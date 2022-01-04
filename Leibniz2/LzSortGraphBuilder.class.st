Class {
	#name : #LzSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sortDeclarations',
		'subsortDeclarations',
		'sortContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzSortGraphBuilder >> clearCache [
	sortContext := nil
]

{ #category : #defining }
LzSortGraphBuilder >> include: aSortGraph [
	aSortGraph sortDeclarations do: [ :each |
		self parsedSortDeclaration: each ].
	aSortGraph subsortDeclarations do: [ :each |
		self parsedSubsortDeclaration: each ]
]

{ #category : #initializing }
LzSortGraphBuilder >> initialize [
	sortDeclarations := OrderedCollection new.
	subsortDeclarations := OrderedCollection new.
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
		| uniqueSorts |
		uniqueSorts := (sortDeclarations collect: [ :each |
			each withoutVarDeclarations ]) asSet.
		self flag: #todo.
		self assert: subsortDeclarations isEmpty. "For now..."

		sortContext := uniqueSorts
			ifEmpty: [ LzSortHierarchyRoot uniqueInstance sortContext ]
			ifNotEmpty: [
				LzContextBuilder new
					sortContext: LzSortHierarchyRoot uniqueInstance sortContext;
					parsedOps: uniqueSorts;
					context ].
		sortContext ]
]

{ #category : #accessing }
LzSortGraphBuilder >> sortContext: aContext [
	self assert: sortDeclarations isEmpty.
	self assert: subsortDeclarations isEmpty.
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
