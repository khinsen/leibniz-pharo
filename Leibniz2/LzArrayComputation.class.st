Class {
	#name : #LzArrayComputation,
	#superclass : #LzComputation,
	#category : #'Leibniz2-Computations'
}

{ #category : #operating }
LzArrayComputation >> runStep: aStepTerm [
	| step |
	step := self context reduce: (aStepTerm substitute: self bindings).
	step ensureArrayTerm.
]
