Class {
	#name : #LzSyntaxLabel,
	#superclass : #Object,
	#instVars : [
		'element'
	],
	#category : #'Leibniz2-Rendering'
}

{ #category : #converting }
LzSyntaxLabel >> asElement [
	^ element
]

{ #category : #rendering }
LzSyntaxLabel >> segmentsFor: aText [
	| segments state segmentIndex |
	segments := OrderedCollection new.
	state := nil.
	segmentIndex := 1.
	aText attributesDo: [ :attrs :index |
		| newState |
		newState := attrs
			detect: [ :each | each isKindOf: LzBaselineAttribute ]
			ifNone: [ nil ].
		newState = state ifFalse: [
			segments add: (LzSyntaxSegment new
				text: (aText from: segmentIndex to: index)).
			segmentIndex := index + 1.
			state := newState ] ].
	^ segments
]

{ #category : #accessing }
LzSyntaxLabel >> text: aText [
	| segments baselines topOffset bottomOffset |
    segments := self segmentsFor: aText.
    baselines := (segments collect: #baseline) asSet.
	topOffset := (baselines includes: LzSuperscriptAttribute)
						ifTrue: [ 5 ] ifFalse: [ 0 ].
	bottomOffset := (baselines includes: LzSubscriptAttribute)
						ifTrue: [ 5 ] ifFalse: [ 0 ].
	element := BrHorizontalPane new 
 	   alignCenter;
    	fitContent.
    segments do: [ :each |
    	element addChild: (BrLabel new
    		text: each text;
    		aptitude: BrGlamorousLabelAptitude;
    		margin: (each marginsForTop: topOffset bottom: bottomOffset) ) ]
]
