Class {
	#name : #LbCodeFont,
	#superclass : #Object,
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #inspecting }
LbCodeFont class >> brLabelCellStencil [
	^ [ BrLabel new
			look: (BrGlamorousLabelLook new
                fontName: self defaultFamily);
				alignCenterLeft;
				hMatchParent;
				vFitContent ]
]

{ #category : #acccessing }
LbCodeFont class >> brLabelFor: aString [
	^ LbCodeFont brLabelCellStencil value
			text: aString asRopedText;
			yourself
]

{ #category : #selecting }
LbCodeFont class >> chooseDefaultFamily [
	| availableFamilies |
	availableFamilies := SkiaFontManager default familyNames.
	#('JuliaMono' 'Arial Unicode MS') do: [ :family |
		(availableFamilies includes: family)
			ifTrue: [ self class compile: 'defaultFamily ^ ''', family, ''''.
						^ family ] ].
	self error: 'No suitable Unicode font for Leibniz code'
]

{ #category : #accessing }
LbCodeFont class >> defaultFamily [
	^ 'Arial Unicode MS'
]
