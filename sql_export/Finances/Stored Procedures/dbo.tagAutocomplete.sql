-- Exported: 2026-06-21T21:55:41.421557+00:00
-- Schema:   dbo
-- Object:   tagAutocomplete
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-06-05 18:14:34.553000
-- Modified: 2020-06-23 03:48:06.680000

CREATE PROC dbo.tagAutocomplete
 AS
  BEGIN
  if object_id('tempdb..#prelimResult') is not null drop table #prelimResult

  SELECT DISTINCT e.taggedEventTag
    INTO #prelimResult
    from taggedEvent e
    INNER JOIN transactionTaggedEvent te ON e.taggedEventId = te.taggedEventId

  IF EXISTS(SELECT TOP 1 * FROM #prelimResult r)
    SELECT '[' + STUFF(x,1,1,'') +']' obj FROM (SELECT ',"'+taggedeventTag +'"' FROM  #prelimResult FOR XML PATH(''))sq(x)
  ELSE
    SELECT '[]' obj

  END
