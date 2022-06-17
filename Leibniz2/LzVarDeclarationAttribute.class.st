Class {
	#name : #LzVarDeclarationAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzVarDeclarationAttribute >> visualAttributeForColor: aColor [
	^ BlTextForegroundAttribute new paint: aColor quiteWhiter quiteWhiter
]
