class Array
  # Get the average (mean) for an array of numbers (Fixnum or Float)
  def average
    inject(:+) / count
  end

  # Get the median value for an array of numbers (Fixnum or Float)
  def median
    if count == 0
      nil
    elsif count.odd?
      sort[count / 2]
    else
      sorted = sort
      (sorted[count / 2 - 1] + sorted[count / 2]).to_f / 2
    end
  end
end
