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
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ∧ y_ = y_ ∧ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ∧ y_) ∧ z_ = x_ ∧ (y_ ∧ z_)';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ∨ y_ = y_ ∨ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ∨ y_) ∨ z_ = x_ ∨ (y_ ∨ z_)';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ⊻ y_ = y_ ⊻ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ⊻ y_) ⊻ z_ = x_ ⊻ (y_ ⊻ z_)'.
	self booleanRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzExampleContexts class >> booleanRulesFor: builder [
	builder
		"1. Eliminate NOT and OR"

		"1a. NOT is replaced by XOR with ⊤"
		rule: '∀ x_:𝔹 ¬(x_) ⇒ ⊤ ⊻ x_';

		"1b. OR is replaced by XOR and AND"
		rule: '∀ y_:𝔹  ∀ x_:𝔹 x_ ∨ y_ ⇒ x_ ⊻ y_ ⊻ (x_ ∧ y_)';

		"2 Simplify AND relations"

		"2a. AND is ⊥ if one of its arguments is ⊥"
		rule: '∀ x_:𝔹 x_ ∧ ⊥ ⇒ ⊥';
		rule: '∀ x_:𝔹 ⊥ ∧ x_ ⇒ ⊥';

		"2b. If one argument of AND is ⊤, the result is the other argument"
		rule: '∀ x_:𝔹 x_ ∧ ⊤ ⇒ x_';
		rule: '∀ x_:𝔹 ⊤ ∧ x_ ⇒ x_';

		"2c. If the two arguments to AND are equal, they are also equal to the result"
		rule: '∀ x_:𝔹 x_ ∧ x_ ⇒ x_';

		"3 Simplify XOR relations"

		"3a. XOR with ⊥ leaves truth values unchanged"
		rule: '∀ x_:𝔹 x_ ⊻ ⊥ ⇒ x_';
		rule: '∀ x_:𝔹 ⊥ ⊻ x_ ⇒ x_';

		"3b. If the two arguments to XOR are equal, the result is ⊥"
		rule: '∀ x_:𝔹 x_ ⊻ x_ ⇒ ⊥';

		"4. Standardize combinations of XOR and AND"
		rule: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 x_ ∧ (y_ ⊻ z_) ⇒ (x_ ∧ y_) ⊻ (x_ ∧ z_)'.
]
