-- Exported: 2026-06-21T21:55:42.315745+00:00
-- Schema:   dbo
-- Object:   vwValidationTransactionCountComparison
-- Type:     VIEW
-- Created:  2020-01-27 01:00:52.130000
-- Modified: 2021-02-07 21:56:43.853000

CREATE VIEW dbo.vwValidationTransactionCountComparison
AS
SELECT
  btc.obs - (te.obs + ti.obs) AS obs
FROM (SELECT
         COUNT(*) obs
       FROM vwTransactionExpense
           INNER JOIN dimDate d ON vwTransactionExpense.DateSK = d.DateSK
           INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
    ) te
    ,(SELECT
         COUNT(*) obs
       FROM vwTransactionIncome
         INNER JOIN dimDate d ON vwTransactionIncome.DateSK = d.DateSK
           INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  ) ti
    ,(SELECT
         COUNT(*) obs
       FROM finances.dbo.BankTransactionCat fbtc
         INNER JOIN staging.validationDateRange dr ON fbtc.accountingDate BETWEEN dr.minDate AND dr.maxDate
  ) btc
WHERE btc.obs - te.obs -ti.obs <> 0
