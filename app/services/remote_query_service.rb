class RemoteQueryService
  def initialize(endpoint)
    @endpoint = endpoint
  end

  def call
    return format_result(404, message: 'endpoint not found') if @endpoint.nil?

    response = RemoteDatabase::Postgres.new(
      *arguments_for_remote_database
    ).run_query(@endpoint.query)
    format_result(200, result: response)
  end

  private

  def arguments_for_remote_database
    [
      @endpoint.database_credential.host,
      @endpoint.database_credential.port,
      @endpoint.database_credential.database,
      @endpoint.database_credential.user,
      @endpoint.database_credential.password
  ]
  end

  def format_result(status, response)
    { status: status, response: response }
  end
end