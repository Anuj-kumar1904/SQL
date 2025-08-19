/* Netflix Data Analysis Sql Project */

--Analysis -1

--Q1. Count how many titles are available for each type. 
select type,count(title)as titles_count
from[titles 2]
group by type

--Q2. Find the average IMDb score of all 'MOVIE' titles.
select avg(imdb_score)
from[titles 2]
where type='movie'

--Q3. List titles along with the total number of votes, sorted by most votes. 
select title,sum(imdb_votes)as total_votes
from[titles 2]
group by title
order by total_votes desc

--Q4. Join titles and credits to list the first 10 title-character pairs. 
select top 10 t.title,c.character
from [titles 2] as t
left join [credits 2] as c
on t.id=c.id

--Q5. How many titles does each genre appear in?
select genres,count(title)as titles_count
from[titles 2]
group by genres

--Q6. Find titles released between 2000 and 2010 with an IMDb score above 7. 
select title,release_year,imdb_score
from[titles 2]
where release_year between 2000 and 2010
and imdb_score >7
order by release_year 

--Q7. Show the number of seasons for each title with more than 1 season. 
select  title,count(distinct seasons)as seasons_count
from[titles 2]
group by title
having count(distinct seasons) >1;

--Q8. Show top 5 most popular titles based on tmdb_popularity.
select top 5 title,tmdb_popularity
from[titles 2]
order by tmdb_popularity desc

--Analysis -2 

--Q1. List the top 5 actors who played in the most titles.
select top 5 c.role,c.name,count(t.title)as titles
from[credits 2] as c
left join [titles 2]as t
on t.id=c.id
where c.role='actor'
group by c.role,c.name
order by titles desc

--Q2. List titles and the number of people credited in each. 
select t.title,count(c.person_id)as peoples_credited
from [titles 2]as t
left join [credits 2]as c
on t.id=c.id
group by title
order by peoples_credited desc

--Q3. Find all titles with both an IMDb score above 7 and a TMDB score above 7.
select title,imdb_score,tmdb_score
from [titles 2]
where imdb_score >7
and tmdb_score >7

--Q4. Which production countries have produced the most titles?
select production_countries ,count(title)as titles
from[titles 2]
group by production_countries
order by titles desc

--Q5. Show the average runtime by title type.
select type,avg(runtime)as avg_runtime
from[titles 2]
group by type

--Q6. List titles where the word “love” appears in the title. 
select title
from[titles 2]
where title like '%love%'

--Q7. Find top 5 directors by number of titles directed.
select top 5 c.role,c.name,count(t.title)as titles
from [credits 2]as c
left join [titles 2]as t
on t.id=c.id
where c.role='director'
group by c.role,c.name
order by titles desc

--Q8. Show the most recent title each person acted in. 
select t.title,t.release_year,c.person_id,c.name
from[titles 2]as t
left join [credits 2]as c
on t.id=c.id
order by release_year desc

--Analysis-3

--Q1. Find titles with IMDb scores higher than the average IMDb score of all titles.
select title,imdb_score
from[titles 2]
where imdb_score >(select avg(imdb_score) from [titles 2] )

--Q2. List the top 1 most common roles from the credits table using a CTE. 
with role_count as(
select role,count(*)as c
from [credits 2]
group by role)

select top 1 *
from role_count
order by c desc

--Q3. Find the top 3 longest movies by runtime using a subquery. 
select title,runtime
from[titles 2]
where type='movie' and runtime in (select top 3 runtime from[titles 2]
where type='movie'
order by runtime desc)
order by runtime desc;

--Q4. Show titles and their IMDb score ranks (1 = highest) using a CTE.
with ranking as(
select title,RANK() over (order by imdb_score desc) as imdb_rank
from [titles 2]
)
select top 5 title,imdb_rank
from ranking

--Q5. List all people who acted in titles released in 2020.
select c.person_id,c.name,t.title,t.release_year
from[credits 2]as c
left join [titles 2]as t
on c.id=t.id
where t.release_year='2020'
and role='actor'

--Q6. Get average IMDb score per type and show only types with average score > 6 using a CTE.
with imdb_7 as (select type,avg(imdb_score)as avg_score
from[titles 2]
group by type
having avg(imdb_score)>6
)

select *
from imdb_7

--Q7. Find titles that have more than 3 people credited.
select c.person_id,c.name,count(t.title)as people_credited
from[credits 2]as c
left join [titles 2]as t
on c.id=t.id
group by c.person_id,c.name
having count(title)>3
order by people_credited desc

--Q8. List each actor and the number of unique titles they appeared in using CTE.
with unique_title as (select  c.name,c.role,count(distinct t.title)as no_of_titles
from[credits 2]as c
inner join [titles 2]as t
on t.id=c.id
where c.role='actor'
group by c.name,c.role
)

select name,no_of_titles
from unique_title
order by no_of_titles desc

