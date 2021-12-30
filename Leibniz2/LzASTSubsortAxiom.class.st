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
