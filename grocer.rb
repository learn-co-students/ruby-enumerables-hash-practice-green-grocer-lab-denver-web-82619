def consolidate_cart(cart)
  new_cart = {}
  cart.each do |items_hash|
    items_hash.each do |item, attribute_hash|
      new_cart[item] ||= attribute_hash
      new_cart[item][:count] ? new_cart[item][:count] += 1 :
      new_cart[item][:count] = 1 
    end
  end
  
  new_cart
end

def apply_coupons(cart, coupons)
coupons.each do |coupon|
    coupon.each do |attribute, value|
      name = coupon[:item]

       if cart[name] && cart[name][:count] >= coupon[:num]
        if cart["#{name} W/COUPON"]
          cart["#{name} W/COUPON"][:count] += coupon[:num]
        else
          cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num],
          :clearance => cart[name][:clearance],:count => coupon[:num]}
        end

       cart[name][:count] -= coupon[:num]
    end
  end
end
  cart
end

def apply_clearance(cart) 
  cart.each do |item, attribute_hash| 
    if attribute_hash[:clearance] == true 
      attribute_hash[:price] = (attribute_hash[:price] *
      0.8).round(2) 
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
