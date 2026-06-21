-- Exported: 2026-06-21T21:55:41.444695+00:00
-- Schema:   dbo
-- Object:   vwSimpleBudgetSummary
-- Type:     VIEW
-- Created:  2018-04-08 19:20:34.220000
-- Modified: 2020-06-14 23:48:22.383000

--SELECT COUNT(*) FROM vwSimpleBudgetSummary sbs

CREATE VIEW dbo.vwSimpleBudgetSummary AS
SELECT
  b.simpleBudgetId,
  b.label1 Income_Expense,
  b.label2 budget,
  b.label3 subBudget,
  br.ruleIndex,
  b.sortOrder,
  CASE WHEN br.usePayee = 1 THEN br.payeePattern WHEN br.usePayee = 0 THEN 'N/A' END payeeRule,
  CASE WHEN br.useCat = 1 THEN br.categoryPattern WHEN br.useCat = 0 THEN 'N/A' END categoryRule,
  CASE WHEN br.useTag = 1 THEN br.tagpattern WHEN br.useTag = 0 THEN 'N/A' END tagRule,
  COALESCE(latestAmounts.actualAmount,0) latestActualSpend,
  COALESCE(latestAmounts.expectedAmount ,0) latestExpectedBudget
FROM simpleBudget b
LEFT JOIN (
            SELECT
               be.simpleBudgetId,
               be.amount expectedAmount,
               bca.amount actualAmount
            FROM simpleBudgetCalculatedActual bca
            INNER JOIN simpleBudgetExpected be
              ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
            INNER JOIN (
                          SELECT
                            MAX(be.transactionEndDate) maxTransactionEndDate
                          FROM simpleBudgetCalculatedActual bca
                          INNER JOIN simpleBudgetExpected be
                            ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
                          WHERE DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) BETWEEN be.effectiveDate AND be.retiredDate
                        ) maxDate
              ON maxDate.maxTransactionEndDate BETWEEN be.transactionStartDate AND be.transactionEndDate
            WHERE DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) BETWEEN be.effectiveDate AND be.retiredDate
  ) latestAmounts on b.simpleBudgetId = latestAmounts.simpleBudgetId
LEFT JOIN simpleBudgetRule br
  ON b.simpleBudgetId = br.simpleBudgetId
and DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) BETWEEN COALESCE(br.effectiveDate, '1/1/1900') AND COALESCE(br.retiredDate, '12/31/2199')
--ORDER BY b.sortOrder
