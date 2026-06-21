-- Exported: 2026-06-21T21:55:41.448343+00:00
-- Schema:   utilities
-- Object:   applyCorePlus
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-02-10 18:37:39.050000
-- Modified: 2020-06-21 22:22:36.430000


CREATE PROCEDURE dbo.applyCorePlus (@analyzeOnly INT = 0, @filter VARCHAR(1000) = '')
AS
BEGIN

  IF OBJECT_ID('tempdb..#t') IS NOT NULL
    DROP TABLE #t

  SELECT
    descs.description,
    c.categoryId,
    c.categoryName,
    COUNT(*) allCount,
    COUNT(te1.transactionTaggedEventId) taggedCount INTO #t
  FROM bankTransaction t

  INNER JOIN (SELECT
    btc.description
  FROM BankTransactionCat btc
  WHERE tags LIKE '%core+;%'
  EXCEPT
  SELECT
    description
  FROM (SELECT
    btc.description
  FROM BankTransactionCat btc
  WHERE tags LIKE '%core;%'
  UNION
  SELECT
    btc.description
  FROM BankTransactionCat btc
  WHERE tags LIKE '%exception;%'
  UNION
  SELECT
    btc.description
  FROM BankTransactionCat btc
  WHERE tags LIKE '%flex;%') sq) descs
    ON descs.description = t.description
  LEFT JOIN categorySplitDetails sd
    ON t.transactionId = sd.parentTransactionId
  LEFT JOIN transactionTaggedEvent te1
    ON te1.taggedEventId = 1244
    AND t.transactionId = te1.transactionId
    AND COALESCE(sd.splitTransactionId, 0) = COALESCE(te1.splitTransactionId, 0)
  LEFT JOIN spendingCategories c
    ON COALESCE(sd.categoryId, t.categoryId) = c.categoryId
  GROUP BY descs.description,
           c.categoryId,
           c.categoryName
  HAVING COUNT(*) <> COUNT(te1.transactionTaggedEventId)

  IF @analyzeOnly = 1
    SELECT
      *
    FROM #t t
  ELSE
    INSERT INTO transactionTaggedEvent (transactionId, taggedEventId, taggedAt, splitTransactionId)
      SELECT
        t.transactionId,
        1244,
        SYSDATETIME(),
        sd.splitTransactionId
      FROM bankTransaction t
      LEFT JOIN categorySplitDetails sd
        ON t.transactionId = sd.parentTransactionId
      INNER JOIN #t cplus
        ON t.description = cplus.description
        AND cplus.categoryId = COALESCE(sd.categoryId, t.categoryId)
      LEFT JOIN transactionTaggedEvent te
        ON t.transactionId = te.transactionId
        AND COALESCE(sd.splitTransactionId, 0) = COALESCE(te.splitTransactionId, 0)
        AND taggedEventId IN (1224, 1244, 1245, 1243)
      WHERE te.transactionTaggedEventId IS NULL AND t.description = COALESCE(NULLIF(@filter,''),t.description)

END
