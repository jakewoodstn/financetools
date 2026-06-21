-- Exported: 2026-06-21T21:55:41.446600+00:00
-- Schema:   reporting
-- Object:   probeJSON
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:14.780000
-- Modified: 2014-12-10 15:57:14.780000

CREATE FUNCTION reporting.probeJSON (@json NVARCHAR(MAX), @token NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS
  BEGIN

DECLARE @retval NVARCHAR(MAX)='';
SET @token = '"' + @token + '":'
  DECLARE @tokenStart INT = charindex(@token,@json);
  IF @tokenStart=0 RETURN null;
  DECLARE @startDelimPos int = @tokenStart + LEN(@token);
  DECLARE @afterTokenToEnd NVARCHAR(MAX) = RIGHT(@json,LEN(@json)-@startDelimPos+1)
  DECLARE @startDelim NVARCHAR(1) = left(@afterTokenToEnd,1)
  DECLARE @endDelim NVARCHAR(1) = CASE when @startDelim='[' THEN ']' WHEN @startDelim='{' THEN '}' ELSE '"' end
  DECLARE @endDelimPos INT = charindex(@endDelim,@json,@startDelimPos+1)

  SELECT @retval= SUBSTRING(@json,@startDelimPos,@endDelimPos-@startDelimPos+1)

RETURN @retval;
END
