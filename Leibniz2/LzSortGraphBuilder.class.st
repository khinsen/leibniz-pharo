Class {
	#name : #LzSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sortDeclarations',
		'subsortDeclarations',
		'sortContext',
		'sortContextInclusions'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #defining }
LzSortGraphBuilder >> clearCache [
	sortContext := nil
]

{ #category : #defining }
LzSortGraphBuilder >> include: aSortGraph [
	aSortGraph sortContext = LzSortHierarchyRoot uniqueInstance sortContext
		ifFalse: [ self includeSortContext: aSortGraph sortContext ].
	aSortGraph sortDeclarations do: [ :each |
		self parsedSortDeclaration: each ].
	aSortGraph subsortDeclarations do: [ :each |
		self parsedSubsortDeclaration: each ]
]

{ #category : #defining }
LzSortGraphBuilder >> includeSortContext: aContext [
	sortContextInclusions add: aContext
]

{ #category : #initializing }
LzSortGraphBuilder >> initialize [
	sortDeclarations := OrderedCollection new.
	subsortDeclarations := OrderedCollection new.
	sortContextInclusions := OrderedCollection new
]

{ #category : #defining }
LzSortGraphBuilder >> parsedSortDeclaration: anASTOp [
	self clearCache.
	sortDeclarations add: anASTOp.
]

{ #category : #defining }
LzSortGraphBuilder >> parsedSubsortDeclaration: anASTSubsortAxiom [
	self clearCache.
	subsortDeclarations add: anASTSubsortAxiom
]

{ #category : #defining }
LzSortGraphBuilder >> sort: aString [
	self parsedSortDeclaration: 
		(LzParser
			parse: (aString, ' : ', LzConstants opNameSort)
			startingAt: #opEnd
			yielding: LzASTOp).
]

{ #category : #accessing }
LzSortGraphBuilder >> sortContext [
	^ sortContext ifNil: [
		| uniqueSorts uniqueSubsorts |
		uniqueSorts := (sortDeclarations collect: [ :each |
			each withoutVarDeclarations ]) asSet.
		uniqueSubsorts := subsortDeclarations asSet.
		self flag: #todo. "Check for axioms that are equal up to variable names."
		sortContext := (uniqueSorts isEmpty
						and: [ uniqueSubsorts isEmpty
						and: [ sortContextInclusions isEmpty ] ])
			ifTrue: [ LzSortHierarchyRoot uniqueInstance sortContext ]
			ifFalse: [
				| builder |
				builder := LzContextBuilder new.
				sortContextInclusions do: [ :each |
					builder include: each ].
				builder
					op: LzConstants opNameSort, ' : ', LzConstants opNameSort;
					parsedOps: uniqueSorts;
					parsedAxioms: uniqueSubsorts.
				builder context ].
		sortContext ]
]

{ #category : #accessing }
LzSortGraphBuilder >> sortContext: aContext [
	self assert: sortDeclarations isEmpty.
	self assert: subsortDeclarations isEmpty.
	self assert: sortContextInclusions isEmpty.
	sortContext := aContext
]

{ #category : #building }
LzSortGraphBuilder >> sortGraph [
	^ LzSortGraph new
		sortContext: self sortContext;
		sortDeclarations: sortDeclarations copy;
		subsortDeclarations: subsortDeclarations copy;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #defining }
LzSortGraphBuilder >> subsort: aString [
	self parsedSubsortDeclaration:
		(LzParser
			parse: aString
			startingAt: #subsortAxiomEnd
			yielding: LzASTSubsortAxiom).
]
