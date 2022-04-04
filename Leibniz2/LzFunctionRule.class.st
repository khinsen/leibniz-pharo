"
Function rules are implemented as a pattern, a piece of Pharo code, and the subclass of {{gtClass:name=LzTerm}}  representing the desired return value. The Pharo code has access to the variable bindings resulting from the pattern match, the variable names being the same as in the pattern but lacking the trailing underscore that marks Leibniz identifiers as variables.

Variables whose names start with an upper-case character have Leibniz terms as their values, i.e. instances of a subclass of {{gtClass:name=LzTerm}}. All other variables must be bound to an instance of a subclass of {{gtClass:name=LzAtomicTerm}}, the Pharo code receiving the Pharo representation of the value (i.e. a number or string object).

The return value is constructed via the message {{gtMethod:name=LzAtomicTerm class>>signature:value:}} .
"
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

{ #category : #initialization }
LzFunctionRule >> buildTermsFrom: anASTRuleNode [
	super buildTermsFrom: anASTRuleNode.
	self function: anASTRuleNode function
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
			s nextPutAll: each asSymbol allButLast.
			s nextPut: Character space ].
		s nextPutAll: '| '.
		self variables keysDo: [ :each |
			s nextPutAll: each asSymbol allButLast.
			s nextPutAll: ' := (args at: (LzVarName for: '.
			each asSymbol printOn: s.
			s nextPutAll: '))'.
			each asSymbol first isUppercase
				ifFalse: [ s nextPutAll: ' lzAtomicTermValue' ].
			s nextPutAll: '. ' ].
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
LzFunctionRule >> tempMethod [ ^ [ :signature :args | | y x | y := (args at: (LzVarName for: #y_)) lzAtomicTermValue. x := (args at: (LzVarName for: #x_)) lzAtomicTermValue. LzBooleanTerm signature: signature value: (x >= y) ] 
]
