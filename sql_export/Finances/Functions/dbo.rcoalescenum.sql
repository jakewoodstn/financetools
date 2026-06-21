-- Exported: 2026-06-21T21:55:41.282142+00:00
-- Schema:   dbo
-- Object:   rcoalescenum
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2011-12-19 00:41:54.160000
-- Modified: 2011-12-19 00:41:54.160000

create function rcoalescenum(@val float, @valifnull float)
returns float
as 
begin
	declare @retval float;
	if @val is not null 
	begin
		set @retval = @val;
	end; 
	else
	begin
		set @retval = @valifnull;
	end;
	return  @retval;
end;
