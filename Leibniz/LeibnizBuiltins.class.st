"
My unique instance is a special document that contains the built-in contexts of Leibniz.
"
Class {
	#name : #LeibnizBuiltins,
	#superclass : #LeibnizDocument,
	#category : #'Leibniz-7-Documents'
}

{ #category : #initialization }
LeibnizBuiltins >> createContextContext [
	| contextsBuilder |
	contextsBuilder := self newContextBuilderNamed: 'contexts'.
	contextsBuilder include: 'strings' inMode: 'use'.
	contextsBuilder addSort: #context.
	contextsBuilder addOp: #context withArgs: #(#string) ofSort: #context.
	contextsBuilder addOp: #context withArgs: #(#string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-sort' withArgs: #(#context #string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-sort-prefix' withArgs: #(#context #string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-include' withArgs: #(#context #context #context) ofSort: #context.
	contextsBuilder addOp: #'remove-vars' withArgs: #(#context) ofSort: #context.
	contextsBuilder build.
]

{ #category : #initialization }
LeibnizBuiltins >> createFPContext [
	| fpNumbers |
	fpNumbers := self newContextBuilderNamed: 'IEEE-floating-point'.
	fpNumbers include: 'integers' inMode: 'use'.
	"Generic FP Sorts"
	fpNumbers addSort: #FP.
	fpNumbers addSort: #'FP.number'.
	fpNumbers addSort: #'FP.NaN'.
	fpNumbers addSort: #'FP.inf'.
	fpNumbers make: #'FP.number' subsortOf: #'FP'.
	fpNumbers make: #'FP.NaN' subsortOf: #'FP'.
	fpNumbers make: #'FP.inf' subsortOf: #'FP'.
	"Single-precision FP sorts"
	fpNumbers addSort: #FP32.
	fpNumbers addSort: #'FP32-number'.
	fpNumbers addSort: #'FP32-NaN'.
	fpNumbers addSort: #'FP32-inf'.
	fpNumbers make: #'FP32' subsortOf: #'FP'.
	fpNumbers make: #'FP32-number' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-number' subsortOf: #'FP.number'.
	fpNumbers make: #'FP32-NaN' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-NaN' subsortOf: #'FP.NaN'.
	fpNumbers make: #'FP32-inf' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-inf' subsortOf: #'FP.inf'.
	"Double-precision FP sorts"
	fpNumbers addSort: #FP64.
	fpNumbers addSort: #'FP64-number'.
	fpNumbers addSort: #'FP64-NaN'.
	fpNumbers addSort: #'FP64-inf'.
	fpNumbers make: #'FP64' subsortOf: #'FP'.
	fpNumbers make: #'FP64-number' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-number' subsortOf: #'FP.number'.
	fpNumbers make: #'FP64-NaN' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-NaN' subsortOf: #'FP.NaN'.
	fpNumbers make: #'FP64-inf' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-inf' subsortOf: #'FP.inf'.
	"Floating-point literals"
	fpNumbers addBuiltin: #fpNumbers.
	"Arithmetic operators, single precision"
	fpNumbers addOp: #'_+' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'_-' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'-' withArgs: #(#FP32) ofSort: #FP32.
	fpNumbers addOp: #'_×' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'_÷' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'^' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'^' withArgs: #(#FP32 #'ℤ') ofSort: #FP32.
	fpNumbers addOp: #'abs' withArgs: #(#FP32) ofSort: #FP32.
	fpNumbers addOp: #'√' withArgs: #(#FP32) ofSort: #FP32.
	"Arithmetic operators, double precision"
	fpNumbers addOp: #'_+' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'_-' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'-' withArgs: #(#FP64) ofSort: #FP64.
	fpNumbers addOp: #'_×' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'_÷' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'^' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'^' withArgs: #(#FP64 #'ℤ') ofSort: #FP64.
	fpNumbers addOp: #'abs' withArgs: #(#FP64) ofSort: #FP64.
	fpNumbers addOp: #'√' withArgs: #(#FP64) ofSort: #FP64.
	"Comparison operators, single precision"
	fpNumbers addOp: #'_<' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_>' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_≤' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_≥' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	"Comparison operators, double precision"
	fpNumbers addOp: #'_<' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_>' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_≤' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_≥' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	"Build the context"
	fpNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createIntegerContext [
	| integers |
	self createIntegerContextWithoutRules.
	integers := self newContextBuilderNamed: 'integers'.
	integers include: 'integers-without-rules' inMode: 'extend'.
	"addition rules"
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X + Zero ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero + X ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X + Y → ''X + Y'':LeibnizIntegerTerm'.
	"subtraction rules"
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X - Zero ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero - X ⇒ -(X)'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X - Y → ''X - Y'':LeibnizIntegerTerm'.
	integers parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ -(X) → ''X negated'':LeibnizIntegerTerm'.
	"multiplication rules"
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X × Zero ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero × X ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ 1 × X ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ X × 1 ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X × Y → ''X * Y'':LeibnizIntegerTerm'.
	"division rules"
	integers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	integers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	"exponentiation rules"
	integers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero X^{Zero} ⇒ 1'.
	integers parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℕ.nz X^{Y} → ''X raisedTo: Y'':LeibnizIntegerTerm'.
	"abs rules"
	integers parseAndAddRule: '∀ X:ℤ abs(X) → ''X abs'':LeibnizIntegerTerm'.
	"comparison rules"
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X < Y → ''X < Y'':LeibnizBooleanTerm'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X > Y → ''X > Y'':LeibnizBooleanTerm'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≤ Y → ''X <= Y'':LeibnizBooleanTerm'.
	integers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≥ Y → ''X >= Y'':LeibnizBooleanTerm'.
	"Build context"
	integers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createIntegerContextWithoutRules [
	| integers |
	integers := self newContextBuilderNamed: 'integers-without-rules'.
	integers include: 'truth' inMode: 'use'.
	"Natural numbers"
	integers parseAndAddSort: 'ℕ'.
	integers parseAndAddSort: 'zero ⊆ ℕ'.
	integers parseAndAddSort: 'ℕ.nz ⊆ ℕ'.
	"Integers"
	integers parseAndAddSort: 'ℤ'.
	integers parseAndAddSort: 'ℕ ⊆ ℤ'.
	integers parseAndAddSort: 'ℤ.nz ⊆ ℤ'.
	integers parseAndAddSort: 'ℕ.nz ⊆ ℤ.nz'.
	"Integer literals"
	integers addBuiltin: #integers.
	"Arithmetic operators"
	integers parseAndAddOp: 'ℤ + ℤ : ℤ'.
	integers parseAndAddOp: 'ℕ + ℕ : ℕ'.
	integers parseAndAddOp: 'ℕ.nz + ℕ : ℕ.nz'.
	integers parseAndAddOp: 'ℕ + ℕ.nz : ℕ.nz'.
	integers parseAndAddOp: 'ℤ - ℤ : ℤ'.
	integers parseAndAddOp: '-(ℤ) : ℤ'.
	integers parseAndAddOp: 'ℤ × ℤ : ℤ'.
	integers parseAndAddOp: 'ℕ × ℕ : ℕ'.
	integers parseAndAddOp: 'ℕ.nz × ℕ.nz : ℕ.nz'.
	integers parseAndAddOp: 'ℤ.nz × ℤ.nz : ℤ.nz'.
	integers parseAndAddOp: 'ℤ div ℤ.nz : ℤ'.
	integers parseAndAddOp: 'ℕ div ℕ.nz : ℕ'.
	integers parseAndAddOp: 'ℤ rem ℤ.nz : ℤ'.
	integers parseAndAddOp: 'ℕ rem ℕ.nz : ℕ'.
	integers parseAndAddOp: 'ℤ^{ℕ.nz} : ℤ'.
	integers parseAndAddOp: 'ℕ^{ℕ.nz} : ℕ'.
	integers parseAndAddOp: 'ℕ.nz^{ℕ.nz} : ℕ.nz'.
	integers parseAndAddOp: 'ℤ.nz^{ℕ.nz} : ℤ.nz'.
	integers parseAndAddOp: 'ℤ.nz^{zero} : ℕ.nz'.
	integers parseAndAddOp: 'abs(ℤ) : ℕ'.
	integers parseAndAddOp: 'abs(ℤ.nz) : ℕ.nz'.
	"Comparison operators"
	integers parseAndAddOp: 'ℤ < ℤ : boolean'.
	integers parseAndAddOp: 'ℤ > ℤ : boolean'.
	integers parseAndAddOp: 'ℤ ≤ ℤ : boolean'.
	integers parseAndAddOp: 'ℤ ≥ ℤ : boolean'.
	"Build context"
	integers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRationalContext [
	| rationalNumbers |
	self createRationalContextWithoutRules.
	rationalNumbers := self newContextBuilderNamed: 'rational-numbers'.
	rationalNumbers include: 'rational-numbers-without-rules' inMode: 'extend'.
	"addition rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X + Zero ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero + X ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X + Y → ''X + Y'':LeibnizRationalNumberTerm'.
	"Subtraction rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X - Zero ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero - X ⇒ -(X)'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X - Y → ''X - Y'':LeibnizRationalNumberTerm'.
	"Negation rules"
	rationalNumbers parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ -(X) → ''X negated'':LeibnizRationalNumberTerm'.
	"Multiplication rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X × Zero ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero × X ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ 1 × X ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ X × 1 ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X × Y → ''X * Y'':LeibnizRationalNumberTerm'.
	"Division rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ.nz ∀ Zero:zero Zero ÷ X ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ X ÷ 1 ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ.nz X ÷ Y → ''X / Y'':LeibnizRationalNumberTerm'.
	"Integer div and rem rules"
	rationalNumbers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X'.
	rationalNumbers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	rationalNumbers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	"Exponentiation rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ.nz ∀ Zero:zero X^{Zero} ⇒ 1'.
	rationalNumbers parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ.nz ∀ Y:ℤ.nz X^{Y} → ''X raisedTo: Y'':LeibnizRationalNumberTerm'.
	"Abs rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ abs(X) → ''X abs'':LeibnizRationalNumberTerm'.
	"Comparison rules"
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X < Y → ''X < Y'':LeibnizBooleanTerm'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X > Y → ''X > Y'':LeibnizBooleanTerm'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≤ Y → ''X <= Y'':LeibnizBooleanTerm'.
	rationalNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≥ Y → ''X >= Y'':LeibnizBooleanTerm'.
	"Build context"
	rationalNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRationalContextWithoutRules [
	| rationalNumbers |
	rationalNumbers := self newContextBuilderNamed: 'rational-numbers-without-rules'.
	rationalNumbers include: 'integers-without-rules' inMode: 'extend'.
	rationalNumbers addSort: #'ℚ'.
	rationalNumbers make: #'ℤ' subsortOf: 'ℚ'.
	rationalNumbers addSort: #'ℚ.nz'.
	rationalNumbers make: #'ℚ.nz'subsortOf: #'ℚ'.
	rationalNumbers make: #'ℤ.nz'subsortOf: #'ℚ.nz'.
	rationalNumbers addSort: #'ℚ.p'.
	rationalNumbers make: #'ℚ.p'subsortOf: #'ℚ.nz'.
	rationalNumbers make: #'ℕ.nz'subsortOf: #'ℚ.p'.
	rationalNumbers addSort: #'ℚ.nn'.
	rationalNumbers make: #'ℚ.nn'subsortOf: #'ℚ'.
	rationalNumbers make: #'ℚ.p'subsortOf: #'ℚ.nn'.
	rationalNumbers make: #'ℕ'subsortOf: #'ℚ.nn'.
	"Rational number literals"
	rationalNumbers addBuiltin: #rationalNumbers.
	"Arithmetic operators"
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ.nn' #'ℚ.nn') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_-' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'-' withArgs: #(#'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.nn' #'ℚ.nn') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.nz' #'ℚ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ' #'ℚ.nz') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.nz' #'ℚ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.nn' #'ℚ.p') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.nz' #'ℤ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.p' #'ℤ.nz') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.nz' #'zero') ofSort: #'ℕ.nz'.
	rationalNumbers addOp: #'abs' withArgs: #(#'ℚ') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'abs' withArgs: #(#'ℚ.nz') ofSort: #'ℚ.p'.
	"Comparison operators"
	rationalNumbers addOp: #'_<' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_>' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_≤' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_≥' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	"Build context"
	rationalNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRealNumberContext [
	| realNumbers |
	self createRealNumberContextWithoutRules.
	realNumbers := self newContextBuilderNamed: 'real-numbers'.
	realNumbers include: 'real-numbers-without-rules' inMode: 'extend'.
	"addition rules"
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X + Zero ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero + X ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X + Y → ''X + Y'':LeibnizRationalNumberTerm'.
	"Subtraction rules"
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X - Zero ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero - X ⇒ -(X)'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X - Y → ''X - Y'':LeibnizRationalNumberTerm'.
	"Negation rules"
	realNumbers parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℚ -(X) → ''X negated'':LeibnizRationalNumberTerm'.
	"Multiplication rules"
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X × Zero ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero × X ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℝ 1 × X ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℝ X × 1 ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X × Y → ''X * Y'':LeibnizRationalNumberTerm'.
	"Division rules"
	realNumbers parseAndAddRule: '∀ X:ℝ.nz ∀ Zero:zero Zero ÷ X ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℝ X ÷ 1 ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ.nz X ÷ Y → ''X / Y'':LeibnizRationalNumberTerm'.
	"Integer div and rem rules"
	realNumbers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X'.
	realNumbers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	realNumbers parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LeibnizIntegerTerm'.
	"Exponentiation rules"
	realNumbers parseAndAddRule: '∀ X:ℝ.nz ∀ Zero:zero X^{Zero} ⇒ 1'.
	realNumbers parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0'.
	realNumbers parseAndAddRule: '∀ X:ℚ.nz ∀ Y:ℤ.nz X^{Y} → ''X raisedTo: Y'':LeibnizRationalNumberTerm'.
	"Abs rules"
	realNumbers parseAndAddRule: '∀ X:ℚ abs(X) → ''X abs'':LeibnizRationalNumberTerm'.
	"Comparison rules"
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X < Y → ''X < Y'':LeibnizBooleanTerm'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X > Y → ''X > Y'':LeibnizBooleanTerm'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≤ Y → ''X <= Y'':LeibnizBooleanTerm'.
	realNumbers parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≥ Y → ''X >= Y'':LeibnizBooleanTerm'.
	"Build the context"
	realNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRealNumberContextWithoutRules [
	| realNumbers |
	realNumbers := self newContextBuilderNamed: 'real-numbers-without-rules'.
	realNumbers include: 'rational-numbers-without-rules' inMode: 'extend'.
	"Sorts"
	realNumbers addSort: #'ℝ'.
	realNumbers make: #'ℚ' subsortOf: #'ℝ'.
	realNumbers addSort: #'ℝ.nz'.
	realNumbers make: #'ℝ.nz' subsortOf: #'ℝ'.
	realNumbers make: #'ℚ.nz' subsortOf: #'ℝ.nz'.
	realNumbers addSort: #'ℝ.p'.
	realNumbers make: #'ℝ.p' subsortOf: #'ℝ.nz'.
	realNumbers make: #'ℚ.p' subsortOf: #'ℝ.p'.
	realNumbers addSort: #'ℝ.nn'.
	realNumbers make: #'ℝ.nn' subsortOf: #'ℝ'.
	realNumbers make: #'ℝ.p' subsortOf: #'ℝ.nn'.
	realNumbers make: #'ℚ.nn' subsortOf: #'ℝ.nn'.
	"Arithmetic operators"
	realNumbers addOp: #'_+' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_+' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_+' withArgs: #(#'ℝ.nn' #'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'_-' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'-' withArgs: #(#'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ.nn' #'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ' #'ℝ.nz') ofSort: #'ℝ'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.nz' #'ℝ.nz') ofSort: #'ℝ.nz'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.nn' #'ℝ.p') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ.p' #'ℝ.nz') ofSort: #'ℝ.p'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ.nz' #'ℤ.nz') ofSort: #'ℝ.nz'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ' #'ℕ.nz') ofSort: #'ℝ'.
	"Various functions"
	realNumbers addOp: #'abs' withArgs: #(#'ℝ') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'abs' withArgs: #(#'ℝ.nz') ofSort: #'ℝ.p'.
	realNumbers addOp: #'√' withArgs: #(#'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'√' withArgs: #(#'ℝ.p') ofSort: #'ℝ.p'.
	"Comparison operators"
	realNumbers addOp: #'_<' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_>' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_≤' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_≥' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	"Build the context"
	realNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createStringContext [
	| string |
	string := self newContextBuilderNamed: 'strings'.
	string addSort: #string.
	string addBuiltin: #strings.
	string addOp: #'_+' withArgs: #(#string #string) ofSort: #string.
	string build.

]

{ #category : #initialization }
LeibnizBuiltins >> createTruthContext [
	| truth uvar1 uvar2 equalityPattern |
	self flag: #todo.
	truth := self newContextBuilderNamed: 'truth'.
	truth addSort: #boolean.
	truth addBuiltin: #truth.
	truth addOp: #true ofSort: #boolean.
	truth addOp: #false ofSort: #boolean.
	"The special equality operator"
"	truth addOp: #'_==' withArgs: #(nil nil) ofSort: #boolean.
"	"The special rule for term equality a == b"
"	uvar1 := LbUniversalVarTerm symbol: #X forSignature: truth signature.
	uvar2 := LbUniversalVarTerm symbol: #Y forSignature: truth signature.
	equalityPattern := LbOpTerm symbol: #'_==' args: { uvar1. uvar2 } sort: #boolean
											  forSignature: truth signature.
	truth addRule: (LbFunctionRule pattern: equalityPattern function: #('X = Y' #LbBooleanTerm)).
"	truth build.

]

{ #category : #initialization }
LeibnizBuiltins >> initialize [
	super initialize.
	self docHash: (SHA256 hashMessage: 'builtins') hex.
	self createTruthContext.
	self createIntegerContext.
	self createRationalContext.
	self createRealNumberContext.
	self createStringContext.
	self createContextContext.
	self createFPContext.

]
