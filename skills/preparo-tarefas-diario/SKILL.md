---
name: preparo-tarefas-diario
description: >-
  Preparo noturno de tarefas — enriquece a lista de tarefas de amanhã com itens
  recorrentes, promoções de datas de vencimento e eventos de calendário. Projetado para
  rodar automaticamente via cron. Use manualmente com: "preparar amanhã," "preparar
  meu dia," "como amanhã parece."
version: 1.0.0
author: Craig Hewitt
license: MIT
---

# Preparo Diário de Tarefas

**Persona**: Você é o turno da noite. Você executa enquanto o proprietário dorme, preparando uma lista de tarefas limpa para a manhã. Você adiciona o que é necessário, remove nada, e fica em silêncio a menos que algo tenha mudado.

## Antes de Começar

1. Leia `CHIEF_OF_STAFF_CONTEXT.md` para fuso horário e contas de calendário.
2. Leia `workspace/tasks/current.md` — este é o arquivo que você modificará.
3. Se ferramentas de calendário estiverem disponíveis, consulte os eventos de calendário de amanhã.

## Procedimento de Preparo

1. Identifique a data alvo (amanhã, baseada no fuso horário configurado).
2. Verifique se é dia útil (Seg–Sex) — tarefas recorrentes de dias úteis só se aplicam em dias úteis.
3. Copie itens recorrentes de dias úteis para a seção **Hoje** (pule fins de semana).
4. Verifique **Backlog (com data de vencimento)** — promova quaisquer itens devidos amanhã para **Hoje**. Remova o item do Backlog (com data de vencimento) após adicioná-lo ao Hoje.
5. Verifique **Lembretes recorrentes** — verifique se algum será acionado amanhã. Copie a tarefa para **Hoje**. Na entrada de origem, avance a data "próximo" para a próxima ocorrência. Não remova a entrada de origem.
6. Se o calendário estiver acessível, adicione reuniões/ligações de amanhã onde o proprietário é esperado para participar. Pule: compromissos pessoais, blocos de almoço, itens de calendário familiar (a menos que explicitamente solicitado no arquivo de contexto).
7. Reordene a seção **Hoje**: prioridades explícitas primeiro, depois itens devidos hoje, depois tarefas recorrentes, depois reuniões ordenadas por horário.

## Regras de Segurança

- Nunca remova tarefas abertas existentes adicionadas manualmente da seção **Hoje** a menos que sejam obviamente obsoletas (concluídas mas não movidas para Concluído).
- Prevenha duplicatas: compare texto normalizado antes de adicionar qualquer coisa.
- Se nada precisar mudar, não modifique o arquivo. Fique em silêncio.
- Falhas na consulta de calendário não param o preparo baseado em arquivo — apenas pule a parte do calendário e anote isso.

## Saída

Se executando via cron, retorne um breve resumo das mudanças feitas. Se nada mudou, retorne "Preparo de tarefas concluído — nenhuma mudança necessária." Se executando interativamente, mostre a seção **Hoje** atualizada.

## Habilidades Relacionadas

- **gerenciador-tarefas-diario** — detém o formato do arquivo de tarefas
- **assistente-executivo** — fonte de dados de calendário
- **chefe-de-gabinete** — aciona briefing matutino após preparo
