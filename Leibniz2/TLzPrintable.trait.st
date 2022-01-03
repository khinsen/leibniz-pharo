Trait {
	#name : #TLzPrintable,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
TLzPrintable >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : #accessing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream [
	self notYetImplemented
]
