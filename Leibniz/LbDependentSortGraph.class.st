Class {
	#name : #LbDependentSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'context',
		'sorts',
		'sortSort'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortGraph class >> sortContext: anLbContext [
	^ self basicNew
		initializeWithSortContext: anLbContext;
		yourself
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSorts [
	[ sortSort := context sortGraph sortNamed: #sort ]
		on: Error
		do: [ self error: 'No sorts in sort context.' ].
	self
		assert: (sortSort kind maximalSorts = (Set with: sortSort))
		description: 'Sort sort may not have supersorts'.
	sorts := context signature opsOfKind: sortSort kind.
]

{ #category : #initialization }
LbDependentSortGraph >> initializeWithSortContext: anLbContext [
	context := anLbContext.
	self initializeSorts.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbDependentSortGraph >> parseSort: aString [
	| sort |
	sort := context parseTerm: aString.
	self assert: sort sort <= sortSort.
	^ sort
]

{ #category : #accessing }
LbDependentSortGraph >> sortContext [
	^ context
]
