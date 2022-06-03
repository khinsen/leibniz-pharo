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

{ #category : #accessing }
LzRuleDeclaration >> variables [
	^ variables
]

{ #category : #accessing }
LzRuleDeclaration >> variables: anObject [
	variables := anObject
]
