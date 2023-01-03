Class {
	#name : #LzRuleDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
		'pattern',
		'condition',
		'label',
		'order'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzRuleDeclaration >> addAsRopedTextTo: aRopedText [
	self label ifNotNil: [ :l |
		aRopedText append:
			(l asRopedText attribute: LzAssetLabelAttribute new).
		self order ifNotNil: [ :o |
			aRopedText append: '[' asRopedText.
			aRopedText append:
				(o asRopedText attribute: LzRuleOrderAttribute new).
			aRopedText append: ']' asRopedText ].
		aRopedText append: ': ' asRopedText ].
	super addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzRuleDeclaration >> condition [
	^ condition
]

{ #category : #accessing }
LzRuleDeclaration >> condition: aTermNode [
	condition := aTermNode
]

{ #category : #accessing }
LzRuleDeclaration >> label [
	^ label
]

{ #category : #accessing }
LzRuleDeclaration >> label: aSymbol [
	label := aSymbol
]

{ #category : #constructing }
LzRuleDeclaration >> objectFor: aContext [
	^ aContext signature parsedRule: self
]

{ #category : #accessing }
LzRuleDeclaration >> order [
	^ order
]

{ #category : #accessing }
LzRuleDeclaration >> order: aNumber [
	order := aNumber
]

{ #category : #accessing }
LzRuleDeclaration >> pattern [
	^ pattern
]

{ #category : #accessing }
LzRuleDeclaration >> pattern: aTermNode [
	pattern := aTermNode
]

{ #category : #accessing }
LzRuleDeclaration >> ruleClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzRuleDeclaration >> valueSlots [
	^ #(variables pattern condition)
]
