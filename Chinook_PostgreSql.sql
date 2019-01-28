/* 2.1 SELECT
Task – Select all records from the Employee table.
Task – Select all records from the Employee table where last name is King.
Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
*/
select * from employee
where lastname = 'King';

select * from employee
where firstname = 'Andrew' and reportsto is null;

/*2.2 ORDER BY
Task – Select all albums in Album table and sort result set in descending order by title.
Task – Select first name from Customer and sort result set in ascending order by city
*/

select title from album order by title asc;
select firstname, lastname, city from customer order by city;

/*2.3 INSERT INTO
Task – Insert two new records into Genre table
Task – Insert two new records into Employee table
Task – Insert two new records into Customer table
*/

select * from genre;
insert into genre(genreid, name) values (26, 'Indie Rock'), (27, 'Podcast');

select * from employee;
insert into employee(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
	values (9, 'Garcia', 'Mileena', 'IT Staff', 6, '1995-05-11', '2019-01-24', '3725 W Dakota', 'Lethbridge', 'AB', 'Canada', 'T1K5M9', '+1(559)709-2774', '+1(403)456-8194', 'mileena@chinookcorp.com'),
	(10, 'Acosta', 'Brandon', 'Sales Supprt Agent', 2, '1994-12-11', '2019-01-23', '3725 W Dakota', 'Lethbridge', 'AB', 'Canada', 'T1K5L6', '+1(559)421-5433', '+1(403)456-9716', 'brandon@chinookcorp.com');

select * from customer;
insert into customer(customerid, firstname, lastname, address, city, state, country, phone, email, supportrepid) 
	values (60, 'Rebecca', 'Ortiz', '5154 N Marty', 'Fresno', 'CA', 'USA', '+1(209)486-2596', 'ro@gmail.com', 4 ),
	(61, 'Tom', 'Mendoza', '6934 W Shaw', 'Fresno', 'CA', 'USA', '+1(559)761-5690', 'tom@yahoo.com', 4);

/*2.4 UPDATE
Task – Update Aaron Mitchell in Customer table to Robert Walter
Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
*/

select * from customer;
update customer 
set firstname = 'Robert', lastname = 'Walter'
where firstname = 'Aaron' and lastname = 'Mitchell'; 

select * from artist;
update artist
set name = 'CCR'
where name = 'Creedence Clearwater Revival';

/*2.5 LIKE
Task – Select all invoices with a billing address like “T%”
*/

select * from invoice 
where billingaddress like 'T%';

/*2.6 BETWEEN
Task – Select all invoices that have a total between 15 and 50
Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
*/

select * from invoice 
where total 
between 15 and 50;

select * from employee
where hiredate
between '2003-06-01' and '2004-03-01';

/*2.7 DELETE
Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
*/

--delete from customer where firstname = 'Robert' and lastname = 'Walter'; 


select * from customer;

alter table invoiceline
drop constraint fk_invoicelineinvoiceid;

alter table invoiceline
add constraint k_invoicelineinvoiceid foreign key (invoiceid) references invoice(invoiceid) on delete cascade;

alter table invoice
drop constraint fk_invoicecustomerid;

alter table invoice
add constraint fk_invoicecustomerid foreign key (customerid) references customer(customerid) on delete cascade;

delete from customer where firstname = 'Robert' and lastname = 'Walter';


/*3.0 SQL Functions
In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
*/

/*3.1 System Defined Functions
Task – Create a function that returns the current time.
Task – create a function that returns the length of a mediatype from the mediatype table
*/

create or replace function getTime() 
returns timestamptz as $$ 
begin
	return now();
end; 
$$ language plpgsql;

select getTime();


create or replace function getLength(id int) 
returns int as $$
begin
	return length(name) from mediatype where mediatypeid = id;
end;
$$ language plpgsql;

select getLength(2);


/*3.2 System Defined Aggregate Functions
Task – Create a function that returns the average total of all invoices
Task – Create a function that returns the most expensive track
*/

create or replace function totalAvg() 
returns numeric as $$
begin
	return avg(total) from invoice;
end;
$$ language plpgsql;

select totalAvg();




create or replace function mostExpensiveTrack() 
returns numeric as $$
begin
	return max(track.unitprice) from track;
end;
$$ language plpgsql;

select mostExpensiveTrack();




/*3.3 User Defined Scalar Functions
Task – Create a function that returns the average price of invoiceline items in the invoiceline table
*/

create or replace function avgPrice() 
returns numeric as $$
begin
	return avg(unitprice) from invoiceline;
end;
$$ language plpgsql;

select avgPrice();

/*3.4 User Defined Table Valued Functions
Task – Create a function that returns all employees who are born after 1968.
*/

create or replace function bornAfter1968() 
returns setof employee as $$
begin
	return Query(select * from employee where extract(year from birthdate) > 1968);
end;
$$ language plpgsql;

select bornAfter1968();

/*4.0 Stored Procedures
 In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
*/

/*4.1 Basic Stored Procedure
Task – Create a stored procedure that selects the first and last names of all the employees.
*/
create function namesOfEmployees() returns TABLE(firstname text, lastname text) as 
    $$ select firstname, lastname from employee 
    $$ language sql;


/*4.2 Stored Procedure Input Parameters
Task – Create a stored procedure that updates the personal information of an employee.
Task – Create a stored procedure that returns the managers of an employee.
*/
create or replace function update_emp(
	p_id int, 
	p_birthdate timestamp, 
	p_address varchar, 
	p_city varchar, 
	p_state varchar,
	p_country varchar,
    p_postalcode varchar,
    p_phone varchar,
    p_fax varchar,
    p_email varchar
)
returns void as $$
begin
    update employee
    	set birthdate = p_birthdate,
    	address = p_address,
    	city = p_city,
    	state = p_state,
    	country = p_country,
    	postalcode = p_postalcode,
    	phone = p_phone,
    	fax = p_fax,
    	email = p_email
        where employeeid = p_id;
end;
$$ language plpgsql;

select update_emp(10, '1994-12-11', '5972 N Fresno', 'Calgary', 'AB', 'USA', 'T2P 6L8', '+1(403)569-1367', null , 'ba@gmail.com');

select * from employee;




--TASK 2
create table e_managers (
	employeeid serial primary key,
	m_name text,
	e_name text
);

create or replace function employeeManagers()
returns refcursor as $$
	declare
		ref refcursor;
	begin
		open ref for select 
			concat(m.firstname, ', ', m.lastname) as "Manager Name",
			concat(e.firstname, ', ', e.lastname) as "Employee Name"
			from employee as m
			inner join employee as e  
			on m.employeeid = e.reportsto
			order by m.employeeid;
		return ref;
	end;
$$ language plpgsql;

do $$
declare
    curs refcursor;
  	v_m_name text;
  	v_e_name text;
begin
    select employeeManagers() into curs;
   	loop
        fetch curs into v_m_name, v_e_name;
        exit when not found;
        insert into e_managers (m_name, e_name) values(v_m_name, v_e_name);
   	end loop;
end;
$$ language plpgsql;

select * from e_managers;

/*4.3 Stored Procedure Output Parameters
Task – Create a stored procedure that returns the name and company of a customer.
*/


create table temp_customers (
	id serial primary key,
	name text,
	company text
);

create or replace function getCustomers()
returns refcursor as $$
	declare
		ref refcursor;
	begin
		open ref for select 
			concat(firstname, ' ', lastname),
			company
			from customer
			order by customerid;
		return ref;
	end;
$$ language plpgsql;

do $$
declare
    curs refcursor;
  	v_name text;
  	v_company text;
begin
    select getCustomers() into curs;
   	loop
        fetch curs into v_name, v_company;
        exit when not found;
        insert into temp_customers (name, company) values(v_name, v_company);
   	end loop;
end;
$$ language plpgsql;

select * from temp_customers;


/*5.0 Transactions
In this section you will be working with transactions. Transactions are usually nested within a stored procedure.
Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
*/
begin;
	delete from invoice where invoiceid = 405;
commit;

create or replace function insert_customer(
	p_id integer, 
	p_firstname varchar, 
	p_lastname varchar, 
	p_company varchar, 
	p_address varchar, 
	p_city varchar, 
	p_state varchar, 
	p_country varchar, 
	p_postalcode varchar, 
	p_phone varchar, 
	p_fax varchar, 
	p_email varchar, 
	p_supportrepid int
) 
returns void as $$
	begin
		insert into customer values(p_id, p_firstname, p_lastname, p_company, p_address, p_city, p_state, p_country, p_postalcode, p_phone, p_fax, p_email, p_supportrepid);
	end;
$$ language plpgsql;

select insert_customer(62, 'Kristen', 'Bell', null, '9437 E Fruit', 'Los Angeles', 'CA', 'USA', '90564', '+1(861)667-3597', null , 'bell@gmail.com', 9);

select * from customer;


/*6.0 Triggers
In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
6.1 AFTER/FOR
Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
Task – Create an after update trigger on the album table that fires after a row is inserted in the table
Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
*/

create or replace function hello_world()
returns trigger as $$
	begin
		raise 'Hello, World';
	end;
$$ language plpgsql;


create trigger after_employee_insert
	after insert on employee
	for each row
    execute procedure hello_world();
   
drop trigger after__employee_insert on employee;

create trigger after_album_update
	after update on album
	for each row
    execute procedure hello_world();
   
insert into album values (350, 'Testing', 275);
update album set title = 'Updated Title' where albumid = 350;
select * from album;
delete from album where albumid = 350;

drop trigger after_album_update on album;

create trigger after_customer_delete
	after delete on customer
	for each row
    execute procedure hello_world();
   
insert into customer (customerid, firstname, lastname, email) values (62, 'John', 'Doe', 'jd@gmail.com');
select * from customer;
delete from customer where customerid = 62;

drop trigger after_customer_delete on customer;


/*7.0 JOINS
In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
7.1 INNER
Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
*/

Select invoiceid as "invoiceid", firstname as "fname", lastname as "lname" from customer C 
	Inner join invoice I on c.customerid = i.customerid;


/*7.2 OUTER
Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
*/
select c.customerid as "customerid", firstname as "firstname", lastname as "lastname", invoiceid as "invoiceid", total as "total"
    from invoice I full join customer C on C.customerid = I.customerid;
   
/*7.3 RIGHT
Task – Create a right join that joins album and artist specifying artist name and title.
*/

select name as "artistname", title as "title" from album A 
    right join artist art on a.artistid = art.artistid;
   
/*7.4 CROSS
Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
*/

select name as "artistname" from album a 
    cross join artist order by name asc;

/*7.5 SELF
Task – Perform a self-join on the employee table, joining on the reportsto column.
*/

select e.firstname, e.lastname, e.reportsto from employee e inner join employee m on true;
