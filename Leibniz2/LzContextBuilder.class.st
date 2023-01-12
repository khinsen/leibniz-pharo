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
LzContextBuilder class >> fromPage: pageName [
	^ self fromPage: pageName subcontext: nil
]

{ #category : #'instance creation' }
LzContextBuilder class >> fromPage: pageName subcontext: aString [
	^ self new
		addDeclarationsFromPageNamed: pageName subcontext: aString;
		yourself
]

{ #category : #lepiter }
LzContextBuilder >> addDeclaration: anAnnotatedDeclaration [
	| declaration |
	declaration := anAnnotatedDeclaration declaration.
	(declaration isKindOf: LzSortDeclaration)
		ifTrue: [ sortGraphBuilder parsedSortDeclaration: declaration ].
	(declaration isKindOf: LzSubsortAxiomDeclaration)
		ifTrue: [ sortGraphBuilder parsedSubsortDeclaration: declaration ].
	(declaration isKindOf: LzOpDeclaration)
		ifTrue: [ signatureBuilder parsedOps: { declaration } ].
	(declaration isKindOf: LzEqualityAxiomDeclaration)
		ifTrue: [ self parsedAxiom: declaration ].
	(declaration isKindOf: LzRuleDeclaration)
		ifTrue: [ rewriteSystemBuilder parsedRule:  declaration ].
	(declaration isKindOf: LzUseContextDeclaration)
		ifTrue: [
			| context |
			context := (LzGlobalCache uniqueInstance
							contextCacheFor: declaration contextName)
						subcontext: declaration subcontext.
			(anAnnotatedDeclaration optionsAt: #forSorts)
				ifFalse: [ self include: context ]
				ifTrue: [ self includeSortContext:  context ] ].
	(declaration isKindOf: LzSpecialTermsDeclaration)
		ifTrue: [ declaration termTypes do: [ :each |
					self builtin:  each ] ].
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationsFrom: aLePage subcontext: aString [
	aLePage allChildrenDepthFirstDo: [ :eachSnippet |
		eachSnippet ast ifNotNil: [ :ast |
			ast allNodesDo: [ :eachNode |
				 (eachNode class name beginsWith: 'LzTopLevel') ifTrue: [
				 	| annotatedDeclaration |
				 	annotatedDeclaration := LzDeclarationBuilder new acceptNode: eachNode.
				 	(annotatedDeclaration optionsAt: #subcontext)
				 		ifNil: [ self addDeclaration: annotatedDeclaration ]
				 		ifNotNil: [ :s |
				 			s = aString ifTrue: [
				 				self addDeclaration: annotatedDeclaration ] ] ] ] ] ]
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationsFromPageNamed: pageName [
	self
		addDeclarationsFromPageNamed: pageName
		subcontext: nil
]

{ #category : #lepiter }
LzContextBuilder >> addDeclarationsFromPageNamed: pageName subcontext: aString [
	self
		addDeclarationsFrom: (LzBook pageNamed: pageName)
		subcontext: aString
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
	signatureBuilder builtin: aSymbol
]

{ #category : #building }
LzContextBuilder >> context [
	| sortGraph signature axioms rewriteSystem |
	LzDebuggingUtilities checkForInfiniteRecursion.
	sortGraph := sortGraphBuilder
		sortGraph.
	signature := signatureBuilder 
		sortGraph: sortGraph;
		signature.
	axioms := axiomDeclarations collect: [ :each |
		signature parsedAxiom: each ].
	rewriteSystem := rewriteSystemBuilder
		signature: signature;
		rewriteSystem.
	^ LzContext new
		signature: signature;
		axioms: axioms;
		axiomDeclarations: axiomDeclarations copy;
		rewriteSystem: rewriteSystem;
		collectAssets;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtAxiomDeclarationsFor: aView [
	<gtView>
	^ aView list
		title: 'Axiom declarations';
		priority: 5;
		items: [ axiomDeclarations asArray ];
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtBuildContextFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect the context';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ :aButton |
			aButton phlow spawnObject:
				self context ]
]

{ #category : #inspecting }
LzContextBuilder >> gtBuiltinsFor: aView [
	<gtView>
	^ aView forward
		title: 'Builtins';
		priority: 2;
		object: [ self signatureBuilder ];
		view: #gtBuiltinsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtOperatorDeclarationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Operator declarations';
		priority: 3;
		object: [ self signatureBuilder ];
		view: #gtOperatorDeclarationsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtRuleDeclarationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Rule declarations';
		priority: 4;
		object: [ self rewriteSystemBuilder ];
		view: #gtRuleDeclarationsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtSortDeclarationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort declarations';
		priority: 0;
		object: [ self sortGraphBuilder ];
		view: #gtSortDeclarationsFor:;
		yourself
]

{ #category : #inspecting }
LzContextBuilder >> gtSubsortDeclarationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Subsort declarations';
		priority: 1;
		object: [ self sortGraphBuilder ];
		view: #gtSubsortDeclarationsFor:;
		yourself
]

{ #category : #defining }
LzContextBuilder >> include: aContext [
	sortGraphBuilder include: aContext sortGraph.
	signatureBuilder include: aContext signature.
	rewriteSystemBuilder include: aContext rewriteSystem.
	aContext axiomDeclarations do: [ :each |
		axiomDeclarations addIfNotPresent:  each ].
	self includeSortContext: aContext sortGraph sortContext
]

{ #category : #defining }
LzContextBuilder >> includeSortContext: aContext [
	sortGraphBuilder includeSortContext: aContext
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
	signatureBuilder op: aString
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
	signatureBuilder parsedOps: aCollection
]

{ #category : #accessing }
LzContextBuilder >> rewriteSystemBuilder [
	"Answer the rewrite system builder with the current
	sortGraph and signature, for debugging the
	rewrite system builder."
	| sortGraph  signature |
	sortGraph := self sortGraphBuilder sortGraph.
	signature := self signatureBuilder
					sortGraph: sortGraph;
					signature.
	^ rewriteSystemBuilder
		signature: signature;
		yourself
]

{ #category : #defining }
LzContextBuilder >> rule: aString [
	self rewriteSystemBuilder rule: aString
]

{ #category : #accessing }
LzContextBuilder >> signatureBuilder [
	"Answer the signature builder with the current
	sortGraph, for debugging the signature builder."
	^ signatureBuilder
		sortGraph: self sortGraphBuilder sortGraph;
		yourself
]

{ #category : #defining }
LzContextBuilder >> sort: aString [
	self sortGraphBuilder sort: aString
]

{ #category : #defining }
LzContextBuilder >> sortContext: aContext [
	sortGraphBuilder sortContext: aContext
]

{ #category : #accessing }
LzContextBuilder >> sortGraphBuilder [
	^ sortGraphBuilder
]

{ #category : #defining }
LzContextBuilder >> subsort: aString [
	self sortGraphBuilder subsort: aString
]

{ #category : #defining }
LzContextBuilder >> var: aString [
	signatureBuilder var: aString
]
