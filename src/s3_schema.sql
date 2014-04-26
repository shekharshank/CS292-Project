create external table machine_events (
  event_time                bigint,
  machine_id      bigint,
  event_type              INT,
  platform_id              string,
  cpu_capacity              float,
  memory_capacity              float
) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/machine_events/';

create external table machine_attributes (
  event_time bigint,
  machine_id      bigint,
  name STRING,
  attribute_value STRING,
  attribute_deleted INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/machine_attributes/';

create external table job_events (
  event_time bigint,
  missing_info INT,
  job_id bigint,
  event_type INT,
  user STRING,
  scheduling_class INT,
  job_name STRING,
  logical_job_name STRING

) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/job_events/';

create external table task_events (
  event_time bigint,
  missing_info INT,
  job_id bigint,
  task_index INT,
  machine_id bigint,
  event_type INT,
  user STRING,
  scheduling_class INT,
  priority INT,
  CPU_request FLOAT,
  memory_request FLOAT,
  disk_space_request FLOAT,
  different_machines_restriction INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/task_events/';

create external table task_constraints (
  event_time bigint,
  job_id bigint,
  task_index INT,
  comparison_operator INT,
  attribute_name STRING,
  attribute_value STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/task_constraints/';

create external table task_usage (
  start_time bigint,
  end_time bigint,
  job_id bigint,
  task_index INT,
  machine_id bigint,
  CPU_rate FLOAT,
  canonical_memory_usage FLOAT,
  assigned_memory_usage FLOAT,
  unmapped_page_cache FLOAT,
  total_page_cache FLOAT,
  maximum_memory_usage FLOAT,
  disk_IO_time FLOAT,
  local_disk_space_usage FLOAT,
  maximum_CPU_rate FLOAT,
  maximum_disk_IO_time FLOAT,
  cycles_per_instruction FLOAT,
  memory_accesses_per_instruction FLOAT,
  sample_portion FLOAT,
  aggregation_type INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY "," LOCATION 's3n://googlecluster/task_usage/';

