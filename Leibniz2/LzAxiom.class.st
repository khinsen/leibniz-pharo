Class {
	#name : #LzAxiom,
	#superclass : #LzTermsWithSharedVars,
	#instVars : [
		'label'
	],
	#category : #'Leibniz2-Axioms'
}

{ #category : #converting }
LzAxiom >> addAsRopedTextTo: aRopedText [
	self label ifNotNil: [ :l |
		aRopedText append:
			(l asRopedText attribute: LzAssetLabelAttribute new).
			aRopedText append: ': ' asRopedText ].
	super addAsRopedTextTo: aRopedText
]

{ #category : #initialization }
LzAxiom >> buildTermsFrom: aDictionary [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LzAxiom >> checkConsistency [
	self subclassResponsibility
]

{ #category : #accessing }
LzAxiom >> label [

	^ label
]

{ #category : #accessing }
LzAxiom >> label: anObject [

	label := anObject
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
