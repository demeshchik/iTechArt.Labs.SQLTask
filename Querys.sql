use Company;
go

-- 1) Получить все содержимое таблицы Employee
select * from Employee;

-- 2) Получить коды и названия должностей, чья минимальная зарплата не превышает 500
select Code, Name from Job where MinSalary < 500;

-- 3) Получить среднюю заработную плату начисленную в январе 2015 года
select AVG(Salary) from Salary where Month = 1 and Year = 2015;


-- Subquerys --

-- 4) Получить имя самого старого работника, а также его возраст
select top(1) Name, DATEDIFF(year, Birthday, GETDATE()) as [Years] from Employee order by Birthday asc;

-- 5) Найти фамилии работников, которым была начислена зарплата в январе 2015 года
select Surname from Employee where Code in (select EmployeeCode from Salary where Year = 2015 and Month = 1);

-- 6) Найти коды работников, зарплата которых в мае 2015 года снизилась по сравнению с каким-либо предыдущим месяцем этого же года
select EmployeeCode from Salary sq 
					where YEAR = 2015 and 
					MONTH = 5 and 
					Salary < any (select Salary from Salary where Year = 2015 and MONTH < 5 and EmployeeCode = sq.EmployeeCode);

-- 7) Получить информацию о кодах, названиях отделов и количестве работающих в этих отделах в настоящее время сотрудников
select d.Code,
	   d.Name,
	   (select count(*) from Career where DepartmentCode = d.Code and DismissalDate is NULL) as Count
 from Department d;


-- Group

-- 8) Найти среднюю начисленную зарплату за 2015 год в разрезе работников
select (select Surname from Employee where Code = s.EmployeeCode) as [Surname],
	   avg(Salary) as [Salary] 
	from Salary s where Year = 2015 group by EmployeeCode;

-- 9) Найти среднюю зарплату за 2015 год в разрезе работников. Включать в результат только тех работников, начисления которым проводились не менее двух раз
select (select Surname from Employee where Code = s.EmployeeCode) as [Surname],
	   avg(Salary) as [Salary] 
	from Salary s where Year = 2015 and (select count(Month) from Salary where EmployeeCode = s.EmployeeCode) > 2 group by EmployeeCode;


-- Table joins

-- 10) Найти имена тех работников, начисленная зарплата которых за январь 2015 превысила 1000
select e.Surname, e.Name, s.Salary from Employee e left join Salary s on e.Code = s.EmployeeCode where Salary > 1000 and Month = 1 and Year = 2015;

-- 11) Найти имена работников и стаж их непрерывной работы (на одной должности и в одном отделе).
select e.Surname as [Surname],
	   e.Name as [Name],
	   d.Name as [Department],
	   j.Name as [Job],
	   DATEDIFF(YEAR, c.ReceptionDate, c.DismissalDate) as [Time(years)] from Career c 
	   left join Employee e on e.Code = c.EmployeeCode
	   left join Department d on c.DepartmentCode = d.Code
	   left join Job j on c.JobCode = j.Code;


-- Modification

-- 12) Увеличить минимальную зарплату для всех должностей в 1.5 раза
update Job set MinSalary = MinSalary * 1.5;

-- 13) Удалить из таблицы salary все записи за 2014 и более ранние годы
delete from Salary where YEAR <= 2014;