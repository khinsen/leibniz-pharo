Class {
	#name : #LzSortExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Sorts'
}

{ #category : #example }
LzSortExamples >> greatestCommonSubsorts [
	<gtExample>
	| sortGraph naturalNumberSort nonzeroIntegerSort pair lcs |
	sortGraph := self integerSortGraph.
	naturalNumberSort := sortGraph sort: 'ℕ'.
	nonzeroIntegerSort := sortGraph sort: 'ℤ.nz'.
	pair := LzSortPair
		sort1: naturalNumberSort
		sort2: nonzeroIntegerSort.
	lcs := pair greatestCommonSubsorts.
	self assert: lcs equals: (Set with: (sortGraph sort: 'ℕ.nz')).
	^ lcs
]

{ #category : #example }
LzSortExamples >> integerSortGraph [
	<gtExample>
	^ LzBuiltinContexts integerContext sortGraph
]

{ #category : #example }
LzSortExamples >> leastCommonSupersorts [
	<gtExample>
	| sortGraph naturalNumberSort nonzeroIntegerSort pair lcs |
	sortGraph := self integerSortGraph.
	naturalNumberSort := sortGraph sort: 'ℕ'.
	nonzeroIntegerSort := sortGraph sort: 'ℤ.nz'.
	pair := LzSortPair
		sort1: naturalNumberSort
		sort2: nonzeroIntegerSort.
	lcs := pair leastCommonSupersorts.
	self assert: lcs equals: (Set with: (sortGraph sort: 'ℤ')).
	^ lcs
]
