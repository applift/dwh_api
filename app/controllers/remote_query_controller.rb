class RemoteQueryController < ApplicationController
  def show
    endpoint = Endpoint
               .joins(:token)
               .find_by(
                 name: endpoint_params[:name],
                 tokens: { code: endpoint_params[:token] }
               )
    return render json: { message: 'not found' }, status: 404 if endpoint.nil?
    render json: { query: endpoint.query }
  end

  private

  def endpoint_params
    params.permit(:name, :token)
  end
end
