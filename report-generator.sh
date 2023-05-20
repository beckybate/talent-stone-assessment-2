#!/bin/bash

# Part 1 - gather data for the report

# Download the CSV file
curl -o organizations.csv https://github.com/datablist/sample-csv-files/raw/main/files/organizations/organizations-100.csv

# Extract a list of full names, sort, and save to /tmp/names.txt
cut -d',' -f3 organizations.csv | tail -n +2 | sort > /tmp/names.txt

# Count the number of employees and save to /tmp/employee_count.txt
employee_count=$(wc -l organizations.csv | cut -d' ' -f1)
echo "Total number of employees: $employee_count" > /tmp/employee_count.txt

# Extract lines containing the abbreviation "Inc" and save to /tmp/lines-with-inc.txt
grep -i "Inc" organizations.csv > /tmp/lines-with-inc.txt

# Part 2 - Create and save the final report

# Get the current date and public IP
current_date=$(date "+%m/%d/%Y")
public_ip=$(curl -s https://api.ipify.org)

# Create the final report
echo "Report created on $current_date, IP: $public_ip" > /tmp/final-report.txt
echo >> /tmp/final-report.txt
echo "Header line: $(cat /tmp/employee_count.txt)" >> /tmp/final-report.txt
echo >> /tmp/final-report.txt
echo "Company names that contain the word Inc:" >> /tmp/final-report.txt
grep -i "inc" organizations.csv | cut -d',' -f1 | sort | sed 's/^/* /' >> /tmp/final-report.txt
echo >> /tmp/final-report.txt
echo "All names, sorted:" >> /tmp/final-report.txt
sed 's/^/* /' /tmp/names.txt >> /tmp/final-report.txt
