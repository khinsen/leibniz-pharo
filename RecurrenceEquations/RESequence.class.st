Class {
	#name : #RESequence,
	#superclass : #Object,
	#instVars : [
		'context',
		'rules',
		'variables',
		'sequence'
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
		checkRulesMatchInitialValues;
		yourself
]

{ #category : #computing }
RESequence >> addSteps: anInteger [
	| index |
	index := self numberOfSteps + 1.
	sequence := sequence grownByRows: anInteger.
	index to: self numberOfSteps do: [ :step |
		self computeStep: step ]
]

{ #category : #verifying }
RESequence >> checkRulesMatchInitialValues [
]

{ #category : #initializing }
RESequence >> checkRulesMatchVariables [
	self
		assert: rules keys asSet
		equals: variables asSet
]

{ #category : #computing }
RESequence >> computeStep: n [
	1 to: self numberOfVariables do: [ :i |
		sequence at: n at: i
			put: ((sequence at: n - 1 at: i)
					+ (sequence at: n - 1 at: i)) ]
]

{ #category : #initializing }
RESequence >> context: aContext [
	self assert: (aContext isKindOf: LzContext).
	context := aContext
]

{ #category : #inspecting }
RESequence >> gtItemsFor: aView [
	<gtView>
	| view |
	view := aView columnedList 
		title: 'Items';
		priority: 1;
		items: [ sequence rowsCollect: [ :row | row ] ].
	variables withIndexDo: [ :var :i |
		view
			column: var asLeibnizSyntax
			text: [ :item | item at: i ] ].
	^ view
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

{ #category : #accessing }
RESequence >> numberOfSteps [
	^ sequence numberOfRows
]

{ #category : #accessing }
RESequence >> numberOfVariables [
	^ variables size
]

{ #category : #initializing }
RESequence >> rules: anArrayOfAssetLabels [
	rules := anArrayOfAssetLabels collect: [ :each |
		| rule pattern variable index |
		rule := context asset: each.
		self assert: (rule isKindOf: LzRule).
		pattern := rule pattern.
		self assert: pattern args size equals: 2.
		variable := pattern args first.
		self assert: (variable isKindOf: LzOpTerm).
		self assert: (variable args isEmpty).
		index := pattern args second.
		self assert: (index isKindOf: LzVarTerm).
		variable -> rule  ].
	rules := rules asDictionary
]
