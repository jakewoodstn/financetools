-- Exported: 2026-06-21T21:55:41.445431+00:00
-- Schema:   reporting
-- Object:   binaryFilter
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:15.017000
-- Modified: 2014-12-10 15:57:15.017000

CREATE FUNCTION reporting.binaryFilter(@domain int, @operator NVARCHAR(3), @value NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN

  DECLARE @ret NVARCHAR(MAX);  
  DECLARE @field NVARCHAR(MAX) = NULL;
  DECLARE @opText NVARCHAR(MAX) = NULL;
  DECLARE @snippet NVARCHAR(MAX) = NULL;
  
  SELECT @field=d.domainField FROM reporting.domain d WHERE domainId=@domain  
  SELECT @opText=o.operatorText FROM reporting.operator o WHERE o.operatorCardinality=2 and o.operatorCode=@operator;

  IF NOT(ISNUMERIC(@value)=1)
    BEGIN
    	
    IF NOT(@value='NULL' OR @value='NOT NULL') AND NOT @operator = 'IN' AND LEFT(@value,1)<>''''
      SET @value = '''' + @value + ''''
    END
  IF @field is NULL OR @opText IS NULL 
    SET @ret= '1=0'
  ELSE 
    BEGIN
      SELECT @snippet = snippetSQL FROM reporting.snippet s WHERE s.snippetName=@field;
      SET @ret = COALESCE(@snippet,@field) + ' ' + @opText + ' ' + @value;
    END

  RETURN @ret;

END
;
