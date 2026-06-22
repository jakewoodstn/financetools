-- Exported: 2026-06-21T21:55:42.295795+00:00
-- Schema:   dbo
-- Object:   vwDescriptionEvent
-- Type:     VIEW
-- Created:  2020-06-14 19:10:10.147000
-- Modified: 2020-06-14 19:10:10.147000


CREATE   VIEW dbo.vwDescriptionEvent
  AS
  SELECT ed.eventDomainId
        ,e.eventId
        ,ed.eventDomainName
        ,e.eventName 
  FROM dimEventDomain ed
    INNER JOIN dimEvent e ON ed.eventDomainId = e.eventDomainId
