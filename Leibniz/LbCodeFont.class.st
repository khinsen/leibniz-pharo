Class {
	#name : #LbCodeFont,
	#superclass : #Object,
	#classVars : [
		'DefaultFamily'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : #inspecting }
LbCodeFont class >> brLabelCellStencil [

	^ [ 
	  BrLabel new
		  aptitude: (BrGlamorousLabelLook new fontName: self defaultFamily);
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
			ifTrue: [ DefaultFamily := family. ^ self] ].
	self error: 'No suitable Unicode font for Leibniz code'
]

{ #category : #accessing }
LbCodeFont class >> defaultFamily [
	^ DefaultFamily
]
