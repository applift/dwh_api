# DWH API

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


# Table of contents

- [Installation](#installation)
- [Populate database](#populate-database)
- [Usage](#usage)
- [Navigation](#Navigation)
- [Parameterized query](#Parameterized-query)

## Installation
### Ruby, Rails and dependencies

Download repository [dwh_api](https://github.com/applift/dwh_api)

Install [rvm](https://rvm.io/).

Install ruby:

- ```rvm install ruby-2.6.3```

Install dependencies:

- ```bundle install```

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
db_credential = DatabaseCredential.create(user: 'user', password: 'password', database: 'postgres', host: 'localhost', port: '5432')
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


## Parameterized query



- SQL:
```
SELECT %{first_field} FROM USERS WHERE family_name=%{second_field};
```

- API call:
```
http://localhost:3000/api/qwerty?token=your_token&first_field=email&second_field=name is not null
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

For all:
```
http://localhost:3000/api/your_endpoint?token=your_token
```

For only “user”:
```
http://localhost:3000/api/your_endpoint?token=your_token&user_name='user'
```

