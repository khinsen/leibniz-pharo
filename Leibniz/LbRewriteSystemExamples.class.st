Class {
	#name : #LbRewriteSystemExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-4-Rules'
}

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
