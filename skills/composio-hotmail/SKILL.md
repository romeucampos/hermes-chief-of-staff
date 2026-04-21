---
name: hotmail
description: Resumir e-mails do Hotmail/Outlook via Composio CLI, sempre cobrindo a janela consultada com datas explícitas nos itens e um resumo final prático.
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

Use esta skill quando o usuário pedir resumo do Hotmail ou Outlook.

## Regra fixa de saída

Sempre retornar:

1. Conta consultada
2. Intervalo consultado
3. Quantidade total de e-mails encontrados
4. Quantidade de não lidos, se disponível
5. Principais remetentes ou categorias
6. Datas dos e-mails mostradas explicitamente nos destaques
7. Destaques importantes
8. Itens de atenção
9. Resumo final no fim da resposta
10. Se houver sinais de golpe ou phishing, destacar claramente

Evite tabela bruta como formato principal.

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
3. Consultar Outlook inbox com `OUTLOOK_QUERY_EMAILS`:
   - `folder = inbox`
   - usar filtro por `receivedDateTime`
   - pedir campos: `id`, `subject`, `from`, `receivedDateTime`, `bodyPreview`, `isRead`, `importance`, `hasAttachments`, `webLink`
4. Ler o `outputFilePath` retornado pelo Composio
5. Resumir:
   - total de e-mails
   - não lidos
   - anexos
   - top remetentes
   - destaques com data explícita
   - possível phishing
   - paginação, se houver

## Exemplo

```bash
composio execute OUTLOOK_QUERY_EMAILS -d '{
  "user_id":"me",
  "folder":"inbox",
  "top":50,
  "filter":"receivedDateTime ge 2026-04-01T03:00:00Z and receivedDateTime lt 2026-04-03T03:00:00Z",
  "select":["id","subject","from","receivedDateTime","bodyPreview","isRead","importance","hasAttachments","webLink"]
}'
```

## Observações importantes

- Se `@odata.nextLink` existir, avisar que há mais e-mails e oferecer buscar a próxima página
- Se o remetente parecer falso, domínio estranho ou anexo suspeito, marcar como suspeito
- O usuário prefere respostas curtas, práticas e em tópicos
- Sempre incluir datas e intervalo explicitamente

## Falhas comuns

- `himalaya: command not found` → usar Composio CLI
- a conta Outlook pode parecer conectada, mas falhar por vínculo expirado; se isso ocorrer, verificar a conexão Composio
- não esquecer a conversão de fuso ao montar o filtro

## Checklist final

- [ ] Intervalo informado
- [ ] Quantidade total informada
- [ ] Datas mostradas nos destaques
- [ ] Resumo final incluído no fim
- [ ] Suspeitos destacados
- [ ] Paginação mencionada se existir
