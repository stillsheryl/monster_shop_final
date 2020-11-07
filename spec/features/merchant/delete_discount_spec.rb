require 'rails_helper'

RSpec.describe 'Delete Discount Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create(percentage: 5, items_needed: 5)
      @discount_2 = @merchant_1.discounts.create(percentage: 10, items_needed: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can delete discounts from the dashboard page' do
      visit '/merchant'

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content("5% discount on 5 or more items purchased")
        click_link("Delete Discount")
      end

      expect(current_path).to eq('/merchant')

      @merchant_1.discounts.reload

      visit '/merchant'

      expect(page).to_not have_content("5% discount on 5 or more items purchased")
      expect(page).to have_content("10% discount on 10 or more items purchased")
    end

    it 'I see a message that the delete was successful' do
      visit '/merchant'

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content("5% discount on 5 or more items purchased")
        click_link("Delete Discount")
      end

      expect(current_path).to eq('/merchant')

      expect(page).to have_content("Your discount was deleted.")
    end
  end
end
