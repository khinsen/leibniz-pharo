"
I represent an operator with given symbol and kind-arity in a LeibnizSignature.
"
Class {
	#name : #LeibnizOperator,
	#superclass : #Object,
	#instVars : [
		'opSymbol',
		'kindArity',
		'kind',
		'ranks',
		'sortGraph'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizOperator class >> symbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	^ self basicNew
			 initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind;
			 yourself.

]

{ #category : #adding }
LeibnizOperator >> addArity: newArity withSort: newSort [
	self assertMonotonicity: [ kind includes: newSort ]
		  forArity: newArity andSort: newSort.

	ranks ifEmpty:
		[ ranks add: newArity -> newSort.
		  ^self  ].

	1 to: ranks size do:
		[	:index |
		 	| r a s |
			r := ranks at: index.
			a := r key.
			s := r value.

			a = newArity
				ifTrue:
					[ self assert: [ s = newSort ]
							 description: [ 'conflicting earlier operator definition with sort ', s asString ].
					  ^self ].

			(newArity <= a)
				ifTrue: [ self assertMonotonicity: [ sortGraph is: newSort subsortOf: s ]
									forArity: newArity andSort: newSort.
							 ranks add: newArity -> newSort beforeIndex: index.
							 ^self ].

			(a <= newArity)
				ifTrue: [ self assertMonotonicity: [ sortGraph is: s subsortOf: newSort ]
									forArity: newArity andSort: newSort]. ].

]

{ #category : #'error signalling' }
LeibnizOperator >> assertMonotonicity: aBlock forArity: anArity andSort: aSort [
	self assert: aBlock
		  description: 'new rank ', anArity printString,
							' -> ', aSort asString, ' makes operator non-monotonic'.
]

{ #category : #initializing }
LeibnizOperator >> initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	opSymbol := aSymbol.
	kindArity := aKindConstraintArray.
	kind := aKind.
	sortGraph := kind sortGraph.
	ranks := OrderedCollection new.


]

{ #category : #printing }
LeibnizOperator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: opSymbol.
	aStream nextPutAll: ': '.
	kindArity printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' -> '.
	kind printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ', '.
	ranks size printOn: aStream.
	aStream nextPutAll: ' ranks)'.

]
