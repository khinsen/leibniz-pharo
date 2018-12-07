"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'phase',
		'includes',
		'sortGraph'
	],
	#category : #Leibniz
}

{ #category : #defining }
LeibnizContext >> addSort: aSymbol [
	self phase: #sortGraph.
	sortGraph add: aSymbol.

]

{ #category : #'XML-import' }
LeibnizContext >> fromXML: anXMLElement [
	name := anXMLElement attributeAt: 'id'.
	anXMLElement descendantElementsNamed: 'sort' do:
		[ :sort | sortGraph add: (sort attributeAt: 'id') asSymbol].
	anXMLElement descendantElementsNamed: 'subsort' do:
		[ :ss | sortGraph make: (ss attributeAt: 'subsort') asSymbol
		                  subsortOf: (ss attributeAt: 'supersort') asSymbol].
	anXMLElement descendantElementsNamed: 'include' do:
		[ :i | includes add: (Dictionary
					with: #mode -> (i attributeAt: 'mode')
					with: #context -> (i attributeAt: 'context')
					with: #document -> (i attributeAt: 'document')) ].

]

{ #category : #defining }
LeibnizContext >> include: aContextName fromDocument: aDocHash inMode: useOrExtend [
	self phase: #includes.
	self validateIncludeMode: useOrExtend.
	includes add: (Dictionary with: #context -> aContextName
									  with: #document -> aDocHash
									  with: #mode -> useOrExtend).

]

{ #category : #defining }
LeibnizContext >> include: aContextName inMode: useOrExtend [
	self phase: #includes.
	self validateIncludeMode: useOrExtend.
	includes add: (Dictionary with: #context -> aContextName
									  with: #mode -> useOrExtend).

]

{ #category : #initializing }
LeibnizContext >> initialize [
	phase := #initialization.
	includes := OrderedCollection new.
	sortGraph := LeibnizSortGraph new.


]

{ #category : #defining }
LeibnizContext >> make: aSort subsortOf: anotherSort [
	self phase:#sortGraph.
	sortGraph make: aSort subsortOf: anotherSort.
]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]

{ #category : #defining }
LeibnizContext >> name: aString [
	name := aString.

]

{ #category : #defining }
LeibnizContext >> phase: aSymbol [
	| phaseLabels current new |
	phaseLabels := #(#initialization #includes #sortGraph #operators #rules #assets).
	current := phaseLabels indexOf: phase.
	new := phaseLabels indexOf: aSymbol.
	self assert: new >= current description: 'context definition phase out of order'.
	phase := aSymbol.

]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]

{ #category : #defining }
LeibnizContext >> validateIncludeMode: useOrExtend [
	self assert: (#('use' 'extend') includes: useOrExtend)
	     description: 'include mode must be "use" or "extend"'.

]
