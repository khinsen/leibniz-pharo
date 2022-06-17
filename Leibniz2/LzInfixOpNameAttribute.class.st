Class {
	#name : #LzInfixOpNameAttribute,
	#superclass : #LzIdentifierAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzInfixOpNameAttribute >> visualAttributeForColor: aColor [
	^ BlTextForegroundAttribute new paint: aColor darker
]
