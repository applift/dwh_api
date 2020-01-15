# DWH API
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release) [![CircleCI](https://circleci.com/gh/applift/dwh_api.svg?style=svg)](https://circleci.com/gh/applift/dwh_api) 	![](https://img.shields.io/circleci/build/github/applift/dwh_api?style=plastic) ![](https://img.shields.io/github/v/tag/applift/dwh_api?sort=semver&style=plastic)
![](/public/docs/img/diagram.png) 

DWH API is an application that creates dynamic REST API endpoints with configuration. User only need to connect to a database know how to write SQL and define the end points and permission.
The solution allows Data warehouse managers (BI Managers, DBA, Data Engineers) full control on who access to their database without the need to provide database credentials. This application layer release the dependency in database modifications.

In many cases the solution accelerate X3 time to go to market in data related applications

In this application the user can:
1. Connect to a database
2. Define query and parameters (i.e. dynamic filters, columns)
3. Set credentials by specifying access level and tokens
4. Monitor requests

(Current application support DWH based on postgres)

# Services documentation:
https://medium.com/engineering-applift/controlling-data-warehouse-consumers-via-dwh-api-d5ae2f5c584c

# Table of contents

- [Installation](#installation)
- [Database setup](#database-setup)
- [Populate database](#populate-database)
- [Usage](#usage)
- [Navigation](#Navigation)
- [Parameterized query](#Parameterized-query)

# Installation

Download repository [dwh_api](https://github.com/applift/dwh_api)

## Database setup

All parameters which are set as ENV variables are required, except `RAILS_MAX_THREADS`, by default number of the pool is ```5```

Parameters description

- DATABASE_HOST - Name of host to connect to, ```example '127.0.0.1'```  ```this parameter will be 'postgres' inside docker container``` 
- DATABASE_PORT - Port number to connect to at the server host, ```example '5432'```
- DATABASE_USERNAME - PostgreSQL user name to connect as, ```example 'postgres'```
- DATABASE_PASSWORD - Password to be used if the server demands password authentication, ```example 'postgres'```
- DATABASE_NAME - The database name, ```exaple 'dwh_api_development'```

## Via Docker

Install [Docker](https://docs.docker.com/install/).

Run:

- ```docker-compose up```

- Create user to login into the application (interface):

```
docker-compose run web rails c
User.create(login: 'login', email: 'user@email.com', password: 'password')
```


URL for the app:

- ```http://localhost:3000```

## Regular installation
### Ruby, Rails and dependencies

Install [rvm](https://rvm.io/).

Install ruby:

- ```rvm install ruby-2.6.3```

Install dependencies:

- ```bundle install```

Create file with encrypted environment variables

- ```EDITOR=vim rails credentials:edit```

### Database

Application is using Postgres database.

Create database:

- ```rake db:create```

Run all migrations:

- ```rake db:migrate```

Database config file: (edit the user and password for the postgres repository)

- ```config/database.yml```

## Populate database

- Rails console:

```
rails c
```

- Create user to login into the application (interface):

```
User.create(login: 'login', email: 'user@email.com', password: 'password')
```

## Usage

Start server:

- ```rails s```

URL for the app:

- ```http://localhost:3000```


## Navigation

- **Login Page**: Insert the user and password defined in the db_credential for first login (i.e. 'user', 'password')

 ![](/public/docs/img/login.png)

- **Access Level**: Define access level name, and assign permission to endpoints for this access level

  ![](/public/docs/img/access-level.png)

- **Database credentials**: Define database access credentials

  ![](/public/docs/img/database_credentials.png)
  
  ![](/public/docs/img/db_creds.png)

- **Endpoints**: Define an endpoint based on query. Select the database and create the SQL query 

  ![](/public/docs/img/endpoint.png)

- **Request Logs**: View which activities, such as endpoint calls were done by which token

  ![](/public/docs/img/list-of-request-logs.png)

- **Tokens**: Tokens are a way to authenticate in order to make a endpoint request. Each token has an access level (many token can have the same access level). Based on the access level available endpoint a token have permission to those endpoints. From the token page the user can see the swagger page with all endpoints and parameters available for this token

  ![](/public/docs/img/token.png)

- **Users**: Define admin users who can create and modify endpoint

  ![](/public/docs/img/list-of-users.png)

- **API docs**: Overview of all endpoints which accessible by token (link of access from token page)

  ![](/public/docs/img/swagger-docs.png)

Swagger documentation for available endpoints by token:

```
http://localhost:3000/swagger_docs?token=your_token
```
Where your_token is the token.code


HTTP call:
```
GET http://localhost:3000/api/{your_endpoint}?token={your_token}
```


## Parameterized query



- SQL:
```
SELECT %{first_field} FROM USERS WHERE family_name=%{second_field};
```

- API call:
```
http://localhost:3000/api/qwerty?token=your_token&first_field=email&second_field=name is not null
```

## Getting the schema

- SQL:
```
select * from information_schema.tables where table_schema = 'public'
```

- API call:
```
http://localhost:3000/api/qwerty?token=your_token
```

### Replaceable Fields: Hints for use

The input must be preceded by the percentage symbol and surrounded by curly brackets as such `%{field_name}` where field_name will be the call for the field.

Therefore the simplest query would be `SELECT %{field_name};` and the API would thus be `http://localhost:3000/api/your_endpoint?token=your_token&field_name=your_input`

If your input is a string, you must surround it with single quotes as such: `http://localhost:3000/api/your_endpoint?token=your_token&field_name='your_input'`

You have the option of making your replaceable fields a requirement or not, by using the tick on “Replaced fields required”. This will make all your replaced fields required, or all of them off. If the field is thus not defined in the API, it will return null. It is thus recommended that you use logic in your query to make use of this case. Example below:

```
select id,
  login, 
  email
from users
where login = COALESCE (%{user_name}, login); 
```

Here we have set it up so that when no input is chosen, it will return all values in the database, and when a specific user name (aka login) is chosen, only their information will be returned. The API for both cases would thus look like this:

For only “user”:
```
http://localhost:3000/api/your_endpoint?token=your_token&user_name='user'
```

# Build Process
DWH API is using CI from Circle CI. 

# Versioning 
DWH is using semantec versioning. New version is determined based on commit message format (https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines). 

Here is an example of the release type that will be done based on a commit messages:

|Commit message	|Release type|
|---------------|------------|
|fix(pencil): stop graphite breaking when too much pressure applied	|Patch Release|
|feat(pencil): add 'graphiteWidth' option	|~~Minor~~ Feature Release|
|perf(pencil): remove graphiteWidth option. BREAKING CHANGE: The graphiteWidth option has been removed. The default graphite width of 10mm is always used for performance reasons.|~~Major~~ Breaking Release|