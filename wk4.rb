#!/usr/bin/env ruby

require 'httparty'
require 'pry'
require 'byebug'

TARGET = 'http://crypto-class.appspot.com/po?er='
TEST = 'f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4'
BLOCKSIZE = 16

module Attack
	class PaddingOracle
		
		class << self
			def query(params)
				@params = params	

				blocks = split_parms(params)
				second_last_block(blocks)
				response.code

				(1..BLOCKSIZE).each do |i|
					byte_in_progress = BLOCKSIZE - i
					block[byte_in_progress..(BLOCKSIZE - 1)] = i.to_s
					(0..255).each do |b|
						block[byte_in_progress] = b.hex
						response = call
						if response.code = 203
							intermediate_byte = byte_in_progress xor i.to_s
							intermediate_block[byte_in_progress] = intermediate_byte
							exit
						end
					end	
				end

				binding.pry
			end

			def call
				HTTParty.get(TARGET + @params)

			def second_last_block(array)
				array[array.length -2]
			end


			def chunk(string, size)
				string.scan(/.{1,#{size}}/)
			end

			def split_parms(params)
				chunk(params, 16)
			end

			def last_block
				array[array.length - 1]
			end
		end
	end
end
Attack::PaddingOracle.query(TEST)
