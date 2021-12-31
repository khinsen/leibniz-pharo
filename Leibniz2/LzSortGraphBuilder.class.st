Class {
	#name : #LzSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'sortDeclarations',
		'subsortDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #initializing }
LzSortGraphBuilder >> initialize [
	sortDeclarations := OrderedCollection new.
	subsortDeclarations := OrderedCollection new.
]

{ #category : #defining }
LzSortGraphBuilder >> sort: aString [
	sortDeclarations add:
		(LzParser
			parse: (aString, ' : ', LzConstants opNameSort)
			startingAt: #opEnd
			yielding: LzASTOpDeclaration).
]

{ #category : #building }
LzSortGraphBuilder >> sortGraph [
	| uniqueSorts sortContext |
	uniqueSorts := (sortDeclarations collect: [ :each |
		each withoutVarDeclarations ]) asSet.
	self assert: subsortDeclarations isEmpty.
	sortContext := uniqueSorts
		ifEmpty: [ LzSortHierarchyRoot uniqueInstance sortContext ]
		ifNotEmpty: [
			LzContextBuilder new
				sortContext: LzSortHierarchyRoot uniqueInstance sortContext;
				parsedOps: uniqueSorts;
				context ].
	^ LzSortGraph new
		sortContext: sortContext;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #defining }
LzSortGraphBuilder >> subsort: aString [
	subsortDeclarations add:
		(LzParser
			parse: aString
			startingAt: #subsortAxiomEnd
			yielding: LzASTSubsortAxiom).
]
