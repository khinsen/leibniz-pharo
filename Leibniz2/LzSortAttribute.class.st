Class {
	#name : #LzSortAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzSortAttribute >> visualAttributesForColor: aColor [
	^ { BlFontItalicAttribute new }
]
