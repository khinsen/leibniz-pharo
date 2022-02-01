Class {
	#name : #LzSignature,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortGraph',
		'operators',
		'variables',
		'varDeclarations',
		'opDeclarations',
		'builtins'
	],
	#category : #'Leibniz2-Signatures'
}

{ #category : #accessing }
LzSignature >> builtins [
	^ builtins
]

{ #category : #accessing }
LzSignature >> builtins: aSet [
	builtins := aSet
]

{ #category : #inspecting }
LzSignature >> gtBuiltinsFor: aView [
	<gtView>
	self builtins ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Builtins' translated;
		priority: 4;
		items: [ self builtins asArray sorted ];
		yourself
]

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

{ #category : #accessing }
LzSignature >> opDeclarations [
	^ opDeclarations
]

{ #category : #accessing }
LzSignature >> opDeclarations: aCollection [
	opDeclarations := aCollection
]

{ #category : #constructing }
LzSignature >> opTerm: anOpName args: anArrayOfTerms [
	| sort |
	sort := self operators
				sortForOp: anOpName
				arity: (LzArity forArgs: anArrayOfTerms).
	anArrayOfTerms do: [ :each |
		self assert: each signature == self ].
	^ LzOpTerm new
		signature: self;
		opName: anOpName;
		args: anArrayOfTerms;
		sort: sort;
		beRecursivelyReadOnlyObject;
		yourself 
]

{ #category : #accessing }
LzSignature >> operators [
	^ operators
]

{ #category : #accessing }
LzSignature >> operators: anObject [
	operators := anObject
]

{ #category : #accessing }
LzSignature >> opsOfKind: aKind [
	^ self operators opsOfKind: aKind
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
	(anASTTermNode isKindOf: LzASTIntegerLiteral) ifTrue: [
		self assert: (builtins includes: #integers).
		^ LzIntegerTerm new
			signature:  self;
			value: anASTTermNode value;
			beRecursivelyReadOnlyObject;
			yourself ].
	self notYetImplemented
]

{ #category : #constructing }
LzSignature >> parsedVariables: anArrayOfASTVarDeclarationNodes [
	^ (anArrayOfASTVarDeclarationNodes collect: [ :each |
		each name -> (self sortGraph parsedSort: each sort) ])
		asDictionary
]

{ #category : #constructing }
LzSignature >> pattern: aString [
	^ self parsedPattern:
		(LzParser parse: aString startingAt: #patternEnd yielding: LzASTPattern)
]

{ #category : #constructing }
LzSignature >> sort: aString [
	^ self sortGraph sort: aString
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

{ #category : #accessing }
LzSignature >> varDeclarations [
	^ varDeclarations
]

{ #category : #accessing }
LzSignature >> varDeclarations: aCollection [
	varDeclarations := aCollection
]

{ #category : #constructing }
LzSignature >> varTerm: aVarName variables: aDictionary [
	| sort |
	sort := aDictionary at: aVarName
				ifAbsent: [ self variables at: aVarName
								ifAbsent: [ self error: 'No var named ', aVarName asSymbol ] ].
	^ LzVarTerm new
		signature: self;
		name: aVarName;
		sort: sort;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #accessing }
LzSignature >> variables [
	^ variables
]

{ #category : #accessing }
LzSignature >> variables: aDictionary [
	variables := aDictionary
]
