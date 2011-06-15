xml.instruct!
xml.comment! ""
xml.comment! "Web Service Support Request Format and Addresss"
xml.comment! "http://localhost:3000/web_service/support_request"

xml.support_request do

   xml.client do
     xml.account "string"
     xml.birthday "year-month-day"
     xml.firstname "string"
     xml.lastname "string"
     xml.phone "integer(10)"
   end
   xml.address do
     xml.city "string"
     xml.country "string"
     xml.latitude "float"
     xml.longitude "float"
     xml.name "string"
     xml.nickname "string"
     xml.number "string"
     xml.street "street"
     xml.zip "integer(4)"
     xml.zone "string"
   end
   xml.creditcard do
     xml.code "integer(3)"
     xml.expdate "year-month-day"
     xml.name "string"
     xml.number "integer(16)"
   end
   xml.order do
     xml.city "string"
     xml.country "string"
     xml.latitude "float"
     xml.longitude "float"
     xml.name "string"
     xml.number "string"
     xml.recipient "string"
     xml.street "string"
     xml.zip "integer(4)"
     xml.zone "string"
   end
   xml.package do
     xml.description "string"
     xml.weight "float"
   end
   xml.total "float"
end
xml.comment! ""
xml.comment! "Web Service Track Id Addresss"
xml.comment! "http://localhost:3000/web_service/track_id/(id)"
