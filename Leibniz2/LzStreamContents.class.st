Class {
	#name : #LzStreamContents,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'retrievedItems',
		'streamOrSequence'
	],
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzStreamContents >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #testing }
LzStreamContents >> isComplete [
	^ streamOrSequence isStream not or: [ streamOrSequence atEnd ]
]

{ #category : #accessing }
LzStreamContents >> moreItems [
	| counter |
	streamOrSequence isStream
		ifFalse: [ retrievedItems addAll: streamOrSequence ]
		ifTrue: [
			counter := 0.
			[ streamOrSequence atEnd and: [ counter < 100] ] whileFalse: [
				retrievedItems add: streamOrSequence next.
				counter := counter + 1 ] ].
	self announcer announce: LzStreamContentsMoreItemsEvent new
]

{ #category : #accessing }
LzStreamContents >> streamOrSequence: aGeneratorOrSequence [
	streamOrSequence := aGeneratorOrSequence.
	retrievedItems := OrderedCollection new.
	self moreItems.
]
