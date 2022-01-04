Class {
	#name : #LzCodeFont,
	#superclass : #Object,
	#classVars : [
		'DefaultFamily'
	],
	#category : #Leibniz2
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
	self error: 'No suitable Unicode font for Leibniz code'
]

{ #category : #accessing }
LzCodeFont class >> defaultFamily [
	^ DefaultFamily
]
