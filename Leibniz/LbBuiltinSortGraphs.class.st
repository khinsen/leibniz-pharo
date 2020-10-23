Class {
	#name : #LbBuiltinSortGraphs,
	#superclass : #Object,
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #builtins }
LbBuiltinSortGraphs class >> contextSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
		parseAndAdd: 'context';
		sortGraph
]

{ #category : #builtins }
LbBuiltinSortGraphs class >> fpNumberSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
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
LbBuiltinSortGraphs class >> integerSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
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
LbBuiltinSortGraphs class >> rationalNumberSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
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
LbBuiltinSortGraphs class >> realNumberSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
		addSortGraph: self rationalNumberSortGraph;
		parseAndAdd: 'ℝ';
		parseAndAdd: 'ℚ ⊆ ℝ';
		parseAndAdd: 'ℝ.nz ⊆ ℝ';
		parseAndAdd: 'ℚ.nz ⊆ ℝ.nz';
		parseAndAdd: 'ℝ.p ⊆ ℝ.nz';
		parseAndAdd: 'ℚ.p ⊆ ℝ.p';
		parseAndAdd: 'ℝ.nn ⊆ ℝ';
		parseAndAdd: 'ℝ.p ⊆ ℝ.nn';
		parseAndAdd: 'ℚ.p ⊆ ℝ.nn';
		sortGraph
]

{ #category : #builtins }
LbBuiltinSortGraphs class >> stringSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
		parseAndAdd: 'string';
		sortGraph
]

{ #category : #builtins }
LbBuiltinSortGraphs class >> truthSortGraph [
	<gtExample>
	^LbSortGraphBuilder new
		parseAndAdd: 'boolean';
		sortGraph
]
