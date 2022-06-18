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

{ #category : #converting }
TLzPrintable >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
TLzPrintable >> asLeibnizSyntaxTextColored: aColor [
	| text |
	text := self asLeibnizSyntaxString asRopedText.
	text fontName: LzCodeFont defaultFamily.
	text attribute: (BlTextForegroundAttribute color: aColor).
	^ text
]

{ #category : #converting }
TLzPrintable >> asRopedText [
	| text |
	text := '' asRopedText .
	self addAsRopedTextTo: text.
	^ text
]

{ #category : #converting }
TLzPrintable >> asRopedTextColored: aColor [
	| text |
[
	text := self asRopedText.
	LzTextRenderer new
		render: text baseColor: aColor.
] on: Exception do: [ :ex | ex debug ].
	^ text
]

{ #category : #inspecting }
TLzPrintable >> gtSyntaxFor: aView [
	<gtView>
	^ aView explicit
		title: 'Syntax';
		priority: 9;
		stencil: [
			BrEditorElement new
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c vertical matchParent. 
					c horizontal matchParent ];
				editor: (BrTextEditor new
					beReadOnlyWithSelection;
					text: (self asLeibnizSyntaxString asRopedText
								fontName: LzCodeFont defaultFamily;
								glamorousRegularSize) ) ]
]

{ #category : #printing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream [
	self notYetImplemented
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
