class Token < ApplicationRecord
  validates :code, uniqueness: true
  has_secure_token :code
end
