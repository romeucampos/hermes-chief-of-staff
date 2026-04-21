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
3. Montar a janela padrão:
   - início = ontem às 00:00 no horário local convertido para UTC
   - fim = amanhã às 00:00 no horário local convertido para UTC, ou fim do dia atual
4. Para janela local, montar um query simples e depois refinar pela data local, se necessário
5. Executar a busca
6. Ler o `outputFilePath` retornado
7. Resumir:
   - total de e-mails
   - não lidos
   - anexos
   - top remetentes
   - destaques com data explícita
   - possível phishing
   - paginação, se houver

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
6. Principais remetentes ou categorias, com a quantidade de e-mails em cada item
7. Categorias principais
8. Destaques com datas explícitas
9. Itens de atenção
10. Indicação de próxima página, se houver
11. Resumo final

Evite tabela bruta como formato principal.

## Exemplo de saída

Use este formato como referência. Os valores são ilustrativos, mas a estrutura da resposta deve seguir este padrão.

```text
Resumo do Gmail (20/04 até 21/04):

- Conta confirmada: romeu.campos@bitpreco.com
- Emails encontrados: 34
- Não lidos: 11
- Com anexo: 0
- Próxima página: não há (nextPageToken vazio)

Principais remetentes/categorias
- Financeiro / relatórios operacionais — 12 emails
- Segurança de conta — 4 emails
- Infraestrutura / faturamento — 2 emails
- Mobilidade / despesas — 3 emails
- Parceiros / comunicados — 2 emails
- Newsletters / promoções — 11 emails

Destaques
- 20/04 10:09 — cobranca@provedorexemplo.com — Fatura de infraestrutura disponível
- 20/04 10:13 — alertas@segurancaexemplo.com — Novo acesso detectado em dispositivo Windows
- 20/04 12:15 — financeiro@empresaexemplo.com — Transferência recebida na conta operacional
- 20/04 15:28 — operacoes@empresaexemplo.com — Nova liquidação disponível para conferência
- 20/04 17:45 — parceiros@plataformaexemplo.com — Atualização semanal de indicadores
- 20/04 21:33 — comunicacao@fornecedorexemplo.com — Novas funcionalidades liberadas para o time
- 21/04 07:10 — relatorios@empresaexemplo.com — Resumo diário de receitas e saídas
- 21/04 11:03 — cobranca@provedorexemplo.com — Confirmação de pagamento processado
- 21/04 12:10 — financeiro@empresaexemplo.com — Relatório consolidado de saldos

Observações
- A caixa está bem concentrada em operacional e financeiro da BitPreço, com vários relatórios automáticos do Data Studio.
- Há um alerta de segurança do Google em 20/04 às 12:15 — vale conferir se o login foi seu.

Resumo final
Sua caixa do Gmail está majoritariamente operacional e financeira, com vários relatórios automáticos, liquidações, transferências e faturamento. O único item que merece atenção extra é o alerta de segurança do Google.

Se quiser, eu posso fazer agora um resumo só dos emails importantes e não lidos ou um recorte por remetente.
```

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
