xml.instruct!
xml.comment! ""
xml.comment! "Web Service Support Request Format and Addresss"
xml.comment! "http://localhost:3000/web_service/support_request"

xml.support_request do

   xml.client "string"
   xml.address "string"
   xml.creditcard "string"
   xml.order do
     xml.city "string"
     xml.country "string"
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
end
xml.comment! ""
xml.comment! "Web Service Track Id Addresss"
xml.comment! "http://localhost:3000/web_service/track_id/(id)"
