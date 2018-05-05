// ==UserScript==
// @name         "Helper"
// @version      6.9
// @author       Sir TE5T
// @require      http://code.jquery.com/jquery-3.2.1.min.js
// @match        http*://www.educationperfect.com/*
// @match        http*://www.languageperfect.com/*
// ==/UserScript==

pq = {
    c    : {
        target: {},
        base  : {},
        bad   : {}
    },
    list : function () {
        $('.h-group.preview-grid-item-content.ng-scope').each (function () {
            var a = $.trim ($('.targetLanguage', this).text ().match (/.*/));
            var b = $.trim ($('.baseLanguage',   this).text ().match (/.*/));
            pq.c.target[a] = b.match (/.[^;]*/)[0];
            pq.c.base  [b] = a.match (/.[^;]*/)[0];
        });
        if (!$('#preview-section-navigator-label .ng-binding')[0]) {return;}
        var a = parseInt ($.text ($('#preview-section-navigator-label .ng-binding')[0]));
        var b = parseInt ($.text ($('#preview-section-navigator-label .ng-binding')[1]));
        $('#section-navigator-content .arrow.right').click ();
        if (a < b) {
            setTimeout (pq.list, 200);
        }
    },
    input: function () {
        var a = $('.nice-button.positive-green.next-tutorial-button.ng-scope')[0] ? $('.nice-button.positive-green.next-tutorial-button.ng-scope')[0] :
                $('.continue-button.nice-button.positive-green'              )[0] ? $('.continue-button.nice-button.positive-green'              )[0] :
                $('.continue-button.text-link-button'                        )[0] ? $('.continue-button.text-link-button'                        )[0] : false;
        if (a) {
            a.click ();
            setTimeout (function () {
                $('#start-button-main').click ();
                setTimeout (function () {
                    var a = $('#preview-section-navigator-label .ng-binding')[0] ? parseInt ($.text ($('#preview-section-navigator-label .ng-binding')[0])) : 1;
                    if (a == 1) {return;}
                    $('#start-button-main-content').click ();
                    setTimeout (pq.input, 1000);
                }, 1200);
            }, 1500);
            return;
        }
        var a = $('.modal-body.v-group.h-align-center.ng-scope table tbody')[0];
        if (a) {
            setTimeout (function () {
                var a = $('#question-text').text ();
                var b = $.text ($('.correct #correct-answer-field')).match (/.[^;\|]*/);
                pq.c.bad[a] = b;
                setTimeout (function () {
                    $('#continue-button').click ();
                }, 1200);
                setTimeout (pq.input, 1500);
            }, 1000);
            return;
        }
        var a = $('#question-text').text ();
        if (pq.c.bad[a]) {
            a = pq.c.bad[a];
        } else {
            a = $.trim (a.replace (/\([\w ]*"\w*"\)/, '')).replace (/,/g, ';');
            a = pq.c.target[a] ? pq.c.target[a] :
                pq.c.base  [a] ? pq.c.base  [a] : '?';
        }
        $('input[id=answer-text]').val (a);
        if ($('#submit-button')) {
            $('#submit-button').click ();
        }
        setTimeout (pq.input, 100);
    }
};
