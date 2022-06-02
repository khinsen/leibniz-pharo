Class {
	#name : #LzASTSort,
	#superclass : #LzASTNode,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTSort >> op [
	^ op
]

{ #category : #accessing }
LzASTSort >> op: anOpNode [
	anOpNode sort:
		(LzASTOpTerm new
			opName: (LzPrefixOpName for: LzConstants opNameSort);
			args: #()).
	op := anOpNode
]

{ #category : #printing }
LzASTSort >> printAsLeibnizSyntaxOn: aStream [
	op variables do: [ :each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	op name printForArity: op args on: aStream
]
