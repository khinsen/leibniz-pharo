Class {
	#name : #LzRandomExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Random'
}

{ #category : #example }
LzRandomExamples >> clonedGenerator [
	<gtExample>
	| generator clonedGenerator |
	generator := self generatorFromSmallIntegerSeed.
	clonedGenerator := LzRandom new
							seed: generator seed.
	self assert: generator seed equals: clonedGenerator seed.
	self assert: generator next equals: clonedGenerator next.
	^ clonedGenerator
]

{ #category : #example }
LzRandomExamples >> generatorFromSmallIntegerSeed [
	<gtExample>
	^ LzRandom new
		seedFromSmallInteger: (self smallIntegerSeed)
]

{ #category : #example }
LzRandomExamples >> randomChoices [
	<gtExample>
	| generator booleans transformer trueCount |
	generator := self generatorFromSmallIntegerSeed.
	transformer := generator randomChoiceWithFraction: 1/3.
	booleans := generator next: 1000 transformedBy: transformer.
	self assert: booleans size equals: 1000.
	booleans do: [ :each |
		self assert: ({ true . false } includes: each) ].
	trueCount := (booleans select: [ :each | each ]) size.
	self assert: (trueCount < 350).
	self assert: (trueCount > 300).
	^ booleans
]

{ #category : #example }
LzRandomExamples >> randomIntegers [
	<gtExample>
	| generator integers transformer |
	generator := self generatorFromSmallIntegerSeed.
	transformer := generator integerBetween: 1 and: 50.
	integers := generator next: 1000 transformedBy: transformer.
	self assert: integers size equals: 1000.
	integers do: [ :each |
		self assert: each >= 1.
		self assert: each <= 50 ].
	"Two tests that may fail in general but pass for this specific
	 choice of seed and sample size."
	self assert: integers min equals: 1.
	self assert: integers max equals: 50.
	^ integers
]

{ #category : #example }
LzRandomExamples >> smallIntegerSeed [
	<gtExample>
	^ 42
]
