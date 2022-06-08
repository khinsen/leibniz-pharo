Class {
	#name : #LbDArity,
	#superclass : #Array,
	#type : #variable,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'variables'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDArity class >> sortGraph: aSortGraph argSortPatterns: anArray [
	^(self basicNew: anArray size)
			initializeWithSortGraph: aSortGraph argSortPatterns: anArray;
			yourself
]

{ #category : #comparing }
LbDArity >> <= anArity [
	self species = anArity species ifFalse: [ ^ false ].
	self size = anArity size ifFalse: [ ^ false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #converting }
LbDArity >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : #inspecting }
LbDArity >> gtArgumentsFor: aView [
	<gtView>
	^ aView list
		title: 'Arguments' translated;
		priority: 0;
		items: [ self ];
		itemText: [ :each | each asLeibnizSyntaxString ]
]

{ #category : #initializing }
LbDArity >> initializeWithSortGraph: aSortGraph argSortPatterns: anArray [
	sortGraph := aSortGraph.
	anArray collect: [ :s | s ] into: self.
	self do: [ :each | self assert: each sortGraph = sortGraph ].
	variables := Dictionary new.
	self do: [ :each |
		each variables keysAndValuesDo: [ :k : v |
			variables at: k ifPresent: [ :priorValue |
				self assert: v equals: priorValue ].
			variables at: k put: v ] ].
	self beRecursivelyReadOnlyObject
]

{ #category : #operating }
LbDArity >> liftToKinds [
	^ LbDKindArity
		sortGraph: sortGraph
		kinds: (self collect: #kind)
]

{ #category : #comparing }
LbDArity >> pairWith: otherArity [
	^ LbDArityPair arity1: self arity2: otherArity
]

{ #category : #printing }
LbDArity >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LbDArity >> printOn: aStream [
	self printNameOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
LbDArity >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort asLeibnizSyntaxString.
			aStream nextPutAll: ' ']
]

{ #category : #printing }
LbDArity >> printVariablesOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort asLeibnizSyntaxString.
			aStream nextPutAll: ' ']
]

{ #category : #accessing }
LbDArity >> sortGraph [
	^ sortGraph
]

{ #category : #matching }
LbDArity >> unify: otherArity [
	| variables |
	variables := LbVariables new.
	self size = otherArity size
		ifFalse: [ ^ variables failWith: self notUnifiableWith: otherArity ].
	self with: otherArity do: [ :sp1 :sp2 |
		sp1 unify: sp2 variables: variables ].
	^ variables
]

{ #category : #accessing }
LbDArity >> variables [
	^ self
		inject: Dictionary new
		into:[ :total :each | total union: each variables ]
]
