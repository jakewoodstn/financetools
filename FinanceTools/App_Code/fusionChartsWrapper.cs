using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FusionCharts.Charts;
using System.Dynamic;
using System.Web.Helpers;



/// <summary>
/// Summary description for fusionChartsWrapper
/// </summary>
public class fusionChartsWrapper
{

    private IDictionary<string, string> _style;
    private IDictionary<string, string> _type;
    private IDictionary<string, string> _colors;
    private IDictionary<string, IList<IDictionary<string, string>>> _data;
    private IList<string> _keys;
    private int seriesCount;

    public fusionChartsWrapper()
    {
        _style = new Dictionary<string, string>();
        _type = new Dictionary<string, string>();
        _colors = new Dictionary<string, string>();
        _data = new Dictionary<string, IList<IDictionary<string, string>>>();
        _keys = new List<string>();
    }

    public FusionCharts.Charts.Chart makeChart()
    {
        string chartType = _type["chartType"];
        string chartId = _type["chartId"];
        string chartWidth = _type["chartWidth"];
        string chartHeight = _type["chartHeight"];
        string missingValue = _type.ContainsKey("missingValue") ? _type["missingValue"] : "0";

        FusionCharts.Charts.Chart c = new FusionCharts.Charts.Chart(chartType, chartId, chartWidth, chartHeight, "json");
        string chartOptionsJSON = "\"chart\":" + Json.Encode(_style);
        string chartJSON = "";
        if (seriesCount == 1)
        {
            string dataArrayJSON = "\"data\":" + Json.Encode(_data.First().Value);
            chartJSON = "{" + chartOptionsJSON + "," + dataArrayJSON + "}";
        }
        else if (seriesCount > 1)
        {
            IList<IDictionary<string, string>> _labeledKeys = new List<IDictionary<string, string>>();
            foreach (string i in _keys)
            {
                IDictionary<string, string> _labeledKey = new Dictionary<string, string>();
                _labeledKey.Add("label", i);
                _labeledKeys.Add(_labeledKey);
            }

            IList<IDictionary<string, string>> serii = new List<IDictionary<string, string>>();

            foreach (KeyValuePair<string, IList<IDictionary<string, string>>> d in _data)
            {

                string seriesName = d.Key;
                Dictionary<string, string> seriesFullEntry = new Dictionary<string, string>();
                IDictionary<string, string> seriesData = new Dictionary<string, string>();

                foreach (Dictionary<string, string> dd in d.Value)
                {
                    seriesData.Add(dd["label"], dd["value"]);
                }

                IList<IDictionary<string, string>> completeSeriesData = new List<IDictionary<string, string>>();
                string lastvalue = "0";
                foreach (string k in _keys)
                {
                    IDictionary<string, string> entry = new Dictionary<string, string>();
                    if (seriesData.ContainsKey(k))
                    {
                        entry.Add("value", seriesData[k]);
                        lastvalue = seriesData[k];
                    }
                    else
                    {
                        entry.Add("value", missingValue == "0" ? "0" : (missingValue == "last" ? lastvalue : null));
                    }
                    completeSeriesData.Add(entry);
                }
                seriesFullEntry.Add("seriesname", seriesName);
                if (_colors.ContainsKey(seriesName)) { seriesFullEntry.Add("color", _colors[seriesName]); }
                seriesFullEntry.Add("data", Json.Encode(completeSeriesData).Replace("\\", ""));
                serii.Add(seriesFullEntry);
            }

            string catJSON = "\"categories\":[{\"category\":" + Json.Encode(_labeledKeys) + "}]";
            string dataJSON = "\"dataset\":" + Json.Encode(serii).Replace("\\", "").Replace("\"[", "[").Replace("]\"", "]");
            chartJSON = "{" + chartOptionsJSON + "," + catJSON + "," + dataJSON + "}";

        }
        c.SetData(chartJSON, FusionCharts.Charts.Chart.DataFormat.json);

        return c;
    }

    public IDictionary<string, string> setType(string chartType = "column2d",
                                                           string chartId = "",
                                                           string chartWidth = "650",
                                                           string chartHeight = "400",
                                                           string missingValue = "0")
    {
        foreach (string o in _type.Keys)
        {
            _type.Remove(o);
        }

        _type.Add("chartType", chartType);
        _type.Add("chartId", chartId);
        _type.Add("chartWidth", chartWidth);
        _type.Add("chartHeight", chartHeight);
        _type.Add("missingValue", missingValue);

        return _type;
    }

    public IDictionary<string, string> setStyle(string bgColor = "#FFFFFF",
                                                            string caption = "Caption",
                                                            string subCaption = "Sub Caption",
                                                            string xAxisName = "X axis",
                                                            string yAxisName = "Y axis",
                                                            string numberPrefix = "$",
                                                            string showBorder = "0",
                                                            string theme = "fint",
                                                            string pieRadius = "0",
                                                            string formatNumberScale = "0",
                                                            string showPercentValues = "1",
                                                            string decimals = "1",
                                                            string forceDecimals = "0",
                                                            string defaultCenterLabel = "",
                                                            string showPercentInTooltip = "0",
                                                            string stack100Percent = "0",
                                                            string labelDisplay = "auto",
                                                            string labelStep = "1",
                                                            string showValues = "1",
                                                            string drawAnchors = "1"
                                                        )
    {

        foreach (string o in _style.Keys)
        {
            _style.Remove(o);
        }

        _style.Add("bgColor", bgColor);
        _style.Add("caption", caption);
        _style.Add("subCaption", subCaption);
        _style.Add("xAxisName", xAxisName);
        _style.Add("yAxisName", yAxisName);
        _style.Add("numberPrefix", numberPrefix);
        _style.Add("showBorder", showBorder);
        _style.Add("theme", theme);
        _style.Add("decimals", decimals);
        _style.Add("forceDecimals", forceDecimals);
        _style.Add("formatNumberScale", formatNumberScale);
        _style.Add("pieRadius", pieRadius);
        _style.Add("showPercentValues", showPercentValues);
        _style.Add("defaultCenterLabel", defaultCenterLabel);
        _style.Add("showPercentInTooltip", showPercentInTooltip);
        _style.Add("stack100Percent", stack100Percent);
        _style.Add("labelDisplay", labelDisplay);
        _style.Add("labelStep", labelStep);
        _style.Add("showValues", showValues);
        _style.Add("drawAnchors", drawAnchors);

        return _style;
    }


    public IDictionary<string, string> modifyChartOption(IDictionary<string, string> optionDict, string optionLabel, string optionValue)
    {
        optionDict[optionLabel] = optionValue;
        return optionDict;
    }

    private IDictionary<string, string> dataElement(string label, string value)
    {
        IDictionary<string, string> _me = new Dictionary<string, string>();
        _me.Add("label", label);
        _me.Add("value", value);
        return _me;
    }


    public void addData(string dataSetName, IDictionary<string, string> dataSet, string seriesColor="")
    {
        List<IDictionary<string, string>> _dataSet = new List<IDictionary<string, string>>();
        foreach (KeyValuePair<string, string> entry in dataSet)
        {

            if (!_keys.Contains(entry.Key)) { _keys.Add(entry.Key); }
            _dataSet.Add(dataElement(entry.Key, entry.Value));
        }

        if (seriesColor != "") { _colors.Add(dataSetName, seriesColor); }
        _keys = _keys.OrderBy(q => q).ToList();
        _data.Add(dataSetName, _dataSet);
        seriesCount = _data.Keys.Count;

    }
}