/*
 * Add a 'android' class to the html element when such OS is detected along with properties to detect the version.
 * 
 * On android 2.2 the following classes will be present :
 *  - android
 *  - android-2
 *  - android-ge-1
 *  - android-ge-2
 */
(function( window, document, undefined ) {
	"use strict";
	
	var re = /android (\d+)[.;]/i;
	var match = re.exec(navigator.userAgent);
	if (!match) return;
	
	var majorVersion = match[1];
	var classes = ['android', 'android-' + majorVersion];
	for(var i = 1; i <= majorVersion; i++)
	{
		classes.push('android-ge-' + i);
	}
	
	var docElement = document.documentElement;
	docElement.className = docElement.className + ' ' + classes.join(' ');
})(this, this.document);