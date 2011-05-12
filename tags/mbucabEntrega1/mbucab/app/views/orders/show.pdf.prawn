require "open-uri"
pdf.fill_color "0000ff"
pdf.font "Courier"
pdf.text "Mail Boxes Ucab", :size => 16, :style => :bold
pdf.text "Orinoco Avenue, between Mucuchies & Perijá", :size => 8
pdf.text "L&M Tower, PH", :size => 8
pdf.text "Las Mercedes", :size => 8
pdf.text "Rif J-304181981", :size => 8
pdf.text "Telf: 212-992-2120, 212-992-6781, 212-991-1277", :size => 8
pdf.text "Fax: 212-992-8978", :size => 8
pdf.text "E-mail: contact@mailboxesucab.com", :size => 8
pdf.fill_color "000000"
pdf.text " "
pdf.text "Print this page for your records.", :size => 10
pdf.text " "
pdf.text "Order Information", :size => 13, :style => :bold
pdf.text "Order #: #{@order.id}"
pdf.text "Tracking-id: #{@order.id}",:style=> :bold
pdf.text "Order Placed: #{@order.created_at}"
pdf.text "Client: #{@name}"
pdf.text "Pickup Address: #{@address.nickname}"
pdf.text "Recipient: #{@order.recipient}"
pdf.text "Delivery address: #{@order.fulladdress}"
pdf.text " "
pdf.text "Packages List", :size => 13, :style => :bold
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
pdf.text "Credit card: #{@creditcard.four_numbers}"
pdf.text "Total before taxes:$ #{@total} "
pdf.text "Taxes:$ #{@total * 0.1} "
pdf.text "Grand total:$ #{@total + (@total * 0.1)} "
pdf.text " "
pdf.text "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
pdf.text " "
pdf.text "Your mail carrier will scan this code to complete the pickup"
pdf.image open("#{@qr}"), :weight => 2002
