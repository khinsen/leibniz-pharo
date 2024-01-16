Class {
	#name : #LzArrayComputation,
	#superclass : #LzComputation,
	#category : #'Leibniz2-Computations'
}

{ #category : #operating }
LzArrayComputation >> run [
	| bindings result |
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
	result := self
				runStep: steps first
				continuation: steps allButFirst
				bindings: bindings.
	^ self signature arrayTerm: result shape: { result size }
]

{ #category : #operating }
LzArrayComputation >> runStep: aStep continuation: moreSteps bindings: bindings [
	| stepTerm |
	stepTerm := self context reduce: (aStep first substitute: bindings).
	stepTerm ensureArrayTerm.
	self assert: stepTerm shape size equals: 1.
	^ stepTerm elements flatCollect: [ :each |
		| localBindings |
		localBindings := bindings copy.
		aStep second match: each bindings: localBindings.
		moreSteps
			ifEmpty: [ { context reduce: (resultTerm substitute: localBindings) } ]
			ifNotEmpty: [ self
							runStep: moreSteps first
							continuation: moreSteps allButFirst
							bindings: localBindings ] ]
]
