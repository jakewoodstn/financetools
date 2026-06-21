-- Exported: 2026-06-21T21:55:41.303304+00:00
-- Schema:   dbo
-- Object:   json
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-12-25 22:25:50.240000
-- Modified: 2020-06-23 03:21:33.040000

CREATE procedure [dbo].[json] 
( @tablename nvarchar(255)
,@keyname NVARCHAR(255),@pFields fieldList READONLY)
as 
begin

declare @fields fieldlist;
DECLARE @subq NVARCHAR(max); 
DECLARE @flist NVARCHAR(max); 
declare @json varchar(max);

if exists (select top 1 * from @pfields)
begin
	insert into @fields select * from @pFields
end
else
begin
	if @tablename is not null
	begin
		insert into @fields select name from sys.columns where object_id = object_id(@tablename)
	end
end

SELECT @subq = @keyname + ' jsonkey ' + x 
FROM   (SELECT ', coalesce(Cast(' + fieldName 
               + ' as varchar(2000)),'''') ' + fieldName
        FROM   @fields 
        FOR xml path ('')) sq(x) 

SELECT @flist = Stuff(x, 1, 2, '') 
FROM   (SELECT ',  ' + fieldname 
        FROM   @fields
        FOR xml path ('')) sq(x) 

SET @subq = 'select jsonkey, value,fieldname from (SELECT ' 
            + @subq 
            + ' from '+@tablename+') sq unpivot( value for fieldname in (' 
            + @flist + '))upt' 
IF Object_id('tempdb..#t56020405') IS NOT NULL 
  DROP TABLE #t56020405 

CREATE TABLE #t56020405 
  ( 
     jsonkey   VARCHAR(2000), 
     fieldname VARCHAR(2000), 
     value     VARCHAR(2000) 
  ) 


INSERT INTO #t56020405 
            (jsonkey, 
             value, 
             fieldname) 
EXEC Sp_executesql 
  @subq 

IF Object_id('tempdb..#t560204052') IS NOT NULL 
  DROP TABLE #t560204052 

CREATE TABLE #t560204052 
  ( 
     jsonkey VARCHAR(2000), 
     json    VARCHAR(max) 
  ); 

INSERT INTO #t560204052 
SELECT DISTINCT jsonkey, 
                json='{' + Stuff(x, 1, 2, '') + '}' 
FROM   #t56020405 t 
       CROSS apply(SELECT ', "' + fieldname + '":"' + value + '"' 
                   FROM   #t56020405 t2 
                   WHERE  t.jsonkey = t2.jsonkey 
                   FOR xml path('')) s(x) 

SELECT @json = '{' + Stuff(x, 1, 2, '') + '}' 
FROM   (SELECT ', "' + jsonkey + '":' + json 
        FROM   #t560204052 
        FOR xml path('')) sq(x) ;
select @json;
        end;
