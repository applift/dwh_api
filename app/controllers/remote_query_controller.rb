class RemoteQueryController < ApplicationController
  def show
    endpoint = Endpoint
               .joins(:token)
               .find_by(
                 name: endpoint_params[:name],
                 tokens: { code: endpoint_params[:token] }
               )

    result = RemoteQueryService.new(endpoint).call
    render json: result[:response], status: result[:status]
  end

  private

  def endpoint_params
    params.permit(:name, :token)
  end
end
