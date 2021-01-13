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

{ #category : #copying }
LbDependentSortGraph >> copy [
	^ self
]

{ #category : #copying }
LbDependentSortGraph >> deepCopy [
	^ self
]

{ #category : #lookup }
LbDependentSortGraph >> directSupersortsOf: aSortTerm [
	^ context statements subsortStatements
		collect: [ :each | each supersortOf: aSortTerm ]
		thenSelect: #isNotNil
]

{ #category : #accessing }
LbDependentSortGraph >> includes: aSortTerm [
	self flag: #todo.
	^ true.
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
LbDependentSortGraph >> normalizedSortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: (context reduce: aSortTerm)
]

{ #category : #lookup }
LbDependentSortGraph >> parseSort: aString [
	^ self sortFor: (context parseTerm: aString)
]

{ #category : #accessing }
LbDependentSortGraph >> sortContext [
	^ context
]

{ #category : #accessing }
LbDependentSortGraph >> sortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: aSortTerm
]

{ #category : #lookup }
LbDependentSortGraph >> sortNamed: aSymbol [
	self flag: #legacy.
	^ self parseSort: aSymbol
]
