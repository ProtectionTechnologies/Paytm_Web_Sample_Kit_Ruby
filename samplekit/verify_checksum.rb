#!/usr/bin/ruby
require '../checksum/encryption_new_pg.rb'
require 'cgi'
include EncryptionNewPG
cgi = CGI.new

MERCHANT_KEY = "xxxxxxxxxxxxxxxx"

keys = cgi.keys
paytmParams = Hash.new
keys.each do |key|
paytmParams[key] = cgi[key]
end

checksum_hash = paytmParams["CHECKSUMHASH"]
paytmParams.delete("CHECKSUMHASH")

is_valid_checksum = new_pg_verify_checksum(paytmParams, checksum_hash, MERCHANT_KEY)

puts "Content-type: text/html\n\n"
puts "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=ISO-8859-I\"><title>Paytm</title></head><body>"

if is_valid_checksum == true
	puts "<b>Checksum matched and following are the transaction details:</b><br/>";
	paytmParams.each do |key, value|
		puts "<b>#{key}</b>: #{value}<br/>"
	end
else
puts "<b>Checksum mismatched.</b>"
end

puts "</body></html>" 