# Configuração Recomendada para Fundadores

O caminho mais rápido para um Chief of Staff funcional. Isso te dá triagem de caixa de entrada, gerenciamento de tarefas, acompanhamento de follow-ups e preparo diário de tarefas — sem a camada completa do orquestrador.

---

## Instale Estas 4 Habilidades

```bash
cp -r skills/executive-assistant ~/.hermes/skills/
cp -r skills/daily-task-manager ~/.hermes/skills/
cp -r skills/daily-task-prep ~/.hermes/skills/
cp -r skills/relationship-manager ~/.hermes/skills/
```

Pule `chief-of-staff` por enquanto — ele adiciona briefings matutinos e revisões EOD, que você pode adicionar depois se quiser.

## Preencha Estes Campos de Contexto Primeiro

Copie o modelo:

```bash
cp templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md
```

Os campos que mais importam para começar:

- **Nome** e **fuso horário**
- **E-mail principal** (a caixa de entrada que o assistente irá triar)
- **Contas de calendário** (todos os calendários a verificar antes de agendar)
- **Regras de autoridade** (o que o assistente pode lidar vs. o que precisa da sua aprovação)
- **Canal de escalada** (onde itens urgentes vão — DM do Telegram, Slack, etc.)

Todo o resto pode ser preenchido depois. Veja [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](../templates/CHIEF_OF_STAFF_CONTEXT.demo.md) para um exemplo preenchido.

## Copie os Arquivos do Workspace

```bash
cp -r workspace/ ~/your-project/workspace/
```

Edite as entradas de exemplo em:
- `workspace/tasks/current.md` — substitua por suas tarefas reais
- `workspace/relationships/current.md` — substitua por seus acompanhamentos reais

## Crie Estes 3 Trabalhos Cron

```bash
# Varredura de caixa de entrada do EA — a cada 15 min, horário comercial, dias úteis
hermes cron add "*/15 8-21 * * 1-5" "Execute a habilidade executive-assistant no modo heartbeat. Siga o workspace/HEARTBEAT.md. Retorne HEARTBEAT_OK se nada for acionável."

# Preparo diário de tarefas — 2h da manhã todas as noites
hermes cron add "3 2 * * *" "Execute a habilidade daily-task-prep. Enriqueça a lista de tarefas de amanhã com itens recorrentes, prazos e eventos de calendário."

# Verificação de acompanhamentos — duas vezes ao dia, dias úteis
hermes cron add "47 9,14 * * 1-5" "Execute a habilidade relationship-manager. Verifique acompanhamentos devidos hoje. Elabore mensagens para quaisquer que estejam atrasados."
```

## O Que Você Recebe

- Caixa de entrada triada a cada 15 minutos com decisões baseadas em autoridade
- Lista de tarefas automaticamente preparada cada manhã
- Acompanhamentos rastreados com uma cadência de 2/5/7 dias
- Nenhuma conversa passa despercebida
- Silêncio `HEARTBEAT_OK` quando nada precisa de atenção

## Quando Adicionar o Orquestrador

Adicione a habilidade `chief-of-staff` quando quiser:
- Um briefing matutino que resume tarefas, calendário, caixa de entrada e acompanhamentos em uma visão
- Uma revisão de fim de dia que captura o que foi feito e o que segue em frente
- Triagem ad-hoc "no que devo focar agora?"

```bash
cp -r skills/chief-of-staff ~/.hermes/skills/

# Cron de briefing matutino — uma vez ao dia, dias úteis
hermes cron add "57 7 * * 1-5" "Execute a habilidade chief-of-staff no modo briefing matutino."
```
