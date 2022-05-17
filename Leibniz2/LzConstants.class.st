Class {
	#name : #LzConstants,
	#superclass : #Object,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzConstants class >> opNameBoolean [
	^ '𝔹'
]

{ #category : #accessing }
LzConstants class >> opNameFalse [
	^ '⊥'
]

{ #category : #accessing }
LzConstants class >> opNameSort [
	^ '𝕊'
]

{ #category : #accessing }
LzConstants class >> opNameTrue [
	^ '⊤'
]

{ #category : #accessing }
LzConstants class >> reservedIdentifiers [
	| rewriteArrow functionArrow equalSign
	  forAllSymbol conditionSymbol subsortSymbol |
	rewriteArrow := '⇒'.
	functionArrow := '→'.
	equalSign := '='.
	forAllSymbol := '∀'.
	conditionSymbol := '|'.
	subsortSymbol := '⊆'.
	^ {
		rewriteArrow.
		functionArrow.
		equalSign.
		forAllSymbol.
		conditionSymbol.
		subsortSymbol
		}
]
