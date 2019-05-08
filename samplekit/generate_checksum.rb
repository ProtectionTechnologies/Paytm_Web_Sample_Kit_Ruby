#!/usr/bin/ruby
require '../checksum/encryption_new_pg.rb'
require 'cgi'
include EncryptionNewPG
cgi = CGI.new
  
MERCHANT_ID = "xxxxxxxxxxxxxxxxxxxx"
MERCHANT_KEY = "xxxxxxxxxxxxxxxx"
WEBSITE = "xxxxxxxxxx"
CHANNEL_ID = "xxx"
INDUSTRY_TYPE_ID = "xxxxxx"

ORDER_ID = cgi["ORDER_ID"]
CUST_ID = cgi["CUST_ID"]
TXN_AMOUNT = cgi["TXN_AMOUNT"]
MOBILE_NO = cgi["MOBILE_NO"]
EMAIL = cgi["EMAIL"]

paytmParams = Hash.new
paytmParams["MID"] = MERCHANT_ID
paytmParams["ORDER_ID"] = ORDER_ID
paytmParams["CUST_ID"] = CUST_ID
paytmParams["INDUSTRY_TYPE_ID"] = INDUSTRY_TYPE_ID
paytmParams["CHANNEL_ID"] = CHANNEL_ID
paytmParams["TXN_AMOUNT"] = TXN_AMOUNT
paytmParams["MOBILE_NO"] = MOBILE_NO
paytmParams["EMAIL"] = EMAIL
paytmParams["WEBSITE"] = WEBSITE
paytmParams["CALLBACK_URL"] = "http://localhost/cgi-bin/Paytm_Web_Sample_Kit_Ruby/samplekit/verify_checksum.rb"

checksum = new_pg_checksum(paytmParams, MERCHANT_KEY)

txn_url = "https://securegw-stage.paytm.in/order/process" # Staging URL
# txn_url = "https://securegw.paytm.in/order/process" # Production URL

form_fields = ""
paytmParams.each do |key, value|
	form_fields += "<input type=\"hidden\" name=\"#{key}\" value=\"#{value}\" />"
end
form_fields += "<input type=\"hidden\" name=\"CHECKSUMHASH\" value=\"#{checksum}\" />"

puts "Content-type: text/html\n\n"
puts "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=ISO-8859-I\"><title>Paytm</title></head><body><center><h2>Redirecting to Paytm </h2><br /><h1>Please do not refresh this page...</h1></center><form method=\"post\" action=\"#{txn_url}\" name=\"paytm_form\">#{form_fields}</form><script type=\"text/javascript\">document.paytm_form.submit();</script></body></html>"