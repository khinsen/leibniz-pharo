Class {
	#name : #LbStatements,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'equations',
		'subsorts',
		'signature',
		'statements'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #'instance creation' }
LbStatements class >> signature: aSignature statements: aDictionary [
	^ self basicNew
		initializeWithSignature: aSignature
		statements: aDictionary;
		yourself
]

{ #category : #accessing }
LbStatements >> declarations [
	| declarations equationDecls |
	declarations := self signature declarations.
	#(equations subsortStatements) do: [ :each |
		| decls |
		decls := ((self perform: each)
					collect: #asLeibnizSyntaxString)
					asOrderedCollection sort.
		declarations at: each put: decls ].
	^ declarations
]

{ #category : #accessing }
LbStatements >> equations [
	^ statements at: #LbEquation
]

{ #category : #inspecting }
LbStatements >> gtDeclarationsFor: aView [
	<gtView>
	^ aView lbTree
		title: 'Declarations' translated;
		priority: 4;
		items: [ | d categories |
			d := self declarations.
			categories := OrderedCollection new.
			#(sorts subsorts variables operators
			  equations subsortStatements) do: [ :each |
				(d at: each) ifNotEmpty: [
					categories add: {
						each asString capitalized.
						(d at: each) collect: [ :aString |
							{ aString. #() } ] } ] ].
			categories ];
		itemLbCode: #first;
		children: #second;
		send: #first;
		collapseAll;
		expandItems: #('Equations' 'SubsortStatements');
		yourself
]

{ #category : #accessing }
LbStatements >> gtRulesFor: aView [
	<gtView>
	^ aView tree
		title: 'Statements' translated;
		priority: 1;
		items: [ statements keys sorted ];
		children: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ statements at: each ]
				ifFalse: [ #() ] ];
		itemLbCode: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ each ]
				ifFalse: [ each asLeibnizSyntaxString ] ];
		yourself
]

{ #category : #initialization }
LbStatements >> initializeWithSignature: aSignature statements: aDictionary [
	signature := aSignature.
	statements := aDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbStatements >> signature [
	^ signature
]

{ #category : #accessing }
LbStatements >> subsortStatements [
	^ statements at: #LbSubsortStatement
]
