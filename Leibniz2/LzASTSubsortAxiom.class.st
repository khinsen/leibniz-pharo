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
LzASTSubsortAxiom >> subsort: anObject [

	subsort := anObject
]

{ #category : #accessing }
LzASTSubsortAxiom >> supersort [

	^ supersort
]

{ #category : #accessing }
LzASTSubsortAxiom >> supersort: anObject [

	supersort := anObject
]
