"
I represent a context in a Leibniz document.
"
Class {
	#name : #LbContext,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'name',
		'sortGraph',
		'signature',
		'rewriteSystem',
		'statements'
	],
	#category : #'Leibniz-6-Contexts'
}

{ #category : #'instance creation' }
LbContext class >> name: aString signature: aSignature rewriteSystem: aRewriteSystem [
	^ self
		name: aString
		signature: aSignature
		rewriteSystem: aRewriteSystem
		statements: (LbStatementsBuilder signature: aSignature) statements
]

{ #category : #'instance creation' }
LbContext class >> name: aString signature: aSignature rewriteSystem: aRewriteSystem statements: anLbStatements [
	^ self basicNew
			 initializeWithName: aString
			 signature: aSignature
			 rewriteSystem: aRewriteSystem
			 statements: anLbStatements;
			 yourself
]

{ #category : #copying }
LbContext >> copy [
	^ self
]

{ #category : #accessing }
LbContext >> declarations [
	^ rewriteSystem allDeclarations union: statements declarations
]

{ #category : #copying }
LbContext >> deepCopy [
	^ self
]

{ #category : #inspecting }
LbContext >> gtDeclarationsFor: aView [
	<gtView>
	^ aView tree
		title: 'Declarations' translated;
		priority: 4;
		items: [ | d categories |
			d := self declarations.
			categories := OrderedCollection new.
			#(sorts subsorts variables operators rules equations subsortStatements) do: [ :each |
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
		yourself
]

{ #category : #inspecting }
LbContext >> gtOperatorsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 1;
		object: [ signature ];
		view: #gtOperatorsFor:
]

{ #category : #inspecting }
LbContext >> gtRulesFor: aView [ 
	<gtView>
	rewriteSystem isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Rules';
		priority: 3;
		object: [ rewriteSystem ];
		view: #gtRulesFor:
]

{ #category : #inspecting }
LbContext >> gtSortGraphFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 0;
		object: [ sortGraph ];
		view: #gtGraphFor:
]

{ #category : #inspecting }
LbContext >> gtStatementsFor: aView [ 
	<gtView>
	statements isEmpty ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Statements';
		priority: 4;
		object: [ statements ];
		view: #gtStatementsFor:
]

{ #category : #inspecting }
LbContext >> gtVariablesFor: aView [ 
	<gtView>
	signature numberOfVariables isZero ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Variables';
		priority: 2;
		object: [ signature ];
		view: #gtVariablesFor:
]

{ #category : #initializing }
LbContext >> initializeWithName: aString signature: aSignature rewriteSystem: aRewriteSystem statements: anLbStatements [
	name := aString.
	sortGraph := aSignature sortGraph.
	signature := aSignature.
	rewriteSystem := aRewriteSystem.
	statements := anLbStatements.
	self beRecursivelyReadOnlyObject.
]

{ #category : #converting }
LbContext >> lbAtomicTermClass [
	^ LbContextTerm
]

{ #category : #accessing }
LbContext >> name [
	^ name
]

{ #category : #operations }
LbContext >> parseTerm: aString [
	^ (LbTermParser signature: signature) parse: aString
]

{ #category : #rewriting }
LbContext >> parseTermAndReduce: aString [
	| term |
	term := (LbTermParser signature: signature) parse: aString.
	term isPetit2Failure ifTrue: [ self error: term message ].
	^ rewriteSystem reduce: term
]

{ #category : #printing }
LbContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: name.
	aStream nextPut: $'.
	aStream nextPut: $).

]

{ #category : #operations }
LbContext >> reduce: aTerm [
	^ rewriteSystem reduce: aTerm
]

{ #category : #accessing }
LbContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #rewriting }
LbContext >> rulesMatching: aTerm [
	^ rewriteSystem rulesMatching: aTerm
]

{ #category : #accessing }
LbContext >> signature [
	^signature

]

{ #category : #accessing }
LbContext >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LbContext >> statements [
	^ statements
]
