﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;

using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
// Use FusionCharts.Charts name space
using FusionCharts.Charts;

public partial class BasicExample_BasicChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        // Render the chart
        Literal1.Text = "Please browse to individual folders to view different samples";
    }
}
