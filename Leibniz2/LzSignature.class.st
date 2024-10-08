Class {
	#name : #LzSignature,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortGraph',
		'operators',
		'stateVars',
		'stateVarDeclarations',
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

{ #category : #copying }
LzSignature >> copy [
	^ self
]

{ #category : #copying }
LzSignature >> deepCopy [
	^ self
]

{ #category : #constructing }
LzSignature >> emptyBindings [
	^ LzBindings new
		sortGraph: self sortGraph
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
LzSignature >> gtStateVarsFor: aView [
	<gtView>
	stateVars isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'State vars';
		priority: 1;
		items: [ stateVars associations ] ;
		column: 'Name' text: [ :each | each key asLeibnizSyntax ];
		column: 'Sort' text: [ :each | each value asLeibnizSyntax ];
		yourself
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
		checkSteps;
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
		checkSteps;
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
		(LzDeclarationBuilder new acceptNode:
			(LzParser2
				parse: aString
				startingAt: LzParser2 startingStateForTopLevelTerm))
				declaration
]

{ #category : #constructing }
LzSignature >> programTerm:  steps [
	self assertBuiltin: #programs.
	^ LzProgramTerm new
		signature: self;
		steps: steps;
		checkSteps;
		computeSort;
		beRecursivelyReadOnlyObject.
]

{ #category : #constructing }
LzSignature >> programTerm:  steps variables: vars [
	| tempVars |
	tempVars := vars associationsSelect: [ :each |
		each key asSymbol beginsWith: LzConstants tempVarPrefix].
	tempVars ifEmpty: [ ^ self programTerm:  steps ].

	^ LzScopedProgramTerm new
		signature: self;
		tempVars: tempVars;
		steps: steps fromScope: nil;
		checkSteps;
		computeSort;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #constructing }
LzSignature >> rule: aString [
	^ self parsedRule:
		(LzDeclarationBuilder new acceptNode:
			(LzParser2
				parse: aString
				startingAt: LzParser2 startingStateForTopLevelRule))
				declaration
]

{ #category : #constructing }
LzSignature >> sort: aString [
	^ self sortGraph sort: aString
]

{ #category : #constructing }
LzSignature >> sortForVar: aVarName variables: aDictionary [
	^ aDictionary
		at: aVarName
		ifAbsent: [ self stateVars
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

{ #category : #accessing }
LzSignature >> stateVarDeclarations [
	^ stateVarDeclarations
]

{ #category : #accessing }
LzSignature >> stateVarDeclarations: anObject [
	stateVarDeclarations := anObject
]

{ #category : #accessing }
LzSignature >> stateVars [
	^ stateVars
]

{ #category : #accessing }
LzSignature >> stateVars: aDictionary [
	stateVars := aDictionary
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
		(LzDeclarationBuilder new acceptNode:
			(LzParser2
				parse: aString
				startingAt: LzParser2 startingStateForTopLevelTerm))
				declaration
]

{ #category : #accessing }
LzSignature >> valueSlots [
	^ #(sortGraph operators variables)
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
