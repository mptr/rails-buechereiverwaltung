//= require turbolinks
//= require jquery3
//= require_tree .
//= require jquery_ujs

var oneClickBlocked = false;
function oneClickBookAction(bookid, action, message = "Aktion erfolgreich") {
    return new Promise((resolve) => {
        var xhr = new XMLHttpRequest();
        let url = '/book_instances/' + bookid + '/' + action;
        console.log(url);
        xhr.open('POST', url, true);

        let header = "X-CSRF-Token"
        let token = $("meta[name='csrf-token']").attr("content");
        xhr.setRequestHeader(header, token);
        xhr.withCredentials = true;

        discardNotice($("#main .notice"));
        xhr.onreadystatechange = function() { 
            if (this.readyState === XMLHttpRequest.DONE) {
                if(this.status == 200) {
                    $("#main").append($(".noticetemplate").html().replace("%MESSAGE%", message));
                    reprocNoticeFunc();
                    resolve();
                } else {
                    alert("Bei der Anfrage trat ein Fehler auf.\nBitte erneut versuchen");
                    window.location.reload();
                }
                console.log("xhr finished with " + this.status);
            }
        }
        xhr.send(null);
    });
}

$(document).on('ready turbolinks:load', function () {
    $('table.dataTable').each((_,x) => {
        if($(x).attr('id')) return; // dont rerender datatables
        $(x).DataTable({
            language: { url: '//cdn.datatables.net/plug-ins/1.10.25/i18n/German.json' },
            drawCallback: function(settings) {
                var api = this.api();
                if (api.rows().data().length <= 10) { // make small tables slimmer
                    $('.dataTables_paginate, .dataTables_info, .dataTables_length, .dataTables_filter', x.parentElement).hide();
                }
            }
        });
    });

    const statechanges = {
        "lend": {
            next: "return", 
            title: "Zurückgeben",
            icon: "reply",
            did: "Buch erfolgreich ausgeliehen"
        },
        "return": {
            next: "lend", 
            title: "Ausleihen",
            icon: "book",
            did: "Buch erfolgreich zurückgegeben"
        },
        "reserve": {
            next: "dereserve", 
            title: "Reservierung löschen",
            icon: "event_busy",
            did: "Buch erfolgreich reserviert"
        },
        "dereserve":{
            next: "reserve", 
            title: "Reservieren",
            icon: "event_available",
            did: "Reservierung erfolgreich storniert"
        }
    };
    $(".oneClick").each((_,x) => {
        $(x).click(e => {
            if(oneClickBlocked) return; // deny requests until one is finished
            oneClickBlocked = true;
            $(x).attr('style', 'cursor:wait;');
            console.log($(x).attr('data-clickid'), $(x).attr('data-clickaction'));
            let to = statechanges[$(x).attr('data-clickaction')];
            oneClickBookAction(
                $(x).attr('data-clickid'),
                $(x).attr('data-clickaction'),
                to.did
            ).then(() => {
                $(x).parent().find(".tooltip").hide();
                $(x).attr('data-clickaction', to.next);
                $(x).attr('data-original-title', to.title);
                $(x).html(
                    '<i class="material-icons">' + to.icon + '</i>'
                    + ($(x).parent().hasClass("btn-group") ? "":to.title)
                );
                $(x).attr('style', '');
                oneClickBlocked = false;
            });
        });
    });

    $(function() {
        $('[data-toggle=tooltip]').tooltip(); 
    });

    $('.searchselect').selectpicker();

    reprocNoticeFunc();
});

var t1, t2;
function reprocNoticeFunc() {
    $("#main .notice, #main .error_explanation").find("a").click(() => {
        discardNotice($("#main .notice, #main .error_explanation"));
    });
    clearTimeout(t1);
    clearTimeout(t2);
    // discard all notices after 4s
    t1 = setTimeout(() => discardNotice($("#main .notice")), 4000);
    // discard all errors after 10s
    t2 = setTimeout(() => discardNotice($("#main .error_explanation")), 10000);
}
function discardNotice(x) {
    $(x).addClass("discard");
    setTimeout(() => {
        $(x).remove();
    }, 1000);
}