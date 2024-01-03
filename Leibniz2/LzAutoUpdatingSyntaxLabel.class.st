Class {
	#name : #LzAutoUpdatingSyntaxLabel,
	#superclass : #BrAsyncWidget,
	#instVars : [
		'page',
		'subcontext',
		'declaration',
		'options',
		'textBlock'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> context [
	^ (self page lzDBCache
		contextCacheFor: self page title)
		subcontext: self subcontext
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> declaration [
	^ declaration
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> declaration: anObject [
	declaration := anObject
]

{ #category : #intializing }
LzAutoUpdatingSyntaxLabel >> initialize [
	super initialize.
	self fitContent.
]

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> makeLabel [
	| object text label |
	[
		[
			object := (self options at: #example ifAbsent: [ false ])
				ifTrue: [ self declaration ]
				ifFalse: [ self declaration objectFor: self context ].
			text := self textBlock
						value: declaration
						value: object
						value: options
		] on: Exception do: [ :ex |
			ex freeze.
			object := ex.
			text := self textBlock value: declaration value: object value: options.
			text := text, ((' ',ex printString) asRopedText foreground: Color red) ].
		label := LzSyntaxLabel new
					text: text;
					declaration: self declaration ;
					object: object
	] on: Exception do: [ :ex |
		ex freeze.
		label := LzSyntaxLabel new
					text: (ex printString asRopedText foreground: Color red);
					declaration: ex ].
	^ label beSmallSize asElement
		padding: (BlInsets top: 0 left: 0 bottom: 0 right: 0)
]

{ #category : #'event handling' }
LzAutoUpdatingSyntaxLabel >> onContextChanged: anAnnouncement [
	(anAnnouncement page = self page
		and: [ anAnnouncement subcontext = self subcontext ])
		ifTrue: [ self update ]
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> options [
	^ options
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> options: anObject [
	options := anObject
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> page [
	^ page
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> page: anObject [
	page := anObject
]

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> setUp [
	self subscribeToContextEvents.
	self pendingBlock: [ :aFuture | self makeLabel].
	self update
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> subcontext [
	^ subcontext
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> subcontext: anObject [
	subcontext := anObject
]

{ #category : #'event handling' }
LzAutoUpdatingSyntaxLabel >> subscribeToContextEvents [
	(self page lzDBCache
		contextCacheFor: self page title) weak
			when: LzPageContextChanged
			send: #onContextChanged: to: self
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> textBlock [
	^ textBlock
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> textBlock: anObject [
	textBlock := anObject
]

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> update [
	self stencil: [ self makeLabel  ]
]
