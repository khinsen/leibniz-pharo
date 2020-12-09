Class {
	#name : #LbListSort,
	#superclass : #LbSort,
	#instVars : [
		'baseSort'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #comparing }
LbListSort >> <= aSort [
	| dss |
	self = aSort ifTrue: [ ^ true ].
	self sortGraph = aSort sortGraph ifFalse: [ ^ false ].
	dss := sortGraph directSubsortsOf: aSort name.
	(dss includes: self) ifTrue: [ ^ true ].
	dss do: [ :each |
		self <= each ifTrue: [ ^ true ] ].
	^ false.
]

{ #category : #accessing }
LbListSort >> asSet [
	^ self subsorts
]

{ #category : #initialization }
LbListSort >> initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet [
	super initializeWithName: aSymbol sortGraph: aSortGraph origins: aSet.
	baseSort := sortGraph sortNamed: (aSymbol allButFirst: 2)
]

{ #category : #accessing }
LbListSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #enumerating }
LbListSort >> subsorts [
	^ sortGraph subsortsOf: name
]
