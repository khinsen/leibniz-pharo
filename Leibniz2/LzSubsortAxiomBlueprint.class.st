Class {
	#name : #LzSubsortAxiomBlueprint,
	#superclass : #LzAxiomBlueprint,
	#instVars : [
		'supersort',
		'subsort'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzSubsortAxiomBlueprint >> subsort [

	^ subsort
]

{ #category : #accessing }
LzSubsortAxiomBlueprint >> subsort: anObject [

	subsort := anObject
]

{ #category : #accessing }
LzSubsortAxiomBlueprint >> supersort [

	^ supersort
]

{ #category : #accessing }
LzSubsortAxiomBlueprint >> supersort: anObject [

	supersort := anObject
]
