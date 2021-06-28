
#class definition
setClass("linmod",
         slots = c(coefficients = 'numeric',
                   fittedValues = 'numeric',
                   x = 'matrix',
                   y = 'numeric')
)

#initializer
setMethod(
  f="initialize",
  signature="linmod",
  definition=function(.Object, coefficients = NULL,
                      fittedValues = NULL,
                      x = NULL,
                      y = NULL){
    .Object@coefficients <- coefficients
    .Object@fittedValues <- fittedValues
    .Object@x <- x
    .Object@y <- y
    return(.Object)
  }
)

#' @export
#' @title plotLinmod
#' @import ggplot2
#' @description Function to plot a linmod object
#' @usage plotLinmod(object, useGGplot)
#' @param object The linmod object
#' @param useGGplot logical, should ggplot2 be used for beautify the plot?
#' @return It creates a plot of the fitted vs. the actual outcome values
#' @author Vincenzo Lagani

#set generic for plot
setGeneric(
  name = "plotLinmod",
  def = function(object, useGGplot = FALSE){standardGeneric("plotLinmod")}
)

#plot with option for ggplot
setMethod(
  f = 'plotLinmod',
  signature = c('linmod', 'logical'),
  definition=function(object, useGGplot){
    if(useGGplot){
      p <- ggplot(data = data.frame(y = object@y, fittedValues = object@fittedValues), 
                  aes(x = fittedValues, y = y)) +
        geom_point() +
        theme_bw();
      plot(p)
    }else{
      plot(object@fittedValues , object@y)
    }
  }
)

#' @export
#' @title getCoefficients
#' @description Function to retrieve the fitted coefficients from a ggplot object
#' @usage getCoefficients(object, useGGplot)
#' @param object The linmod object
#' @return The vector of fitted coefficients
#' @author Vincenzo Lagani

#generic method
setGeneric(
  name = "getCoefficients",
  def = function(object){standardGeneric("getCoefficients")}
)

#specific method
setMethod(
  f = 'getCoefficients',
  signature = c('linmod'),
  definition=function(object){
    return(object@coefficients)
  }
)
