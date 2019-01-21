"
I represent the signature of a Leibniz context.
"
Class {
	#name : #LeibnizSignature,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'operators',
		'variables'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LeibnizSignature class >> sortGraph: aSortGraph operators: anOperatorDictionary variables: aVariableDictionary [
	^ self basicNew
			 initializeWithSortGraph: aSortGraph
								operators: anOperatorDictionary
								variables: aVariableDictionary;
			 yourself.

]

{ #category : #inspecting }
LeibnizSignature >> childrenInInspector [
	^Array new.
]

{ #category : #copying }
LeibnizSignature >> copy [
	^self
]

{ #category : #copying }
LeibnizSignature >> deepCopy [
	^self
]

{ #category : #inspecting }
LeibnizSignature >> gtInspectorOperatorsIn: composite [
	"Show a list of all variables"

	<gtInspectorPresentationOrder: 0>
	composite fastTable 
		title: 'Operators';
		display: [ operators flatCollect: [ :each | each values ] ];
		column: 'Operator' evaluated: #title;
		column: 'Kind' evaluated:
			[ :each | String streamContents: [ :s | (each kind printAsLeibnizSyntaxOn: s) ] ];
		column: 'Ranks' evaluated: [ :each | each size asString ];
		when: [ operators isNotEmpty ]
]

{ #category : #inspecting }
LeibnizSignature >> gtInspectorVariablesIn: composite [
	"Show a list of all variables"

	<gtInspectorPresentationOrder: 1>
	composite fastTable 
		title: 'Variables';
		display: [ variables associations sorted: [ :v1 :v2 | v1 key < v2 key ] ] ;
		column: 'Name' evaluated: [ :each | each key asString ];
		column: 'Sort' evaluated: [ :each | each value asString ];
		when: [ variables isNotEmpty ]
]

{ #category : #initializing }
LeibnizSignature >> initializeWithSortGraph: aSortGraph operators: anOperatorDictionary variables: aVariableDictionary [
	sortGraph := aSortGraph.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	self beRecursivelyReadOnlyObject.

]

{ #category : #accessing }
LeibnizSignature >> numberOfOperators [
	^operators size
]

{ #category : #accessing }
LeibnizSignature >> numberOfVariables [
	^variables size
]

{ #category : #inspecting }
LeibnizSignature >> title [
	^'signature'

]

{ #category : #enumerating }
LeibnizSignature >> withOperatorsDo: aBlock [
	operators keysAndValuesDo:
		[ :symbol :byKindArity |
		  byKindArity keysAndValuesDo:
			[ :kindArity :operator |
			  operator withRanksDo:
				[ :args :sort |
				  aBlock value: symbol value: args asArgSorts value: sort ]]]

]

{ #category : #enumerating }
LeibnizSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v | aBlock value: v key value: v value ]

]

{ #category : #'term construction' }
LeibnizSignature >> zeroArgTermNamed: aSymbol [
	variables at: aSymbol
		ifPresent: [ :sort | ^ LeibnizVarTerm symbol: aSymbol sort: sort forSignature: self ].
	operators at: aSymbol
		ifPresent: [ :ops | ops at: (LeibnizArity sortGraph: sortGraph size: 0)
									ifPresent: [ :op | ^ LeibnizOpTerm symbol: aSymbol args: #()
																				 sort: (op sortForArity: #())
																				 forSignature: self ]
									ifAbsent: [ ^ nil ] ]
		ifAbsent: [ ^ nil ].

]
