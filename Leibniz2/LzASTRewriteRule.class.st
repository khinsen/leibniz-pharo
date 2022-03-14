Class {
	#name : #LzASTRewriteRule,
	#superclass : #LzASTRule,
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTRewriteRule >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	self replacement printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil: [
		aStream nextPutAll: ' | '.
		self condition printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzASTRewriteRule >> replacement [
	^ replacement
]

{ #category : #accessing }
LzASTRewriteRule >> replacement: aTermNode [
	replacement := aTermNode
]

{ #category : #accessing }
LzASTRewriteRule >> ruleClass [
	^ LzRewriteRule
]

{ #category : #accessing }
LzASTRewriteRule >> valueSlots [
	^ super valueSlots, #(replacement)
]
