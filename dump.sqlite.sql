CREATE table AppleStore_description_combined AS

select * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2 
 
 UNION ALL
 
 SELECT * from appleStore_description3
 
 union ALL
 
 SELECT * FROM appleStore_description4
 
 
 **Exploratory Data Analysis**
 
 -- check the number of unique apps in both tableapplestoreAppleStore
 
 SELECT count(DISTINCT id) As UniqueAppIDs
 from AppleStore
 
 SELECT count(DISTINCT id) As UniqueAppIDs
 from AppleStore_description_combined

--check for any missing values in key fields 

select count(*) As MissingValues
From AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL

Select count(*) as MissingValues
from AppleStore_description_combined 
where app_desc is null 

--find out the number of apps per genre

SELECT prime_genre, count(*) As NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

--get an overview of the apps ratings

select min(user_rating) AS MinRating,
	   max(user_rating) As MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore


-- get the distribution of app prices 

Select 
	(price / 2) *2 AS PriceBinStart,
    ((price / 2) *2) +2 AS PriceBinEnd,
    count(*) as NumApps 
From AppleStore

GROUP by PriceBinStart
Order by PriceBinStart

**Data Analysis**
 
 ---Determine whether paid apps higher rating than free appsAppleStore


SELECT case 
			when price > 0 then 'Paid'
            Else 'Free'
        End as App_Type,
        avg(user_rating) As avg_Rating 
From AppleStore
Group by App_Type

--check if apps with more supported languages have higher ratingsAppleStore

SELECT CASE 
			When lang_num < 10 then '<10 languages'
            WHEn lang_num BETWEEN 10 and 30 then '10-30 languages'
            Else '>30 languages'
         End as language_bucket,
         avg(user_rating) As Avg_Rating
FRom AppleStore
group by language_bucket
order by Avg_Rating DESC

-- Check genres with low ratingsAppleStore
Select prime_genre,
	   avg(user_rating) As Avg_Rating
From AppleStore
GROUP By prime_genre
Order by Avg_Rating ASC
LIMIT 10

-- check if there is correlation between the length of the app description and the user rating 

SELECT CASE 
			WHEN Length(b.app_desc) <500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 Then 'Medium'
            Else 'Long'
          End as description_length_bucket,
          avg(a.user_rating) as average_rating
          
          
from 
	AppleStore as a
JOIN 
	AppleStore_description_combined as b
ON 
	a.id = b.id 
group by description_length_bucket
order by average_rating Desc
          
            

--check the top-rated apps for each genre

SELECT
		prime_genre,
        track_name,
        user_rating
from ( 
  		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		Rank() OVER(PARTITION by prime_genre order by user_rating Desc,rating_count_tot Desc) as rank
  		From 
  		applestore 
   	) AS a 
    where
    a.rank = 1


             