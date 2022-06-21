Class {
	#name : #LzVarNameTrailingUnderscoreAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzVarNameTrailingUnderscoreAttribute >> visualAttributesForColor: aColor [
	^ { BlFontSizeAttribute new size: 0 }
]
