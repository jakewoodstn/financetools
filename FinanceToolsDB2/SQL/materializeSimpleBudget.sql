DECLARE @e DATE = GETDATE()

DECLARE @s DATE = DATEADD(MONTH,-12,DATEADD(DAY,1,@e))


EXEC materializeSimpleBudgetActual @startDate = @s,
                                    @endDate = @e,
                                    @sendMessage = 1,
                                    @force = 1

  