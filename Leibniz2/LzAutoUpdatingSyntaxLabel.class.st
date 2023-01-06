Class {
	#name : #LzAutoUpdatingSyntaxLabel,
	#superclass : #BrAsyncWidget,
	#instVars : [
		'page',
		'subcontext',
		'declaration',
		'options',
		'text'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> color [
| color |
	color := LzColors declarationColor.
	(self options at: #example ifAbsent: [ false ])
		ifTrue: [ color := LzColors exampleColor ].
	(self options at: #subcontext ifAbsent: [ nil ])
		ifNotNil: [ color := LzColors exampleColor ].
	^ color
]

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> context [
	^ (LzGlobalCache uniqueInstance
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
	| object label |
	[
		object := (self options at: #example ifAbsent: [ false ])
			ifTrue: [ self declaration ]
			ifFalse: [ self declaration objectFor: self context ].
		label := LzSyntaxLabel new
					text: (self text value: declaration value: object value: options);
					declaration: self declaration ;
					object: object
	] on: Exception do: [ :ex |
		ex freeze.
		label := LzSyntaxLabel new
					text: (ex printString asRopedText foreground: Color red);
					declaration: ex ].
	^ label beSmallSize asElement
		padding: (BlInsets top: 2 left: 0 bottom: 0 right: 0)
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
	(LzGlobalCache uniqueInstance
		contextCacheFor: self page title) weak
			when: LzPageContextChanged
			send: #onContextChanged: to: self
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> text [
	^ text
]

{ #category : #accessing }
LzAutoUpdatingSyntaxLabel >> text: anObject [
	text := anObject
]

{ #category : #updating }
LzAutoUpdatingSyntaxLabel >> update [
	self stencil: [ self makeLabel  ]
]
