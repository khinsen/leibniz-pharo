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

{ #category : #constructing }
LzSignature >> arrayTerm:  elements shape: shape [
	| sorts elementSort arraySort |
	self assertBuiltin: #arrays.
	elements
		ifEmpty: [ elementSort := nil ]
		ifNotEmpty: [
			sorts := (elements collect: #sort) asSet asArray.
			(sorts collect: #kind) asSet size > 1
				ifTrue: [ self error: 'Array elements must be of same kind' ].
			elementSort :=
				sorts size = 1
					ifTrue: [ sorts first ]
					ifFalse: [ sorts allButFirst
						inject: sorts first
						into: [ :total :each |
								total leastCommonSupersortWith: each ] ] ].
	arraySort := sortGraph arraySortFor: elementSort shape: shape.
	^ LzArrayTerm new
		signature: self;
		elements: elements;
		shape: shape;
		sort: arraySort;
		beRecursivelyReadOnlyObject
]

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

{ #category : #constructing }
LzSignature >> compoundStepTerm:  steps [
	self assertBuiltin: #steps.
	^ LzCompoundStepTerm new
		signature: self;
		steps: steps;
		checkConsistency;
		computeSort;
		beRecursivelyReadOnlyObject.
]

{ #category : #copying }
LzSignature >> copy [
	^ self
]

{ #category : #copying }
LzSignature >> deepCopy [
	^ self
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

{ #category : #constructing }
LzSignature >> indexArrayTerm: anIntegerTerm [
	| elements length |
	length := anIntegerTerm value.
	elements := Array new: length.
	1 to: length do: [ :index |
		| element |
		element := self integerTerm: index.
		elements at: index put: element ].
	^ self arrayTerm: elements shape: { length }
]

{ #category : #constructing }
LzSignature >> integerTerm: anInteger [
	^ self
		literalTerm: anInteger
		class: LzIntegerTerm
		builtin: #integers
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
LzSignature >> parsedAxiom: anAxiomDeclaration [
	^ anAxiomDeclaration axiomClass new
		signature: self;
		variables: (self parsedVariables: anAxiomDeclaration variables);
		buildTermsFrom: anAxiomDeclaration terms;
		label: anAxiomDeclaration label;
		checkConsistency;
		beRecursivelyReadOnlyObject
]

{ #category : #constructing }
LzSignature >> parsedPattern: anASTPatternNode [
	^ anASTPatternNode
		buildFor: self
]

{ #category : #constructing }
LzSignature >> parsedRule: aRuleDeclaration [
	^ aRuleDeclaration ruleClass new
		signature: self;
		variables: (self parsedVariables: aRuleDeclaration variables);
		buildTermsFrom: aRuleDeclaration;
		label: aRuleDeclaration label;
		order: aRuleDeclaration order;
		checkConsistency;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #constructing }
LzSignature >> parsedTerm: anASTTermNode [
	^ anASTTermNode buildFor: self
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
		(LzParser parse: aString startingAt: #patternEnd yielding: LzPatternDeclaration)
]

{ #category : #constructing }
LzSignature >> rule: aString [
	^ self parsedRule:
		(LzParser parse: aString startingAt: #ruleEnd yielding: LzRuleDeclaration)
]

{ #category : #constructing }
LzSignature >> sort: aString [
	^ self sortGraph sort: aString
]

{ #category : #constructing }
LzSignature >> sortForVar: aVarName variables: aDictionary [
	^ aDictionary
		at: aVarName
		ifAbsent: [ self variables
						at: aVarName
						ifAbsent: [ self error: 'No var named ', aVarName asSymbol ] ]
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
LzSignature >> stringTerm: aString [
	^ self 
		literalTerm:  aString
		class: LzStringTerm
		builtin: #strings
]

{ #category : #constructing }
LzSignature >> term: aString [
	^ self parsedTerm:
		(LzParser parse: aString startingAt: #termEnd yielding: LzTermDeclaration)
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
	^ LzVarTerm new
		signature: self;
		name: aVarName;
		sort: (self sortForVar: aVarName variables: aDictionary);
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
