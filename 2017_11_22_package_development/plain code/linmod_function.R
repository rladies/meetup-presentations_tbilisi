#Example partially taken from:
# Friedrich Leisch, Creating R Packages: A Tutorial. (2008)
# https://cran.r-project.org/doc/contrib/Leisch-CreatingPackages.pdf

#coefficients estimation for linear model y ~ x
linmodEst <- function(x, y)
{
  ## compute QR-decomposition of x
  qx <- qr(x)
  ## compute (x'x)^(-1) x'y
  coeffs <- solve.qr(qx, y)

}


linmod <- function(x, y)
{
  x <- as.matrix(x)
  y <- as.numeric(y)
  coefficients <- linmodEst(x, y)
  fitted.values <- as.vector(x %*% coefficients)
  residuals <- y - fitted.values
  result <- list(coefficients = coefficients, 
                 fitted.values = fitted.values, 
                 residuals = residuals);
}
