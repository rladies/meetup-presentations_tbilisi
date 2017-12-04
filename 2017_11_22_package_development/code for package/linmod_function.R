#' @export
#' 
#' @title linmod, simplified linear regression
#' 
#' @description
#' This function provides a very simple implementation of linear regression.
#' 
#' @usage linmod(x, y)
#' @param x An MxN matrix with M samples and N predictors
#' @param y A numeric vector with M elements
#'
#' @return an instance of class linmod, containing:
#' coefficients: the coefficients of the linear regression
#' fitted.values: the values predicted by the linear regression
#' x, y: the original values
#'
#' @author Vincenzo Lagani
#'
#' @references
#' Friedrich Leisch, Creating R Packages: A Tutorial. (2008)
#' https://cran.r-project.org/doc/contrib/Leisch-CreatingPackages.pdf
#' 
#' @examples
#' # Load the data
#' data("linmodExampleData")
#' attach(linmodExampleData)
#' res <- linmod(x, y)
#' plotLinmod(res, useGGplot = TRUE)
#' 

#main linmod function
linmod <- function(x, y)
{
  x <- as.matrix(x)
  y <- as.numeric(y)
  coefficients <- linmodEst(x, y)
  fittedValues <- as.vector(x %*% coefficients)
  result <- new('linmod', coefficients, fittedValues, x, y);
}

#coefficients estimation for linear model y ~ x
linmodEst <- function(x, y)
{
  ## compute QR-decomposition of x
  qx <- qr(x)
  ## compute (x'x)^(-1) x'y
  coeffs <- solve.qr(qx, y)
  
}
