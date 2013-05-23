class Array
  # Get the average (mean) for an array of numbers (Fixnum or Float)
  def average
    self.inject(:+) / self.count
  end

  # Get the median value for an array of numbers (Fixnum or Float)
  def median
    if self.count == 0
      nil
    elsif self.count.odd?
      self.sort[self.count/2]
    else
      sorted = self.sort
      (sorted[self.count/2 - 1] + sorted[self.count/2]).to_f / 2
    end
  end
end
