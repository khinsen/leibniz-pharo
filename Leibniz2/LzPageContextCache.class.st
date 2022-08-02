Class {
	#name : #LzPageContextCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'contexts',
		'declarations'
	],
	#category : #'Leibniz2-Lepiter'
}

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

{ #category : #subscribing }
LzPageContextCache >> subscribeToDeclarationEvents [
	self declarations weak
		when: LzPageDeclarationsChanged
		send: #onDeclarationsChanged: to: self
]
