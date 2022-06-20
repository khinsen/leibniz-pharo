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
	self
		do: [ :t |
			t append: '"' asRopedText.
			t append: value asRopedText.
			t append: '"' asRopedText ]
		to: aRopedText
		withAttribute: LzLiteralAttribute new
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
