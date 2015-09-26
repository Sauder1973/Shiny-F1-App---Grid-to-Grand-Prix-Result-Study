library(shiny)
library(RCurl)


#Setting Up Global Data Points

# Pull data using FTP from site
url <- "ftp://F1World@aesius.ca/ALLF1Data.Rda"
userpwd <- "F1World@aesius.ca:F1Data!23"
bin = getBinaryURL(url, userpwd = userpwd, verbose = TRUE,
                   ftp.use.epsv = TRUE)
load(rawConnection(bin))

# Pull relevant Data
raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]
raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
#close.connection(bin)

# Construct lists used in Check Boxes
constructorFreq <- as.data.frame(table(as.character(raceStudy$constructorId)))
constructors <- constructorFreq[order(-constructorFreq$Freq),]
constructors <- as.vector(constructors$Var1)

circuitFreq <- as.data.frame(table(as.character(raceStudy$CircuitID)))
circuits <- circuitFreq[order(-circuitFreq$Freq),]
circuits <- as.vector(circuits$Var1)

driversFreq <- as.data.frame(table(as.character(raceStudy$driverId)))
drivers <- driversFreq[order(-driversFreq$Freq),]
drivers <- as.vector(drivers$Var1)

#---------------------------------------------------------------------------------------------------------------------------
# Begin SHINY APP CODE
#

 
shinyUI(pageWithSidebar(
   
  # Application title
  headerPanel("F1 Results Study - Comparing Qualifying Grid Position to Race Final Result"),
   
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("Year", 
                "Select The Last Year in Study:", 
                min = 1955, 
                max = 2015, 
                value = 2015,
                sep = ""),
    sliderInput("YearRange", 
                "Select The Number of Years to Include in the Study:", 
                min = 0, 
                max = 60, 
                value = 0,
                sep = ""),
  
    selectInput("constructorSelect", 
                     label = h3("Constructor - Top 50 Presenters"), 
                     choices = (constructors[1:50]),
                     selected = NULL),
                     #inline = TRUE),
  selectInput("circuitSelect", 
                     label = h3("Circuits - Top 50 Grand Prix By Races"), 
                     choices = (circuits[1:50]),
                     selected = NULL),
                     #inline = TRUE),
  selectInput("driverSelect", 
                     label = h3("Drivers - Top 150 Drivers by Appearance"), 
                     choices = (drivers[1:150]),
                     selected = NULL)
  ),
  
   
  # Show a plot of the generated model
  mainPanel(
    #dataTableOutput("standingsBySeason")
      tabsetPanel(
            
            tabPanel(("Scatter Plot - Variable By Year"), 
                     h4("Study for Racing Years:"),
                     verbatimTextOutput("StudyYears"),
                     plotOutput("scatterPlotNet")),
            #tabPanel("By Year",h4("Grid Position Minus Result for Date Range"),dataTableOutput("standingsBySeason")),
            tabPanel("By Constructor",h4("Constructor Grid Position Minus Result"),
                     h4("Study for Racing Years:"),
                     verbatimTextOutput("StudyYears2"),
                     h4("Ensure you have selected a Constructor from the list on the left in order to view a result"),
                     plotOutput("scatterPlotConstructor")),
            tabPanel("By Circuit",h4("Circuit Grid Position Minus Result"),
                     h4("Ensure you have selected a Circuit from the list on the left in order to view a result"),
                     plotOutput("scatterPlotCircuit")),
            tabPanel("By Drivers",h4("Driver Grid Position Minus Result"),
                     h5("Ensure you have selected a Driver from the list on the left in order to view a result"),
                     h4("Study for Driver:"),
                     verbatimTextOutput("StudyDriver"),
                     plotOutput("scatterPlotDriver"),
                     h4("The following histogram illustrates the distribution of the delta between the grid and finish.  A positive delta means the driver
                        did better than they originally qualified for"),
                     plotOutput("histogramDriver")),
            tabPanel("Acknowledgements",
                     h4("Date Source and Wrangling Methods:"), 
                     h5("The Data for this study was pulled from the Ergast motor racing results API (http://ergast.com)
                        maintained by Chris Newell.  The data wrangling in R code to pull the data from discrete yearly and race specific API calls was achieved 
                        by a single R script using modified code which casts the Ergast API from JSON to an R data.frame.  "),
                     h5("The data used in this study is a static one time extract capturing all the races from 1955 to mid year 2015 and is pulled into this Shiny App via FTP from a personal site 
                        and the rCurl library to make the connection.  This app will not update any race data after Sept 1, 2015 as it is for a submission 
                        in the Coursera Data Science Specialiation offered from Johns Hopkins University "),
                     h5("This text can be purchased and I highly recommend it especially if you are a Formula One Fan!"),
                     h5("Details are: Wrangling F1 Data With R: A Data Junkie's Guide, by Tony Hirst"),
                     h5("This book is for sale at http://leanpub.com/wranglingf1datawithr"))
))
  ))


#scatterPlotDriver
