-- table with unique tasks
create table task_events_data ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' as select job_id, task_index, round(avg(scheduling_class),0) as scheduling_class, round(avg(priority),0) as priority, avg(CPU_request) as CPU_request,  avg(memory_request) as memory_request, avg(disk_space_request) as disk_space_request from  task_events group by job_id, task_index;

-- K-Means clustering training data
create table task_events_kmeans_data ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' as select  scheduling_class, priority, CPU_request, memory_request, disk_space_request from  task_events_data;

-- Table to find failures according to clusters
create table task_events_data_witheventtypes as select job_id, task_index, SUM(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS event_schedule, SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS event_evict, SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS event_fail, SUM(CASE WHEN event_type = 4 THEN 1 ELSE 0 END) AS event_finish, SUM(CASE WHEN event_type = 5 THEN 1 ELSE 0 END) AS event_kill, SUM(CASE WHEN event_type = 6 THEN 1 ELSE 0 END) AS event_lost, round(avg(scheduling_class),0) as scheduling_class, round(avg(priority),0) as priority, avg(CPU_request) as CPU_request,  avg(memory_request) as memory_request,  avg(disk_space_request) as disk_space_request from  task_events group by job_id, task_index;

-- Table with labeled cluster rows to display failures
CREATE TABLE task_cluster (cluster INT, event_schedule BIGINT, event_evict BIGINT, event_fail BIGINT, event_finish BIGINT, event_kill BIGINT, event_lost BIGINT)  ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- to find average failure types across the data set
select count(event_type) from task_events where event_type=1;
select count(event_type) from task_events where event_type=2;
select count(event_type) from task_events where event_type=3;
select count(event_type) from task_events where event_type=4;
select count(event_type) from task_events where event_type=5;
select count(event_type) from task_events where event_type=6;
select count(*) from  task_events_data_witheventtypes;

-- to find atleast once failure types
select count(event_evict) from task_events_data_witheventtypes where event_evict > 0;
select count(event_fail) from task_events_data_witheventtypes where event_fail > 0;
select count(event_kill) from task_events_data_witheventtypes where event_kill > 0;
select count(event_lost) from task_events_data_witheventtypes where event_lost > 0;

-- find avg failures across the clusters
SELECT cluster, avg(event_evict), avg(event_fail), avg(event_kill), avg(event_lost) from task_cluster group by cluster order by cluster;

-- find total failures across the clusters
SELECT cluster, sum(event_schedule), sum(event_evict), sum(event_fail), sum(event_finish), sum(event_kill), sum(event_lost) from task_cluster group by cluster;