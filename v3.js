// ==UserScript==
// @name          "Helper"
// @version       8.4
// @author        Sir TE5T
// @require       http://code.jquery.com/jquery-3.2.1.min.js
// @match         http*://www.educationperfect.com/*
// @match         http*://www.languageperfect.com/*
// ==/UserScript==

pq = {
	c	: {
		target: {},
		base  : {},
		bad   : {}
	},
	list : function (z) {
		$('.h-group.preview-grid-item-content.ng-scope').each (function () {
			var a = $.trim ($('.targetLanguage', this).text ().match (/.*/));
			var b = $.trim ($('.baseLanguage'  , this).text ().match (/.*/));
			if (a && b) {
				pq.c.target [a] = b.match (/.[^;]*/) [0];
				pq.c.base   [b] = a.match (/.[^;]*/) [0];
			}
		});
		if (!$('#preview-section-navigator-label .ng-binding') [0] || z) {return;}
		var a = parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [0]));
		var b = parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [1]));
		$('#section-navigator-content .arrow.right').trigger ('click');
		if (a < b) {
			setTimeout (pq.list, 10);
		}
	},
	input: function () {
		if ($('.nice-button.positive-green.next-tutorial-button.ng-scope') [0] ? $('.nice-button.positive-green.next-tutorial-button.ng-scope') :
            $('.continue-button.nice-button.positive-green'              ) [0] ? $('.continue-button.nice-button.positive-green'              ) :
            $('.continue-button.text-link-button'                        ) [0] ? $('.continue-button.text-link-button'                        ) : false) {
			a.trigger ('click');
			setTimeout (function () {
				setTimeout (function () {
					$('#feedback-form').val ('lol');
					setTimeout (function () {$('#start-button-main').trigger ('click');}, 500);
				}, 1000);
				setTimeout (function () {
					if (a == $('#preview-section-navigator-label .ng-binding') [0] ? parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [0])) : 1) {
						return;
					}
					$('#start-button-main-content').trigger ('click');
					setTimeout (pq.input, 1000);
				}, 2000);
			}, 1500);
			return;
		} else if ($('.nice-button.light-grey.ng-scope') [0]) {
			setTimeout (function () {
				var a = $.text ($('.correct #correct-answer-field')).match (/.[^;\|]*/);
				pq.c.bad [$('#question-field').text ()] = a;
				pq.c.bad [$('#question-text' ).text ()] = a;
				setTimeout (function () {
					$('.nice-button.light-grey.ng-scope').trigger ('click');
				}, 100);
				setTimeout (pq.input, 500);
			}, 200);
			return;
		} else if ($('.modal-body.v-group.h-align-center.ng-scope table tbody') [0]) {
			setTimeout (function () {
				pq.c.bad [$('#question-text').text ()] = $.text ($('.correct #correct-answer-field')).match (/.[^;\|]*/);
				setTimeout (function () {
					$('#continue-button').trigger ('click');
				}, 100);
				setTimeout (pq.input, 500);
			}, 200);
			return;
		}
		var a = $('#question-text').text ();
		if (pq.c.bad [a]) {
			a = pq.c.bad [a];
		} else {
			a = $.trim (a.replace (/\([\w ]*"\w*"\)/, '')).replace (/,/g, ';');
			var b = $.trim (a.replace (/\(.*\)/, ''));
			a = pq.c.target [a] ? pq.c.target [a] :
				pq.c.base   [a] ? pq.c.base   [a] :
				pq.c.bad    [a] ? pq.c.bad    [a] :
				pq.c.bad    [b] ? pq.c.bad    [b] : '?';
		}
		$('input#answer-text')[0].select ();
		document.execCommand ('insertText', false, a);
		var a = $('#submit-button') [0] ? $('#submit-button') :
				$('.submit-button') [0] ? $('.submit-button') : false;
		if (a) {
			// cry at night because clicking doesnt work
		}
		setTimeout (pq.input, pq.delay);
	},
	delay: 1000
};
