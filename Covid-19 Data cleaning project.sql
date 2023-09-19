/*Data cleaning in sql project from covid 19 dataset*/
SELECT * FROM portfolio..newcovid19


--date format change --
SELECT date,cONvert(date,date)
FROM portfolio..newcovid19

alter table newcovid19
add dateforamte date

update newcovid19
set dateforamte = cONvert(date,date)


--populate properly address--

SELECT *
FROM portfolio..newcovid19
WHERE address1 is null
ORDER BY iso_code


SELECT a.iso_code,a.address ,b.iso_code b.address1,is null (a.address b.address1)
FROM portfolio..newcovid19 a
JOIN portfolio..newcovid19 b
ON a.iso_code = b.iso_code
AND a.[iso_code] <> b.[iso_code]
WHERE address1 is null




--breking out address into individual column -- 

SELECT SUBSTRING(address1,1,CHARINDEX(' ',address1)+1) as statecade,
SUBSTRING(address1,CHARINDEX(' ',address1) -1 ,len(address1)) city
FROM portfolio..newcovid19


alter table portfolio..newcovid19
add address nvarchar(50)

update portfolio..newcovid19
set address = SUBSTRING(address1,1,CHARINDEX(' ',address1)+1)


alter table portfolio..newcovid19
add address nvarchr(255)


update portfolio..newcovid19
set address = SUBSTRING(address1,CHARINDEX(' ',address1) -1 ,len(address1)) 


--replase _ to--

SELECT PARSENAME(REPLACE(address,'_',' '),1)
FROM portfolio..newcovid19


--change y AND n to yes AND no--

SELECT * FROM portfolio..newcovid19

SELECT distinct(status),count(status)
FROM portfolio..newcovid19
group BY status
ORDER BY 2


SELECT status,
case when status = 'y' then'yes'
     when status = 'N' then 'NO'
     else status
     end
FROM portfolio..newcovid19

update portfolio..newcovid19
set status =case when status = 'y' then 'yes'
when status = 'N' then 'No'
else status
end


SELECT count(iso_code)
FROM portfolio..newcovid19
group BY iso_code
having count(iso_code)>1


SELECT iso_code,count(iso_code)
FROM portfolio..newcovid19
group BY iso_code


SELECT * FROM portfolio..newcovid19
group BY iso_code,locatiON,totalcases,total_deaths,date,status,address,address1,dateforamte,city,address
having count(iso_code)>1

-- remove duplicate--

with row_numCTE as (
SELECT *, row_number() over (partitiON BY iso_code,locatiON,totalcases,total_deaths,date,status ORDER BY iso_code) row_num
FROM portfolio..newcovid19
)
SELECT * FROM row_numCTE
WHERE row_num >1


alter table portfolio..newcovid19
drop column date