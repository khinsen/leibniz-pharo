Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'stateVarDeclarations',
		'opDeclarations',
		'sortGraph',
		'builtins'
	],
	#category : #'Leibniz2-Signatures'
}

{ #category : #defining }
LzSignatureBuilder >> builtin: aSymbol [
	self assert:
		(#(integers
			rationalNumbers
			floatingPointNumbers
			strings
			arrays
			programs
			termClasses) includes: aSymbol).
	builtins add: aSymbol 
]

{ #category : #inspecting }
LzSignatureBuilder >> gtBuildSignatureFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect the signature';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ :aButton |
			aButton phlow spawnObject:
				self signature ]
]

{ #category : #inspecting }
LzSignatureBuilder >> gtBuiltinsFor: aView [
	<gtView>
	builtins ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Builtins';
		priority: 3;
		items: [ builtins asArray sorted ] ;
		yourself
]

{ #category : #inspecting }
LzSignatureBuilder >> gtOperatorDeclarationsFor: aView [
	<gtView>
	opDeclarations ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Operator declarations';
		priority: 1;
		items: [ opDeclarations asSet asArray ] ;
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #accessing }
LzSignatureBuilder >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ sortGraph ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzSignatureBuilder >> gtStateVarDeclarationsFor: aView [
	<gtView>
	stateVarDeclarations ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'State var declarations';
		priority: 2;
		items: [ stateVarDeclarations asSet asArray ] ;
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #defining }
LzSignatureBuilder >> include: aSignature [
	self parsedOps: aSignature opDeclarations.
	self parsedStateVars: aSignature stateVarDeclarations.
	aSignature builtins do: [ :each | self builtin: each ]
]

{ #category : #accessing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	stateVarDeclarations := OrderedCollection new.
	builtins := Set new
]

{ #category : #defining }
LzSignatureBuilder >> op: aString [
	opDeclarations add:
		(LzDeclarationBuilder new acceptNode:
		(LzParser2
			parse: aString
			startingAt: LzParser2 startingStateForTopLevelOp))
			declaration
]

{ #category : #defining }
LzSignatureBuilder >> parsedOps: aCollection [
	aCollection do: [ :each |
		opDeclarations addIfNotPresent: each ]
]

{ #category : #defining }
LzSignatureBuilder >> parsedStateVars: aCollection [
	aCollection do: [ :each |
		stateVarDeclarations addIfNotPresent: each ]
]

{ #category : #building }
LzSignatureBuilder >> signature [
	| uniqueOps uniqueVars stateVars operators |
	uniqueOps := opDeclarations asSet.
	self flag: #todo. "Signature-level vars removed in a test phase."
	uniqueVars := stateVarDeclarations asSet.
	self flag: #todo.
	"Check for var declarations with sorts that are equal up to variable renaming."
	stateVars := (uniqueVars collect: [ :each |
		each name -> (self sortGraph parsedSort: each sort) ])
		asDictionary.
	operators :=
		LzOperators new
			sortGraph: self sortGraph;
			operators: uniqueOps.
	^ LzSignature new
		sortGraph: self sortGraph;
		builtins: builtins copy;
		operators: operators;
		stateVars: stateVars;
		opDeclarations: opDeclarations copy;
		stateVarDeclarations: stateVarDeclarations copy;
		beRecursivelyReadOnlyObject;
		yourself.
]

{ #category : #accessing }
LzSignatureBuilder >> sortGraph [
	^ sortGraph
]

{ #category : #initializing }
LzSignatureBuilder >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #defining }
LzSignatureBuilder >> stateVar: aString [
	stateVarDeclarations add:
		(LzDeclarationBuilder new acceptNode:
			(LzParser2
				parse: aString
				startingAt: LzParser2 startingStateForTopLevelState))
				declaration
]
