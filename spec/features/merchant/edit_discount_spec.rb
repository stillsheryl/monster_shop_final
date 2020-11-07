require 'rails_helper'

RSpec.describe 'Update Discount Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount = @merchant_1.discounts.create(percentage: 5, items_needed: 5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can edit discounts from the dashboard page' do
      visit '/merchant'

      within("#discount-#{@discount.id}") do
        expect(page).to have_content("5% discount on 5 or more items purchased")
        click_link("Edit Discount")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")

      fill_in "Percentage", with: 10
      fill_in "Items needed", with: 10

      click_button "Update Discount"

      expect(current_path).to eq('/merchant')

      @discount.reload

      visit '/merchant'
      expect(page).to have_content("10% discount on 10 or more items purchased")
    end

    it "prefills fields with existing data" do
      visit '/merchant'

      within("#discount-#{@discount.id}") do
        expect(page).to have_content("5% discount on 5 or more items purchased")
        click_link("Edit Discount")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")

      expect(find_field('Percentage').value).to eq "5"
      expect(find_field('Items needed').value).to eq "5"
    end

    it "gives an error if missing information" do
      visit '/merchant'

      click_link("Edit Discount")

      fill_in "Percentage", with: 10
      fill_in "Items needed", with: 0

      click_button "Update Discount"

      expect(page).to have_content("Items needed must be greater than 0")
    end

    it "gives an success message if information entered correctly and is updated" do
      visit '/merchant'

      click_link("Edit Discount")

      fill_in "Percentage", with: 10
      fill_in "Items needed", with: 10

      click_button "Update Discount"

      expect(page).to have_content("Discount Updated.")
    end
  end
end
