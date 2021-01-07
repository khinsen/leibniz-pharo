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
LbStatements >> allDeclarations [
	^ self signature declarations union: self declarations
]

{ #category : #copying }
LbStatements >> copy [
	^ self
]

{ #category : #accessing }
LbStatements >> declarations [
	| declarations equationDecls |
	declarations := Dictionary new.
	#(equations subsortStatements) do: [ :each |
		declarations
			at: each
			put: ((self perform: each)
					collect: #asLeibnizSyntaxString)
						asOrderedCollection sort ].
	^ declarations
]

{ #category : #copying }
LbStatements >> deepCopy [
	^ self
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
			d := self allDeclarations.
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
LbStatements >> gtStatementsFor: aView [
	<gtView>
	^ aView tree
		title: 'Statements' translated;
		priority: 1;
		items: [ statements keys sorted
					reject: [ :each |
						(statements at: each) isEmpty ]];
		children: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ statements at: each ]
				ifFalse: [ #() ] ];
		itemLbCode: [ :each |
			(each isKindOf: Symbol)
				ifTrue: [ each ]
				ifFalse: [ each asLeibnizSyntaxString ] ];
		expandAll;
		yourself
]

{ #category : #initialization }
LbStatements >> initializeWithSignature: aSignature statements: aDictionary [
	signature := aSignature.
	statements := aDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #testing }
LbStatements >> isEmpty [
	statements values do: [ :each |
		each ifNotEmpty: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
LbStatements >> signature [
	^ signature
]

{ #category : #accessing }
LbStatements >> subsortStatements [
	^ statements at: #LbSubsortStatement
]
