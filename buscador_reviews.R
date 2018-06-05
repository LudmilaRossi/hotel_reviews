library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(knitr)

#Cargar datos, se comenta para que no realice todo el proceso nuevamente
#hotel.opinions<-read.csv("Hotel_Reviews.csv")
#save(hotel.opinions, file="hotelopinions.rda")

load("hotelopinions.rda")

ht<- hotel.opinions %>% 
  select(Reviewer_Nationality, Negative_Review, Average_Score, lng, lat) %>%
  group_by(Reviewer_Nationality)

my_countries <- c(levels(ht$Reviewer_Nationality))
scores <- c(sort(unique(ht$Average_Score)))



shinyUI(fluidPage(
  
  titlePanel("Dime tu nacionalidad y te dire cuales hoteles no te gustaran"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("ct", label="Country", choices = my_countries),
      selectInput("val", label="Score", choices = scores),
      actionButton("goButton", label = "Scan")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Cloud", plotOutput("cloudplot")),
        tabPanel("Map", leafletOutput("hotelmap", height = 500)),
        tabPanel("Histograma", plotOutput("Hist"))
        
      )
    )
  )
  
  
  
)
)