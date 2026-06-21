-- Exported: 2026-06-21T21:55:41.304151+00:00
-- Schema:   dbo
-- Object:   recordParameter
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-09-04 11:41:10.653000
-- Modified: 2020-06-23 03:10:17.510000


CREATE PROCEDURE recordParameter(@parameterName varchar(255), @parameterValue varchar(max)) 
as

  BEGIN

  INSERT into parameter(parameterName, parameterValue) VALUES (@parameterName,@parameterValue);

  END;
