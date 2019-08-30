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
    result = RemoteQueryService.new(endpoint, endpoint_params[:replace_fields]).call

    respond_to do |format|
      format.csv { send_data to_csv(result[:response][:result]),
                        type: 'text/csv',
                        disposition: "filename=#{endpoint_params[:name]}.csv" }
      format.json { render json: result[:response], status: result[:status] }
    end
  end

  private

  def endpoint_params
    params.permit(:name, :token, replace_fields: {})
  end
end
