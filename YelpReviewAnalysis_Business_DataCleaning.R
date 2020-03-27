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

    

origbusinessdatafile = paste(filedir, "yelp_business.csv", sep="")
df_business <- read.csv(origbusinessdatafile, 
                          sep=',',
                          stringsAsFactors=F,
                          header=T)
View(df_business)

  
#*****************************************************************
#
#Try to limit the selection to restaurants that only have
#table service. Since table service is a big part of the 
#customer experience.
#
#origbusinessattdatafile = paste(filedir, "yelp_business_attributes.csv", sep="")
#df_business_att <- read.csv(origbusinessattdatafile, 
#                        sep=',',
#                        stringsAsFactors=F,
#                        header=T)
#View(df_business_att)
#table(df_business_att$RestaurantsTableService)
#False     Na   True 
# 1490 149757    794 
#df_restaurants <- df_business_att[ which(df_business_att$RestaurantsTableService == "True"), ]
#nrow(df_restaurants)

#There are too few "restaurants with Table Service", most likely
#this attribute is not accurately reported on since most values
#are NA. Using this attribute to limit the data set to restaurants
#that have table service will not work
#
#*****************************************************************



#*****************************************************************
#Use the "df_business$categories" attribute to select only those
#businesses that are categorized as "Restaurants" this will be the
#data set of "Restaurants"
df_restaurants <- df_business[ which(grepl("Restaurants", df_business$categories, ignore.case = 'True')), ]
nrow(df_restaurants)
#[1] 54618
#
#Include only those restaurants that have 10 or more reviews in
#order to remove any issues that might be involved with a resturant 
#having few reviews, e.g. it is very new or it is not legitimate
df_restaurants <- df_restaurants[ which(df_restaurants$review_count > 9), ]
nrow(df_restaurants)
#[1] 36257

View(df_restaurants)
#
#*****************************************************************



#*****************************************************************
#Examine the data...
#
#Check for duplicate "business_ids"
#unique returns a vector, data frame or array 
# like x but with duplicate elements/rows removed.
stopifnot(nrow(df_restaurants) == length(unique(df_restaurants$business_id)))
#
#
# Trim leading and trailing whitespace (e.g. change "   a" to "a")
df_restaurants$business_id <- trimws(df_restaurants$business_id)

#check if business_id is "" if so replace it with NA
df_restaurants$business_id <- dplyr::na_if(df_restaurants$business_id, "")

# Check for NA values for the business_id variable
sum(is.na(df_restaurants$business_id))
#[1] 0
#no NA values present



#Check for " " or any number of spaces as the business_id
#variable
#match between 1 and 100 whitespaces within the
#business_id. business_id's should have no white
#space
# a max of 100 should cover all possible "errors"

df_restaurants <- df_restaurants[ which(!grepl(pattern = " {1,100}", df_restaurants$business_id)), ]
nrow(df_restaurants)
#[1] 46479
# no rows were removed due to invalid business_id's

#
#Check states
#By "state"
table(df_restaurants$state)
#   01    AK    AZ     B    BW     C   CHE   EDH   ELN   ESX   FIF   GLG 
#    3     1  9726     1  1314    11    25  1121     7     1     6     1 
#  HLD    IL    IN   KHL   MLN    NC    NI    NV    NY   NYK    OH    ON 
#   42   549     3     1    66  3381     6  6613     7    29  4001 11216 
#   PA   PKN    QC   RCC    SC    ST    WI   WLN   XGL 
# 3120     1  3648     1   183     5  1380     9     1 
#
#The data are a mix from the US and Canada!
#Might Canadian English be different than the United States?
#Might there be cutural differences that would skew
# the reviews between US and Canadian Restaurants?
#table(df_restaurants$postal_code)
#Canadian postal codes start with a letter while US
# postal codes start with a number. Use this to create
# a new column "country", which can later be used to
# separate the data by country if need be.  
#
#*****************************************************************


#*****************************************************************
#Add the "country" column based on the first character of the 
# "postal_code" attribute.

getCountry <- function(postalcode){
  
  if(grepl("^[A-Z]", postalcode))
  {
    #if the first character of the string is A-Z
    return("Canada")
  }
  else if(grepl("^[0-9]", postalcode))
  {
    #if the first character of the string is 0-9
    return("United States")
  }
  else
  {
    return(NA)
  }
  
}

df_restaurants$country <- sapply(df_restaurants$postal_code, FUN = getCountry)
table(df_restaurants$country)
#Canada United States 
# 11398         24824 
#
#No NA entries exist.
#*****************************************************************


#*****************************************************************
# to reduce file sizes,
# remove the "is_open" column since that just
# says if the restaurant was open for business at the
# time the data was downloaded, not if the restaurant
# was an active business or that it had gone out of business 

df_restaurants$is_open <- NULL
View(df_restaurants)



#*****************************************************************



#dont even bother to run this code
#*****************************************************************
#write the cleaned Restaurant data to a file with the col 
#headers and new columns 
#restaurantsdatafile = paste(filedir, "yelp_restaurants.csv", sep="")
#write.csv(df_restaurants, 
#          file = restaurantsdatafile, 
#          row.names = FALSE, 
#          col.names = TRUE,
#          sep = ",")

#*****************************************************************

#*****************************************************************
#US Data ONLY
#write the cleaned Restaurant data to a file with the col 
#headers and new columns 

#select only USA resturants
df_restaurants_usa <- df_restaurants[ which(df_restaurants$country=="United States"), ]
nrow(df_restaurants_usa)
#[1] 24824
# no rows were removed due to invalid business_id's


restaurantsdatafile_usa = paste(filedir, "yelp_restaurants_usa.csv", sep="")
write.csv(df_restaurants_usa, 
            file = restaurantsdatafile_usa, 
          row.names = FALSE, 
          col.names = TRUE,
          sep = ",")

#*****************************************************************



#Don't even bother to run this code
#*****************************************************************
#Canada Data ONLY
#write the cleaned Restaurant data to a file with the col 
#headers and new columns 

#select only canada resturants
#df_restaurants_canada <- df_restaurants[ which(df_restaurants$country=="Canada"), ]
#nrow(df_restaurants_canada)
#[1] 11398
# no rows were removed due to invalid business_id's


#restaurantsdatafile_canada = paste(filedir, "yelp_restaurants_canada.csv", sep="")
#write.csv(df_restaurants_canada,
#          file = restaurantsdatafile_canada,
#          row.names = FALSE, 
#          col.names = TRUE,
#          sep = ",")

#*****************************************************************











