rm(list = ls())
setwd("C:/Users/KASUTAJA/Documents/RLadies/2017-2018 season/shiny_sopho")
install.packages("shiny") ##shiny paketi gvaZlevs Shesadzleblobas vimuSaopt veb 
                         ##gverdis aplikaciaze R studiashi
library("shiny")
runExample("01_hello")

ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)


## identipikacia rom es aris applikaciis faili
## aplikaacis gamortva da cvlilebisbi ganxorcileba
## aplikaciis gaxsna calke folderebad

###        UI 
#h1() function for a top-level header 
# h2() for a secondary header 
#strong() to make text bold 
#em() to make text italicized

#br() for a line break
#img() for an image
#a() for a hyperlink
#textInput()
#numericInput()
#dateInput()
#selectInput()


### Server

## 1.Save the output object into the output list (remember the app template - every server function has an output argument)
## 2.Build the object with a render* function, where * is the type of output
## 3.Access input values using the input list (every server function has an input argument)

#################################################################################

ui <- fluidPage(                                         ## render the text
  titlePanel( "ra satauri minda qondes slide bars"),
  sidebarLayout(
    sidebarPanel("input year here"),
    mainPanel("the results will go here")   
    
                                            # After creating all the inputs, 
                                            # we should add elements to the UI to display the outputs. 
                                            # Outputs can be any object that R creates and that we want to display in our app - such as a plot, a table, or text.  
  )
)


if (interactive()) {
  
  ui <- fluidPage(
    numericInput("obs", "Observations:", 5, min = 1, max = 50),
    verbatimTextOutput("value")
  )
  server <- function(input, output) {
    output$value <- renderText({ input$obs })
  }

  shinyApp(ui, server)
}
############ Ui s elementebis sheqma dinamikurad
ui <- fluidPage(
  numericInput("num", "Maximum slider value", 10),
  uiOutput("slider")
)

server <- function(input, output) {
  output$slider <- renderUI({
    sliderInput("slider", "Slider", min = 0,
                max = input$num, value = 0)
  })
}

shinyApp(ui = ui, server = server)


###################################################################################3
##### Hello Shiny
#####################################################################################
View(faithful)
dim(faithful)
?faithful
# ganvsazrvrot UI aplikaciisatvis romelic gamogvitan histograms ----

ui <- fluidPage(
  
  # App satauri ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar sheqmna rom chavwerot damatebiti inpormacia inputze and outputes ganmartebaze ----
  sidebarLayout(
    
    # Sidebar panel inputsatvis ----
    sidebarPanel(
      
      # Input: Slider-- the number of bins ----
      sliderInput(inputId = "bins", #this is very important
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    # ra dziritadi machvenebeli unda gamoivtanot ekranze ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

# ganvsazrvrot server-is funqcia romelsac gamoivtant histogram ze ----
dim(faithful)
View(faithful)
server <- function(input, output) {
  # Histogram of the Old Faithful Geyser Data ----
  # historgrama sheicvleba avtomaturad rogroc ki  shevcvlit  bin -ebis raodenobas:
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting #choose your x
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}
shinyApp(ui = ui, server = server)
myshiny <-shinyApp(ui = ui, server = server)
print(myshiny)
getwd()
 #########################################################################

##our first projection function
##sp_rATE-simple projection with crude growth rate 
sp_rate <- function(n = NULL, N0 = NULL, rate = NULL){
  NN <- rep(NA, times = n+1)
  NN[1] <- N0
  for(i in 1:n){ #for each cycle want the same formula
    NN[i+1] <- NN[i] * (1 + rate) #this is the growth rate formula
  }
  return(NN)
}

##
##run the projection model a couple of times
##
#Population 0
pp0 <- sp_rate(n = 20, N0 = 100, rate = 0.05)
pp0

pp1 <- sp_rate(n = 20, N0 = 110, rate = 0.03)
pp1

pp2 <- sp_rate(n = 20, N0 = 110, rate = 0.02)
pp2

#Life expectancy
#21 bc we got 21 population outputs at pp0, pp1, pp2
#ex <- seq(70,85, length = 21)
ex <- rep(c(70,75,80), length.out = 21)
ex

##
##combine results into a data_frame
##

library(tidyverse)

df0 <- data_frame("Year" = 2015:2035, "Georgia" = pp0, "France" = pp1, "Italy"= pp2,
                  "lifeexpectance" = ex)
#using a tbl not a data.frame
df0

##
##stack data to long format ready for ggplots
##

df1 <- gather(data = df0, key = Country, value = Population, -lifeexpectance, -Year)
#gather will reshape the data to a long format. (Transpose in Excel does the same)
#both key and value arguments refer to names.
#use - before a column name to signal that a column should not be stacked!
#it will be reattached after the stacking
df1

##
##plot the results
##

#in the ggplot function provide the data and basic aesthetics
library(ggplot2)
k <- ggplot(data = df1, 
       mapping = aes(x = Year, y = Population, colour = Country)) +
  #then add geoms until your heart's content
  geom_line()
k

ui <- fluidPage(
  #slider to select year
  sliderInput(inputId = "Year", label = "expected population", 
              value = 2015, step = 2, 
              min = min(df1$Year), max = max(df1$Year), sep = ""),
  selectInput("countryInput", "Country",
              choices = c("Georgia", "France", "Italy")),
  #plot server output
  plotOutput("k")
)

server <- function(input, output){
  output$k <-renderPlot({
    plot(x = df1$Year, y = df1$Population )

  })
}


shinyApp(ui = ui, server = server)
###############################
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
#might have to setwd to get the file in the same folder
View(bcl)
ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      selectInput("countryInput", "Country",
                  choices = c("CANADA", "FRANCE", "ITALY"))
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$coolplot <- renderPlot({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price >= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    ggplot(filtered, aes(Alcohol_Content)) +
      geom_histogram()
  })
}

shinyApp(ui = ui, server = server)



 #################################3
ui <- fluidPage(
  titlePanel("expected population"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "yearinput", label = "Year",
                  2015 , 2040, c(2015,2036),sep = ""),
      
      selectInput("countryInput", "Country",
                  choices = "Georgia")
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
)
library(dplyr)
server <- function(input, output) {
  output$coolplot <- renderPlot({
    filt <- df1 %>%
      filter(Year >= input$yearinput[1],
             Year <= input$yearinput[2],
             Country == input$countryInput
      )
    ggplot(filt, aes(x = Year, y = Population, colour = Country)) +
      #then add geoms until your heart's content
      geom_line()
  })
} 
shinyApp(ui = ui, server = server)


