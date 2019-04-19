USE Finances
GO

DECLARE @update INT = 1

IF @update = 0
  OR (@update = 1
  AND OBJECT_ID('tempdb..#candidate') IS NULL)
BEGIN
  IF OBJECT_ID('tempdb..#candidate') IS NOT NULL
    DROP TABLE #candidate

  SELECT
    ROW_NUMBER() OVER (ORDER BY bt.description, bt.accountingDate) AS rn,
    bt.transactionId,
    bt.description,
    c.categoryName,
    accountingDate,
    cat.spendingTier,
    timesUsed,
    1 AS useMapping INTO #candidate
  FROM bankTransaction bt
  LEFT JOIN categorySplitDetails sd
    ON bt.transactionId = sd.parentTransactionId
  LEFT JOIN spendingCategories c
    ON bt.categoryId = c.categoryId
  INNER JOIN (SELECT
    transactionId,
    sts.description
  FROM vwSpendingTierSummaryUncategorized sts
  WHERE sts.spendingTier = 'Error'
  AND sts.actdate >= '201811') missing
    ON bt.transactionId = missing.transactionId
  INNER JOIN (SELECT
    description,
    COUNT(*) timesUsed
  FROM vwSpendingTierSummary btc
  WHERE btc.spendingTier NOT IN ('Exception', 'Error')
  AND btc.actdate >= '201801'
  GROUP BY description
  HAVING COUNT(DISTINCT btc.spendingTier) = 1
  AND COUNT(*) > 1) found
    ON found.description = missing.description
  INNER JOIN (SELECT
    description,
    sts.spendingTier
  FROM vwSpendingTierSummary sts
  WHERE sts.spendingTier NOT IN ('Exception', 'Error')
  AND sts.actdate >= '201801'
  GROUP BY description,
           spendingTier) cat
    ON cat.description = found.description
  WHERE sd.splitTransactionId IS NULL
  ORDER BY description, bt.accountingDate DESC

UPDATE #candidate SET useMapping = 0 WHERE description = 'Paypal'
  UPDATE #candidate SET useMapping = 0 WHERE description = 'The Home Depot'

  IF @update = 0
    SELECT
      *
    FROM #candidate c
END

IF @update = 1
  AND OBJECT_ID('tempdb..#candidate') IS NOT NULL
BEGIN

  INSERT INTO transactionTaggedEvent (transactionId, taggedEventId)
    SELECT
      c.transactionId,
      e.taggedEventId
    FROM #candidate c
    INNER JOIN taggedEvent e
      ON REPLACE(c.spendingTier, ' ', '') = e.taggedEventTag
    WHERE c.categoryName IS NOT NULL AND c.useMapping=1

END

--