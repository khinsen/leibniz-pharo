Trait {
	#name : #TLzPrintable,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
TLzPrintable >> asLeibnizSyntaxString [
	^ String streamContents: [ :s |
		self printAsLeibnizSyntaxOn: s ]
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

{ #category : #accessing }
TLzPrintable >> printAsLeibnizSyntaxOn: aStream [
	self notYetImplemented
]
