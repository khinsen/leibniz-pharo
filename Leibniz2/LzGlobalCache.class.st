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
LzGlobalCache >> recursiveDependentsOf: aPageName [
	| allDependents |
	allDependents := (self dependentsOf: aPageName) asSet.
	[
		| numberOfDependents |
		numberOfDependents := allDependents size.
		allDependents addAll:
			(allDependents flatCollect: [ :each |
				self dependentsOf: each ]).
		allDependents size > numberOfDependents
	] whileTrue.
	^ allDependents
]
