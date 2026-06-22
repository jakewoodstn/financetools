-- Exported: 2026-06-21T21:55:42.572464+00:00
-- Schema:   dbo
-- Table:    dimDate

CREATE TABLE [dbo].[dimDate] (
    [DateSK] int NOT NULL,
    [FullDate] datetime NOT NULL,
    [ActDate] varchar(6) NOT NULL,
    [ActQtr] varchar(6) NOT NULL,
    [Day] tinyint NOT NULL,
    [DaySuffix] varchar(4) NOT NULL,
    [DayOfWeek] varchar(9) NOT NULL,
    [DayOfWeekNumber] int NOT NULL,
    [DayOfWeekInMonth] tinyint NOT NULL,
    [DayOfYearNumber] int NOT NULL,
    [WeekOfYearNumber] tinyint NOT NULL,
    [WeekOfMonthNumber] tinyint NOT NULL,
    [CalendarMonthNumber] tinyint NOT NULL,
    [CalendarMonthName] varchar(9) NOT NULL,
    [CalendarQuarterNumber] tinyint NOT NULL,
    [CalendarQuarterName] varchar(6) NOT NULL,
    [CalendarYearNumber] int NOT NULL,
    [StandardDate] date NOT NULL,
    [FirstDayOfMonth] date NOT NULL,
    [LastDayOfMonth] date NOT NULL,
    [FirstDayOfQuarter] date NOT NULL,
    [LastDayOfQuarter] date NOT NULL,
    [FirstDayOfYear] date NOT NULL,
    [LastDayOfYear] date NOT NULL,
    [WeekDayFlag] bit NOT NULL,
    [OpenFlag] bit NOT NULL,
    [PaydayFlag] tinyint NOT NULL DEFAULT ((0)),
    [FirstDayOfCalendarMonthFlag] bit NOT NULL,
    [LastDayOfCalendarMonthFlag] bit NOT NULL,
    [HolidayFlag] bit NOT NULL,
    [HolidayText] varchar(50),
    [ActWeek] varchar(7),
    [semiAnnum] varchar(6),
    CONSTRAINT [PK_dimDate] PRIMARY KEY ([DateSK])
);

