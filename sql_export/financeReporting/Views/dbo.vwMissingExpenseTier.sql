-- Exported: 2026-06-21T21:55:42.311238+00:00
-- Schema:   dbo
-- Object:   vwMissingExpenseTier
-- Type:     VIEW
-- Created:  2022-09-12 15:04:31.780000
-- Modified: 2022-09-12 15:04:31.780000


CREATE VIEW vwMissingExpenseTier
AS
SELECT
  et.expenseTierID eventId
 ,1 eventDomainId
 ,et.expenseTierName eventName
FROM dimExpenseTier et
EXCEPT
SELECT
  eventId
 ,eventDomainId
 ,eventName
FROM dimEvent e
WHERE e.eventDomainId = 1
