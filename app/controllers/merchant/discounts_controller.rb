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
    if discount.update(discount_params)
      flash[:success] = "Discount Updated."
      redirect_to "/merchant"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

  def destroy
    discount = current_user.merchant.discounts.find(params[:id])
    discount.destroy
    flash[:message] = "Your discount was deleted."
    redirect_to "/merchant"
  end

  private

  def discount_params
    params.permit(:percentage, :items_needed)
  end
end
