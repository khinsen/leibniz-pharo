Class {
	#name : #LzASTEqualityAxiom,
	#superclass : #LzASTAxiom,
	#instVars : [
		'left',
		'right',
		'condition'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTEqualityAxiom >> axiomClass [
	^ LzEqualityAxiom
]

{ #category : #accessing }
LzASTEqualityAxiom >> condition [
	^ condition
]

{ #category : #accessing }
LzASTEqualityAxiom >> condition: aTermNode [
	condition := aTermNode
]

{ #category : #accessing }
LzASTEqualityAxiom >> left [
	^ left
]

{ #category : #accessing }
LzASTEqualityAxiom >> left: aTermNode [
	left := aTermNode
]

{ #category : #accessing }
LzASTEqualityAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: Character space.
	left printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' = '.
	right printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil: [ :c |
		aStream nextPutAll: ' | '.
		c printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzASTEqualityAxiom >> right [
	^ right
]

{ #category : #accessing }
LzASTEqualityAxiom >> right: aTermNode [
	right := aTermNode
]

{ #category : #accessing }
LzASTEqualityAxiom >> terms [
	^ Dictionary
		with: #left -> self left
		with: #right -> self right
]
