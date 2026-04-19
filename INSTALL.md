# Guia de Instalação

Configuração passo a passo do Chief of Staff OS no Hermes Agent.

---

## Pré-requisitos

- [Hermes Agent](https://hermes-agent.nousresearch.com/) instalado e configurado
- Pelo menos uma conta de e-mail acessível via MCP (Gmail recomendado)
- Acesso ao calendário via MCP (Google Calendar recomendado)

## Passo 1: Clonar o Repositório

```bash
git clone https://github.com/TheCraigHewitt/hermes-chief-of-staff.git
cd hermes-chief-of-staff
```

## Passo 2: Instalar as Habilidades

Copie as habilidades para o diretório de habilidades do Hermes:

```bash
cp -r skills/* ~/.hermes/skills/
```

Verifique se foram detectadas iniciando uma sessão do Hermes e verificando a lista de habilidades. O comando exato pode variar por versão — tente listar suas habilidades disponíveis para confirmar que as cinco habilidades do CoS aparecem.

## Passo 3: Configurar o Arquivo de Contexto

Copie o modelo para a raiz do seu projeto:

```bash
cp templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md
```

Abra-o e preencha cada seção:

- **Sobre Você**: Nome, fuso horário, cargo
- **Comunicação**: Contas de e-mail, contas de calendário, preferência de tom
- **Autoridade**: O que o assistente pode lidar vs. o que precisa da sua aprovação
- **Horas de Trabalho**: Quando as varreduras devem executar, horas de silêncio
- **Ferramentas Disponíveis**: Quais integrações MCP estão conectadas
- **Preferências de Acompanhamento**: Cadência padrão, contatos VIP
- **Contexto de Negócios**: Notas breves para ajudar o assistente a tomar melhores decisões

## Passo 4: Configurar os Arquivos do Workspace

Copie o diretório workspace para seu projeto:

```bash
cp -r workspace/ ~/your-project/workspace/
```

Isso cria:
- `workspace/tasks/current.md` — Seu arquivo de tarefas canônico (edite as entradas de exemplo)
- `workspace/relationships/current.md` — Seu arquivo de acompanhamento de follow-ups (edite os exemplos)
- `workspace/HEARTBEAT.md` — Instruções para varreduras automatizadas
- `workspace/TOOLS.md` — Notas do ambiente de ferramentas locais (preencha conforme necessário)

## Passo 5: Configurar a Personalidade (Opcional)

Copie o modelo SOUL para a personalidade do CoS:

```bash
cp templates/SOUL.example.md ~/.hermes/SOUL.md
```

Copie o modelo USER para seu perfil:

```bash
cp templates/USER.example.md ~/.hermes/memories/USER.md
```

Edite ambos para corresponder às suas preferências.

## Passo 6: Configurar as Integrações MCP

Em `~/.hermes/config.yaml`, configure os servidores MCP para seu e-mail e calendário. Exemplo para Gmail:

```yaml
mcp_servers:
  gmail:
    command: "npx"
    args: ["-y", "@anthropic/mcp-server-gmail"]
  google_calendar:
    command: "npx"
    args: ["-y", "@anthropic/mcp-server-google-calendar"]
```

Recarregue os servidores MCP após as alterações. Em uma sessão de chat do Hermes, use o comando de recarregar (ex: `/reload-mcp`) para pegar a nova configuração.

## Passo 7: Configurar os Agendamentos Cron

Inicie o agendador cron do Hermes (o comando exato pode variar — consulte a documentação do Hermes para sua versão):

```bash
hermes cron start
```

Adicione os agendamentos recomendados (ajuste os horários para seu fuso horário). Exemplo de fluxo de trabalho:

```bash
# Varredura de caixa de entrada do EA — a cada 15 min, horário comercial, dias úteis
hermes cron add "*/15 8-21 * * 1-5" "Execute a habilidade executive-assistant no modo heartbeat. Siga o workspace/HEARTBEAT.md. Retorne HEARTBEAT_OK se nada for acionável."

# Preparo diário de tarefas — 2h da manhã todas as noites
hermes cron add "3 2 * * *" "Execute a habilidade daily-task-prep. Enriqueça a lista de tarefas de amanhã com itens recorrentes, prazos e eventos de calendário."

# Verificação de acompanhamentos — duas vezes ao dia, dias úteis
hermes cron add "47 9,14 * * 1-5" "Execute a habilidade relationship-manager. Verifique acompanhamentos devidos hoje. Elabore mensagens para quaisquer que estejam atrasados."

# Briefing matutino — uma vez ao dia, dias úteis
hermes cron add "57 7 * * 1-5" "Execute a habilidade chief-of-staff no modo briefing matutino. Resuma as tarefas de hoje, destaques da caixa de entrada, calendário e acompanhamentos devidos."
```

> **Nota**: A sintaxe de comando cron acima segue o padrão da CLI do Hermes no momento da escrita. Se a sintaxe exata mudou, consulte `hermes cron --help` ou a [documentação do cron do Hermes](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron/).

Veja [cron/README.md](cron/README.md) para detalhes e opções de personalização.

## Lista de Verificação de Validação

Execute isto após a configuração para confirmar que tudo funciona:

**Instalação**:
- [ ] As habilidades estão instaladas em `~/.hermes/skills/` (um diretório por habilidade, cada um contendo SKILL.md)
- [ ] `CHIEF_OF_STAFF_CONTEXT.md` está preenchido e presente na raiz do seu projeto
- [ ] `workspace/tasks/current.md` existe com as seções necessárias (Hoje, Próximos, Regras, Concluídos)
- [ ] `workspace/relationships/current.md` existe com as seções (Acompanhamentos Ativos, Nutrição, Arquivados)
- [ ] `workspace/HEARTBEAT.md` está presente

**Integrações**:
- [ ] Os servidores MCP estão configurados em `~/.hermes/config.yaml`
- [ ] Teste o acesso ao e-mail: pergunte "verifique minha caixa de entrada" — deve listar mensagens recentes ou confirmar acesso
- [ ] Teste o acesso ao calendário: pergunte "o que tem no meu calendário hoje" — deve listar eventos ou confirmar acesso
-- [ ] Os trabalhos cron estão configurados (verifique com `hermes cron list` ou equivalente)

**Testes funcionais** (execute estes em uma sessão de chat do Hermes):
- [ ] "Adicione uma tarefa: testar a configuração do CoS" — deve atualizar workspace/tasks/current.md
- [ ] "Execute executive-assistant no modo heartbeat" — deve retornar HEARTBEAT_OK ou um resumo de triagem
- [ ] "Briefing matutino" — deve retornar uma visão geral diária estruturada
- [ ] "Com quem preciso fazer acompanhamento?" — deve verificar workspace/relationships/current.md
- [ ] "Marcar como concluído: testar a configuração do CoS" — deve mover a tarefa para Concluídos com um carimbo de data/hora

## Escolhendo o Que Instalar

Você não precisa de tudo. Para a configuração de maior valor mais rápida, veja [docs/recommended-founder-setup.md](docs/recommended-founder-setup.md).

Para todas as opções, veja [docs/maturity-levels.md](docs/maturity-levels.md):

- **Nível 1 (EA Pessoal)**: Passos 2-4 com apenas `executive-assistant` e `daily-task-manager`
- **Nível 2 (Fundador)**: Passos 2-6 completos, todos os trabalhos cron exceto o briefing matutino
- **Nível 3 (CoS Completo)**: Tudo acima

Um arquivo de contexto de demonstração preenchido está disponível em [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](templates/CHIEF_OF_STAFF_CONTEXT.demo.md) para ver como uma configuração completa se parece.

## Solução de Problemas

**Habilidades não aparecendo**: Certifique-se de que os arquivos SKILL.md estejam em `~/.hermes/skills/<nome-da-habilidade>/SKILL.md`. Cada habilidade precisa de seu próprio diretório.

**MCP não conectando**: Recarregue os servidores MCP em uma sessão de chat do Hermes (ex: `/reload-mcp`). Verifique `~/.hermes/logs/` para erros.

**Cron não executando**: Certifique-se de que o agendador cron esteja iniciado (ex: `hermes cron start`). Verifique o status com seu comando de listagem de cron.

**Arquivo de contexto não encontrado**: As habilidades procuram por `CHIEF_OF_STAFF_CONTEXT.md` na raiz do seu projeto (o diretório onde você inicia o Hermes). Certifique-se de que esteja lá.
