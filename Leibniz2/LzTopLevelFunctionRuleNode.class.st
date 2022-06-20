Class {
	#name : #LzTopLevelFunctionRuleNode,
	#superclass : #LzTopLevelRuleNode,
	#instVars : [
		'pharo',
		'code'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelFunctionRuleNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelFunctionRule: self
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> code [
	^ code
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> code: aSmaCCToken [
	code := aSmaCCToken
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> pharo [
	^ pharo
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> pharo: aSmaCCToken [
	pharo := aSmaCCToken
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> tokenVariables [
	^ #(#pharo #code #arrow)
]
