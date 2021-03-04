Class {
	#name : #LbDependentKindArity,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentKindArity class >> sortGraph: aSortGraph kindFamilies: anArray [
	^(self basicNew: anArray size)
			initializeWithSortGraph: aSortGraph kindFamilies: anArray;
			yourself
]

{ #category : #initialization }
LbDependentKindArity >> initializeWithSortGraph: aSortGraph kindFamilies: anArray [
	sortGraph := aSortGraph.
	anArray collect: [ :s | s ] into: self.
	self do: [ :each | self assert: each sortGraph = sortGraph ].
	self beRecursivelyReadOnlyObject
]

{ #category : #printing }
LbDependentKindArity >> printAsLeibnizSyntaxOn: aStream [
	self
		do: [ :each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]
