Class {
	#name : #LzContextBuilder,
	#superclass : #Object,
	#instVars : [
		'sortGraphBuilder',
		'signatureBuilder',
		'axiomDeclarations',
		'rewriteSystemBuilder'
	],
	#category : #'Leibniz2-Contexts'
}

{ #category : #defining }
LzContextBuilder >> axiom: aString [
	self parsedAxiom:
		(LzParser
			parse: aString
			startingAt: #axiomEnd
			yielding: LzASTAxiom)
]

{ #category : #defining }
LzContextBuilder >> beSortContextBuilder [
	self signatureBuilder beSortSignatureBuilder
]

{ #category : #accessing }
LzContextBuilder >> builtin: aSymbol [
	self signatureBuilder builtin: aSymbol
]

{ #category : #building }
LzContextBuilder >> context [
	| sortGraph signature axioms rewriteSystem |
	sortGraph := self sortGraphBuilder
		sortGraph.
	signature := self signatureBuilder 
		sortGraph: sortGraph;
		signature.
	axioms := axiomDeclarations collect: [ :each |
		signature parsedAxiom: each ].
	rewriteSystem := self rewriteSystemBuilder
		signature: signature;
		rewriteSystem.
	^ LzContext new
		signature: signature;
		axioms: axioms;
		axiomDeclarations: axiomDeclarations copy;
		rewriteSystem: rewriteSystem;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #defining }
LzContextBuilder >> include: aContext [
	self sortGraphBuilder include: aContext sortGraph.
	self signatureBuilder include: aContext signature.
	self rewriteSystemBuilder include: aContext rewriteSystem.
	aContext axiomDeclarations do: [ :each |
		axiomDeclarations addIfNotPresent:  each ]
]

{ #category : #defining }
LzContextBuilder >> includeSortContext: aContext [
	self sortGraphBuilder includeSortContext: aContext
]

{ #category : #initializing }
LzContextBuilder >> initialize [
	sortGraphBuilder := LzSortGraphBuilder new.
	signatureBuilder := LzSignatureBuilder new.
	axiomDeclarations := Set new.
	rewriteSystemBuilder := LzRewriteSystemBuilder new.
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

{ #category : #accessing }
LzContextBuilder >> rewriteSystemBuilder [
	^ rewriteSystemBuilder
]

{ #category : #defining }
LzContextBuilder >> rule: aString [
	self rewriteSystemBuilder rule: aString
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
