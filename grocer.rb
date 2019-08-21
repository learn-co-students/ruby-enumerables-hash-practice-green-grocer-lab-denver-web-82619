require 'pry'

def consolidate_cart(cart)
  # code here
    consolidated_cart = {}
    cart.each do |item|
        item.each do |name, attributes|
            attributes[:count] = cart.count(item)
        end
    consolidated_cart.merge!(item)
    end
    consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        name = "#{coupon[:item]} W/COUPON"
        if cart[name]
          cart[name][:count] += coupon[:num]
        else cart[name] = {
          price: coupon[:cost]/ coupon[:num],
          clearance: cart[coupon[:item]][:clearance],
          count: coupon[:num]
        }
      end
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  end
end
cart
end

def apply_clearance(cart)
  cartHash = cart
  cart.each do |name, hash|
    if hash[:clearance] 
      cartHash[name][:price] = (cart[name][:price] * 0.8).round(2)
    end
  end
 cartHash
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each do |food, info|
    total += (info[:price] * info[:count]).to_f
  end
  total >= 100 ? total * 0.9 : total
  end

