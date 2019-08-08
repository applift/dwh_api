module RemoteDatabase
  class Postgres
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
        password: @password
      )
      connection.exec(query)
    end
  end
end