#!/usr/bin/env ruby

require 'pry'
require 'openssl'


class Inform
	attr_accessor :key, :iv, :ct
	def initialize (key, ct, iv_size = 16)
		@key = [key].pack('H*')
		@text = [ct].pack('H*')
		@iv = @text[0 .. iv_size - 1]
		@ct = @text[iv_size..@text.size]
	end
end

class Hell
	def initialize(infoxr, mode)
		Mode = {cbc: 'AES-128-CBC', ctr: 'AES-128-CTR'}
		decrypter = OpenSSL::Cipher::Cipher.new(Mode[mode])
		decrypter.decrypt
		decrypter.key = infoxr.key 	
		decrypter.iv = infoxr.iv
		plain = decrypter.update(infoxr.ct) << decrypter.final
		puts plain
	end
end

require_relative 'data'

binding.pry
