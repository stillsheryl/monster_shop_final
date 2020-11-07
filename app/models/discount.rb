class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage,
                        :items_needed

  validates :percentage, inclusion: { in: 1..99, message: 'The percentage must be between 1 and 99' }

  validates_numericality_of :items_needed, greater_than: 0
end
