#!/usr/bin/env ruby

require 'digest/sha2'
require 'pry'

def chunker
	video = File.new('acrtual.mp4', 'r') 
	(0..video.size/1024).inject([]) { |array, i| array << video.read(1024)}
end

def sha
	video_chunks = chunker
	sha = video_chunks.reverse.inject('') do  |sha, chunk| 
		sha = Digest::SHA2.digest( chunk+sha )
	end
end

puts sha.unpack('H*')
# 5b96aece304a1422224f9a41b228416028f9ba26b0d1058f400200f06a589949
