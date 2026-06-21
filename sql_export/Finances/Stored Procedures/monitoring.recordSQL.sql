-- Exported: 2026-06-21T21:55:41.445039+00:00
-- Schema:   monitoring
-- Object:   recordSQL
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2014-12-10 15:57:15.177000
-- Modified: 2014-12-10 15:57:15.177000

CREATE PROCEDURE monitoring.recordSQL (@procName VARCHAR(255), @SQL NVARCHAR(MAX))
AS
BEGIN
  INSERT INTO monitoring.dynamicSqlMonitor (procedureCalling, timeCalled, SQLTEXT)
  VALUES (@procName, SYSDATETIME(), @SQL);

END;
