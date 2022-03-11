Class {
	#name : #LzASTAxiom,
	#superclass : #LzASTNode,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTAxiom >> axiomClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzASTAxiom >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables do:
		[ :var |
			aStream nextPutAll: '∀ '.
			var printAsLeibnizSyntaxOn: aStream.
			aStream nextPut: Character space]
]

{ #category : #accessing }
LzASTAxiom >> terms [
	self subclassResponsibility
]

{ #category : #accessing }
LzASTAxiom >> variables [

	^ variables
]

{ #category : #accessing }
LzASTAxiom >> variables: anObject [

	variables := anObject
]
