Class {
	#name : #LzSignatureBuilder,
	#superclass : #Object,
	#instVars : [
		'varDeclarations',
		'opDeclarations',
		'sortGraph'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzSignatureBuilder >> include: aSignature [
	self parsedOps: aSignature opDeclarations.
	self parsedVars: aSignature varDeclarations
]

{ #category : #accessing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	varDeclarations := OrderedCollection new.
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
	opDeclarations addAll: aCollection
]

{ #category : #defining }
LzSignatureBuilder >> parsedVars: aCollection [
	varDeclarations addAll: aCollection
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
