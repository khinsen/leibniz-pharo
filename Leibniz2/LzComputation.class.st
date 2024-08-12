Class {
	#name : #LzComputation,
	#superclass : #Object,
	#instVars : [
		'internalVars',
		'steps',
		'resultTerm',
		'context',
		'computationSubsort',
		'resultSort'
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
	computationSubsort
		ifNil: [ computationSubsort := self computationSubsortFor: step ]
		ifNotNil: [ self
						assert: computationSubsort
						equals: (self computationSubsortFor: step) ].
	steps add: { step . pattern }
]

{ #category : #testing }
LzComputation >> computationSubsortFor: aTerm [
	| computation subsort sortBindings |
	computation := self parseAsSortPattern: 'result_:𝕊, Computation(result_)'.
	subsort := computation directSubsorts
		detect: [ :each |
					sortBindings := each matchWithSupersortsOf:  aTerm sort.
					sortBindings isSuccess ]
		ifNone: [ self error: 'Not a computation: ', aTerm asLeibnizSyntaxString ].
	sortBindings unbindVar: (LzVarName for: 'result_').
	^ subsort substitute: sortBindings
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
	computationSubsorts := OrderedCollection new.
]

{ #category : #accessing }
LzComputation >> internalVars [
	^ internalVars
]

{ #category : #private }
LzComputation >> parseAsPattern: aTermString [
	| node builder |
	node := LzParser2 parse: aTermString startingAt: LzParser2 startingStateForTopLevelTerm.
	self assert: node prefix isNil.
	builder := LzDeclarationBuilder new.
	^ (builder acceptNode: node) declaration buildFor: self signature
]

{ #category : #private }
LzComputation >> parseAsSortPattern: aTermString [
	| node builder term |
	node := LzParser2 parse: aTermString startingAt: LzParser2 startingStateForTopLevelTerm.
	self assert: node prefix isNil.
	builder := LzDeclarationBuilder new.
	term := (builder acceptNode: node) declaration buildFor: self context sortGraph sortContext signature.
	^ self context sortGraph sortWithTerm: term
]

{ #category : #private }
LzComputation >> parseAsTerm: aTermString [
	| node builder |
	node := LzParser2 parse: aTermString startingAt: LzParser2 startingStateForTerm.
	builder := LzDeclarationBuilder new.
	^ (builder acceptNode: node) declaration buildFor: self signature variables: self internalVars
]

{ #category : #accessing }
LzComputation >> resultTerm: aTermString [
	| resultBindings |
	resultTerm := self parseAsTerm: aTermString.
	resultBindings := self context signature emptyBindings.
	resultBindings
		defineVar: (LzVarName for: 'result_')
		sort: resultTerm sort term sort.
	resultBindings
		bindVar: (LzVarName for: 'result_') sort: resultTerm sort term sort to: resultTerm sort term.
	resultSort := computationSubsort substitute: resultBindings
]

{ #category : #accessing }
LzComputation >> signature [
	^ self context signature
]
