-- Exported: 2026-06-21T21:55:42.269754+00:00
-- Schema:   dbo
-- Object:   loadEvent
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.810000
-- Modified: 2022-09-12 20:15:21.373000


CREATE PROCEDURE dbo.loadEvent
AS
BEGIN

IF EXISTS (SELECT TOP 1
        1
      FROM vwMissingExpenseTier)
  BEGIN
    SET IDENTITY_INSERT dimEvent ON
    INSERT INTO dimEvent (eventId, eventDomainId, eventName)
      SELECT
        eventId
       ,eventDomainId
       ,eventName
      FROM vwMissingExpenseTier met
    SET IDENTITY_INSERT dimEvent OFF
  END

  INSERT INTO dimEvent (eventDomainId, eventName)
    SELECT
      eventDomainId
     ,eventName
    FROM vwMissingEvent

  
END
