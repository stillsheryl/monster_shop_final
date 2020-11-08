require 'rails_helper'

RSpec.describe DiscountItem do
  describe 'Relationships' do
    it {should belong_to :item}
    it {should belong_to :discount}
  end
end
