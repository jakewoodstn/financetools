-- Exported: 2026-06-21T21:55:42.294933+00:00
-- Schema:   dbo
-- Object:   runValidation
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-09-29 22:48:36.360000
-- Modified: 2021-02-07 21:50:08.900000

CREATE PROCEDURE dbo.runValidation(@startdate DATE, @enddate DATE)
AS
BEGIN

  DELETE FROM staging.validationDateRange
  INSERT INTO staging.validationDateRange VALUES(@startdate,@enddate)
  
  DROP TABLE IF EXISTS #t
  DROP TABLE IF EXISTS #results
  
  CREATE TABLE #t(i INT IDENTITY(1,1) PRIMARY KEY,name varchar(255),run INT )
  CREATE TABLE #results (i INT, name varchar(255), obs INT)
  
  INSERT INTO #t (name, run) SELECT name, 0 AS run   FROM sys.views v WHERE name LIKE '%validation%' ORDER BY name
  DECLARE @i INT
  DECLARE @name varchar(255)
  DECLARE @sql NVARCHAR(4000)
  declare @param NVARCHAR(255) = '@i int, @name varchar(255)'
  
  
  
  WHILE EXISTS (SELECT i FROM #t WHERE run =0)
  BEGIN
    SELECT @i  = min (i) FROM #t t WHERE run = 0
    SELECT @name = name FROM #t WHERE i=@i;
    SELECT @sql = 'insert into #results (i, name, obs) select @i, @name, count(*) from ' +@name
    EXEC sys.sp_executesql @sql, @param, @i, @name
    UPDATE #t SET run = 1 WHERE i=@i
  END
  
  SELECT * FROM #results WHERE obs>0
  
  IF @@rowcount>0
  BEGIN
  
  UPDATE #t SET run = 0 WHERE i IN (SELECT i FROM #results r WHERE obs>0)
  WHILE EXISTS (SELECT i FROM #t WHERE run =0)
  BEGIN
    SELECT @i  = min (i) FROM #t t WHERE run = 0
    SELECT @name = name FROM #t WHERE i=@i;
    SELECT @sql = 'select * from ' +@name
    EXEC sys.sp_executesql @sql
    UPDATE #t SET run = 1 WHERE i=@i
  END
  END
  ELSE
    RAISERROR('No issues found',0,1) WITH NOWAIT  

END
