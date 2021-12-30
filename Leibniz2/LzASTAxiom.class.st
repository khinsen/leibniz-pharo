Class {
	#name : #LzASTAxiom,
	#superclass : #LzASTNode,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTAxiom >> variables [

	^ variables
]

{ #category : #accessing }
LzASTAxiom >> variables: anObject [

	variables := anObject
]
