Overall process for mlops.

1. Build
2. Train
3. Deploy

## Build
When building, the following steps are necessary usually.

### Deciding on and productionizing data preprocessing steps - where does ETL for analytics end, and ETL for machine learning start?
Use Glue for ETL when you need "out of the box" transformations provided by awsglue.

### Model development. Tinkering around with different models and algorithms.
Run the main stack to create:
(insert architecture drawing)
- sm notebook
- codecommit repo.
- step functions for monitoring things.

The notebook has special features:
- it comes with a standardized folder layout. See cookiecutter / datascience.
- it comes already connected to a repo. When you start up an instance, it completes the lifecycle config by pushing to the remote repo.
- it has example code in it for general operations (training models, deploying models).

### Placing the most important work into version control: ETL.
1. Open a terminal from Jupyter notebook. Use git commands like normal. You will be pushing to your CodeCommit repo.
2. `cd SageMaker/(YOUR_REPO_NAME)`
3. `git add A`
4. `git commit -m "my commit message"`
5. `git push origin master`


## Train

## Deploy


# To set up your mini datalake
## Create a virtual database and crawler
1. Create the database and crawler in the console.

### Data exploration: statistics, looking at the data, visualization.

1. Start up a Glue endpoint. This assumes you have data in an S3 datalake (if you don't have data in a datalake yet, see below ... place data in a single s3 bucket, crawl it using Glue to establish a table definition, then proceed. Or, run the 2ndwatch Datalake)

```bash
aws glue create-dev-endpoint \
  --endpoint-name $ENDPOINT_NAME \
  --role-arn $ROLE_ARN \
  --worker-type Standard \
  --glue-version 1.0 \
  --number-of-workers 2
```

2. Once the dev endpoint is up, attach a SageMaker notebook to it, in the Console. It will show up both in Glue and in SageMaker. Run it from SageMaker.
3. Create a glueContext to use the awsglue library - useful in order to easily port your code to "official" ETL processes in AWS Glue.

```python
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

glueContext = GlueContext(SparkContext.getOrCreate())
```

4. Load your data from the table in Glue database. It is loaded into an structure called a DynamicFrame.
```python
db_name = "mlops-database"
table_name = "table_name"
observations = glueContext.create_dynamic_frame.from_catalog(database=db_name, table_name=table_name)
print "Count: ", observations.count()
observations.printSchema()
```
Now you are ready to work on data manipulation.
Assuming the ML model you eventually create will be used for production ML, you will need to productionize your ETL that prepares your data. So, that is why you do the etl manipulation in PySpark. AWS has a powerful library called `awsglue` with lots of common transforms.

Write ETL code that preps your data for model training and places it in a new S3 partition.

What is the difference between ETL code and data prep code for a ml model?
ETL: common transforms, such as joining two tables, enriching data, formatting a date field, validating entries.
Data prep code: transformation of the data for input to a ml interface. One-hot encoding of categorical variables; tokenizing text.

5. Version control your ETL code.

6. IMPORTANT. Turn off the glue dev endpoint when you are done. And the sagemaker notebook.
