# Guia de Migração para Composio

Como migrar um setup legado baseado em MCP para o modelo atual, em que Hermes continua como agente e Composio passa a ser a camada padrão de conexão.

---

## Quem Precisa Migrar

Você precisa deste guia se ainda estiver usando:

- `mcp_servers` em `~/.hermes/config.yaml` para Gmail ou Google Calendar
- instruções como `/reload-mcp` no seu fluxo operacional
- referências a “servidor MCP” para descrever integrações do projeto

Se seu setup já usa Composio para e-mail e calendário, você pode ignorar este documento.

## O Que Muda na Prática

Antes:

- Hermes dependia de servidores MCP configurados no arquivo do usuário
- a linguagem operacional falava em “servidor MCP”
- a reconfiguração passava por recarga manual desses servidores

Agora:

- Hermes continua sendo o agente principal
- Composio é a camada padrão de conexão
- a linguagem operacional passa a usar “integração”, “conta conectada” e “mapeamento de contas”

## O Que Pode Ser Removido do Setup Antigo

Se suas entradas de `mcp_servers` existiam apenas para suportar este repositório, você pode removê-las de `~/.hermes/config.yaml`.

Também deixe de usar:

- `/reload-mcp`
- qualquer documentação local que dependa de “nome do servidor MCP” como referência principal

## Nova Sequência Recomendada

1. Instale o Composio CLI.
2. Faça login com `composio login`.
3. Em uma sessão do Hermes, conecte Gmail e Google Calendar.
4. Atualize `CHIEF_OF_STAFF_CONTEXT.md` com as contas corretas.
5. Atualize `workspace/TOOLS.md` com o estado das conexões, permissões e restrições.
6. Valide leitura de caixa de entrada e calendário.

## Reautenticando Gmail e Google Calendar

Prompts recomendados em uma sessão do Hermes:

- `Autentique com Gmail`
- `Autentique com Google Calendar`

Se a sua sessão local do Composio não estiver autenticada, rode antes:

```bash
composio login
composio whoami
```

## Como Atualizar o Contexto

Depois da reconexão:

- revise **Contas de e-mail adicionais**
- revise **Contas de calendário**
- revise **Ferramentas Disponíveis**
- revise **Mapeamento de Contas**

O objetivo é garantir que o assistente saiba quais contas devem ser lidas, quais podem enviar respostas e quais calendários devem ser verificados antes de agendar.

## Como Validar a Migração

Execute estes testes:

1. `Verifique minha caixa de entrada`
2. `O que tenho no calendário hoje?`
3. `Execute assistente-executivo no modo heartbeat`
4. `Briefing matutino`

Sinais de que a migração deu certo:

- a caixa de entrada retorna mensagens reais
- o calendário retorna eventos reais
- o heartbeat não falha por ausência de integração
- o briefing consegue combinar tarefas, inbox e calendário

## Problemas Comuns

**O Hermes não encontra a integração**  
Refaça a autenticação do aplicativo na própria sessão do Hermes.

**O Composio CLI parece desconectado**  
Confirme com `composio whoami`. Se necessário, rode `composio login` novamente.

**Há conflito entre contexto e conexão real**  
Atualize `CHIEF_OF_STAFF_CONTEXT.md` e `workspace/TOOLS.md` para refletir as contas que realmente ficaram conectadas.

## Resultado Esperado

Ao final da migração:

- Hermes continua no centro da operação
- Composio passa a ser a camada padrão de conexão
- o repositório deixa de depender de MCP como caminho principal
- a documentação operacional fica consistente com o setup real
