# DATAWAREHOUSE (STAR SCHEMA)
To create a star schema in a data warehouse, the first step is to upload the dvdrental tar file into a PostgreSQL database. This file includes approximately 15 tables in normalized form, and their entity relationships are shown in the image below.

![image](https://user-images.githubusercontent.com/101486899/236881639-5e6e1b33-7b59-4d68-8550-96fa76073ce3.png)

The main objective of this project is to transform the existing normalized tables into a star schema that includes both fact and dimension tables. This involves joining various normalized tables to create the desired schema.
