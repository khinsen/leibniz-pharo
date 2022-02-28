Class {
	#name : #LzTermGeneratorView,
	#superclass : #Object,
	#instVars : [
		'retrievedTerms',
		'announcer',
		'generatorOrSequence'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzTermGeneratorView >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
LzTermGeneratorView >> generator: aGeneratorOrSequence [
	generatorOrSequence := aGeneratorOrSequence.
	retrievedTerms := OrderedCollection new.
	self moreTerms.
]

{ #category : #inspecting }
LzTermGeneratorView >> gtTermsFor: aView [
	<gtView>
	| view |
	view := aView list
		title: 'Terms';
		priority: 0;
		items: [ retrievedTerms ];
		itemLzCode: #asLeibnizSyntaxString;
		updateWhen: LzTermGeneratorViewMoreTermsEvent in: [ self announcer ]
		yourself.
	self isComplete ifFalse: [
		view
			actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'More'
			action: [ self moreTerms ] ].
	^ view
]

{ #category : #testing }
LzTermGeneratorView >> isComplete [
	^ generatorOrSequence isStream not or: [ generatorOrSequence atEnd ]
]

{ #category : #accessing }
LzTermGeneratorView >> moreTerms [
	| counter |
	generatorOrSequence isStream
		ifFalse: [ retrievedTerms addAll: generatorOrSequence ]
		ifTrue: [
			counter := 0.
			[ generatorOrSequence atEnd and: [ counter < 100] ] whileFalse: [
				retrievedTerms add: generatorOrSequence next.
				counter := counter + 1 ] ].
	self announcer announce: LzTermGeneratorViewMoreTermsEvent new
]
