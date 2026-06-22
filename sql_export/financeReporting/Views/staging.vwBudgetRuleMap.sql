-- Exported: 2026-06-21T21:55:42.360805+00:00
-- Schema:   staging
-- Object:   vwBudgetRuleMap
-- Type:     VIEW
-- Created:  2021-02-06 22:36:44.377000
-- Modified: 2021-02-06 23:10:52.490000

CREATE VIEW staging.vwBudgetRuleMap
  AS
SELECT bm.subbudgetId, r.simpleBudgetRuleId budgetRuleId, 'payee' dimension, p.payeeId dimensionId FROM staging.budgetRule r
  INNER JOIN staging.vwBudgetMap bm ON r.simpleBudgetId = bm.simpleBudgetId
  INNER JOIN dimPayee p ON p.payeeName LIKE r.payeePattern
  WHERE r.usePayee = 1
  UNION

SELECT bm.subbudgetId,r.simpleBudgetRuleId, 'subcategory' ,dc.subcategoryId FROM staging.budgetRule r
  INNER JOIN staging.vwBudgetMap bm ON r.simpleBudgetId = bm.simpleBudgetId
  INNER JOIN vwDescriptionCategory dc ON dc.categoryName + COALESCE( ' - ' + NULLIF(dc.subcategoryName,''),'') LIKE r.categoryPattern
  WHERE r.useCat = 1
  UNION
  
SELECT bm.subbudgetId,r.simpleBudgetRuleId, 'event', de.eventId FROM staging.budgetRule r
  INNER JOIN staging.vwBudgetMap bm ON r.simpleBudgetId = bm.simpleBudgetId
  INNER JOIN vwDescriptionEvent de ON de.eventName LIKE r.tagpattern
  WHERE r.useTag=1
