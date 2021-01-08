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

{ #category : #printing }
LbDependentSort >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LbDependentSort >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LbDependentSort >> term [
	^ term
]
