#!/usr/bin/env bash
set -euo pipefail

ACCOUNT_LABEL="${1:-me}"
MAX_RESULTS="${MAX_RESULTS:-100}"
TZ_NAME="${TZ:-America/Sao_Paulo}"
LOOKBACK_DAYS="${LOOKBACK_DAYS:-7}"

if ! command -v composio >/dev/null 2>&1; then
  echo "composio command not found" >&2
  exit 1
fi

if ! command -v python >/dev/null 2>&1; then
  echo "python command not found" >&2
  exit 1
fi

readarray -t WINDOW_VALUES < <(
  TZ_NAME="$TZ_NAME" python - <<'PY'
from datetime import datetime, timedelta, time
from zoneinfo import ZoneInfo
import os

tz = ZoneInfo(os.environ.get("TZ_NAME", "America/Sao_Paulo"))
now = datetime.now(tz)
today = now.date()
lookback_days = max(1, int(os.environ.get("LOOKBACK_DAYS", "7")))
window_start_day = today - timedelta(days=lookback_days)
tomorrow = today + timedelta(days=1)

start_local = datetime.combine(window_start_day, time.min, tz)
end_local = datetime.combine(tomorrow, time.min, tz)

print(start_local.isoformat())
print(end_local.isoformat())
print(start_local.astimezone(ZoneInfo("UTC")).isoformat().replace("+00:00", "Z"))
print(end_local.astimezone(ZoneInfo("UTC")).isoformat().replace("+00:00", "Z"))
print(f"{window_start_day.year:04d}/{window_start_day.month:02d}/{window_start_day.day:02d}")
print(f"{tomorrow.year:04d}/{tomorrow.month:02d}/{tomorrow.day:02d}")
PY
)

START_LOCAL="${WINDOW_VALUES[0]}"
END_LOCAL="${WINDOW_VALUES[1]}"
START_UTC="${WINDOW_VALUES[2]}"
END_UTC="${WINDOW_VALUES[3]}"
QUERY_AFTER="${WINDOW_VALUES[4]}"
QUERY_BEFORE="${WINDOW_VALUES[5]}"

QUERY="in:inbox after:${QUERY_AFTER} before:${QUERY_BEFORE}"
PAYLOAD=$(cat <<EOF
{
  "user_id":"me",
  "query":"${QUERY}",
  "max_results":${MAX_RESULTS},
  "verbose":false,
  "include_payload":false,
  "include_spam_trash":false
}
EOF
)

COMPOSIO_STDOUT="$(composio execute GMAIL_FETCH_EMAILS -d "$PAYLOAD")"

SUMMARY_SOURCE="$(
  COMPOSIO_STDOUT="$COMPOSIO_STDOUT" python - <<'PY'
import json
import os
import re
import sys

raw = os.environ["COMPOSIO_STDOUT"]
path = None
inline_data = None

try:
    data = json.loads(raw)
    if isinstance(data, dict):
        path = data.get("outputFilePath")
        if not path and isinstance(data.get("data"), dict):
            path = data["data"].get("outputFilePath")
            if isinstance(data["data"].get("messages"), list):
                inline_data = data["data"]
except Exception:
    pass

if not path:
    match = re.search(r'"outputFilePath"\s*:\s*"([^"]+)"', raw)
    if match:
        path = match.group(1)

if path:
    print(json.dumps({"type": "file", "value": path}, ensure_ascii=False))
    sys.exit(0)

if inline_data is not None:
    print(json.dumps({"type": "inline", "value": inline_data}, ensure_ascii=False))
    sys.exit(0)

sys.exit("Could not find outputFilePath or inline messages in composio output")
PY
)"

SUMMARY_JSON="$(
  ACCOUNT_LABEL="$ACCOUNT_LABEL" \
  LOOKBACK_DAYS="$LOOKBACK_DAYS" \
  START_LOCAL="$START_LOCAL" \
  END_LOCAL="$END_LOCAL" \
  START_UTC="$START_UTC" \
  END_UTC="$END_UTC" \
  TZ_NAME="$TZ_NAME" \
  SUMMARY_SOURCE="$SUMMARY_SOURCE" \
  python - <<'PY'
import json
import os
from collections import Counter
from datetime import datetime, timedelta
from email.utils import parsedate_to_datetime
from zoneinfo import ZoneInfo


def load_json(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def load_payload(summary_source):
    source = json.loads(summary_source)
    source_type = source.get("type")
    if source_type == "file":
        return load_json(source["value"])
    if source_type == "inline":
        return source["value"]
    raise ValueError(f"Unsupported summary source type: {source_type}")


def parse_timestamp(value, tz):
    if value is None:
        return None
    if isinstance(value, (int, float)):
        dt = datetime.fromtimestamp(value / 1000, ZoneInfo("UTC"))
        return dt.astimezone(tz)
    text = str(value).strip()
    if not text:
        return None
    try:
        if text.endswith("Z"):
            text = text[:-1] + "+00:00"
        return datetime.fromisoformat(text).astimezone(tz)
    except Exception:
        pass
    try:
        return parsedate_to_datetime(text).astimezone(tz)
    except Exception:
        return None


def sender_text(msg):
    sender = msg.get("sender")
    if isinstance(sender, dict):
        return sender.get("email") or sender.get("name") or json.dumps(sender, ensure_ascii=False)
    return str(sender or "")


def labels(msg):
    value = msg.get("labelIds") or msg.get("labels") or []
    if isinstance(value, str):
        return [value]
    return [str(v) for v in value]


def attachment_count(msg):
    value = msg.get("attachmentList") or msg.get("attachments") or []
    if isinstance(value, list):
        return len(value)
    return 0


def body_preview(msg):
    preview = msg.get("preview")
    if isinstance(preview, dict):
        return str(preview.get("body") or "")
    return str(msg.get("bodyPreview") or "")


def is_unread(msg):
    lbls = set(labels(msg))
    if "UNREAD" in lbls:
        return True
    raw = msg.get("isRead")
    if isinstance(raw, bool):
        return not raw
    return False


def category_for(msg):
    sender = sender_text(msg).lower()
    subject = str(msg.get("subject") or "").lower()
    preview = body_preview(msg).lower()
    lbls = set(labels(msg))
    merged = " ".join([sender, subject, preview])

    if any(x in merged for x in ["security", "seguranca", "alerta", "login", "password", "senha", "2fa", "verification", "verificacao"]):
        return "Seguranca de conta"
    if any(x in merged for x in ["invoice", "fatura", "billing", "cobranca", "cloudflare", "aws", "gcp", "azure"]):
        return "Infraestrutura / faturamento"
    if any(x in merged for x in ["financeiro", "receita", "saldo", "cashback", "transferencia", "liquidacao", "relatorio"]):
        return "Financeiro / relatorios operacionais"
    if any(x in merged for x in ["uber", "99", "taxi", "mobility", "mobilidade", "despesa"]):
        return "Mobilidade / despesas"
    if any(x in merged for x in ["newsletter", "promoc", "oferta"]) or "CATEGORY_PROMOTIONS" in lbls:
        return "Newsletters / promocoes"
    if any(x in merged for x in ["partner", "parceiro", "comunicado", "update", "atualizacao", "status"]):
        return "Parceiros / comunicados"
    return "Outros"


def possible_phishing(msg):
    sender = sender_text(msg).lower()
    subject = str(msg.get("subject") or "").lower()
    preview = body_preview(msg).lower()
    merged = " ".join([sender, subject, preview])
    keywords = ["verify your account", "verifique sua conta", "reset password", "redefinir senha", "urgent action", "acao urgente", "click here", "clique aqui"]
    return any(k in merged for k in keywords)


def message_list(data):
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        for key in ["messages", "items", "data", "results"]:
            value = data.get(key)
            if isinstance(value, list):
                return value
            if isinstance(value, dict):
                for nested_key in ["messages", "items", "results"]:
                    nested = value.get(nested_key)
                    if isinstance(nested, list):
                        return nested
    return []


tz = ZoneInfo(os.environ["TZ_NAME"])
start_local = datetime.fromisoformat(os.environ["START_LOCAL"])
end_local = datetime.fromisoformat(os.environ["END_LOCAL"])
account_label = os.environ["ACCOUNT_LABEL"]

payload = load_payload(os.environ["SUMMARY_SOURCE"])
messages = message_list(payload)
next_page_token = ""
if isinstance(payload, dict):
    next_page_token = payload.get("nextPageToken") or payload.get("@odata.nextLink") or ""
    if not next_page_token and isinstance(payload.get("data"), dict):
        nested = payload["data"]
        next_page_token = nested.get("nextPageToken") or nested.get("@odata.nextLink") or ""

filtered = []
for msg in messages:
    ts = parse_timestamp(msg.get("messageTimestamp") or msg.get("receivedDateTime") or msg.get("internalDate"), tz)
    if ts is None:
        continue
    if start_local <= ts < end_local:
        filtered.append((ts, msg))

filtered.sort(key=lambda item: item[0])

total = len(filtered)
unread = sum(1 for _, msg in filtered if is_unread(msg))
with_attachments = sum(1 for _, msg in filtered if attachment_count(msg) > 0)
category_counts = Counter(category_for(msg) for _, msg in filtered)

highlights = []
phishing = []
for ts, msg in filtered:
    item = {
        "datetime": ts.strftime("%d/%m %H:%M"),
        "from": sender_text(msg) or "(remetente desconhecido)",
        "subject": str(msg.get("subject") or "(sem assunto)"),
    }
    if possible_phishing(msg):
        phishing.append(item)
    if len(highlights) < 9:
        highlights.append(item)

summary = {
    "account": account_label,
    "lookback_days": int(os.environ["LOOKBACK_DAYS"]),
    "date_range": {
        "start_local": start_local.strftime("%d/%m %H:%M"),
        "end_local": end_local.strftime("%d/%m %H:%M"),
        "start_utc": os.environ["START_UTC"],
        "end_utc": os.environ["END_UTC"],
    },
    "query_window_label": f"{start_local.strftime('%d/%m')} ate {(end_local - timedelta(days=1)).strftime('%d/%m')}",
    "total": total,
    "unread": unread,
    "with_attachments": with_attachments,
    "top_categories": [{"name": name, "count": count} for name, count in category_counts.most_common(6)],
    "highlights": highlights,
    "possible_phishing": phishing[:5],
    "has_next_page": bool(next_page_token),
    "next_page_token": next_page_token if next_page_token else "",
}

if total == 0:
    summary["note"] = "Nenhum email encontrado na janela consultada. Ajuste LOOKBACK_DAYS ou MAX_RESULTS se quiser ampliar a busca."

print(json.dumps(summary, ensure_ascii=False, indent=2))
PY
)"
printf '%s\n' "$SUMMARY_JSON"
