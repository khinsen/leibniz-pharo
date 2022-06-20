Class {
	#name : #LzStringTerm,
	#superclass : #LzAtomicTerm,
	#category : #'Leibniz2-Terms'
}

{ #category : #rewriting }
LzStringTerm >> , otherString [
	^ self class
		signature: self signature
		value: self value , otherString value
]

{ #category : #converting }
LzStringTerm >> addAsRopedTextTo: aRopedText [
	| size |
	size := aRopedText size.
	aRopedText append: '"' asRopedText.
	aRopedText append: value asRopedText.
	aRopedText append: '"' asRopedText.
	aRopedText
		attribute: LzLiteralAttribute new
		from: size + 1 to: aRopedText size + 1
]

{ #category : #rewriting }
LzStringTerm >> ensureString [
]

{ #category : #printing }
LzStringTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream
		<< $";
		<< value;
		<< $".
]

{ #category : #accessing }
LzStringTerm >> sort [
	^ self signature sort: #string
]
