"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'document',
		'name',
		'phase',
		'includes',
		'sortGraph'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizContext class >> withName: aString inDocument: aDocument [
	^ self new withName: aString inDocument: aDocument.

]

{ #category : #defining }
LeibnizContext >> addSort: aSymbol [
	self phase: #sortGraph.
	sortGraph add: aSymbol.

]

{ #category : #defining }
LeibnizContext >> endIncludes [
	sortGraph := includes inject: (LeibnizSortGraph new) into: [ :sg :i | sg union: (i at: #context) sortGraph ].

]

{ #category : #'XML-import' }
LeibnizContext >> fromXML: anXMLElement inDocument: aDocument [
	name := anXMLElement attributeAt: 'id'.
	anXMLElement descendantElementsNamed: 'include' do:
		[ :i | | attrs |
				 attrs := i attributes.
				 (attrs includesKey: 'document')
				 ifTrue: [ self include: (attrs at: 'context')
									 fromDocumentWithHash: (attrs at: 'document')
									 inMode: (attrs at: 'mode') ]
				 ifFalse: [ self include: (attrs at: 'context')
									  inMode: (attrs at: 'mode') ] ].
	anXMLElement descendantElementsNamed: 'sort' do:
		[ :sort | self addSort: (sort attributeAt: 'id') asSymbol].
	anXMLElement descendantElementsNamed: 'subsort' do:
		[ :ss | self make: (ss attributeAt: 'subsort') asSymbol
		             subsortOf: (ss attributeAt: 'supersort') asSymbol].

]

{ #category : #defining }
LeibnizContext >> include: aContextName fromDocumentWithHash: aDocHash inMode: useOrExtend [
	| context |
	self phase: #includes.
	self validateIncludeMode: useOrExtend.
	context := LeibnizLibrary uniqueInstance contextNamed: aContextName inDocumentWithHash: aDocHash.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #document -> aDocHash
									  with: #context -> context
									  with: #mode -> useOrExtend).

]

{ #category : #defining }
LeibnizContext >> include: aContextName inMode: useOrExtend [
	| context |
	self phase: #includes.
	self validateIncludeMode: useOrExtend.
	context := document contextNamed: aContextName.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #mode -> useOrExtend
									  with: #context -> context).


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
	| phaseLabels current new phaseEndMethod phaseStartMethod |
	phaseLabels := #(#initialization #includes #sortGraph #operators #rules #assets).
	current := phaseLabels indexOf: phase.
	new := phaseLabels indexOf: aSymbol.
	(new ~= current) ifTrue:
		[ self assert: new >= current description: 'context definition phase out of order'.
		  phaseEndMethod := ('end', (phase asString capitalized)) asSymbol.
		  (self respondsTo: phaseEndMethod) ifTrue: [ self perform: phaseEndMethod ].
		  phaseStartMethod := ('start', (aSymbol asString capitalized)) asSymbol.
		  (self respondsTo: phaseStartMethod) ifTrue: [ self perform: phaseStartMethod ] ].
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

{ #category : #defining }
LeibnizContext >> withIncludesDo: aBlock [
	includes do: [ :i | aBlock value: (i at: #document ifAbsent: nil)
										value: (i at: #context)
										value: (i at: #mode) ]

]

{ #category : #defining }
LeibnizContext >> withName: aString inDocument: aDocument [
	name := aString.
	document := aDocument.

]
