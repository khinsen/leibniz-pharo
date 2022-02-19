"
Builtin contexts are contexts that cannot be defined in Leibniz itself, because they make use of builtin terms such as numbers or strings. {{gtMethod:name=LzBuiltinContexts class>>#truthContext}} is an exception: it could very well be defined as a standard Leibniz context, but since it is used by the number contexts, it is part of the builtin contexts as well.

"
Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #private }
LzBuiltinContexts class >> integerAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ ?x:ℤ ∀ ?y:ℤ  ?x + ?y = ?y + ?x';
		axiom: '∀ ?x:ℤ ∀ ?y:ℤ  ∀ ?z:ℤ  (?x + ?y) + ?z = ?x + (?y + ?z)';
		"multiplication axioms"
		axiom: '∀ ?x:ℤ ∀ ?y:ℤ  ?x × ?y = ?y × ?x';
		axiom: '∀ ?x:ℤ ∀ ?y:ℤ  ∀ ?z:ℤ  (?x × ?y) × ?z = ?x × (?y × ?z)'.
]

{ #category : #accessing }
LzBuiltinContexts class >> integerContext [
	| builder |
	builder := LzContextBuilder new
		include: self truthContext;
		builtin: #integers.
	self integerSortsFor: builder.
	self integerOpsFor: builder.
	self integerAxiomsFor: builder.
	self integerRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzBuiltinContexts class >> integerOpsFor: aContextBuilder [
	aContextBuilder
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
		op: 'ℤ < ℤ : 𝔹';
		op: 'ℤ > ℤ : 𝔹';
		op: 'ℤ ≤ ℤ : 𝔹';
		op: 'ℤ ≥ ℤ : 𝔹'.
]

{ #category : #private }
LzBuiltinContexts class >> integerRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x + ?zero ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero + ?x ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x + ?y → ''x + y'':LzIntegerTerm';
		"subtraction rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x - ?zero ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero - ?x ⇒ -(?x)';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x - ?y → ''x - y'':LzIntegerTerm';
		rule: '∀ ?zero:zero -(?zero) ⇒ 0';
		rule: '∀ ?x:ℤ -(?x) → ''x negated'':LzIntegerTerm';
		"multiplication rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x × ?zero ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero × ?x ⇒ 0';
		rule: '∀ ?x:ℤ 1 × ?x ⇒ ?x';
		rule: '∀ ?x:ℤ ?x × 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x × ?y → ''x * y'':LzIntegerTerm';
		"division rules"
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?zero div ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x div 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x div ?y → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?zero rem ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x rem 1 ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x rem ?y → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"exponentiation rules"
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?x^{?zero} ⇒ 1';
		rule: '∀ ?x:ℕ.nz ∀ ?zero:zero ?zero^{?x} ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℕ.nz ?x^{?y} → ''x raisedTo: y'':LzIntegerTerm';
		"abs rules"
		rule: '∀ ?x:ℕ abs(?x) ⇒ ?x';
		rule: '∀ ?x:ℤ abs(?x) ⇒ -(?x) | ?x < 0';
		rule: '∀ ?x:ℤ abs(?x) → ''x abs'':LzIntegerTerm';
		"comparison rules"
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x < ?y → ''x < y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x > ?y → ''x > y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x ≤ ?y → ''x <= y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x ≥ ?y → ''x >= y'':LzBooleanTerm'.
]

{ #category : #private }
LzBuiltinContexts class >> integerSortsFor: aContextBuilder [
	aContextBuilder
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
		subsort: 'ℕ.nz ⊆ ℤ.nz'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ ?x:ℚ ∀ ?y:ℚ  ?x + ?y = ?y + ?x';
		axiom: '∀ ?x:ℚ ∀ ?y:ℚ  ∀ ?z:ℚ  (?x + ?y) + ?z = ?x + (?y + ?z)';
		"multiplication axioms"
		axiom: '∀ ?x:ℚ ∀ ?y:ℚ  ?x × ?y = ?y × ?x';
		axiom: '∀ ?x:ℚ ∀ ?y:ℚ  ∀ ?z:ℚ  (?x × ?y) × ?z = ?x × (?y × ?z)'.
]

{ #category : #accessing }
LzBuiltinContexts class >> rationalNumberContext [
	| builder |
	builder := LzContextBuilder new
		include: self truthContext;
		builtin: #integers;
		builtin: #rationalNumbers.
	self integerSortsFor: builder.
	self rationalSortsFor: builder.
	self integerOpsFor: builder.
	self rationalOpsFor: builder.
	"No integerAxioms, because they would be redundant."
	self rationalAxiomsFor:  builder.
	"No integerRules, the few that are required are repeated in rationalRules."
	self rationalRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzBuiltinContexts class >> rationalOpsFor: aContextBuilder [
	aContextBuilder
		"Arithmetic operators"
		op: 'ℚ + ℚ : ℚ';
		op: 'ℚ.p + ℚ.p : ℚ.p';
		op: 'ℚ.nn + ℚ.nn : ℚ.nn';
		op: 'ℚ - ℚ : ℚ';
		op: '-(ℚ) : ℚ';
		op: 'ℚ × ℚ : ℚ';
		op: 'ℚ.p × ℚ.p : ℚ.p';
		op: 'ℚ.nn × ℚ.nn : ℚ.nn';
		op: 'ℚ.nz × ℚ.nz : ℚ.nz';
		op: 'ℚ ÷ ℚ.nz : ℚ';
		op: 'ℚ.nz ÷ ℚ.nz : ℚ.nz';
		op: 'ℚ.nn ÷ ℚ.p : ℚ.nn';
		op: 'ℚ.p ÷ ℚ.p : ℚ.p';
		op: 'ℚ.nz^{ℤ.nz} : ℚ.nz';
		op: 'ℚ.p^{ℤ.nz} : ℚ.p';
		op: 'ℚ.nz^{zero} : ℕ.nz';
		op: 'abs(ℚ) : ℚ.nn';
		op: 'abs(ℚ.nz) : ℚ.p';
		"Comparison operators"
		op: 'ℚ < ℚ : 𝔹';
		op: 'ℚ > ℚ : 𝔹';
		op: 'ℚ ≤ ℚ : 𝔹';
		op: 'ℚ ≥ ℚ : 𝔹'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ ?x:ℚ ∀ ?z:zero ?x + ?z ⇒ ?x';
		rule: '∀ ?x:ℚ ∀ ?z:zero ?z + ?x ⇒ ?x';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x + ?y → ''x + y'':LzRationalNumberTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x + ?y → ''x + y'':LzIntegerTerm';
		"Subtraction rules"
		rule: '∀ ?x:ℚ ∀ ?z:zero ?x - ?z ⇒ ?x';
		rule: '∀ ?x:ℚ ∀ ?z:zero ?z - ?x ⇒ -(?x)';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x - ?y → ''x - y'':LzIntegerTerm';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x - ?y → ''x - y'':LzRationalNumberTerm';
		"Negation rules"
		rule: '∀ ?z:zero -(?z) ⇒ 0';
		rule: '∀ ?x:ℤ -(?x) → ''x negated'':LzIntegerTerm';
		rule: '∀ ?x:ℚ -(?x) → ''x negated'':LzRationalNumberTerm';
		"Multiplication rules"
		rule: '∀ ?x:ℚ ∀ ?z:zero ?x × ?z ⇒ 0';
		rule: '∀ ?x:ℚ ∀ ?z:zero ?z × ?x ⇒ 0';
		rule: '∀ ?x:ℚ 1 × ?x ⇒ ?x';
		rule: '∀ ?x:ℚ ?x × 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x × ?y → ''x * y'':LzIntegerTerm';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x × ?y → ''x * y'':LzRationalNumberTerm';
		"Division rules"
		rule: '∀ ?x:ℚ.nz ∀ ?z:zero ?z ÷ ?x ⇒ 0';
		rule: '∀ ?x:ℚ ?x ÷ 1 ⇒ ?x';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ.nz ?x ÷ ?y → ''x / y'':LzRationalNumberTerm';
		"Integer div and rem rules"
		rule: '∀ ?x:ℤ.nz ∀ ?z:zero ?z div ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x div 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x div ?y → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ ?x:ℤ.nz ∀ ?z:zero ?z rem ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x rem 1 ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x rem ?y → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"Exponentiation rules"
		rule: '∀ ?x:ℚ.nz ∀ ?z:zero ?x^{?z} ⇒ 1';
		rule: '∀ ?x:ℕ.nz ∀ ?z:zero ?z^{?x} ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℕ.nz ?x^{?y} → ''x raisedTo: y'':LzIntegerTerm';
		rule: '∀ ?x:ℚ.nz ∀ ?y:ℤ.nz ?x^{?y} → ''x raisedTo: y'':LzRationalNumberTerm';
		"Abs rules"
		rule: '∀ ?x:ℚ.nn abs(?x) ⇒ ?x';
		rule: '∀ ?x:ℚ abs(?x) ⇒ -(?x) | ?x < 0';
		rule: '∀ ?x:ℤ abs(?x) → ''x abs'':LzIntegerTerm';
		rule: '∀ ?x:ℚ abs(?x) → ''x abs'':LzRationalNumberTerm';
		"Comparison rules"
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x < ?y → ''x < y'':LzBooleanTerm';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x > ?y → ''x > y'':LzBooleanTerm';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x ≤ ?y → ''x <= y'':LzBooleanTerm';
		rule: '∀ ?x:ℚ ∀ ?y:ℚ ?x ≥ ?y → ''x >= y'':LzBooleanTerm'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalSortsFor: aContextBuilder [
	aContextBuilder
		"Rational numbers"
		sort: 'ℚ';
		sort: 'ℚ.nn';
		sort: 'ℚ.nz';
		sort: 'ℚ.p';
		subsort: 'ℚ.nz ⊆ ℚ';
		subsort: 'ℚ.p ⊆ ℚ.nz';
		subsort: 'ℚ.nn ⊆ ℚ';
		subsort: 'ℚ.p ⊆ ℚ.nn';
		subsort: 'ℕ ⊆ ℚ.nn';
		subsort: 'ℕ.nz ⊆ ℚ.p';
		subsort: 'ℤ ⊆ ℚ';
		subsort: 'ℤ.nz ⊆ ℚ.nz'.
]

{ #category : #accessing }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]

{ #category : #accessing }
LzBuiltinContexts class >> stringContext [
	^ LzContextBuilder new
		builtin: #strings;
		sort: 'string';
		op: 'string + string : string';
		rule: '∀ ?a:string ∀ ?b:string ?a + ?b → ''a, b'':LzStringTerm';
		context
]

{ #category : #accessing }
LzBuiltinContexts class >> truthContext [
	^ LzContextBuilder new
		sort: '𝔹';
		op: '⊤ : 𝔹';
		op: '⊥ : 𝔹';
		context
]
