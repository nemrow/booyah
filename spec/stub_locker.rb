class StubLocker
  def self.lob_order_return
    {
        "id"=>"job_8b194c64de739a70", 
        "name"=>"Jordan Nemrow's Job", 
        "price"=>"1.21", 
        "to"=>
          {
            "id"=>"adr_39dd19dac0a5876a", 
            "name"=>"Jordan Nemrow", 
            "email"=>nil, 
            "phone"=>nil, 
            "address_line1"=>"22 weatherby ct.", 
            "address_line2"=>"", 
            "address_city"=>"Petaluma", 
            "address_state"=>"CA", 
            "address_zip"=>"94954", 
            "address_country"=>"US", 
            "date_created"=>"2013-09-02T20:33:32+00:00", 
            "date_modified"=>"2013-09-02T20:33:32+00:00", 
            "object"=>"address"
          }, 
        "from"=>nil, 
        "status"=>"Processed", 
        "tracking"=>nil, 
        "packaging"=>
          {
            "id"=>"1", 
            "name"=>"Smart Packaging", 
            "description"=>"Automatically determined optimal packaging for safe and secure delivery", 
            "object"=>"packaging"
          }, 
        "service"=>nil, 
        "objects"=>
          [
            {
              "id"=>"obj_20ff0dcca6008aef", 
              "name"=>"Jordan Nemrow's Object", 
              "quantity"=>"1", 
              "double_sided"=>"0", 
              "date_created"=>"2013-09-17T17:34:08+00:00", 
              "date_modified"=>"2013-09-17T17:34:08+00:00", 
              "setting"=>
                {
                  "id"=>"500", 
                  "type"=>"Photos", 
                  "description"=>"4x6 Gloss Photo", 
                  "paper"=>"Gloss Photo Paper", 
                  "width"=>"6.000", 
                  "length"=>"4.000", 
                  "color"=>"Color", 
                  "notes"=>nil, 
                  "object"=>"setting"
                }, 
              "object"=>"object"
            }
          ], 
        "date_created"=>"2013-09-17T17:34:12+00:00", 
        "date_modified"=>"2013-09-17T17:34:12+00:00", 
        "object"=>"job"
      }
  end

  def self.valid_order_json_no_receiver
    JSON.parse( 
        '{
          "event": "message-in",
          "campaign_id": "49136",
          "msisdn": "17078496085",
          "carrier": "Verizon Wireless",
          "message": "Booyah",
          "subject": "",
          "images": [
            {
              "image": "http://d2c.bandcon.mogreet.com/mo-mms/images/710133_4856324.jpeg"
            }
          ]
        }'
      )
  end

  def self.valid_order_with_receiver_json
    JSON.parse(
      '{
        "event": "message-in",
        "campaign_id": "49892",
        "msisdn": "17078496085",
        "carrier": "Verizon Wireless",
        "message": "Booyahtest Grammie",
        "subject": "",
        "images": [
          {
            "image": "http://d2c.bandcon.mogreet.com/mo-mms/images/755634_5151977.jpeg"
          }
        ]
      }'
    )
  end

  def self.valid_order_with_receiver_name_json
    JSON.parse(
      '{
        "event": "message-in",
        "campaign_id": "49892",
        "msisdn": "17078496085",
        "carrier": "Verizon Wireless",
        "message": "Booyahtest Grammie and Poppa",
        "subject": "",
        "images": [
          {
            "image": "http://d2c.bandcon.mogreet.com/mo-mms/images/755634_5151977.jpeg"
          }
        ]
      }'
    )
  end

  def self.contacts_request_json
    JSON.parse(
      '{
        "event": "message-in",
        "campaign_id": "49892",
        "msisdn": "17078496085",
        "carrier": "Verizon Wireless",
        "message": "Booyahtest people",
        "subject": ""
      }'
    )
  end

  def self.no_image_order_json
    JSON.parse( 
        '{
          "event": "message-in",
          "campaign_id": "49136",
          "msisdn": "17078496085",
          "carrier": "Verizon Wireless",
          "message": "Booyah",
          "subject": ""
        }'
      )
  end

  def self.create_picture_json
    {
      :pdf=>"https://s3.amazonaws.com/booyahbooyah/user_52_1379099369.pdf", 
      :jpg=>"https://s3.amazonaws.com/booyahbooyah/user_52_1379099369.jpg"
    }
  end

  def self.lob_address_verification_json_return
    '{
      "address" : 
        {
          "address_line1" : "22 WEATHERBY CT", 
          "address_line2" : "", 
          "address_city" : "PETALUMA", 
          "address_state" : "CA", 
          "address_zip" : "94954-4659", 
          "address_country" : "US", 
          "object" : "address"
        }
    }'
  end
end