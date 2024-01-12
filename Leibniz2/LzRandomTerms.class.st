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

{ #category : #operating }
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

{ #category : #operating }
LzRandomTerms >> randomChoiceWithFraction: fraction seed: seed [
	| generator boolean nextSeed |
	generator := LzRandom new seed: seed value.
	boolean := LzBooleanTerm
					signature: self signature
					value: (generator nextTransformedBy:
								(generator
									randomChoiceWithFraction: fraction value)).
	nextSeed := LzIntegerTerm
					signature: self signature
					value: generator seed.
	^ self signature
		opTerm: LzTupleOpName new
		args: { boolean . nextSeed }
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
