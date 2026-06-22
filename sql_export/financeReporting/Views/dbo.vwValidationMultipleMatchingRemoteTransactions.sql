-- Exported: 2026-06-21T21:55:42.315412+00:00
-- Schema:   dbo
-- Object:   vwValidationMultipleMatchingRemoteTransactions
-- Type:     VIEW
-- Created:  2020-06-14 20:18:10.050000
-- Modified: 2021-02-07 21:44:14.650000

CREATE VIEW dbo.vwValidationMultipleMatchingRemoteTransactions AS
  SELECT
    t.remoteTransactionId
   ,t.remoteTransactionSplitId
   ,t.description
   ,t.payeeId
   ,t.categoryId
   ,t.categoryName
   ,t.subcategoryId
   ,t.accountId
   ,t.subbudgetId
   ,t.accountingDate
   ,t.dateSK
   ,t.amount
  FROM staging.factTransaction t
    INNER JOIN staging.validationDateRange dr ON t.accountingDate BETWEEN dr.minDate AND dr.maxDate
  INNER JOIN (SELECT
      t.remoteTransactionId
     ,t.remoteTransactionSplitId
    FROM staging.factTransaction t
       INNER JOIN staging.validationDateRange dr ON t.accountingDate BETWEEN dr.minDate AND dr.maxDate
    GROUP BY t.remoteTransactionId
            ,t.remoteTransactionSplitId
    HAVING COUNT(*) > 1) errors
    ON errors.remoteTransactionId = t.remoteTransactionId
      AND COALESCE(errors.remoteTransactionSplitId, 0) = COALESCE(t.remoteTransactionSplitId, 0)
