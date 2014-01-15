#!usr/bin/env ruby

require 'pry'
require 'openssl'

class Hell
	def initialize( key, ct )
		decrypter = OpenSSL::Cypher.new 'AES-128-CBC'
		decrypter.decrypt
		decrypter.key = key
		decrypter.iv = ct[0..15]
		decrypter.update(ct[16..63])
	end
end

binding.pry

