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

{ #category : #testing }
LzSignature >> assertBuiltin: aSymbol [
	self assert: (builtins includes: aSymbol)
]

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

{ #category : #constructing }
LzSignature >> literalTerm:  anObject class: aLiteralTermClass builtin: aSymbol [
	self assertBuiltin: aSymbol.
	^ aLiteralTermClass
		signature: self
		value: anObject
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
LzSignature >> parsedAxiom: anASTAxiomNode [
	^ anASTAxiomNode axiomClass new
		signature: self;
		variables: (self parsedVariables: anASTAxiomNode variables);
		buildTermsFrom: anASTAxiomNode terms;
		checkConsistency;
		beRecursivelyReadOnlyObject
]

{ #category : #constructing }
LzSignature >> parsedPattern: anASTPatternNode [
	^ anASTPatternNode
		buildFor: self
]

{ #category : #constructing }
LzSignature >> parsedRule: anASTRuleNode [
	^ anASTRuleNode ruleClass new
		signature: self;
		variables: (self parsedVariables: anASTRuleNode variables);
		buildTermsFrom: anASTRuleNode;
		checkConsistency;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #constructing }
LzSignature >> parsedTerm: anASTTermNode [
	^ anASTTermNode buildFor: self variables: Dictionary new
]

{ #category : #constructing }
LzSignature >> parsedTerm: anASTTermNode variables: aDictionary [
	^ anASTTermNode buildFor: self variables: aDictionary.
]

{ #category : #constructing }
LzSignature >> parsedVariables: anArrayOfASTVarDeclarationNodes [
	| noVariables termVariables sortVariables |
	noVariables := Dictionary new.
	sortVariables := (anArrayOfASTVarDeclarationNodes
		select: [ :each | each isSortVar ]
		thenCollect: [ :each |
			each name -> (self sortGraph sortContext sortGraph
							parsedSort: each sort variables: noVariables) ])
		asDictionary.
	termVariables := (anArrayOfASTVarDeclarationNodes
		select: [ :each | each isSortVar not ]
		thenCollect: [ :each |
			each name -> (self sortGraph
							parsedSort: each sort variables: sortVariables) ])
		asDictionary.
	^ termVariables
]

{ #category : #constructing }
LzSignature >> pattern: aString [
	^ self parsedPattern:
		(LzParser parse: aString startingAt: #patternEnd yielding: LzASTPattern)
]

{ #category : #constructing }
LzSignature >> rule: aString [
	^ self parsedRule:
		(LzParser parse: aString startingAt: #ruleEnd yielding: LzASTRule)
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
