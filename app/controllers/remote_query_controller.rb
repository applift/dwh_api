class RemoteQueryController < ApplicationController
  include ApplicationHelper

  def show
    endpoint = Endpoint
               .active
               .joins(:token)
               .find_by(
                 name: endpoint_params[:name],
                 tokens: { code: endpoint_params[:token] }
               )
    result = RemoteQueryService.new(endpoint).call

    if endpoint_params['format'] == 'csv'
      send_data to_csv(result[:response][:result]),
                type: 'text/csv',
                disposition: "filename=#{endpoint_params[:name]}.csv"
    else
      render json: result[:response], status: result[:status]
    end
  end

  private

  def endpoint_params
    params.permit(:name, :token, :format)
  end
end
