Class {
	#name : #LzContext,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'signature',
		'axioms',
		'axiomDeclarations',
		'rewriteSystem'
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
LzContext >> axioms [
	^ axioms
]

{ #category : #accessing }
LzContext >> axioms: aCollection [
	axioms := aCollection
]

{ #category : #inspecting }
LzContext >> gtAxiomsFor: aView [
	<gtView>
	| axiomTree |
	axioms ifEmpty: [ ^ aView empty ].
	axiomTree := axioms groupedBy: #class .
	^ aView tree
		title: 'Axioms';
		priority: 3;
		items: [ axiomTree keys sorted ];
		itemLzCode: [ :each |
			each isClass ifTrue: [ each name ]
			ifFalse: [ each asLeibnizSyntaxString ] ];
		children: [ :each |
			each isClass ifTrue: [ axiomTree at: each ]
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

{ #category : #accessing }
LzContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LzContext >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #constructing }
LzContext >> rule: aString [
	^ self signature rule: aString
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
LzContext >> sortGraph [
	^ self signature sortGraph
]

{ #category : #accessing }
LzContext >> subsortAxioms [
	^ self axioms select: [ :each | each isKindOf: LzSubsortAxiom ]
]

{ #category : #constructing }
LzContext >> term: aString [
	^ self signature term: aString
]

{ #category : #accessing }
LzContext >> valueSlots [
	^ #(signature)
]
