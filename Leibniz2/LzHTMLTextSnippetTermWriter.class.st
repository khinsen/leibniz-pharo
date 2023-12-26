Class {
	#name : #LzHtmlTextSnippetTermWriter,
	#superclass : #LzHtmlTextSnippetAnnotationWriter,
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlTextSnippetTermWriter >> cssClass [
	^ 'leibniz-example'
]

{ #category : #accessing }
LzHtmlTextSnippetTermWriter >> tag [
	^ #'leibniz-term'
]
