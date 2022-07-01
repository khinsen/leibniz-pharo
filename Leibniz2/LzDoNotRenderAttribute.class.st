Class {
	#name : #LzDoNotRenderAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzDoNotRenderAttribute >> visualAttributesForColor: aColor [
	^ { BlFontSizeAttribute new size: 0 }
]
