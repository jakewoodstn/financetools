﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;

public partial class account
{
    public int accountId { get; set; }
    public string accountName { get; set; }
    public Nullable<System.DateTime> createdAt { get; set; }
    public Nullable<System.DateTime> closedOn { get; set; }
    public Nullable<byte> importTransactions { get; set; }
    public byte[] ts { get; set; }
}

public partial class BankTransactionCat
{
    public long transactionId { get; set; }
    public Nullable<System.DateTime> transactionDate { get; set; }
    public Nullable<System.DateTime> loadedDate { get; set; }
    public string description { get; set; }
    public string category { get; set; }
    public Nullable<decimal> amount { get; set; }
    public Nullable<int> accountId { get; set; }
    public string accountName { get; set; }
    public Nullable<int> categoryId { get; set; }
    public string origDescription { get; set; }
    public int categoryStatus { get; set; }
    public string bankOrigDescription { get; set; }
    public string categoryName { get; set; }
    public Nullable<System.DateTime> accountingDate { get; set; }
    public string tags { get; set; }
    public Nullable<int> tagCount { get; set; }
    public Nullable<long> splitTransactionId { get; set; }
}

public partial class BankTransactionCatNoSplit
{
    public long transactionId { get; set; }
    public Nullable<System.DateTime> transactionDate { get; set; }
    public Nullable<System.DateTime> loadedDate { get; set; }
    public string description { get; set; }
    public string category { get; set; }
    public Nullable<decimal> amount { get; set; }
    public Nullable<int> accountId { get; set; }
    public string accountName { get; set; }
    public Nullable<int> categoryId { get; set; }
    public string origDescription { get; set; }
    public int categoryStatus { get; set; }
    public string bankOrigDescription { get; set; }
    public string categoryName { get; set; }
    public Nullable<System.DateTime> accountingDate { get; set; }
    public string tags { get; set; }
    public Nullable<int> tagCount { get; set; }
}

public partial class DailyBalance
{
    public int accountId { get; set; }
    public System.DateTime MeasurementDate { get; set; }
    public Nullable<decimal> Amount { get; set; }
}

public partial class DimDate
{
    public int DateSK { get; set; }
    public System.DateTime FullDate { get; set; }
    public string ActDate { get; set; }
    public string ActQtr { get; set; }
    public byte Day { get; set; }
    public string DaySuffix { get; set; }
    public string DayOfWeek { get; set; }
    public int DayOfWeekNumber { get; set; }
    public byte DayOfWeekInMonth { get; set; }
    public int DayOfYearNumber { get; set; }
    public byte WeekOfYearNumber { get; set; }
    public byte WeekOfMonthNumber { get; set; }
    public byte CalendarMonthNumber { get; set; }
    public string CalendarMonthName { get; set; }
    public byte CalendarQuarterNumber { get; set; }
    public string CalendarQuarterName { get; set; }
    public int CalendarYearNumber { get; set; }
    public string StandardDate { get; set; }
    public System.DateTime FirstDayOfMonth { get; set; }
    public System.DateTime LastDayOfMonth { get; set; }
    public System.DateTime FirstDayOfQuarter { get; set; }
    public System.DateTime LastDayOfQuarter { get; set; }
    public System.DateTime FirstDayOfYear { get; set; }
    public System.DateTime LastDayOfYear { get; set; }
    public bool WeekDayFlag { get; set; }
    public bool OpenFlag { get; set; }
    public byte PaydayFlag { get; set; }
    public bool FirstDayOfCalendarMonthFlag { get; set; }
    public bool LastDayOfCalendarMonthFlag { get; set; }
    public bool HolidayFlag { get; set; }
    public string HolidayText { get; set; }
    public string ActWeek { get; set; }
    public string semiAnnum { get; set; }
}

public partial class simpleBudget
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
    public simpleBudget()
    {
        this.simpleBudgetRules = new HashSet<simpleBudgetRule>();
        this.simpleBudgetExpecteds = new HashSet<simpleBudgetExpected>();
    }

    public int simpleBudgetId { get; set; }
    public string label1 { get; set; }
    public string label2 { get; set; }
    public string label3 { get; set; }
    public System.DateTime created_at { get; set; }
    public string created_by { get; set; }
    public Nullable<System.DateTime> updated_at { get; set; }
    public string updated_by { get; set; }
    public Nullable<int> sortOrder { get; set; }

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
    public virtual ICollection<simpleBudgetRule> simpleBudgetRules { get; set; }
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
    public virtual ICollection<simpleBudgetExpected> simpleBudgetExpecteds { get; set; }
}

public partial class simpleBudgetCalculatedActual
{
    public int simpleBudgetActualId { get; set; }
    public Nullable<int> simpleBudgetExpectedId { get; set; }
    public decimal amount { get; set; }
    public Nullable<System.DateTime> calculated { get; set; }

    public virtual simpleBudgetExpected simpleBudgetExpected { get; set; }
}

public partial class simpleBudgetExpected
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
    public simpleBudgetExpected()
    {
        this.simpleBudgetCalculatedActuals = new HashSet<simpleBudgetCalculatedActual>();
    }

    public int simpleBudgetExpectedId { get; set; }
    public Nullable<int> simpleBudgetId { get; set; }
    public Nullable<decimal> amount { get; set; }
    public Nullable<System.DateTime> transactionStartDate { get; set; }
    public Nullable<System.DateTime> transactionEndDate { get; set; }
    public Nullable<System.DateTime> effectiveDate { get; set; }
    public Nullable<System.DateTime> retiredDate { get; set; }

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
    public virtual ICollection<simpleBudgetCalculatedActual> simpleBudgetCalculatedActuals { get; set; }
    public virtual simpleBudget simpleBudget { get; set; }
}

public partial class simpleBudgetRule
{
    public int simpleBudgetRuleId { get; set; }
    public int simpleBudgetId { get; set; }
    public int ruleIndex { get; set; }
    public int usePayee { get; set; }
    public int useCat { get; set; }
    public int useTag { get; set; }
    public string payeePattern { get; set; }
    public string categoryPattern { get; set; }
    public string tagpattern { get; set; }
    public System.DateTime effectiveDate { get; set; }
    public System.DateTime retiredDate { get; set; }
    public System.DateTime created_at { get; set; }
    public string created_by { get; set; }
    public Nullable<System.DateTime> updated_at { get; set; }
    public string updated_by { get; set; }

    public virtual simpleBudget simpleBudget { get; set; }
}

public partial class taggedEvent
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
    public taggedEvent()
    {
        this.transactionTaggedEvents = new HashSet<transactionTaggedEvent>();
    }

    public int taggedEventId { get; set; }
    public string taggedEventTag { get; set; }
    public string taggedEventDescription { get; set; }
    public Nullable<System.DateTime> effectiveDate { get; set; }
    public Nullable<System.DateTime> retiredDate { get; set; }

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
    public virtual ICollection<transactionTaggedEvent> transactionTaggedEvents { get; set; }
}

public partial class transactionTaggedEvent
{
    public int transactionTaggedEventId { get; set; }
    public Nullable<long> transactionId { get; set; }
    public Nullable<int> taggedEventId { get; set; }
    public Nullable<System.DateTime> taggedAt { get; set; }
    public Nullable<int> splitTransactionId { get; set; }

    public virtual taggedEvent taggedEvent { get; set; }
}

public partial class vwMaterializedActualSpendingTransactionDetail
{
    public long transactionId { get; set; }
    public Nullable<long> splitTransactionId { get; set; }
    public string accountName { get; set; }
    public Nullable<System.DateTime> accountingDate { get; set; }
    public string description { get; set; }
    public Nullable<decimal> amount { get; set; }
    public string categoryName { get; set; }
    public string tags { get; set; }
    public string label1 { get; set; }
    public string label2 { get; set; }
    public string label3 { get; set; }
    public decimal actualAmount { get; set; }
    public Nullable<decimal> expectedAmount { get; set; }
}
