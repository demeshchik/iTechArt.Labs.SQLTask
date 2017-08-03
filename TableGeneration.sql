use Company;
go

-- Department
CREATE TABLE Department(
	Code int IDENTITY(1,1) NOT NULL primary key,
	Name varchar(50) NOT NULL,
	Address varchar(50) NOT NULL
);

-- Employee
CREATE TABLE Employee(
	Code int IDENTITY(1,1) NOT NULL primary key,
	Surname varchar(50) NOT NULL,
	Name varchar(20) NOT NULL,
	Birthday date NOT NULL
);

-- Job
CREATE TABLE Job(
	Code int IDENTITY(1,1) NOT NULL primary key,
	Name varchar(50) NOT NULL,
	MinSalary money NOT NULL
);

-- Career
CREATE TABLE Career(
	Code int IDENTITY(1,1) NOT NULL primary key,
	JobCode int NOT NULL,
	EmployeeCode int NOT NULL,
	DepartmentCode int NOT NULL,
	ReceptionDate date NOT NULL,
	DismissalDate date
);
ALTER TABLE Career ADD FOREIGN KEY (JobCode) REFERENCES Job(Code); 
ALTER TABLE Career ADD FOREIGN KEY (EmployeeCode) REFERENCES Employee(Code); 
ALTER TABLE Career ADD FOREIGN KEY (DepartmentCode) REFERENCES Department(Code); 

-- Salary
CREATE TABLE Salary(
	Code int IDENTITY(1,1) NOT NULL primary key,
	EmployeeCode int NOT NULL,
	Month int NOT NULL,
	Year int NOT NULL,
	Salary money NOT NULL
);

ALTER TABLE Salary ADD FOREIGN KEY (EmployeeCode) REFERENCES Employee(Code); 

