Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzBuiltinContexts class >> integerContext [
	^ LzContextBuilder new
		include: self truthContext;
		builtin: #integers;
		"Natural numbers"
		sort: 'ℕ';
		sort: 'ℕ.nz';
		sort: 'zero';
		subsort: 'zero ⊆ ℕ';
		subsort: 'ℕ.nz ⊆ ℕ';
		"Integers"
		sort: 'ℤ';
		sort: 'ℤ.nz';
		subsort: 'ℕ ⊆ ℤ';
		subsort: 'ℤ.nz ⊆ ℤ';
		subsort: 'ℕ.nz ⊆ ℤ.nz';
		"Arithmetic operators"
		op: 'ℤ + ℤ : ℤ';
		op: 'ℕ + ℕ : ℕ';
		op: 'ℕ.nz + ℕ : ℕ.nz';
		op: 'ℕ + ℕ.nz : ℕ.nz';
		op: 'ℤ - ℤ : ℤ';
		op: '-(ℤ) : ℤ';
		op: 'ℤ × ℤ : ℤ';
		op: 'ℕ × ℕ : ℕ';
		op: 'ℕ.nz × ℕ.nz : ℕ.nz';
		op: 'ℤ.nz × ℤ.nz : ℤ.nz';
		op: 'ℤ div ℤ.nz : ℤ';
		op: 'ℕ div ℕ.nz : ℕ';
		op: 'ℤ rem ℤ.nz : ℤ';
		op: 'ℕ rem ℕ.nz : ℕ';
		op: 'ℤ^{ℕ.nz} : ℤ';
		op: 'ℕ^{ℕ.nz} : ℕ';
		op: 'ℕ.nz^{ℕ.nz} : ℕ.nz';
		op: 'ℤ.nz^{ℕ.nz} : ℤ.nz';
		op: 'ℤ.nz^{zero} : ℕ.nz';
		op: 'abs(ℤ) : ℕ';
		op: 'abs(ℤ.nz) : ℕ.nz';
		"Comparison operators"
		op: 'ℤ < ℤ : boolean';
		op: 'ℤ > ℤ : boolean';
		op: 'ℤ ≤ ℤ : boolean';
		op: 'ℤ ≥ ℤ : boolean';
		context
]

{ #category : #accessing }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]

{ #category : #accessing }
LzBuiltinContexts class >> truthContext [
	^ LzContextBuilder new
		sort: 'boolean';
		op: 'true : boolean';
		op: 'false : boolean';
		context
]
