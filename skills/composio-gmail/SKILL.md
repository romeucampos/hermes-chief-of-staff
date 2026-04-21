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

- a conta Gmail estiver conectada no Composio CLI
- a skill `google-workspace` exigir setup local de OAuth
- `himalaya` não estiver instalado

## Quando priorizar esta abordagem

Priorize Composio CLI para Gmail quando o objetivo for apenas leitura e resumo da caixa.

## Fluxo recomendado

1. Verificar disponibilidade prática:
   - `himalaya --version`
   - `composio dev connected-accounts list --toolkits gmail --limit 10`
   - se Gmail estiver `ACTIVE`, seguir com Composio
2. Inspecionar schema da ferramenta:
   - `composio execute GMAIL_FETCH_EMAILS --get-schema`
3. Para janela local, montar um query simples e depois refinar pela data local, se necessário
4. Executar a busca
5. Ler o `outputFilePath` retornado
6. Resumir com datas explícitas e indicação de paginação, se houver

## Exemplo

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

## Campos úteis

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

1. Conta consultada
2. Intervalo consultado
3. Quantidade total de e-mails encontrados
4. Quantidade de não lidos
5. Quantidade com anexo, se fizer sentido
6. Principais remetentes
7. Categorias principais
8. Destaques com datas explícitas
9. Itens de atenção
10. Indicação de próxima página, se houver
11. Resumo final

Evite tabela bruta como formato principal.

## Heurísticas úteis

- `UNREAD` em `labelIds` → não lido
- `attachmentList` vazio → sem anexo
- `CATEGORY_PROMOTIONS` → promoções
- `CATEGORY_SOCIAL` → social
- `CATEGORY_UPDATES` → updates
- `CATEGORY_PERSONAL` → pessoal
- `CATEGORY_FORUMS` → fóruns

## Limitações e aprendizados práticos

- `google-workspace` pode estar indisponível por falta de setup local; para leitura rápida, Composio pode ser a rota mais curta
- `himalaya` pode não existir no ambiente
- `GMAIL_FETCH_EMAILS` pode retornar `nextPageToken`; avise que há mais resultados
- o filtro por datas do Gmail pode não bastar sozinho para janelas locais exatas; ajuste pela timezone local quando necessário
- `verbose=false` e `include_payload=false` são bons defaults para resumo rápido e leve

## Checklist final

- [ ] Intervalo informado explicitamente
- [ ] Datas explícitas nos destaques
- [ ] Total e não lidos informados
- [ ] Categorias e resumo prático incluídos
- [ ] Próxima página mencionada se existir
- [ ] Sem afirmar phishing sem indício claro
