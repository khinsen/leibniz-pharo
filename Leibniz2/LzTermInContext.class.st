Class {
	#name : #LzTermInContext,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'term',
		'normalForm',
		'context',
		'eGraph'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzTermInContext class >> term: aTerm context: aContext [
	^ self new
		context: aContext;
		term: aTerm
]

{ #category : #converting }
LzTermInContext >> addAsRopedTextTo: aRopedText [
	term addAsRopedTextTo: aRopedText.
	aRopedText append:
		(' ⇒ ' asRopedText attribute: LzRewriteArrowAttribute new).
	normalForm addAsRopedTextTo: aRopedText.
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
	normalForm := self context reduce: term
]

{ #category : #accessing }
LzTermInContext >> gtEquivalentTermsFor: aView [
	<gtView>
	^ aView forward
		title: 'Equivalent terms';
		priority: 1;
		object: [ self eGraph classForId: (self term asENodeIn: self eGraph) ];
		view: #gtTermsFor:;
		yourself
]

{ #category : #accessing }
LzTermInContext >> normalForm [
	normalForm ifNil: [ self findNormalForm ].
	^ normalForm
]

{ #category : #printing }
LzTermInContext >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	normalForm printAsLeibnizSyntaxOn: aStream.
]

{ #category : #comparing }
LzTermInContext >> referenceSlots [
	^ #(context)
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
