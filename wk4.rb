#!/usr/bin/env ruby

require 'httparty'
require 'pry'
require 'byebug'

TARGET = 'http://crypto-class.appspot.com/po?er='
TEST = 'f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4'
BLOCKSIZE = 16

class String
  def fix
    self[0...2].rjust(2, '0') #or ljust
  end
end

module Attack
	class PaddingOracle
		
		class << self
			def query(params)
				@params = params	

				@blocks = split_parms(params)
				working_block = second_last_block(@blocks)
				(1..BLOCKSIZE).each do |i|
					byte_in_progress = BLOCKSIZE - i
					working_block = chunk(working_block, 2)
					working_block[byte_in_progress..(BLOCKSIZE - 1)] = i.to_s.fix
					(0..255).each do |b|
						byebug
						working_block[byte_in_progress] = b.to_s(16).fix
						response = call(working_block)
						if response.code = 203
							intermediate_byte = byte_in_progress xor i.to_s
							intermediate_block[byte_in_progress] = intermediate_byte
							exit
						end
					end	
				end

				binding.pry
			end

			def call(block)
				@blocks[2] = block.join
				HTTParty.get(TARGET + @blocks.join)
			end

			def second_last_block(array)
				binding.pry
				array[array.length - 2]
			end


			def chunk(string, size)
				string.scan(/.{1,#{size}}/)
			end

			def split_parms(params)
				chunk(params, BLOCKSIZE * 2)
			end

			def last_block
				array[array.length - 1]
			end
		end
	end
end
Attack::PaddingOracle.query(TEST)
