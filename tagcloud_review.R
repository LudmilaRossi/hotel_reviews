install.packages("leaflet")
install.packages("leaflet.extras")

library(shiny)
library(dplyr)
library(wordcloud)
library(leaflet)
library(tm)
library(leaflet.extras)
library(scales)
library(tidyr)


#CARGAR DATOS
full = read.csv('Hotel_Reviews.csv')
load("hotelopinions.rda")

shinyServer(function(input, output){
  output$cloudplot <- renderPlot({ #renderPlot dice que vamos a dibujar un plot
                                   #OBTENEMOS EL VALOR DEL ELEMENTO SELECCIONADO 
                                   #CON EL WIDGET DE INPUT (SELECTINPUT)
    
    country_label <- eventReactive(input$goButton, {
      input$ct
    })
    score_label <- eventReactive(input$goButton, {
      input$val
    })
    
    country=country_label() #Obtener el nombre del pais elegido del SELECTINPUT
                            #DESPLEGAMOS LA FUNCION QUE DIBUJA EL PLOT
    score=score_label() #DESPLEGAMOS LA FUNCION QUE DESPLIEGA EL MAPA
    
    
    #Removemos las palabras, simbolos y signos de los reviews que no queremos que se tomen en cuenta en el tagcloud
    dfs <- subset(hotel.opinions, Reviewer_Nationality == country & Negative_Review!= "No Negative" & Average_Score==score)
    text <- Corpus(VectorSource(dfs$Negative_Review))
    text <- tm_map(text, tolower)
    text <- tm_map(text, removePunctuation)
    text <- tm_map(text, removeWords, stopwords('english'))
    #BiCorpus <- tm_map(BiCorpus, stemDocument)
    text <- tm_map(text, removeWords, c('good', 'didn','like', 'nothing','just', 'negative', 'get','wasn', 'even', 'can'))
    wordcloud(text, max.words = 30, random.order = FALSE,colors=brewer.pal(6,"Dark2"))
    
  })
  
 
  output$hotelmap <- renderLeaflet({ #renderPlot dice que vamos a dibujar un mapa
    #OBTENEMOS EL VALOR DEL ELEMENTO SELECCIONADO CON EL WIDGET DE INPUT (SELECTINPUT)
    country_label <- eventReactive(input$goButton, {
      input$ct
    })
    score_label <- eventReactive(input$goButton, {
      input$val
    })
    
    country = country_label()
    score=score_label()
    
    
    #DESPLEGAMOS LA FUNCION QUE DESPLIEGA EL MAPA
    full<- subset(hotel.opinions, Negative_Review!="No Negative" & Reviewer_Nationality==country & Average_Score==score)
    #full<-full[grep("France", full$Hotel_Address), ]
    
    
    hotel.names = full %>%
      select(Hotel_Name, Hotel_Address, lat, lng, Average_Score, Total_Number_of_Reviews,
             Review_Total_Positive_Word_Counts, Review_Total_Negative_Word_Counts) %>%
      
      #Filtrar los que no tienen geo coordinates
      filter(lat != 0 & lng != 0) %>%
      group_by(Hotel_Name, Hotel_Address, lat, lng, Average_Score, Total_Number_of_Reviews) %>%
      summarise(Tot_Pos_Words = sum(Review_Total_Positive_Word_Counts),
                Tot_Neg_Words = sum(Review_Total_Negative_Word_Counts),
                Total_Words = sum(Tot_Pos_Words + Tot_Neg_Words),
                Pos_Word_Rate = percent(Tot_Pos_Words/Total_Words),
                Neg_Word_Rate = percent(Tot_Neg_Words/Total_Words))
    
    
    points <- cbind(hotel.names$lng,hotel.names$lat) #Crear un nuevo objeto 'ligando' las columnas(cbind) del dataframe anterior
    
    
    #Create Leaflet Map
    leaflet() %>% 
      addProviderTiles('OpenStreetMap.Mapnik',
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = points,
                 popup = paste0("<strong>Hotel: </strong>",
                                hotel.names$Hotel_Name,                 
                                "<br><strong>Address: </strong>", 
                                hotel.names$Hotel_Address, 
                                "<br><strong>Average Score: </strong>", 
                                hotel.names$Average_Score, 
                                "<br><strong>Number of Reviews: </strong>", 
                                hotel.names$Total_Number_of_Reviews,
                                "<br><strong>Percent Positive Review Words: </strong>",
                                hotel.names$Pos_Word_Rate),
                 clusterOptions = markerClusterOptions())
  })  
 
  output$Hist <- renderPlot({ #ubica el histograma en la pestana que defini con ese nombre en ui.R no poner caracteres especiales ni siquiera en los comentarios
    country_label <- eventReactive(input$goButton, {
      input$ct
    })
    score_label <- eventReactive(input$goButton, {
      input$val
    })
    country=country_label()
    score=score_label()
    dfs <- subset(hotel.opinions, Reviewer_Nationality == country & Negative_Review!= "No Negative" & Average_Score==score)
    
    dfs %>% #es el filtro
    group_by(Negative_Review) %>% 
    summarize(n_items = last(Review_Total_Negative_Word_Counts)) %>% 
    ggplot(aes(x=n_items))+ labs(x = "Total Negative Words") + 
    geom_histogram(stat="count",fill="black") 

  })
  
})
