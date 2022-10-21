Class {
	#name : #LzGlobalCache,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'pageDeclarations',
		'pageContexts'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzGlobalCache >> contextCacheFor: aPageOrPageName [
	| page |
	page := aPageOrPageName asLzPage.
	pageContexts at: page uid ifAbsentPut: [
		LzPageContextCache new
			page: page;
			declarationCache: (self declarationCacheFor: page);
			subscribeToDeclarationEvents;
			yourself].
	^ pageContexts at: page uid
]

{ #category : #accessing }
LzGlobalCache >> contextFor: aPageOrPageName [
	^ (self contextCacheFor: aPageOrPageName) pageContext
]

{ #category : #accessing }
LzGlobalCache >> declarationCacheFor: aPageOrPageName [
	| page |
	page := aPageOrPageName asLzPage.
	pageDeclarations at: page uid ifAbsentPut: [
		LzPageDeclarationCache new
			page: page;
			parsePage;
			subscribeToPageEvents;
			yourself].
	^ pageDeclarations at: page uid
]

{ #category : #accessing }
LzGlobalCache >> dependenceGraphOf: aPageName [
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
LzGlobalCache >> dependenciesOf: aPageName [
	^ (self declarationCacheFor: aPageName)
		useContextDeclarations collect: [ :each |
			each declaration contextName ]
]

{ #category : #retrieving }
LzGlobalCache >> dependentsOf: aPageName [
	^ pageDeclarations associations
		select: [ :eachAssociation |
			(eachAssociation value useContextDeclarations collect: [ :each |
				each declaration contextName ])
				includes: aPageName ]
		thenCollect: [ :eachAssociation | eachAssociation value page title ]
]

{ #category : #inspecting }
LzGlobalCache >> gtContextCachesFor: aView [
	<gtView>
	^ aView list
		title: 'Context caches';
		priority: 1;
		items: [ pageContexts values ];
		itemText: [ :each | each page title ];
		yourself
]

{ #category : #inspecting }
LzGlobalCache >> gtDeclarationCachesFor: aView [
	<gtView>
	^ aView list
		title: 'Declaration caches';
		priority: 2;
		items: [ pageDeclarations values ];
		itemText: [ :each | each page title ];
		yourself
]

{ #category : #initializing }
LzGlobalCache >> initialize [
	pageDeclarations := Dictionary new.
	pageContexts := Dictionary new.
	LzBook database pages do: [ :each |
		self declarationCacheFor: each ]
]

{ #category : #accessing }
LzGlobalCache >> recursiveClosureGraphOf: aSelector for: aPageName [
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
LzGlobalCache >> recursiveClosureOf: aSelector for: aPageName [
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
	^ allRelations
]

{ #category : #accessing }
LzGlobalCache >> recursiveDependenciesOf: aPageName [
	^ self recursiveClosureOf: #dependenciesOf: for: aPageName
]

{ #category : #accessing }
LzGlobalCache >> recursiveDependentsOf: aPageName [
	^ self recursiveClosureOf: #dependentsOf: for: aPageName
]

{ #category : #accessing }
LzGlobalCache >> subcontext: aSubcontextName for: aPageOrPageName [
	^ (self contextCacheFor: aPageOrPageName) subcontext: aSubcontextName
]
