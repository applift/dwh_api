class RemoteQueryController < ApplicationController
  def show
    endpoint = Endpoint
               .active
               .joins(:token)
               .find_by(
                 name: endpoint_params[:name],
                 tokens: { code: endpoint_params[:token] }
               )
    result = RemoteQueryService.new(endpoint, endpoint_params[:replace_fields]).call
    render json: result[:response], status: result[:status]
  end

  private

  def endpoint_params
    params.permit(:name, :token, replace_fields: {})
  end
end
