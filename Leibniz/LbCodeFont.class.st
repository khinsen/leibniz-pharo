Class {
	#name : #LbCodeFont,
	#superclass : #Object,
	#category : #'Leibniz-0-Infrastructure'
}

{ #category : #inspecting }
LbCodeFont class >> brLabelCellStencil [
	^ [ BrLabel new
			look: (BrGlamorousLabelLook new
                fontName: self defaultFamily) ]
]

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

{ #category : #inspecting }
LbCodeFont class >> columnDoBlock [
	^ [ :aColumn | aColumn
        cellStencil: [
            BrLabel new
                look: (BrGlamorousLabelLook new
                			fontName: self defaultFamily) ];
        dataBinder: [ :eachLabel :eachText |  eachLabel text: eachText ] ]
]

{ #category : #accessing }
LbCodeFont class >> defaultFamily [
	^ 'Arial Unicode MS'
]

{ #category : #'as yet unclassified' }
LbCodeFont >> defaultFamily [ ^ 'JuliaMono'
]
