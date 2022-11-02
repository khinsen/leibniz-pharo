"
This class implements a simple computational tool that takes its main input (the equations that it solves) from a Leibniz context. It illustrates how computational tools can interface with Leibniz.

The task that this computational tool accomplishes is solving [recurrence equations](https://en.wikipedia.org/wiki/Recurrence_relation). The equations are defined in a Leibniz context with a label. The labels of the equations to be solved (one per variable) are given to this tool, which compiles them to Pharo code (this happens in {{gtMethod:name=RESequence>>compileRules}}). Parameters, such as the initial values of the recurrence sequences, can also be specified as Leibniz expressions, but also as Pharo numbers. To see how parameters are extracted from Leibniz expressions, look at {{gtMethod:name=RESequence>>stepSize:}}.

"
Class {
	#name : #RESequence,
	#superclass : #Object,
	#instVars : [
		'context',
		'rules',
		'variables',
		'sequence',
		'stepSize',
		'indexVariable',
		'parameters',
		'iterationCode'
	],
	#category : #RecurrenceEquations
}

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels initialValues: aDictionary [
	^ self new
		context: aContext;
		rules: anArrayOfAssetLabels;
		initialValues: aDictionary;
		yourself
]

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels initialValues: aDictionary indexVariable: aString stepSize: aStringOrNumber [
	^ self new
		context: aContext;
		rules: anArrayOfAssetLabels;
		initialValues: aDictionary;
		indexVariable: aString;
		stepSize: aStringOrNumber;
		yourself
]

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels parameters: anArraOfRules initialValues: initial [
	^ self new
		context: aContext;
		parameters: anArraOfRules;
		rules: anArrayOfAssetLabels;
		initialValues: initial;
		yourself
]

{ #category : #'instance creation' }
RESequence class >> context: aContext rules: anArrayOfAssetLabels parameters: anArrayOfRules initialValues: initial indexVariable: aString stepSize: aStringOrNumber [
	^ self new
		context: aContext;
		parameters: anArrayOfRules;
		rules: anArrayOfAssetLabels;
		initialValues: initial;
		indexVariable: aString;
		stepSize: aStringOrNumber
]

{ #category : #computing }
RESequence >> addSteps: anInteger [
	| index |
	iterationCode ifNil: [ self compileRules ].
	index := self numberOfSteps + 1.
	sequence := sequence grownByRows: anInteger.
	index to: self numberOfSteps do: [ :step |
		iterationCode value: sequence value: step ]
]

{ #category : #compiling }
RESequence >> assertNumber: aTerm [
	self
		assert: aTerm sort kind
		equals: (context term: '1') sort kind
]

{ #category : #initializing }
RESequence >> checkIsRecurrence: aRule [
	"Check that the rule pattern is of the form var[index]."
	| pattern variable index |
	pattern := aRule pattern.
	self assert: pattern opName equals: LzBracketOpName new.
	self assert: pattern args size equals: 2.
	variable := pattern args first.
	self assert: (variable isKindOf: LzOpTerm).
	self assert: (variable args isEmpty).
	index := pattern args second.
	self assert: (index isKindOf: LzVarTerm).
	"Check that the replacement does not contain the pattern."
	(aRule replacement contains: pattern)
		ifTrue: [ self error: 'Not a valid recurrence: ', aRule asLeibnizSyntaxString ]
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
	self sortVariables.
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
	iterationCode := Smalltalk compiler class new
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
RESequence >> gtCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Code';
		priority: 7;
		object: [ iterationCode ];
		view: #gtSourceCodeFor:.
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
RESequence >> gtVariablesFor: aView [
	<gtView>
	^ aView list
		title: 'Variables';
		priority: 6;
		items: [ variables withIndexCollect: [ :each :index |
			{ each. self lineColor: index } ] ];
		itemText: [ :each |
			each first asRopedTextColored: each second ];
		yourself
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

{ #category : #initializing }
RESequence >> indexVariable: aString [
	indexVariable := aString
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
	self
		assert: rules keys asSet
		equals: variables asSet.
	sequence := Array2D
					rows: varSequenceSizes first
					columns: variables size.
	aDictionary keys withIndexDo: [ :each :index |
		| values |
		values := (aDictionary at: each) collect: [ :eachNumber |
			self numericalValue: eachNumber ].
		sequence atColumn: index put: values ].
	sequence do: [ :each | self assert: each isNumber ]
]

{ #category : #plotting }
RESequence >> lineColor: aStringOrIndex [
	| colors |
	colors := {
		Color blue.
		Color orange.
		Color green.
		Color red.
		Color purple.
		Color brown.
		Color pink darker.
		Color gray.
		Color tan darker.
		Color cyan darker.
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
RESequence >> numericalValue: aStringOrNumber [
	^ aStringOrNumber isNumber
		ifTrue: [ aStringOrNumber ]
		ifFalse: [ (context reduce: aStringOrNumber) value ]
]

{ #category : #initializing }
RESequence >> parameters: anArrayOfRules [
	| builder |
	builder := LzContextBuilder new
				include: context.
	anArrayOfRules do: [ :each |
		builder rule: each ].
	context := builder context
]

{ #category : #plotting }
RESequence >> parametricPlot: varA with: varB [
	| data linePlot |
	data := GtPlotterDataGroup new
			values: ((self variable: varA)
						with: (self variable: varB)
						collect: [ :a :b | { a. b }]);
			colored: (self lineColor: 1).
	linePlot := GtPlotterLineChart new
		valueX: #first;
		labelFormatX: [ :each |
			each printShowingDecimalPlaces:
					(self decimalPlacesForVariable: varA) ] ;
		scaleX: GtPlotterLinearScale new;
		titleX: varA;
		ticksX: 10;
		valueY: #second;
		labelFormatY: [ :each |
			each printShowingDecimalPlaces:
					(self decimalPlacesForVariable: varB) ] ;
		scaleY: GtPlotterLinearScale new;
		titleY: varB;
		ticksY: 10;
		with: data.
	^ linePlot
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
				values: (self points: aString);
				colored: (self lineColor: 1).
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

{ #category : #printing }
RESequence >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< $(;
		<< self numberOfSteps asString;
		<< ' steps';
		<< $).
]

{ #category : #initializing }
RESequence >> rules: anArrayOfAssetLabels [
	rules := anArrayOfAssetLabels collect: [ :each |
		| rule variable |
		rule := context asset: each.
		self assert: (rule isKindOf: LzRule).
		self checkIsRecurrence: rule.
		variable := rule pattern args first .
		variable -> rule  ].
	rules := rules asDictionary
]

{ #category : #compiling }
RESequence >> sortVariables [
	| dependencies varIndices sortCriterion |
	dependencies := Dictionary new.
	variables do: [ :eachVar |
		dependencies at: eachVar put: OrderedCollection new ].
	variables do: [ :eachVar |
		rules valuesDo: [ :eachRule |
			| index indexedVar |
			index := eachRule pattern args second.
			indexedVar := context signature
							opTerm: LzBracketOpName new
							args: { eachVar. index }.
			(eachRule replacement contains: indexedVar)
				ifTrue: [ (dependencies at: eachRule pattern args first) add: eachVar ] ] ].
	sortCriterion :=  [ :a :b |
		((dependencies at: (variables at: a))
			includes: (variables at: b)) not ].
	varIndices := (1 to: variables size) sorted: sortCriterion.
	self assert: (varIndices isSortedBy: sortCriterion).
	variables := varIndices collect: [ :eachIndex |
		variables at: eachIndex ].
]

{ #category : #initializing }
RESequence >> stepSize: aStringOrNumber [
	stepSize := self numericalValue: aStringOrNumber
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
