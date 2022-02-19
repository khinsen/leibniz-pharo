"
The contexts defined in the methods of this class are standard Leibniz contexts. They are provided because they are useful and/or because they are used in other example code.
"
Class {
	#name : #LzExampleContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzExampleContexts class >> booleanContext [
	| builder |
	builder := LzContextBuilder new
		include: LzBuiltinContexts truthContext;
		op: '¬(𝔹) : 𝔹';
		op: '𝔹 ∧ 𝔹 : 𝔹';
		op: '𝔹 ∨ 𝔹 : 𝔹';
		op: '𝔹 ⊻ 𝔹 : 𝔹';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ?x ∧ ?y = ?y ∧ ?x';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ∀ ?z:𝔹 (?x ∧ ?y) ∧ ?z = ?x ∧ (?y ∧ ?z)';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ?x ∨ ?y = ?y ∨ ?x';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ∀ ?z:𝔹 (?x ∨ ?y) ∨ ?z = ?x ∨ (?y ∨ ?z)';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ?x ⊻ ?y = ?y ⊻ ?x';
		axiom: '∀ ?x:𝔹 ∀ ?y:𝔹 ∀ ?z:𝔹 (?x ⊻ ?y) ⊻ ?z = ?x ⊻ (?y ⊻ ?z)'.
	self booleanRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzExampleContexts class >> booleanRulesFor: builder [
	builder
		"1. Eliminate NOT and OR"

		"1a. NOT is replaced by XOR with ⊤"
		rule: '∀ ?x:𝔹 ¬(?x) ⇒ ⊤ ⊻ ?x';

		"1b. OR is replaced by XOR and AND"
		rule: '∀ ?y:𝔹  ∀ ?x:𝔹 ?x ∨ ?y ⇒ ?x ⊻ ?y ⊻ (?x ∧ ?y)';

		"2 Simplify AND relations"

		"2a. AND is ⊥ if one of its arguments is ⊥"
		rule: '∀ ?x:𝔹 ?x ∧ ⊥ ⇒ ⊥';
		rule: '∀ ?x:𝔹 ⊥ ∧ ?x ⇒ ⊥';

		"2b. If one argument of AND is ⊤, the result is the other argument"
		rule: '∀ ?x:𝔹 ?x ∧ ⊤ ⇒ ?x';
		rule: '∀ ?x:𝔹 ⊤ ∧ ?x ⇒ ?x';

		"2c. If the two arguments to AND are equal, they are also equal to the result"
		rule: '∀ ?x:𝔹 ?x ∧ ?x ⇒ ?x';

		"3 Simplify XOR relations"

		"3a. XOR with ⊥ leaves truth values unchanged"
		rule: '∀ ?x:𝔹 ?x ⊻ ⊥ ⇒ ?x';
		rule: '∀ ?x:𝔹 ⊥ ⊻ ?x ⇒ ?x';

		"3b. If the two arguments to XOR are equal, the result is ⊥"
		rule: '∀ ?x:𝔹 ?x ⊻ ?x ⇒ ⊥';

		"4. Standardize combinations of XOR and AND"
		rule: '∀ ?x:𝔹 ∀ ?y:𝔹 ∀ ?z:𝔹 ?x ∧ (?y ⊻ ?z) ⇒ (?x ∧ ?y) ⊻ (?x ∧ ?z)'.
]
