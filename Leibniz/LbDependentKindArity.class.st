Class {
	#name : 'LbDependentKindArity',
	#superclass : 'Array',
	#type : 'variable',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDependentKindArity class >> sortGraph: aSortGraph kinds: anArray [
	^(self basicNew: anArray size)
			initializeWithSortGraph: aSortGraph kinds: anArray;
			yourself
]

{ #category : 'initialization' }
LbDependentKindArity >> initializeWithSortGraph: aSortGraph kinds: anArray [
	sortGraph := aSortGraph.
	anArray collect: [ :s | s ] into: self.
	self do: [ :each | self assert: each sortGraph = sortGraph ].
	self beRecursivelyReadOnlyObject
]

{ #category : 'printing' }
LbDependentKindArity >> printAsLeibnizSyntaxOn: aStream [
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]
