Class {
	#name : #LzSortTermBuilder,
	#superclass : #Object,
	#instVars : [
		'signature',
		'clientSortGraph'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #accessing }
LzSortTermBuilder >> clientSortGraph [
	^ clientSortGraph
]

{ #category : #accessing }
LzSortTermBuilder >> clientSortGraph: aSortGraph [
	clientSortGraph := aSortGraph
]

{ #category : #constructing }
LzSortTermBuilder >> literalTerm:  anObject class: aLiteralTermClass builtin: aSymbol [
	^ signature literalTerm:  anObject class: aLiteralTermClass builtin: aSymbol
]

{ #category : #constructing }
LzSortTermBuilder >> opTerm: anOpName args: anArrayOfTerms [
	| sort |
	sort := signature operators
				sortForOp: anOpName
				arity: (LzArity forArgs: anArrayOfTerms).
	anArrayOfTerms do: [ :each |
		self assert: each signature == self ].
	^ LzSortTerm new
		sortGraph: clientSortGraph;
		signature: signature;
		opName: anOpName;
		args: anArrayOfTerms;
		sort: sort;
		beRecursivelyReadOnlyObject;
		yourself 
]

{ #category : #constructing }
LzSortTermBuilder >> parsedVariables: anArrayOfASTVarDeclarationNodes [
	^ signature parsedVariables: anArrayOfASTVarDeclarationNodes
]

{ #category : #accessing }
LzSortTermBuilder >> signature [
	^ signature
]

{ #category : #accessing }
LzSortTermBuilder >> signature: aSignature [
	signature := aSignature
]

{ #category : #constructing }
LzSortTermBuilder >> varTerm: aVarName variables: aDictionary [
	^ signature varTerm: aVarName variables: aDictionary
]
