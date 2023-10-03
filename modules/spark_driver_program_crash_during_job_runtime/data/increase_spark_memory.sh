

#!/bin/bash



# Set the path to the Spark configuration file

SPARK_CONF=${PATH_TO_SPARK_CONF}



# Increase the driver program's memory allocation

sed -i 's/spark.driver.memory ${MEMORY_SIZE}/spark.driver.memory ${NEW_MEMORY_SIZE}/g' $SPARK_CONF



# Restart the Spark cluster to apply the changes

systemctl restart spark