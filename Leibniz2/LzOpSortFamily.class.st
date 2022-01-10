Class {
	#name : #LzOpSortFamily,
	#superclass : #LzSortFamily,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzOpSortFamily >> op [
	^ op
]

{ #category : #accessing }
LzOpSortFamily >> op: anOperator [
	op := anOperator
]

{ #category : #printing }
LzOpSortFamily >> printAsLeibnizSyntaxOn: aStream [
	self op opName printForArity: op kindArity on: aStream
]

{ #category : #accessing }
LzOpSortFamily >> valueSlots [
	^ #(op)
]
