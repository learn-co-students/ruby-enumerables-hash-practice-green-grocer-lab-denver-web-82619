require "pry"

def consolidate_cart(cart)
  total_hash = {}
  
  cart.each do |item|
    if total_hash[item.keys[0]]
      #increase value of :count key by 1
      total_hash[item.keys[0]][:count] += 1
    else
      #add key/value pair, initialized :count = 0
      total_hash[item.keys[0]] = {}
      total_hash[item.keys[0]][:count] = 1
      total_hash[item.keys[0]][:price] = item.values[0][:price]
      total_hash[item.keys[0]][:clearance] = item.values[0][:clearance]
    end
  end
  
  total_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    if cart.key?(coupon[:item])
      
      #generate a key with variable first word depending on coupon
      coupon_item_name = "#{coupon[:item]} W/COUPON"
      
      #if no such item exists in cart, add it and initialize it
      if !cart[coupon_item_name]
       cart[coupon_item_name] = {}
       coupon_item_price = coupon[:cost] / coupon[:num]
       cart[coupon_item_name][:price] = coupon_item_price
       cart[coupon_item_name][:clearance] = cart[coupon[:item]][:clearance]
      end

      #calculate and modify count on original cart entry
      if cart[coupon[:item]][:count] >= coupon[:num]
        
        #create or update count of coupon item in cart
        discounted_count = cart[coupon_item_name][:count] ?
          cart[coupon_item_name][:count] + coupon[:num] :
          coupon[:num]
        cart[coupon_item_name][:count] = discounted_count

        #update original cart entry count (minus all discounted)
        cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
      end
    end
  end
  
  cart
end

def apply_clearance(cart)
  cart.each do |item|
    #binding.pry
    if
      item[1][:clearance]
        item[1][:price] = (item[1][:price] * 0.80).round(2)
    end
  end
  
  cart
end

def checkout(cart, coupons)
  total = 0.0
  
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  clearanced = apply_clearance(couponed)
 
  clearanced.each { |key, value| total = total + (value[:price] * value[:count]) }
  
  if total > 100
    total = 0.9 * total
  end
  
  total
end
