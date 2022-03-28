Class {
	#name : #LzContext,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'signature',
		'axiomDeclarations',
		'rewriteSystem',
		'equalityAxioms',
		'subsortAxioms'
	],
	#category : #'Leibniz2-Contexts'
}

{ #category : #accessing }
LzContext >> axiomDeclarations [
	^ axiomDeclarations
]

{ #category : #accessing }
LzContext >> axiomDeclarations: aSet [
	axiomDeclarations := aSet
]

{ #category : #accessing }
LzContext >> axioms: aCollection [
	equalityAxioms := aCollection select: [ :each | each isKindOf: LzEqualityAxiom ].
	subsortAxioms := aCollection select: [ :each | each isKindOf: LzSubsortAxiom ].
]

{ #category : #accessing }
LzContext >> equalityAxioms [
	^ equalityAxioms
]

{ #category : #inspecting }
LzContext >> gtAxiomsFor: aView [
	<gtView>
	| axiomTree |
	(equalityAxioms size +  subsortAxioms size)
		= 0 ifTrue: [ ^ aView empty ].
	axiomTree := Dictionary
		with: #Equality -> self equalityAxioms 
		with: #Subsorts -> self subsortAxioms.
	^ aView tree
		title: 'Axioms';
		priority: 3;
		items: [ axiomTree keys sorted ];
		itemLzCode: [ :each |
			each isSymbol ifTrue: [ each ]
			ifFalse: [ each asLeibnizSyntaxString ] ];
		children: [ :each |
			each isSymbol ifTrue: [ axiomTree at: each ]
			ifFalse: [ #() ] ];
		expandAll;
		yourself
]

{ #category : #inspecting }
LzContext >> gtBuiltinsFor: aView [
	<gtView>
	self signature builtins
		ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Builtins';
		priority: 4;
		object: [ self signature ];
		view: #gtBuiltinsFor:;
		yourself
]

{ #category : #inspecting }
LzContext >> gtOperatorsFor: aView [
	<gtView>
	| operators |
	operators := self signature operators.
	operators isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Operators' translated;
		priority: 1;
		object: [ operators ] ;
		view: #gtOperatorsFor:;
		yourself
]

{ #category : #inspecting }
LzContext >> gtRulesFor: aView [ 
	<gtView>
	self rewriteSystem isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Rules';
		priority: 5;
		object: [ self rewriteSystem ];
		view: #gtRulesFor:
]

{ #category : #inspecting }
LzContext >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ self sortGraph ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzContext >> gtVariablesFor: aView [
	<gtView>
	self signature variables
		isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Variables';
		priority: 3;
		object: [ self signature ];
		view: #gtVariablesFor:;
		yourself
]

{ #category : #constructing }
LzContext >> parsedPattern: anASTPatternNode [
	^ self signature parsedPattern: anASTPatternNode
]

{ #category : #constructing }
LzContext >> parsedTerm: anASTTermNode [
	^ self signature parsedTerm: anASTTermNode
]

{ #category : #constructing }
LzContext >> pattern: aString [
	^ self signature pattern: aString
]

{ #category : #rewriting }
LzContext >> reduce: aTermOrString [
	^ self rewriteSystem reduce:
		(aTermOrString isString
			ifTrue: [ self term: aTermOrString ]
			ifFalse: [ aTermOrString ])
]

{ #category : #accessing }
LzContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LzContext >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #accessing }
LzContext >> rewriteSystemWithEqualityAxioms [
	| builder |
	builder := LzRewriteSystemBuilder new
		signature: self signature;
		include: self rewriteSystem.
	axiomDeclarations
		select: [ :each | each isKindOf: LzASTEqualityAxiom ]
		thenDo: [ :each |
			self flag: #todo. "Check if the constructed rules are well-formed."
			builder parsedRule:
				(LzASTRewriteRule new
					variables: each variables;
					pattern: each left;
					replacement: each right;
					condition: each condition).
			builder parsedRule:
				(LzASTRewriteRule new
					variables: each variables;
					pattern: each right;
					replacement: each left;
					condition: each condition) ].
	^ builder rewriteSystem
]

{ #category : #constructing }
LzContext >> rule: aString [
	^ self signature rule: aString
]

{ #category : #rewriting }
LzContext >> rulesMatching: aTermOrString [
	^ self rewriteSystem rulesMatching:
		(aTermOrString isString
			ifTrue: [ self term: aTermOrString ]
			ifFalse: [ aTermOrString ])
]

{ #category : #accessing }
LzContext >> signature [
	^ signature
]

{ #category : #accessing }
LzContext >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzContext >> sort: aString [
	^ self sortGraph sort: aString
]

{ #category : #accessing }
LzContext >> sortGraph [
	^ self signature sortGraph
]

{ #category : #accessing }
LzContext >> subsortAxioms [
	^ subsortAxioms
]

{ #category : #constructing }
LzContext >> term: aString [
	^ self signature term: aString
]

{ #category : #accessing }
LzContext >> valueSlots [
	^ #(signature equalityXAxioms subsortAxioms rewriteSystem)
]
