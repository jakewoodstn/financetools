-- Exported: 2026-06-21T21:55:41.447270+00:00
-- Schema:   reporting
-- Object:   renderSnippet
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:15.007000
-- Modified: 2014-12-10 15:57:15.007000

CREATE function reporting.renderSnippet(@baseSQL NVARCHAR(MAX), @snippetName VARCHAR(255)) RETURNS NVARCHAR(MAX)
  AS
BEGIN
  DECLARE @snp NVARCHAR(MAX);
  DECLARE @replace NVARCHAR(MAX) = '<replace id='''+@snippetName+'''/>';
  DECLARE @retSQL NVARCHAR(MAX)=@baseSQL;

  SET @snp=reporting.getSnippet(@snippetName);
  IF @snp is NOT NULL
    SET @retSQL=REPLACE(@baseSQL,@replace,@snp);

  RETURN @retSQL;

END;
