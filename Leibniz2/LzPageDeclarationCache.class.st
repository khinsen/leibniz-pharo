"
A page declaration cache subscribes to events from an {{gtClass:name=LePage}} (see {{gtMethod:name=LzPageDeclarationCache>>onSnippetTextChanged:}} and {{gtMethod:name=LzPageDeclarationCache>>onContentTreeRemoved:}}) and updates its list of declarations from that page. It parses the changed snippets ({{gtMethod:name=LzPageDeclarationCache>>parseChangedSnippets}} and if they lead to a different set of declarations, it announces the change to subscribing instances of {{gtClass:name=LzPageContextCache}} (see {{gtMethod:name=LzPageDeclarationCache>>announceChangesFor:}}.


"
Class {
	#name : #LzPageDeclarationCache,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'page',
		'declarations',
		'changedSnippets',
		'declarationsChanged',
		'announcer'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #announcing }
LzPageDeclarationCache >> announceChangesFor: subcontexts [
	subcontexts ifNotEmpty: [
		self announce:
			(LzPageDeclarationsChanged new
				page: self page;
				subcontexts: subcontexts) ]
]

{ #category : #announcer }
LzPageDeclarationCache >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #parsing }
LzPageDeclarationCache >> clearChangedSnippets [
	changedSnippets := Set new
]

{ #category : #constructing }
LzPageDeclarationCache >> contextBuilder [
	^ self contextBuilderFor: nil
]

{ #category : #constructing }
LzPageDeclarationCache >> contextBuilderFor: aSubcontextName [
	| builder |
	builder :=  LzContextBuilder new
					database: self page database.
	(self declarationsFor: aSubcontextName) do: [ :each |
		builder addDeclaration: each ].
	^ builder
]

{ #category : #accessing }
LzPageDeclarationCache >> declarationsByClass [
	^ declarations values flattened
		groupedBy: [ :each | each declaration class ]
]

{ #category : #accessing }
LzPageDeclarationCache >> declarationsFor: aSubcontextName [
	^ declarations values flattened select: [ :each |
		each definesSubcontext: aSubcontextName ]
]

{ #category : #inspecting }
LzPageDeclarationCache >> gtContextBuilderFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Inspect the page''s context builder';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ :aButton |
			aButton phlow spawnObject:
				self contextBuilder ]
]

{ #category : #inspecting }
LzPageDeclarationCache >> gtContextsUsedFor: aView [
	<gtView>
	^ aView list
		title: 'Contexts used';
		priority: 2;
		items: [ self useContextDeclarations collect: [ :each |
					each declaration contextName ] ];
		send: [ :each | self page database pageNamed: each ];
		updateWhen: LzPageDeclarationsChanged in: self announcer;
		actionUpdateButton;
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
			text: [ :each |
				each asLeibnizSyntax foreground: each color ];
		column: 'Annotations'
			text: [ :each |
				', ' join:
					(each options associations collect: #printString) ];
		updateWhen: LzPageDeclarationsChanged in: self announcer;
		actionUpdateButton;
		yourself
]

{ #category : #inspecting }
LzPageDeclarationCache >> gtSubcontextsFor: aView [
	<gtView>
	^ aView list
		title: 'Subcontexts';
		priority: 3;
		items: [ self subcontexts asArray ];
		updateWhen: LzPageDeclarationsChanged in: self announcer;
		send: [ :each | self declarationsFor: each ];
		actionUpdateButton;
		yourself
]

{ #category : #initializing }
LzPageDeclarationCache >> initialize [
	declarations := Dictionary new.
	self clearChangedSnippets.
	declarationsChanged := false.
]

{ #category : #testing }
LzPageDeclarationCache >> isEmpty [
	^ declarations
		detect: [ :each | each value size > 0 ]
		ifFound: [ false ]
		ifNone: [ true ]
]

{ #category : #'event handling' }
LzPageDeclarationCache >> onContentTreeRemoved: anAnnouncement [
	| snippetUid subcontexts |
	snippetUid := anAnnouncement content uid.
	subcontexts := Set new.
	(declarations at: snippetUid ifAbsent: [#()]) do: [ :each |
		(each optionsAt: #example) = true ifFalse: [
			subcontexts add: (each optionsAt: #subcontext) ] ].
	self announceChangesFor: subcontexts.
	declarations
		removeKey: snippetUid
		ifAbsent: [].
	changedSnippets
		remove: snippetUid
		ifAbsent: []
]

{ #category : #'event handling' }
LzPageDeclarationCache >> onSnippetTextChanged: anAnnouncement [
	changedSnippets add: anAnnouncement snippet uid.
	self parseChangedSnippets
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
		(changedSnippets includes: eachSnippet uid)
			ifTrue: [
				| oldDeclarations newDeclarations subcontexts |
				oldDeclarations := declarations at: eachSnippet uid ifAbsent: [ Set new ].
				self parseSnippet: eachSnippet.
				newDeclarations := declarations at: eachSnippet uid.
				subcontexts := Set new.
				newDeclarations = oldDeclarations ifFalse: [
					(newDeclarations union: oldDeclarations) do: [ :each |
						each definesContext ifTrue: [
							subcontexts add: (each optionsAt: #subcontext) ] ] ].
				self announceChangesFor: subcontexts ] ].
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

{ #category : #printing }
LzPageDeclarationCache >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self page title;
		<<$).
]

{ #category : #private }
LzPageDeclarationCache >> sortOrderFor: aClass [
	^ {
		LzSpecialTermsDeclaration -> 0.
		LzUseContextDeclaration -> 1.
		LzSortDeclaration -> 2.
		LzSubsortAxiomDeclaration -> 3.
		LzOpDeclaration -> 4.
		LzStateDeclaration -> 5.
		LzEqualityAxiomDeclaration -> 6.
		LzRewriteRuleDeclaration -> 7.
		LzFunctionRuleDeclaration -> 8.
		LzPatternDeclaration -> 9.
		LzAssetDeclaration -> 10.
	} asDictionary at: aClass
]

{ #category : #accessing }
LzPageDeclarationCache >> subcontexts [
	| subcontexts |
	subcontexts := Set new.
	declarations valuesDo: [ :eachDeclarationList |
		eachDeclarationList do: [ :eachDeclaration |
			subcontexts add: (eachDeclaration optionsAt: #subcontext) ] ].
	subcontexts remove: nil ifAbsent: [].
	^ subcontexts
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
