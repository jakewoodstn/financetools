-- Exported: 2026-06-21T21:55:42.316987+00:00
-- Schema:   staging
-- Object:   stageBudgetTablesFromFinance
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:00:58.387000
-- Modified: 2021-02-07 18:32:52.870000

CREATE PROCEDURE staging.stageBudgetTablesFromFinance (@startdate DATE, @enddate DATE)

AS

BEGIN


  TRUNCATE TABLE staging.budgetRule

  INSERT INTO staging.budgetRule (simpleBudgetRuleId, simpleBudgetID, ruleIndex, usePayee, useCat, useTag, payeePattern, categoryPattern, tagpattern, effectiveDate, retiredDate)
    SELECT
      br.simpleBudgetRuleId
     ,br.simpleBudgetId
     ,br.ruleIndex
     ,br.usePayee
     ,br.useCat
     ,br.useTag
     ,br.payeePattern
     ,br.categoryPattern
     ,br.tagpattern
     ,br.effectiveDate
     ,br.retiredDate

    FROM finances.dbo.simpleBudgetRule br

    WHERE @startdate BETWEEN br.effectiveDate AND br.retiredDate


  TRUNCATE TABLE staging.budgetExpected


  INSERT INTO staging.budgetExpected (simpleBudgetExpectedId, simpleBudgetId, transactionStartDate, transactionEndDate, amount,subbudgetId)

    SELECT
      be.simpleBudgetExpectedId
     ,be.simpleBudgetId
     ,be.transactionStartDate
     ,transactionEndDate
     ,amount
     ,bm.subbudgetId
    FROM finances.dbo.simpleBudgetExpected be
      INNER JOIN staging.vwBudgetMap bm ON be.simpleBudgetId = bm.simpleBudgetId
    WHERE @startdate <= be.transactionEndDate AND @enddate>=be.transactionStartDate

  UPDATE staging.budgetExpected SET subbudgetId = bm.subbudgetId
    FROM staging.budgetExpected e INNER JOIN staging.vwBudgetMap bm ON e.simpleBudgetId = bm.simpleBudgetId

END
