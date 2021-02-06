Class {
	#name : #LbDualNamespaceVariables,
	#superclass : #LbVariables,
	#instVars : [
		'right',
		'left',
		'currentNamespace',
		'namespaces'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #initialization }
LbDualNamespaceVariables >> initialize [
	super initialize.
	currentNamespace := #left.
	namespaces := Dictionary
					with: #left -> Set new
					with: #right -> Set new.
]

{ #category : #accessing }
LbDualNamespaceVariables >> namespace: aSymbol [
	^ namespaces at: aSymbol
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> registerVar: aSymbol ofSort: aSort [
	(namespaces at: currentNamespace) add: aSymbol.
	super registerVar: aSymbol ofSort: aSort
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> switchNamespaces [
	currentNamespace = #left
		ifTrue: [ currentNamespace := #right ]
		ifFalse: [ currentNamespace := #left ]
]

{ #category : #'api - binding' }
LbDualNamespaceVariables >> switchToNamespace: aSymbol [
	self assert: (#(left right) includes: aSymbol).
	currentNamespace := aSymbol.
]
