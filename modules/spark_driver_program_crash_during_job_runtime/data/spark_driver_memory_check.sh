bash

#!/bin/bash



# Define parameters

SPARK_DRIVER_MEMORY="${MEMORY_SIZE}"



# Get current memory usage of the Spark driver

SPARK_DRIVER_PID=$(ps aux | grep spark.driver.memory | grep -v grep | awk '{print $2}')

SPARK_DRIVER_MEMORY_USAGE=$(pmap -x "$SPARK_DRIVER_PID" | tail -n 1 | awk '{print $4}')



# Check if current memory usage exceeds allocated memory

if (( $(echo "$SPARK_DRIVER_MEMORY_USAGE / 1024 / 1024 / 1024" | bc) > $SPARK_DRIVER_MEMORY )); then

    echo "Spark driver program is using more memory than allocated: $SPARK_DRIVER_MEMORY_USAGE bytes"

    echo "Allocated memory: $SPARK_DRIVER_MEMORY GB"

    echo "Please increase the value of spark.driver.memory configuration parameter and restart the Spark driver program."

else

    echo "Spark driver program is using memory within allocated limits: $SPARK_DRIVER_MEMORY_USAGE bytes"

fi