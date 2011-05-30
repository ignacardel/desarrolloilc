xml.instruct!
#xml.posts do
#  @orders.each do |post|
#    xml.post do
#      xml.title post.title
#      xml.body post.body
#      xml.published_at post.published_at
#      xml.comments do
#        post.comments.each do |comment|
#          xml.comment do
#            xml.body comment.body
#          end
#        end
#      end
#    end
#  end
#end

xml.order do
  xml.order_id @order.id
  xml.client @name
  @order.packages.each do |package|
    xml.packages do
      xml.weight package.weight
      xml.price  package.price
    end

  end
end

