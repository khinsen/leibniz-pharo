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
		'function',
		'code'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #converting }
LzFunctionRule >> addBodyAsRopedTextTo: aRopedText [
	pattern addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⇒ ' asRopedText attribute: LzRewriteArrowAttribute new).
	aRopedText append:
		('Pharo:' asRopedText attribute: LzLanguageTagAttribute new).
	aRopedText append: '"' asRopedText.
	aRopedText append: (code asRopedText attribute: LzPharoCodeAttribute new).
	aRopedText append: '"' asRopedText
]

{ #category : #rewriting }
LzFunctionRule >> apply: bindings reducer: aBlock [
	^ block value: signature value: bindings bindings value: aBlock
]

{ #category : #initialization }
LzFunctionRule >> buildTermsFrom: anASTRuleNode [
	super buildTermsFrom: anASTRuleNode.
	self flag: #todo. "Remove 'function' when obsolete."
	anASTRuleNode function ifNotNil: [ :f | self function: f ].
	anASTRuleNode code ifNotNil: [ :c | self code: c ].
]

{ #category : #accessing }
LzFunctionRule >> code [
	^ code
]

{ #category : #initialization }
LzFunctionRule >> code: aString [
	| fullCode |
	code := aString.
	fullCode := String streamContents: [ :s |
		s << '[ :signature :args :reducer | | '.
		self variables keysDo: [ :each |
			s << each asSymbol allButLast.
			s << Character space ].
		s << '| '.
		self variables keysDo: [ :each |
			s << each asSymbol allButLast.
			s << ' := (args at: (LzVarName for: '.
			each asSymbol printOn: s.
			s << ')). ' ].
		s << aString.
		s << ' ] ' ].
	block := Smalltalk compiler class new
				source: fullCode;
				evaluate
]

{ #category : #printing }
LzFunctionRule >> function [
	^ function
]

{ #category : #accessing }
LzFunctionRule >> function: anArray [
	| code |
	self flag: #todo. "Remove when obsolete"
	function := anArray.
	code := String streamContents: [ :s |
		s << '[ :signature :args :reducer | | '.
		self variables keysDo: [ :each |
			s << each asSymbol allButLast.
			s << Character space ].
		s << '| '.
		self variables keysDo: [ :each |
			s << each asSymbol allButLast.
			s << ' := (args at: (LzVarName for: '.
			each asSymbol printOn: s.
			s << '))'.
			each asSymbol first isUppercase
				ifFalse: [ s << ' lzAtomicTermValue' ].
			s << '. ' ].
		function second = #nil
			ifTrue: [
				s << function first ]
			ifFalse: [
				s << function second.
				s << ' signature: signature value: ('.
				s << function first.
				s << ')' ].
		s << ' ] ' ].
	block := Smalltalk compiler class new
				source: code;
				evaluate
]

{ #category : #printing }
LzFunctionRule >> printBodyAsLeibnizSyntaxOn: aStream [
	self pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	self function ifNotNil: [ :f |
		aStream nextPutAll: ''''.
		aStream nextPutAll: f first.
		aStream nextPutAll: ''':'.
		aStream nextPutAll: f second ].
	self code ifNotNil: [ :c |
		aStream
			<< '"';
			<< c;
			<< '"' ]
]

{ #category : #accessing }
LzFunctionRule >> valueSlots [
	^ super valueSlots, #(block function)
]
