#Fault Analysis in a Data Center using Trace Logs 

## Setup

Clone a git repo locally from <https://github.com/apache/spark>. 

Setup AWS account locally by adding environment varibles:

	export AWS_ACCESS_KEY_ID=<ACCESS_KEY>
	export AWS_SECRET_ACCESS_KEY=<SECRET_KEY>
	
Go ec2 directory and create a Apache Spark cluster on AWS using:

	./spark-ec2 -k <KEY_NAME> -i <KEY_FILE> -s <SLAVES> -w 240 launch <CLUSTER_NAME>
	
Login to master node:

	./spark-ec2 -k <KEY_NAME> -i <KEY_FILE> login <CLUSTER_NAME>
	
Modify ~/ephemeral-hdfs/conf/core-site.xml for setting up Shark to use S3:

	<property>
	    <name>fs.s3n.awsAccessKeyId</name>
	    <value>ACCESS_KEY</value>
	</property>
	<property>
	    <name>fs.s3n.awsSecretAccessKey</name>
	    <value>SECRET_KEY</value>
	</property>
	
## Data loading

Load data to AWS S3 with the following command:

	aws s3 cp <LOCAL> <REMOTE_BUCKET> --recursive

