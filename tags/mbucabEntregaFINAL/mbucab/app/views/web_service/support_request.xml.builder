xml.instruct!
xml.comment! "http://localhost:3000/web_service/format"


  if @error == false
    xml.order do
      xml.order_id @order.id
      xml.price @ourtotal
    end
  else
    xml.error "Errors in xml!"
  end