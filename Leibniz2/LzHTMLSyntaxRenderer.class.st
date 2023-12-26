Class {
	#name : #LzHTMLSyntaxRenderer,
	#superclass : #Object,
	#instVars : [
		'declaration'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHTMLSyntaxRenderer >> content [
	| text |
	text := self declaration asLeibnizSyntax.

	^ self declaration asLeibnizSyntaxString
]

{ #category : #accessing }
LzHTMLSyntaxRenderer >> declaration [
	^ declaration
]

{ #category : #accessing }
LzHTMLSyntaxRenderer >> declaration: anLzDeclaration [
	declaration := anLzDeclaration
]
