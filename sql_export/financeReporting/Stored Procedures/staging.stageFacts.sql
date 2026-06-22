-- Exported: 2026-06-21T21:55:42.330366+00:00
-- Schema:   staging
-- Object:   stageFacts
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-09-29 22:41:25.220000
-- Modified: 2021-02-07 23:18:39.270000

CREATE PROCEDURE staging.stageFacts(@startdate DATE = NULL, @enddate DATE = NULL) AS
  BEGIN

    
 IF @startdate IS NULL
    SELECT
      @startdate= '1/1/2018'
     ,@enddate = GETDATE()

    EXEC staging.resetImbalancedSplits @startdate, @enddate
    EXEC staging.stageTransactionFact @startdate, @enddate
    EXEC staging.stageBudgetTablesFromFinance @startdate, @enddate
    EXEC staging.stageEventTransactionFact
    EXEC staging.stageExpenseTier

  END
