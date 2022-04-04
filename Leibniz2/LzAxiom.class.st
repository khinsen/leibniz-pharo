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
