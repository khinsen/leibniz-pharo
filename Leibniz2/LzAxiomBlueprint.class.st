Class {
	#name : #LzAxiomBlueprint,
	#superclass : #LzBlueprint,
	#instVars : [
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzAxiomBlueprint >> variables [

	^ variables
]

{ #category : #accessing }
LzAxiomBlueprint >> variables: anObject [

	variables := anObject
]
