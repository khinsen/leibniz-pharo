Class {
	#name : #LzRewriteCache,
	#superclass : #Object,
	#instVars : [
		'rewriteSystem',
		'termCache',
		'signature'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #initializing }
LzRewriteCache >> clearCache [
	termCache := Dictionary new
]

{ #category : #inspecting }
LzRewriteCache >> gtTermsFor: aView [
	<gtView>
	termCache ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Terms';
		priority: 5;
		items: [ termCache associations ];
		column: 'Term' text: [ :each | each key asLeibnizSyntax ];
		column: 'Normal form' text: [ :each | each value asLeibnizSyntax ];
		yourself.
]

{ #category : #initializing }
LzRewriteCache >> initialize [
	self clearCache
]

{ #category : #rewriting }
LzRewriteCache >> reduce: aTerm [
	self assert: aTerm signature equals: signature.
	^ termCache
		at: aTerm
		ifAbsentPut: [
			| rewritten |
			rewritten := self rewriteSystem
							rewriteLeftmostInnermost: aTerm
							reducer: [ :t | self reduce: t ].
			rewritten = aTerm
				ifTrue: [ aTerm ]
				ifFalse: [ self reduce: rewritten ] ]
]

{ #category : #accessing }
LzRewriteCache >> rewriteSystem [

	^ rewriteSystem
]

{ #category : #accessing }
LzRewriteCache >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem.
	signature := aRewriteSystem signature
]
