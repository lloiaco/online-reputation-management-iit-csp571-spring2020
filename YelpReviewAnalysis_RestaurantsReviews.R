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


#
#ONLY use USA files!
#Run this script for input files....
#inputfile = "yelp_restaurants.csv"
#inputfile = "yelp_restaurants_usa.csv"
#inputfile = "yelp_restaurants_canada.csv"
#
#And for corresponding output files...
#outputfile = "yelp_restaurants_reviews.csv"
#outputfile = "yelp_restaurants_usa_reviews.csv"
#outputfile = "yelp_restaurants_canada_reviews.csv"
#

#
restaurantsdatafile = paste(filedir, "yelp_restaurants_usa.csv", sep="")
df_restaurants <- read.csv(restaurantsdatafile, 
                           sep=',',
                           stringsAsFactors=F,
                           header=T)
head(df_restaurants)
nrow(df_restaurants)
#from all restaurants (usa and canada)
#[1] 
#from restaurants in the usa only
#[1] 24824
#from restaurants in canada only
#


#
#Read in the yelp_reviews.csv data file
#

reviewsdatafile = paste(filedir, "yelp_review.csv", sep="")
df_reviews <- read.csv(reviewsdatafile, 
                       sep=',',
                       stringsAsFactors=F,
                       header=T)
head(df_reviews)

nrow(df_reviews)
#[1] 5261668


#--------------------------------------------------------------
#
#reduce the file size
# remove user_id, date, useful, funny, cool columns
#
df_reviews$user_id <- NULL
df_reviews$date <- NULL
df_reviews$useful <- NULL
df_reviews$funny <- NULL
df_reviews$cool <- NULL

#reviewssmalldatafile = paste(filedir, "yelp_reviews_small.csv", sep="")
#write.csv(df_reviews, 
#          file = reviewssmalldatafile, 
#          row.names = FALSE, 
#          col.names = TRUE,
#          sep = ",")

#---------------------------------------------------------------
# Clean the business_id in the same way the same variable
# was cleaned in the YelpReviewAnalysis_Business_DataCleaning.R script
#
# Trim leading and trailing whitespace (e.g. change "   a" to "a")
df_reviews$business_id <- trimws(df_reviews$business_id)
#
#check if business_id is "" if so replace it with NA
df_reviews$business_id <- dplyr::na_if(df_reviews$business_id, "")

# Check for NA values for the business_id variable
sum(is.na(df_reviews$business_id))
#[1] 0
#no NA values present



#Check for " " or any number of spaces as the business_id
#variable
#match between 1 and 100 whitespaces within the
#business_id. business_id's should have no white
#space
# a max of 100 should cover all possible "errors"

df_reviews <- df_reviews[ which(!grepl(pattern = " {1,100}", df_reviews$business_id)), ]
nrow(df_reviews)
#[1] 5261668
# no rows were removed due to invalid business_id's


#--------------------------------------------------------------------------
#
#we need to select only those reviews in df_reviews data frame
# that correspond (have a matching "business_id" variable)
# in the df_resturants data frame
#we do this using the code
#df_reviews[ which(df_reviews$business_id %in% df_restaurants$business_id), ]
#Since the df_reviews data frame uses most of the memory
# my computer has I must directly write the selected rows to a
# new csv file called "yelp_restaurants_reviews.csv" without
# storing the new data frame in memory first.
#
# In order to read the "yelp_restaurants_reviews.csv"
# (which is done in 
# YelpReviewAnalysis_RestaurantsReviews_DataCleansing.R)
# all memory that is currently being used must be freed up
# i.e. the R session must be restarted
# 
#



restaurantsreviewsdatafile = paste(filedir, "yelp_restaurants_usa_reviews.csv", sep="")
write.csv(df_reviews[ which(df_reviews$business_id %in% df_restaurants$business_id), ], 
          file = restaurantsreviewsdatafile, 
          row.names=F, 
          col.names=T, 
          sep=",")




