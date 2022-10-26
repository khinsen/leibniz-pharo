Trait {
	#name : #TLzPrintable,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #converting }
TLzPrintable >> addAsRopedTextTo: aRopedText [
	self notYetImplemented
]

{ #category : #converting }
TLzPrintable >> addAsRopedTextTo: aRopedText parenthesized: aBoolean [
	aBoolean ifTrue: [ aRopedText append:
		('(' asRopedText attribute: LzParenthesisAttribute new) ].
	self addAsRopedTextTo: aRopedText.
	aBoolean ifTrue: [ aRopedText append:
		(')' asRopedText attribute: LzParenthesisAttribute new) ]
]

{ #category : #converting }
TLzPrintable >> addTextTo: text [ 
]

{ #category : #printing }
TLzPrintable >> asLeibnizSyntax [
	^ self asRopedTextColored: Color black
]

{ #category : #converting }
TLzPrintable >> asLeibnizSyntaxString [
	"^ self asLeibnizSyntax asString"
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
TLzPrintable >> asRopedText [
	^ LzCodeFont textFrom: [ :t |
		self addAsRopedTextTo: t ]
]

{ #category : #converting }
TLzPrintable >> asRopedTextColored: aColor [
	| text |
	text := self asRopedText.
	LzTextRenderer new
		render: text baseColor: aColor.
	^ text
]

{ #category : #converting }
TLzPrintable >> do: aBlock to: aRopedText withAttribute: aBlTextAttribute [
	self do: aBlock to: aRopedText withAttributes: { aBlTextAttribute }
]

{ #category : #converting }
TLzPrintable >> do: aBlock to: aRopedText withAttributes: anArrayOfAttributes [
	| size |
	size := aRopedText size.
	aBlock value: aRopedText.
	anArrayOfAttributes ifNotEmpty: [
		aRopedText
			attributes: anArrayOfAttributes
			from: size + 1 to: aRopedText size + 1 ]
]

{ #category : #inspecting }
TLzPrintable >> gtSyntaxFor: aView [
	<gtView>
	^ aView explicit
		title: 'Syntax';
		priority: 9;
		stencil: [ (LzSyntaxLabel for: self) asElement
					padding: (BlInsets all: 10) ]
]

{ #category : #printing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream [
	aStream << self asLeibnizSyntax asString
	"self notYetImplemented"
]

{ #category : #printing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $(. ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $). ]
]

{ #category : #printing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean parents: aSet [
	aBoolean ifTrue: [ aStream nextPut: $(. ].
	self printAsLeibnizSyntaxOn: aStream parents: aSet.
	aBoolean ifTrue: [ aStream nextPut: $). ]
]

{ #category : #printing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream parents: aSet [
	self notYetImplemented
]

{ #category : #printing }
TLzPrintable >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '('''.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ''')'
]
