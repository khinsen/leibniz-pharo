Class {
	#name : #LbRewriteSystemBuilder,
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
LbRewriteSystemBuilder class >> signature: aSignature [
	^self basicNew
			initializeWithSignature: aSignature;
			yourself.


]

{ #category : #adding }
LbRewriteSystemBuilder >> addRewriteSystem: aRewriteSystem [
	aRewriteSystem rules do:
		[ :each | self addRule: (each convertToSignature: signature) ]
]

{ #category : #adding }
LbRewriteSystemBuilder >> addRule: aRule [
	self assert: aRule signature equals: signature.
	rules add: aRule
]

{ #category : #initialization }
LbRewriteSystemBuilder >> initializeWithSignature: aSignature [
	signature := aSignature.
	rules := OrderedCollection new.
]

{ #category : #adding }
LbRewriteSystemBuilder >> parseAndAddRule: aString [
	| rule |
	rule := (LbRuleParser signature: signature)
				parse: aString
				onError: [ :message :position | self error: 'Parse error for: ', aString, ' (', message, ')'].
	rules add: rule
]

{ #category : #accessing }
LbRewriteSystemBuilder >> rewriteSystem [
	^ LbRewriteSystem signature: signature rules: rules deepCopy.
]
