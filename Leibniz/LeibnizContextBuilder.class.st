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
		'sortGraphBuilder',
		'sortGraph',
		'signatureBuilder',
		'signature'
	],
	#category : #'Leibniz-5-Contexts'
}

{ #category : #'instance creation' }
LeibnizContextBuilder class >> name: aString document: aDocument [
	^ self basicNew initializeWithName: aString document: aDocument.

]

{ #category : #'defining - signature' }
LeibnizContextBuilder >> addBuiltin: aSymbol [
	self phase: #signature.
	signatureBuilder addBuiltin: aSymbol
]

{ #category : #'defining - signature' }
LeibnizContextBuilder >> addOp: anOpSymbol ofSort: aSortSymbol [
	self phase: #signature.
	signatureBuilder addOp: anOpSymbol ofSort: aSortSymbol.
]

{ #category : #'defining - signature' }
LeibnizContextBuilder >> addOp: anOpSymbol withArgs: anArgList ofSort: aSortSymbol [
	self phase: #signature.
	signatureBuilder addOp: anOpSymbol withArgs: anArgList ofSort: aSortSymbol.
]

{ #category : #'defining - sort graph' }
LeibnizContextBuilder >> addSort: aSymbol [
	self phase: #sortGraph.
	sortGraphBuilder add: aSymbol.

]

{ #category : #'defining - signature' }
LeibnizContextBuilder >> addVar: aVarSymbol ofSort: aSortSymbol [
	self phase: #signature.
	signatureBuilder addVar: aVarSymbol ofSort: aSortSymbol.
]

{ #category : #accessing }
LeibnizContextBuilder >> build [
	document replaceBuilderByContextNamed: name.

]

{ #category : #accessing }
LeibnizContextBuilder >> context [
	self phase: #finished.
	^ LeibnizContext name: name sortGraph: sortGraph signature: signature.
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endIncludes [
	includes do: [ :i | sortGraphBuilder addSortGraph: (i at: #context) sortGraph ].

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endSignature [
	signature := signatureBuilder signature.

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endSortGraph [
	sortGraph := sortGraphBuilder sortGraph.

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> ensureSignature [
	self ensureSortGraph.
	signatureBuilder ifNil: [ signatureBuilder := LeibnizSignatureBuilder sortGraph: sortGraph. ].
	signature ifNil: [ signature := signatureBuilder signature ]
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> ensureSortGraph [
	sortGraph ifNil: [ sortGraph := sortGraphBuilder sortGraph ]
]

{ #category : #'XML import' }
LeibnizContextBuilder >> fromXML: anXMLElement [
	(anXMLElement elementsDetect: [:each | each isNamed: 'includes'])
		descendantElementsNamed: 'include' do:
			[ :i | | attrs |
					 attrs := i attributes.
					 (attrs includesKey: 'document')
					 ifTrue: [ self include: (attrs at: 'context')
										 fromDocumentWithHash: (attrs at: 'document')
										 inMode: (attrs at: 'mode') ]
					 ifFalse: [ self include: (attrs at: 'context')
										  inMode: (attrs at: 'mode') ] ].
	(anXMLElement elementsDetect: [:each | each isNamed: 'sorts'])
		descendantElementsNamed: 'sort' do:
			[ :sort | self addSort: (sort attributeAt: 'id') asSymbol ].
	(anXMLElement elementsDetect: [:each | each isNamed: 'subsorts'])
		descendantElementsNamed: 'subsort' do:
			[ :ss | self make: (ss attributeAt: 'subsort') asSymbol
			             subsortOf: (ss attributeAt: 'supersort') asSymbol ].
	(anXMLElement elementsDetect: [:each | each isNamed: 'vars'])
		descendantElementsNamed: 'var' do:
			[ :var | self addVar: (var attributeAt: 'id') asSymbol
							  ofSort: (var attributeAt: 'sort') asSymbol ].
	(anXMLElement elementsDetect: [:each | each isNamed: 'ops'])
		descendantElementsNamed: 'op' do:
			[ :op |
				| arityEl arity |
				arityEl := op elementsDetect: [ :each | each isNamed: 'arity' ].
				arityEl descendantElementsNamed: 'var' do:
					[ :var | self addVar: (var attributeAt: 'id') asSymbol
									  ofSort: (var attributeAt: 'sort') asSymbol ].
				arity := arityEl descendantElementsCollect:
					[ :el | el name = 'var'
								ifTrue: [ (el attributeAt: 'sort') asSymbol ]
								ifFalse: [ self assert: el name equals: 'sort'.
											  (el attributeAt: 'id') asSymbol ] ].
				self addOp: (op attributeAt: 'id') asSymbol
							 withArgs: arity asArray
							 ofSort: ((op elementsDetect: [ :each | each isNamed: 'sort' ])
											attributeAt: 'id') asSymbol].

]

{ #category : #'defining - includes' }
LeibnizContextBuilder >> include: aContextName fromDocumentWithHash: aDocHash inMode: useOrExtend [
	| context |
	context := LeibnizLibrary uniqueInstance contextNamed: aContextName inDocumentWithHash: aDocHash.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #document -> aDocHash
									  with: #context -> context
									  with: #mode -> useOrExtend).
	self validateIncludeWithMode: useOrExtend

]

{ #category : #'defining - includes' }
LeibnizContextBuilder >> include: aContextName inMode: useOrExtend [
	| context |
	context := document contextNamed: aContextName.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #mode -> useOrExtend
									  with: #context -> context).
	self validateIncludeWithMode: useOrExtend
]

{ #category : #initializing }
LeibnizContextBuilder >> initializeWithName: aString document: aDocument [
	name := aString.
	document := aDocument.
	phase := #initialization.
	includes := OrderedCollection new.
	sortGraphBuilder := LeibnizSortGraphBuilder new.

]

{ #category : #initializing }
LeibnizContextBuilder >> initializeWithXML: anXMLElement document: aDocument [
	self initializeWithName: (anXMLElement attributeAt: 'id') document: aDocument.
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

{ #category : #'defining - sort graph' }
LeibnizContextBuilder >> make: aSort subsortOf: anotherSort [
	self phase: #sortGraph.
	sortGraphBuilder make: aSort subsortOf: anotherSort.
]

{ #category : #accessing }
LeibnizContextBuilder >> name [
	^ name
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> phase: aSymbol [
	| phaseLabels current new phaseEndMethod phaseStartMethod |
	phaseLabels := #(#initialization #includes #sortGraph #signature #rules #assets #finished).
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
LeibnizContextBuilder >> startSignature [
	self ensureSortGraph.
	signatureBuilder := LeibnizSignatureBuilder sortGraph: sortGraph.
	includes do: [ :i | signatureBuilder addSignature: (i at: #context) signature
													includeVars: (i at: #mode) = 'extend' ].

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> validateIncludeWithMode: useOrExtend [
	self phase: #includes.
	self assert: (#('use' 'extend') includes: useOrExtend)
	     description: 'include mode must be "use" or "extend"'.

]
