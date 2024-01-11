Class {
	#name : #LzPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'term',
		'bindings',
		'report',
		'context'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzPatternMatcher >> bindings [
	^ bindings
]

{ #category : #accessing }
LzPatternMatcher >> context [
	^ context
]

{ #category : #inspecting }
LzPatternMatcher >> context: anLzContext [
	context := anLzContext
]

{ #category : #inspecting }
LzPatternMatcher >> gtBindingsFor: aView [
	<gtView>
	self bindings bindings ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Bindings';
		priority: 4;
		object: [ self bindings ];
		view: #gtBindingsFor:;
		yourself
]

{ #category : #inspecting }
LzPatternMatcher >> gtFailureFor: aView [
	<gtView>
	self bindings ifSuccess: [ ^ aView empty ].
	^ aView forward
		title: 'Failure';
		priority: 5;
		object: [ self bindings ];
		view: #gtFailureFor:;
		yourself
]

{ #category : #inspecting }
LzPatternMatcher >> gtPatternFor: aView [
	<gtView>
	^ aView forward
		title: 'Pattern';
		priority: 1;
		object: [ self patternInContext ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
LzPatternMatcher >> gtReportFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Report';
		priority: 0;
		items: [ report ];
		column: 'Item' text: [ :each | each key ];
		column: 'Pattern' text: [ :each | each value first gtDisplayText ];
		column: 'Term' text: [ :each | each value second gtDisplayText ];
		column: 'Success' text: [ :each |
			each value third ];
		send: [ :each | each value fourth ];
		yourself.
]

{ #category : #inspecting }
LzPatternMatcher >> gtTermFor: aView [
	<gtView>
	^ aView forward
		title: 'Term';
		priority: 2;
		object: [ self termInContext ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
LzPatternMatcher >> gtUnboundFor: aView [
	<gtView>
	self bindings unboundVarSets ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Unbound';
		priority: 4;
		object: [ self bindings ];
		view: #gtUnboundFor:;
		yourself
]

{ #category : #operating }
LzPatternMatcher >> match [
	bindings := self pattern match: self term.
	report := OrderedCollection
		with: #term ->
			{ self patternInContext . self termInContext . bindings isSuccess . self }.
	(self pattern isKindOf: LzVarTerm)
		ifTrue: [ self matchVar: self pattern to: self term ].
	(self pattern isKindOf: LzOpTerm)
		ifTrue: [ self matchOpTerm: self pattern to: self term ]
		ifFalse: [ (self pattern isKindOf: LzArrayTerm)
						ifTrue: [ self matchArrayTerm: self pattern to: self term ] ]
]

{ #category : #operating }
LzPatternMatcher >> matchArrayTerm: anLzArrayTerm to: anLzTerm [
	| pargs targs |
	pargs := anLzArrayTerm args.
	targs := anLzTerm args.
	report add: #numberOfElements ->
		{ pargs size . targs size . pargs size = targs size .
			{ pargs size . targs size } }.
	((anLzArrayTerm opName = anLzTerm opName)
		and: [ pargs size = targs size ])
		ifTrue: [ 1 to: pargs size do: [ :index |
			| parg targ |
			parg := pargs at: index.
			targ := targs at: index.
			report add: ('element', index asString) asSymbol ->
				{ parg . targ . (parg match: targ) isSuccess .
					LzPatternMatcher new
						context: self context;
						pattern: parg;
						term: targ } ] ]
]

{ #category : #operating }
LzPatternMatcher >> matchOpTerm: anLzOpTerm to: anLzTerm [
	| pargs targs |
	pargs := anLzOpTerm args.
	targs := anLzTerm args.
	report add: #opName ->
		{ anLzOpTerm opName . anLzTerm opName .
			anLzOpTerm opName = anLzTerm opName .
			{ anLzOpTerm opName . anLzTerm opName } }.
	report add: #numberOfArgs ->
		{ pargs size . targs size . pargs size = targs size .
			{ pargs size . targs size } }.
	((anLzOpTerm opName = anLzTerm opName)
		and: [ pargs size = targs size ])
		ifTrue: [ 1 to: pargs size do: [ :index |
			| parg targ |
			parg := pargs at: index.
			targ := targs at: index.
			report add: ('arg', index asString) asSymbol ->
				{ parg . targ . (parg match: targ) isSuccess .
				 	LzPatternMatcher new
						context: self context;
						pattern: parg;
						term: targ } ] ]
]

{ #category : #operating }
LzPatternMatcher >> matchVar: anLzVarTerm to: anLzTerm [
	report add: #sort ->
		{ anLzVarTerm sort . anLzTerm sort .
			anLzTerm sort <= anLzVarTerm sort .
			LzSortPatternMatcher new
				pattern: anLzVarTerm sort;
				term: anLzTerm sort }
]

{ #category : #accessing }
LzPatternMatcher >> pattern [
	^ pattern
]

{ #category : #accessing }
LzPatternMatcher >> pattern: anLzTerm [
	pattern := anLzTerm.
	term ifNotNil: [ self match ].
]

{ #category : #accessing }
LzPatternMatcher >> patternInContext [
	^ pattern inContext: self context
]

{ #category : #accessing }
LzPatternMatcher >> term [
	^ term
]

{ #category : #accessing }
LzPatternMatcher >> term: anLzTerm [
	 term := anLzTerm.
	 pattern ifNotNil: [ self match ].
]

{ #category : #accessing }
LzPatternMatcher >> termInContext [
	^ term inContext: self context
]
