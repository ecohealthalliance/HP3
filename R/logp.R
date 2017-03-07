
logp = function(x){   # Fn to take log but make zeros less 10x less than min
  # x[is.na(x)] <- 0
  m = min(x[ x > 0], na.rm=T)
  x = log( x + m )
  return(x)
}
