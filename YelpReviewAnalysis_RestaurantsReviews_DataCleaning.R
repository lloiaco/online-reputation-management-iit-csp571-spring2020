#YOU MUST fIRST GO TO 
# SESSION -> SET WORKING DIRECTORY -> TO SOURCE FILE LOCATION
# FOR THIS TO WORK!!!
setwd(getwd())

#
#NOTE: if you are working in windows you will have to 
#change the "/" to "\"! 
#
filedir = paste(getwd(),  "/data/", sep = "")
filedir
#---------------------------------------------------------------------
#Read in the yelp_restaurants.csv file
# which was generated from the 
# script YelpReviewAnalysis_Business_DataCleaning.R
#


#ONLY USE USA files!!!
#Run this script for input restaurant files....
#restaurantinputfile = "yelp_restaurants.csv"
#restaurantinputfile = "yelp_restaurants_usa.csv"
#restaurantinputfile = "yelp_restaurants_canada.csv"
#
#And for corresponding reviews files...
#restaurantsreviewsinputfile = "yelp_restaurants_reviews.csv"
#restaurantsreviewsinputfile = "yelp_restaurants_usa_reviews.csv"
#restaurantsreviewsinputfile = "yelp_restaurants_canada_reviews.csv"
#

#
restaurantsdatafile = paste(filedir, "yelp_restaurants_usa.csv", sep="")
df_restaurants <- read.csv(restaurantsdatafile, 
                          sep=',',
                          stringsAsFactors=F,
                           header=T)
head(df_restaurants)

nrow(df_restaurants)
#from restaurants in the usa only
#[1] 24824



#
#read in the restaurant reviews file
#created from YelpReviewAnalysis_RestaurantsReviews.R
#


restaurantsreviewsdatafile = paste(filedir, "yelp_restaurants_usa_reviews.csv", sep="")
df_restaurantsreviews <- read.csv(restaurantsreviewsdatafile, 
                       sep=",",
                       stringsAsFactors=F,
                       header=T)

nrow(df_restaurantsreviews)
#from restaurants in the usa only
#[1] 2572831




#
#Create a data frame which
# counts the number of rows
# for each business_id in
# the df_restaurantsreviews dataframe
#
# This number should match the
# number of reviews(review_count) listed in 
# the df_restaurants dataframe
#
# This is not a necessary requirement
# in order to perform the analysis
# but is shows consistency in the data
# set and in the data gathering method
#

df_nrestrevs <- data.frame(table(df_restaurantsreviews$business_id))
names(df_nrestrevs) <- c("business_id", "review_count")
df_nrestrevs$business_id <- as.character(df_nrestrevs$business_id)
str(df_nrestrevs)
head(df_nrestrevs)
View(df_nrestrevs)
nrow(df_nrestrevs)
#from restaurants in the usa only
#[1] 24824
#
#number of rows in the restaurant reviews file 
#matches the number of rows in the corresponding
#restaurant file!!!! Yeah!
#

#
#since the number of rows in each data frame
#are equal and the business_id has already
# been determined to be unique, if there
# are no "problems" then all types of joins
# should yield the same result.
#
#left: all rows in x, adding matching columns from y

library(dplyr)
df_consistency_test <- left_join(df_restaurants, 
                            df_nrestrevs, 
                            by = c("business_id", "review_count")
                            )
nrow(df_consistency_test)
#from restaurants in the usa only
#[1] 24824


#
#The join on business_id AND review_count
# produces the same number of rows as in the
# original dataframes!!!
# This means that the restaurant reviews file
# contains ALL of the reviews that the resturant
# file says there is for each business!
# This is an excellent consistency check!
#

#
#
#since the number of rows in each data frame
#are equal and the business_id has already
# been determined to be unique, if there
# are no "problems" then all types of joins
# should yield the same result.
# Checking...
#
df_consistency_test2 <- right_join(df_restaurants, 
                                 df_nrestrevs, 
                                 by = c("business_id", "review_count")
)
nrow(df_consistency_test2)
#from restaurants in the usa only
#[1] 24824
#....Same result!

#------------------------------------------------------------------
#
#examine the number of stars (USA ONLY!)
#

tbl_stars <- table(df_restaurantsreviews$stars)
tbl_stars
#1       2       3       4       5 
#293205  243886  335760  675127 1024853 


library(ggplot2)


starfreq <- ggplot(data=df_restaurantsreviews, aes(df_restaurantsreviews$stars))

starfreq + geom_bar()

#geom_histogram(breaks=seq(20, 50, by=2), 
#               col="red", 
#               fill="green", 
#               alpha = .2) + 
#  labs(title="Histogram for Age", x="Age", y="Count") + 
#  xlim(c(18,52)) + 
#  ylim(c(0,30))


#
#Balance the data samples
#and save them to files
#
starnames <- dimnames(tbl_stars)[[1]]
totalrows <- min(tbl_stars)
totalrows
#[1] 243886
for(i in starnames)
{
  set.seed(1)
  #note: starnames is a char vector, i is a char
  
  #create a subset of the review data
  #with only "i" stars
  df_restaurantsreviews_nstars <- df_restaurantsreviews[ which(df_restaurantsreviews$stars == as.integer(i)), ]
  nrows <- nrow(df_restaurantsreviews_nstars)
  
  if(nrows > totalrows)
  {
    #sample the data with nstars = i
    starSampleIndex <- sample(nrow(df_restaurantsreviews_nstars), size = totalrows, replace = FALSE)
    df_restaurantsreviews_nstars <- df_restaurantsreviews_nstars[starSampleIndex, ]
  }
  
  
  
  print(nrow(df_restaurantsreviews_nstars))
  # 1 star
  #[1] 243886
  # 2 star
  #[1] 243886
  # 3 star
  #[1] 243886
  # 4 star
  #[1] 243886
  # 5 star
  
  
  #
  #now create training and testing samples for each star rating
  #
  #alot 80% of the rows for training and 20% of the rows for testing
  trainPct <- 0.8
  testPct <- 1 - trainPct
  
  starSampleIndexTRAIN <- sample(nrow(df_restaurantsreviews_nstars), 
                                 size = trainPct * nrow(df_restaurantsreviews_nstars), 
                                 replace = FALSE)
  #replace = False means only want an observation to up one time, i.e. each
  #observation should be in the Train or the Test and only show up once
  df_restaurantsreviews_nstars_TRAIN <- df_restaurantsreviews_nstars[starSampleIndexTRAIN, ]
  df_restaurantsreviews_nstars_TEST <- df_restaurantsreviews_nstars[-starSampleIndexTRAIN, ]

  # Always check key assumptions like below!!!
  stopifnot(nrow(df_restaurantsreviews_nstars_TRAIN) + nrow(df_restaurantsreviews_nstars_TEST) == nrow(df_restaurantsreviews_nstars))
  print(nrow(df_restaurantsreviews_nstars_TRAIN))
  #[1] 195108
  print(nrow(df_restaurantsreviews_nstars_TEST))
  #[1] 48778
  print(nrow(df_restaurantsreviews_nstars))
  #[1] 243886
  
  
  
  restaurantsreviewsdatafile_nstars_TRAIN = paste(filedir, "yelp_restaurants_usa_", i, "star_reviews_TRAIN.csv", sep="")
  write.csv(df_restaurantsreviews_nstars_TRAIN,
            file = restaurantsreviewsdatafile_nstars_TRAIN,
            row.names = FALSE, 
            col.names = TRUE,
            sep = ",")
  
  restaurantsreviewsdatafile_nstars_TEST = paste(filedir, "yelp_restaurants_usa_", i, "star_reviews_TEST.csv", sep="")
  write.csv(df_restaurantsreviews_nstars_TEST,
            file = restaurantsreviewsdatafile_nstars_TEST,
            row.names = FALSE, 
            col.names = TRUE,
            sep = ",")
}

#*****************************************************************





#*****************************************************************


