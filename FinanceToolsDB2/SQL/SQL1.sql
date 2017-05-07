USE Finances
  GO

ALTER PROCEDURE dbo.materializeSimpleBudgetActual(@startDate date, @endDate DATE, @sendMessage INT = 0, @force int = 0)
AS
  BEGIN

    SET nocount on 
    SET XACT_ABORT on 

    --phase 0: check if materialization is necessary
    IF NOT EXISTS (  
      SELECT 'TotalRecordCount', COUNT(*) FROM BankTransactionCat btc 
      EXCEPT select signalname, signalvalue FROM simpleBudgetMaterializationSignals bms
      ) 
    AND NOT EXISTS (  
      SELECT 'TotalTaggedEventCount', COUNT(*) FROM transactionTaggedEvent te  
      EXCEPT select signalname, signalvalue FROM simpleBudgetMaterializationSignals bms
      )
    AND NOT EXISTS (  
      SELECT 'CatCount: ' + btc.categoryName, COUNT(*) from BankTransactionCat btc GROUP by btc.categoryName
      EXCEPT select signalname, signalvalue FROM simpleBudgetMaterializationSignals bms
      )
    AND NOT EXISTS (  
      SELECT 'DateCount: ' + dd.ActDate, COUNT(*) from BankTransactionCat btc INNER JOIN DimDate dd ON btc.accountingDate = dd.FullDate group by dd.ActDate
      EXCEPT select signalname, signalvalue FROM simpleBudgetMaterializationSignals bms
      )
    AND @force = 0
    BEGIN
      IF @sendMessage>0 
        BEGIN 
          SELECT 'No Materialization Needed';
        END;
      RETURN; 
    END;
            
    DECLARE @earliest DATE
    DECLARE @latest DATE
    
    DECLARE @transactionHolder TABLE (simpleBudgetId int , transactionId bigint, transactionDate DATE, amount SMALLMONEY)
    DECLARE @basesql NVARCHAR(MAX) = 'SELECT DISTINCT @budgetParam, btc.transactionId, accountingDate,  amount from bankTransactionCat btc 
                                  WHERE accountingDate between @edate and @ldate and (<replace/>)'
    DECLARE @sqlparams NVARCHAR(255) = '@budgetParam int, @edate date, @ldate date'
    DECLARE @sql NVARCHAR(MAX) = ''
    DECLARE @thisWhere NVARCHAR(MAX)
    DECLARE @thisBudget INT
    
    DECLARE @payeeRules TABLE (simpleBudgetId int, ruleIndex INT, payeeClause NVARCHAR(MAX))
    DECLARE @catRules TABLE (simpleBudgetId int, ruleIndex INT, catClause NVARCHAR(MAX))
    DECLARE @tagRules TABLE (simpleBudgetId int, ruleIndex INT, tagClause NVARCHAR(MAX))
    DECLARE @lineRules TABLE (simpleBudgetId int, ruleIndex INT, indexClause NVARCHAR(MAX))
    DECLARE @finalRules table (simpleBudgetId int , whereClause NVARCHAR(MAX), used INT not null DEFAULT 0)
    
    SELECT @earliest = dd.FirstDayOfMonth from DimDate dd WHERE dd.FullDate = @startDate
    SELECT @latest = dd.LastDayOfMonth FROM DimDate dd WHERE dd.FullDate = @endDate
    
    DELETE sbca from simpleBudgetCalculatedActual sbca INNER JOIN simpleBudgetExpected be ON sbca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
        WHERE be.transactionStartDate>=@earliest and be.transactionEndDate<=@latest 
    
    --phase 1 build SQL
      INSERT into @payeerules
    SELECT sq.simpleBudgetId, sbr.ruleIndex, 'description like ''' + payeePattern + '''' FROM simpleBudgetRule sbr
      INNER JOIN (
    SELECT simplebudgetid, ruleIndex, MIN(br.simpleBudgetRuleId) firstRecord
    FROM simpleBudgetRule br
      WHERE br.usePayee = 1
      GROUP by  br.simpleBudgetId,
                br.ruleIndex
    ) sq ON sbr.simpleBudgetRuleId = sq.firstRecord
    
      INSERT into @catRules
      SELECT sq.simpleBudgetId, sbr.ruleIndex, 'categoryName like ''' + sbr.categoryPattern + '''' FROM simpleBudgetRule sbr
      INNER JOIN (
    SELECT simplebudgetid, ruleIndex, MIN(br.simpleBudgetRuleId) firstRecord
    FROM simpleBudgetRule br
      WHERE br.useCat = 1
      GROUP by  br.simpleBudgetId,
                br.ruleIndex
    ) sq ON sbr.simpleBudgetRuleId = sq.firstRecord
     
    
      INSERT into @tagRules
        SELECT DISTINCT sbr.simpleBudgetId, sbr.ruleIndex,STUFF( x,1,5,'') AS tagClause
          from simpleBudgetRule sbr
          CROSS apply
    (
      SELECT ' AND (btc.tags like ''' + tagpattern + ';%'' OR btc.tags like ''%;'+ tagpattern + ';%'')'
        from simpleBudgetRule br
        WHERE br.useTag = 1 AND br.simpleBudgetId= sbr.simpleBudgetId and br.ruleIndex = sbr.ruleIndex
        GROUP by br.simpleBudgetId, br.ruleIndex, br.tagpattern
    ORDER by br.tagpattern
        for XML path ('')) sq(x)
    WHERE x is NOT NULL
    
        INSERT into @lineRules
    SELECT pr.simpleBudgetId, pr.ruleIndex, STUFF(COALESCE(' AND ' + pr.payeeClause,'') + COALESCE(' AND ' + cr.catClause,'') + COALESCE(' AND ' + tr.tagClause ,''),1,5,'') indexClause  FROM @payeeRules pr 
        LEFT JOIN @catRules cr ON pr.simpleBudgetId = cr.simpleBudgetId and pr.ruleIndex = cr.ruleIndex
        LEFT JOIN @tagRules tr on pr.simpleBudgetId = tr.simpleBudgetId and pr.ruleIndex = tr.ruleIndex
    UNION
    SELECT cr.simpleBudgetId, cr.ruleIndex, STUFF(COALESCE(' AND ' + pr.payeeClause,'') + COALESCE(' AND ' + cr.catClause,'') + COALESCE(' AND ' + tr.tagClause ,''),1,5,'') indexClause  FROM @catRules cr 
      LEFT JOIN @payeeRules pr ON pr.simpleBudgetId = cr.simpleBudgetId and pr.ruleIndex = cr.ruleIndex
        LEFT JOIN @tagRules tr on cr.simpleBudgetId = tr.simpleBudgetId and cr.ruleIndex = tr.ruleIndex
    UNION  
    SELECT tr.simpleBudgetId, tr.ruleIndex, STUFF(COALESCE(' AND ' + pr.payeeClause,'') + COALESCE(' AND ' + cr.catClause,'') + COALESCE(' AND ' + tr.tagClause ,''),1,5,'') indexClause  FROM @tagRules tr 
        LEFT JOIN @payeeRules pr on pr.simpleBudgetId = tr.simpleBudgetId and pr.ruleIndex = tr.ruleIndex
        LEFT JOIN @catRules cr ON tr.simpleBudgetId = cr.simpleBudgetId and tr.ruleIndex = cr.ruleIndex
        
    
    INSERT into @finalRules       (simpleBudgetId, whereClause)
          SELECT DISTINCT simpleBudgetId , STUFF(x,1,4,'') finalWhere FROM @lineRules olr
            CROSS apply
          (SELECT ' OR (' + indexClause + ')' FROM @lineRules lr WHERE olr.simpleBudgetId = lr.simpleBudgetId ORDER BY ruleIndex FOR XML PATH (''))sq(x)
    
  --Materialize "all other" expenses
  INSERT into @finalRules (simpleBudgetId, whereClause, used)
    SELECT 31, 'AMOUNT < 0 '+COALESCE('AND NOT (' + STUFF(sq.x,1,3,'') + ')',''),0 FROM (SELECT 'OR ' + whereClause FROM @finalRules WHERE simpleBudgetId in (select simpleBudgetId FROM simpleBudget bin WHERE bin.label1 = 'Expenses') for XML PATH (''))sq (x)

  --Materialize "all other" incomes
  INSERT into @finalRules (simpleBudgetId, whereClause, used)
    SELECT 38, 'AMOUNT > 0 ' + COALESCE('AND NOT (' + STUFF(sq.x,1,3,'') + ')',''),0 FROM (SELECT 'OR ' + whereClause FROM @finalRules WHERE simpleBudgetId in (select simpleBudgetId FROM simpleBudget bin WHERE bin.label1 = 'Income') for XML PATH (''))sq (x)

  --phase 2 run sql
    WHILE EXISTS (select 1 from @finalRules where used = 0)
      BEGIN
        SELECT TOP 1 @thisBudget = simpleBudgetId, @thisWhere = whereClause FROM @finalRules where used = 0 ORDER by simpleBudgetId
        
        SET @sql = REPLACE(@basesql, '<replace/>', @thisWhere)
        
        INSERT into @transactionHolder (simpleBudgetId, transactionId, transactionDate, amount)
          EXEC sys.sp_executesql @sql,@sqlparams, @thisBudget, @earliest, @latest
        
        INSERT INTO simpleBudgetCalculatedActual (simpleBudgetExpectedId, amount, calculated)
        
        SELECT be.simpleBudgetExpectedId,SUM(th.amount), SYSDATETIME() FROM @transactionHolder th INNER JOIN simpleBudgetExpected be ON th.simpleBudgetId = be.simpleBudgetId
          AND th.transactionDate BETWEEN be.transactionStartDate and be.transactionEndDate 
          GROUP BY simpleBudgetExpectedId
        
        UPDATE @finalRules set used = 1 WHERE simpleBudgetId = @thisBudget
        DELETE @transactionHolder;
      END
  
  --phase 3 set materialization signals

    TRUNCATE table simpleBudgetMaterializationSignals
    
    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'TotalRecordCount', COUNT(*) FROM BankTransactionCat btc
  
    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'TotalTaggedEventCount', COUNT(*) FROM transactionTaggedEvent te

    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'CatCount: ' + btc.categoryName, COUNT(*) from BankTransactionCat btc GROUP by btc.categoryName

    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'DateCount: ' + dd.ActDate, COUNT(*) from BankTransactionCat btc INNER JOIN DimDate dd ON btc.accountingDate = dd.FullDate GROUP by actdate 

    IF @sendMessage > 0 
      BEGIN
        SELECT 'Materialized';
      END;
        
  END

GO