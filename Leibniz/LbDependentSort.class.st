Class {
	#name : #LbDependentSort,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'term'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSort class >> term: aTerm [
	^ self basicNew
		initializeWithTerm: aTerm;
		yourself
]

{ #category : #initialization }
LbDependentSort >> initializeWithTerm: aTerm [
	term := aTerm.
	self beRecursivelyReadOnlyObject
]
