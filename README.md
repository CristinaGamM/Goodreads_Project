Goodreads Library SQL Project
Project Overview
This is a personal SQL project built to develop my understanding of SQL, data cleaning and relational data modelling.

I used an export of my Goodreads library containing 393 books as a real-world dataset. The data was not perfectly consistent, which gave me an opportunity to practise identifying data-quality issues, deciding how they should be handled, and transforming the raw data into a more structured database.

The project is being developed alongside a self-directed SQL course.

Project Goals
Practise SQL using a real dataset rather than only tutorial exercises.
Explore and understand the structure and quality of raw data.
Identify inconsistencies, missing values and formatting issues.
Clean and transform data using SQL.
Learn how to organise related information into separate relational tables.
Practise using SQL joins to connect related data.
Document decisions and problems encountered during the process.
Project Workflow
Raw Goodreads data → Data investigation → Cleaning & transformation → Relational tables → Analysis

1. Raw Data Investigation
I first explored the raw dataset to understand what information it contained and look for potential data-quality problems.

Examples of checks included:

Checking unique author and binding values.
Looking for inconsistent capitalisation and spacing.
Investigating ISBN values containing unexpected characters.
Checking publication years for unexpected formats.
Looking for suspicious page-count values.
Checking the different values used for reading shelves.
Investigating missing values.
The investigation queries are kept in the SQL file because they show how I identified the problems rather than only showing the final cleaned result.

2. Data Cleaning
I created a Goodreads_Clean table from the raw data and used SQL transformations to address several issues.

ISBN
Some ISBN values contained characters introduced by the original export, such as ="...", while some records were blank.

I cleaned the unwanted characters and used Unknown where no ISBN was available.

Binding
Different versions of the same binding type appeared in the raw data, including differences in capitalisation and spacing.

I standardised these values into consistent categories such as:

Hardcover
Paperback
Audiobook
e-Book
Unknown Binding
Reading Shelf
The raw data contained variations in capitalisation, spacing and hyphenation.

These were standardised into consistent values such as:

Read
To read
Currently reading
Publication Years
Some year values contained unexpected extra digits.

I investigated these values and used SQL string functions to extract the expected four-digit year.

Number of Pages
I investigated unusually large page counts and records with values ending in an additional zero. Where the pattern indicated an extra trailing zero, I tested removing it.

This was a useful example of why data cleaning requires investigation rather than automatically changing every unusual value.

Publisher and Dates
Missing publisher values were replaced with Unknown.

Date_Added was converted to a SQL DATE format to make it more consistent and easier to work with.

3. Relational Data Modelling
After creating the cleaned dataset, I started separating the information into tables based on what each piece of data represents.

Current tables
Table	Purpose
Goodreads_Raw	Original imported Goodreads data
Goodreads_Clean	Cleaned and transformed version of the raw data
Books	Book-specific information such as title, ISBN, publisher and publication details
Reading	Reading activity such as date added, date read and reading shelf
Authors	A distinct list of authors with generated author IDs
Books_and_Authors	Links books to their authors
The Authors table uses an IDENTITY column to generate author IDs automatically.

The Books_and_Authors table uses a join between the cleaned Goodreads data and the Authors table to create the book-author relationships.

Additional Authors
The Goodreads export contains an Additional_Authors field. I found 60 records containing additional-author information.

For the current scope of the project, I have kept these values together rather than splitting them into separate author records.

This is a deliberate modelling decision. A future version could model additional authors separately.

What I Have Learned
Through this project I have been learning how to:

Investigate a dataset before transforming it.
Use SQL to identify data-quality problems.
Clean and standardise inconsistent values.
Work with NULL and missing values.
Use SQL string functions to investigate and transform data.
Create and populate tables using SQL.
Create relationships between tables using SQL joins.
Use IDENTITY to generate IDs.
Think about how data should be structured rather than keeping everything in one table.
Document decisions and problems encountered while working through a project.
One of the most useful parts of the project has been learning that cleaning data is not always about applying a simple rule. Some unusual values require investigation before deciding whether they are actually incorrect.

Challenges and Decisions
A few challenges during the project have been particularly useful for my learning:

The Goodreads export contained inconsistent formatting and missing values.
Some fields looked numeric but needed to be treated carefully when working with identifiers such as ISBNs.
I had to investigate unexpected page counts and publication-year values before deciding how to transform them.
I initially created the Authors table without knowing how to automatically generate IDs. After encountering the problem, I learned about IDENTITY and recreated the table.
I chose to keep the original raw data separate from the cleaned data so that transformations could be traced back to the source.
I have kept some investigation and failed attempts in the SQL file, with comments explaining what I learned from them.
Tools
SQL Server
SQL Server Management Studio (SSMS)
Goodreads library export
GitHub
SQL
Current Status
The project currently includes the raw data investigation, initial data cleaning and the first stage of relational modelling.

I am continuing to develop the database and analysis as I learn more SQL.

Future Improvements
Some ideas for future development include:

Adding primary and foreign keys to the relational tables.
Improving the modelling of additional authors.
Creating Genres and a BookGenres junction table.
Adding a separate table for special editions, including FairyLoot editions.
Adding more analysis queries and visualising findings.
Further reviewing the cleaned data and refining the transformations.
