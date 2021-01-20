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
LbDependentSortGraph class >> sortContext: aContext directSubsorts: aSubsortDictionary subsortAxioms: anAxiomDictionary [
	^ self basicNew
		initializeWithSortContext: aContext
		directSubsorts: aSubsortDictionary
		subsortAxioms: anAxiomDictionary;
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
	| supersorts |
	supersorts := Set new.
	context axioms subsortAxioms do: [ :each |
		(each supersortOf: aSortTerm)
			ifNotNil: [ :term | supersorts add: (self sortFor: term) ] ].
	^ supersorts
]

{ #category : #accessing }
LbDependentSortGraph >> includes: aSortTerm [
	self flag: #todo.
	^ true.
]

{ #category : #initialization }
LbDependentSortGraph >> initializeWithSortContext: anLbContext directSubsorts: aSubsortDictionary subsortAxioms: anAxiomDictionary [
	context := anLbContext.
	sorts := aSubsortDictionary keys.
	sortSort := context sortGraph sortNamed: #sort.
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
