Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'varDeclarations',
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
			arrays) includes: aSymbol).
	builtins add: aSymbol 
]

{ #category : #defining }
LzSignatureBuilder >> include: aSignature [
	self parsedOps: aSignature opDeclarations.
	self parsedVars: aSignature varDeclarations.
	aSignature builtins do: [ :each | self builtin: each ]
]

{ #category : #accessing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	varDeclarations := OrderedCollection new.
	builtins := Set new
]

{ #category : #defining }
LzSignatureBuilder >> op: aString [
	opDeclarations add:
		(LzParser
			parse: aString
			startingAt: #opEnd
			yielding: LzOpDeclaration).
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
	^ LzSignature new
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
	self flag: #todo.
	"Signature-level vars are the reason why var-containing terms were not allowed
	in the rhs of match: in the past. They do not seem very important in practice so
	far. Current experiment: allow vars in matches, but don't allow signature-level vars."
	self shouldNotImplement.
	varDeclarations add:
		(LzParser
			parse: aString
			startingAt: #varEnd
			yielding: LzVarDeclaration).
]
