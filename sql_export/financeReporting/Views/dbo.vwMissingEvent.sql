-- Exported: 2026-06-21T21:55:42.310860+00:00
-- Schema:   dbo
-- Object:   vwMissingEvent
-- Type:     VIEW
-- Created:  2019-05-06 16:23:16.723000
-- Modified: 2021-02-06 21:11:11.073000


CREATE VIEW dbo.vwMissingEvent
AS
SELECT
  eventDomainId
 ,eventName
FROM (SELECT DISTINCT
    3 eventDomainId
   ,e.taggedEventTag eventName
  FROM finances.dbo.taggedEvent e
  INNER JOIN Finances.dbo.transactionTaggedEvent te
    ON e.taggedEventId = te.taggedEventId
  WHERE e.TaggedEventTag LIKE 'Check[0123456789]%'
  EXCEPT
  SELECT DISTINCT
    eventDomainId
   ,e.eventName
  FROM dimEvent e
  WHERE e.eventDomainId = 3) sq
UNION
SELECT
  eventDomainId
 ,eventName
FROM (SELECT DISTINCT
    2 eventDomainId
   ,e.taggedEventTag eventName
  FROM finances.dbo.taggedEvent e
  INNER JOIN Finances.dbo.transactionTaggedEvent te
    ON e.taggedEventId = te.taggedEventId
  WHERE e.TaggedEventTag NOT LIKE 'Check[0123456789]%'
  AND e.taggedEventTag <> 'Follow'
  AND e.taggedEventDescription NOT IN ('Core', 'Core+', 'Exception', 'Flex')
  EXCEPT
  SELECT DISTINCT
    eventDomainId
   ,e.eventName
  FROM dimEvent e
  WHERE e.eventDomainId = 2) sq
