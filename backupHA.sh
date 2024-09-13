#!/bin/bash

# Directories
CONFIG_DIR="./homeassistant/config"  # Change to your Home Assistant config directory
BACKUP_DIR="./backup"  # Change to your desired backup directory

# Get current date details
TODAY=$(date +'%Y%m%d')
DAY_OF_MONTH=01
MONTH=$(date +'%m')
YEAR=$(date +'%Y')

# Backup file names
BACKUP_FILE="$BACKUP_DIR/homeassistant_$TODAY.tar.gz"
MONTHLY_BACKUP_FILE="$BACKUP_DIR/homeassistant_monthly_$YEAR$MONTH.tar.gz"
ANNUAL_BACKUP_FILE="$BACKUP_DIR/homeassistant_annual_$YEAR.tar.gz"

# Create a new backup
tar -czvf "$BACKUP_FILE" -C "$CONFIG_DIR" .

# Logic for keeping specific backups

# 1. Keep last 7 daily backups
find "$BACKUP_DIR" -type f -name "homeassistant_*.tar.gz" -mtime +7 -exec rm {} \;

# 2. If today is the 1st, save a monthly backup
if [ "$DAY_OF_MONTH" -eq "01" ]; then
    cp "$BACKUP_FILE" "$MONTHLY_BACKUP_FILE"
    # Delete monthly backups older than 12 months
    find "$BACKUP_DIR" -type f -name "homeassistant_monthly_*.tar.gz" -mtime +365 -exec rm {} \;
fi

# 3. If today is Jan 1st, save an annual backup
if [ "$DAY_OF_MONTH" -eq "01" ] && [ "$MONTH" -eq "01" ]; then
    cp "$BACKUP_FILE" "$ANNUAL_BACKUP_FILE"
    # Delete annual backups older than 7 years
    find "$BACKUP_DIR" -type f -name "homeassistant_annual_*.tar.gz" -mtime +2555 -exec rm {} \;
fi
