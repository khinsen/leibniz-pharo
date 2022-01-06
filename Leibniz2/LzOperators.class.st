Class {
	#name : #LzOperators,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
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

{ #category : #accessing }
LzOperators >> gtOperatorsFor: aView [
	<gtView>
	| operators |
	opTable isEmpty ifTrue: [ ^ aView empty ].
	operators := Dictionary new.
	opTable keysAndValuesDo: [ :key :op |
		| opName |
		opName := key first.
		operators at: opName
			ifPresent: [ :opList | opList add: op ]
			ifAbsentPut: [ OrderedCollection with: op ] ].
	operators := operators associations
					sorted: [ :a :b | a key <= b key ].
	operators do: [ :each |
		each value sort: [ :a :b  |
					a kindArity size <= b kindArity size ] ].
	^ aView lzColumnedTree
		title: 'Operators' translated;
		priority: 0;
		items: [ operators ];
		children: [ :each |
			each isAssociation
				ifTrue: [ each value ]
				ifFalse: [ #() ] ];
		column: 'Kind arity' lzCode: [ :each |
			each isAssociation
				ifTrue: [ each key synopsis ]
				ifFalse: [ each opName printStringForArity: each kindArity ] ]
			weight: 0.5 ;
		column: 'Kind' lzCode: [ :each |
			each isAssociation
				ifTrue: [ '' ]
				ifFalse: [ each kind asLeibnizSyntaxString ]]
			weight: 0.3;
		column: 'Ranks' text: [ :each |
			each isAssociation
				ifTrue: [ '' ]
				ifFalse: [ each size ] ]
			weight: 0.2;
		expandItems: operators;
		yourself
]

{ #category : #testing }
LzOperators >> isEmpty [
	^ opTable isEmpty
]

{ #category : #defining }
LzOperators >> operators: aSetOfASTOpNodes [
	opTable := Dictionary new.
	aSetOfASTOpNodes do: [ :each |
		self addOp: each ]
]

{ #category : #accessing }
LzOperators >> opsOfKind: aKind [
	^ opTable values select: [ :each | each kind = aKind ]
]

{ #category : #accessing }
LzOperators >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #lookup }
LzOperators >> sortForOp: anOpName args: anArity [
	| key |
	key := { anOpName. anArity kindArity }.
	^ (opTable at: key
		ifAbsent: [ opTable keys do: [ :each |
						(KhEqualityExplorer for: key and: each) inspect ] ])
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

{ #category : #accessing }
LzOperators >> valueSlots [
	^ #(opTable)
]
