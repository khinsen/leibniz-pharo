Class {
	#name : #LzInfixOpNameAttribute,
	#superclass : #LzIdentifierAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzInfixOpNameAttribute >> visualAttributesForColor: aColor [
	^ { BlTextForegroundAttribute new
			paint: aColor darker }
]
