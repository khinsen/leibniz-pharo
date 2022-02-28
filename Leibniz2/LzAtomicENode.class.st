Class {
	#name : #LzAtomicENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'atomicTerm'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #enumerating }
LzAtomicENode >> allTerms [
	^ { self atomicTerm }
]

{ #category : #accessing }
LzAtomicENode >> atomicTerm [
	^ atomicTerm
]

{ #category : #accessing }
LzAtomicENode >> atomicTerm: aTerm [
	atomicTerm := aTerm
]

{ #category : #matching }
LzAtomicENode >> matchesFor: aPattern bindings: bindings [
	| b |
	b := bindings copy.
	aPattern match: self atomicTerm bindings: b.
	^ b
		ifSuccess: [ { b } ]
		ifFailure: [ #() ]
]

{ #category : #printing }
LzAtomicENode >> printAsLeibnizSyntaxOn: aStream [
	self atomicTerm printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzAtomicENode >> sort [
	^ self atomicTerm sort
]
