Class {
	#name : #LbListSort,
	#superclass : #LbCollectionSort,
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #sorting }
LbListSort class >> sortNamePrefix [
	^ '☰.'
]

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

{ #category : #accessing }
LbListSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #enumerating }
LbListSort >> subsorts [
	^ sortGraph subsortsOf: name
]
