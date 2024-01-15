Class {
	#name : #LzStateComputation,
	#superclass : #LzComputation,
	#instVars : [
		'state',
		'bindings'
	],
	#category : #'Leibniz2-Computations'
}

{ #category : #accessing }
LzStateComputation >> bindings [
	^ bindings
]

{ #category : #inspecting }
LzStateComputation >> gtBindingsFor: aView [
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
LzStateComputation >> gtFailureFor: aView [
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

{ #category : #accessing }
LzStateComputation >> runStep: aStepTerm [
	 | fnTerm reduced |
	fnTerm := self signature
				opTerm: (LzBracketOpName new)
				args: { aStepTerm substitute: self bindings . self state }.
	reduced := self context reduce: fnTerm.
	self assert: (reduced isKindOf: LzOpTerm).
	self assert: reduced opName = LzTupleOpName new.
	self assert: reduced args size equals: 2.
	self state: reduced args second.
	^ reduced args first
]

{ #category : #accessing }
LzStateComputation >> runWithState: aString [
	self state: (self context reduce: (self parseAsTerm: aString)).
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
	steps do: [ :eachStep |
		| result |
		result := self runStep: eachStep first.
		eachStep second match: result bindings: bindings ].
	^ context reduce: (resultTerm substitute: bindings)
]

{ #category : #accessing }
LzStateComputation >> state [
	^ state
]

{ #category : #accessing }
LzStateComputation >> state: anObject [
	state := anObject
]
