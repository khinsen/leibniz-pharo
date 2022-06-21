Class {
	#name : #LzParenthesisAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzParenthesisAttribute >> visualAttributesForColor: aColor [
	^ { BlTextForegroundAttribute new
			paint: aColor darker }
]
