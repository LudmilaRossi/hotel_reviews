library(rworldmap)
library(dplyr)

#APLICACION MAPAS: VISUALIZACION DE LOS HOTELES EN UN MAPA POR PUNTUACION Y PAIS
colnames(Hotel_Reviews) <- c("ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitud", "timezone", "DST")

summary(Hotel_Reviews$Average_Score)
HReviews <- subset(Hotel_Reviews, Hotel_Reviews$Average_Score>7)
summary(Hotel_Reviews$Review_Total_Negative_Word_Counts)
HReviews <- subset(Hotel_Reviews, HReviews$Review_Total_Negative_Word_Counts>24)
newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1)
points(HReviews$lng, HReviews$lat, col = "red", cex = .6)

#Removemos las palabras, simbolos y signos de los reviews que no queremos que se tomen en cuenta en el tagcloud
#Cargar datos, se comenta para que no realice todo el proceso nuevamente
#Hotel_Reviews <- read_file("Hotel_Reviews.csv")
HReviews <- subset(Hotel_Reviews, Hotel_Reviews$Negative_Review!="No Negative" & Hotel_Reviews$Reviewer_Nationality == "Germany")

BiCorpus <- Corpus(VectorSource(as.vector(Hotel_Reviews$Negative_Review)))
BiCorpus <- tm_map(BiCorpus, content_transformer(tolower))
BiCorpus <- tm_map(BiCorpus, removePunctuation) 
BiCorpus <- tm_map(BiCorpus, removeWords, stopwords('english'))

wordcloud(BiCorpus, max.words = 100, random.order = FALSE)
BiCorpus <- tm_map(BiCorpus, removeWords, c('https', 'www', 'com', 'negative', 'nothing', 'didn','asked', 'can', 'told', 'two', 'view', 'morning', 'stay', 'got', 'use', 'made', 'still', 'like', 'will', 'stayed', 'around', 'open', 'free', 'just', 'negative', 'nothing', 'don', 'bit', 'hard', 'one', 'also', 'said', 'star', 'given', 'need', 'back', 'get','took', 'find', 'although', 'problem', 'outside', 'put', 'available', 'never', 'however', 'quite', 'even', 'door', 'for', 'extra', 'hotels', 'clean', 'every', 'time', 'though', 'first', 'long', 'place', 'arrived', 'lot', 'early', 'days', 'london', 'needs', 'street', 'everything', 'city', 'way', 'paid', 'front', 'nice', 'slow', 'wasn', 'think', 'well'))
wordcloud(BiCorpus, max.words = 100, random.order = FALSE, color=brewer.pal(6,"Dark2"))


#Eliminar desde un fichero txt
BiCorpus <- readLines("remove-words.txt") # , encoding= "UTF-8"
#convierte de utf8 a ascii: BiCorpus <- iconv(BiCorpus, to= "ASCII//TRANSLIT")
BiCorpus <- tm_map(BiCorpus, removeWords, c)
wordcloud(BiCorpus, max.words = 100, random.order = FALSE, color=brewer.pal(6,"Dark2"))
#Fin eliminar desde un fiechero txt


#filtros 1
View(full)
nation=" Ireland "
hotel.opinions = full %>%
  select(Reviewer_Nationality, Negative_Review, Positive_Review) %>%
  #Filtrar los que no tienen geo coordinates
  group_by(Reviewer_Nationality, Negative_Review, Positive_Review)

irishopinions <- subset(hotel.opinions, Reviewer_Nationality == nation & Negative_Review != "No Negative")
View(irish)

BiCorpus <- Corpus(VectorSource(irishopinions$Negative_Review))
BiCorpus <- tm_map(BiCorpus, tolower)
BiCorpus <- tm_map(BiCorpus, removePunctuation) 
BiCorpus <- tm_map(BiCorpus, removeWords, stopwords('english'))
wordcloud(BiCorpus, max.words = 100, random.order = FALSE)
BiCorpus <- tm_map(BiCorpus, removeWords, c('https', 'www', 'com', 'negative', 'nothing', 'didn','asked', 'can', 'told', 'two', 'view', 'morning', 'stay', 'got', 'use', 'made', 'still', 'like', 'will', 'stayed', 'around', 'open', 'free', 'just', 'negative', 'nothing', 'don', 'bit', 'hard', 'one', 'also', 'said', 'star', 'given', 'need', 'back', 'get','took', 'find', 'although', 'problem', 'outside', 'put', 'available', 'never', 'however', 'quite', 'even', 'door', 'for', 'extra', 'hotels', 'clean', 'every', 'time', 'though', 'first', 'long', 'place', 'arrived', 'lot', 'early', 'days', 'london', 'needs', 'street', 'everything', 'city', 'way', 'paid', 'front', 'nice', 'slow', 'wasn', 'think', 'well'))
wordcloud(BiCorpus, max.words = 100, random.order = FALSE, color=brewer.pal(6,"Dark2"))
#fin filtros 1


require(RColorBrewer)
source("http://blog.revolutionanalytics.com/downloads/calendarHeat.R")

class(Hotel_Reviews$Review_Date)
Review_Date = as.Date(Hotel_Reviews$Review_Date)
class(Review_Date)

green_color_ramp = brewer.pal(9, "Greens")
calendarHeat(Hotel_Reviews$Review_Date, Hotel_Reviews$Negative_Review, varname = "Días con mayores comentarios negativos", color="green_color_ramp")

