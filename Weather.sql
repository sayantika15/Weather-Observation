create database finalproject;
use finalproject;

/*1. Create a table “Station”  to store information about weather observation stations:
ID Number Primary Key 
CITY CHAR(20), 
STATE CHAR(2), 
LAT_N Number 
LONG_W Number */

create table station (`ID` int  Primary Key not null,
CITY CHAR(20) not null, 
STATE CHAR(2)not null, 
`LAT_N`int not null,
`LONG_W`int not null );

/*2. Insert the following records into the table:
ID CITY STATE LAT_N LONG_W 
13 Phoenix AZ 33 112 
44 Denver CO 40 105 
66 Caribou ME 47 68*/

insert into station (ID,CITY,STATE,LAT_N, LONG_W )
values(13, "Phoenix", "AZ",33,112),
	   (44,"Denver", "CO", 40, 105),
       (66, "Caribou", "ME", 47, 68);
       
-- 3. Execute a  query to look at table STATION in undefined order.
select * from station;

-- 4. Execute a query to select Northern stations (Northern latitude > 39.7)
select * 
from station 
where LAT_N > 39.7 ;


/*5. Create another table, ‘STATS’, to store normalized temperature and precipitation data
Column Data type Remark 
ID Number must match some STATION table ID(so name & location 
will be known). 
MONTH Number Range between 1 and 12 
TEMP_F Number in Fahrenheit degrees,Range between -80 and 150, 
RAIN_I Number */

create table stats (`ID` int ,foreign key (ID) references station(ID) ,
`Month` double not null, 
Temp_F double not null , 
Rain_I double not null
);
 
/*6. Populate the table STATS with some statistics for January and July:   
ID MONTH TEMP_F RAIN_I
13 1 57.4 .31
13 7 91.7 5.15
44 1 27.3 .18
44 7 74.8 2.11
66 1 6.7 2.1
66 7 65.8 4.5
*/
insert into stats (ID ,MONTH, TEMP_F, RAIN_I)
values(13, 1, 57.4, .31),
	   (13, 7, 91.7 ,5.15),
       (44 ,1 ,27.3 ,.18),
       (44 ,7, 74.8 ,2.11),
       (66 ,1 ,6.7 ,2.1),
       (66 ,7 ,65.8, 4.5);

select * from stats;

-- 7. Execute a query to display temperature stats (from STATS table) for each city (from Station table). 
select s1.id, s1.temp_f,s1.month, s2.city
from stats s1 inner join station s2 using(ID);

-- 8. Execute a query to look at the table STATS, ordered by month and greatest rainfall, with
-- columns rearranged. It should also show the corresponding cities.  

select s1.id, s1.month,max(s1.rain_I) as Greatest_Rainfall,s2.city
from  stats s1 inner join station s2 using(ID)
group by s1.id, s1.month,s2.city
order by month,Greatest_Rainfall ; 

-- 9. Execute a query to look at temperatures for July from table STATS, lowest temperatures first,
--    picking up city name and latitude.
select Min(s1.temp_f) as Lowest_temp, s2.city, s2.lat_n, s1.month
from  stats s1 inner join station s2 using(ID)
where month =7
group by s2.city, s2.lat_n,s1.month
order by Lowest_temp  asc;

-- 10. Execute a query to show MAX and MIN temperatures as well as average rainfall for each city.
select max(s1.temp_f) as `Max temp`, min(s1.temp_f) as `Min Temp`,
round(avg(s1.rain_i),2) as `Avg Rainfall`, s2.city
from  stats s1 inner join station s2 using(ID)
group by s2.city;

-- 11. Execute a query to display each city’s monthly temperature in Celcius and rainfall in
--     Centimeter. 
select s1.month,s2.city,s1.temp_f, s1.rain_i
from  stats s1 inner join station s2 using(ID)
order by s1.month;

-- 12. Update all rows of table STATS to compensate for faulty rain gauges known to read 0.01
--     inches low.

update stats 
set rain_i = round(rain_i-0.01,2);

select * from stats;
select * from station;

-- 13. Update Denver's July temperature reading as 74.9.
set sql_safe_updates =0;

update stats s1 inner join station s2
set temp_f = 74.9
where s1.id = 44 and s1.month = 7;

select s1.id,s1.month,s2.city,s1.temp_f, s1.rain_i
from  stats s1 inner join station s2 using(ID) ;






