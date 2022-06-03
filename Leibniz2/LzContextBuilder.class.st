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

{ #category : #'instance creation' }
LzContextBuilder class >> fromPage: aString [
	^ self new
		addDeclarationsFromPageNamed: aString;
		yourself
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationNode: aTopLevelNode [
	| declaration |
	declaration := LzDeclarationBuilder new acceptNode: aTopLevelNode.
	(aTopLevelNode isKindOf: LzTopLevelSortNode)
		ifTrue: [ self sortGraphBuilder parsedSortDeclaration: declaration op ].
	(aTopLevelNode isKindOf: LzTopLevelSubsortNode)
		ifTrue: [ self sortGraphBuilder parsedSubsortDeclaration: declaration ].
	(aTopLevelNode isKindOf: LzTopLevelOpNode)
		ifTrue: [ self signatureBuilder parsedOps: { declaration } ].
	(aTopLevelNode isKindOf: LzTopLevelAxiomNode)
		ifTrue: [ self parsedAxiom: declaration ].
	(aTopLevelNode isKindOf: LzTopLevelRuleNode)
		ifTrue: [ self rewriteSystemBuilder parsedRule:  declaration ].
	(aTopLevelNode isKindOf: LzTopLevelUseContextNode)
		ifTrue: [ declaration second
			ifFalse: [ self addDeclarationsFromPageNamed: declaration first ]
			ifTrue: [ self halt ] ].
	(aTopLevelNode isKindOf: LzTopLevelSpecialTermsNode)
		ifTrue: [ declaration termTypes do: [ :each | self builtin:  each ] ].
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationsFrom: aLePage [
	aLePage allChildrenDepthFirstDo: [ :eachSnippet |
		eachSnippet ast ifNotNil: [ :ast |
			ast allNodesDo: [ :eachNode |
				 (eachNode class name beginsWith: 'LzTopLevel')
			 		ifTrue: [ self addDeclarationNode: eachNode ] ] ] ]
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationsFromPageNamed: aString [
	self addDeclarationsFrom: (LzBook pageNamed: aString)
]

{ #category : #defining }
LzContextBuilder >> axiom: aString [
	self parsedAxiom:
		(LzParser
			parse: aString
			startingAt: #axiomEnd
			yielding: LzAxiomDeclaration)
]

{ #category : #accessing }
LzContextBuilder >> builtin: aSymbol [
	self signatureBuilder builtin: aSymbol
]

{ #category : #building }
LzContextBuilder >> context [
	| sortGraph signature axioms rewriteSystem |
	LzDebuggingUtilities checkForInfiniteRecursion.
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

{ #category : #inspecting }
LzContextBuilder >> gtAxiomsFor: aView [
	<gtView>
	^ aView forward
		title: 'Axioms';
		priority: 3;
		object: [ self context ];
		view: #gtAxiomsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtBuiltinsFor: aView [
	<gtView>
	^ aView forward
		title: 'Builtins';
		priority: 5;
		object: [ self context ];
		view: #gtBuiltinsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtOperatorsFor: aView [
	<gtView>
	| operators |
	operators := self context signature operators.
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Operators' translated;
		priority: 1;
		object: [ operators ] ;
		view: #gtOperatorsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtRulesFor: aView [ 
	<gtView>
	| rws |
	rws := self context rewriteSystem.
	rws isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Rules';
		priority: 5;
		object: [ rws ];
		view: #gtRulesFor:
]

{ #category : #inspecting }
LzContextBuilder >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ self context sortGraph ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #defining }
LzContextBuilder >> include: aContext [
	self sortGraphBuilder include: aContext sortGraph.
	self signatureBuilder include: aContext signature.
	self rewriteSystemBuilder include: aContext rewriteSystem.
	aContext axiomDeclarations do: [ :each |
		axiomDeclarations addIfNotPresent:  each ].
	self includeSortContext: aContext sortGraph sortContext
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
