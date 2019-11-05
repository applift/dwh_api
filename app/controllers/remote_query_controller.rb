class RemoteQueryController < ApplicationController
  include ApplicationHelper

  swagger_controller :remote_query, 'Available endpoints'

  def show
    endpoint = Endpoint.active
                 .joins(:tokens)
                 .find_by(
                   name: endpoint_params[:name],
                   tokens: { code: endpoint_params[:token] }
                 )
    result = RemoteQueryService.new(endpoint, params.except(:name, :token)).call

    respond_to do |format|
      format.csv { send_data to_csv(result[:response][:result]),
                        type: 'text/csv',
                        disposition: "filename=#{endpoint_params[:name]}.csv" }
      format.json { render json: result[:response], status: result[:status] }
    end
  end

  private

  def endpoint_params
    params.permit(:name, :token)
  end
end
