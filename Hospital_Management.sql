create database hospital;
use hospital;
show tables;

#Query 1 Write a SQL query to identify the physicians who are the department heads.
SELECT p.employeeid,
p.name,
d.name AS department_name
FROM physician p
JOIN department d
ON p.employeeid = d.head;

#Query 2 Write a SQL query to locate the floor and block where room number 212 is located.
SELECT blockfloor,
blockcode
FROM room
WHERE roomnumber = 212;

#Query 3 Write a SQL query to count the number of unavailable rooms. Return count as "Number of unavailable rooms"
select COUNT(*) as "Number of unavailable rooms"
from room
where unavailable = 't';

#Query 4 Write a SQL query to identify the physician and the department with which he or she is affiliated.
select
p.name as physician_name,
d.name as department_name
from physician p
join department d
on p.employeeid = d.head;

#Query 5 Write a SQL query to find those physicians who have received special training. 
select distinct
p.employeeid,
p.name,
p.position
from physician p
join trained_in t
on p.employeeid = t.physician;

#Query 6 Write a SQL query to identify the patients and the number of physicians with whom they have scheduled appointments.
SELECT patient, COUNT(physician) AS number_of_physicians
FROM appointment
GROUP BY patient;

#Query 7 Write a SQL query to count the number of unique patients who have been scheduled for examination room 'C'. 
select COUNT(patient) AS unique_patients 
FROM appointment 
WHERE examinationroom = 'C';

#Query 8 Write a SQL query to count the number of available rooms for each floor in each block. Sort the result-set on floor ID, ID of the block.
select blockfloor , blockcode , COUNT(*) AS available_rooms
FROM room 
WHERE unavailable = 0 
GROUP BY blockfloor , blockcode;

#Query 9 Create a view to display the name of the patients, their block, floor, and room number where 
#they are admitted
create view patient_detail as
select 
patient.name,
room.blockcode,
room.blockfloor,
room.roomnumber
from patient
join stay
on patient.ssn = stay.patient
join room
on stay.room = room.roomnumber;
select * from patient_detail;

#Query 10 Write a SQL query to find those patients who have undergone a procedure costing more than
#$,000, as well as the name of the physician who has provided primary care, should be
#identified

select
patient.name as patient_name,
physician.name as physician_name,
`procedure`.name as procedure_name,
`procedure`.cost name 
from patient
join physician 
on patient.pcp = physician.employeeid
join undergoes 
on patient.ssn = undergoes.patient
join `procedure` 
on undergoes.procedure = `procedure`.code
where `procedure`.cost > 5000;

#Query 11 Write a SQL query to identify those patients whose primary care is provided by a physician who is not the head of any department
select name from patient where pcp not in ( select head from department );

#Query 12 Retrieve the names of patients who have been prescribed at least one medication by a physician from the Psychiatry department using a subquery
select name from patient where ssn in
 ( select patient from prescribes where physician in
 (select physician from affiliated_with where department in 
 (select departmentid from department where name = 'Psychiatry')));
 
#Query 14 Update the insurance id of patients whose primary care physician(PCP) is 'John Dorian' to a new value '99999999'.
set SQL_SAFE_UPDATES = 0;
update patient
join physician on patient.PCP = physician.employeeid
set patient.insuranceid = '99999999'
where physician.name = 'John Dorian';
set SQL_SAFE_UPDATES = 1;
select * from patient;

#Query 15 Retrieve each physician's name along with the number of appointments they have, and show the ranking of each physician based on the number of appointments in descending order
select p.name AS physician_name,
COUNT(a.appointmentid) AS appointment_count,
rank() over (ORDER BY COUNT(a.appointmentid) DESC) as ranking
from physician p, appointment a
where p.employeeid = a.physician
group by p.name
order by appointment_count desc;
