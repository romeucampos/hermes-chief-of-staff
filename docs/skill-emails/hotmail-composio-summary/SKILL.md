---
name: hotmail
description: Resumir emails do Hotmail/Outlook via Composio CLI, sempre cobrindo do dia anterior até o dia atual, mostrando quantidade, datas explícitas nos itens e um resumo final. Sempre incluir as datas dos emails nos destaques/itens, não só o intervalo geral.
version: 1.0.1
author: Hermes
license: MIT
metadata:
  hermes:
    tags: [Email, Outlook, Hotmail, Composio, Resumo]
    homepage: https://github.com/ComposioHQ/composio
prerequisites:
  commands: [composio]
---

# Hotmail / Outlook summary via Composio CLI

Use esta skill quando o usuário pedir resumo do Hotmail/Outlook.

## Regra fixa de saída

Sempre retornar:
1. Intervalo consultado: do dia anterior até o dia atual
2. Quantidade total de emails encontrados
3. Quantidade de não lidos, se disponível
4. Principais remetentes/categorias
5. Datas dos emails mostradas explicitamente nos destaques/itens
6. Destaques importantes
7. Resumo final no fim da resposta
8. Se houver sinais de golpe/phishing, destacar claramente

## Fonte preferida

Priorizar Composio CLI com Outlook.
Não usar Himalaya se o comando não existir.

## Passo a passo

1. Verificar horário local e UTC:
   - `date -Is`
   - `date -u -Is`

2. Montar a janela padrão:
   - início = ontem às 00:00 no horário local convertido para UTC
   - fim = amanhã às 00:00 no horário local convertido para UTC, ou fim do dia atual
   - Na prática, para Brasil (-03:00), usar cuidado com conversão para `Z`

3. Consultar Outlook inbox com `OUTLOOK_QUERY_EMAILS`:
   - folder = `inbox`
   - usar filtro por `receivedDateTime`
   - pedir campos: `id`, `subject`, `from`, `receivedDateTime`, `bodyPreview`, `isRead`, `importance`, `hasAttachments`, `webLink`

Exemplo:

```bash
composio execute OUTLOOK_QUERY_EMAILS -d '{
  "user_id":"me",
  "folder":"inbox",
  "top":50,
  "filter":"receivedDateTime ge 2026-04-01T03:00:00Z and receivedDateTime lt 2026-04-03T03:00:00Z",
  "select":["id","subject","from","receivedDateTime","bodyPreview","isRead","importance","hasAttachments","webLink"]
}'
```

4. Ler o `outputFilePath` retornado pelo Composio.

5. Resumir:
   - total de emails
   - não lidos
   - anexos
   - top remetentes
   - separar mentalmente: GitHub, financeiro, newsletters, possível phishing
   - mencionar se existe `@odata.nextLink`

6. Formato recomendado da resposta:
   - Intervalo: DD/MM até DD/MM
   - Emails encontrados: N
   - Não lidos: N
   - Destaques:
     - DD/MM HH:MM — Remetente — Assunto
   - Atenção:
     - DD/MM HH:MM — Remetente — Assunto
   - Resumo final:

## Observações importantes

- Se `@odata.nextLink` existir, avisar que há mais emails e oferecer buscar a próxima página.
- Se o remetente parecer falso (display name imitando Microsoft, domínio estranho, anexo suspeito), marcar como suspeito.
- O usuário prefere respostas curtas, práticas e em tópicos.
- Sempre incluir datas/intervalo explicitamente.

## Falhas comuns

- `himalaya: command not found` → usar Composio CLI.
- Conta Outlook pode aparecer conectada, mas falhar por vínculo expirado; se isso ocorrer, verificar conexão Composio.
- Não esquecer a conversão de fuso ao montar o filtro.

## Checklist final

- [ ] Intervalo do dia anterior até hoje informado
- [ ] Quantidade total informada
- [ ] Datas dos emails mostradas nos destaques
- [ ] Resumo final incluído no fim
- [ ] Suspeitos destacados
- [ ] Paginação mencionada se existir
