// ==UserScript==
// @name          "Helper"
// @version       6.9
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
	list : function () {
		$('.h-group.preview-grid-item-content.ng-scope').each (function () {
			var a = $.trim ($('.targetLanguage', this).text ().match (/.*/));
			var b = $.trim ($('.baseLanguage'  , this).text ().match (/.*/));

			if (a && b) {
				pq.c.target [a] = b.match (/.[^;]*/) [0];
				pq.c.base   [b] = a.match (/.[^;]*/) [0];
			}
		});
		if (!$('#preview-section-navigator-label .ng-binding') [0]) {return;}

		$('#section-navigator-content .arrow.right').click ();

		if (parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [0])) < parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [1]))) {
			setTimeout (pq.list, 100);
		}
	},
	input: function () {
		if ($('.nice-button.positive-green.next-tutorial-button.ng-scope') [0] ? $('.nice-button.positive-green.next-tutorial-button.ng-scope') [0] :
            $('.continue-button.nice-button.positive-green'              ) [0] ? $('.continue-button.nice-button.positive-green'              ) [0] :
            $('.continue-button.text-link-button'                        ) [0] ? $('.continue-button.text-link-button'                        ) [0] : false) {
			a.click ();

			setTimeout (function () {
				setTimeout (function () {
					$('#feedback-form').val ('lol');

					setTimeout (function () {$('#start-button-main').click ();}, 500);
				}, 1000);
				setTimeout (function () {
					if (a == $('#preview-section-navigator-label .ng-binding') [0] ? parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [0])) : 1) {
						return;
					}

					$('#start-button-main-content').click ();

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
					$('.nice-button.light-grey.ng-scope').click ();
				}, 100);
				setTimeout (pq.input, 500);
			}, 200);
			return;
		} else if ($('.modal-body.v-group.h-align-center.ng-scope table tbody') [0]) {
			setTimeout (function () {
				pq.c.bad [$('#question-text').text ()] = $.text ($('.correct #correct-answer-field')).match (/.[^;\|]*/);

				setTimeout (function () {
					$('#continue-button').click ();
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
		$('input[id=answer-text]').val (a);

		var a = $('#submit-button') [0] ? $('#submit-button') [0] :
				$('.submit-button') [0] ? $('.submit-button') [0] : false;

		if (a) {
			a.click ();
		}

		setTimeout (pq.input, pq.delay);
	},
	delay: 1000
};

