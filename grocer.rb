require "pry"

def consolidate_cart(cart)
  cart_hash = {} #=> create new hash
  cart.each do |item|
    item_name = item.keys.first 
    
      #=> .first is same as "element at item zero"
      #=> item refers to the hash within the Array
      #=> item.keys.first will grab the key (here a food name) at index zero
      
    if cart_hash[item_name]
      cart_hash[item_name][:count] += 1 
      
      #=> if cart_hash already has food name, increment count key (:count)
    else 
      cart_hash[item_name] = item.values.first  
      cart_hash[item_name][:count] = 1
      
      #=> if cart_hash doesn't have the food name, set :count key equal to 1
    end 
  end
  cart_hash   #=> return new hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon| 
    coupon_name = coupon[:item]
      if cart.has_key?(coupon_name) && !cart.has_key?("#{coupon_name} W/COUPON") && cart[coupon_name][:count] >= coupon[:num]
        cart["#{coupon_name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num],:clearance => cart[coupon_name][:clearance],:count => coupon[:num]}
        cart[coupon_name][:count] -= coupon[:num]
      elsif cart.has_key?("#{coupon_name} W/COUPON") && cart[coupon_name][:count] >= coupon[:num]
        cart["#{coupon_name} W/COUPON"][:count] += coupon[:num]
        cart[coupon_name][:count] -= coupon[:num]
    end
  end
  cart 
end

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  total = 0 
  hash_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(hash_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  clearance_cart.each do |item, values|
    total += values[:price] * values[:count]
  end
  
  if total > 100
    total = total * 0.9
  end
  total
end
