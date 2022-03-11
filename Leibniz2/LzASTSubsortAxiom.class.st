Class {
	#name : #LzASTSubsortAxiom,
	#superclass : #LzASTAxiom,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTSubsortAxiom >> axiomClass [
	^ LzSubsortAxiom
]

{ #category : #accessing }
LzASTSubsortAxiom >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	aStream nextPut: Character space.
	subsort printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⊆ '.
	supersort printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzASTSubsortAxiom >> subsort [

	^ subsort
]

{ #category : #accessing }
LzASTSubsortAxiom >> subsort: anASTTermNode [
	subsort := anASTTermNode
]

{ #category : #accessing }
LzASTSubsortAxiom >> supersort [

	^ supersort
]

{ #category : #accessing }
LzASTSubsortAxiom >> supersort: anASTTermNode [
	supersort := anASTTermNode
]

{ #category : #accessing }
LzASTSubsortAxiom >> terms [
	^ Dictionary
		with: #subsort -> self subsort
		with: #supersort -> self supersort
]
