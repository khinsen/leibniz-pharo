Class {
	#name : #LbDependentSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sameKindSorts',
		'directSubsorts',
		'sortContextBuilder',
		'sortContext',
		'sorts',
		'subsortAxioms'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #adding }
LbDependentSortGraphBuilder >> addSortContext: aContext [
	sortContextBuilder include: aContext mode: #extend
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> addSubsortRelation: aSubsortAxiom [
	| subsort supersort |
	aSubsortAxiom subsort = aSubsortAxiom supersort
		ifTrue: [ ^ self ].

	subsort := self findSortForTerm: aSubsortAxiom subsort.
	supersort := self findSortForTerm: aSubsortAxiom supersort.

	(self is: supersort subsortOf: subsort)
		ifTrue: [
			self error: 'cycle in subsort relation: ',
					(supersort printString), '<=', (subsort printString ) ].

	((directSubsorts at: supersort) includes: subsort)
		ifFalse: [
			| newKind |
			newKind := (sameKindSorts at: subsort) union: (sameKindSorts at: supersort).
			newKind do: [ :sort | sameKindSorts at: sort put: newKind ].
			(directSubsorts at: supersort) add: subsort ].

	(subsortAxioms at: { subsort. supersort } ifAbsentPut: [ OrderedCollection new ])
		add: aSubsortAxiom
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> buildSortContext [
	sortContext := sortContextBuilder context.
	self initializeSorts.
	self initializeSubsorts.
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> checkIf: subsort canBeMadeSubsortOf: supersort [
	self halt
]

{ #category : #private }
LbDependentSortGraphBuilder >> findSortForTerm: aTerm [
	| sortOp |
	sortOp := sortContext signature
		opNamed: aTerm opName
		withArgs: (aTerm arguments collect: #sort).
	self assert: (sorts includes: sortOp).
	^ sortOp
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> initialize [
	sameKindSorts := Dictionary new.
	directSubsorts := Dictionary new.
	sorts := Set new.
	subsortAxioms := Dictionary new.
	self initializeSortContextBuilder
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> initializeSortContextBuilder [
	sortContextBuilder := LbContextBuilder name: 'sorts'.
	"sortContextBuilder parseAndAddSort: 'sort'."
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> initializeSorts [
	| sortSort |
	[ sortSort := sortContext sortGraph sortNamed: #sort ]
		on: Error
		do: [ self error: 'No sorts in sort context.' ].
	self
		assert: (sortSort kind maximalSorts = (Set with: sortSort))
		description: 'Sort sort may not have supersorts'.
	sorts := sortContext signature opsOfKind: sortSort kind.
	sorts do: [ :each |
		self assert: each size equals: 1 ]
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> initializeSubsorts [
	sorts do: [ :each |
		directSubsorts at: each put: Set new.
		sameKindSorts at: each put: Set new ].
	sortContext axioms subsortAxioms do: [ :each |
		self addSubsortRelation: each ]
]

{ #category : #initializing }
LbDependentSortGraphBuilder >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort) or: [
		ss := directSubsorts at: anotherSort.
		(ss includes: aSort) or: [
			ss anySatisfy: [:each |
				self is: aSort subsortOf: each ] ] ]
]

{ #category : #accessing }
LbDependentSortGraphBuilder >> sortGraph [
	self buildSortContext.
	^ LbDependentSortGraph sortContext: sortContext directSubsorts: directSubsorts subsortAxioms: subsortAxioms
]
