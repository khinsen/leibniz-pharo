Class {
	#name : #LzSortDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Declarations'
}

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
	op variables do: [ :each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	op name printForArity: op args on: aStream
]
