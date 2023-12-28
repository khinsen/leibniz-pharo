Class {
	#name : #LzHtmlTextSnippetTermWriter,
	#superclass : #LzHtmlTextSnippetAnnotationWriter,
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetTermWriter >> cssClass [
	^ 'leibniz-example'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetTermWriter >> object [
	| lzContext |
	lzContext := (LzGlobalCache uniqueInstance
					contextCacheFor: self page title)
					subcontext: self subcontext.
	^ self declaration declaration objectFor: lzContext
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
	| object |
	object := self object.
	(self declaration options
		at: #withSort ifAbsent: false) ifTrue: [
		| sort |
		sort := object term sort.
		context html
			 tag: #span
			 class: 'whiter'
			 do: [
			 	context html nextPutAll: ' : '.
			 	context html
			 		tag: #i
			 		do: [ LzHtmlSyntaxPiece new
							text: sort asLeibnizSyntax;
							writeWithContext: context ] ] ].
	(self declaration options
		at: #withNormalForm ifAbsent: false) ifTrue: [
		| normalForm |
		normalForm := object normalForm.
		context html
			 tag: #span
			 class: 'computed'
			 do: [
			 	context html nextPutAll: ' ⇒ '.
			 	LzHtmlSyntaxPiece new
					text: normalForm asLeibnizSyntax;
					writeWithContext: context ] ].
]
