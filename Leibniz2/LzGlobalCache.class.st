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
	nodes := (self perform: aSelector withArguments: { aPageName }) asSet.
	[
		| numberOfRelations |
		numberOfRelations := nodes size.
		nodes addAll:
			(nodes flatCollect: [ :each |
				self perform: aSelector withArguments: { each } ]).
		nodes size > numberOfRelations
	] whileTrue.
	^ nodes
]

{ #category : #accessing }
LzGlobalCache >> recursiveClosureOf: aSelector for: aPageName [
	| allRelations |
	allRelations := (self perform: aSelector withArguments: { aPageName }) asSet.
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
