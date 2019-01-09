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
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizArity class >> sortGraph: aSortGraph size: anInteger [
	^(self basicNew: anInteger)
			initializeWithSortGraph: aSortGraph;
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
LeibnizArity >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.

]

{ #category : #operating }
LeibnizArity >> liftToKindLevel [
	| kindArity |
	kindArity := self class sortGraph: sortGraph size: self size.
	self collect: [ :sc | sc kindConstraint ] into: kindArity.
	^kindArity.

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
