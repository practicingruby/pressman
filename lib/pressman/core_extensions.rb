class Fixnum
  def to(another)
    nums = []
    if self < another
      self.upto(another) { |i|  nums << i }
    else
      self.downto(another) { |i| nums << i }
    end
    return nums
  end
end