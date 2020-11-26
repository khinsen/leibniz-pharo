Class {
	#name : #LbRewriteSystemExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-4-Rules'
}

{ #category : #example }
LbRewriteSystemExamples >> booleanMatchingRules [
	<gtExample>
	^ self booleanRewriteSystem rulesMatching:
		(LbSignatureExamples new booleanSignature parseTerm: 'true ∧ true')
]

{ #category : #example }
LbRewriteSystemExamples >> booleanReductions [
	<gtExample>
	| rws |
	rws := self booleanRewriteSystem.
	^ {
		{ '¬(true)'. 'false' }.
		{ '¬(false)'. 'true' }.
		{ '¬(¬(false))'. 'false' }.

		{ 'false ∧ false'. 'false' }.
		{ 'false ∧ true'. 'false' }.
		{ 'true ∧ false'. 'false' }.
		{ 'true ∧ true'. 'true' }.

		{ 'false ∨ false'. 'false' }.
		{ 'false ∨ true'. 'true' }.
		{ 'true ∨ false'. 'true' }.
		{ 'true ∨ true'. 'true' }.

		{ 'false ⊻ false'. 'false' }.
		{ 'false ⊻ true'. 'true' }.
		{ 'true ⊻ false'. 'true' }.
		{ 'true ⊻ true'. 'false' }.
	} collect: [ :each |
		| input result reference |
		input := rws signature parseTerm: each first.
		result := rws reduce: input.
		reference := rws signature parseTerm: each second.
		self assert: result equals: reference.
		{ input. result } ]
]

{ #category : #example }
LbRewriteSystemExamples >> booleanRewriteSystem [
	<gtExample>
	^ (LbRewriteSystemBuilder signature: LbSignatureExamples new booleanSignature)
		"1. Eliminate NOT and OR"

		"1a. NOT is replaced by XOR with true"
		parseAndAddRule: '∀ X:boolean ¬(X) ⇒ true ⊻ X';

		"1b. OR is replaced by XOR and AND"
		parseAndAddRule: '∀ Y:boolean  ∀ X:boolean X ∨ Y ⇒ X ⊻ Y ⊻ (X ∧ Y)';

		"2 Simplify AND relations"

		"2a. AND is false if one of its arguments is false"
		parseAndAddRule: '∀ X:boolean X ∧ false ⇒ false';
		parseAndAddRule: '∀ X:boolean false ∧ X ⇒ false';

		"2b. If one argument of AND is true, the result is the other argument"
		parseAndAddRule: '∀ X:boolean X ∧ true ⇒ X';
		parseAndAddRule: '∀ X:boolean true ∧ X ⇒ X';

		"2c. If the two arguments to AND are equal, they are also equal to the result"
		parseAndAddRule: '∀ X:boolean X ∧ X ⇒ X';

		"3 Simplify XOR relations"

		"3a. XOR with false leaves truth values unchanged"
		parseAndAddRule: '∀ X:boolean X ⊻ false ⇒ X';
		parseAndAddRule: '∀ X:boolean false ⊻ X ⇒ X';

		"3b. If the two arguments to XOR are equal, the result is false"
		parseAndAddRule: '∀ X:boolean X ⊻ X ⇒ false';

		"4. Standardize combinations of XOR and AND"
		parseAndAddRule: '∀ X:boolean ∀ Y:boolean ∀ Z:boolean X ∧ (Y ⊻ Z) ⇒ (X ∧ Y) ⊻ (X ∧ Z)';

		"Build the rewrite system"
		rewriteSystem
]

{ #category : #example }
LbRewriteSystemExamples >> booleanRewrites [
	<gtExample>
	| rws |
	rws := self booleanRewriteSystem.
	^ {
		{ '¬(true)'. 'true ⊻ true' }.
		{ '¬(false)'. 'true ⊻ false' }.

		{ 'false ∧ false'. 'false' }.
		{ 'false ∧ true'. 'false' }.
		{ 'true ∧ false'. 'false' }.
		{ 'true ∧ true'. 'true' }.

		{ 'false ∨ false'. 'false ⊻ false ⊻ (false ∧ false)' }.
		{ 'false ∨ true'. 'false ⊻ true ⊻ (false ∧ true)' }.
		{ 'true ∨ false'. 'true ⊻ false ⊻ (true ∧ false)' }.
		{ 'true ∨ true'. 'true ⊻ true ⊻ (true ∧ true)' }.

		{ 'false ⊻ false'. 'false' }.
		{ 'false ⊻ true'. 'true' }.
		{ 'true ⊻ false'. 'true' }.
		{ 'true ⊻ true'. 'false' }.
	} collect: [ :each |
		| input result reference |
		input := rws signature parseTerm: each first.
		result := rws rewriteHeadOnce: input.
		reference := rws signature parseTerm: each second.
		self assert: result equals: reference.
		"All the inputs have literal 'true' or 'false' as
		 arguments, and therefore rewriteLeftmostInnermost:
		 yields the same results as rewriteHeadOnce:"
		result := rws rewriteLeftmostInnermost: input.
		self assert: result equals: reference.
		{ input. result } ]
]

{ #category : #accessing }
LbRewriteSystemExamples >> equalityTerms [
	<gtExample>
	| rws |
	rws := self booleanRewriteSystem.
	^ {
		#('true == true' 'true' 'true').
		#('true == false' 'false' 'false').
		#('¬(true) == false' 'false' 'true').
	} collect: [ :each |
		| term rewriteResult reduceResult |
		term := rws signature parseTerm: each first.
		rewriteResult := rws signature parseTerm: each second.
		reduceResult := rws signature parseTerm: each third.
		self assert: (rws rewriteHeadOnce: term ) equals: rewriteResult.
		self assert: (rws reduce: term ) equals: reduceResult.
		term ]
]

{ #category : #example }
LbRewriteSystemExamples >> integerMatchingRules [
	<gtExample>
	^ LbBuiltinRewriteSystems integerRewriteSystem rulesMatching:
		(LbBuiltinSignatures integerSignature parseTerm: 'abs(-5)')
]

{ #category : #example }
LbRewriteSystemExamples >> integerMatchingRulesWithFailedCondition [
	<gtExample>
	^ LbBuiltinRewriteSystems integerRewriteSystem rulesMatching:
		(LbBuiltinSignatures integerSignature parseTerm: 'abs(5)')
]

{ #category : #example }
LbRewriteSystemExamples >> rewriteSystemWithVarHeadRule [
	<gtExample>
	"Note: this is not a useful rewrite system. It is meant
	 for testing only."
	| rws |
	rws := (LbRewriteSystemBuilder signature: LbSignatureExamples new booleanSignature)
		parseAndAddRule: '∀ X:boolean X ∨ Y ⇒ Y';
		parseAndAddRule: '∀ X:boolean X ⇒ true';
		parseAndAddRule: '∀ X:boolean X ∧ Y ⇒ X';
		rewriteSystem.
	self
		assert: rws rules keys asSet
		equals: { LbInfixOperatorName for: #'∨'.
					LbInfixOperatorName for: #'∧'} asSet.
	self
		assert: (rws rules values collect: [ :each | each size ])
		equals: #(2 2).
	self
		assert: (rws rules at:
					(LbInfixOperatorName for: #'∨'))
					second pattern headOpName asSymbol
		equals: #Variable.
	self
		assert: (rws rules at:
					(LbInfixOperatorName for: #'∧'))
					first pattern headOpName asSymbol
		equals: #Variable.
	 ^ rws
]
