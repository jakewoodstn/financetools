

function bindAutocomplete(element, sourceArray) {
    $(element).autocomplete({ source: sourceArray });
}

function addAutocomplete(targetElement,sourceProcedure) {
    $.ajax({
        type: 'POST',
        url: "/Content/shared/dataRetrieveJSON.cshtml",
        data: {
            "procedure": sourceProcedure,
            "ct": 0
        },
        dataType: "json",
        success: function (retData) {
            bindAutocomplete(targetElement, retData);
        },
        error: function (obj, disp, err) { fetchError(obj, disp, err); }
    });
}

