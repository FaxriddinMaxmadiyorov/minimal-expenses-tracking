class Expense < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0}
  validates :category_id, presence: true
  validates :description, presence: true, length: { minimum: 3 }

  has_one_attached :avatar
  has_many_attached :images
end
