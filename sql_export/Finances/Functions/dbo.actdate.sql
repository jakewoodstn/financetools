-- Exported: 2026-06-21T21:55:41.279905+00:00
-- Schema:   dbo
-- Object:   actdate
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2012-09-03 11:19:19.423000
-- Modified: 2012-09-03 11:19:19.423000

create function actdate(@dt as datetime2) returns varchar(6) as 
begin

declare @yr varchar(4);
declare @mo varchar(2);

set @yr = CAST(year(@dt) as varchar(4)); 
set @mo = RIGHT('0' + CAST(MONTH(@dt) as varchar(2)),2);

return @yr+@mo;

end;
