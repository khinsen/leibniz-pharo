Class {
	#name : #LbDependentSort,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'term',
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSort class >> sortGraph: aSortGraph term: aTerm [
	^ self basicNew
		initializeWithSortGraph: aSortGraph term: aTerm;
		yourself
]

{ #category : #converting }
LbDependentSort >> asLeibnizSyntaxString [
	^ term asLeibnizSyntaxString
]

{ #category : #lookup }
LbDependentSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
]

{ #category : #testing }
LbDependentSort >> includes: aSort [
	self flag: #todo.
	^ true
]

{ #category : #initialization }
LbDependentSort >> initializeWithSortGraph: aSortGraph term: aTerm [
	sortGraph := aSortGraph.
	term := aTerm.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbDependentSort >> kind [
	self flag: #todo.
	^ self
]

{ #category : #matching }
LbDependentSort >> match: aSort [
	^ self term match: aSort term
]

{ #category : #printing }
LbDependentSort >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #printing }
LbDependentSort >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LbDependentSort >> sortGraph [
	^ sortGraph
]

{ #category : #matching }
LbDependentSort >> substitute: aSubstitution [
	^ sortGraph sortFor: (term substitute: aSubstitution)
]

{ #category : #matching }
LbDependentSort >> substituteAndReduce: aSubstitution [
	^ sortGraph normalizedSortFor: (term substitute: aSubstitution)
]

{ #category : #accessing }
LbDependentSort >> term [
	^ term
]
