Class {
	#name : #LzRandomTerms,
	#superclass : #Object,
	#instVars : [
		'signature'
	],
	#category : #'Leibniz2-Random'
}

{ #category : #'instance creation' }
LzRandomTerms class >> signature: anLzSignature [
	^ self new
		signature: anLzSignature
]

{ #category : #accessing }
LzRandomTerms >> integerBetween: min and: max seed: seed [
	| generator integer nextSeed |
	generator := LzRandom new seed: seed value.
	integer := LzIntegerTerm
					signature: self signature
					value: (generator nextTransformedBy:
								(generator
									integerBetween: min value
									and: max value)).
	nextSeed := LzIntegerTerm
					signature: self signature
					value: generator seed.
	^ self signature
		opTerm: LzTupleOpName new
		args: { integer . nextSeed }
]

{ #category : #accessing }
LzRandomTerms >> positiveIntegers: count max: max [
	| countV maxV values randomArray |
	countV := count value.
	maxV := max value.
	values := self next: countV transformedBy: [ :each | each ].
	randomArray := self signature
		arrayTerm: (values collect: [ :each |
			LzIntegerTerm signature: self signature value: each ])
		shape: { countV }.
	^ self signature
		opTerm: LzTupleOpName new
		args: { randomArray. LzIntegerTerm signature: self signature value: self seed }
]

{ #category : #accessing }
LzRandomTerms >> seedFromSmallInteger: anInteger [
	^ LzIntegerTerm
		signature: self signature
		value: (LzRandom new
					seedFromSmallInteger: anInteger value) seed
]

{ #category : #accessing }
LzRandomTerms >> signature [
	^ signature
]

{ #category : #accessing }
LzRandomTerms >> signature: anObject [
	signature := anObject
]
