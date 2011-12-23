/*
 * Add a 'webkit' class to the html element when such browser is detected.
 */
(function( window, document, undefined ) {
	var re = /webkit/i;
	var match = re.exec(navigator.userAgent);
	if (!match) return;
	
	var docElement = document.documentElement;
	docElement.className = docElement.className + ' webkit';
})(this, this.document);