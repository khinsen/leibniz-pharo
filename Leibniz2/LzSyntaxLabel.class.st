Class {
	#name : #LzSyntaxLabel,
	#superclass : #Object,
	#instVars : [
		'declaration',
		'object',
		'segments',
		'size'
	],
	#category : #'Leibniz2-Rendering'
}

{ #category : #'instance creation' }
LzSyntaxLabel class >> for: aLzPrintable [
	^ self for: aLzPrintable color: Color black
]

{ #category : #'instance creation' }
LzSyntaxLabel class >> for: aLzPrintable color: aColor [
	^ self new
		text: (aLzPrintable asRopedTextColored: aColor);
		yourself
]

{ #category : #converting }
LzSyntaxLabel >> asElement [
	| baselines topOffset bottomOffset element |
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
    		margin: (each marginsForTop: topOffset bottom: bottomOffset) ) ].
    element when: BlClickEvent
        do: [ :anEvent |
        	| objectToSpawn |
        	objectToSpawn := (self object isNil or: [ anEvent modifiers isPrimaryModifier ])
        		ifTrue: [ self declaration ]
        		ifFalse: [ self object ].
        	objectToSpawn ifNotNil: [ anEvent target phlow spawnObject: objectToSpawn ] ].
       size ifNotNil: [ element childrenDo: size ].
      ^ element
]

{ #category : #accessing }
LzSyntaxLabel >> beNormalSize [
	size := #beNormalSize
]

{ #category : #accessing }
LzSyntaxLabel >> beSmallSize [
	size := #beSmallSize
]

{ #category : #accessing }
LzSyntaxLabel >> declaration [
	^ declaration
]

{ #category : #accessing }
LzSyntaxLabel >> declaration: anLzDeclaration [
	declaration := anLzDeclaration
]

{ #category : #accessing }
LzSyntaxLabel >> object [
	^ object
]

{ #category : #accessing }
LzSyntaxLabel >> object: aLeibnizObject [
	object := aLeibnizObject
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
		(newState ~= state or: [ index = aText size ]) ifTrue: [
			segments add: (LzSyntaxLabelSegment new
				text: (aText from: segmentIndex to: index - 1)).
			segmentIndex := index + 1.
			state := newState ] ].
	^ segments
]

{ #category : #accessing }
LzSyntaxLabel >> text: aText [
    segments := self segmentsFor: aText
]
