Class {
	#name : #LzOperators,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortGraph',
		'opTable'
	],
	#category : #'Leibniz2-Signatures'
}

{ #category : #defining }
LzOperators >> addOp: anASTOpNode [
	| opParams argSorts valueSort key op |
	opParams := self preprocessOp: anASTOpNode.
	argSorts := opParams second.
	valueSort := opParams third.
	key := { opParams first. argSorts kindArity }.
	op := opTable at: key
			ifAbsentPut: [ LzOperator new 
								sortGraph: self sortGraph;
								opName: key first;
								kindArity: key second;
								kind: valueSort kind ].
	op addArity: argSorts sort: valueSort
]

{ #category : #defining }
LzOperators >> findOp: anASTOpNode [
	| opParams |
	opParams := self preprocessOp: anASTOpNode.
	^ opTable at: { opParams first. opParams second kindArity }
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

{ #category : #failing }
LzOperators >> noMatchFor: aKey [
	| message |
	message := String streamContents: [ :s |
		s << 'No op matching '.
		aKey first printForArity:  aKey second on: s ].
	self error: message
]

{ #category : #lookup }
LzOperators >> opForTerm: aTerm [
	^ self
		opNamed: aTerm opName
		arity: aTerm arity
]

{ #category : #lookup }
LzOperators >> opNamed: anOpName arity: anArity [
	| key kindArity message |
	anArity ifEmpty: [
		key := { anOpName. anArity }.
		opTable at: key
			ifPresent: [ :op | ^ op ]
			ifAbsent: [ self noMatchFor: key ] ].
	kindArity := anArity kindArity .
	#(false true) asDigitsToPower: kindArity size do: [ :eachSelection |
		| candidate |
		candidate := kindArity copy.
		1 to: kindArity size do: [ :index |
			(eachSelection at: index) ifTrue: [
				candidate at: index put: self sortGraph anySortKind ] ].
		key := { anOpName. candidate }.
		opTable at: key ifPresent: [ :op | ^ op ] ].
	self noMatchFor: key.
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

{ #category : #defining }
LzOperators >> preprocessOp: anASTOpNode [
	| vars argSorts valueSort key op |
	vars := self sortGraph sortContext signature
				parsedVariables: anASTOpNode variables.
	argSorts := LzArity new: anASTOpNode args size.
	1 to: argSorts size do: [ :index |
		argSorts at: index put:
			(self sortGraph
			parsedSort: (anASTOpNode args at: index)
			variables: vars) ].
	valueSort := self sortGraph
		parsedSort: anASTOpNode sort
		variables: vars.
	^ { anASTOpNode name. argSorts. valueSort }
]

{ #category : #accessing }
LzOperators >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #lookup }
LzOperators >> sortForOp: anOpName arity: anArity [
	^ (self opNamed: anOpName arity: anArity)
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
