xml.instruct!

xml.order do
  #xml.order_id @client.id
  xml.order_id @order.id
  xml.price @package.price
  xml.total @order.extra+@package.price
end