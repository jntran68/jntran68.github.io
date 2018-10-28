# import the module
import os
import csv
candidates = []
total_votes = 0
votecounter = []

csvpath = os.path.join('..', 'Resources', 'election_data.csv')
with open("c:/Users/Nhung Tran/Desktop/github-data-analytics/Homework 3/Resources/election_data.csv", newline='',encoding="utf-8") as csvfile:
    # CSV reader specifies delimiter and variable that holds contents
    csvreader = csv.reader(csvfile, delimiter=',')
    # Read the header row first 
    csv_header = next(csvreader)      

    # Calculate the total number of votes and A complete list of candidates who received votes
    for row in csvreader:
         total_votes += 1
         if row[2] in candidates.keys():
             candidates[row[2]] += 1
         else:
             candidates[row[2]] = 1

    # Calculate the percentage of votes; # of votes each candidate won; & winner
    percent_votes = []
    number_votes = []
    for n in number_votes:
        percent_votes = (number_votes/total_votes*100)
        if vote_counts[count] > max_votes:
            max_votes = vote_counts[count]
            print(max_votes)
            max_index = count
    winner = candidates[max_index]

   