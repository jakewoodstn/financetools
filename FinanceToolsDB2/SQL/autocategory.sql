USE Finances
GO

CREATE PROCEDURE autoCategory_Calculate
AS
BEGIN

  --DECLARE @update INT = 0
  TRUNCATE TABLE autoCategory;

  INSERT INTO autoCategory (description, accountingDate, categoryId, categoryName, transactionId)
    SELECT
      bt.description,
      accountingDate,
      sc.categoryid,
      sc.categoryName,
      bt.transactionId
    FROM bankTransaction bt
    INNER JOIN (SELECT
      transactionId,
      btc.description
    FROM BankTransactionCat btc
    WHERE btc.categoryId IS NULL
    AND btc.accountingDate >= '11/1/2018') missing
      ON bt.transactionId = missing.transactionId
    INNER JOIN (SELECT
      description
    FROM BankTransactionCat btc
    WHERE btc.categoryId IS NOT NULL
    AND btc.categoryStatus = -1
    GROUP BY description
    HAVING COUNT(DISTINCT btc.categoryId) = 1
    AND COUNT(*) > 5) found
      ON found.description = missing.description
    INNER JOIN (SELECT
      description,
      categoryId
    FROM BankTransactionCat btc
    WHERE btc.categoryId IS NOT NULL
    AND btc.categoryStatus = -1
    GROUP BY description,
             categoryId) cat
      ON cat.description = found.description
    INNER JOIN vSpendingCategories sc
      ON cat.categoryId = sc.categoryid


  --IF @update <> 1
  --  SELECT
  --    *
  --  FROM #base
  --  ORDER BY description, accountingDate DESC
  --
  --IF @update = 1
  UPDATE bt
  SET categoryId = cat.categoryId
  FROM autoCategory cat
  INNER JOIN bankTransaction bt
    ON cat.transactionId = bt.transactionId

END