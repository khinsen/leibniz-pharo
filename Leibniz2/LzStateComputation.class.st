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

{ #category : #operating }
LzStateComputation >> run [
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
	steps do: [ :eachStep |
		| result |
		result := self runStep: eachStep first.
		eachStep second match: result bindings: bindings ].
	^ context reduce: (resultTerm substitute: bindings)
]

{ #category : #operating }
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

{ #category : #operating }
LzStateComputation >> runWithState: aString [
	self state: (self context reduce: (self parseAsTerm: aString)).
	^ self run
]

{ #category : #accessing }
LzStateComputation >> state [
	^ state
]

{ #category : #accessing }
LzStateComputation >> state: anObject [
	state := anObject
]
