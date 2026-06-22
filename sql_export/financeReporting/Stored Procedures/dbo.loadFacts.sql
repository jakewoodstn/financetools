-- Exported: 2026-06-21T21:55:42.293137+00:00
-- Schema:   dbo
-- Object:   loadFacts
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:36:31.127000
-- Modified: 2021-02-07 20:00:40.317000

CREATE PROCEDURE dbo.loadFacts (@startdate DATE, @enddate DATE)
  AS
  BEGIN

        EXEC staging.stageFacts @startdate
                                 ,@enddate
      
      
        DECLARE @check INT
      
        SELECT
          @check = COUNT(*)
        FROM (SELECT
                 COUNT(*) obs
               FROM staging.factTransaction t) staged
            ,(SELECT
                 COUNT(*) obs
               FROM Finances.dbo.bankTransaction t
               LEFT JOIN Finances.dbo.categorySplitDetails sd
                 ON t.transactionId = sd.parentTransactionId
               WHERE accountingdate
               BETWEEN @startdate AND @endDate) truth
        WHERE staged.obs - truth.obs <> 0
      
      
        IF @check = 0
        BEGIN
            EXEC loadBudgetRuleFact
            EXEC loadExpectedBudgetFact @startdate,@enddate
            EXEC loadTransactionFact 
            EXEC loadEventTransactionFact @startdate, @enddate
        END
        ELSE
        BEGIN
          PRINT @check
        END

  END
