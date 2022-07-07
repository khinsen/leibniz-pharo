Class {
	#name : #LzPageDeclarationCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'declarations',
		'changedSnippets',
		'declarationsChanged'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #parsing }
LzPageDeclarationCache >> clearChangedSnippets [
	changedSnippets := Set new
]

{ #category : #accessing }
LzPageDeclarationCache >> context [
	^ self subcontext: nil
]

{ #category : #accessing }
LzPageDeclarationCache >> declarationsByClass [
	^ declarations values flattened
		groupedBy: [ :each | each declaration class ]
]

{ #category : #inspecting }
LzPageDeclarationCache >> gtContextsUsedFor: aView [
	<gtView>
	| contextNames |
	contextNames := self useContextDeclarations collect: [ :each |
		each declaration contextName ].
	^ aView list
		title: 'Contexts used';
		priority: 2;
		items: [ contextNames ];
		send: [ :each | LzBook pageNamed: each ];
		yourself
]

{ #category : #inspecting }
LzPageDeclarationCache >> gtDeclarationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Declarations';
		priority: 1;
		items: [ ((self declarationsByClass associations
					sorted: [ :a :b |
						(self sortOrderFor: a key) <= (self sortOrderFor: b key) ])
					collect: #value) flattened ];
		column: 'Type'
			text: [ :each |
				(each declaration class name
					allButFirst: 2) allButLast: 'Declaration' size ]
			width: 100;
		column: 'Declaration'
			text: #asLeibnizSyntax;
		column: 'Annotations'
			text: [ :each |
				', ' join:
					(each options associations collect: #printString) ];
		yourself
]

{ #category : #initializing }
LzPageDeclarationCache >> initialize [
	declarations := Dictionary new.
	self clearChangedSnippets.
	declarationsChanged := false.
]

{ #category : #'event handling' }
LzPageDeclarationCache >> onContentTreeRemoved: anAnnouncement [
	| snippetUid |
	snippetUid := anAnnouncement content uid.
	declarations
		removeKey: snippetUid
		ifAbsent: [].
	changedSnippets
		remove: snippetUid
		ifAbsent: []
]

{ #category : #'event handling' }
LzPageDeclarationCache >> onSnippetTextChanged: anAnnouncement [
	changedSnippets add: anAnnouncement snippet uid
]

{ #category : #accessing }
LzPageDeclarationCache >> page [
	^ page
]

{ #category : #accessing }
LzPageDeclarationCache >> page: aLePage [
	page := aLePage 
]

{ #category : #parsing }
LzPageDeclarationCache >> parseChangedSnippets [
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
LzPageDeclarationCache >> parsePage [
	page allChildrenDepthFirstDo: [ :eachSnippet |
		self parseSnippet: eachSnippet ].
	self clearChangedSnippets
]

{ #category : #parsing }
LzPageDeclarationCache >> parseSnippet: aSnippet [
	| declarationsInSnippet |
	declarationsInSnippet := Set new.
	aSnippet ast ifNotNil: [ :ast |
		ast allNodesDo: [ :eachNode |
			(eachNode class name beginsWith: 'LzTopLevel') ifTrue: [
			 	declarationsInSnippet add:
			 		(LzDeclarationBuilder new acceptNode: eachNode) ] ] ].
	declarations at: aSnippet uid put: declarationsInSnippet
]

{ #category : #private }
LzPageDeclarationCache >> sortOrderFor: aClass [
	^ {
		LzSpecialTermsDeclaration -> 0.
		LzUseContextDeclaration -> 1.
		LzSortDeclaration -> 2.
		LzSubsortAxiomDeclaration -> 3.
		LzOpDeclaration -> 4.
		LzEqualityAxiomDeclaration -> 5.
		LzRewriteRuleDeclaration -> 6.
		LzFunctionRuleDeclaration -> 7.
	} asDictionary at: aClass
]

{ #category : #subscribing }
LzPageDeclarationCache >> subscribeToPageEvents [
	self page weak
		when: LeContentTreeRemoved
		send: #onContentTreeRemoved: to: self;
		when: LeSnippetTextChanged
		send: #onSnippetTextChanged: to: self
]

{ #category : #accessing }
LzPageDeclarationCache >> useContextDeclarations [
	^ self declarationsByClass at: LzUseContextDeclaration ifAbsent: [ #() ]
]
