if object_id('tempdb..#t') is not null DROP TABLE #t
CREATE TABLE #t (schemaName VARCHAR(255), tableName VARCHAR(255), used INT DEFAULT 0 , obs INT  DEFAULT 0)

INSERT INTO #t (schemaname, tablename) SELECT s.name,t.name FROM sys.tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id

DECLARE @basesql VARCHAR(MAX) = 'update #t set obs = sq.obs from #t, (select count(*) obs from [<replace1/>].[<replace2/>]) sq where schemaname = @1 and tablename = @2'
  DECLARE @sql NVARCHAR(MAX)
DECLARE @params NVARCHAR(MAX) = '@1 varchar(255), @2 varchar(255)'

WHILE EXISTS (SELECT TOP 1 * FROM #t t WHERE used = 0)
  BEGIN

      DECLARE @tname VARCHAR(255) ,@sname VARCHAR(255)

      SELECT TOP 1 @tname = tablename , @sname = schemaName FROM #t WHERE used = 0
      
      SET @sql = REPLACE(REPLACE(@basesql,'<replace2/>',@tname),'<replace1/>',@sname)
        PRINT @sql
      EXEC sys.sp_executesql @sql, @params, @sname, @tname

      UPDATE #t SET used = 1 WHERE tableName = @tname AND schemaName = @sname

  END

SELECT * FROM #t ORDER BY 1,2
