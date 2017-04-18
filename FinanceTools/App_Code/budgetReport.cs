using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for budgetReport
/// </summary>
public class budgetReport
{
    string _density;
    string _metric;
    string _depth;

    public budgetReport()
    {
        asOfDate = System.DateTime.Now;
        _density = "month";

    }

    public DateTime startDate { get; set; }
    public DateTime endDate { get; set; }
    public DateTime asOfDate { get; set; }
    public string density { get; set; }
    public string metric { get; set; }
    public string depth { get; set; }
}