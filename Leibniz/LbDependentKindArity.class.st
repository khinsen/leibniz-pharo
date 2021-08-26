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

{ #category : 'enumerating' }
LbDependentKindArity >> withUniversalVariantsDo: aBlock [
	| universal |
	self ifEmpty: [ aBlock value: self. ^ self ].
	universal := (LbDependentSortFamily anySortInSortGraph: sortGraph) kind.
	#(false true) asDigitsToPower: self size do: [ :eachSelection |
		| argKinds |
		argKinds := Array new: self size.
		1 to: self size do: [ :index |
			argKinds at: index put:
				((eachSelection at: index)
					ifTrue: [ universal ]
					ifFalse: [ self at: index ]) ].
		aBlock value: (self class sortGraph: sortGraph kinds: argKinds) ]
]
