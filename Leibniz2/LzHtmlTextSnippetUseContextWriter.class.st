Class {
	#name : #LzHtmlTextSnippetUseContextWriter,
	#superclass : #LzHtmlTextSnippetAnnotationWriter,
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetUseContextWriter >> tag [
	^ #'leibniz-use-context'
]

{ #category : #'private - writing' }
LzHtmlTextSnippetUseContextWriter >> writeDeclaration [
	context pageLinks
		linkTitled: annotation pageName
					source allButFirst allButLast
		ifFound: [ :aPageLink |
					| url |
					url := self context hrefBuilder hrefFromPageLink: aPageLink.
					context html
						inlineTag: #a
						attributes: {'href' . url }
						do: [ LzHtmlSyntaxPiece new
								text: self declaration asLeibnizSyntax;
								writeWithContext: context ] ]
		ifNone: [ LzHtmlSyntaxPiece new
				text: self declaration asLeibnizSyntax;
				writeWithContext: context ]
]
