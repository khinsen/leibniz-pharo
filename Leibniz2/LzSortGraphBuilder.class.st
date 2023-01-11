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
		(LzSortDeclaration new
			op:(LzOpDeclaration new
				name: aSortTerm opName;
				args: #();
				variables: #()))
]

{ #category : #inspecting }
LzSortGraphBuilder >> gtSortDeclarationsFor: aView [
	<gtView>
	sortDeclarations ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Sort declarations';
		priority: 0;
		items: [ sortDeclarations ];
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #inspecting }
LzSortGraphBuilder >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 5;
		object: [ self sortGraph ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzSortGraphBuilder >> gtSubsortDeclarationsFor: aView [
	<gtView>
	subsortDeclarations ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Subsort declarations';
		priority: 1;
		items: [ subsortDeclarations ];
		itemText: #asLeibnizSyntax;
		yourself
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
LzSortGraphBuilder >> parsedSortDeclaration: aSortDeclaration [
	self clearCache.
	sortDeclarations add: aSortDeclaration.
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
		(LzSortDeclaration new
			op: (LzParser
				parse: (aString, ' : ', LzConstants opNameSort)
				startingAt: #opEnd
				yielding: LzOpDeclaration))
]

{ #category : #accessing }
LzSortGraphBuilder >> sortContext [
	^ sortContext ifNil: [
		| uniqueSorts uniqueSubsorts |
		uniqueSorts := (sortDeclarations collect: #op) asSet.
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
	| opName opDeclaration |
	opName := LzPrefixOpName for: LzConstants opNameSort.
	opDeclaration := LzOpDeclaration new
		name: opName;
		args: #();
		sort:  (LzOpTermDeclaration new
					opName: opName;
					args: #());
		variables: #().
	^ Set with: opDeclaration
]

{ #category : #defining }
LzSortGraphBuilder >> subsort: aString [
	self parsedSubsortDeclaration:
		(LzParser
			parse: aString
			startingAt: #subsortAxiomEnd
			yielding: LzSubsortAxiomDeclaration).
]
