xml.instruct!

xml.order do
  xml.order_id @order.id
  xml.placed_at @order.created_at
  xml.adddress @order.fulladdress
  xml.status @order.actual_status
  xml.detail do
    xml.address1 @address1
    xml.address2 @address2
    xml.address3 @address3
  end

end

