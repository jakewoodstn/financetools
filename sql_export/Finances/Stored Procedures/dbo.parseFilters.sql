-- Exported: 2026-06-21T21:55:41.303731+00:00
-- Schema:   dbo
-- Object:   parseFilters
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-09-02 19:50:46.473000
-- Modified: 2020-06-23 03:10:27.810000

CREATE PROCEDURE dbo.parseFilters (@incomingJSON NVARCHAR(MAX),@outgoingSQL NVARCHAR(MAX) OUTPUT)
AS
BEGIN


  DECLARE @t TABLE (
    element_id INT,
    parent_id INT,
    object_id INT,
    name VARCHAR(255),
    stringValue VARCHAR(255),
    valueType VARCHAR(255)
  )

  DECLARE @datesql NVARCHAR(MAX);
  DECLARE @amountsql NVARCHAR(MAX);
  DECLARE @catSQL NVARCHAR(MAX);
  DECLARE @tagSQL NVARCHAR(MAX);
  DECLARE @payeeSQL NVARCHAR(MAX);
  DECLARE @accountSQL NVARCHAR(MAX);
  DECLARE @orSQL NVARCHAR(MAX);
  DECLARE @andSQL NVARCHAR(MAX);
  DECLARE @sql NVARCHAR(MAX);


  INSERT INTO @t
    SELECT
      element_id,
      parent_id,
      object_id,
      name,
      stringValue,
      valueType
    FROM dbo.parseJSON(@incomingJSON)

  SELECT
    @catSQL = CASE when category ='%' OR category='%%' THEN 'coalesce(categoryName,'''')' ELSE 'categoryName' END + ' like ''' + category + ''''
  FROM (SELECT
    name,
    stringValue
  FROM @t
  WHERE name IN ('category', 'subcategory')) sq PIVOT (MIN(stringValue) FOR name IN (category, subcategory)) pvt

  SELECT
    @datesql = 'accountingdate between ''' + minDate + ''' and ''' + maxDate + ''''
  FROM (SELECT
    name,
    CAST(CAST(stringValue AS DATE) AS VARCHAR(10)) dt
  FROM @t
  WHERE name IN ('minDate', 'maxDate')) sq PIVOT (MIN(dt) FOR name IN (minDate, maxDate)) pvt

  SELECT
    @amountsql =
      CASE WHEN CAST(stringValue AS FLOAT) = 0.0 THEN '' ELSE 'amount = ' + stringValue + ' ' END
  FROM @t
  WHERE name = 'amount'
  AND parent_id = 3
  AND object_id IS NULL
  AND not EXISTS (SELECT * FROM @t where parent_id=2 and stringValue = 'amount');


SELECT
    @amountsql =
       'amount = ' + stringValue 
  FROM @t
  WHERE name = 'amount'
  AND parent_id = 3
  AND object_id IS NULL
  AND EXISTS (SELECT * FROM @t where parent_id=2 and stringValue = 'amount');


  SELECT
    @tagSQL = 'tags like  ''' + stringValue + ''''
  FROM @t
  WHERE object_id IS NULL
  AND parent_id = 3
  AND name = 'tag'
    AND stringValue<> '';

SET @tagSQL = COALESCE(@tagSQL,'');

  SELECT
    @payeeSQL = 'description like ''' + stringValue + ''''
  FROM @t
  WHERE parent_id = 3
  AND object_id IS NULL
  AND name = 'payee'

  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 1
    AND stringValue = '0')
    SELECT
      @accountSQL = '';
  ELSE
    SELECT
      @accountSQL = ' AND accountId in (' + STUFF(x, 1, 2, '') + ')'
    FROM (SELECT
      ', ' + stringValue
    FROM @t
    WHERE parent_id = 1
    FOR XML PATH ('')) y (x)

  SET @orSQL = '';
  SET @andSQL = @accountSQL;



  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 2
    AND stringValue = 'payee')
    SET @orSQL = @orSQL + ' OR ' + @payeeSQL
  ELSE
    SET @andSQL = @andSQL + ' AND ' + @payeeSQL;

  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 2
    AND stringValue = 'amount')
    SET @orSQL = @orSQL + ' OR ' + @amountsql
  ELSE
    SET @andSQL =
      CASE WHEN @amountsql = '' THEN @andSQL ELSE @andSQL + ' AND ' + @amountsql END;

  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 2
    AND stringValue IN ('category', 'subcategory'))
    SET @orSQL = @orSQL + ' OR ' + @catSQL
  ELSE
    SET @andSQL = @andSQL + ' AND ' + @catSQL;

  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 2
    AND stringValue IN ('minDate', 'maxDate'))
    SET @orSQL = @orSQL + ' OR ' + @datesql
  ELSE
    SET @andSQL = @andSQL + ' AND ' + @datesql;

  IF EXISTS (SELECT
      1
    FROM @t
    WHERE parent_id = 2
    AND stringValue = 'tag' AND LEN(@tagSQL)>0)
    SET @orSQL = @orSQL + ' OR ' + @tagSQL
  ELSE
    BEGIN
      IF LEN(@tagSQL)>0 SET @andSQL = @andSQL + ' AND ' + @tagSQL;
    END 

  IF @orSQL <> ''
    SET @orSQL = ' AND (' + RIGHT(@orSQL, LEN(@orSQL) - 4) + ')'

  SET @sql = @andSQL + @orSQL;

  WHILE LEFT(@sql, 5) = ' AND '
  BEGIN
    SET @sql = RIGHT(@sql, LEN(@sql) - 5)
  END

  SET @outgoingSQL = @sql;


  EXEC recordParameter 'parsedFilterResult',@outgoingSQL;
  
END;
