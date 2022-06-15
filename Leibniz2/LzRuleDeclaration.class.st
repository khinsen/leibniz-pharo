Class {
	#name : #LzRuleDeclaration,
	#superclass : #LzDeclaration,
	#instVars : [
		'variables',
		'pattern',
		'condition'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #printing }
LzRuleDeclaration >> asLeibnizSyntaxTextColored: aColor [.
	^ (self variables: variables asLeibnizSyntaxTextColored: aColor),
		(self bodyAsLeibnizSyntaxTextColored: aColor)
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
LzRuleDeclaration >> pattern [
	^ pattern
]

{ #category : #accessing }
LzRuleDeclaration >> pattern: aTermNode [
	pattern := aTermNode
]

{ #category : #printing }
LzRuleDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self printVariables: variables asLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzRuleDeclaration >> ruleClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzRuleDeclaration >> valueSlots [
	^ #(variables pattern condition)
]

{ #category : #accessing }
LzRuleDeclaration >> variables [
	^ variables
]

{ #category : #accessing }
LzRuleDeclaration >> variables: anObject [
	variables := anObject
]
