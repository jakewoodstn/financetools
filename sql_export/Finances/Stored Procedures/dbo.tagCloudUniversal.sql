-- Exported: 2026-06-21T21:55:41.422301+00:00
-- Schema:   dbo
-- Object:   tagCloudUniversal
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2016-03-06 17:09:57.677000
-- Modified: 2020-06-23 03:11:36.490000

CREATE PROC dbo.tagCloudUniversal
 AS
  BEGIN
  if object_id('tempdb..#prelimResult') is not null drop table #prelimResult

  SELECT TOP 40 fontindex = DENSE_RANK() OVER (ORDER BY obs DESC), sq.taggedEventTag INTO #prelimResult FROM(
   SELECT e.taggedEventId,e.taggedEventTag, COUNT(*) obs FROM taggedEvent e 
    INNER JOIN  transactionTaggedEvent te on e.taggedEventId = te.taggedEventId
      GROUP by e.taggedEventId,e.taggedEventTag
    ) sq

  IF EXISTS(SELECT TOP 1 * FROM #prelimResult r)
    SELECT '[' + STUFF(x,1,1,'') +']' obj FROM (SELECT ',{"fontIndex":'+CAST(fontindex AS VARCHAR(10)) + ',"tag":"'+taggedeventTag +'"}' FROM  (SELECT * FROM #prelimResult) r FOR XML PATH(''))sq(x)
  ELSE
    SELECT '{}' obj

  END
