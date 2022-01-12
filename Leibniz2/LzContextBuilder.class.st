Class {
	#name : #LzContextBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraphBuilder',
		'signatureBuilder',
		'axiomDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzContextBuilder >> axiom: aString [
	self parsedAxiom:
		(LzParser
			parse: aString
			startingAt: #axiomEnd
			yielding: LzASTAxiom)
]

{ #category : #building }
LzContextBuilder >> context [
	| sortGraph signature axioms |
	sortGraph := self sortGraphBuilder
		sortGraph.
	signature := self signatureBuilder 
		sortGraph: sortGraph;
		signature.
	axioms := axiomDeclarations collect: [ :each |
		LzAxiom signature: signature declaration: each ].
	^ LzContext new
		signature: signature;
		axioms: axioms;
		axiomDeclarations: axiomDeclarations copy;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #defining }
LzContextBuilder >> include: aContext [
	self sortGraphBuilder include: aContext sortGraph.
	self signatureBuilder include: aContext signature.
	axiomDeclarations addAll: aContext axiomDeclarations 
]

{ #category : #initializing }
LzContextBuilder >> initialize [
	sortGraphBuilder := LzSortGraphBuilder new.
	signatureBuilder := LzSignatureBuilder new.
	axiomDeclarations := Set new
]

{ #category : #defining }
LzContextBuilder >> op: aString [
	self signatureBuilder op: aString
]

{ #category : #defining }
LzContextBuilder >> parsedAxiom: anASTAxiom [
	axiomDeclarations add: anASTAxiom 
]

{ #category : #defining }
LzContextBuilder >> parsedAxioms: aCollection [
	aCollection do: [ :each | self parsedAxiom: each ]
]

{ #category : #defining }
LzContextBuilder >> parsedOps: aCollection [
	self signatureBuilder parsedOps: aCollection
]

{ #category : #defining }
LzContextBuilder >> signatureBuilder [
	^ signatureBuilder
]

{ #category : #defining }
LzContextBuilder >> sort: aString [
	self sortGraphBuilder sort: aString
]

{ #category : #defining }
LzContextBuilder >> sortContext: aContext [
	sortGraphBuilder sortContext: aContext
]

{ #category : #defining }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder
]

{ #category : #defining }
LzContextBuilder >> subsort: aString [
	self sortGraphBuilder subsort: aString
]

{ #category : #defining }
LzContextBuilder >> var: aString [
	self signatureBuilder var: aString
]
