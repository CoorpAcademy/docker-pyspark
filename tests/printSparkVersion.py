import findspark
findspark.init()
from pyspark import SparkConf, SparkContext

sc = SparkContext(conf=SparkConf())
print sc.version

