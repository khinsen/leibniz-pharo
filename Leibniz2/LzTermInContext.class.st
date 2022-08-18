Class {
	#name : #LzTermInContext,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'term',
		'normalForm',
		'context',
		'rewriteCache'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzTermInContext class >> classForTerm: aTerm context: aContext [
	| termClassSort |
	(aContext signature builtins includes: #termClasses)
		ifFalse: [ ^ self ].
	termClassSort := aContext sortGraph simpleSort: #PharoTermClass.
	aTerm sort <= termClassSort ifFalse: [ ^ self ].
	termClassSort directSubsorts do: [ :each |
		aTerm sort <= each ifTrue: [
			| class |
			self assert: each term args isEmpty.
			class := each term opName asSymbol asClass.
			self assert: (class inheritsFrom: self).
			^ class ] ].
	^ self
]

{ #category : #'instance creation' }
LzTermInContext class >> term: aTerm context: aContext rewriteCache: aRewriteCache [
	| class |
	class := self classForTerm: aTerm context: aContext.
	^ class new
		term: aTerm;
		context: aContext;
		rewriteCache: aRewriteCache
]

{ #category : #converting }
LzTermInContext >> addAsRopedTextTo: aRopedText [
	term addAsRopedTextTo: aRopedText
]

{ #category : #accessing }
LzTermInContext >> arity [
	^ self term arity
]

{ #category : #accessing }
LzTermInContext >> context [
	^ context
]

{ #category : #accessing }
LzTermInContext >> context: aContext [
	context := aContext
]

{ #category : #rewriting }
LzTermInContext >> findNormalForm [
	normalForm := self rewriteCache
		ifNotNil: [ :c | c reduce: term ]
		ifNil: [ self context reduce: term ]
]

{ #category : #inspecting }
LzTermInContext >> gtNormalFormTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Normal form';
		priority: 7;
		object: [ self normalForm ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtOperatorFor: aView [
	<gtView>
	^ aView forward
		title: 'Operator';
		priority: 5;
		object: [ self operator ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtSortFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort';
		priority: 2;
		object: [ self term sort ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree';
		priority: 1;
		object: [ self term ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #testing }
LzTermInContext >> hasInlineView [
	^ false
]

{ #category : #accessing }
LzTermInContext >> normalForm [
	normalForm ifNil: [ self findNormalForm ].
	^ normalForm
]

{ #category : #accessing }
LzTermInContext >> operator [
	^ self context signature operators opForTerm: self term
]

{ #category : #printing }
LzTermInContext >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #comparing }
LzTermInContext >> referenceSlots [
	^ #(context)
]

{ #category : #accessing }
LzTermInContext >> rewriteCache [

	^ rewriteCache
]

{ #category : #accessing }
LzTermInContext >> rewriteCache: anObject [

	rewriteCache := anObject
]

{ #category : #accessing }
LzTermInContext >> sort [
	^ self term sort
]

{ #category : #accessing }
LzTermInContext >> term [
	^ term
]

{ #category : #accessing }
LzTermInContext >> term: aTerm [
	term := aTerm
]

{ #category : #comparing }
LzTermInContext >> valueSlots [
	^ #(term)
]
