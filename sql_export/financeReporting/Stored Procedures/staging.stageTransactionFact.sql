-- Exported: 2026-06-21T21:55:42.330779+00:00
-- Schema:   staging
-- Object:   stageTransactionFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-27 23:06:15.317000
-- Modified: 2021-02-07 21:04:53.480000

CREATE PROC staging.stageTransactionFact (@startdate DATE, @endDate DATE)
AS

BEGIN


  IF @startdate IS NULL
    SELECT
      @startdate = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
     ,@enddate = GETDATE()

  IF OBJECT_ID('staging.factTransaction') IS NOT NULL
  BEGIN
    TRUNCATE TABLE staging.factTransaction
  END
  ELSE
  BEGIN

    CREATE TABLE staging.factTransaction (

      remoteTransactionId INT
     ,remoteTransactionSplitId INT
     ,description VARCHAR(255)
     ,payeeId INT
     ,categoryId INT
     ,categoryName VARCHAR(255)
     ,subcategoryId INT
     ,accountId INT
     ,subbudgetId INT
     ,accountingDate VARCHAR(10)
     ,dateSK INT
     ,amount SMALLMONEY

    )

  END


  INSERT INTO staging.factTransaction (remoteTransactionId, remoteTransactionSplitId, description, categoryId, categoryName, accountId, accountingDate, amount)
    SELECT
      t.transactionId
     ,sd.splitTransactionId
     ,description
     ,CASE
        WHEN t.categoryStatus = 0 THEN 0
        ELSE COALESCE(sd.categoryId, t.categoryId)
      END
     ,CASE 
        WHEN t.categoryStatus=0 THEN 'Uncategorized - Uncategorized' 
        ELSE COALESCE(c.categoryName,'Uncategorized - Uncategorized') 
      END
     ,t.accountId
     ,accountingDate
     ,COALESCE(sd.splitAmount, t.amount)
    FROM Finances.dbo.bankTransaction t
    LEFT JOIN Finances.dbo.categorySplitDetails sd
      ON t.transactionId = sd.parentTransactionId
        LEFT JOIN finances.dbo.spendingCategories c ON COALESCE(sd.categoryId, t.categoryId) = c.categoryId
    WHERE accountingdate BETWEEN @startdate AND @endDate;

  UPDATE s
  SET payeeId = d.payeeId
  FROM staging.factTransaction s
  INNER JOIN dimPayee d
    ON s.description = d.payeeName
  
  UPDATE s
  SET dateSK = d.dateSK
  FROM staging.factTransaction s
  INNER JOIN dimDate d
    ON s.accountingDate = d.FullDate

  UPDATE s
   SET 
    categoryId = v.categoryId,
    subcategoryId = v.subcategoryId
  FROM staging.factTransaction s
    INNER JOIN vwDescriptionCategory v ON s.categoryName = v.categoryName + COALESCE(' - ' + NULLIF(v.subcategoryName,''),'')

END;
