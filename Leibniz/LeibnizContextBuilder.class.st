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
		'signature',
		'rewriteSystemBuilder',
		'rewriteSystem'
	],
	#category : #'Leibniz-6-Contexts'
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

{ #category : #'defining - rules' }
LeibnizContextBuilder >> addRule: aRule [
	self phase: #rules.
	rewriteSystemBuilder addRule: aRule
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
	^ LeibnizContext name: name sortGraph: sortGraph signature: signature rewriteSystem: rewriteSystem
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endRules [
	rewriteSystem := rewriteSystemBuilder rewriteSystem
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endSignature [
	signature := signatureBuilder signature.

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> endSortGraph [
	sortGraph := sortGraphBuilder sortGraph.

]

{ #category : #'XML import' }
LeibnizContextBuilder >> fromXML: anXMLElement [
	self includesFromXML: anXMLElement.
	self signatureFromXML: anXMLElement.
	self rulesFromXML: anXMLElement.
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

{ #category : #'XML import' }
LeibnizContextBuilder >> includesFromXML: anXMLElement [
	(anXMLElement elementsDetect: [:each | each isNamed: 'includes'])
		descendantElementsNamed: 'include' do:
			[ :i | | attrs |
					 attrs := i attributes.
					 (attrs includesKey: 'document')
					 ifTrue: [ self include: (attrs at: 'context')
										 fromDocumentWithHash: (attrs at: 'document')
										 inMode: (attrs at: 'mode') ]
					 ifFalse: [ self include: (attrs at: 'context')
										  inMode: (attrs at: 'mode') ] ]
]

{ #category : #initializing }
LeibnizContextBuilder >> initializeWithName: aString document: aDocument [
	name := aString.
	document := aDocument.
	phase := #initialization.
	includes := OrderedCollection new.

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

{ #category : #'defining - signature' }
LeibnizContextBuilder >> parseAndAddOp: aString [
	self phase: #signature.
	signatureBuilder parseAndAddOp: aString.
]

{ #category : #'defining - rules' }
LeibnizContextBuilder >> parseAndAddRule: aString [
	self phase: #rules.
	rewriteSystemBuilder parseAndAddRule: aString
]

{ #category : #'defining - sort graph' }
LeibnizContextBuilder >> parseAndAddSort: aString [
	self phase: #sortGraph.
	sortGraphBuilder parseAndAdd: aString.

]

{ #category : #'defining - signature' }
LeibnizContextBuilder >> parseAndAddVar: aString [
	self phase: #signature.
	signatureBuilder parseAndAddVar: aString.
]

{ #category : #'defining - rules' }
LeibnizContextBuilder >> parseTerm: aString [
	^ self parseTerm: aString extraVariables: Dictionary new
]

{ #category : #'defining - rules' }
LeibnizContextBuilder >> parseTerm: aString extraVariables: aDictionary [
	| parser |
	self phase: #rules.
	parser := LeibnizTermParser forSignature: signature.
	parser setExtraVariables: aDictionary.
	^ parser parse: aString
				onError: [ self error: 'Failed to parse ', aString ]
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> phase: aSymbol [
	| phaseLabels current new phaseEndMethod phaseStartMethod |

	(aSymbol = phase) ifTrue:
		[ ^ self ].

	phaseLabels := #(#initialization #includes #sortGraph #signature #rules #assets #finished).
	current := phaseLabels indexOf: phase.
	new := phaseLabels indexOf: aSymbol.
	self assert: new >= current description: 'context definition phase out of order'.
	current to: new - 1 do:
		[ :each |
			| p |
			p := (phaseLabels at: each) asString capitalized.
			phaseEndMethod := ('end', p) asSymbol.
			(self respondsTo: phaseEndMethod) ifTrue: [ self perform: phaseEndMethod ].
			p := (phaseLabels at: each + 1) asString capitalized.
			phaseStartMethod := ('start', p) asSymbol.
			(self respondsTo: phaseStartMethod) ifTrue: [ self perform: phaseStartMethod ] ].
	phase := aSymbol.

]

{ #category : #'XML import' }
LeibnizContextBuilder >> ruleFromXML: anXMLElement [
	| vars pattern conditionElements condition replacement |

	vars := Dictionary new.
	(anXMLElement elementsDetect: [:each | each isNamed: 'vars'])
		descendantElementsNamed: 'var' do:
			[ :var | vars at: (var attributeAt: 'id') asSymbol
							  put: (var attributeAt: 'sort') asSymbol ].

	pattern := self termFromXML: (anXMLElement elementsDetect: [:each | each isNamed: 'pattern'])
											descendantElements first
						 extraVariables: vars.
	conditionElements := (anXMLElement elementsDetect: [:each | each isNamed: 'condition'])
									descendantElements.
	condition := conditionElements ifEmpty: [ nil ]
										  	ifNotEmpty: [ self termFromXML: conditionElements first
																	extraVariables: vars ].
	replacement := self termFromXML: (anXMLElement elementsDetect: [:each | each isNamed: 'replacement'])
													descendantElements first
							  extraVariables: vars.

	^ LeibnizRewriteRule pattern: pattern localVariables: vars condition: condition replacement: replacement.
]

{ #category : #'XML import' }
LeibnizContextBuilder >> rulesFromXML: anXMLElement [
	self phase: #rules.
	(anXMLElement elementsDetect: [:each | each isNamed: 'rules'])
		descendantElementsNamed: 'rule' do:
			[ :rule | self addRule: (self ruleFromXML: rule) ]
]

{ #category : #accessing }
LeibnizContextBuilder >> signature [
	self phase: #rules.
	^ signature
]

{ #category : #'XML import' }
LeibnizContextBuilder >> signatureFromXML: anXMLElement [
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

{ #category : #accessing }
LeibnizContextBuilder >> sortGraph [
	self phase: #signature.
	^ sortGraph
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> startRules [
	rewriteSystemBuilder := LeibnizRewriteSystemBuilder signature: signature.
	includes do: [ :i | rewriteSystemBuilder addRewriteSystem: (i at: #context) rewriteSystem ].
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> startSignature [
	signatureBuilder := LbSignatureBuilder sortGraph: sortGraph.
	includes do: [ :i | signatureBuilder addSignature: (i at: #context) signature
													includeVars: (i at: #mode) = 'extend' ].

]

{ #category : #'defining - private' }
LeibnizContextBuilder >> startSortGraph [
	sortGraphBuilder := LbSortGraphBuilder new.
	includes do: [ :i | sortGraphBuilder addSortGraph: (i at: #context) sortGraph ].

]

{ #category : #'XML import' }
LeibnizContextBuilder >> termFromXML: anXMLElement [
	^ self termFromXML: anXMLElement extraVariables: Dictionary new
]

{ #category : #'XML import' }
LeibnizContextBuilder >> termFromXML: anXMLElement extraVariables: aDictionary [
	anXMLElement name = 'term'
		ifTrue: [ | op args |
			op := (anXMLElement attributes at: #op) asSymbol.
			args := anXMLElement elements collect:
						[ :each | self termFromXML: each extraVariables: aDictionary ].
			^ signature nonZeroArgTermNamed: op withArgs: args ].
	anXMLElement name = 'term-or-var'
		ifTrue: [ ^ signature
							zeroArgTermNamed: (anXMLElement attributes at: #name) asSymbol
							extraVariables: aDictionary ].
	self error: anXMLElement name.
]

{ #category : #'defining - private' }
LeibnizContextBuilder >> validateIncludeWithMode: useOrExtend [
	self phase: #includes.
	self assert: (#('use' 'extend') includes: useOrExtend)
	     description: 'include mode must be "use" or "extend"'.

]
