Class {
	#name : #LzTextRenderer,
	#superclass : #Object,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzTextRenderer >> render: aText baseColor: aColor [
	aText attributesDo: [ :attrs :index |
		attrs
			select: [ :each | each isKindOf: LzSyntaxAttribute ]
			thenDo: [ :attr |
				aText
					attribute: (attr visualAttributeForColor: aColor)
					from: index to: index ] ]
]
