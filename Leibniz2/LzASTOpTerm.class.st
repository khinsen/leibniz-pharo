Class {
	#name : #LzASTOpTerm,
	#superclass : #LzASTTerm,
	#instVars : [
		'opName',
		'args'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTOpTerm >> args [

	^ args
]

{ #category : #accessing }
LzASTOpTerm >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzASTOpTerm >> hasInfixOpOtherThan: anOpName [
	^ self opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LzASTOpTerm >> isInfix [
	^ self opName isInfix
]

{ #category : #accessing }
LzASTOpTerm >> opName [

	^ opName
]

{ #category : #acccessing }
LzASTOpTerm >> opName: anOpName [
	opName := anOpName 
]

{ #category : #printing }
LzASTOpTerm >> printAsLeibnizSyntaxOn: aStream [
	opName printForArity: args on: aStream
]

{ #category : #accessing }
LzASTOpTerm >> valueSlots [
	^ #(opName args)
]
