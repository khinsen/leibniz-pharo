Class {
	#name : #LzSyntaxLabelSegment,
	#superclass : #Object,
	#instVars : [
		'text',
		'baseline'
	],
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzSyntaxLabelSegment >> baseline [
	^ baseline
]

{ #category : #rendering }
LzSyntaxLabelSegment >> marginsForTop: topMargin bottom: bottomMargin [
	^ BlInsets
		top: (baseline = LzSuperscriptAttribute ifTrue: [ 0 ] ifFalse: [ topMargin ])
		left: 0
		bottom: (baseline = LzSubscriptAttribute ifTrue: [ 0 ] ifFalse: [ bottomMargin ])
		right: 0
]

{ #category : #printing }
LzSyntaxLabelSegment >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< self text asString;
		<< $'.
	baseline ifNotNil: [
		aStream
			<< ', ';
			<< baseline printString].
	aStream
		<< ')'
]

{ #category : #accessing }
LzSyntaxLabelSegment >> text [
	^ text
]

{ #category : #accessing }
LzSyntaxLabelSegment >> text: aText [
	baseline := (aText attributesAt: 1)
		detect: [ :each | each isKindOf: LzBaselineAttribute ]
		ifFound: [ :each | each class ]
		ifNone: [ nil ].
	text := '' asRopedText.
	aText attributesDo: [ :attrs :index |
		attrs
			detect: [ :each | each isKindOf: LzDoNotRenderAttribute ]
			ifNone: [ text append: (aText copyFrom: index +1 to: index + 1)  ] ].
	text fontName: LzCodeFont defaultFamily
]
