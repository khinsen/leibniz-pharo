Class {
	#name : #LzAxiomDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzAxiomDeclaration >> axiomClass [
	self subclassResponsibility
]

{ #category : #printing }
LzAxiomDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self notYetImplemented
]

{ #category : #accessing }
LzAxiomDeclaration >> terms [
	self subclassResponsibility
]
