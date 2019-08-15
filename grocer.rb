def consolidate_cart(cart)
    cart = cart.reduce({}) do |memo, pair|
    pair.each_value{|value| value[:count] = cart.count(pair)}
    memo = memo.merge(pair) {|key, v1, v2| v1}
    memo
    end
    cart
end


def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.length do
    coupon_item = coupons[i][:item]
    if cart[coupon_item] == nil
      return cart
    end
    coupon_num = coupons[i][:num]
    coupon_each_cost = coupons[i][:cost]/coupon_num
    cart_item_count = cart[coupon_item][:count]
    num_item_coupon_applied = ((cart_item_count/coupon_num - 0.5).round)*coupon_num
    cart_item_left = (cart_item_count%coupon_num)
    if coupon_num <= cart_item_count
      cart["#{coupon_item} W/COUPON"] = {price: coupon_each_cost,
                                  clearance: cart[coupon_item][:clearance],
                                  count: num_item_coupon_applied
                                }
    end
    (cart_item_left == 0) ? (cart[coupon_item][:count] = 0):(cart[coupon_item][:count] = cart_item_left)
  i += 1
  end
  cart
end

def apply_clearance(cart)
  cart.each_key do |key|
    if cart[key][:clearance]
        percent_off = (cart[key][:price]*(0.20)).round(2)
        clearance_price = cart[key][:price] - percent_off
        cart[key][:price] = clearance_price
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  apply_coupons(cart, coupons)
  apply_clearance(cart)
  cart_total = {}
  cart.each_key do |key|
    cart_total[key] = cart[key][:price]*cart[key][:count]
  end
p cart_total
total_cost = cart_total.values.sum
  if total_cost > 100
    total_cost = total_cost * (0.9)
  end
total_cost
end
