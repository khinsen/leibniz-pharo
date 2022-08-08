Class {
	#name : #LzLeafErrorAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzLeafErrorAttribute >> visualAttributesForColor: aColor [
	^ { BlTextDecorationAttribute new
			underline;
			dashed;
			double;
			color: Color red }
]
