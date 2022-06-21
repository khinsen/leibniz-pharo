Class {
	#name : #LzVarNameAttribute,
	#superclass : #LzIdentifierAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzVarNameAttribute >> visualAttributesForColor: aColor [
	^ { "BlFontItalicAttribute new."
		BlTextDecorationAttribute new
			underline
			color: aColor quiteWhiter quiteWhiter }
]
