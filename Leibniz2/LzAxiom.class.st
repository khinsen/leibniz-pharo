Class {
	#name : #LzAxiom,
	#superclass : #LzTermsWithSharedVars,
	#category : #'Leibniz2-Axioms'
}

{ #category : #initialization }
LzAxiom >> buildTermsFrom: aDictionary [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LzAxiom >> checkConsistency [
	self subclassResponsibility
]

{ #category : #printing }
LzAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream.
]

{ #category : #printing }
LzAxiom >> printBodyAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]
