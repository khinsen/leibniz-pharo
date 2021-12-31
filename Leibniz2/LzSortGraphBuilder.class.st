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
