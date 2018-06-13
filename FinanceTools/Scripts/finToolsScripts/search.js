var searchTerm = '';
var includeAll = 0;
var accountFilter = 0;
var filter = {};

function initializeFilter(f) {

    f.setFilter = function (term, value) {
        this[term] = value;
    }

    f.setFilter("payee", "%");

    today = new Date();
    dt = (today.getMonth() + 1) + "/1/" + today.getFullYear();

    f.setFilter("minDate", moment(dt, 'MM/DD/YYYY'));
    f.setFilter("maxDate", moment());
    f.setFilter("category", "%");
    f.setFilter("subcategory", "%");
    f.setFilter("tag", "%");
    f.setFilter("amount", 0.0);
    f.setFilter("accountId", [0]);
    f.setFilter("or", ['amount', 'category', 'payee', 'tag', 'subcategory']);

}

function firstOfMonth(inDate) {

    if (inDate === undefined) {
        inDate = moment();
    }
    else {
        inDate = moment(inDate, ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]);
    }
    dt = moment((inDate.month() + 1) + "/1/" + inDate.year(), ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]);

    return dt;
}

function lastOfMonth(inDate) {
    d = firstOfMonth(inDate);
    dt = d.add(1, "months").add(-1, "days");
    return dt;
}

function modDate(control, target, modifier) {
    switch (arguments.length) {
        case 2:
            if (typeof (target) == "object") {
                $(control).val(target.format("MM/DD/YYYY"));
            } else {
                $(control).val(moment(target, ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]).format("MM/DD/YYYY"));
            }
            break;
        case 3:
            $(control).val(moment($(control).val(), ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]).add(modifier, target).format("MM/DD/YYYY"));
            break;
        default: break;
    }
}


function modDateSinceLastMonth() {

    today = moment();
    dts = [];
    dts[0] = firstOfMonth(today).add(-1, "month");
    dts[1] = lastOfMonth(today)

    modDate("#filterMinDate", dts[0]);
    modDate("#filterMaxDate", dts[1]);

}

function modDateLastMonth() {

    today = moment();
    dts = [];
    dts[0] = firstOfMonth(today).add(-1, "month");
    dts[1] = firstOfMonth(today).add(-1, "days");

    modDate("#filterMinDate", dts[0]);
    modDate("#filterMaxDate", dts[1]);

}


function modDateThisYear() {

    today = moment();
    dts = [];
    dts[0] = firstOfMonth(today).add(firstOfMonth(today).month() * -1, "month");
    dts[1] = firstOfMonth(today).add(firstOfMonth(today).month() * -1, "month").add(1, "year").add(-1, "days");

    modDate("#filterMinDate", dts[0]);
    modDate("#filterMaxDate", dts[1]);

}

function modDateThisQuarter() {

    today = moment();
    dts = [];
    dts[0] = firstOfMonth(today).add((firstOfMonth(today).month() % 3) * -1, "month");
    dts[1] = firstOfMonth(today).add((firstOfMonth(today).month() % 3) * -1, "month").add(3, "month").add(-1, "days");

    modDate("#filterMinDate", dts[0]);
    modDate("#filterMaxDate", dts[1]);

}

function modDateThisMonth() {

    today = moment();
    dts = [];
    dts[0] = firstOfMonth(today);
    dts[1] = lastOfMonth(today);

    modDate("#filterMinDate", dts[0]);
    modDate("#filterMaxDate", dts[1]);

}


function modDateAddMonth(control, addend, format) {
    if (format === undefined) { format = "MM/DD/YYYY";}
    $(control).val(moment($(control).val(), ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]).add(addend, "month").format(format));
}

function modDateAddDay(control, addend, format) {
    if (format === undefined) { format = "MM/DD/YYYY"; }
    $(control).val(moment($(control).val(), ["M/D/Y", "M-D-Y", "Y-M-D", "Y/M/D", "YMD"]).add(addend, "day").format(format));
}

function parseTerm(searchTerm) {
    initializeFilter(filter);

    var dateRegex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2} - (0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/;
    var amountRegex = /^-?[0-9]*(\.[0-9])??[0-9]*$/;
    if (dateRegex.test(searchTerm)) {
        filter.setFilter('minDate', moment(searchTerm.substr(0, 10), "MM/DD/YYYY"));
        filter.setFilter('maxDate', moment(searchTerm.substr(13, 10), "MM/DD/YYYY"));
        if (filter.minDate > filter.maxDate) { tmp = filter.maxDate; filter.maxDate = filter.minDate; filter.minDate = tmp; }
        filter.setFilter("or", []);
    } else if (amountRegex.test(searchTerm) && !isNaN(searchTerm)) {
        filter.setFilter('amount', searchTerm);
        filter.setFilter("or", []);
    }
    else {
        if (searchTerm.indexOf('%') == -1) { searchTerm = "%" + searchTerm + "%"; }
        filter.setFilter("payee", searchTerm);
        filter.setFilter("category", searchTerm);
        filter.setFilter("subcategory", searchTerm);
        filter.setFilter("tag", searchTerm);
        filter.or.push("payee");
        filter.or.push("category");
        filter.or.push("subcategory");
        filter.or.push("tag");
    }
}

function search() {

    searchTerm = $('#searcher').val() === undefined ? '' : $('#searcher').val();
    parseTerm(searchTerm);
    searchTerm = JSON.stringify(filter);
    includeAll = ($('input[type="checkbox"]').is(':checked') ? 1 : 0);
    fetchData(renderTrans);
}

function applyFilter(callback, fetch) {

    fetch = (callback === undefined || fetch === undefined) ? false : fetch;

    searchTerm = JSON.stringify(filter);
    if (fetch) { fetchData(callback) };
}

function clearSearch() {
    searchTerm = '';
    includeAll = 0;
    accountFilter = 0;
    $("select option").filter(function () { return $(this).text() == 'All Accounts'; }).attr('selected', true);
    $('input[type="checkbox"]').removeAttr('checked');
    $('#searcher').val('');
    initializeFilter(filter);
    searchTerm = JSON.stringify(filter);
    fetchData(renderTrans);
}

function accountChange() {
    accountFilter = parseInt($('#accountSearch option:selected').attr('accountId'));
    filter.setFilter("accountId", [accountFilter]);
}

function getFilters() { return filter; }
function setFilters(f) { filter = f; return filter; }

$(document).ready(
    function () {
        initializeFilter(filter);
        searchTerm = JSON.stringify(filter);
    }
);