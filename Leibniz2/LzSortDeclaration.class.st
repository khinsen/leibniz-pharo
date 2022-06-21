Class {
	#name : #LzSortDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzSortDeclaration >> addAsRopedTextTo: aRopedText [
	op addVariablesAsRopedTextTo: aRopedText.
	self
		do: [ :t | op name addForArity: op args asRopedTextTo: t ]
		to: aRopedText
		withAttribute: LzSortAttribute new
]

{ #category : #accessing }
LzSortDeclaration >> op [
	^ op
]

{ #category : #accessing }
LzSortDeclaration >> op: anOpNode [
	anOpNode sort:
		(LzOpTermDeclaration new
			opName: (LzPrefixOpName for: LzConstants opNameSort);
			args: #()).
	op := anOpNode
]

{ #category : #printing }
LzSortDeclaration >> printAsLeibnizSyntaxOn: aStream [
	op printVariablesAsLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream
]

{ #category : #printing }
LzSortDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	op name printForArity: op args on: aStream
]
