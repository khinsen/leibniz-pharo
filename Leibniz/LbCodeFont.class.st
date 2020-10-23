Class {
	#name : #LbCodeFont,
	#superclass : #Object,
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #selecting }
LbCodeFont class >> chooseDefaultFamily [
	| availableFamilies |
	availableFamilies := SkiaFontManager default familyNames.
	#('JuliaMono' 'Arial Unicode MS') do: [ :family |
		(availableFamilies includes: family)
			ifTrue: [ self compile: 'defaultFamily ^ ''', family, ''''.
						^ family ] ].
	self error: 'No suitable Unicode font for Leibniz code'
]

{ #category : #accessing }
LbCodeFont class >> defaultFamily [
	^ 'JuliaMono'
]

{ #category : #'as yet unclassified' }
LbCodeFont >> defaultFamily [ ^ 'Arial Unicode MS'
]
