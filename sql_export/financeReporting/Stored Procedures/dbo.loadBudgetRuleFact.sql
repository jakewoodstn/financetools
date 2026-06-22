-- Exported: 2026-06-21T21:55:42.268402+00:00
-- Schema:   dbo
-- Object:   loadBudgetRuleFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2021-02-07 00:47:13.900000
-- Modified: 2021-02-07 20:37:21.210000

CREATE PROCEDURE dbo.loadBudgetRuleFact
  AS
  BEGIN
    DROP TABLE IF EXISTS #t
    CREATE TABLE #t 
      (subBudgetId INT, ruleIndex INT, payeeId INT, subcategoryId INT, eventId INT)
    INSERT INTO #t
    SELECT sq2.subbudgetId
          ,sq2.rn
          ,COALESCE(pce.payeeId,-1) payeeId
          ,COALESCE(pce.subcategoryId,-1) subcategoryId
          ,COALESCE(pce.eventId,-1) eventId FROM (
    SELECT
      sq.subbudgetId
     ,sq.budgetRuleId
     ,rn = ROW_NUMBER() OVER (PARTITION BY sq.subbudgetid ORDER BY sq.budgetRuleId)
    FROM
      (SELECT DISTINCT
        brm.subbudgetId
       ,brm.budgetRuleId
      FROM staging.vwBudgetRuleMap brm) sq
        )sq2
      INNER JOIN 
    (
    SELECT COALESCE(pc.subbudgetId,e.subbudgetId) subbudgetid
          ,COALESCE(pc.budgetRuleId,e.budgetRuleId) budgetRuleId
          ,pc.payeeId
          ,pc.subcategoryId, e.dimensionId eventId FROM 
    (
      SELECT COALESCE(p.subbudgetId,c.subbudgetId) subBudgetId
            ,COALESCE(p.budgetRuleId,c.budgetRuleId) budgetRuleId
            
            ,p.dimensionId payeeId,c.dimensionId subcategoryId FROM 
      (SELECT brm.subbudgetId
             ,brm.budgetRuleId
             ,brm.dimension
             ,brm.dimensionId FROM staging.vwBudgetRuleMap brm WHERE brm.dimension = 'payee') p
      FULL OUTER JOIN 
    
          (SELECT brm.subbudgetId
                 ,brm.budgetRuleId
                 ,brm.dimension
                 ,brm.dimensionId FROM staging.vwBudgetRuleMap brm WHERE brm.dimension = 'subcategory') c ON c.subbudgetId=p.subbudgetId AND c.budgetRuleId = p.budgetRuleId ) pc
          FULL OUTER JOIN (    SELECT brm.subbudgetId
                                     ,brm.budgetRuleId
                                     ,brm.dimension
                                     ,brm.dimensionId FROM staging.vwBudgetRuleMap brm WHERE brm.dimension = 'event') e ON e.subbudgetId=pc.subbudgetId AND e.budgetRuleId=pc.budgetRuleId)pce ON pce.subbudgetId = sq2.subbudgetId AND pce.budgetRuleId=sq2.budgetRuleId
    ORDER BY 1,3
      
      
  DELETE FROM factBudgetRule WHERE factBudgetRuleId IN (
      SELECT br.factBudgetRuleId FROM dbo.factBudgetRule br INNER JOIN (    
          SELECT 
              br.subBudgetId
              ,br.ruleIndex
              ,COALESCE(br.payeeId,-1) payeeId
              ,COALESCE(br.subcategoryId,-1) subcategoryId
              ,COALESCE(br.eventId,-1) eventId FROM factBudgetRule br
         EXCEPT SELECT subBudgetId
                      ,ruleIndex
                      ,payeeId
                      ,subcategoryId
                      ,eventId FROM #t)sq ON br.subBudgetId=sq.subBudgetId AND br.ruleIndex = sq.ruleIndex AND COALESCE(br.payeeId,-1) = sq.payeeId AND COALESCE(br.subcategoryId,-1)=sq.subcategoryId AND COALESCE(br.eventId,-1) = sq.eventId
      )
   

      
              
      INSERT INTO dbo.factBudgetRule (subBudgetId, ruleIndex, payeeId, subcategoryId, eventId)
      SELECT sq.subBudgetId
            ,sq.ruleIndex
            ,NULLIF(sq.payeeId,-1)
            ,NULLIF(sq.subcategoryId,-1)
            ,NULLIF(sq.eventId,-1)
        FROM (
         SELECT subBudgetId
                      ,ruleIndex
                      ,payeeId
                      ,subcategoryId
                      ,eventId
                       FROM #t
         EXCEPT 
         SELECT 
              br.subBudgetId
              ,br.ruleIndex
              ,COALESCE(br.payeeId,-1) payeeId
              ,COALESCE(br.subcategoryId,-1) subcategoryId
              ,COALESCE(br.eventId,-1) eventId FROM factBudgetRule br
         )sq
   
      UPDATE factBudgetRule SET lastUpdatedAt = SYSDATETIME() WHERE 1=1;
        
      END
