require 'rails_helper'

RSpec.describe 'Add Discount to Items' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @donut = @megan.items.create!(name: 'Donut', description: "I'm a circle!", price: 5, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 24 )
      @jelly = @megan.items.create!(name: 'Jelly', description: "I go on toast!", price: 7, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @toast = @megan.items.create!(name: 'Toast', description: "I like jelly!", price: 3, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @discount_1 = @megan.discounts.create(percentage: 5, items_needed: 5)
      @discount_1 = @megan.discounts.create(percentage: 10, items_needed: 10)
      @lucy = User.create!(name: 'Lucy Ball', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'lucy@ball.com', password: 'password', role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@lucy)
    end

    describe 'I can add items to my cart' do
      it "When I reach a threshold of a discount it is automatically applied to my cart, and it only affects items from that merchant that reach the threshold quantity for the discount" do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@giant)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@ogre.id}" do
          3.times do click_button('More of This!')
          end
        end

        expect(page).to have_content("Subtotal: $80.00")

        within "#item-#{@ogre.id}" do
          click_button('More of This!')
        end

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Subtotal: $95.00")
        end

        within "#item-#{@hippo.id}" do
          expect(page).to have_content("Subtotal: $50.00")
        end

        within "#item-#{@giant.id}" do
          expect(page).to have_content("Subtotal: $50.00")
        end
      end

      it "When there is a conflict between two discounts, the greater of the two will be applied." do
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@ogre.id}" do
          4.times do click_button('More of This!')
          end
        end

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Subtotal: $95.00")
        end

        within "#item-#{@ogre.id}" do
          5.times do click_button('More of This!')
          end
        end

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("Subtotal: $180.00")
        end
      end

      it "A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount." do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@giant)
        click_button 'Add to Cart'
        visit item_path(@donut)
        click_button 'Add to Cart'
        visit item_path(@jelly)
        click_button 'Add to Cart'
        visit item_path(@toast)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@ogre.id}" do
          4.times do click_button('More of This!')
          end
        end

        within "#item-#{@giant.id}" do
          expect(page).to have_content("Subtotal: $50.00")
        end

        within "#item-#{@donut.id}" do
          expect(page).to have_content("Subtotal: $5.00")
        end

        within "#item-#{@jelly.id}" do
          expect(page).to have_content("Subtotal: $7.00")
        end

        within "#item-#{@toast.id}" do
          expect(page).to have_content("Subtotal: $3.00")
        end
      end

      it "shows price before discount striked out so visitor can see difference in discount price" do
        visit item_path(@ogre)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@ogre.id}" do
          4.times do click_button('More of This!')
          end
        end

        within "#item-#{@ogre.id}" do
          expect(page).to have_content("New Discounted Price: $19.00")
          within  ".fullprice" do
            expect(page).to have_content("Price: $20.00")
          end
        end
      end
    end
  end
end
