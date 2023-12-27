Class {
	#name : #LzHtmlTextSnippetAnnotationWriter,
	#superclass : #Object,
	#instVars : [
		'context',
		'snippet',
		'annotation',
		'declaration'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> annotation [
	^ annotation
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> annotation: anLzSyntaxAnnotation [
	annotation := anLzSyntaxAnnotation.
	declaration := LzDeclarationBuilder new
		acceptNode: anLzSyntaxAnnotation.
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
LzHtmlTextSnippetAnnotationWriter >> cssClass [
	^ self isExample
		ifTrue: [ 'leibniz-example' ]
		ifFalse: [ 'leibniz' ]
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> declaration [
	^ declaration
]

{ #category : #testing }
LzHtmlTextSnippetAnnotationWriter >> isExample [
	^ self declaration options
		at: #example ifAbsent: false
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
	context html 
		tag: self tag
		attributes: { 'class' . self cssClass .
						 'source' . self declaration asLeibnizSyntaxString }
		do: [ LzHtmlSyntaxPiece new
				declaration: self declaration;
				writeWithContext: context ]
]
