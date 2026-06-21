-- Exported: 2026-06-21T21:55:41.421990+00:00
-- Schema:   dbo
-- Object:   tagCloudForTransaction
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2016-03-06 14:12:34.310000
-- Modified: 2020-06-23 03:16:24.250000

CREATE PROC dbo.tagCloudForTransaction (@tranId BIGINT)
 AS
  BEGIN
--  DECLARE @tranid BIGINT = 100043743
  if object_id('tempdb..#prelimResult') is not null drop table #prelimResult

  DECLARE @Transactions table (transactionId BIGINT PRIMARY KEY)

  INSERT into @Transactions SELECT transactionId from bankTransaction t WHERE t.description IN (SELECT description FROM bankTransaction t1 WHERE t1.transactionId = @tranId)
  
  SELECT TOP 10 fontindex = DENSE_RANK() OVER (ORDER BY obs DESC), sq.taggedEventTag INTO #prelimResult FROM(
   SELECT e.taggedEventId,e.taggedEventTag, COUNT(*) obs FROM taggedEvent e 
    INNER JOIN  transactionTaggedEvent te on e.taggedEventId = te.taggedEventId
    INNER JOIN @Transactions t ON te.transactionId = t.transactionId  
      GROUP by e.taggedEventId,e.taggedEventTag
    ) sq

  IF EXISTS(SELECT TOP 1 * FROM #prelimResult r)
    SELECT '[' + STUFF(x,1,1,'') +']' obj FROM (SELECT ',{"fontIndex":'+CAST(fontindex AS VARCHAR(10)) + ',"tag":"'+taggedeventTag +'"}' FROM  (SELECT * FROM #prelimResult) r FOR XML PATH(''))sq(x)
  ELSE
    SELECT '{}' obj

  END
