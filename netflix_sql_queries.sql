drop table if exists netflix;
create table netflix(
	show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year INT,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);


select* from netflix;

select count(*) as total_content from netflix;

--15 Business problems

--1 count the number of movies vs tv shows
select 
	type,
	count(*) as total_content
from netflix
group by type

--2 find the most common ranking for movies and tv shows
select
	type,
	rating
from
(
	select 
		type,
		rating,
		count(*),
		rank() over(partition by type order by count(*) desc)as ranking
	from netflix
group by 1,2) as t1
where
	ranking=1


--3 list all the movies released in a specific year(ex-2020)
select* from netflix
where
	type='Movie'
	and
	release_year=2020


--4 Find the top 5 countries with the most content on netflix
select 
	unnest(STRING_TO_ARRAY(country,','))as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

--5 identify the longest movie
select * from netflix 
where
	type='Movie'
	and
	duration = (Select max(duration) from netflix)

--6 find content added in the last 5 years

select 
	*
	
from netflix
where
	to_date(date_added,'Month DD,YYYY') >= current_date - interval '5 years'
select current_date - interval '5 years'

--7 Find all the movies/TV shows by director 'Rajiv Chilaka'

select * from netflix 
where
	director iLike '%Rajiv Chilaka%'


--8 List all Tv shows with more than 5 seasons

SELECT *
FROM (
    SELECT 
        *,
        CAST(SPLIT_PART(duration, ' ', 1) AS INT) AS seasons
    FROM netflix
    WHERE type = 'TV Show'
) t
WHERE seasons > 5;

--9 Count the number of conntent items in each genre

Select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(show_id)
from netflix 
group by 1

--10  Find each year and the average numbers of content released by India on netflix. Return top 5 year with highest avg content release
select 
	extract(year from to_date(date_added,'Month DD,YYYY')) as year,
	count(*)
from netflix
where country='India'
group by 1

--11 List all movies that are documentaries

select * from netflix 
where
	listed_in ilike '%documentaries%'

--12 find all content without a director

select * from netflix 
where
	director is null

--13 Find in how many movis did the actor 'Salman Khan' appeared in the last 15 years

select * from netflix
where
	casts ilike '%Salman Khan%'
	and
	release_year > extract(year from current_date) - 15

	
--14 Find the top 10 actors who have appeared in the highest number of movies produced in india
select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc