# Aplicação Web de Notas Colaborativas

Uma aplicação web moderna para criação e gerenciamento de notas colaborativas com suporte a múltiplos formatos de conteúdo, controle granular de permissões e atualização em tempo real.

## 📋 Descrição

> [!WARNING]
> Esse projeto ainda está em desenvolvimento e grande parte das funcionalidades ainda não foram implementadas

Esta aplicação permite que usuários criem e organizem informações em páginas estruturadas, colaborem em tempo real com outros usuários e gerenciem permissões de forma granular. O projeto oferece:

- **Sistema de Autenticação**: Registro e login seguro de usuários
- **Pages Pessoais e em Grupo**: Organize notas em páginas individuais ou colaborativas
- **Blocos de Conteúdo Flexíveis**: Escreva em Markdown, HTML ou LaTeX
- **Controle Granular de Permissões**: Defina visibilidade por bloco (oculto, read-only, editável)
- **Grupos Colaborativos**: Crie grupos com múltiplos admins e membros
- **Atualização em Tempo Real**: Sincronização instantânea via WebSockets

## 🛠️ Tecnologias Utilizadas

### Banco de Dados
- **[PostgreSQL](https://www.postgresql.org/)** - Banco de dados relacional

### Backend
- **[SBCL](http://www.sbcl.org/)** - Steel Bank Common Lisp
- **[Caveman2](https://github.com/fukamachi/caveman)** - Framework web minimalista
- **[Mito](https://github.com/fukamachi/mito)** - ORM para Common Lisp
- **[websocket-driver](https://github.com/fukamachi/websocket-driver)** - Implementação de WebSocket
- **[Djula](https://github.com/mmontone/djula)** - Template engine
- **[3bmd](https://github.com/3b/3bmd)** - Parser e compilador de Markdown



### Estilização
- **[SCSS](https://sass-lang.com)** - Pré-processador CSS para estilização

## 📦 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **SBCL** (Steel Bank Common Lisp) versão 2.0.0 ou superior
- **Quicklisp** - Gerenciador de bibliotecas para Common Lisp
- **PostgreSQL** versão 12 ou superior
- **Git**

### Instalação do SBCL

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install sbcl
```

#### macOS
```bash
brew install sbcl
```

#### Windows
Baixe o instalador em [sbcl.org](http://www.sbcl.org/platform-table.html)

### Instalação do Quicklisp

```bash
curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp
```

No REPL do SBCL:
```lisp
(quicklisp-quickstart:install)
(ql:add-to-init-file)
```

### Instalação do PostgreSQL

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install postgresql postgresql-contrib
```

#### macOS
```bash
brew install postgresql
brew services start postgresql
```

#### Windows
Baixe o instalador em [postgresql.org](https://www.postgresql.org/download/windows/)

## 🚀 Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/MurilloFonseca/incita-notes.git
cd incita-notes
```

Certifique-se que o repositório está dentro da pasta `~/quicklisp/local-projects` ou em um diretório especificado em `~/quicklisp/quicklisp/local-projects.lisp`


2. **Configure o banco de dados:**

No console do PostgreSQL:
```sql
CREATE DATABASE nome_do_banco;
\q
```

1. **Configure as variáveis de ambiente:**

Crie um arquivo `.env` na raiz do projeto:
```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:
```env
# Database 
DB_NAME=nome_do_banco
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=sua_senha-segura
#
# Server
APP_HOST=localhost
APP_PORT=5000
APP_SERVER=hunchentoot # ou woo
APP_ENV=development # ou production
```

4. **Instale as dependências:**

Inicie o SBCL e carregue o sistema:
```bash
sbcl
```

No REPL:
```lisp
(ql:quickload :incita-notes)
```

## 🎯 Utilização

### Executar a aplicação

```bash
sbcl --eval "(ql:quickload :incita-notes)" --eval "(incita-notes:start)"
```

Ou no REPL:
```lisp
(ql:quickload :incita-notes)
(incita-notes:start)
```

A aplicação estará disponível em `http://localhost:5000`

### Parar a aplicação

No REPL:
```lisp
(incita-notes:stop)
```

## 📝 Funcionalidades Principais

### Autenticação
- Registro de novos usuários
- Login/Logout
- Sessões seguras

### Pages (Páginas)
- Criar páginas pessoais ou de grupo
- Organizar conteúdo em blocos
- Editar título

### Blocos
- Suporte a Markdown, HTML e LaTeX
- Renderização em tempo real

### Grupos
- Criar e gerenciar grupos
- Adicionar/remover membros
- Múltiplos administradores
- Controle granular de permissões

### Permissões
- Definir visibilidade por bloco e por página
- Três níveis: oculto, read-only, editável

### Tempo Real
- Sincronização instantânea via WebSockets

## 👥 Autores

- Murillo Fonseca - [@MurilloFonseca](https://github.com/MurilloFonseca)
