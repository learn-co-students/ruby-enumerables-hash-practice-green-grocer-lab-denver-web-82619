def consolidate_cart(cart)
  products_hash = {}
  cart.each do |product|
    product.each do |item, amount|
    products_hash[item] ||= amount
    products_hash[item][:count] ? products_hash[item][:count] += 1:
    products_hash[item][:count] =1 
    end
  end
products_hash
end

def apply_coupons(cart, coupons) 
  
  coupons.each do |coupon| 
    coupon.each do |a, value| 
      n = coupon[:item] 
    
      if cart[n] && cart[n][:count] >= coupon[:num] 
        if cart["#{n} W/COUPON"] 
          cart["#{n} W/COUPON"][:count] += coupon[:num]
        else 
          cart["#{n} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], 
          :clearance => cart[n][:clearance], :count => coupon[:num] } 
        end 
  
      cart[n][:count] -= coupon[:num] 
    end 
  end 
end 
  cart 
end


def apply_clearance(cart) 
  cart.each do |item, a| 
    if a[:clearance] == true 
      a[:price] = (a[:price] * 0.8).round(2) 
    end 
  end 
cart 
end


def checkout(cart, coupons)
  original_cart = consolidate_cart(cart)
  coupons_cart = apply_coupons(original_cart, coupons)
  clearance_cart = apply_clearance(coupons_cart)
  total = 0
  clearance_cart.each do |item, a|
    total += a[:price] * a[:count]
  end
  total > 100 ? total * 0.9 : total
end 

