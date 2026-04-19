# Referência de Formato de Arquivo de Tarefas

Este documento define a estrutura e regras de formatação para o arquivo de tarefas canônico em `workspace/tasks/current.md`.

## Seções Obrigatórias vs Opcionais

**Obrigatórias** (devem estar sempre presentes):
- Hoje
- Próximos
- Regras
- Concluído

**Opcionais** (adicione conforme necessário):
- Recorrentes (dias úteis)
- Backlog (com data de vencimento)
- Lembretes recorrentes
- Backlog

## Seções

### ## Hoje

Tarefas abertas e concluídas para hoje. Este é o conjunto de trabalho ativo.

Sintaxe:

```
- [ ] Descrição da tarefa
- [x] Descrição da tarefa
```

`- [ ]` marca uma tarefa pendente. `- [x]` marca uma tarefa concluída (antes de ser movida para Concluído). Itens mais altos na lista são de maior prioridade.

### ## Próximos

Trabalho na fila para depois que as tarefas de hoje forem feitas. Estes estão prontos para ir mas não são vinculados ao tempo de hoje. Quando a lista de hoje esvaziar, puxe daqui.

### ## Regras

Instruções permanentes para gerenciamento de tarefas. Estas não são tarefas — são políticas que governam como o arquivo de tarefas é mantido. Exemplos: "Sempre verifique o calendário antes de planejar o dia," "Avise o Craig se uma tarefa estiver bloqueada por mais de 24 horas."

### ## Recorrentes (dias úteis)

Itens de base que se repetem toda segunda a sexta. A habilidade daily-task-prep copia estes para a seção Hoje a cada manhã de dia útil. As entradas aqui são modelos — elas permanecem nesta seção permanentemente.

### ## Backlog (com data de vencimento)

Tarefas futuras com prazos específicos. Cada entrada inclui uma data de vencimento.

Sintaxe:

```
- [ ] Descrição da tarefa — vencimento AAAA-MM-DD
```

A habilidade daily-task-prep promove itens para Hoje em suas datas de vencimento (veja Regras de Promoção).

### ## Lembretes recorrentes

Lembretes estacionados com metadados de recorrência. Ao contrário das tarefas recorrentes de dias úteis, estes disparam em intervalos específicos — semanal, mensal, trimestral, etc. A entrada de origem permanece nesta seção mesmo depois de disparar. Apenas uma cópia move para Hoje quando o lembrete é acionado.

Sintaxe:

```
- [ ] Descrição da tarefa — a cada [intervalo], próximo AAAA-MM-DD
```

### ## Backlog

Itens sem data. Sem urgência, sem prazo. Revise periodicamente para decidir se os itens devem ser promovidos, receber uma data de vencimento ou ser removidos.

### ## Concluído

Itens concluídos com carimbos de data/hora. Este é o trilho de auditoria.

Sintaxe:

```
- [x] Descrição da tarefa — concluído AAAA-MM-DD HH:MM TZ
```

Nunca exclua itens do Concluído. Nunca mova itens para fora do Concluído.

## Regras de Formatação

### Datas

- Datas de dia inteiro: `AAAA-MM-DD`
- Horários específicos: `AAAA-MM-DD HH:MM TZ` (ex: `2026-04-02 09:00 CT`)

### Propriedade

Tarefas delegadas usam um prefixo de nome de assistente seguido por dois-pontos.

Sintaxe:

```
- [ ] NomeDoAssistente: Descrição da tarefa — vencimento AAAA-MM-DD
```

Exemplo: `- [ ] Hermes: Elaborar o relatório trimestral — vencimento 2026-04-15`

### Prioridade

Dentro de qualquer seção, itens mais altos na lista são de maior prioridade. Reordene os itens para mudar a prioridade.

### Deduplicação

Antes de adicionar uma tarefa, verifique duplicatas usando comparação de texto normalizada (insensível a maiúsculas, ignore espaços no início/fim). Se uma tarefa substancialmente similar já existir, atualize-a em vez de criar uma duplicata.

## Regras de Promoção

**Backlog (com data de vencimento) para Hoje**: Na data de vencimento, a habilidade daily-task-prep move o item de Backlog (com data de vencimento) para Hoje. O item é removido do Backlog.

**Recorrentes (dias úteis) para Hoje**: A cada manhã de dia útil, a habilidade daily-task-prep copia itens de Recorrentes (dias úteis) para Hoje. A entrada de origem permanece em Recorrentes permanentemente — ela nunca é removida.

**Lembretes recorrentes para Hoje**: Quando um lembrete recorrente é acionado, a habilidade daily-task-prep copia-o para Hoje. A entrada de origem permanece em Lembretes recorrentes, e sua data "próximo" é avançada para a próxima ocorrência.
