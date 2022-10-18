Class {
	#name : #LzCodeFont,
	#superclass : #Object,
	#classVars : [
		'DefaultFamily'
	],
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #inspecting }
LzCodeFont class >> brLabelCellStencil [
	^ [ BrLabel new
		  aptitude: (BrGlamorousLabelAptitude new fontName: self defaultFamily);
		  alignCenterLeft;
		  hMatchParent;
		  vFitContent ]
]

{ #category : #inspecting }
LzCodeFont class >> brLabelFor: aString [
	^ self brLabelCellStencil value
			text: aString asRopedText;
			yourself
]

{ #category : #choosing }
LzCodeFont class >> chooseDefaultFamily [
	| availableFamilies |
	availableFamilies := SkiaFontManager default familyNames.
	#('JuliaMono' 'Arial Unicode MS') do: [ :family |
		(availableFamilies includes: family)
			ifTrue: [ DefaultFamily := family. ^ self] ].
	DefaultFamily := (' ' asRopedText glamorousCodeFont
						attributesAt: 1) first name
]

{ #category : #accessing }
LzCodeFont class >> defaultFamily [
	^ DefaultFamily
]

{ #category : #accessing }
LzCodeFont class >> textFrom: aBlock [
	| text |
	text := '' asRopedText.
	aBlock value: text.
	text fontName: LzCodeFont defaultFamily.
	^ text
]
