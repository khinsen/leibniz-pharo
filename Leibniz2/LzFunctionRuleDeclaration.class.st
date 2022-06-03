Class {
	#name : #LzFunctionRuleDeclaration,
	#superclass : #LzRuleDeclaration,
	#instVars : [
		'function',
		'code'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzFunctionRuleDeclaration >> code [
	^ code
]

{ #category : #accessing }
LzFunctionRuleDeclaration >> code: aString [
	code := aString
]

{ #category : #accessing }
LzFunctionRuleDeclaration >> function [
	^ function
]

{ #category : #accessing }
LzFunctionRuleDeclaration >> function: anArray [
	function := anArray
]

{ #category : #printing }
LzFunctionRuleDeclaration >> printAsLeibnizSyntaxOn: aStream [
	self printVariables: variables asLeibnizSyntaxOn: aStream.
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' → '.
	self function ifNotNil: [ :f |
		aStream nextPutAll: ''''.
		aStream nextPutAll: f first.
		aStream nextPutAll: ''':'.
		aStream nextPutAll: f second ].
	self code ifNotNil: [ :c |
		aStream
			<< '"';
			<< c;
			<< '"' ].
	condition ifNotNil: [
		aStream nextPutAll: ' | '.
		self condition printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzFunctionRuleDeclaration >> ruleClass [
	^ LzFunctionRule
]
