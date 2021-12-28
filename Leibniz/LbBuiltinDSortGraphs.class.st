Class {
	#name : #LbBuiltinDSortGraphs,
	#superclass : #Object,
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #builtins }
LbBuiltinDSortGraphs class >> contextSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		parseAndAdd: 'context';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> fpNumberSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		"Generic FP Sorts"
		parseAndAdd: 'FP';
		parseAndAdd: 'FP.number ⊆ FP';
		parseAndAdd: 'FP.NaN ⊆ FP';
		parseAndAdd: 'FP.inf ⊆ FP';
		"Single-precision FP sorts"
		parseAndAdd: 'FP32';
		parseAndAdd: 'FP32 ⊆ FP';
		parseAndAdd: 'FP32.number ⊆ FP32';
		parseAndAdd: 'FP32.number ⊆ FP.number';
		parseAndAdd: 'FP32.NaN ⊆ FP32';
		parseAndAdd: 'FP32.NaN ⊆ FP.NaN';
		parseAndAdd: 'FP32.inf ⊆ FP32';
		parseAndAdd: 'FP32.inf ⊆ FP.inf';
		"Double-precision FP sorts"
		parseAndAdd: 'FP64';
		parseAndAdd: 'FP64 ⊆ FP';
		parseAndAdd: 'FP64.number ⊆ FP64';
		parseAndAdd: 'FP64.number ⊆ FP.number';
		parseAndAdd: 'FP64.NaN ⊆ FP64';
		parseAndAdd: 'FP64.NaN ⊆ FP.NaN';
		parseAndAdd: 'FP64.inf ⊆ FP64';
		parseAndAdd: 'FP64.inf ⊆ FP.inf';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> integerSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		"Natural numbers"
		parseAndAdd: 'ℕ';
		parseAndAdd: 'zero ⊆ ℕ';
		parseAndAdd: 'ℕ.nz ⊆ ℕ';
		"Integers"
		parseAndAdd: 'ℤ';
		parseAndAdd: 'ℕ ⊆ ℤ';
		parseAndAdd: 'ℤ.nz ⊆ ℤ';
		parseAndAdd: 'ℕ.nz ⊆ ℤ.nz';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> rationalNumberSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		addSortGraph: self integerSortGraph;
		parseAndAdd: 'ℚ';
		parseAndAdd: 'ℤ ⊆ ℚ';
		parseAndAdd: 'ℚ.nz ⊆ ℚ';
		parseAndAdd: 'ℤ.nz ⊆ ℚ.nz';
		parseAndAdd: 'ℚ.p ⊆ ℚ.nz';
		parseAndAdd: 'ℕ.nz ⊆ ℚ.p';
		parseAndAdd: 'ℚ.nn ⊆ ℚ';
		parseAndAdd: 'ℚ.p ⊆ ℚ.nn';
		parseAndAdd: 'ℕ ⊆ ℚ.nn';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> realNumberSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		addSortGraph: self rationalNumberSortGraph;
		parseAndAdd: 'ℝ';
		parseAndAdd: 'ℚ ⊆ ℝ';
		parseAndAdd: 'ℝ.nz ⊆ ℝ';
		parseAndAdd: 'ℚ.nz ⊆ ℝ.nz';
		parseAndAdd: 'ℝ.p ⊆ ℝ.nz';
		parseAndAdd: 'ℚ.p ⊆ ℝ.p';
		parseAndAdd: 'ℝ.nn ⊆ ℝ';
		parseAndAdd: 'ℝ.p ⊆ ℝ.nn';
		parseAndAdd: 'ℚ.nn ⊆ ℝ.nn';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> stringSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		parseAndAdd: 'string';
		sortGraph
]

{ #category : #builtins }
LbBuiltinDSortGraphs class >> truthSortGraph [
	<gtExample>
	^LbDSortGraphBuilder new
		parseAndAdd: 'boolean';
		sortGraph
]
