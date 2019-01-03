"
I build LeibnizContexts from a sequence of declarations
"
Class {
	#name : #LeibnizContextBuilder,
	#superclass : #Object,
	#instVars : [
		'document',
		'name',
		'phase',
		'includes',
		'sortGraph',
		'sortGraphBuilder'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizContextBuilder class >> withName: aString inDocument: aDocument [
	^ self new withName: aString inDocument: aDocument.

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> addDeclarationsFrom: aContext inMode: useOrExtend [
	self phase: #includes.
	sortGraphBuilder addSortGraph: aContext sortGraph.

]

{ #category : #defining }
LeibnizContextBuilder >> addSort: aSymbol [
	self phase: #sortGraph.
	sortGraphBuilder add: aSymbol.

]

{ #category : #defining }
LeibnizContextBuilder >> build [
	document addContext: self context.

]

{ #category : #accessing }
LeibnizContextBuilder >> context [
	"Temporary kludge"
	self phase: #finished.
	^ self
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endSortGraph [
	sortGraph := sortGraphBuilder sortGraph.

]

{ #category : #'XML-import' }
LeibnizContextBuilder >> fromXML: anXMLElement inDocument: aDocument [
	name := anXMLElement attributeAt: 'id'.
	document := aDocument.
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
LeibnizContextBuilder >> include: aContextName fromDocumentWithHash: aDocHash inMode: useOrExtend [
	| context |
	self phase: #includes.
	self validateIncludeMode: useOrExtend.
	context := LeibnizLibrary uniqueInstance contextNamed: aContextName inDocumentWithHash: aDocHash.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #document -> aDocHash
									  with: #context -> context
									  with: #mode -> useOrExtend).
	self addDeclarationsFrom: context inMode: useOrExtend.

]

{ #category : #defining }
LeibnizContextBuilder >> include: aContextName inMode: useOrExtend [
	| context |
	self validateIncludeMode: useOrExtend.
	context := document contextNamed: aContextName.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #mode -> useOrExtend
									  with: #context -> context).
	self addDeclarationsFrom: context inMode: useOrExtend.
]

{ #category : #initializing }
LeibnizContextBuilder >> initialize [
	phase := #initialization.
	includes := OrderedCollection new.
	sortGraphBuilder := LeibnizSortGraphBuilder new.

]

{ #category : #defining }
LeibnizContextBuilder >> make: aSort subsortOf: anotherSort [
	self phase:#sortGraph.
	sortGraphBuilder make: aSort subsortOf: anotherSort.
]

{ #category : #accessing }
LeibnizContextBuilder >> name [
	^ name
]

{ #category : #defining }
LeibnizContextBuilder >> name: aString [
	name := aString.

]

{ #category : #defining }
LeibnizContextBuilder >> phase: aSymbol [
	| phaseLabels current new phaseEndMethod phaseStartMethod |
	phaseLabels := #(#initialization #includes #sortGraph #operators #rules #assets #finished).
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
LeibnizContextBuilder >> sortGraph [
	^ sortGraph
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> validateIncludeMode: useOrExtend [
	self assert: (#('use' 'extend') includes: useOrExtend)
	     description: 'include mode must be "use" or "extend"'.

]

{ #category : #defining }
LeibnizContextBuilder >> withName: aString inDocument: aDocument [
	name := aString.
	document := aDocument.

]
