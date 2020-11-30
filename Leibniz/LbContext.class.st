"
I represent a context in a Leibniz document.
"
Class {
	#name : #LbContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph',
		'signature',
		'rewriteSystem'
	],
	#category : #'Leibniz-6-Contexts'
}

{ #category : #'instance creation' }
LbContext class >> name: aString signature: aSignature rewriteSystem: aRewriteSystem [
	^ self basicNew
			 initializeWithName: aString signature: aSignature rewriteSystem: aRewriteSystem;
			 yourself
]

{ #category : #accessing }
LbContext >> declarations [
	^ rewriteSystem declarations
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
			#(sorts subsorts variables operators rules) do: [ :each |
				(d at: each) ifNotEmpty: [
					categories add: {
						each asString capitalized.
						(d at: each) collect: [ :aString |
							{ aString. #() } ] } ] ].
			categories ];
		itemLbCode: [ :each | each first];
		children: [ :each | each second ];
		expandOneLevel;
		yourself
]

{ #category : #accessing }
LbContext >> gtOperatorsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Operators';
		priority: 1;
		object: [ signature ];
		view: #gtOperatorsFor:
]

{ #category : #accessing }
LbContext >> gtRulesFor: aView [ 
	<gtView>
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
LbContext >> initializeWithName: aString signature: aSignature rewriteSystem: aRewriteSystem [
	name := aString.
	sortGraph := aSignature sortGraph.
	signature := aSignature.
	rewriteSystem := aRewriteSystem.
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
