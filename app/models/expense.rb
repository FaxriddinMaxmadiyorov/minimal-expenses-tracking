class Expense < ApplicationRecord
  belongs_to :category

  validates :amount, numericality: { greater_than: 0}
  validates :category, presence: true
  validates :description, presence: true, length: { minimum: 3 }
end
