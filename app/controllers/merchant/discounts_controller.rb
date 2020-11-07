class Merchant::DiscountsController < Merchant::BaseController
  def new

  end

  def edit
    @discount = current_user.merchant.discounts.find(params[:id])
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant"
    else
      flash[:message] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    discount = current_user.merchant.discounts.find(params[:id])
    discount.update(discount_params)
    redirect_to "/merchant"
  end

  private

  def discount_params
    params.permit(:percentage, :items_needed)
  end
end
