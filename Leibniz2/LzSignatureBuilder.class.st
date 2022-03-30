Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'varDeclarations',
		'opDeclarations',
		'sortGraph',
		'builtins',
		'signatureClass'
	],
	#category : #'Leibniz2-Signatures'
}

{ #category : #defining }
LzSignatureBuilder >> beSortSignatureBuilder [
	signatureClass := LzSortSignature
]

{ #category : #defining }
LzSignatureBuilder >> builtin: aSymbol [
	self assert:
		(#(integers
			rationalNumbers
			floatingPointNumbers
			strings) includes: aSymbol).
	builtins add: aSymbol 
]

{ #category : #defining }
LzSignatureBuilder >> include: aSignature [
	self parsedOps: aSignature opDeclarations.
	self parsedVars: aSignature varDeclarations.
	aSignature builtins do: [ :each | self builtin: each ]
]

{ #category : #initializing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	varDeclarations := OrderedCollection new.
	builtins := Set new.
	signatureClass := LzSignature
]

{ #category : #defining }
LzSignatureBuilder >> op: aString [
	opDeclarations add:
		(LzParser
			parse: aString
			startingAt: #opEnd
			yielding: LzASTOp).
]

{ #category : #defining }
LzSignatureBuilder >> parsedOps: aCollection [
	aCollection do: [ :each |
		opDeclarations addIfNotPresent: each ]
]

{ #category : #defining }
LzSignatureBuilder >> parsedVars: aCollection [
	aCollection do: [ :each |
		varDeclarations addIfNotPresent: each ]
]

{ #category : #building }
LzSignatureBuilder >> signature [
	| uniqueVars uniqueOps variables operators |
	uniqueOps := (opDeclarations collect: [ :each |
		each withoutVarDeclarations ]) asSet.
	uniqueVars := (varDeclarations,
		(opDeclarations flatCollect: [ :each | each varDeclarations ])) asSet.
	self flag: #todo.
	"Check for var declarations with sorts that are equal up to variable renaming."
	variables := (uniqueVars collect: [ :each |
		each name -> (self sortGraph parsedSort: each sort) ])
		asDictionary.
	operators :=
		LzOperators new
			sortGraph: self sortGraph;
			operators: uniqueOps.
	^ signatureClass new
		sortGraph: self sortGraph;
		builtins: builtins copy;
		operators: operators;
		variables: variables;
		opDeclarations: opDeclarations copy;
		varDeclarations: varDeclarations copy;
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

{ #category : #accessing }
LzSignatureBuilder >> var: aString [
	varDeclarations add:
		(LzParser
			parse: aString
			startingAt: #varEnd
			yielding: LzASTVar).
]
