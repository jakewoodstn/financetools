
var clipboard = { "payee": "", "tags": "", "category": "" };

var selectedElem;
var shiftDown;
var ctrlDown;
var shiftSelectDir = 0;
var accountDisplay = ['baChecking', 'chaseCredit']
var debugStats;

$(document).keydown(function (evt) {
    if (evt.keyCode === 16) {
        evt.preventDefault();
        shiftDown = true;
    }

    if (evt.keyCode === 17) {
        evt.preventDefault();
        ctrlDown = true;
    }
});


$(document).keyup(function (evt) {
    if (evt.keyCode === 16) {
        shiftDown = false;
    }

    if (evt.keyCode === 17) {
        evt.preventDefault();
        ctrlDown = false;
    }
});


function copyTran() {
    if ($('.transSelected').length > 0) {
        clipboard.payee = $('.transSelected').first().find('.transDescription').text();
        clipboard.tags = $('.transSelected').first().find('.transTags').text();
        //clipboard.category = $('.transSelected').first().find('.transCat').find('.btn').text();
    }
}

function pasteTran(pasteTarget) {
    if ($('.transSelected').length > 0) {
        switch (pasteTarget) {
            case 'payee':
                saveMultiple(clipboard.payee);
                break;
        }
    }
}

function getPayeeCatStats() {

    includer = $('.transSelected').length > 0 ? 1 : includeAll;

    var f = {};
    initializeFilter(f);
    if ($('.transSelected').length > 0) {
        f.payee = $(".transSelected").first().find('.transDescription').text();
        f.category = "%";
        f.subcategory = "%";
        f.tag = "%";
        f.amount = 0;
        f.or = [];
        f.minDate = moment("9/1/2011", "MM/DD/YYYY");
    }
 
    var searcher = JSON.stringify(f);

    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",

        data: {
            "procedure": "transactionStatsJSON",
            "var0": 1,
            "var1": includer,
            "var2": accountFilter,
            "var3": currentSort.sortField,
            "var4": currentSort.sortDirection,
            "var5": searcher,
            "ct": 6
        },
        dataType: "json",
        success: function (retData) {
            parseStats(retData);
        },
        error: function (obj, disp, err) { fetchError(obj, disp, err); }
    });
}
function foldHandler(evt) {
    evt.preventDefault();
    targ = $(this).parent('.foldable');
    foldToggler(targ);
}

function foldToggler(targ) {
    $(targ).find('.folds').slideToggle();
}

function fold(targ) {
    $(targ).find('.folds').slideUp();
}

function unfold(targ) {
    $(targ).find('.folds').slideDown();
}

function parseCatStats(catStats, targetId) {

    cs = $(targetId);

    cs.html('');
    exs = [];
    incs = [];

    for (var i = 0; i < Object.keys(catStats).length; i++) {
        obj = catStats[i];
        innerObj = obj[Object.keys(obj)[0]];
        elem = document.createElement('span');
        $(elem).addClass('btn');
        $(elem).addClass('btn-sm');
        $(elem).addClass('transaction-focus');
        $(elem).click(function () {
            var tf = transactionFocus();
            readFieldsIntoFilter();
            var f = getFilters();
            var target = $(this).attr('id');
            target = target.substring(0, target.indexOf("Stats"));
            f[target] = $(this).text();
            tf.setFilter(f);
            tf.includeAll = ($('input[type="checkbox"]').is(':checked') ? 1 : 0);
            tf.arm();
            tf.post();
        });
        $(elem).text(innerObj.name);
        $(elem).attr('id', targetId.replace(/#/g, "") + '_' + innerObj.name.replace(/ /g, "_"));
        $(elem).attr('obs', innerObj.obs);
        $(elem).attr('spend', innerObj.spend);
        switch (Object.keys(obj)[0]) {
            case 'expense':
                $(elem).addClass('btn-danger');
                exs.push(elem);
                break;
            case 'income':
                $(elem).addClass('btn-success');
                incs.push(elem);
                break;
        }

    }



    exDiv = document.createElement('div');
    exLabel = document.createElement('span');
    $(exLabel).addClass('h5');
    $(exLabel).text('Expenses:');
    $(exDiv).append(exLabel);
    cs.append(exDiv);

    //debugStats = [catStats,exs];

    headrow = document.createElement('div');
    $(headrow).addClass('row');

    headColName = document.createElement('div');
    $(headColName).addClass('col-sm-6');
    $(headColName).text('Name');
    $(headrow).append(headColName);

    headColObs = document.createElement('div');
    $(headColObs).addClass('col-sm-3');
    $(headColObs).text('# Trans');
    $(headrow).append(headColObs);


    headColSpend = document.createElement('div');
    $(headColSpend).addClass('col-sm-3');
    $(headColSpend).text('$ Spent');
    $(headrow).append(headColSpend);
    cs.append(headrow);

    for (var j = 0; j < exs.length; j++) {
        r = document.createElement('div');
        $(r).addClass('dropTiny');
        $(r).addClass('row');

        c = document.createElement('div');
        $(c).addClass('col-sm-6');
        $(c).html(exs[j]);
        $(r).append(c);

        c = document.createElement('div');
        $(c).addClass('col-sm-3');
        $(c).text($(exs[j]).attr('obs'));
        $(r).append(c);

        c = document.createElement('div');
        $(c).addClass('col-sm-3');
        $(c).text(accounting.formatMoney($(exs[j]).attr('spend')));
        $(r).append(c);

        cs.append(r);
    }

    exDiv = document.createElement('div');
    exLabel = document.createElement('span');
    $(exLabel).addClass('h5');
    $(exLabel).text('Income:');
    $(exDiv).append(exLabel);
    $(exDiv).addClass('dropMedium');
    cs.append(exDiv);

    headrow = document.createElement('div');
    $(headrow).addClass('row');

    headColName = document.createElement('div');
    $(headColName).addClass('col-sm-6');
    $(headColName).text('Category Name');
    $(headrow).append(headColName);

    headColObs = document.createElement('div');
    $(headColObs).addClass('col-sm-3');
    $(headColObs).text('# Trans');
    $(headrow).append(headColObs);


    headColSpend = document.createElement('div');
    $(headColSpend).addClass('col-sm-3');
    $(headColSpend).text('$ Earned');
    $(headrow).append(headColSpend);
    cs.append(headrow);

    for (var j = 0; j < incs.length; j++) {
        r = document.createElement('div');
        $(r).addClass('dropTiny');
        $(r).addClass('row');

        c = document.createElement('div');
        $(c).addClass('col-sm-6');
        $(c).html(incs[j]);
        $(r).append(c);

        c = document.createElement('div');
        $(c).addClass('col-sm-3');
        $(c).text($(incs[j]).attr('obs'));
        $(r).append(c);

        c = document.createElement('div');
        $(c).addClass('col-sm-3');
        $(c).text(accounting.formatMoney($(incs[j]).attr('spend')));
        $(r).append(c);

        cs.append(r);
    }


}

function parseStats(transactionStats) {
    catLoc = $.inArray("categoryStats", Object.keys(transactionStats));
    if (catLoc > -1) { parseCatStats(transactionStats.categoryStats, "#categoryStats"); }

    payeeLoc = $.inArray("payeeStats", Object.keys(transactionStats));
    if (payeeLoc > -1) { parseCatStats(transactionStats.payeeStats, '#payeeStats'); }
}

function renderTags(tagData, target) {
    $(target).html('');

    var tagClass = target.indexOf("Transaction") == -1 ? 'allTag' : 'transactionTag';

    l = tagData.length;
    pivot = 0;
    for (var i = 0; i < l; i++) {
        pivot = tagData[i].fontIndex <= pivot ? pivot : tagData[i].fontIndex;
    }

    fontMin = 10;
    fontStep = 2;
    fontBase = fontMin + (5 > pivot ? 5 : pivot) * fontStep;

    for (var i = 0; i < l; i++) {
        obj = tagData[i];
        calcFontSub = obj.fontIndex * fontStep;
        sp = document.createElement('span');
        $(sp).text(obj.tag);
        $(sp).css('font-size', (fontBase - calcFontSub) + 'pt');
        $(sp).css('padding-right', '10px');
        $(sp).css('word-wrap', 'normal');
        $(sp).css('color', '#2050FF');
        $(sp).addClass(tagClass);
        $(sp).click(
               function () {
                   var tf = transactionFocus();
                   readFieldsIntoFilter();
                   var f = getFilters();
                   var target = $(this).hasClass('transactionTag') ? 'payee' : '';
                   f[target] = $(this).parent().attr('payee');
                   f['tag'] = $(this).text();
                   tf.setFilter(f);
                   tf.includeAll = ($('input[type="checkbox"]').is(':checked') ? 1 : 0);
                   tf.arm();
                   tf.post();
               }
        );
        $(target).append(sp);
        $(target).append('  ');
    }
    if (l == undefined) {
        sp = document.createElement('span');
        $(sp).text('no tags found.');
        $(sp).css('color', 'gray')
        $(target).append(sp);
    }

}

function getTags(target) {

    data = {};

    switch (target) {
        case "transaction":
            tranid = $('.transSelected').first().attr('id');
            if (tranid == undefined) { return undefined; }
            target = '#tagCloudTransaction';
            $(target).attr('payee', $('.transSelected').first().children('.transDescription').text());
            procedure = 'tagCloudForTransaction';
            data.var0 = tranid;
            break;
        case "all":
            target = '#tagCloudAll';
            procedure = 'tagCloudUniversal';
            break;
        default:
            break;
    }
    data.ct = Object.keys(data).length;
    data.procedure = procedure;

    $.ajax({
        type: 'POST',
        url: '/Content/shared/dataRetrieveJSON.cshtml',
        data: data,
        dataType: 'json',
        success: function (data) { renderTags(data, target); },
        error: function (obj, disp, err) { console.log(obj); console.log(disp); console.log(err); }
    });
}

function applyMapping() {
    newDesc = $('#typicalMap').text();
    $('.transSelected').each(function () {
        tranid = $(this).attr('id');
        $(this).children('.transDescription').text(newDesc);
        $.ajax({
            type: 'POST',
            url: '/Content/shared/dataRetrieveJSON.cshtml',
            data: {
                "procedure": "changeDescription",
                "var0": tranid,
                "var1": newDesc,
                "ct": 2
            },
            dataType: 'html'
        });
    });
}

function clearTypicalMapping() {
    $("#typicalMap").text("").hide()
    $("#typicalMapObsCt").text("").hide();
}

function setTypicalMapping(mappingObject) {
    clearTypicalMapping();
    if (Object.keys(mappingObject).length > 0) {
        $("#typicalMap").text(mappingObject.typicalMap).show();
        $("#typicalMapObsCt").text(mappingObject.obsCt).show();
    }
}

function getTypicalMapping() {
    var t = $('.transSelected').first();
    if (t.length == 0) { return; }
    $("#getMapping").addClass('disabled');

    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",

        data: {
            "procedure": "typicalPayeeMapping",
            "var0": $(t).attr('id'),
            "ct": 1
        },
        dataType: "json",
        success: function (retData) {
            setTypicalMapping(retData);
        },
        error: function (obj, disp, err) { clearTypicalMapping(); console.log(obj); console.log(disp); console.log(err); },
        complete: function () { $("#getMapping").removeClass('disabled'); }
    });
}


function updateSelectedCount() {
    var ct = $('.transSelected').length;
    $('#selectedCount').text(ct + ' ' + (ct == 1 ? 'record' : 'records') + ' selected');
    if (ct == 0) { clearTypicalMapping(); }
}

function selectedTransArray() {
    var myArr = new Array();
    $('.transSelected').each(function () {
        myArr.push($(this).attr("id"));
    });
    return myArr;
}

function approve() {
    var myArr = selectedTransArray();
    $("#loadingDiv").toggle(true);
    $('#buttonPanel').hide();
    $.ajax({
        type: 'POST',
        url: '/Content/shared/dataRetrieveJSON.cshtml',
        data: {
            "procedure": "approveCat",
            "var0": String(myArr),
            "ct": 1
        },
        dataType: 'html'
    });
    var elem = $('.sortSelected')[0];
    $(elem).toggleClass('asc');
    changeSort(elem, renderTrans);
    getButtons(renderButtons);

}

function assign(src, index) {
    var myArr = selectedTransArray();
    $.ajax({
        type: 'POST',
        url: '/Content/shared/dataRetrieveJSON.cshtml',
        data: {
            "procedure": "assignCat",
            "var0": String(myArr),
            "var1": ($(src).is("img") || $(src).is("span")) ? $('#catLabel' + $(src).attr("i")).text() : $("#selectAny option:selected").attr("id"),
            "ct": 2
        },
        dataType: 'html',
        success: function (data) {
            isAssigned = !($("#selectAny option:selected").attr("value") == 0);
            btn = "<span class='btn btn-sm btn-" + (isAssigned ? "primary" : "info") + "'>" + (isAssigned ? $("#selectAny option:selected").attr("id") : "Uncategorized") + "</span>";
            targHtml = ($(src).is("img") || $(src).is("span")) ? $('#catLabel' + $(src).attr("i")).html() : btn;
            $('.transSelected .transCatName').html(targHtml);
            $('.transSelected').toggleClass('transSelected');

        }
    });

}

function saveMultiple(value) {
    if (value == undefined) { value = $("#multiDescription").val() }
    var myArr = selectedTransArray();
    for (var i = 0; i < myArr.length; i++) {
        var elem = $("#Description" + myArr[i]);
        elem.text(value);
        $.ajax({
            type: 'POST',
            url: '/Content/shared/dataRetrieveJSON.cshtml',
            data: {
                "procedure": "changeDescription",
                "var0": elem.attr('id').substring(11),
                "var1": value,
                "ct": 2
            },
            dataType: 'html'
        });
    }
}

function renderButtons(buttons) {
    for (var i = 0; i < buttons.length; i++) {
        $('#catLabel' + i).each(
                    function () {
                        $(this).html("<button class='btn btn-primary btn-xs'>" + buttons[i] + "</button>");
                        $(this).attr("i", i);
                        $(this).addClass('quickCat')
                        $(this).click(
                            function () {
                                assign(this, $(this).attr("i"));
                            });
                    }
                );
        $('#catButton' + i).each(
                function () {
                    $(this).attr("i", i);
                    $(this).click(
                        function () {
                            assign(this, $(this).attr("i"));
                        });
                });
    }
}

function getButtons(callback) {
    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",
        data: {
            "procedure": "topCatJSON",
            "var0": 0,
            "var1": numTopCat,
            "var2": durTopCat,
            "var3": 'expenditure',
            "ct": 4
        },
        dataType: "json",
        success: function (retData) {
            callback(retData);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.responseText);
        }
    });
}


function selected(elem) {
    if (!shiftDown == true && !ctrlDown == true && !$(elem).hasClass("transSelected")) {
        $(".transSelected").removeClass("transSelected");
    }

    if (!(selectedElem === undefined) && shiftDown == true) {
        if (shiftSelectDir == 0) {
            if ($(selectedElem).parent().parent().nextAll().filter($(elem).parent().parent()).length > 0) {
                shiftSelectDir = 1;
                selected(elem);
            } else if ($(selectedElem).parent().parent().prevAll().filter($(elem).parent().parent()).length > 0) {
                shiftSelectDir = -1;
                selected(elem);
            }
        } else if (shiftSelectDir == 1) {
            selectedElem = $(selectedElem).parent().parent().next().children().children()[0];  //next, please
            $(selectedElem).toggleClass('transSelected'); //set selected attribute as appropriate
        } else if (shiftSelectDir == -1) {
            selectedElem = $(selectedElem).parent().parent().prev().children().children()[0];  //next, please
            $(selectedElem).toggleClass('transSelected'); //set selected attribute as appropriate
        }
        if ($(selectedElem).is(elem)) { // Done!
            shiftDown = false;
            shiftSelectDir = 0;
        } else {
            selected(elem); //recursive step
        }
    } else {
        selectedElem = elem;
        $(elem).toggleClass('transSelected');
    }
    updateSelectedCount();
}


function addOverlayButton(par, index) {
    var btn = document.createElement('img');
    $(btn).attr('class', 'editButton');
    var position = 16 * index + 4;
    $(btn).css('right', position.toString() + 'px');
    $(btn).click(function (e) { e.stopPropagation(); });
    $(par).css('position', 'relative');
    return btn;
}

function saveDate(tdef) {
    var v = $(tdef).find('input').val()
    var update = true;
    if (v == null || v == '') { v = $(tdef).attr('priorText'); update = false; }
    $(tdef).attr('priorText', v);
    out(tdef);
    var proc = "";

    if (update) {
        $.ajax({
            type: 'POST',
            url: '/Content/shared/dataRetrieveJSON.cshtml',
            data: {
                "procedure": "changeAcctingDate",
                "var0": $(tdef).attr('id').substring(11),
                "var1": v,
                "ct": 2
            },
            dataType: 'html'
        });
        redraw($(tdef).attr('id').substring(11));
    }
}

function saveDesc(tdef) {
    var v = $(tdef).find('input').val()
    var update = true;
    if (v == null || v == '') { v = $(tdef).attr('priorText'); update = false; }
    $(tdef).attr('priorText', v);
    out(tdef);

    if (update) {
        $.ajax({
            type: 'POST',
            url: '/Content/shared/dataRetrieveJSON.cshtml',
            data: {
                "procedure": "changeDescription",
                "var0": $(tdef).attr('id').substring(11),
                "var1": v,
                "ct": 2
            },
            dataType: 'html'
        });
    }
}

function clearTags(tdef) {
    tranId = $(tdef).attr('id').substring(4)
    $.ajax({
        type: 'POST',
        url: '/Content/shared/dataRetrieveJSON.cshtml',
        data: {
            "procedure": "clearTags",
            "var0": tranId,
            "ct": 1
        },
        success: function () {
            $(tdef).text('');
            $(tdef).attr('tagValue', '');
            $(tdef).attr('tagCount', 0);
            $(tdef).removeAttr('title');
        },
        dataType: 'html'
    });


}

function saveTags(tdef) {
    var v = $(tdef).find('input').val()
    var update = true;

    if (v == null || v == '') { v = $(tdef).attr('priorText'); update = false; }
    if (v.substring(v.length - 1) != ';') {
        v = v + ';'
    }
    var ct = v == ';' ? 0 : v.split(';').length - 1;
    $(tdef).attr('priorText', ct == 0 ? '&nbsp;' : v);
    out(tdef);

    if (update) {
        $.ajax({
            type: 'POST',
            url: '/Content/shared/dataRetrieveJSON.cshtml',
            data: {
                "procedure": "changeTags",
                "var0": $(tdef).attr('id').substring(4),
                "var1": v,
                "ct": 2
            },
            success: function () {
                $(tdef).attr('tagValue', v);
                $(tdef).attr('tagCount', ct);
                if (v == ';') { $(tdef).removeAttr('title'); } else { $(tdef).attr('title', v) }
            },
            dataType: 'html'
        });
    }
}

function out(tdef) {

    if ($(tdef).attr('priorText') !== 'undefined') { $(tdef).prepend($(tdef).attr('priorText')); $(tdef).removeAttr('priorText'); }
    $(tdef).css('color', "");
    $(tdef).find('input').remove();
    $(tdef).find('img[name!="editpencil"]').find('img[name!="split"]').find('img[name!="edittag"]').remove();
    $(tdef).find('.editButton').hide();
}

function editInPlace(evt) {


    evt.stopPropagation();
    var par = this.parentElement;
    $(this).css('display', 'none');
    $(par).attr('priorText', par.innerText);
    $(par).contents().filter(function () { return this.nodeType === 3; }).remove();
    var sv = addOverlayButton(par, 0);
    $(sv).attr('src', '/Images/save.png');
    $(sv).addClass('tinyButton');
    if (evt.data == undefined || evt.data.saveFunction == undefined) {
        $(sv).click(function () { save(par); });
    } else {
        $(sv).click(function () { evt.data.saveFunction(par); });
    }
    $(par).append(sv);
    $(sv).show();
    var can = addOverlayButton(par, 1);
    $(can).attr('src', '/Images/delete.png');
    $(can).addClass('tinyButton');
    if (evt.data == undefined || evt.data.clearFunction == undefined) {
        $(can).click(function () { out(par); });
    } else {
        $(can).click(function () { evt.data.clearFunction(par); });
    }
    $(par).append(can);
    $(can).show();
    var ipt = document.createElement('input');

    if (evt.data == undefined || evt.data.autoCompleteSproc == undefined) { }
    else { addAutocomplete(ipt, evt.data.autoCompleteSproc); }

    $(ipt).attr('type', 'text');
    $(ipt).addClass('form-control');
    $(ipt).click(function (e) { e.stopPropagation(); });
    $(ipt).keypress(function (e) {
        if (e.which == 13) {
            e.preventDefault();
            $(sv).click();
        }
    })

    if (evt.data == undefined || evt.data.valueAttr == undefined) {
        $(ipt).attr('value', $(par).attr('priorText'));
    } else {
        $(ipt).attr('value', $(par).attr(evt.data.valueAttr));
    }

    $(par).append(ipt);
    $(ipt).focus(function () { this.select(); });
    $(ipt).focus();
}

function redraw(transactionId) {

    var existing = $("#" + transactionId);
    if (existing.length > 0) {
        var transaction = { 'transactionId': transactionId };
        if (existing.hasClass('baChecking')) { transaction.accountId = 1; }
        if (existing.hasClass('chaseCredit')) { transaction.accountId = 2; }
        transaction.accountingDate = existing.find('.transDate').text();
        transaction.description = existing.find('.transDescription').text();
        transaction.bankOrigdescription = existing.find('.transDescription').attr('title');
        transaction.amount = existing.find('.transAmount').text();
        transaction.categoryName = existing.find('.transCatName .btn').text();
        transaction.categoryName = transaction.categoryName == ' Uncategorized' ? "" : transaction.categoryName;
        transaction.tags = existing.find('.transTags').text();
        transaction.tagCount = (transaction.tags.match(/;/g) || []).length;
        existing.replaceWith(transTable(transaction));
    }

    return existing.length;
}

function transTable(transaction) {
    var t = document.createElement('div');

    var acctId = parseInt(transaction.accountId);
    var tds = [0, 0, 0, 0, 0];
    var td;

    //date
    tds[0] = document.createElement('div');
    td = tds[0];

    var edd = addOverlayButton(td, 0);
    $(edd).attr('src', "/Images/edit.png");
    $(edd).attr('name', 'editpencil');
    $(edd).addClass('indelible');
    $(edd).addClass('tinyButton');
    $(td).attr('id', 'AcctingDate' + transaction.transactionId.toString());
    td.innerHTML = transaction.accountingDate;
    $(td).attr('class', 'transDate');
    $(edd).click({ 'saveFunction': saveDate }, editInPlace);
    $(td).append(edd);
    $(td).hover(function () { $(edd).fadeIn(); }, function () { out(tds[0]); });
    $(td).addClass('col-sm-1');

    $(t).append(td);

    //Payee
    tds[1] = document.createElement('div');
    td = tds[1];
    td.innerHTML = transaction.description;

    $(td).attr('class', 'transDescription');
    $(td).attr('id', 'Description' + transaction.transactionId.toString());
    $(td).attr('title', transaction.bankOrigDescription);

    var ed = addOverlayButton(td, 0);
    $(ed).attr('src', "/Images/edit.png");
    $(ed).attr('name', 'editpencil');
    $(ed).addClass('indelible');
    $(ed).addClass('tinyButton');
    $(ed).click({ 'saveFunction': saveDesc }, editInPlace);
    $(td).append(ed);
    $(td).hover(function () { $(ed).fadeIn(); }, function () { out(tds[1]); });
    $(td).addClass('col-sm-7');

    $(t).append(td);


    //amount
    tds[2] = document.createElement('div');
    td = tds[2];

    td.innerHTML = accounting.formatMoney(transaction.amount);
    $(td).attr('class', 'transAmount');
    $(td).attr('id', 'amount' + transaction.transactionId.toString());
    $(td).addClass('col-sm-1');
    $(t).append(td);


    //Category Field
    tds[4] = document.createElement('div');
    td = tds[4];


    $(td).attr('class', 'transCatName dropTiny');
    td.innerHTML = '<span class="btn btn-sm ' + (transaction.categoryName == '' ? 'btn-info"> Uncategorized' : 'btn-primary"> ' + transaction.categoryName) + '</span>';
    $(td).attr('colspan', '2');
    $(td).attr('id', 'Category' + transaction.transactionId.toString());
    var edsplit = addOverlayButton(td, 0);
    $(edsplit).attr('src', "/Images/split.png");
    $(edsplit).attr('name', 'split');
    $(edsplit).addClass('indelible');
    $(edsplit).addClass('tinyButton');
    $(edsplit).click(split);
    $(td).append(edsplit);
    $(td).hover(function () { $(edsplit).fadeIn(); }, function () { out(tds[4]); });
    $(td).addClass('col-sm-3');
    $(t).append(td);

    //Tag field
    tds[3] = document.createElement('div');
    td = tds[3];
    if (transaction.tagCount > 0) {
        td.innerHTML = transaction.tags.toString();
        $(td).attr('tagValue', transaction.tags);
        $(td).attr('tagCount', transaction.tagCount);
        $(td).attr('title', transaction.tags);
    }
    else {
        td.innerHTML = '&nbsp;';
    }
    $(td).attr('id', 'Tags' + transaction.transactionId.toString());
    $(td).addClass('transTags');
    var edTag = addOverlayButton(td, 0);
    $(edTag).attr('src', "/Images/tag.jpg");
    $(edTag).attr('name', 'edittag');
    $(edTag).addClass('indelible');
    $(edTag).addClass('tinyButton');
    $(edTag).click({ 'valueAttr': 'tagValue', 'saveFunction': saveTags, 'clearFunction': clearTags, 'autoCompleteSproc': 'tagAutocomplete' }, editInPlace);
    $(td).append(edTag);
    $(td).hover(function () { $(edTag).fadeIn(); }, function () { out(tds[3]); });
    $(td).addClass('col-sm-11 col-sm-offset-1');

    $(t).append(td);


    $(t).attr('id', transaction.transactionId);
    $(t).addClass('transactionDetail');
    $(t).attr('unselectable', 'on');
    $(t).addClass('row');
    $(t).addClass(accountDisplay[acctId - 1]);
    $(t).click(function (evt) { evt.preventDefault(); selected(t); });



    return t;
}

function renderTrans(data) {


    var ct = 0;
    var ctLimit = 500;
    if (data === null || data.length == 0) {
        $("#loadingDiv").toggle(false);
        $("#transactionsDiv").toggle(false);
        $("#noRecordsDiv").toggle(true);
        $("#recordCount").html('<a href="#" >0 records found.</a>');
    }
    $.each(data, function () {
        if (ct < ctLimit) {
            var tr = document.createElement('div');
            var td = document.createElement('div');
            $(td).append(transTable(this.transaction));
            $(td).addClass('transaction');
            $(td).addClass('col-sm-12');
            $(tr).append(td);
            $('#transactions').append(tr);
            ct += 1;
        }
    });
    $("#transactionsDiv").toggle(true);
    $("#recordCount").html('<a href="#">' + $("#transactions").children().length + ' records displayed.</a>')
    computeTotals();
}

function fetchError(obj, disp, err) {
    $("#transactionsDiv").text(disp);
    console.log(obj);
    console.log(err);
}

function fetchData(callback) {
    $("#noRecordsDiv").toggle(false);
    $("#loadingDiv").toggle(true);
    $('#transactionsDiv').html('<div id="transactions" class="col-sm-12"></div>');
    $('#selectedCount').text('0 records selected');
    $('.tagCloud').html('');

    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",

        data: {
            "procedure": "transactionsJSON",
            "var0": 0,
            "var1": includeAll,
            "var2": accountFilter,
            "var3": currentSort.sortField,
            "var4": currentSort.sortDirection,
            "var5": searchTerm,
            "ct": 6
        },
        dataType: "json",
        success: function (retData) {

            callback(retData);
        },
        error: function (obj, disp, err) { fetchError(obj, disp, err); },
        complete: function (j, t) {
            $("#loadingDiv").toggle(false);
        }
    });

    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",

        data: {
            "procedure": "transactionStatsJSON",
            "var0": 0,
            "var1": includeAll,
            "var2": accountFilter,
            "var3": currentSort.sortField,
            "var4": currentSort.sortDirection,
            "var5": searchTerm,
            "ct": 6
        },
        dataType: "json",
        success: function (retData) {
            parseStats(retData);
        },
        error: function (obj, disp, err) { fetchError(obj, disp, err); }
    });



}



function readFieldsIntoFilter() {
    f = getFilters();

    f.setFilter("minDate", moment($('.filter-control#filterMinDate').val(), 'MM/DD/YYYY'));
    f.setFilter("maxDate", moment($('.filter-control#filterMaxDate').val(), 'MM/DD/YYYY'));
    f.setFilter("accountId", [$('select.filter-control#accountSearch').children(':selected').first().index()]);
    if ($('.transSelected').length === 1) { f.setFilter("payee", $('.transSelected').children('.transDescription').text()); } else { f.setFilter("payee", $('.filter-control#filterPayee').val()); }
    f.setFilter("category", $('.filter-control#filterCategory').val());
    f.setFilter("tag", $('.filter-control#filterTag').val());
    f.setFilter("amount", accounting.formatNumber($('.filter-control#filterAmount').val(), 2));

    if ($('#filterAndOr input:checked').attr('id') == 'radio-1') {
        f.setFilter('or', ["amount", "payee", "category", "subcategory", "tag"]);
    } else {
        f.setFilter('or', []);

    }

    if (f.payee.indexOf('%') == -1 && f.payee.length > 0) { f.setFilter('payee', '%' + f.payee + '%'); };
    if (f.category.indexOf('%') == -1 && f.category.length > 0) { f.setFilter('category', '%' + f.category + '%'); };
    if (f.tag.indexOf('%') == -1 && f.tag.length > 0) { f.setFilter('tag', '%' + f.tag + '%'); };

    setFilters(f);

}

function processFilterFields() {

    readFieldsIntoFilter();
    includeAll = ($('input[type="checkbox"]').is(':checked') ? 1 : 0);
    applyFilter(renderTrans, true);

}

function readFilterFields() {
    f = getFilters();

    $('.filter-control#filterMinDate').val(f.minDate.format('MM/DD/YYYY'));
    $('.filter-control#filterMaxDate').val(f.maxDate.format('MM/DD/YYYY'));
    $("select.filter-control#accountSearch").prop('selectedIndex', f.accountId[0]);
    $(".filter-control#filterPayee").val(f.payee);
    $(".filter-control#filterCategory").val(f.category);
    $(".filter-control#filterTag").val(f.tag);
    $(".filter-control#filterAmount").val(accounting.formatMoney(f.amount));
}

function clearSearchFilter() {
    clearSearch();
    readFilterFields();
}

function computeTotals() {

    //var runningExpenseTotal = 0;
    //var runningIncomeTotal = 0;
    //var message ='';

    //if ($('.transAmount').length == 0) {
    //    message = 'No totals'
    //} else {

    //    $('.transAmount').each(
    //        function () {
    //            var a = accounting.unformat($(this).text());
    //            if (a < 0) { runningExpenseTotal += a; } else { runningIncomeTotal += a; }
    //        }
    //        );

    //    message = 'Income: ' + accounting.formatMoney(runningIncomeTotal) + ' Expense: ' + accounting.formatMoney(runningExpenseTotal);
    //}

    //$('#totals').text(message);
}

function sendToTransactionFocus() {
    var tf = transactionFocus();
    readFieldsIntoFilter();
    var f = getFilters();
    tf.setFilter(f);
    tf.includeAll = ($('input[type="checkbox"]').is(':checked') ? 1 : 0);
    tf.arm();
    tf.post();
}