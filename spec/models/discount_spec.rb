require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :discount_items}
    it {should have_many(:items).through(:discount_items)}
  end

  describe 'Validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :items_needed}
  end
end
