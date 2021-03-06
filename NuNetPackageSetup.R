## Class 8 Code

# Module 4 Code

### --- Example 1: Analyze WebSPHINX results. --------
library(XML)
HTML.dataset <- list.files(dir,pattern ="html") # List of all saved HTML files @ location "dir"

# Function to strip the table data from the HTML files
sieve.HTML <- function(URL) {
  table <- readHTMLTable(URL) # Read HTML table into a list
}

temp.HTML.text <- lapply(HTML.dataset,function(x) sieve.HTML(x)) # Get all the text from the saved HTMLs

query <- "Boston Bruins"
temp <- grep(query, temp.HTML.text[[1]][[1]]$Champion)
# [1]  5 51 53 82 84 94
temp.HTML.text[[1]][[1]]$Season[temp]


### --- Example 2: Retrieving Financial Data from EDGAR. --------
library(XML)

SearchQuery <- "FRONTLINE LTD"

HTML.dataset <- paste0("http://www.sec.gov/cgi-bin/browse-edgar?company=",
                       SearchQuery,"&owner=exclude&action=getcompany")

# Function to strip the table data from the HTML files
sieve.HTML <- function(URL) {
  table <- readHTMLTable(URL) # Read HTML table into a list
}

temp.HTML.text <- lapply(HTML.dataset,function(x) sieve.HTML(x)) # 

Tab.Names <- names(temp.HTML.text[[1]][[3]]) # Tab Names in the HTML
# [1] "Filings"          "Format"           "Description"      "Filed/Effective"  "File/Film Number"
query <- "Interactive Data" # To search for
temp<-grep(query, temp.HTML.text[[1]][[3]]$Format)
Filings.Number <- temp.HTML.text[[1]][[3]]$"Filings"[temp] # Filings Number
Effective.Dates <- temp.HTML.text[[1]][[3]]$"Filed/Effective"[temp] # Effective File Dates 
File.Number <- temp.HTML.text[[1]][[3]]$"File/Film Number"[temp] # File Number 

query <- "Report of foreign issuer"
temp<-grep(query, temp.HTML.text[[1]][[3]]$Description)


### --- Example 3: Access Current Movies Showtimes. --------
library("rvest")
movies <- read_html("http://www.coolidge.org/showtimes/")
titles <- html_nodes(movies, 
                     "#view-id-external_showtime_date_browser-page div.film-event-title")
html_text(titles) # Display Current Movies
# [1] "Eye in the Sky "          "Hello, My Name is Doris " "Midnight Special "        "The Clan "  


### --- Example 4: Access XML File. --------
## sequencing.xml file content
# <data>
#   <sequence id = "ancestralSequence"> 
#   <taxon id="test1">Taxon1
# </taxon>       
#   GCAGTTGACACCCTT
# </sequence>
#   <sequence id = "currentSequence"> 
#   <taxon id="test2">Taxon2
# </taxon>       
#   GACGGCGCGGAccAG
# </sequence>
#   </data>

pth <- file.path("c:", "Users", "ZlatkoFCX","Documents","My Files","Teachng","2016","CS688","Web Scrapping","Scrapping") # Set Your Path
library(XML)
# read XML File located in folder "pth"
x = xmlParse(file.path(pth,"sequencing.xml"))

# returns a *list* of text nodes under "sequence" tag
nodeSet = xpathApply(x,"//sequence/text()")

# loop over the list returned, and get and modify the node value:
zz<-sapply(nodeSet,function(G){
  text = paste("Ggg",xmlValue(G),"CCaaTT",sep="")
  text = gsub("[^A-Z]","",text)
  xmlValue(G) = text
})


### --- Example 5: Access XML File. --------


### --- Example 6: Web Mining News. --------
library("tm")
library(tm.plugin.webmining) # Framework for text mining.
result <- WebCorpus(GoogleNewsSource("Web Analytics"))

library("tm")
library("tm.plugin.webmining")
googlenews <- WebCorpus(GoogleNewsSource("US economy", since="1-1-2015", until="31-1-2015"))


### --- Example 7: Analyze WebSPHINX results. --------
# Save these 2 files separately in the same folder
# Example: Shiny app that search "YahooNewsSource" for a keyword that we specify
# server.R 
library(shiny)
library(tm)
library(tm.plugin.webmining)
# Define server logic required to implement search
shinyServer(function(input, output) {
  output$text1 <- renderUI({ 
    Str1 <- paste("You have selected:", input$select)
    Str2 <- paste("and searched for:", input$text.Search)
    result <- WebCorpus(YahooNewsSource(input$text.Search))
    dataOutput <- paste("<li>",strong(meta(result[[1]])$heading),"</li>") # Get the first result
    Str3 <- paste("Search Results:", dataInput)
    HTML(paste(Str1, Str2, "Search Results:", dataOutput, sep = '<br/>'))
  })
})

# Example 7: Shiny app that search "YahooNewsSource" for a specify  search query 
# ui.R 
library(shiny)

# Define UI for application 
shinyUI(fluidPage(
  titlePanel("News Search App"),   # Application title (Panel 1)
  
  sidebarLayout(    		# Widget (Panel 2)
    sidebarPanel(h3("Search panel"),
                 # Search for
                 textInput("text.Search", label = h5("Search for"), 
                           value = " Web Analytics"),                 
                 # Where to search 
                 selectInput("select",
                             label = h5("Choose Data Source"),
                             choices = c("YahooNewsSource", "GoogleNewsSource"),
                             selected = "Yahoo! News"),
                 # Start Search
                 submitButton("Results")
    ),
    # Display Panel (Panel 3)
    mainPanel(                   
      h1("Display Panel",align = "center"),
      htmlOutput("text1")
    )
  )
))


### --- Example 8: Search Wikipedia web pages. --------
# Save these 3 files separately in the same folder (Related to HW#4)
# Example: Shiny app that search Wikipedia web pages
# File: ui.R 
library(shiny)
titles <- c("Web_analytics","Text_mining","Integral", "Calculus", 
            "Lists_of_integrals", "Derivative","Alternating_series",
            "Pablo_Picasso","Vincent_van_Gogh","Lev_Tolstoj","Web_crawler")
# Define UI for application 
shinyUI(fluidPage(
  # Application title (Panel 1)
  titlePanel("Wiki Pages"), 
  # Widget (Panel 2) 
  sidebarLayout(
    sidebarPanel(h3("Search panel"),
                 # Where to search 
                 selectInput("select",
                             label = h5("Choose from the following Wiki Pages on"),
                             choices = titles,
                             selected = titles, multiple = TRUE),
                 # Start Search
                 submitButton("Results")
    ),
    # Display Panel (Panel 3)
    mainPanel(                   
      h1("Display Panel",align = "center"),
      plotOutput("distPlot")
    )
  )
))


# Example 8: Shiny app that search Wikipedia web pages
# File: server.R 
library(shiny)
library(tm)
library(stringi)
library(proxy)
source("WikiSearch.R")

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({ 
    result <- SearchWiki(input$select)
    plot(result, labels = input$select, sub = "",main="Wikipedia Search")
  })
})


# Example 8: Shiny app that search Wikipedia web pages
# File: WikiSearch.R
library(tm)
library(stringi)
library(proxy)
SearchWiki <- function (titles) {
  wiki.URL <- "http://en.wikipedia.org/wiki/"
  articles <- lapply(titles,function(i) stri_flatten(readLines(stri_paste(wiki.URL,i)), col = " "))
  docs <- Corpus(VectorSource(articles)) # Get Web Pages' Corpus
  remove(articles)
  # Text analysis - Preprocessing 
  transform.words <- content_transformer(function(x, from, to) gsub(from, to, x))
  temp <- tm_map(docs, transform.words, "<.+?>", " ")
  temp <- tm_map(temp, transform.words, "\t", " ")
  temp <- tm_map(temp, PlainTextDocument)
  temp <- tm_map(temp, stripWhitespace)
  temp <- tm_map(temp, removeWords, stopwords("english"))
  temp <- tm_map(temp, removePunctuation)
  temp <- tm_map(temp, stemDocument, language = "english") # Perform Stemming
  remove(docs)
  # Create Dtm 
  dtm <- DocumentTermMatrix(temp) # Document term matrix
  dtm <- removeSparseTerms(dtm, 0.4) # Reduce Document term matrix
  docsdissim <- dist(as.matrix(dtm), method = "cosine") # Distance Measure
  set.seed(0)  
  h <- hclust(as.dist(docsdissim), method = "ward.D2") # Group Results
}


### --- Example 9: Search Reuters documents. --------
reut21578 <- system.file("texts", "crude", package = "tm") # Reuters Files Location
reuters <- VCorpus(DirSource(reut21578), readerControl = list(reader = readReut21578XMLasPlain)) # Get Corpus
# Text analysis - Preprocessing with tm package functionality
temp  <- reuters 
transform.words <- content_transformer(function(x, from, to) gsub(from, to, x))
temp <- tm_map(temp, content_transformer(tolower)) # Conversion to Lowercase
temp <- tm_map(temp, stripWhitespace)
temp <- tm_map(temp, removeWords, stopwords("english"))
temp <- tm_map(temp, removePunctuation)
# Create Document Term Matrix 
dtm <- DocumentTermMatrix(temp)






















