# online-reputation-management-iit-csp571-spring2020

#
#-------Notes on Data Files--------
#

#The original data files
#yelp_business.csv
#yelp_business_attributes.csv
#yelp_review.csv
#can be downloaded from
#https://www.kaggle.com/yelp-dataset/yelp-dataset/version/6
#they are to large to store in this repository  

#The yelp_restaurants_usa_reviews.csv file which is
# generated from YelpReviewAnalysis_RestaurantReviews.R
# is too large to store in git as well.
#Use the script YelpReviewAnalysis_RestaurantReviews.R
# to create it from the yelp_restaurants_usa.csv data file
# and the yelp_review.csv downloaded from 
# https://www.kaggle.com/yelp-dataset/yelp-dataset/version/6

#
#---------------------------
#

#
#------Notes on Scripts------
#

#
#YelpReviewAnalysis_Business_DataCleaning.R
#
#Reads in the orginial yelp_business.csv
#Selects only business categorized as "Restaurants"
#Cleans the "business_id" key, ensures it is a
# unique identifier
#Removes businesses with less than 10 reviews
#Separates businesses in Canada and the US.
#Saves a file which are restaurants in the US
# having 10 or more reviews into the file
# yelp_restaurants_usa.csv 
#

#
#YelpReviewAnalysis_RestaurantReviews.R
#
#Reads in "yelp_restaurants_usa.csv" 
# and "yelp_review.csv".
#The review file is very large and reading
# both in will take around 4g of RAM
#Removes columns user_id, date, useful
# funny and cool from the reviews dataframe
# in order to reduce the output file size.
#"yelp_restaurants_usa_reviews.csv"
#Selects rows from the review file which
# have a "business_id" that matches a
# row(business_id) in the 
# "yelp_restaurants_usa.csv" file.
#Writes resultant data frame to 
# yelp_restaurants_usa_reviews.csv
# (see comment above
# regarding this file; it is very large)
#

#
#YelpReviewAnalysis_RestaurantReviews_DataCleaning.R
#
#Reads in the yelp_restaurants_usa.csv file
#Reads in the yelp_restaurants_usa_reviews.csv file
#Counts the number of reviews for each business_id
# and compares this number to the corresponding
# business "review_count" attribute from the
# yelp_restaurants_usa.csv file. These numbers 
# are identical! This ensures that the review
# file contains all of the reviews for each
# business listed in the retuaurants file.
#Balances the review data over the "stars" by
# sampling the reviews grouped by "stars" 
# according to the "stars" data set with the 
# smallest number of rows/reviews
#From the Balanced "stars" data sets generates
# training and test data sets using a 80/20
# split for each "star"" data set
#Saves the result to the files...
# yelp_restaurants_usa_Nstar_reviews_TRAIN.csv"
# and
# yelp_restaurants_usa_Nstar_reviews_TEST.csv"
# where N = 1, 2, 3, 4 and 5
#These files are to be used for the data analysis!
#




#
#---------------------------
#



