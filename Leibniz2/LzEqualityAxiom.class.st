Class {
	#name : #LzEqualityAxiom,
	#superclass : #LzAxiom,
	#instVars : [
		'left',
		'right'
	],
	#category : #'Leibniz2-Axioms'
}

{ #category : #accessing }
LzEqualityAxiom >> left [
	^ left
]

{ #category : #accessing }
LzEqualityAxiom >> patterns [
	^ Set with: left with: right
]

{ #category : #accessing }
LzEqualityAxiom >> right [
	^ right
]
