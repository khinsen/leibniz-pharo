Class {
	#name : #LzVarNameAttribute,
	#superclass : #LzIdentifierAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzVarNameAttribute >> visualAttributesForColor: aColor [
	^ { BlTextDecorationAttribute new
			underline
			color: aColor quiteWhiter quiteWhiter }
]
