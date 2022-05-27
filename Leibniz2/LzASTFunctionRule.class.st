Class {
	#name : #LzASTFunctionRule,
	#superclass : #LzASTRule,
	#instVars : [
		'function',
		'code'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTFunctionRule >> code [
	^ code
]

{ #category : #accessing }
LzASTFunctionRule >> code: aString [
	code := aString
]

{ #category : #accessing }
LzASTFunctionRule >> function [
	^ function
]

{ #category : #accessing }
LzASTFunctionRule >> function: anArray [
	function := anArray
]

{ #category : #printing }
LzASTFunctionRule >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' → '.
	self function first printOn: aStream.
	aStream nextPutAll: ':'.
	aStream nextPutAll:  self function second.
	condition ifNotNil: [
		aStream nextPutAll: ' | '.
		self condition printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzASTFunctionRule >> ruleClass [
	^ LzFunctionRule
]
