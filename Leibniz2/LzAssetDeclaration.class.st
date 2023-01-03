Class {
	#name : #LzAssetDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'label',
		'order'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzAssetDeclaration >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(self label asRopedText attribute: LzAssetLabelAttribute new).
	self order ifNotNil: [ :o |
		aRopedText append: '[' asRopedText.
		aRopedText append:
			(o asRopedText attribute: LzRuleOrderAttribute new).
		aRopedText append: ']' asRopedText ].
]

{ #category : #accessing }
LzAssetDeclaration >> label [

	^ label
]

{ #category : #accessing }
LzAssetDeclaration >> label: anObject [

	label := anObject
]

{ #category : #constructing }
LzAssetDeclaration >> objectFor: aContext [
	^ aContext parsedAsset: self
]

{ #category : #accessing }
LzAssetDeclaration >> order [

	^ order
]

{ #category : #accessing }
LzAssetDeclaration >> order: anObject [

	order := anObject
]
