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
	self addRewriteSystem: aRewriteSystem origin: nil
]

{ #category : #adding }
LbRewriteSystemBuilder >> addRewriteSystem: aRewriteSystem origin: aContext [
	aRewriteSystem rules keysAndValuesDo: [ :eachHeadOpName :eachRuleList |
		eachRuleList do: [ :each |
			self addRule: (each convertToSignature: signature) ] ]
]

{ #category : #adding }
LbRewriteSystemBuilder >> addRule: aRule [
	self assert: aRule signature equals: signature.
	(rules includes: aRule) ifFalse: [ rules add: aRule ]
]

{ #category : #inspecting }
LbRewriteSystemBuilder >> gtRulesFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Rules';
		priority: 0;
		object: [ self rewriteSystem ];
		view: #gtRulesFor:
]

{ #category : #initialization }
LbRewriteSystemBuilder >> initializeWithSignature: aSignature [
	signature := aSignature.
	rules := OrderedCollection new.
]

{ #category : #adding }
LbRewriteSystemBuilder >> parseAndAddRule: aString [
	rules add: (signature parseRule: aString)
]

{ #category : #accessing }
LbRewriteSystemBuilder >> rewriteSystem [
	^ LbRewriteSystem signature: signature rules: rules deepCopy.
]
