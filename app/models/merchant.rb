class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :order_items, through: :items
  has_many :orders, through: :order_items
  has_many :users
  has_many :discounts, dependent: :destroy

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    orders.joins('JOIN users ON orders.user_id = users.id')
          .order('city_state')
          .distinct
          .pluck("CONCAT_WS(', ', users.city, users.state) AS city_state")
  end

  def pending_orders
    orders.where(status: 'pending').distinct
  end

  def pending_orders_count
    orders.where(status: 'pending').distinct.count
  end

  def pending_orders_revenue
    order_items.joins("JOIN orders ON order_items.order_id = orders.id")
               .where("orders.status = '0'")
               .sum("order_items.price * order_items.quantity")
  end

  def order_items_by_order(order_id)
    order_items.where(order_id: order_id)
  end

  def discount?
    self.discounts != []
  end

  def default_image_items
    self.items.where(image: nil).or(self.items.where(image: ''))
  end
end
