Class {
	#name : #LzSignature,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortGraph',
		'operators',
		'variables'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #inspecting }
LzSignature >> gtOperatorsFor: aView [
	<gtView>
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Operators' translated;
		priority: 0;
		object: [ operators ] ;
		view: #gtOperatorsFor:;
		yourself
]

{ #category : #accessing }
LzSignature >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 2;
		object: [ self sortGraph ];
		view: #gtGraphFor:
]

{ #category : #inspecting }
LzSignature >> gtVariablesFor: aView [
	<gtView>
	variables isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Variables' translated;
		priority: 1;
		items: [ variables associations
					sorted: [ :a :b | a key <= b key ]];
		send: [ :each |
			LbVariable
				named: each key
				sort: each value
				in: self
				origins: nil  ];
		column: 'Name' lzCode: [ :each |
			each key synopsis ];
		column: 'Sort' lzCode: [ :each |
			each value asLeibnizSyntaxString ];
		yourself
]

{ #category : #constructing }
LzSignature >> opTerm: anOpName args: anArrayOfTerms [
	| sort |
	sort := self operators
				sortForOp: anOpName
				args: (LzArity forArgs: anArrayOfTerms).
	anArrayOfTerms do: [ :each |
		self assert: each signature == self ].
	^ LzOpTerm new
		signature: self;
		opName: anOpName;
		args: anArrayOfTerms;
		sort: sort. 
]

{ #category : #accessing }
LzSignature >> operators [
	^ operators
]

{ #category : #accessing }
LzSignature >> operators: anObject [
	operators := anObject
]

{ #category : #constructing }
LzSignature >> parsedPattern: anASTPatternNode [
	^ self
		parsedTerm: anASTPatternNode term
		variables: (self parsedVariables: anASTPatternNode variables)
]

{ #category : #constructing }
LzSignature >> parsedTerm: anASTTermNode [
	^ self parsedTerm: anASTTermNode variables: Dictionary new
]

{ #category : #constructing }
LzSignature >> parsedTerm: anASTTermNode variables: aDictionary [
	(anASTTermNode isKindOf: LzASTOpTerm) ifTrue: [
		^ self
			opTerm: anASTTermNode opName
			args: (anASTTermNode args
					collect: [ :each |
						self parsedTerm: each variables: aDictionary ]) ].
	(anASTTermNode isKindOf: LzASTVarTerm) ifTrue: [
		^ self
			varTerm: anASTTermNode name
			variables: aDictionary ].
	self notYetImplemented
]

{ #category : #constructing }
LzSignature >> parsedVariables: anArrayOfASTVarDeclarationNodes [
	^ anArrayOfASTVarDeclarationNodes collect: [ :each |
		each name -> self sortGraph parsedSort: each sort ]
]

{ #category : #constructing }
LzSignature >> pattern: aString [
	^ self parsedPattern:
		(LzParser parse: aString startingAt: #termEnd yielding: LzASTPattern)
]

{ #category : #accessing }
LzSignature >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSignature >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #constructing }
LzSignature >> term: aString [
	^ self parsedTerm:
		(LzParser parse: aString startingAt: #termEnd yielding: LzASTTerm)
]

{ #category : #accessing }
LzSignature >> valueSlots [
	^ #(sortGraph operators variables)
]

{ #category : #constructing }
LzSignature >> varTerm: aVarName variables: aDictionary [
	| sort |
	sort := aDictionary at: aVarName
				ifAbsent: [ self variables at: aVarName ].
	^ LzVarTerm new
		signature: self;
		name: aVarName;
		sort: sort.
]

{ #category : #accessing }
LzSignature >> variables [
	^ variables
]

{ #category : #accessing }
LzSignature >> variables: aDictionary [
	variables := aDictionary
]
