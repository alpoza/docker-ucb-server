/*
* Licensed Materials - Property of IBM Corp.
* IBM UrbanCode Build
* (c) Copyright IBM Corporation 2012, 2014. All Rights Reserved.
*
* U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
* GSA ADP Schedule Contract with IBM Corp.
*/
/*
 * CodePress regular expressions for CSS syntax highlighting
 */

// CSS
Language.syntax = [
	{ input : /(.*?){(.*?)}/g,output : '<b>$1</b>{<u>$2</u>}' }, // tags, ids, classes, values
	{ input : /([\w-]*?):([^\/])/g,output : '<a>$1</a>:$2' }, // keys
	{ input : /\((.*?)\)/g,output : '(<s>$1</s>)' }, // parameters
	{ input : /\/\*(.*?)\*\//g,output : '<i>/*$1*/</i>'} // comments
]

Language.snippets = []

Language.complete = [
	{ input : '\'',output : '\'$0\'' },
	{ input : '"', output : '"$0"' },
	{ input : '(', output : '\($0\)' },
	{ input : '[', output : '\[$0\]' },
	{ input : '{', output : '{\n\t$0\n}' }		
]

Language.shortcuts = []
