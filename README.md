
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Spark driver program crash during job runtime.
---

This incident type refers to an unexpected termination of the Spark driver program during the runtime of a job. The driver program is responsible for coordinating the execution of a Spark job and if it crashes, the entire job is affected. This can result in data loss and downtime, and requires investigation and troubleshooting to identify the root cause of the issue.

### Parameters
```shell
export DRIVER_PROGRAM_NAME="PLACEHOLDER"

export PATH_TO_DRIVER_LOGS="PLACEHOLDER"

export PATH_TO_SPARK_CONF="PLACEHOLDER"

export NEW_MEMORY_SIZE="PLACEHOLDER"

export MEMORY_SIZE="PLACEHOLDER"
```

## Debug

### Check if Spark is running
```shell
ps aux | grep spark
```

### Check if the driver program is running
```shell
ps aux | grep ${DRIVER_PROGRAM_NAME}
```

### Check for any logs or error messages related to the driver program crash
```shell
grep -r "error" ${PATH_TO_DRIVER_LOGS}
```

### Check for any system-level errors or warnings
```shell
dmesg | tail
```

### Check for any resource issues, such as memory usage or CPU utilization
```shell
top
```

### Check for any network-related issues
```shell
netstat -a
```

### Check for any firewall or security-related issues
```shell
iptables -L
```

### Insufficient memory resources allocated to the Spark driver program.
```shell
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


```

## Repair

### Increase the resources allocated to the Spark driver program, such as increasing the memory or the number of CPU cores.
```shell


#!/bin/bash



# Set the path to the Spark configuration file

SPARK_CONF=${PATH_TO_SPARK_CONF}



# Increase the driver program's memory allocation

sed -i 's/spark.driver.memory ${MEMORY_SIZE}/spark.driver.memory ${NEW_MEMORY_SIZE}/g' $SPARK_CONF



# Restart the Spark cluster to apply the changes

systemctl restart spark


```