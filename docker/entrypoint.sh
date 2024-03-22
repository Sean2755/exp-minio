#!/bin/bash

# Start MinIO in the background
minio server /data --console-address ":9001" &
MINIO_PID=$!

# Wait for MinIO to be available
# while ! nc -z localhost 9000; do   
sleep 10
# done

# Perform setup tasks
mc alias set ${MINIO_ALIAS} http://localhost:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}

if mc ls ${MINIO_ALIAS}/${BUCKET_NAME}; then   
  echo "Bucket exists."; 
else   
  echo "Bucket does not exist."; 
  mc mb ${MINIO_ALIAS}/${BUCKET_NAME}
  mc admin user add ${MINIO_ALIAS}  ${MINIO_BUCKET_USER} ${MINIO_BUCKET_PASSWORD}
  mc admin policy attach ${MINIO_ALIAS} readwrite --user ${MINIO_BUCKET_USER}
fi

# Add any additional setup commands here

# Wait for MinIO process to finish
wait $MINIO_PID