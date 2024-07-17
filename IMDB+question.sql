USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Count for 'director_mapping' table = 3867
SELECT count(*) FROM director_mapping;

-- Count for 'genre' table = 14662
SELECT count(*) FROM genre;

-- Count for 'movie' table = 7997
SELECT count(*) FROM movie;

-- Count for 'name' table = 25735
SELECT count(*) FROM names;

-- Count for 'ratings' table = 7997
SELECT count(*) FROM ratings;

-- Count for 'role_mapping' table = 15615
SELECT count(*) FROM role_mapping;

-- ANSWER :
	-- Count for 'director_mapping' table = 3867
    -- Count for 'genre' table = 14662
    -- Count for 'movie' table = 7997
    -- Count for 'name' table = 25735
    -- Count for 'ratings' table = 7997
    -- Count for 'role_mapping' table = 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- First check all columns in 'movie' table
SELECT * FROM movie;
SELECT 
	SUM(ISNULL(m.id)) AS id_null_count,
    SUM(ISNULL(m.title)) AS title_null_count,
    SUM(ISNULL(m.year)) AS year_null_count,
    SUM(ISNULL(m.date_published)) AS datePublished_null_count,
    SUM(ISNULL(m.duration)) AS duration_null_count,
    SUM(ISNULL(m.country)) AS country_null_count,
    SUM(ISNULL(m.worlwide_gross_income)) AS worlwideGrossIncome_null_count,
    SUM(ISNULL(m.languages)) AS languages_null_count,
    SUM(ISNULL(m.production_company)) AS produtionCompany_null_count
FROM movie AS m;

 -- ANSWER : 
	-- country(20 null), worlwide_gross_income(3724 null), languages(194 null), production_company (528 null) --> These columns have null values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* There are two columns from which we can extract the year. 
	1. Year 
    2. date_published
*/

SELECT year AS Year,
	COUNT(id) AS number_of_movies
FROM movie 
GROUP BY Year
ORDER BY Year ASC;

SELECT YEAR(date_published) AS Year,
	COUNT(id) AS number_of_movies
FROM movie
GROUP BY YEAR(date_published)
ORDER BY YEAR(date_published) ASC;

 -- ANSWER : 
/* There are two columns from which we can extract the year. 
	1. Year 
		2017 - 3052
        2018 - 2944
        2019 - 2001
    2. date_published
		2017 - 3052
        2018 - 2944
        2019 - 2001
    After cheking both the columns data we are certain that there is no data error and both column have same kind of data
*/

SELECT MONTH(date_published) AS month_num,
	COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num ASC;

 -- ANSWER : 
-- In 2017 highest number of movies has been produced.
-- 824 movies have been produced in month of march.




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Pattern matching using LIKE operator for country column
SELECT Count(id) AS number_of_movies, 
		year
FROM   movie
WHERE  (country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
		AND year = 2019; 

 -- ANSWER :         
-- Total 1059 movies had been produced in USA or INDIA in the year of 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT (genre),
		ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT (genre))) AS genre_seq_no
FROM genre
GROUP BY genre
ORDER BY genre;

 -- ANSWER : 
/* Total 13 unique genres are present in the list
Action, Adventure, Comedy, Crime, Drama, Family, Fantasy, Horror, Mystry, Others, Romance, Sci-Fi, Thriller
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT Count(DISTINCT m.id) AS number_of_movies,
		g.genre
 FROM movie AS m
 INNER JOIN
 genre AS g
 ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY number_of_movies DESC
LIMIT 1;


 -- ANSWER : 
-- Drama is the highest number of movies produced genre. 4285 movies have been produced in Drama genre.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT count(movie_id)
FROM genre;
-- 14662 records

SELECT count(DISTINCT movie_id)
FROM genre;
-- 7997 records

 -- Analysis : 
-- It is clearly visible that there are multiple movies which belong to multiple genres.
-- We can group by the genre table based on the movie_id and find the unique number of genre each movie belongs to
-- using the with statement we will find the count of movies which belogng to only one genre

WITH one_genre_movies AS
(
SELECT movie_id,
		COUNT(genre) AS number_of_genre
FROM genre
GROUP BY movie_id
HAVING (number_of_genre = 1)
)
SELECT COUNT(*) AS one_genre_movie_count
FROM one_genre_movies;

 -- ANSWER : 
-- 3289 movies are belong to only one Genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration
 FROM movie AS m
 INNER JOIN
 genre AS g
 ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

 -- ANSWER : 
-- Action genre having the highest average duration of 112.88 mins


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre,
		COUNT(movie_id) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre;

 -- ANSWER : 
-- Earlier we have seen Drama has the highest number of movies produced and Comedy 2nd and Thriller is 3rd in the list.







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
FROM ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- check using DENSE_RANK()
SELECT m.title,
		r.avg_rating,
        DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM ratings  AS r
INNER JOIN
movie AS m
ON m.id = r.movie_id
LIMIT 10;
 
 -- ANSWER : 
-- Using Desnse Rank list looks like Kirket ,Love in Kilnerry, Gini Helida Kathe, Runam, Fan, Android Kunjappan Version 5.25,Yeh Suhaagraat Impossible,Safe,The Brighton Miracle,Shibu

-- Another approach using CTE
WITH movie_ranks_rowNumber AS
(SELECT m.title,
		r.avg_rating,
        ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM ratings  AS r
INNER JOIN
movie AS m
ON m.id = r.movie_id
)
SELECT * FROM movie_ranks_rowNumber
WHERE movie_rank <=10;

WITH movie_ranks_rowNumber AS
(SELECT m.title,
		r.avg_rating,
        ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM ratings  AS r
INNER JOIN
movie AS m
ON m.id = r.movie_id
LIMIT 3
)
SELECT ROUND(AVG(avg_rating),2)  AS rank_based_on_rating
FROM movie_ranks_rowNumber;

 -- ANSWER : 
-- TOP 3 movies has the rating of 9.93

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
	COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating DESC;

 -- ANSWER : 
-- total 2257 movies has the medain rating of  7 which is the highest of all and median rating of 1 has the lowest number of movies


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.production_company,
		COUNT(r.movie_id) AS movie_count,
        DENSE_RANK() OVER (ORDER BY (COUNT(r.movie_id)) DESC) AS prod_company_rank
FROM movie AS m 
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP  BY m.production_company;

 -- Analysis : 
-- After initial analysis it is found that production_company name is null for 21 movies hence it is better to ignore those records.alter

WITH prod_company_rank_summary AS
(
SELECT m.production_company,
		COUNT(r.movie_id) AS movie_count,
        DENSE_RANK() OVER (ORDER BY (COUNT(r.movie_id)) DESC) AS prod_company_rank
FROM movie AS m 
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
	AND 
		m.production_company IS NOT NULL
GROUP  BY m.production_company
)
SELECT * 
FROM prod_company_rank_summary
WHERE prod_company_rank = 1;

 -- ANSWER : 
-- Now as we  have got rid of the null production company records the top production companes with highest number of hit movies are
-- Dream Warrior Pictures, National Theatre Live with 3 hit movies each.



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
		COUNT(m.id) AS movie_count
FROM movie AS m
	INNER JOIN genre AS g
		ON m.id = g.movie_id
	INNER JOIN ratings as r
		ON r.movie_id = m.id
WHERE YEAR(m.date_published) = 2017 
	AND 
		MONTH(m.date_published) = 3
	AND 
		r.total_votes > 1000
	AND 
		m.country LIKE '%USA%'
GROUP BY g.genre
ORDER BY movie_count DESC;

 -- ANSWER : 
--  Highest movies number is 24 released in March 2017 in Drama Genre which received more than 2017 votes in USA
-- Top 3 genre of the movies released are Drama, Comedy, Action, Thriller in March 2017 in the USA and had more than 1,000 votes




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, 
		r.avg_rating,
		g.genre
FROM movie AS m
	INNER JOIN genre AS g
		ON m.id = g.movie_id
	INNER JOIN ratings as r
		ON r.movie_id = m.id
WHERE r.avg_rating > 8
	AND 
		m.title LIKE 'The%'
GROUP BY m.title, 
		r.avg_rating,
		g.genre
ORDER BY r.avg_rating DESC;


-- Create temp table to check few information
CREATE TABLE avg_rating_title_genre_summary AS
SELECT m.title, 
		r.avg_rating,
		g.genre
FROM movie AS m
	INNER JOIN genre AS g
		ON m.id = g.movie_id
	INNER JOIN ratings as r
		ON r.movie_id = m.id
WHERE r.avg_rating > 8
	AND 
		m.title LIKE 'The%'
GROUP BY m.title, 
		r.avg_rating,
		g.genre
ORDER BY r.avg_rating DESC;

SELECT COUNT(DISTINCT title)
FROM avg_rating_title_genre_summary;
 
 -- ANSWER : 
-- Total 8 movies are in the list which are staring with 'The'

SELECT DISTINCT title
FROM avg_rating_title_genre_summary;

 -- ANSWER : 
/* List of movies are 
	- The Brighton Miracle
    - The Colour of Darkness
    - The Blue Elephant 2
    - The Irishman
    - The Mystery of Godliness: The Sequel
    - The Gambinos
    - Theeran Adhigaaram Ondru
    - The King and I
*/
SELECT DISTINCT genre
FROM avg_rating_title_genre_summary;

 -- ANSWER : 
-- Total 7 Genre have made this to the list 
/* 
 List of Genre which have made this to the list are
	- Drama
    - Horror
    - Mystery
    - Crime
    - Action
    - Thriller
    - Romance
			

*/
-- Finally dropping the temporary table
DROP TABLE avg_rating_title_genre_summary;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
		COUNT(movie_id) AS movies 
FROM 
	ratings AS ratings
	INNER JOIN 
		movie AS movie
	ON ratings.movie_id=movie.id
WHERE (movie.date_published BETWEEN '2018-04-01' 
			AND '2019-04-01') 
		AND (ratings.median_rating = 8)
GROUP BY ratings.median_rating;
 -- ANSWER : 
-- Total 361 movies had been released between 1 April 2018 and 1 April 2019, and were given a median rating of 8 .




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH german_summary AS 
(
SELECT SUM(r.total_votes) AS german_total_votes,
		RANK() OVER(ORDER BY SUM(r.total_votes)) AS primary_id
FROM movie AS m
	INNER JOIN ratings AS r
	ON m.id=r.movie_id
WHERE m.languages LIKE '%German%'
), 
italian_summary AS 
(
SELECT SUM(r.total_votes) AS italian_total_votes,
		RANK() OVER(ORDER BY sum(r.total_votes)) AS primary_id
FROM movie AS m
	INNER JOIN ratings AS r
	ON m.id=r.movie_id
WHERE m.languages LIKE '%Italian%'
) 
SELECT *,
CASE
	WHEN german_total_votes > italian_total_votes THEN 'Yes' ELSE 'No'
    END AS 'is_german_movie_popular_than_italian_movie'
FROM german_summary
	INNER JOIN italian_summary
USING(primary_id);  



 -- ANSWER : 
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) AS name_nulls
FROM names
Where name IS NULL;

SELECT COUNT(*) AS height_nulls
FROM names
Where height IS NULL;

SELECT COUNT(*) AS date_of_birth_nulls
FROM names
Where date_of_birth IS NULL;

SELECT COUNT(*) AS known_for_movies_nulls
FROM names
Where known_for_movies IS NULL;



SELECT 
	SUM(ISNULL(n.name)) AS name_nulls,
    SUM(ISNULL(n.height)) AS height_nulls,
    SUM(ISNULL(n.date_of_birth)) AS date_of_birth_nulls,
    SUM(ISNULL(n.known_for_movies)) AS known_for_movies_nulls
FROM names AS n;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre  AS
(
SELECT COUNT(m.id),
		g.genre,
		DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM movie as m
INNER JOIN ratings as r
	ON m.id = r.movie_id
INNER JOIN genre as g
	ON m.id = g.movie_id
WHERE r.avg_rating > 8
GROUP BY g.genre
LIMIT 3
)
SELECT  n.name AS director_name,
		COUNT(dm.movie_id) AS movie_count
FROM director_mapping as dm
INNER JOIN names as n
	ON dm.name_id = n.id
INNER JOIN genre as g
	USING (movie_id)
INNER JOIN top_3_genre
	USING (genre)
INNER JOIN ratings
	USING      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS rm
       INNER JOIN movie AS m
               ON m.id = rm.movie_id
       INNER JOIN ratings AS r 
				USING(movie_id)
       INNER JOIN names AS n
               ON n.id = rm.name_id
WHERE  r.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

-- Top two actors are Mammootty (having movie count of 8) and Mohanlal (having movie count of 5)




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT	m.production_company,
		SUM(r.total_votes)	AS	vote_count,
        DENSE_RANK() OVER (ORDER BY SUM(r.total_votes) DESC)	AS	prod_comp_rank
FROM	movie	AS	m
INNER JOIN	ratings	AS	r
ON	m.id = r.movie_id
GROUP BY	m.production_company 
LIMIT	3;

-- Marvel Studios, Twentieth Century Fox, Warner Bros. are the top 3 production companies





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT		n.name													AS	actor_name,
			SUM(r.total_votes),
			COUNT(m.id)												AS	movie_count,
            ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2)	AS	actor_avg_rating,
            DENSE_RANK() OVER(ORDER BY  SUM(avg_rating*total_votes)/SUM(total_votes) DESC)	AS	actor_rank
FROM		movie			AS	m
INNER JOIN	ratings			AS	r
ON			m.id = r.movie_id
INNER JOIN	role_mapping	AS	rm
USING		(movie_id)
INNER JOIN	names			AS	n
ON			rm.name_id = n.id
WHERE		rm.category = 'actor'
			AND country	LIKE '%India%'
GROUP BY	name
HAVING		movie_count >= 5
LIMIT 1;

-- Top actor is Vijay Sethupathi with average rating of 8.42


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT		n.name													AS	actress_name,
			SUM(r.total_votes),
			COUNT(m.id)												AS	movie_count,
            ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2)	AS	actress_avg_rating,
            DENSE_RANK() OVER(ORDER BY  SUM(avg_rating*total_votes)/SUM(total_votes) DESC)	AS	actress_rank
FROM		movie			AS	m
INNER JOIN	ratings			AS	r
ON			m.id = r.movie_id
INNER JOIN	role_mapping	AS	rm
USING		(movie_id)
INNER JOIN	names			AS	n
ON			rm.name_id = n.id
WHERE		rm.category = 'actress'
			AND country	LIKE '%India%'
            AND languages LIKE '%Hindi%'
GROUP BY	name
HAVING		movie_count >= 3
LIMIT		5;

/*
	Top 5 acctresses are
		- Taapsee Pannu - 7.74
        - Kriti Sanon - 7.05
        - Divya Dutta - 6.88
        - Shraddha Kapoor - 6.63
        - Kriti Kharbanda - 4.80
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT	m.title,
		g.genre,
        r.avg_rating,
        CASE
			WHEN	r.avg_rating > 8	THEN	'Superhit movies'
            WHEN	r.avg_rating BETWEEN 7  AND 8 THEN	'Hit movies'
            WHEN	r.avg_rating BETWEEN 5  AND 7 THEN	'One-time-watch movies'
            ELSE	'Flop movies'
		END	AS	movie_rating
FROM	movie	AS	m
INNER JOIN	genre	AS	g
ON		m.id = g.movie_id
INNER JOIN	ratings	AS	r
USING		(movie_id)
WHERE	g.genre = 'Thriller'
ORDER BY	r.avg_rating	DESC;





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT	g.genre,
		ROUND(AVG(duration),2)	AS	avg_duration,
        SUM(ROUND(AVG(duration),2))	OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS	running_total_duration,
        ROUND(AVG(AVG(duration))	OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS	moving_avg_duration
FROM	movie	AS	m
INNER JOIN	genre	AS	g
ON		m.id = g.movie_id
GROUP BY	genre
ORDER BY	genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- top 3 genre

WITH top_3_genre AS
(
SELECT	g.genre,
		COUNT(g.movie_id)	AS movie_count
FROM	genre	AS	g
GROUP BY	g.genre
ORDER BY	movie_count	DESC
LIMIT	3
),
top_5_movie AS
(
SELECT	genre,
		year,
        title	AS	movie_name,
        CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
FROM	movie	AS	m
INNER JOIN	genre	AS	g
ON	m.id = g.movie_id
WHERE	genre IN	(SELECT genre FROM	top_3_genre)
)
SELECT	*
FROM	top_5_movie
WHERE	movie_rank<=5;




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT	m.production_company,
		COUNT(m.id)	AS  movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM	movie	AS	m
INNER JOIN	ratings	AS r
ON	m.id = r.movie_id
WHERE	r.median_rating >= 8
	AND
		POSITION(',' IN m.languages) > 0
	AND
		m.production_company IS NOT NULL
GROUP BY  m.production_company
LIMIT 2;


-- Top 2 production companies are 'Star Cinema' and 'Twentieth Century Fox'


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT	n.name	AS	actress_name,
		SUM(r.total_votes)	AS	total_votes,
        COUNT(m.id)	AS	movie_count,
        AVG(r.avg_rating)	AS	actress_avg_rating,
        DENSE_RANK()	OVER(ORDER BY	AVG(r.avg_rating)	DESC)	AS	actress_rank
FROM	movie	AS	m
INNER JOIN	genre	AS	g
ON	m.id = g.movie_id
INNER JOIN	ratings	AS	r
USING	(movie_id)
INNER JOIN	role_mapping	AS	rm
USING	(movie_id)
INNER JOIN	names	AS	n
ON	rm.name_id = n.id
WHERE	r.avg_rating>8
	AND
		g.genre = 'drama'
	AND
		rm.category = 'actress'
GROUP BY	n.name;

-- Sangeetha Bhat, Fatmire Sahiti, Adriana Matoshi are the top 3 actress based on number of super hit movies in drama genre


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH t_date_summary AS 
(
	SELECT d.name_id, 
		NAME, 
        d.movie_id, 
		duration, 
		r.avg_rating, 
		total_votes, 
		m.date_published, 
        Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published 
    FROM director_mapping AS d 
    INNER JOIN names AS n 
    ON n.id = d.name_id 
    INNER JOIN movie AS m 
    ON m.id = d.movie_id 
    INNER JOIN ratings AS r 
    ON r.movie_id = m.id 
), 
top_director_summary AS 
( SELECT 
			*, 
			Datediff(next_date_published, date_published) AS date_difference 
            FROM t_date_summary 
) 
SELECT 
	name_id AS director_id, 
	NAME AS director_name, 
	COUNT(movie_id) AS number_of_movies, 
	ROUND(AVG(date_difference),2) AS avg_inter_movie_days, 
	ROUND(AVG(avg_rating),2) AS avg_rating, 
	SUM(total_votes) AS total_votes, 
    MIN(avg_rating) AS min_rating, 
    MAX(avg_rating) AS max_rating, 
    SUM(duration) AS total_duration 
FROM top_director_summary
GROUP BY director_id
ORDER  BY number_of_movies DESC
LIMIT 9;







