Class {
	#name : #LzAxiomDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
		'label'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzAxiomDeclaration >> addAsRopedTextTo: aRopedText [
	self label ifNotNil: [ :l |
		aRopedText append:
			(l asRopedText attribute: LzAssetLabelAttribute new).
		aRopedText append: ': ' asRopedText ].
	super addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzAxiomDeclaration >> axiomClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzAxiomDeclaration >> label [

	^ label
]

{ #category : #accessing }
LzAxiomDeclaration >> label: anObject [

	label := anObject
]

{ #category : #accessing }
LzAxiomDeclaration >> terms [
	self subclassResponsibility
]
