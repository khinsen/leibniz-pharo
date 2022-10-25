Class {
	#name : #LzAssetLabelAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzAssetLabelAttribute >> visualAttributesForColor: aColor [
	^ { BlFontWeightAttribute bold.
		BlTextForegroundAttribute new
			paint: aColor darker }
]
