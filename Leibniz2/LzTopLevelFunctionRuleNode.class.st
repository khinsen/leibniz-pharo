Class {
	#name : #LzTopLevelFunctionRuleNode,
	#superclass : #LzTopLevelRuleNode,
	#instVars : [
		'code',
		'_class'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelFunctionRuleNode >> _class [
	^ _class
]

{ #category : #generated }
LzTopLevelFunctionRuleNode >> _class: aSmaCCToken [
	_class := aSmaCCToken
]

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
LzTopLevelFunctionRuleNode >> tokenVariables [
	^ #(#code #_class #arrow)
]
