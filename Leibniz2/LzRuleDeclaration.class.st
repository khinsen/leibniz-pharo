Class {
	#name : #LzRuleDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
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

{ #category : #accessing }
LzRuleDeclaration >> ruleClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzRuleDeclaration >> valueSlots [
	^ #(variables pattern condition)
]
