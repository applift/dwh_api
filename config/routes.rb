Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :remote_query, only: [:show], param: :name, path: 'api', defaults: {format: :json}
end
