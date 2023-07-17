# Leilão do Galpão

<br>

<p align="center">
  <a href="#-tecnologias">Tecnologias</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-funcionalidades-principais">Funcionalidades Principais</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#️-arquitetura-do-projeto">Arquitetura do Projeto</a>
</p>

<br>
<br>

## Resumo

Este projeto consiste no desenvolvimento de uma aplicação web utilizando Ruby on Rails, com o objetivo de criar um sistema de leilão para comercializar itens abandonados em galpões. A aplicação terá dois perfis de usuário: administradores, responsáveis pelo cadastro e gestão dos leilões, e visitantes, que poderão criar contas, buscar produtos, ver detalhes e fazer ofertas. O projeto conta com uma lista de tarefas a serem implementadas, com algumas funcionalidades adicionais consideradas bônus.

<br>
<br>

## 🚀 Tecnologias

<table align="center">
  <tbody>
    <tr>
      <td align="center" height="110" width="140">
        <img alt="HTML5 logo" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/html5/html5-original.svg" title="HTML5" width="50" />
        <br>
        <span>HTML</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="CSS3 logo" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/css3/css3-original.svg" title="CSS3" width="50" />
        <br>
        <span>CSS</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="Ruby logo" src="https://raw.githubusercontent.com/devicons/devicon/master/icons/ruby/ruby-original.svg" title="Ruby" width="50" />
        <br>
        <span>Ruby</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="Rails logo" src="https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/rails/rails.png" title="Rails" width="50" />
        <br>
        <span>Rails</span>
      </td>
    </tr>
    <tr>
      <td align="center" height="110" width="140">
        <img alt="Devise logo" src="https://raw.githubusercontent.com/plataformatec/devise/master/devise.png" title="Devise" width="80" />
        <br>
        <span>Devise</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="Rspec logo" src="https://rspec.info/images/logo_ogp.png" title="Rspec" width="50" />
        <br>
        <span>Rspec</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="Capybara logo" src="https://img.stackshare.io/service/2595/capybara.png" title="Capybara" width="50" />
        <br>
        <span>Capybara</span>
      </td>
      <td align="center" height="110" width="140">
        <img alt="SQLite logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/SQLite370.svg/1200px-SQLite370.svg.png" title="SQLite" width="99" />
        <br>
        <span>SQLite</span>
      </td>
    </tr>
  </tbody>
</table>

<br>
<br>

## 📋 Funcionalidades Principais

### Cadastro de usuários

A aplicação possui dois tipos de usuários: regulares e administradores. Os usuários regulares podem se cadastrar utilizando qualquer endereço de e-mail, enquanto os administradores devem se cadastrar com um e-mail do domínio _"leilaodogalpao.com.br"_. Além do e-mail, todos os usuários devem fornecer um CPF único e válido para realizar o cadastro.

### Status dos Lotes

Os lotes possuem diferentes status que determinam suas permissões e ações disponíveis:

- **Pendente**: Este é o status padrão para um lote recém-criado. Enquanto estiver pendente, é possível editá-lo e gerenciá-lo. A opção "Editar" permite alterar as configurações do lote, como a data de início e fim. Na opção "Gerenciar", é possível adicionar ou remover um produto. Também é possível aprovar um lote caso já tenha produtos associados a ele.

- **Aprovado**: Quando um administrador diferente do que cadastrou o lote o aprova, ele passa para o status "Aprovado". Nesse estágio, o lote está aberto para receber lances, desde que esteja dentro do período permitido para tal.

- **Encerrado**: Um lote é encerrado quando sua data final é anterior à data atual. Após o encerramento, o lote pode ter dois status adicionais:

  - **Validado**: Caso existam lances registrados no lote, ele será marcado como "Validado". Isso indica que o lote foi concluído com sucesso e os lances foram aceitos.

  - **Cancelado**: Caso nenhum lance tenha sido registrado no lote, ele será marcado como "Cancelado". Isso indica que o lote foi encerrado sem nenhum lance registrado.

### Lances

Na aplicação, os usuários têm a opção de realizar lances em lotes específicos. No entanto, existem algumas restrições e informações relevantes relacionadas aos lances:

- Um usuário só pode fazer um lance se ele não for inferior ao valor mínimo estabelecido para aquele lote.

- Um usuário não pode fazer um lance se o último lance registrado for dele mesmo. Isso evita que um usuário aumente o valor do seu próprio lance ou que ele de lances duplicados sem querer.

> Imagem da tela de lances:
>
>  <img alt="lances" src="docs/media/lances.png" />

- O usuário pode visualizar todas os lances que deu na tela de lances. Essa tela apresenta duas informações principais:

  - **Todos os lances que o usuário está ganhando**, ou seja, será mostrado todos os lotes que o usuário está vencendo/venceu, independentemente se o lote esteja encerrado ou não.
  - **Todos os lances** dados pelo usuário, incluindo lances em lotes que ele ganhou e lotes em que foi superado por outros lances.

> Imagem da tela de histórico de lances:
>
>  <img alt="histórico de lances" src="docs/media/historico-lances.png" />

<br>
<br>

## 🏗️ Arquitetura do Projeto

Durante o desenvolvimento deste projeto, enfrentei desafios decorrentes de decisões iniciais inadequadas. Como não tinha experiência prévia com bancos de dados, cometi erros na escolha dos modelos, o que resultou em dificuldades ao longo do processo de desenvolvimento para alcançar a funcionalidade desejada. Embora esteja satisfeito com o progresso alcançado até o momento, reconheço que podem haver áreas que precisam ser melhoradas.

Tabelas:

```mermaid
erDiagram
    %% --------------------------------------------------------
    %% Generated by "Rails Mermaid ERD"
    %% https://github.com/koedame/rails-mermaid_erd
    %% Restore Hash: #eyJzZWxlY3RNb2RlbHMiOlsiQmlkIiwiQ2F0ZWdvcnkiLCJGYXZvcml0ZSIsIkxvdCIsIlByb2R1Y3QiLCJVc2VyIiwiQmxvY2tlZENwZiJdLCJpc1ByZXZpZXdSZWxhdGlvbnMiOmZhbHNlLCJpc1Nob3dSZWxhdGlvbkNvbW1lbnQiOmZhbHNlLCJpc1Nob3dLZXkiOnRydWUsImlzU2hvd0NvbW1lbnQiOnRydWUsImlzSGlkZUNvbHVtbnMiOmZhbHNlfQ==
    %% --------------------------------------------------------

    %% table name: bids
    Bid {
        integer id PK ""
        integer user_id FK ""
        integer lot_id FK ""
        integer amount  ""
        datetime created_at  ""
        datetime updated_at  ""
    }

    %% table name: blocked_cpfs
    BlockedCpf {
        integer id PK ""
        string cpf  ""
        datetime created_at  ""
        datetime updated_at  ""
    }

    %% table name: categories
    Category {
        integer id PK ""
        string name  ""
        datetime created_at  ""
        datetime updated_at  ""
    }

    %% table name: favorites
    Favorite {
        integer id PK ""
        integer user_id FK ""
        integer lot_id FK ""
        datetime created_at  ""
        datetime updated_at  ""
    }

    %% table name: lots
    Lot {
        integer id PK ""
        string batch_code  ""
        datetime start_date  ""
        datetime end_date  ""
        integer status  ""
        integer min_value  ""
        integer min_allowed_difference  ""
        datetime created_at  ""
        datetime updated_at  ""
        integer register_by_id FK ""
        integer approved_by_id FK ""
    }

    %% table name: products
    Product {
        integer id PK ""
        string name  ""
        text description  ""
        integer weight  ""
        integer width  ""
        integer height  ""
        integer depth  ""
        string sku  ""
        integer category_id FK ""
        datetime created_at  ""
        datetime updated_at  ""
        integer lot_id FK ""
    }

    %% table name: users
    User {
        integer id PK ""
        string email  ""
        string encrypted_password  ""
        string reset_password_token  ""
        datetime reset_password_sent_at  ""
        datetime remember_created_at  ""
        string cpf  ""
        integer role  ""
        datetime created_at  ""
        datetime updated_at  ""
    }

    Bid }o--|| User : ""
    Bid }o--|| Lot : ""
    Category |o--o{ Product : ""
    Favorite }o--|| User : ""
    Favorite }o--|| Lot : ""
    Lot |o--o{ Product : ""
    Lot }o--|| User : ""
    Lot }o--o| User : ""
```

<br>
<br>

## ☕ Instruções para executar o projeto

1. Clonar o projeto:

```bash
git clone https://github.com/felipel7/ruby-treinadev-stock_auction.git
```

2. Instalar as dependências do projeto:

```bash
# Na pasta raiz, digite o comando:
bundle install
```

3. Configurar o banco de dados:

```bash
rails db:migrate

rails db:seed
```

4. Executar o servidor Rails:

```bash
bin/dev
```

Abra o navegador e digite `http://localhost:3000`

<br>

**Usuários:**

E-mail usuários:

| E-mail                           | Tipo de Usuário | Senha  |
| -------------------------------- | --------------- | ------ |
| `felipe@gmail.com`               | Usuário comum   | 123123 |
| `maria@gmail.com`                | Usuário comum   | 123123 |
| `maria@leilaodogalpao.com.br`    | Administrador   | 123123 |
| `fernando@leilaodogalpao.com.br` | Administrador   | 123123 |

<br>

Feito com carinho ♡ por Felipe Silva :) [Linkedin](https://www.linkedin.com/in/ggfelipesilva/)

[⬆ Voltar ao topo](#Resumo)

<br>
