class String
  def from_hex()
      self.chop()
      string = self.scan(/[a-fA-F0-9]{2}/).map{|x| x.hex.chr}.join
      return string
  end

  def to_hex()
      return self.split("").map{|x| x.unpack('H*')}.join
  end

  def ^ (key) # Define an xor operator
      accum = []
      hex_bytes = []
      key_bytes = []

      key = key.chr if key.is_a? Fixnum and key < 255 #Lets us handle Fixnum or String keys
      raise RangeError, "Integer Keys can be only 1 byte" if key.is_a? Fixnum #raise an error if it's too long
      raise "Invalid XOR key type #{key.class}" unless key.is_a? String #Else raise an exception

      self.to_hex.split("").each_slice(2) {|x| hex_bytes << x.join}
      key.to_hex.split("").each_slice(2) {|x| key_bytes << x.join}
      hex_bytes.each_with_index{|h,i| accum << (h.to_i(16) ^ key_bytes[i.modulo key_bytes.size].to_i(16)).chr}
      return accum.join
  end
end

def cribdrag(ciphertext, crib)
  #ciphertext.length
  2.times{ |x| puts "#{x} : #{ciphertext[x,crib.length] ^ crib}"}
end
