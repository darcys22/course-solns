#!/usr/bin/env ruby

require 'pry'
require 'openssl'

class Hell
	def initialize( key, ct )
		decrypter = OpenSSL::Cipher::Cipher.new('AES-128-CBC')
		decrypter.decrypt
		decrypter.key = key
		decrypter.padding = 1
		decrypter.iv = ct[0..15]
		plain =	decrypter.update(ct[16..ct.size]) 
		plain << decrypter.final
		puts plain
	end
end

binding.pry

