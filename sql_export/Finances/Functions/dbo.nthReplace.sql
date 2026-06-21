-- Exported: 2026-06-21T21:55:41.281763+00:00
-- Schema:   dbo
-- Object:   nthReplace
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:16.420000
-- Modified: 2014-12-10 15:57:16.420000

CREATE FUNCTION dbo.nthReplace(@str NVARCHAR(MAX), @strToFind NVARCHAR(MAX),@strToReplace NVARCHAR(MAX), @n INT)
  RETURNS NVARCHAR(MAX) AS
  BEGIN

    DECLARE @retval NVARCHAR(MAX)=@str;
    DECLARE @start INT;

    SET @start=dbo.nthCHARINDEX(@strToFind,@str,1,@n);
    SET @retval=STUFF(@retval,@start,LEN(@strToFind),@strToReplace);

    RETURN @retval;

  END;
