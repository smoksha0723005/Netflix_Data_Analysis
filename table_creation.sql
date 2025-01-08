-- ---------------NETFLIX DATA ANALYSIS------------------------
-- CREATING TABLE
create table netflix
(
show_id varchar(10) primary key,
type    varchar(15),
title   varchar(150),
director varchar(250),
casts	 varchar(1000),
country	 varchar(150),
date 	 varchar(50),
release_year int,
rating 	 varchar(10),
duration varchar(15),
listed_in varchar(50),
description varchar(250)
)