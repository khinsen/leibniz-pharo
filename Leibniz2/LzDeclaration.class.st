Class {
	#name : #LzDeclaration,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzDeclaration >> associations [
	^ self valueSlots collect: [ :each |
		each -> (self instVarNamed:  each) ]
]

{ #category : #printing }
LzDeclaration >> bodyAsLeibnizSyntaxTextColored: aColor [
	|   text |
	text := (String streamContents: [ :s |
		self printBodyAsLeibnizSyntaxOn: s ])
		asRopedText.
	text attribute: (BlTextForegroundAttribute color: aColor).
	text fontName: LzCodeFont defaultFamily.
	^ text
]

{ #category : #inspecting }
LzDeclaration >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 1;
		items: [ self associations ];
		children: [ :each | 
			each value isLzASTNode
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Field' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #testing }
LzDeclaration >> isLzASTNode [
	^ true
]

{ #category : #printing }
LzDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzDeclaration >> printVariables: variables asLeibnizSyntaxOn: aStream [
	(variables reject: #isDerived)
		do: [ :var |
			var printAsLeibnizSyntaxOn: aStream.
			aStream nextPutAll: ', ' ]
]

{ #category : #accessing }
LzDeclaration >> valueSlots [
	^ self class allInstVarNames
]

{ #category : #printing }
LzDeclaration >> variables: listOfVariables asLeibnizSyntaxTextColored: aColor [
	| color comma text |
	color := aColor lzDeemphasized.
	comma := ', ' asRopedText
		attribute: (BlTextForegroundAttribute color: color).
	text := '' asRopedText.
	(listOfVariables reject: #isDerived)
		do: [ :var |
			text insertText: (var asLeibnizSyntaxTextColored: color) at: text size.
			text insertText: comma at: text size ].
	^ text
]
