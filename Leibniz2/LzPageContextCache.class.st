Class {
	#name : #LzPageContextCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'contexts',
		'announcer',
		'declarationCache',
		'termCaches'
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
	(self declarationCache declarationsFor: aSubcontextName) do: [ :each |
		builder addDeclaration: each ].
	^ builder
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
		send: [ :each | self subcontextNamed: each ];
		actionUpdateButton;
		yourself
]

{ #category : #initializing }
LzPageContextCache >> initialize [
	contexts := Dictionary new.
	termCaches := Dictionary new.
]

{ #category : #'event handling' }
LzPageContextCache >> onDeclarationsChanged: anEvent [
	anEvent page = self page ifTrue: [
		anEvent subcontexts do: [ :each |
			contexts removeKey: each ifAbsent: [].
			termCaches removeKey: each ifAbsent: [] ] ]
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
	^ self subcontextNamed: nil
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
LzPageContextCache >> rewriteCacheAndSubcontextNamed: aSubcontextName [
	| context cache |
	context := self subcontextNamed: aSubcontextName.
	cache := LzRewriteCache new
				rewriteSystem: context rewriteSystem.
	^ { cache. context }
]

{ #category : #constructing }
LzPageContextCache >> subcontextNamed: aSubcontextName [
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
