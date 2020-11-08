class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :discount_items
  has_many :items, through: :discount_items

  validates_presence_of :percentage,
                        :items_needed

  validates :percentage, inclusion: { in: 1..99, message: 'The percentage must be between 1 and 99' }

  validates_numericality_of :items_needed, greater_than: 0
end
