Class {
	#name : #LbDependentArity,
	#superclass : #Array,
	#type : #variable,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentArity class >> sortGraph: aSortGraph argSortPatterns: anArray [
	^(self basicNew: anArray size)
			initializeWithSortGraph: aSortGraph argSortPatterns: anArray;
			yourself
]

{ #category : #comparing }
LbDependentArity >> <= anArity [
	self species = anArity species ifFalse: [ ^ false ].
	self size = anArity size ifFalse: [ ^ false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #converting }
LbDependentArity >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : #inspecting }
LbDependentArity >> gtArgumentsFor: aView [
	<gtView>
	^ aView list
		title: 'Arguments' translated;
		priority: 0;
		items: [ self ];
		itemText: [ :each | each asLeibnizSyntaxString ]
]

{ #category : #initializing }
LbDependentArity >> initializeWithSortGraph: aSortGraph argSortPatterns: anArray [
	sortGraph := aSortGraph.
	anArray collect: [ :s | s ] into: self.
	self beRecursivelyReadOnlyObject
]

{ #category : #operating }
LbDependentArity >> liftToKindLevel [
	^ self class
		sortGraph: sortGraph
		argSortPatterns: (self collect: #kind)
]

{ #category : #printing }
LbDependentArity >> printAsLeibnizSyntaxOn: aStream [
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LbDependentArity >> printOn: aStream [
	self printNameOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]
