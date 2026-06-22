-- Exported: 2026-06-21T21:55:42.294591+00:00
-- Schema:   dbo
-- Object:   loadWarehouse
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:38:06.160000
-- Modified: 2021-02-07 23:12:52.643000


  CREATE PROCEDURE dbo.loadWarehouse (@startdate DATE = NULL, @enddate DATE = NULL)
AS


  IF @startdate IS NULL
  BEGIN
    SELECT
      @startdate = DATEFROMPARTS(YEAR(GETDATE()) - 1, 1, 1)
     ,@enddate = GETDATE()

  END

  EXEC loadDimensions
  EXEC loadFacts @startDate, @Enddate
  EXEC runValidation @startdate, @enddate
