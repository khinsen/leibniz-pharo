Class {
	#name : #LzOpTerm,
	#superclass : #LzTerm,
	#instVars : [
		'opName',
		'sort',
		'args'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzOpTerm >> args [
	^ args
]

{ #category : #accessing }
LzOpTerm >> args: anArray [
	args := anArray
]

{ #category : #accessing }
LzOpTerm >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #accessing }
LzOpTerm >> opName [
	^ opName
]

{ #category : #accessing }
LzOpTerm >> opName: anOpName [
	opName := anOpName
]

{ #category : #printing }
LzOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArgs: args on: aStream
]

{ #category : #accessing }
LzOpTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzOpTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzOpTerm >> valueSlots [
	^ #(opName args)
]
