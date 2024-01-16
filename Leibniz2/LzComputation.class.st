Class {
	#name : #LzComputation,
	#superclass : #Object,
	#instVars : [
		'internalVars',
		'steps',
		'resultTerm',
		'context'
	],
	#category : #'Leibniz2-Computations'
}

{ #category : #initializing }
LzComputation >> addStep: aTermString pattern: aPatternString [
	| node varBuilder vars step pattern |
	node := LzParser2 parse: aPatternString startingAt: LzParser2 startingStateForTerm.
	varBuilder := LzVarDeclarationBuilder new.
	varBuilder acceptNode: node.
	vars := context signature parsedVariables: varBuilder vars.
	internalVars addAll: vars.
	step := self context reduce: (self parseAsTerm: aTermString).
	pattern := self context reduce: (self parseAsTerm: aPatternString).
	steps add: { step . pattern }
]

{ #category : #accessing }
LzComputation >> context [
	^ context
]

{ #category : #accessing }
LzComputation >> context: anObject [
	context := anObject
]

{ #category : #inspecting }
LzComputation >> gtBindingsFor: aView [
	<gtView>
	self bindings ifNil: [ ^ aView empty ].
	self bindings bindings ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Bindings';
		priority: 4;
		object: [ self bindings ];
		view: #gtBindingsFor:;
		yourself
]

{ #category : #accessing }
LzComputation >> gtFailureFor: aView [
	<gtView>
	self bindings ifNil: [ ^ aView empty ].
	self bindings ifSuccess: [ ^ aView empty ].
	^ aView forward
		title: 'Failure';
		priority: 5;
		object: [ self bindings ];
		view: #gtFailureFor:;
		yourself
]

{ #category : #inspecting }
LzComputation >> gtStepsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 1;
		items: [ steps ];
		column: 'Pattern' text:  [ :each |
			each second asLeibnizSyntax ];
		column: 'Term' text: [ :each |
			each first asLeibnizSyntax ];
		yourself
]

{ #category : #initializing }
LzComputation >> initialize [
	internalVars := Dictionary new.
	steps := OrderedCollection new.
]

{ #category : #accessing }
LzComputation >> internalVars [
	^ internalVars
]

{ #category : #private }
LzComputation >> parseAsTerm: aTermString [
	| node builder |
	node := LzParser2 parse: aTermString startingAt: LzParser2 startingStateForTerm.
	builder := LzDeclarationBuilder new.
	^ (builder acceptNode: node)  buildFor: self signature variables: self internalVars
]

{ #category : #accessing }
LzComputation >> resultTerm: aTermString [
	resultTerm := self parseAsTerm: aTermString
]

{ #category : #accessing }
LzComputation >> signature [
	^ self context signature
]
