-- Exported: 2026-06-21T21:55:41.423383+00:00
-- Schema:   dbo
-- Object:   transactionsJSON
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2013-01-01 21:39:51.690000
-- Modified: 2020-06-23 03:09:33.507000

CREATE PROCEDURE dbo.transactionsJSON
(
  @includeSplitLines  INT          = 0,
  @includeCategorized INT          = 0,
  @acctId             INT          = 0,
  @sort               VARCHAR(255) = 'accountingDate',
  @dir                VARCHAR(4)   = 'desc',
  @searchParam        VARCHAR(255) = ''
)
AS
BEGIN

EXEC recordParameter 'incomingFilter',@searchParam;

if object_id('tempdb..#t') is not null drop table #t;
if object_id('tempdb..#t2') is not null drop table #t2;

  CREATE TABLE #t(
    transactionId VARCHAR(1000),
    transactionDate VARCHAR(1000),
    accountingDate VARCHAR(1000),
    description VARCHAR(1000),
    categoryId VARCHAR(1000),
    categoryName VARCHAR(1000),
    amount VARCHAR(1000),
    bankOrigDescription VARCHAR(1000),
    accountName VARCHAR(1000),
    accountId VARCHAR(1000),
    tags VARCHAR(1000),
    tagCount VARCHAR(1000),
    sorter INT 
  )

  INSERT INTO #t EXEC returnTransactions @includeSplitLines,@includeCategorized, @acctid ,@sort ,@dir,@searchParam;

  IF not EXISTS (SELECT top 1 * FROM #t) 
      BEGIN
        SELECT '[]';
        RETURN;
      END;          

  CREATE TABLE #t2(
    transactionid VARCHAR(1000),
    val VARCHAR(MAX)
  );

  INSERT INTO #t2
  SELECT transactionId
       , '"' + fieldname + '" : "' + fieldvalue + '"' val
  FROM
    (SELECT transactionId
          , transactionDate
          , accountingDate
          , description
          , categoryId
          , categoryName
          , amount
          , bankOrigDescription
          , accountName
          , accountId
          , tags
          , tagCount
     FROM
       #t) sq
    UNPIVOT (fieldvalue FOR fieldname IN (transactionDate, accountingdate, description, categoryid, categoryname, amount, bankorigdescription, accountname, accountId, tags, tagCount)) upt

CREATE index t_tid on #t(transactionId)
CREATE INDEX t2_tid on #t2(transactionid)

  SELECT COALESCE('[' + stuff(y, 1, 2, '') + ']','[]')
  FROM
    (SELECT DISTINCT y
     FROM
       (SELECT ', {"transaction":{"transactionId":"' + transactionId + '"' + x + '}}'
        FROM
          #t t
          CROSS APPLY (SELECT ', ' + val
                       FROM
                         #t2 t2
                       WHERE
                         t.transactionId = t2.transactionId
                       FOR XML
                         PATH ('')) s (x)
        ORDER by t.sorter
        FOR XML
          PATH ('')) ss (y)) sss;



END
