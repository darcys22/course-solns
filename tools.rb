class String
  def ^( other )
    b1 = self.unpack("U*")
    b2 = other.unpack("U*")
    longest = [b1.length,b2.length].max
    b1 += [0]*(longest-b1.length)
    b2 += [0]*(longest-b2.length)
    b1.zip(b2).map{ |a,b| a^b }.pack("C*")
  end
end 
