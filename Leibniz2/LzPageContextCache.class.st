"
A page context cache subscribes to events from a {{gtClass:name=LzPageDeclarationCache}} (see {{gtMethod:name=LzPageContextCache>>onDeclarationsChanged:}}). If the declarations defining a context have changed, it is deleted from the cache. The next time the context is requested, it is rebuilt from scratch (see {{gtMethod:name=LzPageContextCache>>subcontext:}}) and stored in the cache again.

"
Class {
	#name : #LzPageContextCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'contexts',
		'announcer',
		'declarationCache'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #announcing }
LzPageContextCache >> announceChangesFor: subcontext [
	self announce:
		(LzPageContextChanged new
			page: self page;
			subcontext: subcontext)
]

{ #category : #announcer }
LzPageContextCache >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
LzPageContextCache >> cachedSubcontext: aSubcontextName [
	^ contexts at: aSubcontextName ifAbsent: [ nil ]
]

{ #category : #constructing }
LzPageContextCache >> contextBuilderFor: aSubcontextName [
	^ self declarationCache contextBuilderFor: aSubcontextName
]

{ #category : #accessing }
LzPageContextCache >> declarationCache [
	^ declarationCache
]

{ #category : #accessing }
LzPageContextCache >> declarationCache: aPageDeclarationCache [
	 declarationCache := aPageDeclarationCache
]

{ #category : #inspecting }
LzPageContextCache >> gtAxiomsFor: aView [
	<gtView>
	^ aView forward
		title: 'Axioms' translated;
		priority: 3;
		object: [ self pageContext ] ;
		view: #gtAxiomsFor:;
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageContextCache >> gtBuiltinsFor: aView [
	<gtView>
	^ aView forward
		title: 'Builtins' translated;
		priority: 5;
		object: [ self pageContext ] ;
		view: #gtBuiltinsFor:;
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageContextCache >> gtOperatorsFor: aView [
	<gtView>
	^ (self pageContext gtOperatorsFor: aView)
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageContextCache >> gtRulesFor: aView [
	<gtView>
	^ aView forward
		title: 'Rules' translated;
		priority: 4;
		object: [ self pageContext ] ;
		view: #gtRulesFor:;
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageContextCache >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ self pageContext ];
		view: #gtSortGraphFor:;
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageContextCache >> gtSubcontextsFor: aView [
	<gtView>
	^ aView list
		title: 'Subcontexts';
		priority: 9;
		items: [ self subcontexts asArray ];
		send: [ :each | self subcontext: each ];
		actionUpdateButton;
		yourself
]

{ #category : #initializing }
LzPageContextCache >> initialize [
	contexts := Dictionary new.
]

{ #category : #'event handling' }
LzPageContextCache >> onDeclarationsChanged: anEvent [
	anEvent page = self page ifTrue: [
		anEvent subcontexts do: [ :each |
			each
				ifNotNil: [
					contexts removeKey: each ifAbsent: [].
					self announceChangesFor: each ]
				ifNil: [
					contexts := Dictionary new.
					self announceChangesFor: nil.  ] ] ]
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
LzPageContextCache >> pageContext [
	^ self subcontext: nil
]

{ #category : #printing }
LzPageContextCache >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< self page title;
		<< ''')'
]

{ #category : #constructing }
LzPageContextCache >> rebuildContexts [
	| contextNames |
	contextNames := self declarationCache subcontexts.
	contextNames add: nil.
	contextNames do: [ :each |
		contexts at: each ifAbsent: [
			contexts
				at: each 
				put: (self contextBuilderFor: each) context.
			self announceChangesFor: each ]].
]

{ #category : #constructing }
LzPageContextCache >> subcontext: aSubcontextName [
	contexts at: aSubcontextName ifAbsentPut: [
		(self contextBuilderFor: aSubcontextName) context ].
	^ contexts at: aSubcontextName
]

{ #category : #accessing }
LzPageContextCache >> subcontexts [
	^ self declarationCache subcontexts
]

{ #category : #subscribing }
LzPageContextCache >> subscribeToDeclarationEvents [
	self declarationCache weak
		when: LzPageDeclarationsChanged
		send: #onDeclarationsChanged: to: self
]
