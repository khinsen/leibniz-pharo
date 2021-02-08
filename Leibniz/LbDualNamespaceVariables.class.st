Class {
	#name : #LbDualNamespaceVariables,
	#superclass : #LbVariables,
	#instVars : [
		'currentNamespace',
		'namespaces',
		'prefixes'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'api - binding' }
LbDualNamespaceVariables >> bindVar: aSymbol ofSort: aSort to: aTerm [
	super
		bindVar: (self namespacedName: aSymbol)
		ofSort: aSort
		to: aTerm
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> defineVar: aSymbol ofSort: aSort [
	| fullName |
	fullName := self namespacedName: aSymbol.
	(namespaces at: currentNamespace) at: aSymbol put: fullName.
	super defineVar: fullName ofSort: aSort
]

{ #category : #initialization }
LbDualNamespaceVariables >> initialize [
	super initialize.
	currentNamespace := #left.
	namespaces := Dictionary new.
	prefixes := Dictionary new.
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> makeVar: aSymbol ofSort: aSort equalToVar: anotherSymbol ofSort: anotherSort namespace: namespaceSymbol [
	super
		makeVar: (self namespacedName: aSymbol)
		ofSort: aSort
		equalToVar: (self prefix: anotherSymbol forNamespace: namespaceSymbol)
		ofSort: anotherSort
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> namespace: aSymbol [
	namespaces at: aSymbol ifAbsentPut: [ Dictionary new ].
	currentNamespace := aSymbol.
]

{ #category : #accessing }
LbDualNamespaceVariables >> namespacedName: aSymbol [
	^ self prefix: aSymbol forNamespace: currentNamespace
]

{ #category : #initialization }
LbDualNamespaceVariables >> prefix: anAssociation [
	prefixes at: anAssociation key ifAbsentPut: [ anAssociation value ].
	self assert: (prefixes at: anAssociation key) equals: anAssociation value
]

{ #category : #accessing }
LbDualNamespaceVariables >> prefix: aSymbol forNamespace: namespaceSymbol [
	prefixes at: namespaceSymbol
		ifPresent: [ :prefix | ^ (prefix, '.', aSymbol asSymbol) asLbOperatorName ]
		ifAbsent: [ ^ aSymbol ]
]

{ #category : #accessing }
LbDualNamespaceVariables >> varsInNamespace: aSymbol [
	^ (namespaces at: aSymbol) values asSet
]
