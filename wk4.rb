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

  def ^( other )
    longest = [self.length,other.length].max
    (self.hex ^ other.hex).to_s(16).rjust(longest, '0')
  end
end

module Attack
	class PaddingOracle
		
		class << self
			def query(params)
				@params = params	

				@blocks = split_parms(params)
				@intermediate = []
				@blocks.length.times do |progress|
					intermediate_block = Array.new(16, "00")
					(1..BLOCKSIZE).each do |i|
						working_block = chunk(second_last_block(@blocks, progress), 2)
						byte_in_progress = BLOCKSIZE - i
						i.times {|count| working_block[BLOCKSIZE - (count + 1)] = (i.to_s.fix^intermediate_block[BLOCKSIZE - (count + 1)].fix).fix }
						(0..255).each do |b|
							working_block[byte_in_progress] = b.to_s(16).fix
							response = call(working_block, progress)
							if response.code == 404
								intermediate_byte = (working_block[byte_in_progress]^i.to_s(16).fix).fix
								intermediate_block[byte_in_progress] = intermediate_byte
								puts intermediate_byte
								break
							elsif response.code == 200
								puts "ERRRROROROROROROOR"
								binding.pry
							end
						end	
					end
					@intermediate[progress + 1] = intermediate_block.join
				end
				binding.pry
			end

			def call(block, progress)
				#puts block.join
				modified = @blocks[0..(progress + 1)]
				modified[progress] = block.join
				puts modified.join
				HTTParty.get(TARGET + modified.join)
			end

			def second_last_block(array, block)
				#@block_in_progress = (array.length - 2)
				array[block] #lolwat
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
