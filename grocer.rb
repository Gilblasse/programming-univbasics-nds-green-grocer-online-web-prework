require 'pry'

def find_item_by_name_in_collection(name, collection)
  collection.each_with_index do |item,index|
    if item[:item] == name
      return item 
    end
  end
  nil
end

def consolidate_cart(cart)
 new_array = []
  
  cart.each do |item|
    item[:count] == nil ? item[:count] = 1 : item[:count] += 1
    # common_item = find_item_by_name_in_collection(item[:item], new_array)
    # if common_item != nil
    #   common_item[:count] += 1
    # else
    #   unique_item = {
    #     :item => item[:item],
    #     :price => item[:price],
    #     :clearance => item[:clearance],
    #     :count => 1
    #   }
    #   new_array << unique_item
    # end
  end
  # new_array
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    cart_item = find_item_by_name_in_collection(coupon[:item],cart)
    couponed_item_name = "#{coupon[:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name,cart)
    
    if cart_item && cart_item[:count] >= coupon[:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupon[:num]
        cart_item[:count] -= coupon[:num]
      else
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupon[:cost] / coupon[:num],
          :count => coupon[:num],
          :clearance => cart_item[:clearance],
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupon[:num]
      end
    end
  end
  cart
end



def apply_clearance(cart)
  cart.each do |item|
    if item[:clearance]
      twenty_percent = (item[:price] * 0.2).round(2)
      item[:price] -= twenty_percent
    end
  end
  cart
end

def checkout(cart, coupons)
  grand_total = 0
  new_consolidate_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(new_consolidate_cart, coupons)
  discounts_applied = apply_clearance(coupons_applied)

  # row = 0
  # while row < discounts_applied.size
  #   grand_total += discounts_applied[row][:price] * discounts_applied[row][:count]
  #   binding.pry
  #   row += 1
  # end
  
  discounts_applied.each do |item|
    grand_total += (item[:price] * item[:count])
  end
  
  if grand_total > 100 
    ten_percent = grand_total * 0.1
    grand_total -= ten_percent
  end
  grand_total
end
