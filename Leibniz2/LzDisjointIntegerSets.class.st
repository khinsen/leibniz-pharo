Class {
	#name : #LzDisjointIntegerSets,
	#superclass : #Object,
	#instVars : [
		'parents',
		'ranks'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzDisjointIntegerSets >> findRootFor: anInteger [
	| parent root |
	parent := parents at: anInteger.
	parent = anInteger
		ifTrue: [ ^ anInteger ].
	root := self findRootFor: parent.
	parents at: parent put: root.
	^ root
]

{ #category : #initializing }
LzDisjointIntegerSets >> initialize [
	parents := OrderedCollection new.
	ranks := OrderedCollection new.
]

{ #category : #testing }
LzDisjointIntegerSets >> is: anInteger inSameSetAs: otherInteger [
	^ (self findRootFor: anInteger) = (self findRootFor: otherInteger)
]

{ #category : #adding }
LzDisjointIntegerSets >> makeSet [
	| newInteger |
	newInteger := self size + 1.
	parents add: newInteger.
	ranks add: 0.
	^ newInteger.
]

{ #category : #merging }
LzDisjointIntegerSets >> merge: anInteger with: otherInteger [
	| root1 root2 rank1 |
	root1 := self findRootFor: anInteger.
	root2 := self findRootFor: otherInteger.
	root1 = root2 ifFalse: [
		(ranks at: root1)  < (ranks at: root2)
			ifTrue: [ | temp |
				temp := root1. root1 := root2. root2 := temp ].
	parents at: root2 put: root1.
	rank1 := ranks at: root1.
	rank1  = (ranks at: root2)
		ifTrue: [ ranks at: root1 put: rank1 + 1 ] ].
	^ root1
]

{ #category : #accessing }
LzDisjointIntegerSets >> size [
	^ parents size
]
