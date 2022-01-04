Class {
	#name : #LzASTPattern,
	#superclass : #LzASTNode,
	#instVars : [
		'term',
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTPattern >> printAsLeibnizSyntaxOn: aStream [
	variables do: [ :each |
		aStream nextPutAll: '∀ '.
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPut: Character space ].
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzASTPattern >> term [
	^ term
]

{ #category : #accessing }
LzASTPattern >> term: anObject [
	term := anObject
]

{ #category : #accessing }
LzASTPattern >> valueSlots [
	^ #(term variables)
]

{ #category : #accessing }
LzASTPattern >> variables [
	^ variables
]

{ #category : #accessing }
LzASTPattern >> variables: anObject [
	variables := anObject
]
