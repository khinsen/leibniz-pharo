Class {
	#name : #LzHtmlSyntaxPiece,
	#superclass : #Object,
	#traits : 'TLeHtmlPiece',
	#classTraits : 'TLeHtmlPiece classTrait',
	#instVars : [
		'text',
		'segments',
		'segmentAttrs'
	],
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #operating }
LzHtmlSyntaxPiece >> findSegments [
	| attrTable activeAttrs segment |
	attrTable := self syntaxAttributes.
	segments := OrderedCollection new.
	segmentAttrs := OrderedCollection new.
	activeAttrs := nil.
	1 to: text size do: [ :eachIndex |
		| attrs |
		attrs := (text attributesAt: eachIndex)
			collect: #class.
		attrs := attrTable keys select: [ :each | attrs includes: each ].
		(attrs includes: LzDoNotRenderAttribute) ifFalse: [
			attrs = activeAttrs
				ifTrue: [ segment add: (text at: eachIndex) ]
				ifFalse: [
					segmentAttrs add: attrs.
					segment := OrderedCollection with: (text at: eachIndex).
					segments add: segment ] ].
		activeAttrs := attrs ]
]

{ #category : #inspecting }
LzHtmlSyntaxPiece >> gtSegmentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Segments';
		priority: 2;
		items: (1 to: segments size);
		column: 'Item' text: [ :index |
			'''',
			('' join: (segments at: index)),
			'''' ];
		column: 'Attributes' text: [ :index |
			segmentAttrs at: index ];
		send: [ :index | segments at: index ];
		yourself
]

{ #category : #inspecting }
LzHtmlSyntaxPiece >> gtTextFor: aView [
	<gtView>
	^ aView forward
		title: 'Text';
		priority: 1;
		object: [ self text ];
		view: #gtTextFor:;
		yourself
]

{ #category : #'private - writing' }
LzHtmlSyntaxPiece >> renderActionFor: aString withAttrs: attrBlocks [
	^ attrBlocks
		ifEmpty: [ [ :context | context html escape: aString ] ]
		ifNotEmpty: [ [ :context |
						attrBlocks first
							value: context
							value: (self
									renderActionFor: aString
									withAttrs: attrBlocks allButFirst) ] ]
]

{ #category : #accessing }
LzHtmlSyntaxPiece >> syntaxAttributes [
	^ {
		LzDoNotRenderAttribute -> nil.
		LzAssetLabelAttribute -> [ :context :block |
			context html inlineTag: #b class: 'darker' do: [ block value: context ] ].
		LzSubscriptAttribute -> [ :context :block |
			context html inlineTag: #sub do: [ block value: context ] ].
		LzSuperscriptAttribute -> [ :context :block |
			context html inlineTag: #sup do: [ block value: context ] ].
		LzInfixOpNameAttribute -> [ :context :block |
			context html inlineTag: #span class: 'darker' do: [ block value: context ] ].
		LzVarNameAttribute -> [ :context :block |
			context html inlineTag: #u do: [ block value: context ] ].
		LzLeafErrorAttribute -> [ :context :block |
			block value: context ].
		LzParenthesisAttribute -> [ :context :block |
			context html inlineTag: #span class: 'darker' do: [ block value: context ] ].
		LzSortAttribute -> [ :context :block |
			context html inlineTag: #i do: [ block value: context ] ].
		LzVarDeclarationAttribute -> [ :context :block |
			context html inlineTag: #span class: 'whiter' do: [ block value: context ] ].
	} asOrderedDictionary
]

{ #category : #accessing }
LzHtmlSyntaxPiece >> text [
	^ text
]

{ #category : #accessing }
LzHtmlSyntaxPiece >> text: aRopedText [
	text := aRopedText.
	self findSegments
]

{ #category : #'api - writing' }
LzHtmlSyntaxPiece >> writeWithContext: aContext [
	| attrTable |
	attrTable := self syntaxAttributes.
	1 to: segments size do: [ :index |
		(self
			renderActionFor: (segments at: index)
			withAttrs: ((segmentAttrs at: index)
							collect: [ :each | attrTable at: each]))
		value: aContext. ]
]
