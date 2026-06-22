-- Exported: 2026-06-21T21:55:42.313204+00:00
-- Schema:   dbo
-- Object:   vwValidationCategoryTransactionCount
-- Type:     VIEW
-- Created:  2020-06-14 20:53:49.497000
-- Modified: 2021-02-07 21:32:32.233000

CREATE VIEW dbo.vwValidationCategoryTransactionCount
AS
SELECT
  baseSet.categoryName
 ,COALESCE(baseSet.baseMetric, 0) baseMetric
 ,checkset.matchName
 ,COALESCE(checkSet.checkMetric, 0) checkMetric
FROM (SELECT
    CASE
      WHEN t.categoryStatus = 0 THEN 'Uncategorized - Uncategorized'
      ELSE COALESCE(categoryName, 'Uncategorized - Uncategorized')
    END categoryName
   ,COUNT(transactionId) AS baseMetric
  FROM finances.dbo.bankTransactionCat t
  INNER JOIN dimdate d
    ON t.accountingDate = d.StandardDate
  INNER JOIN staging.validationDateRange dr on d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY CASE
    WHEN t.categoryStatus = 0 THEN 'Uncategorized - Uncategorized'
    ELSE COALESCE(categoryName, 'Uncategorized - Uncategorized')
  END) baseSet
FULL OUTER JOIN (SELECT
    cg.categoryGroupName
   ,c.categoryName
   ,s.subcategoryName
   ,CASE
      WHEN COALESCE(s.subcategoryName, '') = '' THEN cg.categoryGroupName + ' - ' + c.categoryName
      ELSE c.categoryName + ' - ' + s.subcategoryName
    END matchName
   ,COUNT(t.remoteTransactionId) checkMetric
  FROM factTransaction t
  INNER JOIN dimSubcategory s
    ON t.subcategoryId = s.subcategoryId
  INNER JOIN dimCategory c
    ON s.categoryId = c.categoryId
  INNER JOIN dimCategoryGroup cg
    ON c.categoryGroupId = cg.categoryGroupId
  INNER JOIN dimDate d
    ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr on d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY c.categoryName
          ,s.subcategoryName
          ,cg.categoryGroupName) checkSet
  ON baseSet.categoryName = checkSet.matchName
WHERE COALESCE(baseSet.baseMetric, 0) <> COALESCE(checkSet.checkMetric, 0)
