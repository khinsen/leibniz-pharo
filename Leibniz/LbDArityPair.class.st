Class {
	#name : #LbDArityPair,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'arity1',
		'arity2'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDArityPair class >> arity1: arity1 arity2: arity2 [
	^ self basicNew
		initializeWithArity1: arity1 arity2: arity2;
		yourself
]

{ #category : #initialization }
LbDArityPair >> initializeWithArity1: anArity arity2: anotherArity [
	sortGraph := anArity sortGraph.
	self assert: sortGraph equals: anotherArity sortGraph.
	arity1 := anArity.
	arity2 := anotherArity.
]
