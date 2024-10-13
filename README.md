# Social Network

This is a Ruby on Rails 7 application that implements a basic social network.

## Description 

```
Тестовое: 
Необходимо создать веб-приложение с использование фреймворка Ruby on Rails 7. База данных: PostgreSQL или MariaDB. 
Пользователи могут регистрироваться. Для учёта пользователей использовать библиотеку Devise 4.9.

Пользователи могут создавать текстовые публикации, подписываться друг на друга, читать публикации тех, на кого 
подписаны, в хронологическом порядке в ленте.

Пользователи могут комментировать публикации друг друга. Комментарии представляют собой дерево — каждый комментарий 
относится либо к оригинальной публикации, либо к другому комментарию.

Инструменты: Git, PostgreSQL или MariaDB, Ruby on Rails 7, Devise 4.9.

Важно: отношения в БД между пользователями (подписки), отношения в БД между комментариями и публикациями.

Не важно: внешний вид приложения не имеет значения, вёрсткой можно не заниматься

Это может быть слишком длинное задание. Тогда можно выбрать только одну половину — либо подписки, либо комментарии.
```

## Features

- User registration and authentication using Devise
- Creating and deleting posts
- Commenting on posts with nested comments
- Following other users
- Feed of posts from followed users

## Setup

1. Clone the repository
2. Run `bundle install`
3. Setup the database with `rails db:create db:migrate`
4. Start the server with `rails server`

## Running tests

Run `rspec` to execute the test suite.

## Technologies used

- Ruby on Rails 7
- PostgreSQL
- Devise 4.9
- HAML
- RSpec
