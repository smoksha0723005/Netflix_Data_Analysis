-- --------------------------BUSINESS PROBLEMS-----------------------------------
-- Q1. COUNT THE NUMBER OF MOVIES VS TV SHOWS
select 
	type, 
	count(*) as total_content  
from netflix
group by type
order by total_content desc;

-- Q2. FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS
select 
	type, 
	rating
from
(
	select 
		type,
		rating,
		count(*), 
		rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by type,rating
) as t1
where 
	ranking = 1;

-- Q3. LIST ALL THE MOVIES RELEASED IN 2020
select 
	title
from netflix
where 
	type = 'Movie' and release_year = 2020;

-- Q4. FIND THE TOP 5 COUNTRIES WHICH HAS THE MOST CONTENT ON NETFLIX
select
	trim(upper(unnest(string_to_array(country,',')))) as new_country,
	count(*) as total_content
from netflix
group by new_country
order by total_content desc
limit 5;

-- Q5. IDENTIFY THE LONGEST MOVIE
with cte as(
		select 
			title,
			cast(split_part(duration,' ',1) as integer) as new_duration
		from netflix
		where type = 'Movie'
		)
select 
	title, new_duration
from cte
where new_duration = (select max(new_duration) from cte);

-- Q6. FIND CONTENT ADDED IN THE LAST 5 YEARS
select 
	title, 
	date
from netflix
where 
	to_date(date, 'Month DD YYYY') >= current_date - interval '5 years';

-- Q6. FIND ALL THE MOVIES/TV SHOWS DONE BY DIRECTOR ''RAJIV CHILAKA
with cte as
(
	select 
		type, 
		title,
		trim(upper(unnest(string_to_array(director, ',')))) as new_directors
	from Netflix
) 
select 
	type,
	title,
	new_directors
from cte
where new_directors = 'RAJIV CHILAKA';

-- Q8. LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS
select
	title,
	duration
from netflix
where 
	type = 'TV Show'
	and
	cast(split_part(duration, ' ', 1) as integer) > 5;

-- Q9. COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE
select 
	trim(upper(unnest(string_to_array(listed_in, ',')))) as genre,
	count(show_id) as total_content
from netflix
group by genre
order by total_content desc;

-- Q10. FIND EACH YEAR AND THE AVERAGE NUMBER OF CONTENT RELEASED BY INDIA ON NETFLIX.
-- RETURN TOP 5 YEAR WITH THE HIGHEST AVG CONTENT RELEASE.

select 
	extract(year from to_date(date, 'Month DD, YYYY')) as date_added,
	count(*) as total_content,
	round(
		count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric *100 
		,2)as avg_content
from netflix
where country = 'India'
group by date_added
order by avg_content desc
limit 5;
	
-- Q11. LIST ALL THE MOVIES THAT ARE DOCUMENTRIES
select
	title,
	genre
from 
	(
		select title,
				trim(upper(unnest(string_to_array(listed_in, ',')))) as genre
		from netflix
	) as t1
where genre = 'DOCUMENTARIES';

-- Q12. FIND ALL THE CONTENT WITHOUT A DIRECTOR
select 
	title,
	director
from netflix
where director is null;

-- Q13. FIND HOW MANY MOVIES SALMAN KHAN APPEARED IN LAST 10 YEARS
select
	title,
	release_year,
	final_cast
from
	(select 
		title,
		release_year,
		trim(upper(unnest(string_to_array(casts, ',')))) as final_cast
	from netflix
	) as t1
where 
	final_cast = 'SALMAN KHAN'
	and
	release_year > extract(year from current_date) - 10; 

-- Q14. FIND THE TOP 10 ACTORS WHO APPEARED IN THE 
-- HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA

select
	final_cast,
	count(*) total_movies
from
	(select 
		trim(upper(unnest(string_to_array(casts, ',')))) as final_cast
	from netflix
	where country = 'India'
	) as t1
group by final_cast
order by total_movies desc
limit 10;

/* Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */
with cte as
(
	select 
		title,
		case
			when description ilike '%kill%' or
				 description ilike '%violence%' then 'Bad Content'
				 else 'Good Content'
		end category
	from netflix
	) 
select 
	category,
	count(*) as total_content
from cte
group by category
order by total_content desc;

-- --------------------END OF REPORT-------------------------------------------------















	