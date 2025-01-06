Class {
	#name : #LzTextRenderer,
	#superclass : #Object,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzTextRenderer >> render: aText baseColor: aColor [
	aText attribute: (BlTextForegroundAttribute new paint: aColor).
	aText attributesDo: [ :attrs :index |
		attrs
			select: [ :each | each isKindOf: LzSyntaxAttribute ]
			thenDo: [ :attr |
				(attr visualAttributesForColor: aColor)
					ifNotEmpty: [ :visualAttrs |
						aText
							attributes: visualAttrs
							from: (index + 1) to: ((index + 1) min: aText size) ] ] ]
]
