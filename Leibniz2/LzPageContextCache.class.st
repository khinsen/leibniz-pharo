Class {
	#name : #LzPageContextCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'contexts',
		'declarations',
		'announcer'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #announcer }
LzPageContextCache >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #constructing }
LzPageContextCache >> contextBuilderFor: aSubcontextName [
	| builder |
	builder :=  LzContextBuilder new.
	(self declarations declarationsFor: aSubcontextName) do: [ :each |
		builder addDeclaration: each ].
	^ builder
]

{ #category : #accessing }
LzPageContextCache >> declarations [
	^ declarations
]

{ #category : #accessing }
LzPageContextCache >> declarations: aPageDeclarationCache [
	 declarations := aPageDeclarationCache
]

{ #category : #initializing }
LzPageContextCache >> initialize [
	contexts := Dictionary new
]

{ #category : #'event handling' }
LzPageContextCache >> onDeclarationsChanged: anEvent [
	anEvent page = self page ifTrue: [
		anEvent subcontexts do: [ :each |
			contexts removeKey: each ] ]
]

{ #category : #accessing }
LzPageContextCache >> page [
	^ page
]

{ #category : #accessing }
LzPageContextCache >> page: aLePage [
	page := aLePage
]

{ #category : #constructing }
LzPageContextCache >> pageContextNamed: aSubcontextName [
	contexts at: aSubcontextName ifAbsentPut: [
		(self contextBuilderFor: aSubcontextName) context ].
	^ contexts at: aSubcontextName
]

{ #category : #subscribing }
LzPageContextCache >> subscribeToDeclarationEvents [
	self declarations weak
		when: LzPageDeclarationsChanged
		send: #onDeclarationsChanged: to: self
]
