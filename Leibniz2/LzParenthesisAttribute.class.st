Class {
	#name : #LzParenthesisAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzParenthesisAttribute >> visualAttributeForColor: aColor [
	^ BlTextForegroundAttribute new paint: aColor darker
]
