"
I build LeibnizContexts from a sequence of declarations
"
Class {
	#name : #LbContextBuilder,
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
		'rewriteSystem',
		'statements',
		'statementsBuilder'
	],
	#category : #'Leibniz-6-Contexts'
}

{ #category : #'instance creation' }
LbContextBuilder class >> name: aString [
	^ self name: aString document: nil
]

{ #category : #'instance creation' }
LbContextBuilder class >> name: aString document: aDocument [
	^ self basicNew initializeWithName: aString document: aDocument
]

{ #category : #'defining - signature' }
LbContextBuilder >> addBuiltin: aSymbol [
	self phase: #signature.
	signatureBuilder addBuiltin: aSymbol
]

{ #category : #'defining - signature' }
LbContextBuilder >> addOp: anOpName ofSort: aSort [
	self phase: #signature.
	signatureBuilder addOp: anOpName ofSort: aSort.
]

{ #category : #'defining - signature' }
LbContextBuilder >> addOp: anOpName withArgs: anArgList ofSort: aSort [
	self phase: #signature.
	signatureBuilder addOp: anOpName withArgs: anArgList ofSort: aSort.
]

{ #category : #'defining - rules' }
LbContextBuilder >> addRule: aRule [
	self phase: #rulesAndStatements.
	rewriteSystemBuilder addRule: aRule
]

{ #category : #'defining - sort graph' }
LbContextBuilder >> addSort: aSymbol [
	self phase: #sortGraph.
	sortGraphBuilder add: aSymbol.
]

{ #category : #'defining - signature' }
LbContextBuilder >> addVar: anOpName ofSort: aSort [
	self phase: #signature.
	signatureBuilder addVar: anOpName ofSort: aSort.
]

{ #category : #accessing }
LbContextBuilder >> build [
	document replaceBuilderByContextNamed: name
]

{ #category : #accessing }
LbContextBuilder >> context [
	self phase: #finished.
	^ LbContext
		name: name
		signature: signature
		rewriteSystem: rewriteSystem
		statements: statements
]

{ #category : #'defining - private' }
LbContextBuilder >> endRulesAndStatements [
	rewriteSystem := rewriteSystemBuilder rewriteSystem.
	statements := statementsBuilder statements
]

{ #category : #'defining - private' }
LbContextBuilder >> endSignature [
	signature := signatureBuilder signature.

]

{ #category : #'defining - private' }
LbContextBuilder >> endSortGraph [
	sortGraph := sortGraphBuilder sortGraph.

]

{ #category : #'XML import' }
LbContextBuilder >> fromXML: anXMLElement [
	self includesFromXML: anXMLElement.
	self signatureFromXML: anXMLElement.
	self rulesFromXML: anXMLElement.
]

{ #category : #inspecting }
LbContextBuilder >> gtDeclarationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Declarations' translated;
		priority: 4;
		object: [ self copy context ];
		view: #gtDeclarationsFor:;
		yourself
]

{ #category : #accessing }
LbContextBuilder >> gtOperatorsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 1;
		object: [ self copy context ];
		view: #gtOperatorsFor:
]

{ #category : #inspecting }
LbContextBuilder >> gtRulesFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Rules';
		priority: 3;
		object: [ self copy context ];
		view: #gtRulesFor:
]

{ #category : #inspecting }
LbContextBuilder >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ self copy context ];
		view: #gtSortGraphFor:
]

{ #category : #inspecting }
LbContextBuilder >> gtVariablesFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Variables';
		priority: 2;
		object: [ self copy context ];
		view: #gtVariablesFor:
]

{ #category : #'defining - includes' }
LbContextBuilder >> include: aContextName fromDocumentWithHash: aDocHash inMode: useOrExtend [
	| context |
	context := LeibnizLibrary uniqueInstance contextNamed: aContextName inDocumentWithHash: aDocHash.
	includes add: (Dictionary with: #contextName -> aContextName
									  with: #document -> aDocHash
									  with: #context -> context
									  with: #mode -> useOrExtend).
	self validateIncludeWithMode: useOrExtend

]

{ #category : #'defining - includes' }
LbContextBuilder >> include: aContextOrName inMode: useOrExtend [
	| context |
	aContextOrName isString
		ifTrue: [ context := document contextNamed: aContextOrName ]
		ifFalse: [ context := aContextOrName ].
	includes add:
		(Dictionary
			with: #contextName -> aContextOrName
			with: #mode -> useOrExtend
			with: #context -> context).
	self validateIncludeWithMode: useOrExtend
]

{ #category : #'XML import' }
LbContextBuilder >> includesFromXML: anXMLElement [
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
LbContextBuilder >> initializeWithName: aString document: aDocument [
	name := aString.
	document := aDocument.
	phase := #initialization.
	includes := OrderedCollection new.
]

{ #category : #'defining - sort graph' }
LbContextBuilder >> make: aSort subsortOf: anotherSort [
	self phase: #sortGraph.
	sortGraphBuilder make: aSort subsortOf: anotherSort.
]

{ #category : #accessing }
LbContextBuilder >> name [
	^ name
]

{ #category : #'defining - signature' }
LbContextBuilder >> parseAndAddOp: aString [
	self phase: #signature.
	signatureBuilder parseAndAddOp: aString.
]

{ #category : #'defining - rules' }
LbContextBuilder >> parseAndAddRule: aString [
	self phase: #rulesAndStatements.
	rewriteSystemBuilder parseAndAddRule: aString
]

{ #category : #'defining - sort graph' }
LbContextBuilder >> parseAndAddSort: aString [
	self phase: #sortGraph.
	sortGraphBuilder parseAndAdd: aString.

]

{ #category : #accessing }
LbContextBuilder >> parseAndAddStatement: aString [
	self phase: #rulesAndStatements.
	statementsBuilder parseAndAdd: aString
]

{ #category : #'defining - signature' }
LbContextBuilder >> parseAndAddVar: aString [
	self phase: #signature.
	signatureBuilder parseAndAddVar: aString.
]

{ #category : #'defining - rules' }
LbContextBuilder >> parseTerm: aString [
	^ self parseTerm: aString extraVariables: Dictionary new
]

{ #category : #'defining - rules' }
LbContextBuilder >> parseTerm: aString extraVariables: aDictionary [
	| parser |
	self phase: #rulesAndStatements.
	parser := LbTermParser signature: signature.
	parser extraVariables: aDictionary.
	^ parser parse: aString
				onError: [ self error: 'Failed to parse ', aString ]
]

{ #category : #'defining - private' }
LbContextBuilder >> phase: aSymbol [
	| phaseLabels current new phaseEndMethod phaseStartMethod |

	(aSymbol = phase) ifTrue:
		[ ^ self ].

	phaseLabels := #(#initialization #includes #sortGraph #signature #rulesAndStatements #assets #finished).
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
LbContextBuilder >> ruleFromXML: anXMLElement [
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

	^ LbRewriteRule pattern: pattern localVariables: vars condition: condition replacement: replacement.
]

{ #category : #'XML import' }
LbContextBuilder >> rulesFromXML: anXMLElement [
	self phase: #rulesAndStatements.
	(anXMLElement elementsDetect: [:each | each isNamed: 'rules'])
		descendantElementsNamed: 'rule' do:
			[ :rule | self addRule: (self ruleFromXML: rule) ]
]

{ #category : #accessing }
LbContextBuilder >> signature [
	self phase: #rulesAndStatements.
	^ signature
]

{ #category : #'XML import' }
LbContextBuilder >> signatureFromXML: anXMLElement [
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
LbContextBuilder >> sortGraph [
	self phase: #signature.
	^ sortGraph
]

{ #category : #'defining - private' }
LbContextBuilder >> startRulesAndStatements [
	rewriteSystemBuilder := LbRewriteSystemBuilder signature: signature.
	statementsBuilder := LbStatementsBuilder signature: signature.
	includes do: [ :i |
		rewriteSystemBuilder
			addRewriteSystem: (i at: #context) rewriteSystem
			origin: (i at: #context).
		statementsBuilder
			addStatements: (i at: #context) statements
			origin: (i at: #context) ]
]

{ #category : #'defining - private' }
LbContextBuilder >> startSignature [
	signatureBuilder := LbSignatureBuilder sortGraph: sortGraph.
	includes do: [ :i |
		signatureBuilder
			addSignature: (i at: #context) signature
			includeVars: (i at: #mode) = 'extend'
			origin: (i at: #context) ]
]

{ #category : #'defining - private' }
LbContextBuilder >> startSortGraph [
	sortGraphBuilder := LbSortGraphBuilder new.
	includes do: [ :i | 
		sortGraphBuilder
			addSortGraph: (i at: #context) sortGraph
			origin: (i at: #context) ]
]

{ #category : #'XML import' }
LbContextBuilder >> termFromXML: anXMLElement [
	^ self termFromXML: anXMLElement extraVariables: Dictionary new
]

{ #category : #'XML import' }
LbContextBuilder >> termFromXML: anXMLElement extraVariables: aDictionary [
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
LbContextBuilder >> validateIncludeWithMode: useOrExtend [
	self phase: #includes.
	self assert: (#('use' 'extend') includes: useOrExtend)
	     description: 'include mode must be "use" or "extend"'.

]
