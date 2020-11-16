Class {
	#name : #LeibnizRewriteSystemBuilder,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature',
		'rules'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LeibnizRewriteSystemBuilder class >> signature: aSignature [
	^self basicNew
			initializeWithSignature: aSignature;
			yourself.


]

{ #category : #adding }
LeibnizRewriteSystemBuilder >> addRewriteSystem: aRewriteSystem [
	aRewriteSystem rules do:
		[ :each | self addRule: (each convertToSignature: signature) ]
]

{ #category : #adding }
LeibnizRewriteSystemBuilder >> addRule: aRule [
	self assert: aRule signature equals: signature.
	rules add: aRule
]

{ #category : #initialization }
LeibnizRewriteSystemBuilder >> initializeWithSignature: aSignature [
	signature := aSignature.
	rules := OrderedCollection new.
]

{ #category : #adding }
LeibnizRewriteSystemBuilder >> parseAndAddRule: aString [
	| rule |
	rule := (LbRuleParser forSignature: signature)
				parse: aString
				onError: [ :message :position | self error: 'Parse error for: ', aString, ' (', message, ')'].
	rules add: rule
]

{ #category : #accessing }
LeibnizRewriteSystemBuilder >> rewriteSystem [
	^ LeibnizRewriteSystem signature: signature rules: rules deepCopy.
]
