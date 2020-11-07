class Merchant::DiscountsController < Merchant::BaseController
  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant"
    else
      generate_flash(discount)
      render :new
    end
  end

  private

  def discount_params
    params.permit(:percentage, :items_needed)
  end
end
