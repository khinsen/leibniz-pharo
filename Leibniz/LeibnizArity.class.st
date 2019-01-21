"
I represent an arity, i.e. the sort constraints for each argument of an operator.

"
Class {
	#name : #LeibnizArity,
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
LeibnizArity class >> sortGraph: aSortGraph argSortConstraints: aConstraintArray [
	^(self basicNew: aConstraintArray size)
			initializeWithSortGraph: aSortGraph argSortConstraints: aConstraintArray;
			yourself

]

{ #category : #'instance creation' }
LeibnizArity class >> sortGraph: aSortGraph argSorts: aSortArray [
	^(self basicNew: aSortArray size)
			initializeWithSortGraph: aSortGraph argSorts: aSortArray;
			yourself

]

{ #category : #comparing }
LeibnizArity >> <= anArity [
	self size = anArity size ifFalse: [ ^false ].
	self with: anArity do:
		[ :s1 :s2 | s1 <= s2 ifFalse: [ ^false ] ].
	^true

]

{ #category : #converting }
LeibnizArity >> asArgSorts [
	| argSorts |
	argSorts := Array new: self size.
	self collect: [ :sc | sc asArgSort ] into: argSorts.
	^argSorts

]

{ #category : #initializing }
LeibnizArity >> initializeWithSortGraph: aSortGraph argSortConstraints: aConstraintArray [
	sortGraph := aSortGraph.
	self fillFrom: aConstraintArray with: [ :x | x ].
	self beRecursivelyReadOnlyObject.
	^self

]

{ #category : #initializing }
LeibnizArity >> initializeWithSortGraph: aSortGraph argSorts: aSortArray [
	sortGraph := aSortGraph.
	aSortArray collect: [ :s | LeibnizSortOrSubsortConstraint sortGraph: sortGraph sort: s ]
				  into: self.
	self beRecursivelyReadOnlyObject.
	^self

]

{ #category : #operating }
LeibnizArity >> liftToKindLevel [
	^ self class sortGraph: sortGraph
					 argSortConstraints: (self collect: [ :sc | sc kindConstraint ]).

]

{ #category : #printing }
LeibnizArity >> printAsLeibnizSyntaxOn: aStream [
	self do: [ :sc | sc printAsLeibnizSyntaxOn: aStream ]
		  separatedBy: [ aStream nextPutAll: ', ' ]

]

{ #category : #printing }
LeibnizArity >> printOn: aStream [
	self printNameOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]
