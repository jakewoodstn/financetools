-- Exported: 2026-06-21T21:55:41.417444+00:00
-- Schema:   dbo
-- Object:   returntransactions
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2013-01-01 16:51:16.943000
-- Modified: 2020-06-23 03:09:59.470000

CREATE PROCEDURE dbo.returntransactions (@includeSplit INT = 0,
@categorized INT = 0,
@acctId INT = 0,
@sort VARCHAR(255) = 'accountingDate',
@dir VARCHAR(4) = 'desc',
@searchParam VARCHAR(255) = '')
AS
BEGIN

  IF @searchParam = ''
    SET @searchParam = N'{"payee":"%","minDate":"2011-09-01T05:00:00.000Z","maxDate":"' + CAST(SYSDATETIME() AS VARCHAR) 
      + '","category":"%","subcategory":"%","tag":"%","amount":0,"accountId":[0],"or":[]}'


  DECLARE @sql NVARCHAR(MAX);
  DECLARE @sort2 VARCHAR(255) = '';
  DECLARE @tname NVARCHAR(50);
  DECLARE @whereClause NVARCHAR(MAX);


  IF @includeSplit = 0
    SET @tname = 'BankTransactionCatNoSplit bt'
  ELSE
    SET @tname = 'BankTransactionCat bt';

  IF @sort = 'description'
    SET @sort = 'case when description like ''checkcard %'' then ltrim(rtrim(substring(description, charindex('' '',description,12),len(description)-12))) else description end';

  IF @sort <> 'accountingDate'
    SET @sort2 = ',accountingDate'

  SET @sql = 'select transactionid, transactionDate, accountingDate, description,coalesce(cast(categoryId as varchar(50)),'''') categoryId,coalesce(categoryName,'''') categoryName,amount,bankOrigDescription,accountName,accountid,tags,tagCount, sorter=row_number() over ( order by ' + @sort + ' ' + @dir + @sort2 + ') from ' + @tname + ' where transactionDate>=''9/1/2011'''
  IF @acctId <> 0
    SET @sql = @sql + ' and accountId=' + CAST(@acctId AS VARCHAR(10))

  IF @categorized = 0
    SET @sql = @sql + ' and(categoryStatus>=0 or categoryStatus is null)'

  EXEC parseFilters @searchParam,
                    @whereClause OUTPUT;


  SET @sql = @sql + CASE WHEN COALESCE(@whereClause, '') = '' THEN '' ELSE ' AND ( ' + @whereClause END + ')';

  SET @sql = @sql + ' order by ' + @sort + ' ' + @dir + @sort2;

  EXEC recordParameter @parameterName = 'finalSQL',
                       @parameterValue = @sql;

  EXEC sp_executesql @sql;

END;
