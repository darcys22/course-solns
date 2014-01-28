#!/usr/bin/env ruby

require 'enumerator'
require 'pry'

video = File.open('test.mp4', 'rb'){|f|f.read}

chunks = []
video.bytes.each_slice(1024) { |slice| chunks << slice.join }

chunks.reverse.inject(0) do |checksum, x|
	sha256 = Digest::SHA256.new
	sha256.update x 
	sha256.update checksum unless x.nil?
	checksum = sha256.hexdigest
	binding.pry
end

binding.pry
