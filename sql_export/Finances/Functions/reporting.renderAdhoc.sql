-- Exported: 2026-06-21T21:55:41.446954+00:00
-- Schema:   reporting
-- Object:   renderAdhoc
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:16.430000
-- Modified: 2014-12-10 15:57:16.430000

CREATE FUNCTION reporting.renderAdhoc (@baseSQL NVARCHAR(MAX), @snippetName VARCHAR(255), @replaceValue nvarchar(MAX),@nthInstance INT = 0)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @snp NVARCHAR(MAX);
  DECLARE @replace NVARCHAR(MAX) = '<replace id=''' + @snippetName + '''/>';
  DECLARE @retSQL NVARCHAR(MAX) = @baseSQL;

  IF @nthInstance=0
  BEGIN
    SET @retSQL = REPLACE(@baseSQL, @replace, @replaceValue);
  END
  ELSE
    BEGIN
      SET @retSQL = dbo.nthReplace(@baseSQL, @replace, @replaceValue,@nthInstance);
    END
  RETURN @retSQL;

END;
