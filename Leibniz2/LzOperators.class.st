Class {
	#name : #LzOperators,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'opTable'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzOperators >> addOp: anASTOpNode [
	| argSorts valueSort key op |
	argSorts := LzArity new: anASTOpNode args size.
	argSorts sortGraph: self sortGraph.
	1 to: argSorts size do: [ :index |
		argSorts at: index put:
			(self sortGraph
			parsedSortTerm: (anASTOpNode args at: index)
			variables: anASTOpNode variables) ].
	valueSort := self sortGraph
		parsedSortTerm: anASTOpNode sort
		variables: anASTOpNode variables.
	key := { anASTOpNode name. argSorts kindArity }.
	op := opTable at: key
			ifAbsentPut: [ LzOperator new 
								sortGraph: self sortGraph;
								opName: key first;
								kindArity: key second;
								kind: valueSort kind ].
	op addArity: argSorts sort: valueSort
]

{ #category : #defining }
LzOperators >> operators: aSetOfASTOpNodes [
	opTable := Dictionary new.
	aSetOfASTOpNodes do: [ :each |
		self addOp: each ]
]

{ #category : #lookup }
LzOperators >> sortForOp: anOpName args: anArity [
	^ (opTable at: { anOpName. anArity kindArity })
		sortForArity: anArity
]

{ #category : #accessing }
LzOperators >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzOperators >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]
