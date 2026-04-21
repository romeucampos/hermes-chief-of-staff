# Configuração Recomendada para Fundadores

O caminho mais rápido para um Chief of Staff funcional. Esta configuração entrega triagem de caixa de entrada, gestão de tarefas, follow-ups e preparo diário, sem exigir a camada completa do orquestrador logo no início.

---

## Instale Estas 4 Habilidades

```bash
cp -r skills/assistente-executivo ~/.hermes/skills/
cp -r skills/gerenciador-tarefas-diario ~/.hermes/skills/
cp -r skills/preparo-tarefas-diario ~/.hermes/skills/
cp -r skills/gerenciador-relacionamentos ~/.hermes/skills/
```

Deixe `chefe-de-gabinete` para depois, se quiser começar mais leve.

## Conecte as Integrações Essenciais via Composio

Antes de configurar os jobs de cron:

1. instale o Composio CLI
2. faça `composio login`
3. conecte Gmail e Google Calendar em uma sessão do Hermes
4. valide leitura de caixa de entrada e calendário

Sem essas conexões, o ganho operacional fica incompleto.

## Preencha Estes Campos de Contexto Primeiro

Copie o modelo:

```bash
cp templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md
```

Os campos mais importantes para começar:

- **Nome** e **fuso horário**
- **E-mail principal**
- **Contas de calendário**
- **Regras de autoridade**
- **Canal de escalada**
- **Mapeamento de contas**

Veja [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](../templates/CHIEF_OF_STAFF_CONTEXT.demo.md) para um exemplo completo.

## Copie os Arquivos do Workspace

```bash
cp -r workspace/ ~/your-project/workspace/
```

Edite as entradas de exemplo em:

- `workspace/tasks/current.md`
- `workspace/relationships/current.md`
- `workspace/TOOLS.md`

## Crie Estes 3 Jobs de Cron

```bash
# Varredura de caixa de entrada do EA — a cada 15 min, horário comercial, dias úteis
hermes cron add "*/15 8-21 * * 1-5" "Execute a habilidade assistente-executivo no modo heartbeat. Siga o workspace/HEARTBEAT.md. Retorne HEARTBEAT_OK se nada for acionável."

# Preparo diário de tarefas — 2h da manhã
hermes cron add "3 2 * * *" "Execute a habilidade preparo-tarefas-diario. Enriqueça a lista de tarefas de amanhã com itens recorrentes, prazos e eventos de calendário."

# Verificação de acompanhamentos — duas vezes ao dia, dias úteis
hermes cron add "47 9,14 * * 1-5" "Execute a habilidade gerenciador-relacionamentos. Verifique acompanhamentos devidos hoje. Elabore mensagens para quaisquer que estejam atrasados."
```

## O Que Você Recebe

- Caixa de entrada triada ao longo do dia
- Lista de tarefas enriquecida automaticamente
- Follow-ups acompanhados em cadência
- Menos risco de perder conversas ou compromissos
- Silêncio operacional quando nada precisa de atenção

## Quando Adicionar o Orquestrador

Adicione `chefe-de-gabinete` quando você quiser:

- briefing matutino consolidado
- revisão de fim de dia
- coordenação ad hoc entre tarefas, inbox e follow-ups

```bash
cp -r skills/chefe-de-gabinete ~/.hermes/skills/

# Briefing matutino — uma vez ao dia, dias úteis
hermes cron add "57 7 * * 1-5" "Execute a habilidade chefe-de-gabinete no modo briefing matutino."
```
