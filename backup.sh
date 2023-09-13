#!/bin/bash

TIMESTAMP=$(date +%Y%m%d%H%M%S)
mysqldump -u admin -padmin bookdb > /mnt/mydata/backup_$TIMESTAMP.sql
