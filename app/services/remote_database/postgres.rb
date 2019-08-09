module RemoteDatabase
  class Postgres
    DEFAULT_TIMEOUT = 5

    def initialize(host, port, database_name, user, password)
      @host = host
      @port = port
      @database_name = database_name
      @user = user
      @password = password
    end

    def run_query(query)
      connection = PG::Connection.new(
        host: @host,
        port: @port,
        dbname: @database_name,
        user: @user,
        password: @password,
        connect_timeout: DEFAULT_TIMEOUT
      )
      connection.exec(query)
    end
  end
end
