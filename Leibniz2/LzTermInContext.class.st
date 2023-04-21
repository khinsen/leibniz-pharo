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
LzTermInContext class >> term: aTerm context: aContext [
	| class |
	class := self classForTerm: aTerm context: aContext.
	^ class new
		term: aTerm;
		context: aContext
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
LzTermInContext >> gtAxiomsFor: aView [
	<gtView>
	^ aView forward
		title: 'Axioms';
		priority: 13;
		object: [ self context ];
		view: #gtAxiomsFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtBuiltinsFor: aView [
	<gtView>
	^ aView forward
		title: 'Builtins';
		priority: 15;
		object: [ self context ];
		view: #gtBuiltinsFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtDebugActionFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Debug term construction';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ 
			| signature opName opArgs |
			signature := self term signature.
			opName := self term opName.
			opArgs := self term args.
			self halt.
			signature opTerm: opName args: opArgs ]
]

{ #category : #inspecting }
LzTermInContext >> gtMatchingRulesFor: aView [
	<gtView>
	^ aView forward
		title: 'Matching rules';
		priority: 8;
		object: [ self context rulesMatching: self term ];
		view: #gtRulesFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtNormalFormTreeFor: aView [
	<gtView>
	^ (self gtTreeFor: aView term: self normalForm)
		title: 'Normal form';
		priority: 7;
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
LzTermInContext >> gtOperatorsFor: aView [
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 12;
		object: [ self context ];
		view: #gtOperatorsFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtRulesFor: aView [
	<gtView>
	^ aView forward
		title: 'Rules';
		priority: 14;
		object: [ self context ];
		view: #gtRulesFor:;
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
LzTermInContext >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 11;
		object: [ self context ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtTreeFor: aView [
	<gtView>
	^ (self gtTreeFor: aView term: self term)
		title: 'Tree';
		priority: 1;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtTreeFor: aView term: aTerm [
	^ aView columnedTree
		items: [ { aTerm } ];
		column: 'Term' text: [ :each |
			each synopsis asRopedText
				fontName: LzCodeFont defaultFamily ];
		column: 'Sort' text: [ :each |
			each sort asLeibnizSyntax ];
		children: #args;
		send: [ :each |
			self class
				term: each
				context: context
				rewriteCache: rewriteCache ];
		expandAll;
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
		ifNil: [ rewriteCache := LzGlobalCache uniqueInstance
									rewriteCacheFor:  self context ]
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
