Class {
	#name : #RESequence,
	#superclass : #Object,
	#instVars : [
		'context',
		'rules',
		'variables',
		'sequence',
		'block',
		'stepSize',
		'indexVariable'
	],
	#category : #RecurrenceEquations
}

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels initialValues: aDictionary [
	^ self new
		context: aContext;
		rules: anArrayOfAssetLabels;
		initialValues: aDictionary;
		checkRulesMatchVariables;
		compileRules;
		yourself
]

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels initialValues: aDictionary indexVariable: aString stepSize: aStringOrNumber [
	| seq |
	seq := self
		context: aContext
		rules: anArrayOfAssetLabels
		initialValues: aDictionary.
	seq
		indexVariable: aString;
		stepSize: aStringOrNumber.
	^ seq
]

{ #category : #computing }
RESequence >> addSteps: anInteger [
	| index |
	index := self numberOfSteps + 1.
	sequence := sequence grownByRows: anInteger.
	index to: self numberOfSteps do: [ :step |
		block value: sequence value: step ]
]

{ #category : #compiling }
RESequence >> assertNumber: aTerm [
	self
		assert: aTerm sort kind
		equals: (context term: '1') sort kind
]

{ #category : #initializing }
RESequence >> checkRulesMatchVariables [
	self
		assert: rules keys asSet
		equals: variables asSet
]

{ #category : #compiling }
RESequence >> compileRule: aRule with: aDictionary to: aStream [
	| sequenceTerm indexVar lookupTable |
	sequenceTerm := aRule pattern args first.
	indexVar := aRule pattern args second.
	lookupTable := (aDictionary associations collect: [ :each |
		each key -> ('sequence at: % at: ', each value asString) ])
		asDictionary.
	lookupTable at: indexVar put: 'n'.
	aStream << Character tab.
	self compileTerm: aRule pattern with: lookupTable to: aStream.
	aStream << ' put: ('.
	self compileTerm: aRule replacement with: lookupTable to: aStream.
	aStream << ').'; << Character cr.
]

{ #category : #compiling }
RESequence >> compileRules [
	| varMap code |
	varMap := (variables withIndexCollect: [ :v :i | v -> i ])
				asDictionary.
	code := String streamContents: [ :s |
		s
			<< '[ :sequence :n |'
			<< Character cr.
		1 to: self numberOfVariables do: [ :i |
			| rule |
			rule := rules at: (variables at: i).
			self compileRule: rule with: varMap to: s.
			s << Character cr ].
		s << ']' ].
	block := Smalltalk compiler class new
				source: code;
				evaluate
]

{ #category : #compiling }
RESequence >> compileTerm: aTerm with: lookupTable to: aStream [
	| rewritten |

	lookupTable at: aTerm ifPresent: [ :string |
		aStream << string.
		^ self ].
	"self assertNumber: aTerm."

	(aTerm opName = LzBracketOpName new) ifTrue: [
		| firstArg secondArg |
		firstArg := String streamContents: [ :s |
			self compileTerm: aTerm args first with: lookupTable to: s ].
		secondArg := String streamContents: [ :s |
			s << $(.
			self compileTerm: aTerm args second with: lookupTable to: s.
			s << $) ].
		(firstArg includes: $%)
			ifTrue: [
				aStream
					<< (firstArg copyReplaceAll: '%' with: secondArg) ]
			ifFalse: [
				aStream
					<< firstArg;
					<< ' at: ';
					<< secondArg ].
		^ self ].

	(aTerm opName isKindOf: LzInfixOpName) ifTrue: [
		aStream << $(.
		self compileTerm: aTerm args first with: lookupTable to: aStream.
		aStream << $).
		aStream << (self pharoInfixOperatorFor: aTerm opName).
		aStream << $(.
		self compileTerm: aTerm args second with: lookupTable to: aStream.
		aStream << $).
		^ self ].

	(aTerm isKindOf: LzAtomicTerm) ifTrue: [
		aStream << aTerm asLeibnizSyntaxString.
		^ self ].

	rewritten := context rewriteSystem
					rewriteHeadOnce: aTerm
					reducer: [ :t | context reduce: t].
	rewritten = aTerm
		ifFalse: [
			^ self
				compileTerm: rewritten
				with: lookupTable
				to: aStream ].
	self error: 'Cannot compile term ', aTerm asLeibnizSyntaxString
]

{ #category : #initializing }
RESequence >> context: aContext [
	self assert: (aContext isKindOf: LzContext).
	context := aContext
]

{ #category : #private }
RESequence >> decimalPlacesForIndex [
	| last tickDelta |
	last := self numberOfSteps * stepSize ifNil: [ 1 ].
	tickDelta := last / 10.
	tickDelta > 1 ifTrue: [ ^ 0 ].
	^ (tickDelta log negated round: 0) asInteger
]

{ #category : #private }
RESequence >> decimalPlacesForVariable: aString [
	| values tickDelta |
	values := self variable: aString.
	tickDelta := (values max - values min) / 10.
	tickDelta > 1 ifTrue: [ ^ 0 ].
	^ (tickDelta log negated round: 0) asInteger
]

{ #category : #inspecting }
RESequence >> gtItemsFor: aView [
	<gtView>
	| view |
	view := aView columnedList 
		title: 'Items';
		priority: 1;
		items: [
			(1 to: sequence numberOfRows) collect: [ :row |
				{ row. sequence atRow: row } ] ].
	indexVariable
		ifNil: [
			view
				column: 'Index'
					text: [ :item |
						item first asRopedText foreground: Color gray  ]
					width: 50 ]
		ifNotNil: [
			view
				column: indexVariable
					text: [ :item |
						(item first * stepSize) asRopedText foreground: Color gray  ]
					width: 50 ].
	variables withIndexDo: [ :var :i |
		view
			column: var asLeibnizSyntax
			text: [ :item | item second at: i ] ].
	^ view
]

{ #category : #inspecting }
RESequence >> gtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Plot';
		priority: 5;
		object: [ self plotAll ];
		view: #gtLiveFor:.
]

{ #category : #accessing }
RESequence >> indexVariable [

	^ indexVariable
]

{ #category : #accessing }
RESequence >> indexVariable: anObject [

	indexVariable := anObject
]

{ #category : #initializing }
RESequence >> initialValues: aDictionary [
	| varSequenceSizes |
	varSequenceSizes := aDictionary values collect: #size.
	self
		assert: varSequenceSizes asSet size
		equals: 1.
	variables := aDictionary keys collect: [ :each |
		context term: each ].
	sequence := Array2D
					rows: varSequenceSizes first
					columns: variables size.
	aDictionary keys withIndexDo: [ :each :index |
		sequence atColumn: index put: (aDictionary at: each) ].
	sequence do: [ :each | self assert: each isNumber ]
]

{ #category : #plotting }
RESequence >> lineColor: aStringOrIndex [
	| colors |
	colors := {
		Color blue.
		Color red.
		Color green.
		Color black.
		}.
	^ colors at: (self variableIndex: aStringOrIndex)
]

{ #category : #accessing }
RESequence >> numberOfSteps [
	^ sequence numberOfRows
]

{ #category : #accessing }
RESequence >> numberOfVariables [
	^ variables size
]

{ #category : #compiling }
RESequence >> pharoInfixOperatorFor: anOpName [
	| opTable |
	opTable := Dictionary
				with: '+' -> '+'
				with: '-' -> '-'
				with: '×' -> '*'
				with: '÷' -> '/'.
	^ opTable at: anOpName asLeibnizSyntaxString 
]

{ #category : #plotting }
RESequence >> plot: aString [
	| data linePlot |
	data := GtPlotterDataGroup new
		values: (self points: aString).
	linePlot := GtPlotterLineChart new
		valueX: #first;
		labelFormatX: [ :each |
			each printShowingDecimalPlaces: self decimalPlacesForIndex] ;
		scaleX: GtPlotterLinearScale new;
		titleX: (indexVariable ifNil: ['Index']);
		ticksX: 10;
		valueY: #second;
		labelFormatY: [ :each |
			each printShowingDecimalPlaces:
					(self decimalPlacesForVariable: aString) ] ;
		scaleY: GtPlotterLinearScale new;
		titleY: aString;
		ticksY: 10;
		with: data.
	^ linePlot
]

{ #category : #plotting }
RESequence >> plotAll [
	| data linePlot |
	data := self plotterDataGroup.
	linePlot := GtPlotterLineChart new
		valueX: #first;
		labelFormatX: [ :each |
			each printShowingDecimalPlaces: self decimalPlacesForIndex] ;
		scaleX: GtPlotterLinearScale new;
		titleX: (indexVariable ifNil: ['Index']);
		ticksX: 10;
		valueY: #second;
		labelFormatY: [ :each |
			each printShowingDecimalPlaces:
					1 ] ;
		scaleY: GtPlotterLinearScale new;
		ticksY: 10;
		with: data.
	^ linePlot
]

{ #category : #accessing }
RESequence >> plotterDataGroup [
	^ GtPlotterDataGroups new
		entities: (variables withIndexCollect: [ :each :index |
			((GtPlotterDataGroup new
				values: (self points: index))
				labelled: each asLeibnizSyntaxString)
				colored: (self lineColor: index) ])
]

{ #category : #accessing }
RESequence >> points: aStringOrIndex [
	^ indexVariable ifNil: [
		(self variable: aStringOrIndex) withIndexCollect: [ :each :index |
			{ index. each } ] ]
		ifNotNil: [
			(self variable: aStringOrIndex) withIndexCollect: [ :each :index |
				{ index * stepSize. each } ] ]
]

{ #category : #initializing }
RESequence >> rules: anArrayOfAssetLabels [
	rules := anArrayOfAssetLabels collect: [ :each |
		| rule pattern variable index |
		rule := context asset: each.
		self assert: (rule isKindOf: LzRule).
		pattern := rule pattern.
		self assert: pattern opName equals: LzBracketOpName new.
		self assert: pattern args size equals: 2.
		variable := pattern args first.
		self assert: (variable isKindOf: LzOpTerm).
		self assert: (variable args isEmpty).
		index := pattern args second.
		self assert: (index isKindOf: LzVarTerm).
		variable -> rule  ].
	rules := rules asDictionary
]

{ #category : #accessing }
RESequence >> stepSize: aStringOrNumber [
	aStringOrNumber isNumber
		ifTrue: [ stepSize := aStringOrNumber ]
		ifFalse: [ stepSize := (context reduce: aStringOrNumber) value ]
]

{ #category : #accessing }
RESequence >> variable: aStringOrIndex [
	| index |
	index := self variableIndex: aStringOrIndex.
	index = 0 ifTrue: [ self error: 'No variable ' , aStringOrIndex ].
	^ sequence atColumn: index
]

{ #category : #accessing }
RESequence >> variableIndex: aStringOrIndex [
	^ aStringOrIndex isNumber
		ifTrue: [ aStringOrIndex ]
		ifFalse: [ variables indexOf: (context term: aStringOrIndex) ]
]
