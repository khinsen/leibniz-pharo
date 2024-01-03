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

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> htmlAttributes [
	| attrs |
	attrs := self declaration options associations
		select: [ :each | each value ~= false ]
		thenCollect: [ :each |
			{ each key . each value = true ifTrue: [ nil ] ifFalse: [ each value ] } ].
	^ { #class . self cssClass .
		#source . self declaration asLeibnizSyntaxString },
		attrs flattened
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> isExample [
	^ self declaration options
		at: #example ifAbsent: false
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> page [
	^ self snippet page
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
LzHtmlTextSnippetAnnotationWriter >> subcontext [
	^ self declaration options
		at: #subcontext ifAbsent: nil
]

{ #category : #accessing }
LzHtmlTextSnippetAnnotationWriter >> tag [
	^ #'unknown-leibniz-annotation'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> write [
	context html 
		inlineTag: self tag
		attributes: self htmlAttributes
		do: [
			self writeSubcontextLabel.
			self writeDeclaration.
			self isExample
				ifFalse: [ self writeComputedParts] ]
]

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> writeComputedParts [
]

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> writeDeclaration [
	LzHtmlSyntaxPiece new
		text: self declaration asLeibnizSyntax;
		writeWithContext: context.
]

{ #category : #'private - writing' }
LzHtmlTextSnippetAnnotationWriter >> writeSubcontextLabel [
	self subcontext ifNotNil: [ :sc |
		context html
			inlineTag: #sub
			class: 'leibniz-subcontext-name'
			with: sc.
		context html nextPutAll: '&nbsp;' ]
]
