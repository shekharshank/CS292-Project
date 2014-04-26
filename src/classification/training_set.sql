-- table for selecting machine properties
create table machine_event_data as select machine_id, avg(cpu_capacity) as cpu_capacity, avg(memory_capacity) as memory_capacity from machine_events group by machine_id;

-- table for selecting clustering events, also check if null
create table task_all_events_data as select  event_time, job_id, task_index,  machine_id, event_type, scheduling_class, priority,
CPU_request,  memory_request, disk_space_request from task_events where (event_type=2 or event_type=3 or event_type=4 or event_type=5 or event_type=6);

-- table obtained after clustering
create table task_all_events_data_withcluster (
  event_time bigint,
  job_id bigint,
  task_index int,
  cluster int,
  machine_id  bigint,
  event_type int,
  CPU_request double,
  memory_request double,
  disk_space_request double
);

create table task_usage_data as select event_time, job_id, task_index, CPU_rate, canonical_memory_usage, local_disk_space_usage from task_usage;

-- table with machine details
create table task_all_events_data_temp1 as select event_time, job_id, task_index, cluster, cpu_capacity as machine_cpu_capacity,
memory_capacity as machine_memory_capacity, event_type,  CPU_request, memory_request, disk_space_request from task_all_events_data_withcluster A join machine_event_data B  on A.machine_id=B.machine_id;

-- table with task usage details temp
create table task_all_events_data_fortraining_temp as select A.event_time, B.sampling_end_time, A.job_id, A.task_index, cluster, CPU_rate/CPU_request as cpu_utilization, canonical_memory_usage/memory_request as memory_utilization, local_disk_space_usage/disk_space_request as disk_utilization, machine_cpu_capacity, machine_memory_capacity, event_type from task_all_events_data_temp1 A join task_usage_data B  on A.job_id=B.job_id and A.task_index=B.task_index where CPU_request <> 0 and memory_request <> 0 and disk_space_request <> 0 and A.task_index=B.task_index and B.event_time < (A.event_time + 1) and  B.event_time > (A.event_time - 300000000);


-- table with task usage details for the interval entry
create table task_all_events_data_fortraining as select event_time, job_id, task_index, avg(cluster) as cluster, avg(cpu_utilization) as cpu_utilization, avg(memory_utilization) as memory_utilization, avg(disk_utilization) as disk_utilization, avg(machine_cpu_capacity) as machine_cpu_capacity, avg(machine_memory_capacity) as machine_memory_capacity, avg(event_type) as event_type from task_all_events_data_fortraining_temp where cpu_utilization <>0 and memory_utilization <> 0 group by job_id, task_index, event_time;



-- table with training data - 25 days 
create table training_data as select CASE WHEN event_type = 4 THEN 1 ELSE 0 END, 
cluster, cpu_utilization, memory_utilization, disk_utilization, machine_cpu_capacity, machine_memory_capacity  from task_all_events_data_fortraining where event_time < 2160000000000;

-- table with testing data - 4 days 
create table testing_data as select CASE WHEN event_type = 4 THEN 1 ELSE 0 END, 
cluster, cpu_utilization, memory_utilization, disk_utilization, machine_cpu_capacity, machine_memory_capacity  from task_all_events_data_fortraining where event_time >= 2160000000000;