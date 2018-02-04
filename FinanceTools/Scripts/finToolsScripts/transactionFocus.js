function transactionFocus() {

    var tf = {}

    tf.filter = {};
    tf.form = {};
    tf.armed = false;
    tf.includeAll=0;

    tf.setFilter = function (f) { this.filter = f; this.resetForm();}
    tf.getFilter = function () { return this.filter;}

    tf.resetForm = function () {
        this.form = $('<form>', { "action": "/Content/transactionFocus.cshtml", "method": "post", "target": "_blank" });
        this.armed = false;
    }

    tf.arm = function () {
        this.form.append($('<input>', { "type": "hidden", "name": "filterPayee", "id": "filterPayee", "value": this.filter.payee }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterMinDate", "id": "filterMinDate", "value":this.filter.minDate.format("MM/DD/YYYY") }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterMaxDate", "id": "filterMaxDate", "value": this.filter.maxDate.format("MM/DD/YYYY") }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterCategory", "id": "filterCategory", "value": this.filter.category }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterTag", "id": "filterTag", "value": this.filter.tag }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterAmount", "id": "filterAmount", "value": this.filter.amount }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterAccountId", "id": "filterAccountId", "value": this.filter.accountId }));
        this.form.append($('<input>', { "type": "hidden", "name": "filterOr", "id": "filterOr", "value": this.filter.or }));

        this.form.append($('<input>', { "type": "hidden", "name": "filterIncludeAll", "id": "filterIncludeAll", "value": this.includeAll }));


        this.armed = true;
    }

    tf.post = function () { if (tf.armed) { $(document.body).append(this.form); this.form.submit(); } else { console.warn('transaction focus not fired because unarmed') } }

    return tf;
}

function transactionTable(data) {
    console.log(data);
}