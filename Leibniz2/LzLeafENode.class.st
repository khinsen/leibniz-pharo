Class {
	#name : #LzLeafENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'leafTerm'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #comparing }
LzLeafENode >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class == anObject class ifFalse: [ ^ false ].
	^ self leafTerm = anObject leafTerm
]

{ #category : #enumerating }
LzLeafENode >> allTerms [
	^ { self leafTerm }
]

{ #category : #updating }
LzLeafENode >> canonicalizeIn: anEGraph [
	"nothing to do!"
]

{ #category : #comparing }
LzLeafENode >> hash [
	^ leafTerm hash
]

{ #category : #accessing }
LzLeafENode >> leafTerm [
	^ leafTerm
]

{ #category : #accessing }
LzLeafENode >> leafTerm: aTerm [
	leafTerm := aTerm
]

{ #category : #matching }
LzLeafENode >> matchesFor: aPattern bindings: bindings [
	| b |
	b := bindings copy.
	aPattern match: self leafTerm bindings: b.
	^ b
		ifSuccess: [ { b } ]
		ifFailure: [ #() ]
]

{ #category : #printing }
LzLeafENode >> printAsLeibnizSyntaxOn: aStream [
	self leafTerm printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzLeafENode >> sort [
	^ self leafTerm sort
]
