xml.instruct!
xml.comment! "http://localhost:3000/web_service/support_request_format"

xml.order do
  if @error == false
    xml.order_id @order.id
    xml.price @ourtotal
  else
    xml.order "Errors in xml!"
  end
end