library(shiny)
library(ggplot2)
library(RJSONIO)
library(reshape)
library(RCurl)
library(dplyr)

url <- "ftp://F1World@aesius.ca/ALLF1Data.Rda"
userpwd <- "F1World@aesius.ca:F1Data!23"
bin = getBinaryURL(url, userpwd = userpwd, verbose = TRUE,
                   ftp.use.epsv = TRUE)

load(rawConnection(bin))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

      # Print Label Sections
      
      output$StudyYears <- renderText({paste((input$Year - input$YearRange)," To ",input$Year) })
      output$StudyYears2 <- renderText({paste((input$Year - input$YearRange)," To ",input$Year) })
      output$StudyDriver <- renderText({paste((input$driverSelect)) })

      #-------------------------------------------------------------------------------------------------
      # Yearly Study Work
      output$scatterPlotNet <- renderPlot({
            raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]
            raceStudy <- subset(raceStudy, raceStudy$Year <= input$Year & CompleteRacesMaster$Year >= input$Year-input$YearRange)
            raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
            freqData <- as.data.frame(table(raceStudy$pos, raceStudy$grid))
            names(freqData) <- c("Posn", "Grid", "freq")
            freqData$Posn <- as.numeric(as.character(freqData$Posn))
            freqData$Grid <- as.numeric(as.character(freqData$Grid))
            
            # filter to only meaningful combinations
            g <- ggplot(filter(freqData, freq > 0), aes(x = Grid, y = Posn))
            g <- g + scale_size(range = c(2, 20), guide = "none" )
            # plot grey circles slightly larger than data as base (achieve an outline effect)
            g <- g + geom_point(colour="grey50", aes(size = freq+10, show_guide = FALSE))
            # plot the accurate data points
            g <- g + geom_point(aes(colour=freq, size = freq*10))
            # change the color gradient from default to lightblue -> $red
            g <- g + scale_colour_gradient(low = "lightblue", high="red")
            
            g<-g + xlim(1, 25) + ylim(1,25)
            g<- g + geom_smooth()
            g<- g + geom_smooth(method = lm)            # Add a loess smoothed fit curve with confidence region
            g <- g + geom_abline(slope=1, intercept=0)
            g
      })
      
      #-------------------------------------------------------------------------------------------------
      # Contstructor Work
      output$scatterPlotConstructor <- renderPlot({
            raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]

                              
      raceStudy <- subset(raceStudy, raceStudy$Year <= input$Year 
                              & CompleteRacesMaster$Year >= input$Year-input$YearRange
                              & raceStudy$constructorId == input$constructorSelect)
      

      if (nrow(raceStudy)>0){                  
            raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
            freqData <- as.data.frame(table(raceStudy$pos, raceStudy$grid))
            names(freqData) <- c("Posn", "Grid", "freq")
            freqData$Posn <- as.numeric(as.character(freqData$Posn))
            freqData$Grid <- as.numeric(as.character(freqData$Grid))
            
            # filter to only meaningful combinations
            g <- ggplot(filter(freqData, freq > 0), aes(x = Grid, y = Posn))
            g <- g + scale_size(range = c(2, 20), guide = "none" )
            # plot grey circles slightly larger than data as base (achieve an outline effect)
            g <- g + geom_point(colour="grey50", aes(size = freq+10, show_guide = FALSE))
            # plot the accurate data points
            g <- g + geom_point(aes(colour=freq, size = freq*10))
            # change the color gradient from default to lightblue -> $red
            g <- g + scale_colour_gradient(low = "lightblue", high="red")
            
            g<-g + xlim(1, 25) + ylim(1,25)
            #g<- g + geom_smooth()
            g<- g + geom_smooth(method = lm)            # Add a loess smoothed fit curve with confidence region
            g <- g + geom_abline(slope=1, intercept=0)
            g
      } else {
            print("Sorry - the selection of Year and Constructor is not yielding any results.")
      }
            
            
      })
      
      #-------------------------------------------------------------------------------------------------
      # Circuit Work
      output$scatterPlotCircuit <- renderPlot({
            raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]
            
            
            raceStudy <- subset(raceStudy, raceStudy$Year <= input$Year 
                                & CompleteRacesMaster$Year >= input$Year-input$YearRange
                                & raceStudy$CircuitID == input$circuitSelect)
            
            
            if (nrow(raceStudy)>0){                  
                  raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
                  freqData <- as.data.frame(table(raceStudy$pos, raceStudy$grid))
                  names(freqData) <- c("Posn", "Grid", "freq")
                  freqData$Posn <- as.numeric(as.character(freqData$Posn))
                  freqData$Grid <- as.numeric(as.character(freqData$Grid))
                  
                  # filter to only meaningful combinations
                  g <- ggplot(filter(freqData, freq > 0), aes(x = Grid, y = Posn))
                  g <- g + scale_size(range = c(2, 20), guide = "none" )
                  # plot grey circles slightly larger than data as base (achieve an outline effect)
                  g <- g + geom_point(colour="grey50", aes(size = freq+10, show_guide = FALSE))
                  # plot the accurate data points
                  g <- g + geom_point(aes(colour=freq, size = freq*10))
                  # change the color gradient from default to lightblue -> $red
                  g <- g + scale_colour_gradient(low = "lightblue", high="red")
                  
                  g<-g + xlim(1, 25) + ylim(1,25)
                  #g<- g + geom_smooth()
                  g<- g + geom_smooth(method = lm)            # Add a loess smoothed fit curve with confidence region
                  g <- g + geom_abline(slope=1, intercept=0)
                  g
            } else {
                  print("Sorry - the selection of Year and Constructor is not yielding any results.")
            }
            
            
      })     
      
      
      #-------------------------------------------------------------------------------------------------
      # Driver Work
      output$scatterPlotDriver <- renderPlot({
            
            raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]
            raceStudy <- subset(raceStudy, raceStudy$driverId == input$driverSelect)
            
            
            if (nrow(raceStudy)>0){                  
                  raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
                  freqData <- as.data.frame(table(raceStudy$pos, raceStudy$grid))
                  names(freqData) <- c("Posn", "Grid", "freq")
                  freqData$Posn <- as.numeric(as.character(freqData$Posn))
                  freqData$Grid <- as.numeric(as.character(freqData$Grid))
                  
                  # filter to only meaningful combinations
                  g <- ggplot(filter(freqData, freq > 0), aes(x = Grid, y = Posn))
                  g <- g + scale_size(range = c(2, 20), guide = "none" )
                  # plot grey circles slightly larger than data as base (achieve an outline effect)
                  g <- g + geom_point(colour="grey50", aes(size = freq+10, show_guide = FALSE))
                  # plot the accurate data points
                  g <- g + geom_point(aes(colour=freq, size = freq*10))
                  # change the color gradient from default to lightblue -> $red
                  g <- g + scale_colour_gradient(low = "lightblue", high="red")
                  
                  g<-g + xlim(1, 25) + ylim(1,25)
                  #g<- g + geom_smooth()
                  g<- g + geom_smooth(method = lm)            # Add a loess smoothed fit curve with confidence region
                  g <- g + geom_abline(slope=1, intercept=0)
                  g
            } else {
                  print("Sorry - the selection of Year and Constructor is not yielding any results.")
            }
            
            
      })  
      
      output$histogramDriver <- renderPlot({
            
            
            raceStudy <- CompleteRacesMaster[,c("Year","CircuitID","driverId","constructorId","grid","pos")]
            raceStudy <- subset(raceStudy, raceStudy$driverId == input$driverSelect)
            
            
            if (nrow(raceStudy)>0){                  
                  raceStudy$gridDelta <- raceStudy$grid - raceStudy$pos 
                  freqData <- as.data.frame(table(raceStudy$pos, raceStudy$grid))
                  names(freqData) <- c("Posn", "Grid", "freq")
                  freqData$Posn <- as.numeric(as.character(freqData$Posn))
                  freqData$Grid <- as.numeric(as.character(freqData$Grid))
      
            histDriver <- NULL
            histDriver <- ggplot(raceStudy, aes(x=gridDelta)) 
            histDriver <- histDriver + geom_histogram() 
            #histDriver <- histDriver + geom_histogram(aes(y = ..density..)) + geom_density() 
            histDriver <- histDriver + geom_bar(binwidth = 1)
            histDriver <- histDriver + facet_wrap(~constructorId)
            histDriver <- histDriver + geom_histogram(aes(fill = ..count..))
            histDriver    
            }
      })
      #histogramDriver
      
      
      
})