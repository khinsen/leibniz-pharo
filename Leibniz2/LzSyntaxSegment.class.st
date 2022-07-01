Class {
	#name : #LzSyntaxSegment,
	#superclass : #Object,
	#instVars : [
		'text',
		'baseline'
	],
	#category : #'Leibniz2-Rendering'
}

{ #category : #accessing }
LzSyntaxSegment >> baseline [
	^ baseline
]

{ #category : #rendering }
LzSyntaxSegment >> marginsForTop: topMargin bottom: bottomMargin [
	^ BlInsets
		top: (baseline = LzSuperscriptAttribute ifTrue: [ 0 ] ifFalse: [ topMargin ])
		left: 0
		bottom: (baseline = LzSubscriptAttribute ifTrue: [ 0 ] ifFalse: [ bottomMargin ])
		right: 0
]

{ #category : #accessing }
LzSyntaxSegment >> text [
	^ text
]

{ #category : #accessing }
LzSyntaxSegment >> text: aText [
	text := aText.
	baseline := (text attributesAt: 1)
		detect: [ :each | each isKindOf: LzBaselineAttribute ]
		ifFound: [ :each | each class ]
		ifNone: [ nil ]
]
