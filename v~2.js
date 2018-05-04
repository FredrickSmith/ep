// ==UserScript==
// @name		 "Helper"
// @version	  6.9
// @author	   Sir TE5T
// @require	  http://code.jquery.com/jquery-3.2.1.min.js
// @match		http*://www.educationperfect.com/*
// @match		http*://www.languageperfect.com/*
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
		var a = parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [0]));
		var b = parseInt ($.text ($('#preview-section-navigator-label .ng-binding') [1]));
		$('#section-navigator-content .arrow.right').click ();
		if (a < b) {
			setTimeout (pq.list, 10);
		}
	},
	input: function () {
		document.addEventListener ('copy', function (e) {
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
			e.clipboardData.setData ('text/plain', a);
			e.preventDefault ();
		});
	}
};
