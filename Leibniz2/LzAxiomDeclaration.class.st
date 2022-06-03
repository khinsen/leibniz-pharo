Class {
	#name : #LzAxiomDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzAxiomDeclaration >> axiomClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzAxiomDeclaration >> terms [
	self subclassResponsibility
]

{ #category : #accessing }
LzAxiomDeclaration >> variables [

	^ variables
]

{ #category : #accessing }
LzAxiomDeclaration >> variables: anObject [

	variables := anObject
]
