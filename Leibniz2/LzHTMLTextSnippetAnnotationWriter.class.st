Class {
	#name : #LzHTMLTextSnippetAnnotationWriter,
	#superclass : #Object,
	#instVars : [
		'context',
		'snippet',
		'annotation',
		'response'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> annotation [
	^ annotation
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> annotation: anObject [
	annotation := anObject
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> context [
	^ context
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> context: anObject [
	context := anObject
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> declaration [
	^ LzDeclarationBuilder new
		acceptNode: self annotation.
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> snippet [
	^ snippet
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> snippet: anObject [
	snippet := anObject
]

{ #category : #accessing }
LzHTMLTextSnippetAnnotationWriter >> tag [
	^ #'unknown-leibniz-annotation'
]

{ #category : #'private - writing' }
LzHTMLTextSnippetAnnotationWriter >> write [
	context html 
		tag: self tag
		attributes: { 'class' . 'leibniz' .
						 'source' . self declaration asLeibnizSyntaxString }
		with: self declaration asLeibnizSyntaxString
]
