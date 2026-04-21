 ---
name: gmail-composio-summary
description: Resumir Gmail via Composio CLI sem depender de OAuth local do Google Workspace ou do himalaya. Útil quando a conta Gmail já está conectada no Composio e o usuário quer um resumo rápido por janela de tempo.
version: 1.0.0
author: Hermes
license: MIT
metadata:
  hermes:
    tags: [Gmail, Email, Composio, Resumo]
    homepage: https://docs.composio.dev
---

# Gmail summary via Composio CLI

Use esta skill quando o usuário pedir um resumo do Gmail e:
- a conta Gmail estiver conectada no Composio CLI, e/ou
- a skill `google-workspace` exigir setup local de OAuth, e/ou
- `himalaya` não estiver instalado.

## Quando priorizar esta abordagem

Priorize Composio CLI para Gmail quando o objetivo for apenas leitura/resumo da caixa.
Antes de tentar `google-workspace`, verifique se a setup local está pendente. Antes de tentar `himalaya`, verifique se o binário existe.

## Fluxo recomendado

1. Carregar skills relacionadas, se necessário:
   - `google-workspace` para checar se há setup pendente
   - `himalaya` para ver se seria alternativa viável

2. Verificar disponibilidade prática:
   - `himalaya --version`
   - `composio dev connected-accounts list --toolkits gmail --limit 10`
   - Se Gmail estiver `ACTIVE`, seguir com Composio.

3. Inspecionar schema da ferramenta:
   - `composio execute GMAIL_FETCH_EMAILS --get-schema`
   - Observação importante: `after:` e `before:` usam dias de calendário em UTC, e `before:` é exclusivo.

4. Para janela “ontem até hoje” em horário local do Brasil, usar uma margem simples por data no query do Gmail:
   - Ex.: `in:inbox after:2026/04/01 before:2026/04/04`
   - Depois filtrar programaticamente por timezone local (`-03:00`) para evitar erro de borda.

5. Executar busca:

```bash
composio execute GMAIL_FETCH_EMAILS -d '{
  "user_id":"me",
  "query":"in:inbox after:2026/04/01 before:2026/04/04",
  "max_results":100,
  "verbose":false,
  "include_payload":false,
  "include_spam_trash":false
}'
```

6. Ler o `outputFilePath` retornado.

7. Resumir programaticamente:
   - converter `messageTimestamp` para timezone local
   - filtrar a janela exata local desejada
   - contar total, não lidos, anexos
   - agrupar remetentes
   - classificar por labels: `CATEGORY_PROMOTIONS`, `CATEGORY_SOCIAL`, `CATEGORY_UPDATES`, `CATEGORY_FORUMS`, `CATEGORY_PERSONAL`
   - montar destaques com data explícita
   - sinalizar `nextPageToken` se existir

## Campos úteis da resposta do Composio

Cada mensagem pode trazer:
- `messageId`
- `threadId`
- `messageTimestamp`
- `sender`
- `subject`
- `preview.body`
- `labelIds`
- `attachmentList`

## Formato de saída recomendado

Sempre retornar em tópicos curtos:
1. Intervalo consultado
2. Quantidade total de emails encontrados
3. Quantidade de não lidos
4. Quantidade com anexo
5. Principais remetentes
6. Categorias principais
7. Destaques com datas explícitas
8. Itens de atenção
9. Indicação de próxima página, se houver
10. Resumo final

## Heurísticas úteis

- `UNREAD` em `labelIds` → não lido
- `attachmentList` vazio → sem anexo
- `CATEGORY_PROMOTIONS` → promoções
- `CATEGORY_SOCIAL` → social
- `CATEGORY_UPDATES` → updates
- `CATEGORY_PERSONAL` → pessoal
- `CATEGORY_FORUMS` → fóruns

## Limitações e aprendizados práticos

- `google-workspace` pode estar indisponível por falta de `google_token.json` e `google_client_secret.json`; para leitura rápida, Composio pode ser a rota mais curta.
- `himalaya` pode simplesmente não existir no ambiente (`command not found`).
- `GMAIL_FETCH_EMAILS` pode retornar `nextPageToken`; avise que há mais resultados.
- O filtro por datas do Gmail não é suficiente sozinho para janelas locais exatas; faça pós-filtragem por timezone local.
- `verbose=false` e `include_payload=false` são bons defaults para resumo rápido e leve.

## Checklist final

- [ ] Intervalo informado explicitamente
- [ ] Datas explícitas nos destaques
- [ ] Total e não lidos informados
- [ ] Categorias/resumo prático incluídos
- [ ] Próxima página mencionada se existir
- [ ] Sem afirmar phishing sem indício claro
