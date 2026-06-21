-- Exported: 2026-06-21T21:55:41.468354+00:00
-- Schema:   utilities
-- Object:   materializeSimpleBudgetActual
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-03-20 22:51:57.673000
-- Modified: 2020-06-21 22:37:41.133000

CREATE PROCEDURE dbo.materializeSimpleBudgetActual (@startDate DATE = '4/1/2017',
@endDate DATE = '4/30/2017',
@sendMessage INT = 0,
@force INT = 0,
@accountId INT = NULL, 
  @debug INT = NULL)
AS
BEGIN

  SET NOCOUNT ON
  SET XACT_ABORT ON

  --phase 0: check if materialization is necessary
  DECLARE @signals TABLE (
    signalType VARCHAR(255),
    indicator INT
  )

 

  INSERT INTO @signals EXEC testMaterializationSignals

  IF NOT EXISTS (SELECT TOP 1
      *
    FROM @signals)
    AND @force = 0 --no materialization indicated AND force is not specified
  BEGIN
    IF @sendMessage > 0 --if notification requested
    BEGIN
      SELECT
        'No Materialization Needed';--notify
    END;
    RETURN; --end proc
  END;

  DECLARE @earliest DATE
  DECLARE @latest DATE

  DECLARE @transactionHolder TABLE (
    simpleBudgetId INT,
    transactionId BIGINT,
    splitTransactionId INT,
    transactionDate DATE,
    amount SMALLMONEY
  )
  DECLARE @basesql NVARCHAR(MAX) = 'SELECT DISTINCT @budgetParam, btc.transactionId, btc.splitTransactionId, btc.accountingDate,  amount from bankTransactionCat btc 
                                  WHERE accountingDate between @edate and @ldate and accountId = coalesce(@acctId,accountId) and (<replace/>)'
  DECLARE @sqlparams NVARCHAR(255) = '@budgetParam int, @edate date, @ldate date,@acctId int'
  DECLARE @sql NVARCHAR(MAX) = ''
  DECLARE @thisWhere NVARCHAR(MAX)
  DECLARE @thisBudget INT

  DECLARE @payeeRules TABLE (
    simpleBudgetId INT,
    ruleIndex INT,
    payeeClause NVARCHAR(MAX)
  )
  DECLARE @catRules TABLE (
    simpleBudgetId INT,
    ruleIndex INT,
    catClause NVARCHAR(MAX)
  )
  DECLARE @tagRules TABLE (
    simpleBudgetId INT,
    ruleIndex INT,
    tagClause NVARCHAR(MAX)
  )
  DECLARE @lineRules TABLE (
    simpleBudgetId INT,
    ruleIndex INT,
    indexClause NVARCHAR(MAX)
  )
  DECLARE @finalRules TABLE (
    simpleBudgetId INT,
    whereClause NVARCHAR(MAX),
    used INT NOT NULL DEFAULT 0
  )

  SELECT
    @earliest = dd.FirstDayOfMonth
  FROM DimDate dd
  WHERE dd.FullDate = @startDate
  SELECT
    @latest = dd.LastDayOfMonth
  FROM DimDate dd
  WHERE dd.FullDate = @endDate

  DELETE sbca
    FROM simpleBudgetCalculatedActual sbca
    INNER JOIN simpleBudgetExpected be
      ON sbca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
  WHERE be.transactionStartDate >= @earliest
    AND be.transactionEndDate <= @latest

  --phase 1 build SQL
  INSERT INTO @payeeRules
    SELECT
      sq.simpleBudgetId,
      sbr.ruleIndex,
      'description like ''' + payeePattern + ''''
    FROM simpleBudgetRule sbr
    INNER JOIN (SELECT
      simpleBudgetId,
      ruleIndex,
      MIN(br.simpleBudgetRuleId) firstRecord
    FROM simpleBudgetRule br
    WHERE br.usePayee = 1
    GROUP BY br.simpleBudgetId,
             br.ruleIndex) sq
      ON sbr.simpleBudgetRuleId = sq.firstRecord


  INSERT INTO @catRules
    SELECT
      sq.simpleBudgetId,
      sbr.ruleIndex,
      'COALESCE(categoryName,'''') like ''' + sbr.categoryPattern + ''''
    FROM simpleBudgetRule sbr
    INNER JOIN (SELECT
      simpleBudgetId,
      ruleIndex,
      MIN(br.simpleBudgetRuleId) firstRecord
    FROM simpleBudgetRule br
    WHERE br.useCat = 1
    GROUP BY br.simpleBudgetId,
             br.ruleIndex) sq
      ON sbr.simpleBudgetRuleId = sq.firstRecord


  INSERT INTO @tagRules
    SELECT DISTINCT
      sbr.simpleBudgetId,
      sbr.ruleIndex,
      STUFF(x, 1, 5, '') AS tagClause
    FROM simpleBudgetRule sbr
    CROSS APPLY (SELECT
      ' AND (btc.tags like ''' + tagpattern + ';%'' OR btc.tags like ''%;' + tagpattern + ';%'')'
    FROM simpleBudgetRule br
    WHERE br.useTag = 1
    AND br.simpleBudgetId = sbr.simpleBudgetId
    AND br.ruleIndex = sbr.ruleIndex
    GROUP BY br.simpleBudgetId,
             br.ruleIndex,
             br.tagpattern
    ORDER BY br.tagpattern
    FOR XML PATH ('')) sq (x)
    WHERE x IS NOT NULL

  INSERT INTO @lineRules
    SELECT
      pr.simpleBudgetId,
      pr.ruleIndex,
      STUFF(COALESCE(' AND ' + pr.payeeClause, '') + COALESCE(' AND ' + cr.catClause, '') + COALESCE(' AND ' + tr.tagClause, ''), 1, 5, '') indexClause
    FROM @payeeRules pr
    LEFT JOIN @catRules cr
      ON pr.simpleBudgetId = cr.simpleBudgetId
      AND pr.ruleIndex = cr.ruleIndex
    LEFT JOIN @tagRules tr
      ON pr.simpleBudgetId = tr.simpleBudgetId
      AND pr.ruleIndex = tr.ruleIndex
    UNION
    SELECT
      cr.simpleBudgetId,
      cr.ruleIndex,
      STUFF(COALESCE(' AND ' + pr.payeeClause, '') + COALESCE(' AND ' + cr.catClause, '') + COALESCE(' AND ' + tr.tagClause, ''), 1, 5, '') indexClause
    FROM @catRules cr
    LEFT JOIN @payeeRules pr
      ON pr.simpleBudgetId = cr.simpleBudgetId
      AND pr.ruleIndex = cr.ruleIndex
    LEFT JOIN @tagRules tr
      ON cr.simpleBudgetId = tr.simpleBudgetId
      AND cr.ruleIndex = tr.ruleIndex
    UNION
    SELECT
      tr.simpleBudgetId,
      tr.ruleIndex,
      STUFF(COALESCE(' AND ' + pr.payeeClause, '') + COALESCE(' AND ' + cr.catClause, '') + COALESCE(' AND ' + tr.tagClause, ''), 1, 5, '') indexClause
    FROM @tagRules tr
    LEFT JOIN @payeeRules pr
      ON pr.simpleBudgetId = tr.simpleBudgetId
      AND pr.ruleIndex = tr.ruleIndex
    LEFT JOIN @catRules cr
      ON tr.simpleBudgetId = cr.simpleBudgetId
      AND tr.ruleIndex = cr.ruleIndex


  INSERT INTO @finalRules (simpleBudgetId, whereClause)
    SELECT DISTINCT
      simpleBudgetId,
      STUFF(x, 1, 4, '') finalWhere
    FROM @lineRules olr
    CROSS APPLY (SELECT
      ' OR (' + indexClause + ')'
    FROM @lineRules lr
    WHERE olr.simpleBudgetId = lr.simpleBudgetId
    ORDER BY ruleIndex
    FOR XML PATH ('')) sq (x)


  --Materialize "all other" expenses
  INSERT INTO @finalRules (simpleBudgetId, whereClause, used)
    SELECT
      31,
      '(AMOUNT < 0 or tags like ''%refund;%'')' + COALESCE('AND NOT (' + STUFF(sq.x, 1, 3, '') + ')', ''),
      0
    FROM (SELECT
      'OR ' + whereClause
    FROM @finalRules
    WHERE simpleBudgetId IN (SELECT
      simpleBudgetId
    FROM simpleBudget bin
    WHERE bin.label1 = 'Expenses')
    FOR XML PATH ('')) sq (x)

  --Materialize "all other" incomes
  INSERT INTO @finalRules (simpleBudgetId, whereClause, used)
    SELECT
      38,
      '(AMOUNT > 0 AND NOT tags like ''%refund;%'')' + COALESCE('AND NOT (' + STUFF(sq.x, 1, 3, '') + ')', ''),
      0
    FROM (SELECT
      'OR ' + whereClause
    FROM @finalRules
    WHERE simpleBudgetId IN (SELECT
      simpleBudgetId
    FROM simpleBudget bin
    WHERE bin.label1 = 'Income')
    FOR XML PATH ('')) sq (x)

  IF @debug = 1 SELECT * FROM @finalRules

  --phase 2 run sql
  WHILE EXISTS (SELECT
      1
    FROM @finalRules
    WHERE used = 0)
  BEGIN
    SELECT TOP 1
      @thisBudget = simpleBudgetId,
      @thisWhere = whereClause
    FROM @finalRules
    WHERE used = 0
    ORDER BY simpleBudgetId

    SET @sql = REPLACE(@basesql, '<replace/>', @thisWhere)

    INSERT INTO @transactionHolder (simpleBudgetId, transactionId, splitTransactionId, transactionDate, amount)
    EXEC sys.sp_executesql @sql,
                           @sqlparams,
                           @thisBudget,
                           @earliest,
                           @latest,
                           @accountId

    UPDATE @finalRules
    SET used = 1
    WHERE simpleBudgetId = @thisBudget
  --DELETE @transactionHolder;
  END

  IF @debug = 1 SELECT * FROM @transactionHolder

  DELETE th
    FROM @transactionHolder th
    INNER JOIN (SELECT
      losers.transactionId,
      losers.splitTransactionId,
      losers.simpleBudgetId
    FROM (SELECT
      bh.simpleBudgetHierarchyId,
      th.transactionId,
      COALESCE(th.splitTransactionId, 0) splitTransactionId,
      th.simpleBudgetId
    FROM @transactionHolder th
    INNER JOIN simpleBudgetHierarchy bh
      ON bh.ifThisSimpleBudgetIdApplies = th.simpleBudgetId) keepers
    INNER JOIN (SELECT
      bh.simpleBudgetHierarchyId,
      th.transactionId,
      COALESCE(th.splitTransactionId, 0) splitTransactionId,
      th.simpleBudgetId
    FROM @transactionHolder th
    INNER JOIN simpleBudgetHierarchy bh
      ON bh.thenIgnoreThisSimpleBudgetId = th.simpleBudgetId) losers
      ON keepers.simpleBudgetHierarchyId = losers.simpleBudgetHierarchyId
      AND keepers.transactionId = losers.transactionId
      AND keepers.splitTransactionId = losers.splitTransactionId) sq
      ON th.simpleBudgetId = sq.simpleBudgetId
      AND th.transactionId = sq.transactionId
      AND COALESCE(th.splitTransactionId, 0) = sq.splitTransactionId

  IF @debug = 1 SELECT * FROM @transactionHolder

  INSERT INTO simpleBudgetCalculatedActual (simpleBudgetExpectedId, amount, calculated)

    SELECT
      be.simpleBudgetExpectedId,
      SUM(th.amount),
      SYSDATETIME()
    FROM @transactionHolder th
    INNER JOIN simpleBudgetExpected be
      ON th.simpleBudgetId = be.simpleBudgetId
      AND th.transactionDate BETWEEN be.transactionStartDate AND be.transactionEndDate
    GROUP BY simpleBudgetExpectedId

  DELETE bmt
    FROM simpleBudgetMaterializedTransactions bmt
    INNER JOIN BankTransactionCat t
      ON bmt.transactionId = t.transactionId
      AND COALESCE(bmt.splitTransactionId, 0) = COALESCE(t.splitTransactionId, 0)
  WHERE t.accountingDate BETWEEN @startDate AND @endDate

  DELETE bmt
    FROM simpleBudgetMaterializedTransactions bmt
    INNER JOIN @transactionHolder th
      ON bmt.transactionId = th.transactionId
      AND COALESCE(bmt.splitTransactionId, 0) = COALESCE(th.splitTransactionId, 0)



  INSERT INTO simpleBudgetMaterializedTransactions (simpleBudgetActualId, transactionId, splitTransactionId)
    SELECT
      bca.simpleBudgetActualId,
      th.transactionId,
      th.splitTransactionId
    FROM simpleBudgetCalculatedActual bca
    INNER JOIN simpleBudgetExpected be
      ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
    INNER JOIN @transactionHolder th
      ON be.simpleBudgetId = th.simpleBudgetId
      AND th.transactionDate
      BETWEEN be.transactionStartDate AND be.transactionEndDate

  --phase 3 set materialization signals

  EXEC captureMaterializationSignals


  --phase 4 reset rolling 12 month statistics
--
--  EXEC captureMaterializedSummaryStatistics @timeframeType = 'ROLLING',
--                                            @timeframeLabel = '',
--                                            @budgetFilter = ''

  EXEC updateAdjunctBalanceTable

  IF @sendMessage > 0
  BEGIN
    SELECT
      'Materialized';
  END;

  if object_id('tempdb..##tholder') is not null drop table ##tholder
  IF @debug = 1 SELECT * INTO ##tholder FROM @transactionHolder

END
