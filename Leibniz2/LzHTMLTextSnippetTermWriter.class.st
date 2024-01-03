Class {
	#name : #LzHtmlTextSnippetTermWriter,
	#superclass : #LzHtmlTextSnippetAnnotationWriter,
	#instVars : [
		'object'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetTermWriter >> cssClass [
	^ 'leibniz-example'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetTermWriter >> object [
	object ifNil: [
		| lzContext |
		lzContext := (self page lzDBCache
						contextCacheFor: self page title)
						subcontext: self subcontext.
		object := self declaration declaration objectFor: lzContext ].
	^ object
]

{ #category : #'private - writing' }
LzHtmlTextSnippetTermWriter >> page [
	^ self snippet page
]

{ #category : #accessing }
LzHtmlTextSnippetTermWriter >> tag [
	^ #'leibniz-term'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetTermWriter >> writeComputedParts [
	(self declaration options
		at: #withSort ifAbsent: false) ifTrue: [
		| sort |
		sort := self object term sort.
		context html
			 inlineTag: #span
			 class: 'whiter'
			 do: [
			 	context html nextPutAll: ' : '.
			 	context html
			 		inlineTag: #i
			 		do: [ LzHtmlSyntaxPiece new
							text: sort asLeibnizSyntax;
							writeWithContext: context ] ] ].
	(self declaration options
		at: #withNormalForm ifAbsent: false) ifTrue: [
		| normalForm |
		normalForm := self object normalForm.
		context html
			 inlineTag: #span
			 class: 'computed'
			 do: [
			 	context html nextPutAll: ' ⇒ '.
			 	LzHtmlSyntaxPiece new
					text: normalForm asLeibnizSyntax;
					writeWithContext: context ] ].
]

{ #category : #'private - writing' }
LzHtmlTextSnippetTermWriter >> writeDeclaration [
	self object sort isKind
		ifTrue: [
			context html
				inlineTag: #u
				class: 'leibniz-bad-sort'
				do: [ super writeDeclaration ] ]
		ifFalse: [ super writeDeclaration ]
]
