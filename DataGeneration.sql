use Company;
go

insert into Department values ('D6.G2', 'Minsk, Tolstogo st., 10'), 
	('D1', 'Minsk, Tolstogo st., 10'),
	('HRD', 'Grodno, Sovetskaya st., 21'),
	('D5.G4', 'Toronto, 25 Av. st., 10'),
	('ID', 'New York, 10 Av. st., 15');

insert into Employee values ('Demeshchik', 'Alexander', '1997-04-09'),
	('Ivanov', 'Petr', '1990-05-10'),
	('Zhuk', 'Elena', '1998-08-21'),
	('Shcherbo', 'Evgenii', '1997-08-19'),
	('Sergeev', 'Alexander', '1995-03-22'),
	('Kaylo', 'Anatoliy', '1989-05-16'),
	('Khihol', 'Nadezhda', '1997-10-09'),
	('Volova', 'Elena', '1996-11-10'),
	('Balahanov', 'Oleg', '1997-05-21'),
	('Petsevich', 'Diana', '1997-08-03'),
	('Yurovskaya', 'Yana', '1996-12-22'),
	('Dovgun', 'Mikhail', '1998-01-16'),
	('Bucha', 'Anastasia', '1986-11-05'),
	('Zaborovskaya', 'Anna', '1996-12-16'),
	('Kurilovich', 'Elizaveta', '1997-10-16'),
	('Shakinko', 'Artyom', '1996-10-25'),
	('Smolik', 'Alexander', '1998-11-08'),
	('Petsevich', 'Margo', '1997-08-22'),
	('Keiko', 'Anastasia', '1990-04-19'),
	('Dolgaya', 'Yulia', '1989-12-13');

insert into Job values ('.Net developer', 300),
	('HRM', 400),
	('Java developer', 290),
	('HR recruiter', 390),
	('Big Data developer', 350),
	('Full Stack developer', 500),
	('Team-lead', 700),
	('Financial manager', 500),
	('Director', 1000);

-- Start generating careers

declare @randEmployee int = 0, 
		@randJob int = 0, 
		@randDepartment int = 0, 
		@jobsCount int = (select count(*) from Job), 
		@depCount int = (select count(*) from Department), 
		@empCount int = (select count(*) from Employee),
		@i int = 0;	
while @i < 100
begin
	set @randEmployee = 1 + (rand(checksum(newid())) * @empCount);
	set @randDepartment = 1 + (rand(checksum(newid())) * @depCount);
	set @randJob = 1 + (rand(checksum(newid())) * @jobsCount);

	declare @begin datetime, 
			@end datetime, 
			@randReceptionDate date, 
			@randDismissialDate date;

	select @begin = '2002-01-01', 
		   @end = GETDATE(),
		   @randReceptionDate = convert(date, cast(cast(@begin as float) + 
								(cast(@end as float) - 
								cast(@begin as float)) * 
								RAND(CHECKSUM(NEWID())) as datetime));

	if @randEmployee in (select EmployeeCode from Career)
	begin
		declare @prevDismissialDate date = (select top(1) DismissalDate 
				from Career where EmployeeCode = @randEmployee 
				order by DismissalDate desc);

		while @randReceptionDate < @prevDismissialDate
		begin
			set @randReceptionDate = convert(date, cast(cast(@begin as float) + 
				(cast(@end as float) - 
				cast(@begin as float)) * 
				RAND(CHECKSUM(NEWID())) as datetime));
		end;
	end;

	set @randDismissialDate = convert(date, cast(cast(@begin as float) + 
		(cast(@end as float) - 
		cast(@begin as float)) * 
		RAND(CHECKSUM(NEWID())) as datetime));

	while @randDismissialDate < @randReceptionDate
	begin
		set @randDismissialDate = convert(date, cast(cast(@begin as float) + 
			(cast(@end as float) - 
			cast(@begin as float)) * 
			RAND(CHECKSUM(NEWID())) as datetime));
	end;

	insert into Career 
		values(@randJob, @randEmployee, @randDepartment, @randReceptionDate, @randDismissialDate);

	set @i = @i + 1;
end;

declare @randCountNull int = 25 + (rand(checksum(newid())) * 25);
declare @counter int = 0;
while @counter < @randCountNull
begin

	declare @randomEmployee int = 1 + (rand(checksum(newid())) * 100);
	update Career set DismissalDate = NULL where EmployeeCode = @randomEmployee;
	set @counter = @counter + 1;
end;

-- End generation careers

-- Generating salary
				  
declare @id int = 1, 
		@careerId int = 0,
		@employeesCount int = (select count(*) from Employee), 
		@minSalary money = 0;
declare @codeTable table
(
	Code int
);

while @id <= @employeesCount
begin

	insert into @codeTable select Code from Career where EmployeeCode = @id;
	while (select top(1) Code from @codeTable) is not null
	begin

		set @careerId = (select Code from Career 
				where Code = (select top(1) Code from @codeTable));
		set @minSalary = (select j.MinSalary from Job j 
				left join Career c on j.Code = c.JobCode 
				where c.Code = @careerId);

		declare @recDate date, @disDate date; 
		select @recDate = ReceptionDate, 
			   @disDate = DismissalDate from Career where Code = @careerId;

		while @recDate <= @disDate
		begin

			declare @insYear int = 0, @insMonth int = 0;
			set @insYear = YEAR(@recDate);
			set @insMonth = MONTH(@recDate);

			insert into Salary 
				values(@id, @insMonth, @insYear, @minSalary + (rand(checksum(newid())) * 1000));
			set @recDate = DATEADD(month, 1, @recDate);

		end;

		delete top(1) from @codeTable;
	end;

set @id = @id + 1;
end;