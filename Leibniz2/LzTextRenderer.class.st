Class {
	#name : #LzTextRenderer,
	#superclass : #Object,
	#category : #'Leibniz2-Rendering'
}

{ #category : #rendering }
LzTextRenderer >> render: aText baseColor: aColor [
	aText fontName: LzCodeFont defaultFamily.
	aText attribute: (BlTextForegroundAttribute new paint: aColor).
	aText attributesDo: [ :attrs :index |
		attrs
			select: [ :each | each isKindOf: LzSyntaxAttribute ]
			thenDo: [ :attr |
				(attr visualAttributeForColor: aColor)
					ifNotNil: [ :visualAttr |
						aText
							attribute: visualAttr
							from: index + 1 to: index + 1 ] ] ]
]
