# RSNNS Examples
# ftp://ftp.sas.com/pub/neural/FAQ2.html#A_art - genaral nunet info
library("RSNNS", lib.loc="~/R/win-library/3.2")

# demo() # See all the demos in R 
# Load the Data (more data @  http://sci2s.ugr.es/keel/datasets.php)
data("snnsData") 
laser <- snnsData$laser_1000.pat 

# Spliting the Data 
inputs <- laser[,inputColumns(laser)] # Extracts all columns from a matrix whose column names begin with "in"
targets <- laser[,outputColumns(laser)] # Extracts all columns from a matrix whose column names begin with "out"
# Split the input data (1000) into train (850) and test (150) specified by the argument ratio=0.15
patterns <- splitForTrainingAndTest(inputs, targets, ratio = 0.15)

# Plot the data
plot(c(0,100),c(0,0.8),type = "n",xlab = "Index", ylab = "Values",main = "Data")
lines(inputs[1:100],col="black",lwd=2.5) # Plot Data 1
lines(targets[1:100],col="blue",lwd=2.5) # Plot Data 2
legend(0.0,0.8, # places a legend at the appropriate place 
       c("inputs","targets"), # puts text in the legend
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),col=c("black","blue")) # gives the legend lines the correct color and width


### ---- Example: 1. Regression with recurrent neural networks  ----
# The use of an Elman network (Elman 1990) for time series regression. 
model <- elman(patterns$inputsTrain, patterns$targetsTrain,
               size = c(8, 8), learnFuncParams = c(0.1), maxit = 500,
               inputsTest = patterns$inputsTest, targetsTest = patterns$targetsTest,
               linOut = FALSE)

# input data and fitted values can be visualized in the following way:
# Plot the data
plot(c(0,100),c(0,0.9),type = "n",xlab = "Index", ylab = "Values",main = "Data")
lines(inputs[1:100],col="black",lwd=2.5) # Plot Data 1 - Train 
lines(targets[1:100],col="blue",lwd=2.5) # Plot Data 2 - Targets
lines(model$fitted.values[1:100], col = "red",lwd=2.5)  # Plot Data 3 predicted
legend(2.5,0.9, # places a legend at the appropriate place 
       c("inputs","targets","modeled"), # puts text in the legend
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),col=c("black","blue","red")) # gives the legend lines the correct color and width

plot(c(0,150),c(0,0.9),type = "n",xlab = "Index", ylab = "Values",main = "Data")
# lines(inputs[1:100],col="black",lwd=2.5) # Plot Data 1 - Train 
lines(targets[851:1000],col="blue",lwd=2.5) # Plot Data 2 - Targets
lines(model$fittedTestValues, col = "red",lwd=2.5)  # Plot Data 3 predicted
legend(2.5,0.9, # places a legend at the appropriate place 
       c("Test targets","Test modeled"), # puts text in the legend
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),col=c("blue","red")) # gives the legend lines the correct color and width

# Plot Errors
# Regression plot for the training data, showing an optimal linear fit (black), and linear fit to the training data (red).
plotRegressionError(patterns$targetsTrain, model$fitted.values)
# Regression plot for the test data. 
plotRegressionError(patterns$targetsTest, model$fittedTestValues)



