Class {
	#name : #LbBuiltinSignatures,
	#superclass : #Object,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #builtins }
LbBuiltinSignatures class >> fpNumberSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph:
		((LbBuiltinSortGraphs fpNumberSortGraph
			union: LbBuiltinSortGraphs integerSortGraph)
			union: LbBuiltinSortGraphs truthSortGraph))
		addBuiltin: #fpNumbers;
		addSignature: (LbBuiltinSignatures integerSignature) includeVars: false;
		"Arithmetic operators, single precision"
		parseAndAddOp: 'FP32 + FP32 : FP32';
		parseAndAddOp: 'FP32 - FP32 : FP32';
		parseAndAddOp: '-(FP32) : FP32';
		parseAndAddOp: 'FP32 × FP32 : FP32';
		parseAndAddOp: 'FP32 ÷ FP32 : FP32';
		parseAndAddOp: 'FP32 ÷ FP32 : FP32';
		parseAndAddOp: 'FP32^{FP32} : FP32';
		parseAndAddOp: 'FP32^{ℤ} : FP32';
		parseAndAddOp: 'abs(FP32) : FP32';
		parseAndAddOp: '√(FP32) : FP32';
		"Arithmetic operators, double precision"
		parseAndAddOp: 'FP64 + FP64 : FP64';
		parseAndAddOp: 'FP64 - FP64 : FP64';
		parseAndAddOp: '-(FP64) : FP64';
		parseAndAddOp: 'FP64 × FP64 : FP64';
		parseAndAddOp: 'FP64 ÷ FP64 : FP64';
		parseAndAddOp: 'FP64 ÷ FP64 : FP64';
		parseAndAddOp: 'FP64^{FP64} : FP64';
		parseAndAddOp: 'FP64^{ℤ} : FP64';
		parseAndAddOp: 'abs(FP64) : FP64';
		parseAndAddOp: '√(FP64) : FP64';
		"Comparison operators, single precision"
		parseAndAddOp: 'FP32 < FP32 : boolean';
		parseAndAddOp: 'FP32 > FP32 : boolean';
		parseAndAddOp: 'FP32 ≤ FP32 : boolean';
		parseAndAddOp: 'FP32 ≥ FP32 : boolean';
		"Comparison operators, double precision"
		parseAndAddOp: 'FP64 < FP64 : boolean';
		parseAndAddOp: 'FP64 > FP64 : boolean';
		parseAndAddOp: 'FP64 ≤ FP64 : boolean';
		parseAndAddOp: 'FP64 ≥ FP64 : boolean';
		signature
]

{ #category : #builtins }
LbBuiltinSignatures class >> integerSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph:
		(LbBuiltinSortGraphs integerSortGraph
			union: LbBuiltinSortGraphs truthSortGraph))
		addBuiltin: #integers;
		addSignature: self truthSignature includeVars: false;
		"Arithmetic operators"
		parseAndAddOp: 'ℤ + ℤ : ℤ';
		parseAndAddOp: 'ℕ + ℕ : ℕ';
		parseAndAddOp: 'ℕ.nz + ℕ : ℕ.nz';
		parseAndAddOp: 'ℕ + ℕ.nz : ℕ.nz';
		parseAndAddOp: 'ℤ - ℤ : ℤ';
		parseAndAddOp: '-(ℤ) : ℤ';
		parseAndAddOp: 'ℤ × ℤ : ℤ';
		parseAndAddOp: 'ℕ × ℕ : ℕ';
		parseAndAddOp: 'ℕ.nz × ℕ.nz : ℕ.nz';
		parseAndAddOp: 'ℤ.nz × ℤ.nz : ℤ.nz';
		parseAndAddOp: 'ℤ div ℤ.nz : ℤ';
		parseAndAddOp: 'ℕ div ℕ.nz : ℕ';
		parseAndAddOp: 'ℤ rem ℤ.nz : ℤ';
		parseAndAddOp: 'ℕ rem ℕ.nz : ℕ';
		parseAndAddOp: 'ℤ^{ℕ.nz} : ℤ';
		parseAndAddOp: 'ℕ^{ℕ.nz} : ℕ';
		parseAndAddOp: 'ℕ.nz^{ℕ.nz} : ℕ.nz';
		parseAndAddOp: 'ℤ.nz^{ℕ.nz} : ℤ.nz';
		parseAndAddOp: 'ℤ.nz^{zero} : ℕ.nz';
		parseAndAddOp: 'abs(ℤ) : ℕ';
		parseAndAddOp: 'abs(ℤ.nz) : ℕ.nz';
		"Comparison operators"
		parseAndAddOp: 'ℤ < ℤ : boolean';
		parseAndAddOp: 'ℤ > ℤ : boolean';
		parseAndAddOp: 'ℤ ≤ ℤ : boolean';
		parseAndAddOp: 'ℤ ≥ ℤ : boolean';
		signature
]

{ #category : #builtins }
LbBuiltinSignatures class >> rationalNumberSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph:
		(LbBuiltinSortGraphs rationalNumberSortGraph
			union: LbBuiltinSortGraphs truthSortGraph))
		addBuiltin: #rationalNumbers;
		addSignature: self truthSignature includeVars: false;
		addSignature: self integerSignature includeVars: false;
		"Arithmetic operators"
		parseAndAddOp: 'ℚ + ℚ : ℚ';
		parseAndAddOp: 'ℚ.p + ℚ.p : ℚ.p';
		parseAndAddOp: 'ℚ.nn + ℚ.nn : ℚ.nn';
		parseAndAddOp: 'ℚ - ℚ : ℚ';
		parseAndAddOp: '-(ℚ) : ℚ';
		parseAndAddOp: 'ℚ × ℚ : ℚ';
		parseAndAddOp: 'ℚ.p × ℚ.p : ℚ.p';
		parseAndAddOp: 'ℚ.nn × ℚ.nn : ℚ.nn';
		parseAndAddOp: 'ℚ.nz × ℚ.nz : ℚ.nz';
		parseAndAddOp: 'ℚ ÷ ℚ.nz : ℚ';
		parseAndAddOp: 'ℚ.nz ÷ ℚ.nz : ℚ.nz';
		parseAndAddOp: 'ℚ.nn ÷ ℚ.p : ℚ.nn';
		parseAndAddOp: 'ℚ.p ÷ ℚ.p : ℚ.p';
		parseAndAddOp: 'ℚ.nz^{ℤ.nz} : ℚ.nz';
		parseAndAddOp: 'ℚ.p^{ℤ.nz} : ℚ.p';
		parseAndAddOp: 'ℚ.nz^{zero} : ℕ.nz';
		parseAndAddOp: 'abs(ℚ) : ℚ.nn';
		parseAndAddOp: 'abs(ℚ.nz) : ℚ.p';
		"Comparison operators"
		parseAndAddOp: 'ℚ < ℚ : boolean';
		parseAndAddOp: 'ℚ > ℚ : boolean';
		parseAndAddOp: 'ℚ ≤ ℚ : boolean';
		parseAndAddOp: 'ℚ ≥ ℚ : boolean';
		signature
]

{ #category : #builtins }
LbBuiltinSignatures class >> realNumberSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph:
		(LbBuiltinSortGraphs realNumberSortGraph
			union: LbBuiltinSortGraphs truthSortGraph))
		addBuiltin: #realNumbers;
		addSignature: self truthSignature includeVars: false;
		addSignature: self rationalNumberSignature includeVars: false;
		"Arithmetic operators"
		parseAndAddOp: 'ℝ + ℝ : ℝ';
		parseAndAddOp: 'ℝ.p + ℝ.p : ℝ.p';
		parseAndAddOp: 'ℝ.nn + ℝ.nn : ℝ.nn';
		parseAndAddOp: 'ℝ - ℝ : ℝ';
		parseAndAddOp: '-(ℝ) : ℝ';
		parseAndAddOp: 'ℝ × ℝ : ℝ';
		parseAndAddOp: 'ℝ.p × ℝ.p : ℝ.p';
		parseAndAddOp: 'ℝ.nn × ℝ.nn : ℝ.nn';
		parseAndAddOp: 'ℝ ÷ ℝ.nz : ℝ';
		parseAndAddOp: 'ℝ.nz ÷ ℝ.nz : ℝ.nz';
		parseAndAddOp: 'ℝ.p ÷ ℝ.p : ℝ.p';
		parseAndAddOp: 'ℝ.nn ÷ ℝ.p : ℝ.nn';
		parseAndAddOp: 'ℝ.p^{ℝ.nz} : ℝ.p';
		parseAndAddOp: 'ℝ.nz^{ℤ.nz} : ℝ.nz';
		parseAndAddOp: 'ℝ^{ℕ.nz} : ℝ';
		"Various functions"
		parseAndAddOp: 'abs(ℝ) : ℝ.nn';
		parseAndAddOp: 'abs(ℝ.nz) : ℝ.p';
		parseAndAddOp: '√(ℝ.nn) : ℝ.nn';
		parseAndAddOp: '√(ℝ.p) : ℝ.p';
		"Comparison operators"
		parseAndAddOp: #'ℝ < ℝ : boolean';
		parseAndAddOp: #'ℝ > ℝ : boolean';
		parseAndAddOp: #'ℝ ≤ ℝ : boolean';
		parseAndAddOp: #'ℝ ≥ ℝ : boolean';
		signature
]

{ #category : #builtins }
LbBuiltinSignatures class >> stringSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: LbBuiltinSortGraphs stringSortGraph)
		addBuiltin: #strings;
		parseAndAddOp: 'string + string : string';
		signature
]

{ #category : #builtins }
LbBuiltinSignatures class >> truthSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: LbBuiltinSortGraphs truthSortGraph)
		addBuiltin: #truth;
		parseAndAddOp: 'true : boolean';
		parseAndAddOp: 'false : boolean';
		signature
]
