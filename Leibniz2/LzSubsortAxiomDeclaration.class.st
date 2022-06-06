Class {
	#name : #LzSubsortAxiomDeclaration,
	#superclass : #LzAxiomDeclaration,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzSubsortAxiomDeclaration >> axiomClass [
	^ LzSubsortAxiom
]

{ #category : #accessing }
LzSubsortAxiomDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self printVariables: variables asLeibnizSyntaxOn: aStream.
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
