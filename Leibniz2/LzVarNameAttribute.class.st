Class {
	#name : #LzVarNameAttribute,
	#superclass : #LzIdentifierAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzVarNameAttribute >> visualAttributeForColor: aColor [
	^ BlFontItalicAttribute new
]
