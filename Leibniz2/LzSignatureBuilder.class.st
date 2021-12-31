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

{ #category : #accessing }
LzSignatureBuilder >> initialize [
	opDeclarations := OrderedCollection new.
	varDeclarations := OrderedCollection new.
]

{ #category : #accessing }
LzSignatureBuilder >> op: aString [
	opDeclarations add:
		(LzParser
			parse: aString
			startingAt: #opEnd
			yielding: LzASTOpDeclaration).
]

{ #category : #accessing }
LzSignatureBuilder >> parsedOps: aCollection [
	opDeclarations addAll: aCollection
]

{ #category : #building }
LzSignatureBuilder >> signature [
	| uniqueVars uniqueOps variables |
	uniqueOps := (opDeclarations collect: [ :each |
		each withoutVarDeclarations ]) asSet.
	uniqueVars := (varDeclarations,
		(opDeclarations flatCollect: [ :each | each varDeclarations ])) asSet.
	self flag: #todo.
	"Check for var declarations with sorts that are equal up to variable renaming."
	variables := uniqueVars collect: [ :each |
		each name -> self sortGraph buildSort: each sort ].
	^ LzSignature new
		sortGraph: self sortGraph;
		operators: uniqueOps;
		variables: variables;
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
			yielding: LzASTVarDeclaration).
]
