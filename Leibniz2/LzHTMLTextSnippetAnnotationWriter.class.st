Class {
	#name : #LzHtmlTextSnippetAnnotationWriter,
	#superclass : #Object,
	#instVars : [
		'context',
		'snippet',
		'annotation'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> annotation [
	^ annotation
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> annotation: anObject [
	annotation := anObject
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> context [
	^ context
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> context: anObject [
	context := anObject
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> declaration [
	^ LzDeclarationBuilder new
		acceptNode: self annotation.
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> snippet [
	^ snippet
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> snippet: anObject [
	snippet := anObject
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> tag [
	^ #'unknown-leibniz-annotation'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> write [
	| declaration |
	declaration := self declaration.
	context html 
		tag: self tag
		attributes: { 'class' . 'leibniz' .
						 'source' . declaration asLeibnizSyntaxString }
		do: [ LzHtmlSyntaxPiece new
				declaration: declaration;
				writeWithContext: context ]
]
