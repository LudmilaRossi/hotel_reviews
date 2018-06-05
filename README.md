# Europe Hotels negative reviews

The objective of this dataset is to discover through the negative comments of hotels clients in Europe, what services and / or facilities they liked less according to their nationality. On the one hand, the display of negative words is through a "tagcloud" application, and on the other hand, users can search and see according to their nationality which hotels might not like them according to this analysis.

## Acknowledgements
The data was scraped from Booking.com. All data in the file is publicly available to everyone already. Data is originally owned by Booking.com. Please contact me through my profile if you want to use this dataset somewhere else.

## Data Context
This dataset contains 515,000 customer reviews and scoring of 1493 luxury hotels across Europe. Meanwhile, the geographical location of hotels are also provided for further analysis.

## Data Content
### The csv file contains 17 fields. The description of each field is as below:

- Hotel_Address: Address of hotel.
- Review_Date: Date when reviewer posted the corresponding review.
- Average_Score: Average Score of the hotel, calculated based on the latest comment in the last year.
- Hotel_Name: Name of Hotel
- Reviewer_Nationality: Nationality of Reviewer
- Negative_Review: Negative Review the reviewer gave to the hotel. If the reviewer does not give the negative review, then it should be: 'No Negative'
- Review_Total_Negative_Word_Counts: Total number of words in the negative review.
- Positive_Review: Positive Review the reviewer gave to the hotel. If the reviewer does not give the negative review, then it should be: 'No Positive'
- Review_Total_Positive_Word_Counts: Total number of words in the positive review.
- Reviewer_Score: Score the reviewer has given to the hotel, based on his/her experience
- Total_Number_of_Reviews_Reviewer_Has_Given: Number of Reviews the reviewers has given in the past.
- Total_Number_of_Reviews: Total number of valid reviews the hotel has.
- Tags: Tags reviewer gave the hotel.
- days_since_review: Duration between the review date and scrape date.
- Additional_Number_of_Scoring: There are also some guests who just made a scoring on the service rather than a review. This number indicates how many valid scores without review in there.
- lat: Latitude of the hotel
- lng: longtitude of the hotel

*In order to keep the text data clean, I removed unicode and punctuation in the text data and transform text into lower case. No other preprocessing was performed.*

## Inspiration
The dataset is large and informative, I believe you can have a lot of fun with it! Let me put some ideas below to futher inspire kagglers!

- Fit a regression model on reviews and score to see which words are more indicative to a higher/lower score
- Perform a sentiment analysis on the reviews
- Find correlation between reviewer's nationality and scores.
- Beautiful and informative visualization on the dataset.
- Clustering hotels based on reviews
- Simple recommendation engine to the guest who is fond of a special characteristic of hotel.
