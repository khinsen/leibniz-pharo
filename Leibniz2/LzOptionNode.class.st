Class {
	#name : #LzOptionNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'comma',
		'key',
		'value'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzOptionNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitOption: self
]

{ #category : #generated }
LzOptionNode >> comma [
	^ comma
]

{ #category : #generated }
LzOptionNode >> comma: aSmaCCToken [
	comma := aSmaCCToken
]

{ #category : #generated }
LzOptionNode >> key [
	^ key
]

{ #category : #generated }
LzOptionNode >> key: aSmaCCToken [
	key := aSmaCCToken
]

{ #category : #generated }
LzOptionNode >> nodeVariables [
	^ #(#value)
]

{ #category : #generated }
LzOptionNode >> tokenVariables [
	^ #(#comma #key)
]

{ #category : #generated }
LzOptionNode >> value [
	^ value
]

{ #category : #generated }
LzOptionNode >> value: aLzLiteralTermNode [
	self value notNil ifTrue: [ self value parent: nil ].
	value := aLzLiteralTermNode.
	self value notNil ifTrue: [ self value parent: self ]
]
