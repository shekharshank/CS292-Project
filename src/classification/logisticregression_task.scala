import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.classification.LogisticRegressionWithSGD

// Load and parse the training file
val data = sc.textFile("/user/hive/warehouse/training_data");
val parsedData = data.map { line =>
  val parts = line.split(',');
  LabeledPoint(parts(0).toDouble, parts.tail.map(x => x.toDouble).toArray)
}

// Run training algorithm to build the model
val numIterations = 20
val model = LogisticRegressionWithSGD.train(parsedData, numIterations)

// Evaluate model on training examples and compute training error
val labelAndPreds = parsedData.map { point =>
  val prediction = model.predict(point.features)
  (point.label, prediction)
}

val trainErr = labelAndPreds.filter(r => r._1 != r._2).count.toDouble / parsedData.count
println("Training Error = " + trainErr);

// Load and parse the testing file
val testingData = sc.textFile("/user/hive/warehouse/testing_data");
val parsedTestingData = testingData.map { line =>
  val parts = line.split(',');
  LabeledPoint(parts(0).toDouble, parts.tail.map(x => x.toDouble).toArray)
}

// Evaluate model on training examples and compute training error
val labelAndPredsTesting = parsedTestingData.map { point =>
  val prediction = model.predict(point.features)
  (point.label, prediction)
}
val trainErr = labelAndPredsTesting.filter(r => r._1 != r._2).count.toDouble / parsedTestingData.count
println("Testing Error = " + trainErr)