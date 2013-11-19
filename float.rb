
#monkey patch Float class so I can round the weights to x sig figs
class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end
end