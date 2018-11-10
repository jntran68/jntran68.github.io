# import the module
import os
#import module to read the CSV file
import csv
total_months = []
total_profitandloss = []
average_change = []
csvpath = os.path.join("Resources", "budget_data.csv")
#open the CSV file and create the new line as blank
with open("c:/Users/Nhung Tran/Desktop/github-data-analytics/Homework 3/Resources/budget_data.csv", newline='',encoding="utf-8") as csvfile:
   
    # CSV reader specifies delimiter and variable that holds contents
    csvreader = csv.reader(csvfile, delimiter=',')

    # Read the header row first 
    csv_header = next(csvreader)

    # Calculate the total number of months included in the dataset
    for row in csvreader:
        total_months.append(row[0])

    # Calculate the total net amount of "Profit/Losses" over the entire period
        total_profitandloss.append(int(row[1]))

    # Calculate the average change in "Profit/Losses" between months over the entire period
    for i in range(len(total_profitandloss)-1):
        average_change.append(total_profitandloss[i+1]-total_profitandloss[i])

    # Calculate the greatest increase in profits (date and amount) over the entire period
    greatest_increase = average_change.index(max(average_change))
    # Calculate the greatest decrease in losses (date and amount) over the entire period
    greatest_decrease = average_change.index(min(average_change))
    
