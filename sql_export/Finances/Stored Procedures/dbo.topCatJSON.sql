-- Exported: 2026-06-21T21:55:41.423005+00:00
-- Schema:   dbo
-- Object:   topCatJSON
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-11-20 21:32:20.060000
-- Modified: 2020-06-23 03:07:46.240000


CREATE procedure [dbo].[topCatJSON](@account int, @numberReturn int, @durationDays int, @method varchar(20)='incidence')
as

begin

	create table #json (categoryName varchar(255),rn int);
	insert into #json exec topCat @account, @numberReturn, @durationDays, @method;
	 
	
select '['+STUFF(y,1,2,'')+']' from (
select ', '+x from #json j cross apply (
select  '"'+categoryName+ '"' from #json j2 where j2.rn=j.rn ) s(x) order by j.categoryName for xml path('')) s2(y);

	

end
