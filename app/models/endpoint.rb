class Endpoint < ApplicationRecord
  belongs_to :token
  belongs_to :database_credential

  validates :query, presence: true
  validates :token, presence: true
  validates :is_active, inclusion: { in: [true, false] }
  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }

  rails_admin do
    list do
      field :name
      field :query
      field :is_active
      field :token
      field :database_credential
    end
  end
end
