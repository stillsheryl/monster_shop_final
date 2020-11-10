class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many :discount_items
  has_many :discounts, through: :discount_items

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory

  def self.active_items
    where(active: true)
  end

  def self.by_popularity(limit = nil, order = "DESC")
    left_joins(:order_items)
    .select('items.id, items.name, COALESCE(sum(order_items.quantity), 0) AS total_sold')
    .group(:id)
    .order("total_sold #{order}")
    .limit(limit)
  end

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def apply_discount(total_items_in_cart)
    price - (price * (merchant.discounts.where("items_needed <= #{total_items_in_cart}").order(items_needed: :desc).pluck(:percentage).first * 0.01))
  end

  def image_for_item(item_id)
    item = Item.find(item_id)
    if item.image?
      item.image
    else
      item.image = "https://images.unsplash.com/photo-1604917018135-18fe420b2ce4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=80"
    end
  end
end
