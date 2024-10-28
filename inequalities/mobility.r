#######################################################################################
#
#                             - Measuring Mobility -
#    
# by Frank A. Cowell and E. Flachaire, October 2017
#
# - income mobility indices with asymptotic standard errors
# - rank mobility indices 
#
#######################################################################################


M.stat <- function(x,y,a=1,status=0,se=TRUE) {

  # x     : vector of incomes 0-distribution
  # y     : vector of incomes 1-distribution
  # a     : a scalar/vector of values of alpha
  # status: 0 = income  mobility 
  #         1 = ranking mobility 
  # se    : compute standard errors (asymptotic)
  #
  # ex.:  > source("./Mobility.r")
  #       > M(x,y)
  #       > M(x,y,c(-1,0,1))
  #       > M(x,y,c(-1,0,1),status=1)
  #       > alpha <- c(-.4,-.2,0,.2,.4)
  #       > toto  <- M(x,y,alpha,status=1)
  #       > toto
  
  if (NROW(x)!=NROW(y)) { stop("x and y should have the same number of observations") }
  M.index = numeric(NROW(a))
  M.se=numeric(NROW(a))
  u=numeric(NROW(x))
  v=numeric(NROW(x))

  if (status==0) {
    u=x
    v=y	
  }
  else if (status==1) {
    u=rank(x,ties.method="max")
    v=rank(y,ties.method="max")
  }
  else {
    stop("satus should be 0 or 1")
  }
  if (sum(u<0)!=0) stop("x should be non-negative")   # status u should always be positive
  if (sum(v<0)!=0) stop("y should be non-negative")   # status v should always be positive

  for (j in 1:NROW(a)) {
    if (a[j]==0)
      M.index[j] <- ( mean(v*log(v)) - mean(v*log(u)) ) / mean(v) + log(mean(u)/mean(v))       # eq(48)
    else if (a[j]==1)
      M.index[j] <- ( mean(u*log(u)) - mean(u*log(v)) ) / mean(u) + log(mean(v)/mean(u))       # eq(50)
    else {
      M.index[j] <- ( mean(u^a[j]*v^(1-a[j])) / (mean(u)^a[j]*mean(v)^(1-a[j])) - 1 )  /  ((a[j]-1)*a[j])   # eq(45)
    }
    test0 <- all.equal(M.index[j],0)         # test numerical approx. (FAQ: http://cran.r-project.org/doc/FAQ/R-FAQ.html)
    if (isTRUE(test0)) M.index[j] = 0        # FAQ: see "Why doesn't R think these numbers are equal?"
  }
  
  if (se==TRUE && status==0) {               # Compute asymptotic standard errors for income mobility indices

    for (j in 1:NROW(a)) {
      if (a[j]==0) {
        der1 = 1/mean(u)
        der2 = ( -mean(v*log(v)) + mean(v*log(u)) - mean(v) ) / mean(v)^2
        der3 = 1/mean(v)
        der4 = -1/mean(v)
        DER = matrix( cbind(der1, der2, der3, der4), nrow=1, ncol=4)    
        sig11 = mean(u^2) - mean(u)^2
        sig12 = mean(u*v) - mean(u)*mean(v)
        sig13 = mean(u*v*log(v)) - mean(u)*mean(v*log(v))
        sig14 = mean(u*v*log(u)) - mean(u)*mean(v*log(u))
        sig21 = sig12
        sig22 = mean(v^2) - mean(v)^2
        sig23 = mean(v^2*log(v)) - mean(v)*mean(v*log(v))
        sig24 = mean(v^2*log(u)) - mean(v)*mean(v*log(u))
        sig31 = sig13
        sig32 = sig23
        sig33 = mean(v^2*log(v)^2) - mean(v*log(v))^2
        sig34 = mean(v^2*log(u)*log(v)) - mean(v*log(u))*mean(v*log(v))
        sig41 = sig14
        sig42 = sig24
        sig43 = sig34
        sig44 = mean(v^2*log(u)^2) - mean(v*log(u))^2
        SIG = matrix( c(sig11,sig21,sig31,sig41, sig12,sig22,sig32,sig42, sig13,sig23,sig33,sig43, sig14,sig24,sig34,sig44), nrow=4, ncol=4) / NROW(u)
        Var = DER %*% SIG %*% t(DER)
        M.se[j] <- sqrt(Var[1])
      }
      else if (a[j]==1) {
        der1 = ( -mean(u*log(u)) + mean(u*log(v)) - mean(u) ) / mean(u)^2
        der2 = 1/mean(v)
        der3 = 1/mean(u)
        der4 = -1/mean(u)
        DER = matrix( cbind(der1, der2, der3, der4), nrow=1, ncol=4)
        sig11 = mean(u^2) - mean(u)^2
        sig12 = mean(u*v) - mean(u)*mean(v)
        sig13 = mean(u^2*log(u)) - mean(u)*mean(u*log(u))
        sig14 = mean(u^2*log(v)) - mean(u)*mean(u*log(v))
        sig21 = sig12
        sig22 = mean(v^2) - mean(v)^2
        sig23 = mean(u*v*log(u)) - mean(v)*mean(u*log(u))
        sig24 = mean(u*v*log(v)) - mean(v)*mean(u*log(v))
        sig31 = sig13
        sig32 = sig23
        sig33 = mean(u^2*log(u)^2) - mean(u*log(u))^2
        sig34 = mean(u^2*log(u)*log(v)) - mean(u*log(u))*mean(u*log(v))
        sig41 = sig14
        sig42 = sig24
        sig43 = sig34
        sig44 = mean(u^2*log(v)^2) - mean(u*log(v))^2
        SIG = matrix( c(sig11,sig21,sig31,sig41, sig12,sig22,sig32,sig42, sig13,sig23,sig33,sig43, sig14,sig24,sig34,sig44), nrow=4, ncol=4) / NROW(u)
        Var = DER %*% SIG %*% t(DER)
        M.se[j] <- sqrt(Var[1])
      }
      else {
        der1 = -mean(u^a[j]*v^(1-a[j]))*mean(u)^(-a[j]-1)*mean(v)^(a[j]-1) / (a[j]-1)
        der2 =  mean(u^a[j]*v^(1-a[j]))*mean(u)^(-a[j])*mean(v)^(a[j]-2)  / a[j]
        der3 =  mean(u)^(-a[j])*mean(v)^(a[j]-1)/ ((a[j]-1)*a[j])
        DER = matrix( cbind(der1, der2, der3), nrow=1, ncol=3)
        sig11 = mean(u^2) - mean(u)^2
        sig12 = mean(u*v) - mean(u)*mean(v)
        sig13 = mean(u^(1+a[j])*v^(1-a[j])) - mean(u)*mean(u^a[j]*v^(1-a[j]))
        sig21 = sig12
        sig22 = mean(v^2) - mean(v)^2
        sig23 = mean(u^a[j]*v^(2-a[j])) - mean(v)*mean(u^a[j]*v^(1-a[j]))
        sig31 = sig13
        sig32 = sig23
        sig33 = mean(u^(2*a[j])*v^(2-2*a[j])) - mean(u^a[j]*v^(1-a[j]))^2
        SIG = matrix( c(sig11,sig21,sig31, sig12,sig22,sig32, sig13,sig23,sig33), nrow=3, ncol=3) / NROW(u)
        Var = DER %*% SIG %*% t(DER)
        M.se[j] <- sqrt(Var[1])
      }
      test0 <- all.equal(M.se[j],0)         # test numerical approx. (FAQ: http://cran.r-project.org/doc/FAQ/R-FAQ.html)
      if (isTRUE(test0)) M.se[j] = 0        # FAQ: see "Why doesn't R think these numbers are equal?"
    }    
    return(list(alpha=a,index=M.index,se=M.se,status=status))    
  }
  else {
    return(list(alpha=a,index=M.index,status=status))
  }
  
}


