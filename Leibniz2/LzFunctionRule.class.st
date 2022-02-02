Class {
	#name : #LzFunctionRule,
	#superclass : #LzRule,
	#instVars : [
		'block',
		'function'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #printing }
LzFunctionRule >> function [
	^ function
]

{ #category : #accessing }
LzFunctionRule >> function: anArray [
	| code tempClass |
	function := anArray.
	code := String streamContents: [ :s |
		s nextPutAll: 'block ^ [ :signature :args | | '.
		self variables keysDo: [ :each |
			s nextPutAll: each asSymbol.
			s nextPut: Character space ].
		s nextPutAll: '| '.
		self variables keysDo: [ :each |
			s nextPutAll: each asSymbol.
			s nextPutAll: ' := (args at: (LzPrefixOperatorName for: '.
			each asSymbol printOn: s.
			s nextPutAll: ')) leibnizAtomicTermValue. ' ].
			s nextPutAll: function second.
			s nextPutAll: ' value: ('.
			s nextPutAll: function first.
			s nextPutAll: ') signature: signature ] '].
	tempClass := Object newAnonymousSubclass.
	tempClass compile: code.
	block := tempClass new block.
]

{ #category : #printing }
LzFunctionRule >> printRHSAsLeibnizSyntaxOn: aStream [
	self function first printOn: aStream.
	aStream nextPutAll: ':'.
	aStream nextPutAll:  self function second.
]
