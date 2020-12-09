Class {
	#name : #LbPlainSort,
	#superclass : #LbSort,
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #comparing }
LbPlainSort >> <= aSort [
	| dss |
	self = aSort ifTrue: [ ^ true ].
	self sortGraph = aSort sortGraph ifFalse: [ ^ false ].
	dss := sortGraph directSubsortsOf: aSort name.
	(dss includes: self) ifTrue: [ ^ true ].
	dss do: [ :each |
		self <= each ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
LbPlainSort >> asSet [
	^ self subsorts
]

{ #category : #accessing }
LbPlainSort >> kind [
	^ sortGraph kindOf: name
]

{ #category : #enumerating }
LbPlainSort >> subsorts [
	^ sortGraph subsortsOf: name
]
