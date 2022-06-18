Class {
	#name : #LzRewriteRuleDeclaration,
	#superclass : #LzRuleDeclaration,
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzRewriteRuleDeclaration >> addBodyAsRopedTextTo: aRopedText [
	self pattern addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⇒ ' asRopedText attribute: LzRewriteArrowAttribute new).
	self replacement addAsRopedTextTo: aRopedText.
	condition ifNotNil: [ :c |
		aRopedText append:
			(' | ' asRopedText attribute: LzConditionAttribute new).
		c addAsRopedTextTo: aRopedText ]
]

{ #category : #printing }
LzRewriteRuleDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	self replacement printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil: [
		aStream nextPutAll: ' | '.
		self condition printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzRewriteRuleDeclaration >> replacement [
	^ replacement
]

{ #category : #accessing }
LzRewriteRuleDeclaration >> replacement: aTermNode [
	replacement := aTermNode
]

{ #category : #accessing }
LzRewriteRuleDeclaration >> ruleClass [
	^ LzRewriteRule
]

{ #category : #accessing }
LzRewriteRuleDeclaration >> valueSlots [
	^ super valueSlots, #(replacement)
]
