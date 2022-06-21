Class {
	#name : #LzSubsortAxiomDeclaration,
	#superclass : #LzAxiomDeclaration,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzSubsortAxiomDeclaration >> addBodyAsRopedTextTo: aRopedText [
	self
		do: [ :t | subsort addAsRopedTextTo: t ]
		to: aRopedText
		withAttribute: LzSortAttribute new.
	aRopedText append:
		(' ⊆ ' asRopedText attribute: LzSubsortAttribute new).
	self
		do: [ :t | supersort addAsRopedTextTo: t ]
		to: aRopedText
		withAttribute: LzSortAttribute new
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> axiomClass [
	^ LzSubsortAxiom
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	subsort printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	supersort printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> subsort [

	^ subsort
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> subsort: anASTTermNode [
	subsort := anASTTermNode
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> supersort [

	^ supersort
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> supersort: anASTTermNode [
	supersort := anASTTermNode
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> terms [
	^ Dictionary
		with: #subsort -> self subsort
		with: #supersort -> self supersort
]
