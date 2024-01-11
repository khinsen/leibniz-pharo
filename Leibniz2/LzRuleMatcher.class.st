Class {
	#name : #LzRuleMatcher,
	#superclass : #LzPatternMatcher,
	#instVars : [
		'rule'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #inspecting }
LzRuleMatcher >> gtReplacementFor: aView [
	<gtView>
	self bindings bindings ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Replacement';
		priority: 3;
		object: [ self replacementInContext ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #printing }
LzRuleMatcher >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self rule asLeibnizSyntaxString;
		<< $)
]

{ #category : #accessing }
LzRuleMatcher >> replacement [
	| reducer |
	reducer := self context
		ifNil: [ [ :aTerm | aTerm ] ]
		ifNotNil: [ [ :aTerm | self context reduce: aTerm ] ].
	^ self rule apply: bindings reducer: reducer.
]

{ #category : #accessing }
LzRuleMatcher >> replacementInContext [
	^ self replacement inContext: self context
]

{ #category : #accessing }
LzRuleMatcher >> rule [
	^ rule
]

{ #category : #accessing }
LzRuleMatcher >> rule: anLzRule [
	rule := anLzRule.
	self pattern: rule pattern
]
