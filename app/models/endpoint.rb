class Endpoint < ApplicationRecord
  belongs_to :token
  belongs_to :database_credential
  validates :query, presence: true
  validates :token, presence: true
  validates :is_active, presence: true
end
