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
LzASTFunctionRule >> ruleClass [
	^ LzFunctionRule
]
