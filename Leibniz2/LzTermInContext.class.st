Class {
	#name : #LzTermInContext,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'term',
		'normalForm',
		'context',
		'eGraph',
		'rewriteCache'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #converting }
LzTermInContext >> addAsRopedTextTo: aRopedText [
	term addAsRopedTextTo: aRopedText
]

{ #category : #initializing }
LzTermInContext >> constructEGraph [
	eGraph := LzEGraph new
		context: context.
	term asENodeIn: eGraph.
	eGraph saturateFromRewriteSystem: context rewriteSystemWithEqualityAxioms.
]

{ #category : #accessing }
LzTermInContext >> context [
	^ context
]

{ #category : #accessing }
LzTermInContext >> context: aContext [
	context := aContext
]

{ #category : #accessing }
LzTermInContext >> eGraph [
	eGraph ifNil: [ self constructEGraph ].
	^ eGraph
]

{ #category : #rewriting }
LzTermInContext >> findNormalForm [
	normalForm := self rewriteCache
		ifNotNil: [ :c | c reduce: term ]
		ifNil: [ self context reduce: term ]
]

{ #category : #inspecting }
LzTermInContext >> gtEquivalentTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Equivalent terms';
		priority: 2;
		object: [ self eGraph classForId: (self term asENodeIn: self eGraph) ];
		view: #gtTermsFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtSortFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort';
		priority: 1;
		object: [ self term sort ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LzTermInContext >> gtTreeFor: aView [
	<gtView>
	^ aView forward
		title: 'Tree';
		priority: 0;
		object: [ self term ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #accessing }
LzTermInContext >> normalForm [
	normalForm ifNil: [ self findNormalForm ].
	^ normalForm
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
