import org.apache.spark.mllib.clustering.KMeans

// Load and parse the data from database
val data = sc.textFile("/user/hive/warehouse/task_events_kmeans_data/")

val parsedData = data.map( _.split(',').map(_.toDouble))

// Cluster the data into two classes using KMeans
val numIterations = 20
val numClusters = 8
val clusters = KMeans.train(parsedData, numClusters, numIterations)

// cluster centers
val centers = clusters.clusterCenters
println(centers.deep.mkString("\n"))

// Evaluate clustering by computing Within Set Sum of Squared Errors
val WSSSE = clusters.computeCost(parsedData)
println("Within Set Sum of Squared Errors = " + WSSSE)

// Load and parse the data in database to center
val allData = sc.textFile("/user/hive/warehouse/task_all_events_data/")

// get rdd of sequence data
val line = allData.map( _.split(','))

val labeledData = line.map((x:Array[String]) => (clusters.predict(Array(x(5).toDouble, x(6).toDouble, x(7).toDouble, x(8).toDouble, x(9).toDouble)), x))

// tuple of cluster and array
// event_schedule, event_evict, event_fail, event_finish, event_kill, event_lost
val  labeledDataString = labeledData.map(k => { k._2(0) + "," + k._2(1) + "," + k._2(2) + "," + k._1 + "," + k._2(3) + "," + k._2(4) + "," + k._2(7) + "," + k._2(8) + "," + k._2(9)})

// save to HDFS for further processing
labeledDataString.saveAsTextFile("/user/hive/warehouse/task_all_events_data_withcluster/");