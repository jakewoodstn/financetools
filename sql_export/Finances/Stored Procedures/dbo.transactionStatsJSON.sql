-- Exported: 2026-06-21T21:55:41.423863+00:00
-- Schema:   dbo
-- Object:   transactionStatsJSON
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2016-03-06 19:54:21.990000
-- Modified: 2020-06-23 03:09:45.093000

CREATE PROCEDURE dbo.transactionStatsJSON
(
  @includeSplitLines  INT          = 0,
  @includeCategorized INT          = 0,
  @acctId             INT          = 0,
  @sort               VARCHAR(255) = 'accountingDate',
  @dir                VARCHAR(4)   = 'desc',
  @searchParam        VARCHAR(255) = '',
  @debug              INT          = 0
)
AS
BEGIN

if object_id('tempdb..#t') is not null drop table #t;

  CREATE TABLE #t(
    transactionId VARCHAR(1000),
    transactionDate VARCHAR(1000),
    accountingDate VARCHAR(1000),
    description VARCHAR(1000),
    categoryId VARCHAR(1000),
    categoryName VARCHAR(1000),
    amount MONEY,
    bankOrigDescription VARCHAR(1000),
    accountName VARCHAR(1000),
    accountId VARCHAR(1000),
    tags VARCHAR(1000),
    tagCount VARCHAR(1000),
    sorter INT 
  )

  DECLARE @modifiedSearchParam VARCHAR(255);

  IF @searchParam LIKE 'payee:%' 
    SET @modifiedSearchParam = RIGHT(@searchParam,LEN(@searchParam)-6);
  ELSE 
    SET @modifiedSearchParam = @searchParam;
 
  IF CHARINDEX('''',@modifiedSearchParam) >0 
    SET @modifiedSearchParam = REPLACE(@modifiedSearchParam,'''','''''');

  --EXEC recordParameter 'statsSearch',@modifiedSearchParam

  INSERT INTO #t EXEC returnTransactions @includeSplitLines,@includeCategorized, @acctid ,@sort ,@dir,@modifiedsearchParam;
  
  IF not EXISTS (SELECT top 1 * FROM #t) 
      BEGIN
        SELECT '{}';
        RETURN;
      END;          


  DECLARE @payeeStats TABLE(payeeStatId INT IDENTITY(1,1) PRIMARY KEY,transactionType VARCHAR(255), payeeName VARCHAR(1000),obs VARCHAR(20), spent varchar(20))
  DECLARE @catStats TABLE(catStatId INT IDENTITY(1,1) PRIMARY KEY,transactionType VARCHAR(255), categoryName varchar(1000),obs VARCHAR(20), spent varchar(20))
  DECLARE @tagStats TABLE(tagStatId INT IDENTITY(1,1) PRIMARY KEY,transactionType VARCHAR(255), tag VARCHAR(1000),obs VARCHAR(20), spent VARCHAR(20))

  INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT top 8  'expense' , categoryName, COUNT(transactionId), ABS(SUM(CAST(amount as MONEY))) 
    FROM #t t
    WHERE t.categoryName<>'' AND amount<0
    group by   categoryName 
    ORDER by 3 DESC

  INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT 'expense' , 'Other Expense Categories', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)))
    FROM #t t LEFT JOIN @catStats cs ON t.categoryName = cs.categoryName
    WHERE cs.categoryName is NULL AND t.categoryName<>'' AND amount<0



  INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT 'expense' , 'Uncategorized Expenses', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)) )
    FROM #t t
    WHERE t.categoryName='' AND amount<0

    
  
  INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT top 3 'income' , categoryName, COUNT(transactionId), ABS(SUM(CAST(amount as MONEY))) 
    FROM #t t
    WHERE t.categoryName<>'' AND amount>0
    group by   categoryName 
    ORDER by 3 DESC

INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT 'income' , 'Other Income Categories', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)))
    FROM #t t LEFT JOIN @catStats cs ON t.categoryName = cs.categoryName
    WHERE cs.categoryName is NULL AND t.categoryName<>'' AND amount>0

  INSERT into @catStats(transactionType, categoryName,obs,spent)
    SELECT 'income' , 'Uncategorized Income', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)) )
    FROM #t t
    WHERE t.categoryName='' AND amount>0


INSERT into @payeeStats(transactionType, payeeName,obs,spent)
    SELECT top 9  'expense' , description, COUNT(transactionId), ABS(SUM(CAST(amount as MONEY))) 
    FROM #t t
    WHERE t.description<>'' AND amount<0
    group by   description 
    ORDER by 3 DESC

  INSERT into @payeeStats(transactionType, payeeName,obs,spent)
    SELECT 'expense' , 'Other Payees', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)))
    FROM #t t LEFT JOIN @payeeStats ps ON t.description = ps.payeeName
    WHERE ps.payeeName is NULL AND t.description<>'' AND amount<0

  
  INSERT into @payeeStats(transactionType, payeeName,obs,spent)
    SELECT top 4 'income' , description, COUNT(transactionId), ABS(SUM(CAST(amount as MONEY))) 
    FROM #t t
    WHERE t.description<>'' AND amount>0
    group by   description  
    ORDER by 3 DESC

    
  INSERT into @payeeStats(transactionType, payeeName,obs,spent)
    SELECT 'income' , 'Other Payees', COUNT(transactionId), ABS(SUM(CAST(amount as MONEY)))
    FROM #t t LEFT JOIN @payeeStats ps ON t.description = ps.payeeName
    WHERE ps.payeeName is NULL AND t.description<>'' AND amount>0


IF @debug=1 SELECT * FROM @catStats

  DECLARE @retStage table (stageValue nvarchar(max));


INSERT into @retStage
SELECT '"categoryStats":['+STUFF(y,1,2,'')+']'
     FROM
       (SELECT ', {"'+transactionType+'":{"name":"' + categoryName + '","obs":' + obs + ',"spend":'+spent+'}}'
        FROM
          @catStats
        ORDER by catStatId        
        FOR XML
          PATH ('')) ss (y)
  
IF @searchParam NOT LIKE 'payee:%'
INSERT into @retStage
SELECT '"payeeStats":['+STUFF(y,1,2,'')+']'
     FROM
       (SELECT ', {"'+transactionType+'":{"name":"' + payeeName + '","obs":' + obs + ',"spend":'+spent+'}}'
        FROM
          @payeeStats
        ORDER by payeeStatId        
        FOR XML
          PATH ('')) ss (y)


SELECT '{' + STUFF(y,1,2,'') + '}'  FROM (SELECT ', ' + stageValue FROM @retStage FOR XML PATH('')) sq(y)

END
