ALTER VIEW vwMasterBudget
AS
SELECT
  m.budgetMasterId,
  t.budgetTypeName masterBudgetTypeName,
  m.budgetReferenceId masterBudgetReferenceId,
  LTRIM(RTRIM(COALESCE(tag.taggedEventTag, CASE WHEN m.budgetTypeId = 1 THEN cb.categoryName ELSE cb.categoryName + ' - ' + cb.subCategoryName END, 'UNKNOWN'))) masterBudgetName,
  COALESCE(d.startDate, '1/1/1900') masterStartDate,
  COALESCE(d.endDate, '12/31/2199') masterEndDate,
  COALESCE(d.amount, 0) masterBudgetedAmount,
  COALESCE(d.budgetPeriodTypeId,0) masterBudgetPeriod

FROM budgetMaster m
INNER JOIN budgetType t
  ON m.budgetTypeId = t.budgetTypeId
LEFT JOIN taggedEvent tag
  ON m.budgetReferenceId = tag.taggedEventId
  AND t.budgetTypeId = 3
LEFT JOIN vwCategoryBreakdown cb
  ON m.budgetReferenceId = cb.categoryId
  AND t.budgetTypeId IN (1, 2)
LEFT JOIN budgetDetail d
  ON m.budgetMasterId = d.budgetMasterId
  AND d.budgetSubId IS NULL;

GO

ALTER VIEW vwMasterBudgetPeriod
  AS
  SELECT DISTINCT
    mb.budgetMasterId,
    mb.masterBudgetTypeName,
    mb.masterBudgetReferenceId,
    mb.masterBudgetName,
    mb.masterStartDate,
    mb.masterEndDate,
    mb.masterBudgetedAmount,
    mb.masterBudgetPeriod,
    CASE mb.masterBudgetPeriod WHEN 0 THEN '---' WHEN 1 THEN CAST(year(dd.StandardDate) AS VARCHAR(4)) when 2 then dd.ActQtr WHEN 3 THEN dd.ActDate else null END masterPeriodLabel,
    CASE mb.masterBudgetPeriod WHEN 0 THEN mb.masterStartDate
                               WHEN 1 THEN CASE when dd.FirstDayOfYear >= mb.masterStartDate THEN dd.FirstDayOfYear else mb.masterStartDate END 
                               when 2 then CASE WHEN dd.FirstDayOfQuarter >= mb.masterStartDate then dd.FirstDayOfQuarter ELSE mb.masterStartDate end
                               WHEN 3 THEN CASE WHEN dd.FirstDayOfMonth >=mb.masterStartDate then dd.FirstDayOfMonth ELSE mb.masterStartDate end
                               else null 
    END masterPeriodFirstDay,
    CASE mb.masterBudgetPeriod WHEN 0 THEN mb.masterEndDate 
                               WHEN 1 THEN CASE WHEN dd.lastDayOfYear <=mb.masterEndDate then dd.LastDayOfYear else mb.masterEndDate end
                               when 2 then CASE WHEN dd.lastDayOfQuarter <=mb.masterEndDate THEN dd.LastDayOfQuarter ELSE mb.masterEndDate END
                               WHEN 3 THEN CASE when dd.lastDayOfMonth <=mb.masterEndDate then dd.LastDayOfMonth else mb.masterEndDate end
    else null END masterPeriodlastDay
  FROM vwMasterBudget mb
  INNER JOIN budgetPeriodType pt
    ON mb.masterBudgetPeriod = pt.budgetPeriodTypeId
  INNER JOIN DimDate dd ON StandardDate BETWEEN mb.masterStartDate and mb.masterEndDate

GO

ALTER VIEW vwSubBudget
AS
SELECT
  S.budgetMasterId,
  S.budgetSubId,
  t.budgetTypeName SubBudgetTypeName,
  S.budgetReferenceId subBudgetReferenceId,
  LTRIM(RTRIM(COALESCE(tag.taggedEventTag, CASE WHEN S.budgetTypeId = 1 THEN cb.categoryName ELSE cb.categoryName + ' - ' + cb.subCategoryName END, 'UNKNOWN'))) SubBudgetName,
  COALESCE(d.startDate, '1/1/1900') SubStartDate,
  COALESCE(d.endDate, '12/31/2199') SubEndDate,
  COALESCE(d.amount, 0) SubBudgetedAmount,
  COALESCE(d.budgetPeriodTypeId,-1) SubBudgetPeriod

FROM budgetSub S
INNER JOIN budgetType t
  ON S.budgetTypeId = t.budgetTypeId
LEFT JOIN taggedEvent tag
  ON S.budgetReferenceId = tag.taggedEventId
  AND t.budgetTypeId = 3
LEFT JOIN vwCategoryBreakdown cb
  ON S.budgetReferenceId = cb.categoryId
  AND t.budgetTypeId IN (1, 2)
LEFT JOIN budgetDetail d
  ON S.budgetSubId = d.budgetSubId;

GO

ALTER VIEW vwSubBudgetPeriod
AS
SELECT DISTINCT
  sb.budgetSubId,
  sb.SubBudgetTypeName,
  sb.subBudgetReferenceId,
  sb.SubBudgetName,
  sb.SubStartDate,
  sb.SubEndDate,
  sb.SubBudgetedAmount,
  sb.SubBudgetPeriod,
  CASE sb.SubBudgetPeriod WHEN 0 THEN '---' WHEN 1 THEN CAST(YEAR(dd.StandardDate) AS VARCHAR(4)) WHEN
  2 THEN dd.ActQtr WHEN 3 THEN dd.ActDate ELSE NULL END subPeriodLabel,
  CASE sb.subBudgetPeriod WHEN 0 THEN sb.subStartDate
                               WHEN 1 THEN CASE when dd.FirstDayOfYear >= sb.subStartDate THEN dd.FirstDayOfYear else sb.subStartDate END 
                               when 2 then CASE WHEN dd.FirstDayOfQuarter >= sb.subStartDate then dd.FirstDayOfQuarter ELSE sb.subStartDate end
                               WHEN 3 THEN CASE WHEN dd.FirstDayOfMonth >=sb.subStartDate then dd.FirstDayOfMonth ELSE sb.subStartDate end
                               else null 
    END subPeriodFirstDay,
    CASE sb.subBudgetPeriod WHEN 0 THEN sb.subEndDate 
                               WHEN 1 THEN CASE WHEN dd.lastDayOfYear <=sb.subEndDate then dd.LastDayOfYear else sb.subEndDate end
                               when 2 then CASE WHEN dd.lastDayOfQuarter <=sb.subEndDate THEN dd.LastDayOfQuarter ELSE sb.subEndDate END
                               WHEN 3 THEN CASE when dd.lastDayOfMonth <=sb.subEndDate then dd.LastDayOfMonth else sb.subEndDate end
    else null END subPeriodlastDay


FROM vwSubBudget sb
INNER JOIN budgetPeriodType pt
  ON sb.SubBudgetPeriod = pt.budgetPeriodTypeId
INNER JOIN DimDate dd
  ON StandardDate BETWEEN sb.SubStartDate AND sb.SubEndDate;

GO

ALTER VIEW vwBudgetBase
AS
SELECT
  mb.*,
  budgetSubId,
  SubBudgetTypeName,
  sb.subBudgetReferenceId,
  SubBudgetName,
  SubStartDate,
  SubEndDate,
  SubBudgetedAmount,
  CASE when sb.SubBudgetPeriod = -1 THEN mb.masterBudgetPeriod else sb.SubBudgetPeriod END subBudgetPeriod
FROM vwMasterBudget mb
INNER JOIN vwSubBudget sb
  ON mb.budgetMasterId = sb.budgetMasterId
WHERE mb.masterStartDate <= sb.SubEndDate
AND sb.SubStartDate <= mb.masterEndDate;

GO

ALTER VIEW vwBudgetCatch
AS
SELECT
  bm.budgetMasterId,
  bm.masterStartDate,
  bm.masterEndDate,
  bm.masterBudgetedAmount - COALESCE(SUM(SubBudgetedAmount), 0) catchallAmount
FROM vwMasterBudget bm
LEFT JOIN vwBudgetBase bb
  ON bm.budgetMasterId = bb.budgetMasterId
  AND bm.masterStartDate = bb.masterStartDate
  AND bm.masterEndDate = bb.masterEndDate
GROUP BY bm.budgetMasterId,
         bm.masterBudgetedAmount,
         bm.masterStartDate,
         bm.masterEndDate
HAVING bm.masterBudgetedAmount - COALESCE(SUM(SubBudgetedAmount), 0) > 0;

GO

ALTER VIEW vwBudget
AS
SELECT
  *
FROM vwBudgetBase
UNION
SELECT
  mb.*,
  NULL budgetSubId,
  masterBudgetTypeName subBudgetTypeName,
  0 subBudgetReferenceId,
  'Catchall' SubBudgetName,
  mb.masterStartDate,
  mb.masterEndDate,
  catchallamount,
  mb.masterBudgetPeriod
FROM vwMasterBudget mb
INNER JOIN vwBudgetCatch bc
  ON mb.budgetMasterId = bc.budgetMasterId AND mb.masterStartDate = bc.masterStartDate and mb.masterEndDate = bc.masterEndDate;

GO

ALTER VIEW vwBudgetPeriod
AS
SELECT
  b.*,
  mbp.masterPeriodLabel,
  mbp.masterPeriodFirstDay,
  mbp.masterPeriodlastDay,
  COALESCE(sbp.subPeriodLabel, mbp.masterPeriodLabel) subPeriodLabel,
  COALESCE(sbp.subPeriodFirstDay, mbp.masterPeriodFirstDay) subPeriodFirstDay,
  COALESCE(sbp.subPeriodlastDay, mbp.masterPeriodlastDay) subPeriodlastDay
FROM vwBudget b
INNER JOIN vwMasterBudgetPeriod mbp
  ON b.budgetMasterId = mbp.budgetMasterId
  AND b.masterStartDate = mbp.masterStartDate
  AND b.masterEndDate = mbp.masterEndDate
LEFT JOIN vwSubBudgetPeriod sbp
  ON b.budgetSubId = sbp.budgetSubId
  AND b.SubStartDate = sbp.SubStartDate
  AND b.SubEndDate = sbp.SubEndDate 

  GO



ALTER VIEW vwMasterBudgetTransactionBridge
AS
  SELECT m.budgetMasterId,NULL budgetSubId, cb1.categoryId , NULL taggedEventId 
  FROM budgetMaster m 
  inner join vwCategoryBreakdown cb ON m.budgetReferenceId = cb.categoryId
  INNER JOIN vwCategoryBreakdown cb1 ON cb.categoryName = cb1.categoryName
  WHERE m.budgetTypeId = 1
UNION
  SELECT m.budgetMasterId,NULL budgetSubId, m.budgetReferenceId, null 
  FROM budgetMaster m 
  WHERE m.budgetTypeId =2
UNION
  SELECT m.budgetMasterId,NULL budgetSubId, NULL, m.budgetReferenceId 
  FROM budgetMaster m 
  WHERE m.budgetTypeId =3

GO

ALTER VIEW vwSubBudgetTransactionBridge AS
SELECT DISTINCT sq.budgetMasterId,
        sq.budgetSubId,
        COALESCE(sq.categoryId,mbtb.categoryId) categoryId,

        coalesce(sq.taggedEventId ,mbtb.taggedEventId) taggedEventId  
 FROM 
  vwMasterBudgetTransactionBridge mbtb INNER JOIN 
(SELECT s.budgetMasterId,s.budgetSubId, cb1.categoryId , NULL taggedEventId 
  FROM budgetSub s
  inner join vwCategoryBreakdown cb ON s.budgetReferenceId = cb.categoryId
  INNER JOIN vwCategoryBreakdown cb1 ON cb.categoryName = cb1.categoryName
  WHERE s.budgetTypeId = 1
UNION
SELECT s.budgetMasterId,s.budgetSubId, s.budgetReferenceId, null 
  FROM budgetSub S
  WHERE s.budgetTypeId =2
UNION
SELECT s.budgetMasterId,s.budgetSubId, NULL, s.budgetReferenceId 
  FROM budgetSub S
  WHERE s.budgetTypeId =3) sq ON mbtb.budgetMasterId = sq.budgetMasterId;

GO

ALTER VIEW vwBudgetTransactionList
  AS

SELECT DISTINCT
  sbtb.budgetMasterId,
  sbtb.budgetSubId,
  btc.transactionId
FROM vwSubBudgetTransactionBridge sbtb
INNER JOIN vwBankTransactionCategories btc
LEFT JOIN transactionTaggedEvent te
  ON btc.transactionId = te.transactionId
  ON btc.categoryId = COALESCE(sbtb.categoryId, btc.categoryId)
  AND COALESCE(te.taggedEventId, 0) = COALESCE(sbtb.taggedEventId, te.taggedEventId, 0)
INNER JOIN vwBudgetPeriod sb
  ON sb.budgetSubId = sbtb.budgetSubId
  AND btc.accountingDate BETWEEN sb.subPeriodFirstDay AND sb.subPeriodlastDay
  AND btc.accountingDate BETWEEN sb.masterPeriodFirstDay AND sb.masterPeriodlastDay
UNION
SELECT
  budgetMasterId,
  null,
  transactionId
FROM (SELECT DISTINCT
  mbtb.budgetMasterId,
  btc.transactionId
FROM vwMasterBudgetTransactionBridge mbtb
INNER JOIN vwBankTransactionCategories btc
LEFT JOIN transactionTaggedEvent te
  ON btc.transactionId = te.transactionId
  ON btc.categoryId = COALESCE(mbtb.categoryId, btc.categoryId)
  AND COALESCE(te.taggedEventId, 0) = COALESCE(mbtb.taggedEventId, te.taggedEventId, 0)
INNER JOIN vwMasterBudgetPeriod mb
  ON mb.budgetMasterId = mbtb.budgetMasterId
  AND btc.accountingDate BETWEEN mb.masterPeriodFirstDay AND mb.masterPeriodlastDay
EXCEPT
SELECT DISTINCT
  sbtb.budgetMasterId,
  btc.transactionId
FROM vwSubBudgetTransactionBridge sbtb
INNER JOIN vwBankTransactionCategories btc
LEFT JOIN transactionTaggedEvent te
  ON btc.transactionId = te.transactionId
  ON btc.categoryId = COALESCE(sbtb.categoryId, btc.categoryId)
  AND COALESCE(te.taggedEventId, 0) = COALESCE(sbtb.taggedEventId, te.taggedEventId, 0)
INNER JOIN vwBudgetPeriod sb
  ON sb.budgetSubId = sbtb.budgetSubId
  AND btc.accountingDate BETWEEN sb.subPeriodFirstDay AND sb.subPeriodlastDay
  AND btc.accountingDate BETWEEN sb.masterPeriodFirstDay AND sb.masterPeriodlastDay) sq

GO

ALTER VIEW vwBudgetTransactionDetail AS
SELECT
  v.budgetMasterId,
  v.budgetSubId,
  btc.*
FROM vwBudgetTransactionList v
INNER JOIN vwBankTransactionCategories btc
  ON btc.transactionId = v.transactionId;

GO
