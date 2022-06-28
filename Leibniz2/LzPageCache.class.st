Class {
	#name : #LzPageCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'contexts',
		'snippet',
		'declarations',
		'changedSnippets',
		'declarationsChanged',
		'changedContexts'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #parsing }
LzPageCache >> clearChangedSnippets [
	changedSnippets := Set new
]

{ #category : #accessing }
LzPageCache >> context [
	^ self subcontext: nil
]

{ #category : #initializing }
LzPageCache >> initialize [
	snippet := Dictionary new.
	declarations := Dictionary new.
	contexts := Dictionary new.
	self clearChangedSnippets.
	declarationsChanged := false.
	changedContexts := Set new.
]

{ #category : #'event handling' }
LzPageCache >> onContentTreeRemoved: anAnnouncement [
	{ snippet. declarations }
		do: [ :each |
			each
				removeKey: anAnnouncement content uid
				ifAbsent: [] ]
]

{ #category : #'event handling' }
LzPageCache >> onSnippetTextChanged: anAnnouncement [
	changedSnippets add: anAnnouncement snippet uid
]

{ #category : #accessing }
LzPageCache >> page [
	^ page
]

{ #category : #accessing }
LzPageCache >> page: aLePage [
	page := aLePage 
]

{ #category : #parsing }
LzPageCache >> parseChangedSnippets [
	page allChildrenDepthFirstDo: [ :eachSnippet |
		(changedSnippets includes: eachSnippet) ifTrue: [
			| oldDeclarations |
			oldDeclarations := declarations at: eachSnippet uid.
			self parseSnippet: eachSnippet.
			(declarations at: eachSnippet uid) = oldDeclarations
				ifFalse: [ declarationsChanged := true ] ] ].
	self clearChangedSnippets
]

{ #category : #parsing }
LzPageCache >> parsePage [
	page allChildrenDepthFirstDo: [ :eachSnippet |
		self parseSnippet: eachSnippet ].
	self clearChangedSnippets
]

{ #category : #parsing }
LzPageCache >> parseSnippet: aSnippet [
	| declarationsInSnippet |
	declarationsInSnippet := Set new.
	aSnippet ast ifNotNil: [ :ast |
		ast allNodesDo: [ :eachNode |
			(eachNode class name beginsWith: 'LzTopLevel') ifTrue: [
			 	declarationsInSnippet add:
			 		(LzDeclarationBuilder new acceptNode: eachNode) ] ] ].
	declarations at: aSnippet uid put: declarationsInSnippet
]

{ #category : #accessing }
LzPageCache >> subcontext: aStringOrNil [
	| builder context |
	self parseChangedSnippets.
	declarationsChanged ifFalse: [
		contexts at: aStringOrNil ifPresent: [ :c | ^ c ] ].
	builder := LzContextBuilder new.
	declarations valuesDo: [ :each |
		(each optionsAt: #subcontext)
			ifNil: [ builder addDeclaration: each ]
			ifNotNil: [ :s |
	 			s = aStringOrNil ifTrue: [
	 				builder addDeclaration: each ] ] ].
	 context := builder context.
	 contexts at: aStringOrNil
	 	ifPresent: [ :c |
	 		c = context ifFalse: [
	 			changedContexts add: aStringOrNil.
	 			contexts at: aStringOrNil put: context ] ]
	 	ifAbsent: [ contexts at: aStringOrNil put: context ] .
	 ^ contexts at: aStringOrNil
]

{ #category : #subscribing }
LzPageCache >> subscribeToPageEvents [
	self page weak
		when: LeContentTreeRemoved
		send: #onContentTreeRemoved: to: self;
		when: LeSnippetTextChanged
		send: #onSnippetTextChanged: to: self
]
