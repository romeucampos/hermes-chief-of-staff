# Design: Integrações Composio-First para Hermes Chief of Staff

## Status

Aprovado para especificação. Aguardando revisão do usuário antes da implementação.

## Contexto

Atualmente, o projeto parte do pressuposto de integrações baseadas em MCP na documentação de setup e operação. Os exemplos mais claros são:

- `INSTALL.md`, que instruía usuários a configurar `mcp_servers` para Gmail e Google Calendar em `~/.hermes/config.yaml`
- `workspace/TOOLS.md`, que pedia aos usuários para registrar nomes de servidores MCP para e-mail, calendário e outras integrações

Isso criava dois problemas:

1. O caminho padrão de setup ficava acoplado a MCP, embora o modelo operacional pretendido seja Hermes como agente principal e Composio como camada de conexão.
2. O repositório não tinha uma política explícita para futuras integrações, então novas docs ou skills poderiam voltar a derivar para orientações específicas de MCP.

A direção solicitada é:

- Hermes continua como agente principal e superfície de orquestração.
- Composio CLI passa a ser o mecanismo padrão de conexão para e-mail, calendário e qualquer integração externa futura.
- Toda nova integração deve usar Composio primeiro.

## Objetivos

- Substituir MCP como caminho padrão de integração por Composio CLI.
- Manter Hermes como camada de execução e orquestração.
- Atualizar docs de setup, templates, skills e linguagem operacional para refletir o novo modelo.
- Definir uma política em nível de repositório para que novas integrações usem Composio primeiro.
- Oferecer um caminho de migração para usuários existentes baseados em MCP.

## Não Objetivos

- Reescrever o Hermes em si.
- Implementar um framework de integração de propósito geral além do que este repositório precisa.
- Suportar todos os apps possíveis do Composio no primeiro dia.
- Preservar MCP como caminho de setup de primeira classe na documentação principal.

## Resumo da Decisão

Adotar um modelo de integração `Composio-first`:

- Hermes continua responsável por skills, prompts e fluxos dirigidos por cron.
- Composio CLI passa a ser o método padrão para autenticar e expor integrações.
- A linguagem do repositório muda de `MCP server` para termos como `integração`, `conexão`, `aplicativo conectado`, `provedor` e `mapeamento de contas`.
- A orientação legada de MCP sai do caminho principal e fica retida apenas em um documento de migração, quando necessário.

## Estado Atual

### Acoplamento explícito a MCP

- `INSTALL.md` incluía uma etapa dedicada chamada `Configurar as Integrações MCP`.
- O troubleshooting de `INSTALL.md` instruía usuários a recarregar servidores MCP e inspecionar logs do Hermes para problemas de MCP.
- `workspace/TOOLS.md` usava `Nome do servidor MCP` como dado-chave para e-mail, calendário e outras ferramentas.

### Acoplamento implícito

A estrutura do repositório sugeria que a maior parte da dependência era operacional e editorial, e não em nível de código. Isso era uma boa notícia: a migração seria principalmente uma atualização de contrato e documentação, não uma reescrita profunda de software.

O principal risco era inconsistência. Se as docs migrassem para Composio, mas skills e templates ainda descrevessem integrações em termos de MCP, os usuários acabariam com instruções conflitantes.

## Modelo Operacional Alvo

### Papéis centrais

- Hermes cuida de orquestração, raciocínio, agendamento e execução de skills.
- Composio CLI cuida da conectividade e autorização com serviços externos.
- Os arquivos do projeto continuam definindo contexto do proprietário, estado de tarefas e regras operacionais.

### Contrato de integração

Todos os serviços externos devem ser descritos usando um contrato neutro em relação ao fornecedor:

- **provedor**: o sistema externo, como Gmail, Google Calendar, Slack, Notion ou Sheets
- **conexão**: o vínculo autenticado gerenciado via Composio CLI
- **mapeamento de contas**: qual identidade, mailbox, calendário ou workspace está ligado à conexão
- **capacidades**: para que a integração é usada neste projeto

Skills e docs devem se referir à presença ou ausência de uma integração conectada, e não à existência de um servidor MCP.

### Política padrão

Para qualquer nova integração externa:

1. Tentar Composio primeiro.
2. Usar outro mecanismo apenas se Composio não for viável.
3. Se houver uma exceção, documentar o motivo explicitamente.

## Mudanças Propostas no Repositório

### 1. Instalação e onboarding

Atualizar `INSTALL.md` para que o caminho principal de setup passe a ser:

1. Instalar Hermes
2. Instalar e autenticar o Composio CLI
3. Conectar e-mail, calendário e outros serviços via Composio
4. Validar o acesso a partir dos fluxos do Hermes

Mudanças necessárias:

- substituir `Configurar as Integrações MCP` por `Configurar Integrações via Composio CLI`
- remover exemplos baseados em `mcp_servers` em `~/.hermes/config.yaml`
- remover instruções para executar `/reload-mcp`
- reescrever o troubleshooting em termos de status de conexão, erros de autenticação e acesso ao provedor via Composio

### 2. Referência de ferramentas do workspace

Atualizar `workspace/TOOLS.md` para registrar o estado das integrações em termos de Composio.

Exemplos:

- substituir `Nome do servidor MCP` por `Integração via Composio`
- manter notas sobre provedor e mapeamento de contas
- adicionar espaço para observações específicas da conexão, como calendários somente leitura ou regras para múltiplas inboxes

### 3. Templates de contexto

Atualizar os templates em `templates/` para que `Ferramentas Disponíveis` e seções relacionadas descrevam integrações como aplicativos conectados via Composio.

Mudanças esperadas:

- contas de e-mail passam a ser mapeadas para conexões baseadas em Composio
- contas de calendário passam a ser mapeadas para conexões baseadas em Composio
- integrações futuras usam o mesmo vocabulário

### 4. Skills e referências

Revisar todos os arquivos `skills/*/SKILL.md` e `references/` de suporte em busca de:

- terminologia específica de MCP
- suposições sobre nomes de servidor
- texto de setup ou troubleshooting que redirecione usuários de volta para MCP

Substituir por:

- instruções para usar integrações conectadas via Composio
- referências a mapeamento de contas em `CHIEF_OF_STAFF_CONTEXT.md`
- orientação operacional neutra em relação ao provedor sempre que possível

### 5. Política de integração em nível de projeto

Adicionar uma declaração curta de política nas docs voltadas ao usuário, provavelmente em `README.md` e `docs/adaptation-guide.md`:

- Hermes é a camada de agente
- Composio é a camada de conexão padrão
- novas integrações devem usar Composio primeiro

Isso reduz o risco de desvio futuro.

### 6. Guia de migração

Adicionar uma doc dedicada de migração para usuários existentes, por exemplo:

- `docs/composio-migration.md`

Ela deve cobrir:

- quem precisa migrar
- o que muda na prática
- o que pode ser removido da configuração do Hermes
- como reconectar e-mail e calendário via Composio CLI
- como validar que heartbeat, checagens de inbox e checagens de calendário continuam funcionando

## Plano de Implementação

Diretriz geral do plano:

- Todo o trabalho de documentação, revisão e migração deve ser feito em pt-BR, com acentuação correta e redação final revisada antes da conclusão.

### Fase 1: Auditoria e alinhamento de terminologia

- Buscar no repositório por `MCP`, `mcp`, `reload-mcp`, `server`, `gmail`, `calendar` e termos relacionados
- Montar uma lista dos arquivos que precisam ser alterados
- Identificar trechos fora de pt-BR ou com acentuação incorreta para correção durante a migração
- Padronizar a terminologia aprovada:
  - `integração`
  - `conexão`
  - `aplicativo conectado`
  - `provedor`
  - `mapeamento de contas`

### Fase 2: Atualizar a documentação principal

- Reescrever `INSTALL.md`
- Atualizar `README.md`
- Atualizar `workspace/TOOLS.md`
- Atualizar `templates/CHIEF_OF_STAFF_CONTEXT.example.md`
- Atualizar `templates/CHIEF_OF_STAFF_CONTEXT.demo.md`

### Fase 3: Atualizar skills e referências

- Revisar toda a documentação de skills
- Substituir instruções específicas de MCP
- Garantir que todas as descrições de fluxo continuem coerentes após a mudança de terminologia

### Fase 4: Adicionar material de migração

- Criar `docs/composio-migration.md`
- Mover para esse documento qualquer orientação legada de MCP que ainda valha a pena preservar

### Fase 5: Validação

Verificar os fluxos documentados de ponta a ponta:

- acesso à inbox
- acesso ao calendário
- fluxo de heartbeat
- fluxo de briefing matutino
- fluxo de onboarding para um novo usuário

## Plano de Execução por Arquivo

### Alta prioridade

- `INSTALL.md`
- `README.md`
- `workspace/TOOLS.md`
- `templates/CHIEF_OF_STAFF_CONTEXT.example.md`
- `templates/CHIEF_OF_STAFF_CONTEXT.demo.md`

### Média prioridade

- `docs/adaptation-guide.md`
- `docs/recommended-founder-setup.md`
- `docs/maturity-levels.md`
- `skills/assistente-executivo/SKILL.md`
- `skills/assistente-executivo/references/calendar-rules.md`

### Prioridade de varredura

- Demais arquivos `skills/*/SKILL.md`
- Demais arquivos `skills/*/references/*`
- Qualquer documentação futura que ainda mencione MCP após a primeira passada

## Riscos

### Inconsistência de terminologia

Se alguns arquivos disserem `MCP` e outros disserem `Composio`, os usuários não saberão qual sistema é o autoritativo.

Mitigação:

- atualizar primeiro as docs de maior tráfego
- rodar uma busca completa no repositório depois das edições

### Suposições ocultas de fluxo

Algumas skills podem assumir implicitamente capacidades ou comportamentos de seleção de conta que não se mapeiam exatamente de MCP para Composio.

Mitigação:

- preservar o mapeamento de contas controlado pelo proprietário em `CHIEF_OF_STAFF_CONTEXT.md`
- manter regras do provedor nas docs de referência, separadas dos detalhes de transporte

### Acoplamento excessivo a um novo fornecedor

Substituir um termo específico de fornecedor por outro em todo lugar pode criar lock-in no futuro.

Mitigação:

- usar terminologia neutra em relação ao fornecedor na lógica das skills e nos templates
- mencionar Composio explicitamente nas docs de setup e migração, onde isso realmente importa

## Testes e Critérios de Aceitação

A migração estará completa quando:

- o caminho principal de instalação não depender mais de MCP
- o caminho principal de instalação usar Composio CLI de forma clara
- templates de workspace e contexto descreverem integrações em termos compatíveis com Composio
- skills não exigirem que usuários pensem em termos de servidores MCP
- existir um guia de migração para usuários legados de MCP
- uma busca no repositório por `MCP` encontrar apenas referências legadas ou intencionalmente delimitadas
- os materiais atualizados estiverem em pt-BR, com acentuação correta e revisão textual consistente

## Questões em Aberto

Estas perguntas não bloqueiam a migração da documentação, mas podem afetar detalhes da implementação:

- Qual é a sequência exata de setup do Composio CLI que o repositório deve recomendar?
- Existem comandos ou wrappers do lado do Hermes necessários para invocar ferramentas conectadas via Composio?
- Algumas integrações deveriam ser descritas como opcionais em vez de básicas?

A implementação deve responder isso com comandos e exemplos concretos antes de finalizar o guia de instalação.

## Recomendação

Implementar isso primeiro como uma migração de documentação e contrato, e depois fazer uma varredura no restante do texto das skills para consistência.

Essa é a ordem correta porque, no estado atual, o repositório parecia estar acoplado a MCP principalmente por instruções e linguagem operacional, não por código profundamente embutido. O caminho mais rápido e seguro é tornar o caminho padrão inequívoco e, depois, limpar a cauda longa.
