# Assignment3 :blush:

This project is influenced by the powerful disruption that cloud computing has had on the world of Finance: :euro:

* Causing the current Fintech boom    
* Enabling a challenger banking model of Peer2Peer lending   
* Rewriting traditional credit risk management

The big data set that I have used comes from LendingClub.com goldmine of Loans data. :moneybag:

App
====
The App that I have built will allow users to explore all of the data through graphs and data tables, and in another tab an Interest Rate Predictor will assess their loan details and borrower demographics and establish what the likely interest rate that Lending Club will offer them.  This is calculated by algorithm based on a Generalised Linear Model.

S3 Dataset
==========
The S3 bucket I created was loaded with all of the available Loans data on LendingClub.com totalling 887391.  
Following intensive data cleaning, exploration and preprocessing the working dataset.

Implementation
===============
I deployed in 2 ways 
1. Shinyapps.io is a platform as a service (PaaS) for hosting Shiny web apps (applications).
2. Shiny Server is a server program that Linux servers can run to host a Shiny app as a web page. To use Shiny Server, you need a Linux server that has explicit support for Ubuntu 12.04 or greater (64 bit) and CentOS/RHEL 5 (64 bit). For this I set up an EC2 Instance on AWS

AWS EC2 Shiny Server Instance with IAM etc
===========================================
Please see Documentation on this implementation in 
https://github.com/DataDamsel/Assignment3/blob/master/Documentation/App%20Implementation%20Doc.doc

Data Exploration
================
As I explored the data I found some verey interesting insights and have provided some of the many graphs I produced. 
This Heat map shows the annual income per state and is also tagged with the number of loans per state
![Image of AnnualIncByState](https://github.com/DataDamsel/Assignment3/blob/master/Graphs/State%20and%20no%20of%20loans.png)

This graph shows the number of Loans per Loan Purpose ![Image of LoansPerPurpose](https://github.com/DataDamsel/Assignment3/blob/master/Graphs/Purpose%20Horizontal%20BarChart.png)

The rest can be seen in my data exploration document alomg with an explanation of insights in each graph:
https://github.com/DataDamsel/Assignment3/blob/master/Documentation/Exploratory%20Data%20Analysis.doc
 
Data Bucketing & Binning
========================
This work facilitated producing nice graphs and data tables for the Data Exploration Tab of my app.
https://github.com/DataDamsel/Assignment3/blob/master/Documentation/Data%20Binning%20%26%20Bucketing.doc

Future Work
===========

The app could connect to LendingClub via REST API  and the model could retrain the data each time so the results get more accurate over time as more data becomes available.
:email: I emailed LendingClub.com to see if I could get an investor account and therefore access to the REST API (only registered users can get this access to the REST API and it is not available in Ireland at this time).  LendingClub.com responded saying they “hope to offer investment opportunities to non US investors in the near future”.  So if this happens there would be an option to do further work on this app.
