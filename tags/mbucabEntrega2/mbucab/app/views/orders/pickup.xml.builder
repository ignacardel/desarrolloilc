xml.instruct! :xml, :version=>"1.0"

xml.order do

  xml.tracking_id @order.id.to_s
  xml.pickup_date @order.collectiondate
  xml.status @order.actual_status
 
end
