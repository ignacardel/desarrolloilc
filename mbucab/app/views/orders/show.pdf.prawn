require "open-uri"
pdf.text "Order Bill", :size => 16, :style => :bold
pdf.text " "
pdf.text "Billing #: #{@order.id}"
pdf.text "Date: #{@order.created_at}"
pdf.text "Client: #{@name}"
pdf.text "Address: #{@address.nickname}"
pdf.text "Recipient: #{@order.recipient}"
pdf.text "Fulladdress: #{@order.fulladdress}"
pdf.text "Creditcard: #{@creditcard.name}"
pdf.text " "
pdf.image open("#{@qr}"), :weight => 2002
pdf.text " "
pdf.text "Package List", :size => 14, :style => :bold
         @order.packages.each do |package|
pdf.text "Description: #{package.description}"
pdf.text "Weight: #{package.weight}"
pdf.text "Price: #{package.price}", :spacing => 16
         pdf.start_new_page
         end

