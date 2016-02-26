# Easily calculate the percent difference by extending class numeric
class Numeric
  def percent_diff(n)
    (1 -self.to_f / n.to_f) * 100.0 
  end
end