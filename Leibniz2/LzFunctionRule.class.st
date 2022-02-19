Class {
	#name : #LzFunctionRule,
	#superclass : #LzRule,
	#instVars : [
		'block',
		'function'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #rewriting }
LzFunctionRule >> apply: bindings [
	^ block value: signature value: bindings bindings
]

{ #category : #printing }
LzFunctionRule >> function [
	^ function
]

{ #category : #accessing }
LzFunctionRule >> function: anArray [
	| code |
	function := anArray.
	code := String streamContents: [ :s |
		s nextPutAll: 'tempMethod ^ [ :signature :args | | '.
		self variables keysDo: [ :each |
			s nextPutAll: each asSymbol allButFirst.
			s nextPut: Character space ].
		s nextPutAll: '| '.
		self variables keysDo: [ :each |
			s nextPutAll: each asSymbol allButFirst.
			s nextPutAll: ' := (args at: (LzVarName for: '.
			each asSymbol printOn: s.
			s nextPutAll: ')) lzAtomicTermValue. ' ].
			s nextPutAll: function second.
			s nextPutAll: ' signature: signature value: ('.
			s nextPutAll: function first.
			s nextPutAll: ') ] '].
	self class compile: code.
	block := self tempMethod
]

{ #category : #printing }
LzFunctionRule >> printBodyAsLeibnizSyntaxOn: aStream [
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' → '''.
	aStream nextPutAll: self function first.
	aStream nextPutAll: ''':'.
	aStream nextPutAll: self function second
]

{ #category : #'as yet unclassified' }
LzFunctionRule >> tempMethod [ ^ [ :signature :args | | y x | y := (args at: (LzVarName for: #'?y')) lzAtomicTermValue. x := (args at: (LzVarName for: #'?x')) lzAtomicTermValue. LzBooleanTerm signature: signature value: (x >= y) ] 
]
