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
LzSortGraphBuilder >> deriveSortDeclarationFromSort: aSortTerm [
	aSortTerm args ifNotEmpty: [ ^ self ].
	self parsedSortDeclaration: 
		(LzASTOp new
			name: aSortTerm opName;
			args: #();
			sort: (LzASTOpTerm new
						opName: (LzPrefixOpName for: LzConstants opNameSort);
						args: #());
			variables: #())
]

{ #category : #defining }
LzSortGraphBuilder >> include: aSortGraph [
	aSortGraph sortDeclarations do: [ :each |
		self parsedSortDeclaration: each ].
	aSortGraph subsortDeclarations do: [ :each |
		self parsedSubsortDeclaration: each ]
]

{ #category : #defining }
LzSortGraphBuilder >> includeSortContext: aContext [
	sortContextInclusions addIfNotPresent: aContext
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
	subsortDeclarations add: anASTSubsortAxiom.
	anASTSubsortAxiom variables ifEmpty: [
		self deriveSortDeclarationFromSort: anASTSubsortAxiom subsort.
		self deriveSortDeclarationFromSort: anASTSubsortAxiom supersort ]
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
		sortContext := (uniqueSubsorts isEmpty
						and: [ (uniqueSorts isEmpty
								or: [ uniqueSorts = self sortSortDeclaration ])
						and: [ sortContextInclusions = self sortContextInclusion] ])
			ifTrue: [ LzSortHierarchyRoot uniqueInstance sortContext ]
			ifFalse: [
				| builder |
				builder := LzContextBuilder new.
				builder includeSortContext: LzSortHierarchyRoot uniqueInstance sortContext.
				sortContextInclusions do: [ :each |
					builder include: each ].
				builder
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

{ #category : #accessing }
LzSortGraphBuilder >> sortContextInclusion [
	^ OrderedCollection with: LzSortHierarchyRoot uniqueInstance sortContext
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

{ #category : #accessing }
LzSortGraphBuilder >> sortSortDeclaration [
	| opName astOp |
	opName := LzPrefixOpName for: LzConstants opNameSort.
	astOp := LzASTOp new
		name: opName;
		args: #();
		sort:  (LzASTOpTerm new
					opName: opName;
					args: #());
		variables: OrderedCollection new.
	^ Set with: astOp
]

{ #category : #defining }
LzSortGraphBuilder >> subsort: aString [
	self parsedSubsortDeclaration:
		(LzParser
			parse: aString
			startingAt: #subsortAxiomEnd
			yielding: LzASTSubsortAxiom).
]
