Class {
	#name : #LzOpTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'opName',
		'args'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzOpTermDeclaration >> addAsRopedTextTo: aRopedText [
	opName addForArgs: args asRopedTextTo: aRopedText
]

{ #category : #accessing }
LzOpTermDeclaration >> args [

	^ args
]

{ #category : #accessing }
LzOpTermDeclaration >> args: anObject [
	args := anObject asArray
]

{ #category : #constructing }
LzOpTermDeclaration >> buildFor: aSignature variables: aDictionary [
	LzDebuggingUtilities checkForInfiniteRecursion.
	^ aSignature
		opTerm: self opName
		args: (self args collect: [ :each |
				each buildFor: aSignature variables: aDictionary ])
]

{ #category : #accessing }
LzOpTermDeclaration >> hasInfixOpOtherThan: anOpName [
	^ self opName isInfixOpOtherThan: anOpName
]

{ #category : #testing }
LzOpTermDeclaration >> isInfix [
	^ self opName isInfix
]

{ #category : #accessing }
LzOpTermDeclaration >> opName [

	^ opName
]

{ #category : #acccessing }
LzOpTermDeclaration >> opName: anOpName [
	opName := anOpName 
]

{ #category : #printing }
LzOpTermDeclaration >> printAsLeibnizSyntaxOn: aStream [
	opName printForArgs: args on: aStream
]

{ #category : #accessing }
LzOpTermDeclaration >> valueSlots [
	^ #(opName args)
]
