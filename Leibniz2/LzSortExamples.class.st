Class {
	#name : #LzSortExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Sorts'
}

{ #category : #example }
LzSortExamples >> arraySortFamily [
	<gtExample>
	| family1 family2 sortGraph |
	family1 := self integerArraySort family.
	family2 := self stringArraySort family.
	self assert: (family1 ~= family2).
	"These two objects are not equal because they were constructed from
	 different though equivalent sort graphs. We have to start from a
	 common one:"
	sortGraph := self integerAndStringArraySortGraph.
	family1 := (sortGraph sort: 'Array1D(ℤ)') family.
	family2 := (sortGraph sort: 'Array1D(String)') family.
	self assert: family1 equals: family2.
	^ family1
]

{ #category : #example }
LzSortExamples >> arraySortPatternMatching [
	<gtExample>
	| sortGraph integerArraySort arraySortPattern bindings varName |
	sortGraph := self integerAndStringArraySortGraph.
	integerArraySort := (sortGraph sort: 'Array1D(ℤ)').
	arraySortPattern := (sortGraph sort: 's_:𝕊, Array1D(s_)').
	bindings := arraySortPattern match: integerArraySort.
	self assert: bindings isFailure not.
	varName := LzVarName for: 's_'.
	self assert: (bindings sortOf: varName) asLeibnizSyntaxString equals: '𝕊'.
	self assert: (bindings bindingFor: varName) asLeibnizSyntaxString equals: 'ℤ'.
	^ bindings
]

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
LzSortExamples >> integerAndStringArrayContext [
	<gtExample>
	^ LzContextBuilder new
		database: LzBook database;
		include: (LzBook contextNamed: 'One-dimensional arrays');
		include: (LzBook contextNamed: 'Integers');
		include: (LzBook contextNamed: 'Character strings');
		context.
]

{ #category : #example }
LzSortExamples >> integerAndStringArraySortGraph [
	<gtExample>
	^ self integerAndStringArrayContext sortGraph
]

{ #category : #example }
LzSortExamples >> integerArraySort [
	<gtExample>
	^ self integerAndStringArraySortGraph sort: 'Array1D(ℤ)'
]

{ #category : #example }
LzSortExamples >> integerSort [
	<gtExample>
	^ self integerSortGraph sort: 'ℤ'
]

{ #category : #example }
LzSortExamples >> integerSortFamily [
	<gtExample>
	^ self integerSort family
]

{ #category : #example }
LzSortExamples >> integerSortGraph [
	<gtExample>
	^ (LzBook contextNamed: 'Integers') sortGraph
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

{ #category : #example }
LzSortExamples >> naturalNumberSort [
	<gtExample>
	^ self integerSortGraph sort: 'ℕ'
]

{ #category : #example }
LzSortExamples >> stringArraySort [
	<gtExample>
	^ self integerAndStringArraySortGraph sort: 'Array1D(String)'
]

{ #category : #example }
LzSortExamples >> stringSort [
	<gtExample>
	^ self stringSortGraph sort: 'String'
]

{ #category : #example }
LzSortExamples >> stringSortGraph [
	<gtExample>
	^ (LzBook contextNamed: 'Character strings') sortGraph
]
