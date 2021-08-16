Class {
	#name : 'LbDependentArity',
	#superclass : 'Array',
	#type : 'variable',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'variables'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDependentArity class >> sortGraph: aSortGraph argSortPatterns: anArray [
	^(self basicNew: anArray size)
			initializeWithSortGraph: aSortGraph argSortPatterns: anArray;
			yourself
]

{ #category : 'comparing' }
LbDependentArity >> <= anArity [
	self species = anArity species ifFalse: [ ^ false ].
	self size = anArity size ifFalse: [ ^ false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'converting' }
LbDependentArity >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : 'inspecting' }
LbDependentArity >> gtArgumentsFor: aView [
	<gtView>
	^ aView list
		title: 'Arguments' translated;
		priority: 0;
		items: [ self ];
		itemText: [ :each | each asLeibnizSyntaxString ]
]

{ #category : 'initializing' }
LbDependentArity >> initializeWithSortGraph: aSortGraph argSortPatterns: anArray [
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

{ #category : 'operating' }
LbDependentArity >> liftToKinds [
	^ LbDependentKindArity
		sortGraph: sortGraph
		kinds: (self collect: #kind)
]

{ #category : 'comparing' }
LbDependentArity >> pairWith: otherArity [
	^ LbDependentArityPair arity1: self arity2: otherArity
]

{ #category : 'printing' }
LbDependentArity >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : 'printing' }
LbDependentArity >> printOn: aStream [
	self printNameOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : 'printing' }
LbDependentArity >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort asLeibnizSyntaxString.
			aStream nextPutAll: ' ']
]

{ #category : 'accessing' }
LbDependentArity >> sortGraph [
	^ sortGraph
]

{ #category : 'matching' }
LbDependentArity >> unify: otherArity [
	| variables |
	variables := LbVariables new.
	self size = otherArity size
		ifFalse: [ ^ variables failWith: self notUnifiableWith: otherArity ].
	self with: otherArity do: [ :sp1 :sp2 |
		sp1 unify: sp2 variables: variables ].
	^ variables
]

{ #category : 'accessing' }
LbDependentArity >> variables [
	^ self
		inject: Dictionary new
		into:[ :total :each | total union: each variables ]
]
