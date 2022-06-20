Class {
	#name : #LzFunctionRuleDeclaration,
	#superclass : #LzRuleDeclaration,
	#instVars : [
		'function',
		'code'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzFunctionRuleDeclaration >> addBodyAsRopedTextTo: aRopedText [
	self pattern addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⇒ ' asRopedText attribute: LzRewriteArrowAttribute new).
	aRopedText append:
		('Pharo:' asRopedText attribute: LzLanguageTagAttribute new).
	self function ifNotNil: [ :f |
		aRopedText appendString: ''''.
		aRopedText appendString: f first.
		aRopedText appendString: ''':'.
		aRopedText appendString: f second ].
	self code ifNotNil: [ :c |
		aRopedText appendString: '"'.
		aRopedText append: (c asRopedText attribute: LzPharoCodeAttribute new).
		aRopedText appendString: '"' ].
	condition ifNotNil: [ :c |
		aRopedText append:
			(' | ' asRopedText attribute: LzConditionAttribute new).
		c addAsRopedTextTo: aRopedText ]
]

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
LzFunctionRuleDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
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
