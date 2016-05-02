# Assignment3

This project is influenced by the powerful disruption that cloud computing has had on the world of Finance:

-Causing the current Fintech boom
-Enabling a challenger banking model of Peer2Peer lending
-rewriting traditional credit risk management

The big data set that I have used comes from LendingClub.com.

App
====
The App that I have built will allow users to explore all of the data throughgraphs and data tables, and in anopther tab an Interest Rate Predictor will assess their loan details and borrower demographics and establish what the likely interest rate that Lending lub will offer them is.  The algorithm is based on a Generalised Linear Model.

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


 

