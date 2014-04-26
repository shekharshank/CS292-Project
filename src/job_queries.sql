-- table for analysing job clusters based on scheduling class
create table job_events_data ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' as select event_time, job_id, event_type, scheduling_class from  job_events;

-- to find average failure types across the data set
select count(*) from job_events_data where event_type=1;
select count(event_type) from job_events_data where event_type=2;
select count(event_type) from job_events_data where event_type=3;
select count(event_type) from job_events_data where event_type=4;
select count(event_type) from job_events_data where event_type=5;
select count(event_type) from job_events_data where event_type=6;

-- Table to find failures according to clusters
create table job_events_data_witheventtypes as select job_id, round(avg(scheduling_class),0) as scheduling_class, SUM(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS event_schedule, SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS event_evict, SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS event_fail, SUM(CASE WHEN event_type = 4 THEN 1 ELSE 0 END) AS event_finish, SUM(CASE WHEN event_type = 5 THEN 1 ELSE 0 END) AS event_kill, SUM(CASE WHEN event_type = 6 THEN 1 ELSE 0 END) AS event_lost from  job_events_data group by job_id;

-- to find atleast once failure types
select count(*) from  job_events_data_witheventtypes;
select count(event_evict) from job_events_data_witheventtypes where event_evict > 0;
select count(event_fail) from job_events_data_witheventtypes where event_fail > 0;
select count(event_kill) from job_events_data_witheventtypes where event_kill > 0;
select count(event_lost) from job_events_data_witheventtypes where event_lost > 0;

-- find avg failures across the clusters
select avg(event_evict), avg(event_fail), avg(event_kill), avg(event_lost) from job_events_data_witheventtypes where scheduling_class = 0;
select avg(event_evict), avg(event_fail), avg(event_kill), avg(event_lost) from job_events_data_witheventtypes where scheduling_class = 1;
select avg(event_evict), avg(event_fail), avg(event_kill), avg(event_lost) from job_events_data_witheventtypes where scheduling_class = 2;
select avg(event_evict), avg(event_fail), avg(event_kill), avg(event_lost) from job_events_data_witheventtypes where scheduling_class = 3;
