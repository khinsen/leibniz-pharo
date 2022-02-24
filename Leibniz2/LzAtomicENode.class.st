Class {
	#name : #LzAtomicENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'atomicTerm'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzAtomicENode >> atomicTerm [
	^ atomicTerm
]

{ #category : #accessing }
LzAtomicENode >> atomicTerm: aTerm [
	atomicTerm := aTerm
]

{ #category : #printing }
LzAtomicENode >> printAsLeibnizSyntaxOn: aStream [
	self atomicTerm printAsLeibnizSyntaxOn: aStream
]
