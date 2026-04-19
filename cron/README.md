# Agendamentos Cron

Trabalhos automatizados que mantêm o Chief of Staff OS rodando em segundo plano.

## Como Configurar

Use o agendador cron integrado do Hermes. Os comandos de exemplo abaixo seguem o padrão da CLI do Hermes no momento da escrita — consulte `hermes cron --help` ou a [documentação do cron do Hermes](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron/) se a sintaxe exata mudou.

Inicie o agendador (ex: `hermes cron start`), depois adicione os trabalhos.

## Agendamentos Recomendados

### 1. Varredura de Caixa de Entrada do EA

A cada 15 minutos, horário comercial, dias úteis.

- **Cron**: `*/15 8-21 * * 1-5`
- **Comando**:
```
hermes cron add "*/15 8-21 * * 1-5" "Execute a habilidade executive-assistant no modo heartbeat. Siga as instruções no workspace/HEARTBEAT.md. Retorne HEARTBEAT_OK se nada for acionável."
```
- **Propósito**: Monitoramento contínuo de caixa de entrada e calendário durante o horário de trabalho.

### 2. Preparo Diário de Tarefas

Todas as noites.

- **Cron**: `3 2 * * *`
- **Comando**:
```
hermes cron add "3 2 * * *" "Execute a habilidade daily-task-prep. Enriqueça a lista de tarefas de amanhã com itens recorrentes, prazos e eventos de calendário."
```
- **Propósito**: Preparar lista de tarefas limpa antes da manhã.

### 3. Verificação de Acompanhamentos

Duas vezes ao dia, dias úteis.

- **Cron**: `47 9,14 * * 1-5`
- **Comando**:
```
hermes cron add "47 9,14 * * 1-5" "Execute a habilidade relationship-manager. Verifique acompanhamentos devidos hoje. Elabore mensagens para quaisquer que estejam atrasados."
```
- **Propósito**: Garantir que nenhum acompanhamento passe despercebido.

### 4. Briefing Matutino

Uma vez ao dia, dias úteis.

- **Cron**: `57 7 * * 1-5`
- **Comando**:
```
hermes cron add "57 7 * * 1-5" "Execute a habilidade chief-of-staff no modo briefing matutino. Resuma as tarefas de hoje, destaques da caixa de entrada, calendário e acompanhamentos devidos."
```
- **Propósito**: Começar o dia com uma visão clara.

> **Nota**: Os minutos são intencionalmente deslocados de :00 e :30 para evitar agrupar múltiplos trabalhos ao mesmo tempo.

## Gerenciando Trabalhos

Comandos comuns de gerenciamento de cron (sintaxe exata pode variar por versão):

- **Listar todos os trabalhos**: `hermes cron list`
- **Pausar um trabalho**: `hermes cron pause <id>`
- **Retomar um trabalho**: `hermes cron resume <id>`
- **Excluir um trabalho**: `hermes cron delete <id>`
- **Acionamento manual**: `hermes cron trigger <id>`

## Personalização

Ajuste os agendamentos para corresponder ao seu fuso horário e horário de trabalho. As expressões cron acima assumem que o relógio do sistema corresponde ao seu fuso horário.
