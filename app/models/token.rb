class Token < ApplicationRecord
  has_many :endpoints
  validates :name, presence: true, uniqueness: true
  has_secure_token :code
end
