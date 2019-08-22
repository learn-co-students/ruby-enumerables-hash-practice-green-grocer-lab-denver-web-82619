def consolidate_cart(cart)
  hash_cart = cart.reduce({}) do |memo, pair|
    pair.each do |(key, value)|
      if !memo[key]
        memo[key] = value
        memo[key][:count] = 1
      else 
        memo[key][:count] += 1
      end
    end
    memo
  end
end

def apply_coupons(cart, coupons)
  matching_coupons = coupons.select do |n|
    cart[n[:item]]
  end
  
  if matching_coupons.length == 0 
    return cart
  end

  i = 0
  while i < matching_coupons.length do
    item = matching_coupons[i][:item]
    cart_count = cart[item][:count]
    coupon_num = matching_coupons[i][:num]
    
    if cart_count >= coupon_num
      if !cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"] = {
          price: matching_coupons[i][:cost] / coupon_num,
          clearance: cart[item][:clearance],
          count: 0
        }
      end
      
      cart["#{item} W/COUPON"][:count] += coupon_num
        
      cart[item][:count] -= coupon_num
    end
    cart
    i += 1
  end
  
  cart
end

def apply_clearance(cart)
  clearance_cart = cart.reduce({}) do |memo, (key, value)|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
    end
    memo[key] = value
    
    memo
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  total = cart.reduce(0) do |memo, (key, value)|
    memo += (value[:price] * value[:count])
  end
  
  if total > 100
    total *= 0.9
  end
  
  total
end




