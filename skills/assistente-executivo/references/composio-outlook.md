# Outlook / Hotmail via Composio

Use esta referência quando a caixa consultada for Outlook, Hotmail ou conta Microsoft equivalente.

## Abordagem recomendada

- trate Hotmail como Outlook/Microsoft na documentação e na operação
- priorize Composio quando a conexão estiver ativa
- use campos como remetente, assunto, `receivedDateTime`, leitura, importância, anexos e prévia para montar o resumo

## O que observar

- `receivedDateTime` costuma ser o campo central para janela de tempo
- pode haver paginação ou continuação de resultados
- a conexão pode aparentar existir, mas estar expirada ou falhando na prática
- remetentes com nome de exibição suspeito, domínio estranho ou anexo incomum merecem destaque de segurança

## Boas práticas

- sempre mostrar data e hora explícitas nos destaques
- mencionar se houver mais páginas de resultado
- validar o fuso horário ao interpretar a janela consultada
- manter a resposta curta, prática e em tópicos
