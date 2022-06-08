Class {
	#name : #LbGraphicsElements,
	#superclass : #Object,
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : #'graph drawing' }
LbGraphicsElements class >> graphArrow [
	^ self graphArrowWithColor: Color gray
]

{ #category : #'graph drawing' }
LbGraphicsElements class >> graphArrowWithColor: aColor [
	^ BlLineElement new
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: aColor width: 1));
		border: (BlBorder paint: aColor width: 1)
]

{ #category : #'graph drawing' }
LbGraphicsElements class >> graphNodeLabelled: aString highlight: aBoolean [
	| text color label rectangle |
	color := Color black.
	text := aString asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	text foreground: color.
	label := BlTextElement new text: text.

	aBoolean ifFalse: [
	 ^ label
		padding: (BlInsets all: 3);
		yourself ].

	rectangle := BlElement new
		background: color;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets all: 3);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	text foreground: Color white.
	rectangle addChild: label.
	^ rectangle
]

{ #category : #'graph drawing' }
LbGraphicsElements class >> graphNodeLabelled: aString highlightColor: aColorOrNil [
	| text label rectangle |
	text := aString asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	text foreground: Color black.
	label := BlTextElement new text: text.

	aColorOrNil ifNil: [
	 ^ label
		padding: (BlInsets all: 3);
		yourself ].

	rectangle := BlElement new
		background: aColorOrNil;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets all: 3);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	text foreground: Color white.
	rectangle addChild: label.
	label userData at: #graph put: rectangle graph.
	^ rectangle
]
