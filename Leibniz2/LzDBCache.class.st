Class {
	#name : #LzDBCache,
	#superclass : #Object,
	#instVars : [
		'pageDeclarations',
		'pageContexts',
		'database'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #'instance creation' }
LzDBCache class >> forDatabase: anLeDatabase [
	^ self new
		database: anLeDatabase;
		yourself
]

{ #category : #accessing }
LzDBCache >> contextCacheFor: aPageOrPageName [
	| page |
	aPageOrPageName isString
		ifTrue: [ page := self database pageNamed: aPageOrPageName]
		ifFalse: [ page := aPageOrPageName ].
	pageContexts at: page uid ifAbsentPut: [
		LzPageContextCache new
			page: page;
			declarationCache: (self declarationCacheFor: page);
			subscribeToDeclarationEvents;
			yourself].
	^ pageContexts at: page uid
]

{ #category : #accessing }
LzDBCache >> contextFor: aPageOrPageName [
	^ (self contextCacheFor: aPageOrPageName) pageContext
]

{ #category : #accessing }
LzDBCache >> database [
	^ database
]

{ #category : #accessing }
LzDBCache >> database: anLeDatabase [
	self assert: database isNil.
	database := anLeDatabase.
	database pages do: [ :each |
		self declarationCacheFor: each ]
]

{ #category : #accessing }
LzDBCache >> declarationCacheFor: aPageOrPageName [
	| page |
	aPageOrPageName isString
		ifTrue: [ page := self database pageNamed: aPageOrPageName]
		ifFalse: [ page := aPageOrPageName ].
	pageDeclarations at: page uid ifAbsentPut: [
		LzPageDeclarationCache new
			page: page;
			parsePage;
			subscribeToPageEvents;
			yourself].
	^ pageDeclarations at: page uid
]

{ #category : #accessing }
LzDBCache >> dependenceGraphOf: aPageName [
	| graph nodes edges |
	graph := self recursiveClosureGraphOf: #dependenciesOf: for: aPageName.
	nodes := graph first.
	edges := graph second.
	graph := self recursiveClosureGraphOf: #dependentsOf: for: aPageName.
	nodes addAll: graph first.
	edges addAll: (graph second collect: [ :each | { each second. each first } ]).
	^ { nodes. edges }.
]

{ #category : #retrieving }
LzDBCache >> dependenciesOf: aPageName [
	^ (self declarationCacheFor: aPageName)
		useContextDeclarations collect: [ :each |
			each declaration contextName ]
]

{ #category : #retrieving }
LzDBCache >> dependentsOf: aPageName [
	^ pageDeclarations associations
		select: [ :eachAssociation |
			(eachAssociation value useContextDeclarations collect: [ :each |
				each declaration contextName ])
				includes: aPageName ]
		thenCollect: [ :eachAssociation | eachAssociation value page title ]
]

{ #category : #inspecting }
LzDBCache >> gtContextCachesFor: aView [
	<gtView>
	^ aView list
		title: 'Context caches';
		priority: 1;
		items: [ pageContexts values ];
		itemText: [ :each | each page title ];
		yourself
]

{ #category : #inspecting }
LzDBCache >> gtDeclarationCachesFor: aView [
	<gtView>
	^ aView list
		title: 'Declaration caches';
		priority: 2;
		items: [ pageDeclarations values ];
		itemText: [ :each | each page title ];
		yourself
]

{ #category : #initializing }
LzDBCache >> initialize [
	pageDeclarations := Dictionary new.
	pageContexts := Dictionary new.
]

{ #category : #accessing }
LzDBCache >> recursiveClosureGraphOf: aSelector for: aPageName [
	| nodes edges |
	nodes := Set with: aPageName.
	edges := Set new.
	[
		| numberOfNodes numberOfEdges newNodes newEdges |
		numberOfNodes := nodes size.
		numberOfEdges := edges size.
		nodes do: [ :eachNode |
			newNodes := self perform: aSelector withArguments: { eachNode }.
			newEdges := newNodes collect: [ :each | { eachNode. each } ] ].
		nodes addAll: newNodes.
		edges addAll: newEdges.
		nodes size > numberOfNodes or: [ edges size > numberOfEdges ]
	] whileTrue.
	^ { nodes. edges }
]

{ #category : #accessing }
LzDBCache >> recursiveClosureOf: aSelector for: aPageName [
	| allRelations |
	allRelations := Set with: aPageName.
	[
		| numberOfRelations |
		numberOfRelations := allRelations size.
		allRelations addAll:
			(allRelations flatCollect: [ :each |
				self perform: aSelector withArguments: { each } ]).
		allRelations size > numberOfRelations
	] whileTrue.
	^ allRelations copyWithout: aPageName
]

{ #category : #accessing }
LzDBCache >> recursiveDependenciesOf: aPageName [
	^ self recursiveClosureOf: #dependenciesOf: for: aPageName
]

{ #category : #accessing }
LzDBCache >> recursiveDependentsOf: aPageName [
	^ self recursiveClosureOf: #dependentsOf: for: aPageName
]

{ #category : #accessing }
LzDBCache >> subcontext: aSubcontextName for: aPageOrPageName [
	^ (self contextCacheFor: aPageOrPageName) subcontext: aSubcontextName
]
