require "open-uri"
pdf.text "Order Bill", :size => 16, :style => :bold
pdf.text " "
pdf.text " "
pdf.text "Order Information", :size => 13, :style => :bold
pdf.text "Order #: #{@order.id}"
pdf.text "Order Placed: #{@order.created_at}"
pdf.text "Client: #{@name}"
pdf.text "Address: #{@address.nickname}"
pdf.text "Recipient: #{@order.recipient}"
pdf.text "Fulladdress: #{@order.fulladdress}"
pdf.text " "
pdf.text "Package List", :size => 13, :style => :bold
         cont = 1
         @order.packages.each do |package|
pdf.text "#{cont}.  Description: #{package.description}"
pdf.text "     Weight: #{package.weight} Kg"
pdf.text "     Price: $ #{package.price} ", :spacing => 16
pdf.text " "
         cont =  cont + 1
         end
pdf.text " "
pdf.text "Payment Information ", :size => 13, :style => :bold
pdf.text "Creditcard: #{@creditcard.four_numbers}"
pdf.text "Price:$ #{@total} "
pdf.text "Taxes:$ #{@total * 0.1} "
pdf.text "Total Price:$ #{@total + (@total * 0.1)} "
pdf.text " "
pdf.text "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
pdf.image open("#{@qr}"), :weight => 2002
