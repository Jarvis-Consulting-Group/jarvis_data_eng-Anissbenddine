# Introduction

# SQL Quries

###### Table Setup (DDL):


Here are the SQL DDL statements to create the required tables with primary keys and foreign keys (After creating the tables using the SQL DDL statements, dummy data is inserted into all the tables using the SQL INSERT query.) :


Members table:
```sql
CREATE TABLE cd.members
(
memid integer NOT NULL PRIMARY KEY,
surname character varying(200) NOT NULL,
firstname character varying(200) NOT NULL,
address character varying(300) NOT NULL,
zipcode integer NOT NULL,
telephone character varying(20) NOT NULL,
recommendedby integer,
joindate timestamp NOT NULL,
CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
REFERENCES cd.members(memid) ON DELETE SET NULL
);
```
Facilities table:

```sql
CREATE TABLE cd.facilities
(
facid integer NOT NULL PRIMARY KEY,
name character varying(100) NOT NULL,
membercost numeric NOT NULL,
guestcost numeric NOT NULL,
initialoutlay numeric NOT NULL,
monthlymaintenance numeric NOT NULL
);
```
Bookings table:

```sql

CREATE TABLE cd.bookings
(
bookid integer NOT NULL PRIMARY KEY,
facid integer NOT NULL REFERENCES cd.facilities(facid),
memid integer NOT NULL REFERENCES cd.members(memid),
starttime timestamp NOT NULL,
slots integer NOT NULL
);
```


###### Question 1: 

Adding a new facility - a spa. We add it into the facilities table

```sql
INSERT INTO facilities 
(facid,name,membercost,guestcost,initialoutlay,monthlymaintenance)
VALUES (9,'spa',20,30,1000000,800);
```

###### Questions 2: 

Adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. 

```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES ((SELECT max(facid) + 1 FROM facilities), 'Spa', 20, 30, 100000, 800);
```
###### Questions 3:

This will update the value of the initialoutlay column to 10000 for the facility with the name 'Tennis Court 2'.

```sql
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';
```

###### Questions 4: 

Updating the price of the second tennis court to be 10% more than the first one:


```sql
UPDATE cd.facilities
SET membercost = (SELECT membercost FROM cd.facilities WHERE facid = 0) * 1.1,
    guestcost = (SELECT guestcost FROM cd.facilities WHERE facid = 0) * 1.1
WHERE facid = 1;
```

###### Questions 5: 

Deleting all bookings from the cd.bookings table

```sql
DELETE FROM cd.bookings;
```

###### Questions 6: 

Removing member 37,

```sql
DELETE FROM cd.members
WHERE memid = 37;
```

###### Questions 7: 

Producing a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost

```sql
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost < monthlymaintenance/50 AND membercost > 0
ORDER BY facid;
```

###### Questions 8: 

Producing a list of all facilities with the word 'Tennis' in their name

```sql
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';
```

###### Questions 9: 

Retrieving the details of facilities with ID 1 and 5

```sql
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);
```

###### Questions 10: 

Producing a list of members who joined after the start of September 2012


```sql
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';
```

###### Questions 11: 

Combined list of all surnames and all facility names.


```sql
SELECT surname FROM cd.members UNION SELECT name FROM cd.facilities
```

###### Questions 12: 

Producing a list of the start times for bookings by members named 'David Farrell'

```sql
SELECT starttime 
FROM cd.bookings b
JOIN cd.members m ON b.memid = m.memid
WHERE m.firstname = 'David' AND m.surname = 'Farrell';
```

###### Questions 13: 

Producing a list of the start times for bookings for tennis courts, for the date '2012-09-21'?

```sql
SELECT starttime, name
FROM cd.bookings b
INNER JOIN cd.facilities f ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
  AND DATE(starttime) = '2012-09-21'
ORDER BY starttime;
```

###### Questions 14: 

List of all members, including the individual who recommended them

```sql
SELECT m1.firstname, m1.surname, m2.firstname AS recommended_firstname, m2.surname AS recommended_surname
FROM cd.members m1
LEFT JOIN cd.members m2 ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname;
```

###### Questions 15: 

List of all members who have recommended another member, there are no duplicates in the list, and that results are ordered by (surname, firstname).

```sql
SELECT DISTINCT m1.firstname, m1.surname
FROM cd.members m1
INNER JOIN cd.members m2 ON m1.memid = m2.recommendedby
ORDER BY m1.surname, m1.firstname;
```

###### Questions 16: 

List of all members, including the individual who recommended them (if any), without using any joins, there are no duplicates in the list, and each firstname + surname pairing is formatted as a column and ordered.

```sql
SELECT DISTINCT m.firstname || ' ' || m.surname AS member, r.firstname || ' ' || r.surname AS recommender
FROM cd.members AS m LEFT JOIN cd.members AS r ON m.recommendedby = r.memid
ORDER BY member
```

###### Questions 17: 

Producing a count of the number of recommendations each member has made. Ordered by member ID.

```sql
SELECT recommendedby, COUNT(*) AS recommendation_count
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
```

###### Questions 18: 

Producing a list of the total number of slots booked per facility. Sorted by facility id.

```sql
SELECT facid, SUM(slots) as total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;
```

###### Questions 19: 

Producing a list of the total number of slots booked per facility in the month of September 2012. Sorted by the number of slots.

```sql
SELECT facid, SUM(slots) as total_slots
FROM cd.bookings
WHERE EXTRACT(MONTH FROM starttime) = 9 AND EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid
ORDER BY total_slots;
```

###### Questions 20: 

Producing a list of the total number of slots booked per facility per month in the year of 2012. Sorted by the id and month.

```sql
SELECT 
  cd.bookings.facid, 
  EXTRACT(month FROM starttime) AS month,
  SUM(slots) AS total_slots
FROM 
  cd.bookings 
  INNER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid 
WHERE 
  EXTRACT(year FROM starttime) = 2012 
GROUP BY 
  cd.bookings.facid, 
  month 
ORDER BY 
  cd.bookings.facid, 
  month;
```

###### Questions 21: 

The total number of members (including guests) who have made at least one booking.

```sql
SELECT COUNT(DISTINCT memid)
FROM cd.bookings;
```

###### Questions 22:

Producing a list of each member name, id, and their first booking after September 1st 2012. Ordered by member ID.

```sql
SELECT
  m.surname,
  m.firstname,
  b.memid,
  MIN(b.starttime) AS starttime
FROM
  cd.bookings AS b
  INNER JOIN cd.members AS m
    ON b.memid = m.memid
WHERE
  b.starttime >= '2012-09-01'
GROUP BY
  m.surname,
  m.firstname,
  b.memid
ORDER BY
  b.memid;
```

###### Questions 23: 

Producing a list of member names, with each row containing the total member count. Ordered by join date, and including guest members.

```sql
SELECT
	(SELECT count(*) from members),
	 firstname, surname from members 
ORDER BY joindate
```

###### Questions 24: 

Producing a monotonically increasing numbered list of members (including guests), ordered by their date of joining.

```sql
SELECT 
  ROW_NUMBER() OVER(ORDER BY joindate) AS member_number, 
  firstname, 
  surname
FROM 
  cd.members
ORDER BY 
  joindate;
```

###### Questions 25: 

Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

```sql
SELECT facid, SUM(slots) AS total
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) = (
  SELECT MAX(total_slots) FROM (
    SELECT SUM(slots) AS total_slots
    FROM cd.bookings
    GROUP BY facid
  ) AS facility_totals
)
```

###### Questions 26:

Output the names of all members, formatted as 'Surname, Firstname'

```sql
SELECT CONCAT(surname, ', ', firstname) AS member_name
FROM cd.members
ORDER BY surname, firstname;
```

###### Questions 27: 

Finding all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.

```sql
SELECT memid, telephone
FROM cd.members
WHERE telephone LIKE '%(%'
ORDER BY memid;

```

###### Questions 28: 

Producing a count of how many members you have whose surname starts with each letter of the alphabet. Sorted by the letter.

```sql
SELECT 
  LEFT(surname, 1) AS first_letter, 
  COUNT(*) AS member_count
FROM 
  cd.members
GROUP BY 
  first_letter
HAVING 
  COUNT(*) > 0
ORDER BY 
  first_letter;
```





