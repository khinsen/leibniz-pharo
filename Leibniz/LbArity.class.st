"
I represent an arity, i.e. the sort constraints for each argument of an operator.

"
Class {
	#name : #LbArity,
	#superclass : #Array,
	#type : #variable,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbArity class >> sortGraph: aSortGraph argSortConstraints: aConstraintArray [
	^(self basicNew: aConstraintArray size)
			initializeWithSortGraph: aSortGraph argSortConstraints: aConstraintArray;
			yourself

]

{ #category : #'instance creation' }
LbArity class >> sortGraph: aSortGraph argSorts: aSortArray [
	^(self basicNew: aSortArray size)
			initializeWithSortGraph: aSortGraph argSorts: aSortArray;
			yourself

]

{ #category : #comparing }
LbArity >> <= anArity [
	self size = anArity size ifFalse: [ ^false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^false ] ].
	^true

]

{ #category : #converting }
LbArity >> asArgSorts [
	| argSorts |
	argSorts := Array new: self size.
	self collect: [ :sc | sc asArgSort ] into: argSorts.
	^argSorts

]

{ #category : #initializing }
LbArity >> initializeWithSortGraph: aSortGraph argSortConstraints: aConstraintArray [
	sortGraph := aSortGraph.
	self fillFrom: aConstraintArray with: [ :x | x ].
	self beRecursivelyReadOnlyObject.
	^self

]

{ #category : #initializing }
LbArity >> initializeWithSortGraph: aSortGraph argSorts: aSortArray [
	sortGraph := aSortGraph.
	aSortArray collect: [ :s | s ] into: self.
	self beRecursivelyReadOnlyObject.
	^ self
]

{ #category : #operating }
LbArity >> liftToKindLevel [
	^ self class
		sortGraph: sortGraph
		argSorts: (self collect: #kind)
]

{ #category : #printing }
LbArity >> printAsLeibnizSyntaxOn: aStream [
	self do: [ :sc | sc printAsLeibnizSyntaxOn: aStream ]
		  separatedBy: [ aStream nextPutAll: ', ' ]

]

{ #category : #printing }
LbArity >> printOn: aStream [
	self printNameOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]
