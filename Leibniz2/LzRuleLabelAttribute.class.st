Class {
	#name : #LzRuleLabelAttribute,
	#superclass : #LzSyntaxAttribute,
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzRuleLabelAttribute >> visualAttributesForColor: aColor [
	^ { BlFontWeightAttribute bold.
		BlTextForegroundAttribute new
			paint: aColor darker }
]
