# Guia de Instalação

Configuração passo a passo do Chief of Staff OS no Hermes Agent.

---

## Pré-requisitos

- [Hermes Agent](https://hermes-agent.nousresearch.com/) instalado e configurado
- Pelo menos uma conta de e-mail que será conectada via Composio (Gmail recomendado)
- Acesso ao calendário que será conectado via Composio (Google Calendar recomendado)
- Um terminal com `bash` disponível para a instalação do Composio CLI

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

Verifique se foram detectadas iniciando uma sessão do Hermes e conferindo a lista de habilidades. O comando exato pode variar por versão, então use o comando equivalente da sua instalação para confirmar que as cinco habilidades do CoS aparecem.

## Passo 3: Configurar o Arquivo de Contexto

Copie o modelo para a raiz do seu projeto:

```bash
cp templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md
```

Abra o arquivo e preencha cada seção:

- **Sobre Você**: nome, fuso horário, cargo
- **Comunicação**: contas de e-mail, contas de calendário, preferência de tom
- **Autoridade**: o que o assistente pode resolver sozinho e o que exige sua aprovação
- **Horas de Trabalho**: quando as varreduras devem executar e quais são as horas de silêncio
- **Ferramentas Disponíveis**: quais integrações estão conectadas via Composio
- **Preferências de Acompanhamento**: cadência padrão, contatos VIP
- **Contexto de Negócios**: notas curtas para ajudar o assistente a tomar melhores decisões

## Passo 4: Configurar os Arquivos do Workspace

Copie o diretório `workspace` para seu projeto:

```bash
cp -r workspace/ ~/your-project/workspace/
```

Isso cria:

- `workspace/tasks/current.md` — seu arquivo canônico de tarefas
- `workspace/relationships/current.md` — seu arquivo de acompanhamento de follow-ups
- `workspace/HEARTBEAT.md` — instruções para varreduras automatizadas
- `workspace/TOOLS.md` — notas sobre integrações, contas e ambiente local

## Passo 5: Configurar Personalidade e Perfil (Opcional)

Copie o modelo SOUL para a personalidade do CoS:

```bash
cp templates/SOUL.example.md ~/.hermes/SOUL.md
```

Copie o modelo USER para seu perfil:

```bash
cp templates/USER.example.md ~/.hermes/memories/USER.md
```

Edite ambos para corresponder às suas preferências.

## Passo 6: Instalar e Autenticar o Composio CLI

Instale o Composio CLI:

```bash
curl -fsSL https://composio.dev/install | bash
```

Autentique sua sessão:

```bash
composio login
```

Se estiver em um ambiente remoto ou sem navegador local, use:

```bash
composio login --no-browser
```

Confirme que a autenticação ficou ativa:

```bash
composio whoami
```

## Passo 7: Conectar E-mail e Calendário via Composio

Com o Composio CLI autenticado, abra uma sessão do Hermes e conecte os aplicativos necessários pela própria interface do agente.

Prompts recomendados:

- `Autentique com Gmail`
- `Autentique com Google Calendar`

Se você usar outras integrações no projeto, conecte-as pelo mesmo fluxo, sempre priorizando Composio como camada padrão.

Depois da autenticação:

- registre no `CHIEF_OF_STAFF_CONTEXT.md` quais contas devem ser usadas
- registre em `workspace/TOOLS.md` o provedor, o mapeamento de contas e quaisquer restrições da conexão

## Passo 8: Validar o Acesso às Integrações

Ainda em uma sessão do Hermes, valide os acessos principais:

- `Verifique minha caixa de entrada`
- `O que tenho no calendário hoje?`

Os resultados devem mostrar mensagens e eventos reais, ou pelo menos confirmar que a conexão está ativa e acessível.

## Passo 9: Configurar os Agendamentos Cron

Inicie o agendador cron do Hermes:

```bash
hermes cron start
```

Adicione os agendamentos recomendados. Ajuste os horários para seu fuso horário:

```bash
# Varredura de caixa de entrada do EA — a cada 15 min, horário comercial, dias úteis
hermes cron add "*/15 8-21 * * 1-5" "Execute a habilidade assistente-executivo no modo heartbeat. Siga o workspace/HEARTBEAT.md. Retorne HEARTBEAT_OK se nada for acionável."

# Preparo diário de tarefas — 2h da manhã todas as noites
hermes cron add "3 2 * * *" "Execute a habilidade preparo-tarefas-diario. Enriqueça a lista de tarefas de amanhã com itens recorrentes, prazos e eventos de calendário."

# Verificação de acompanhamentos — duas vezes ao dia, dias úteis
hermes cron add "47 9,14 * * 1-5" "Execute a habilidade gerenciador-relacionamentos. Verifique acompanhamentos devidos hoje. Elabore mensagens para quaisquer que estejam atrasados."

# Briefing matutino — uma vez ao dia, dias úteis
hermes cron add "57 7 * * 1-5" "Execute a habilidade chefe-de-gabinete no modo briefing matutino. Resuma as tarefas de hoje, destaques da caixa de entrada, calendário e acompanhamentos devidos."
```

> **Nota**: A sintaxe acima segue o padrão do Hermes no momento desta documentação. Se sua versão usar outra interface, consulte `hermes cron --help` ou a [documentação do cron do Hermes](https://hermes-agent.nousresearch.com/docs/user-guide/features/cron/).

Veja também [cron/README.md](cron/README.md) para detalhes adicionais.

## Lista de Verificação de Validação

Execute esta lista após a configuração:

**Instalação**

- [ ] As habilidades estão instaladas em `~/.hermes/skills/`
- [ ] `CHIEF_OF_STAFF_CONTEXT.md` está preenchido e presente na raiz do projeto
- [ ] `workspace/tasks/current.md` existe com as seções necessárias
- [ ] `workspace/relationships/current.md` existe com as seções necessárias
- [ ] `workspace/HEARTBEAT.md` está presente
- [ ] `workspace/TOOLS.md` foi preenchido com o estado das integrações

**Integrações**

- [ ] `composio whoami` confirma uma sessão autenticada
- [ ] Gmail está conectado via Composio
- [ ] Google Calendar está conectado via Composio
- [ ] O Hermes consegue ler a caixa de entrada
- [ ] O Hermes consegue ler o calendário

**Cron**

- [ ] Os trabalhos cron estão configurados
- [ ] Os horários refletem seu fuso horário real

**Testes funcionais**

- [ ] `Adicione uma tarefa: testar a configuração do CoS`
- [ ] `Execute assistente-executivo no modo heartbeat`
- [ ] `Briefing matutino`
- [ ] `Com quem preciso fazer acompanhamento?`
- [ ] `Marcar como concluído: testar a configuração do CoS`

## Escolhendo o Que Instalar

Você não precisa usar tudo de uma vez. Para o caminho de maior valor com menor esforço, veja [docs/recommended-founder-setup.md](docs/recommended-founder-setup.md).

Para todas as opções de adoção, veja [docs/maturity-levels.md](docs/maturity-levels.md):

- **Nível 1 (EA Pessoal)**: passos 2 a 8 com apenas `assistente-executivo` e `gerenciador-tarefas-diario`
- **Nível 2 (Fundador)**: passos 2 a 9 com `gerenciador-relacionamentos` e `preparo-tarefas-diario`
- **Nível 3 (CoS Completo)**: tudo acima, incluindo `chefe-de-gabinete`

Um arquivo de contexto preenchido para demonstração está disponível em [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](templates/CHIEF_OF_STAFF_CONTEXT.demo.md).

## Solução de Problemas

**As habilidades não aparecem**: confira se cada habilidade está em `~/.hermes/skills/<nome-da-habilidade>/SKILL.md`.

**O Composio CLI não autentica**: rode `composio whoami`. Se não houver sessão ativa, execute `composio login` novamente.

**O Hermes não consegue acessar Gmail ou Google Calendar**: refaça a autenticação na sessão do Hermes com `Autentique com Gmail` ou `Autentique com Google Calendar`, depois teste novamente.

**O cron não executa**: confirme se o agendador foi iniciado com `hermes cron start` e confira os jobs com o comando equivalente da sua instalação.

**O arquivo de contexto não é encontrado**: as habilidades procuram `CHIEF_OF_STAFF_CONTEXT.md` na raiz do projeto em que o Hermes foi iniciado.
