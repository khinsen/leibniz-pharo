Class {
	#name : #LzGlobalCache,
	#superclass : #Object,
	#traits : 'TSingleton',
	#classTraits : 'TSingleton classTrait',
	#instVars : [
		'pageDeclarations'
	],
	#category : #'Leibniz2-Lepiter'
}

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
	LzBook database pages do: [ :each |
		self pageDeclarationsFor: each ]
]

{ #category : #accessing }
LzGlobalCache >> pageDeclarationsFor: aPage [
	pageDeclarations at: aPage uid ifAbsentPut: [
		LzPageDeclarationCache new
			page: aPage;
			parsePage;
			subscribeToPageEvents;
			yourself].
	^ pageDeclarations at: aPage uid
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
