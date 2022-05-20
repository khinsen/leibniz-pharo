Class {
	#name : #LzTermStyler,
	#superclass : #LeComponentStyler,
	#traits : 'TLzParseTreeNodeVisitor',
	#classTraits : 'TLzParseTreeNodeVisitor classTrait',
	#category : #'Leibniz2-Lepiter'
}

{ #category : #initializing }
LzTermStyler class >> initialize [
	LeSnippetStylerVisitor additionalStylers add: self
]

{ #category : #initializing }
LzTermStyler class >> obsolete [
	LeSnippetStylerVisitor additionalStylers remove: self ifAbsent: [  ].
	^ super obsolete
]

{ #category : #accessing }
LzTermStyler >> page [
	^ self snippet page
]

{ #category : #accessing }
LzTermStyler >> snippet [
	^ self composite snippetViewModel snippetModel
]

{ #category : #styling }
LzTermStyler >> styleAnnotation: anAnnotation [
	(self text from: anAnnotation parent startPosition to: anAnnotation parent stopPosition)
		fontName: LzCodeFont defaultFamily
]

{ #category : #styling }
LzTermStyler >> styleAutoHidingAnnotation: anAnnotation [
	| first last range |
	first := anAnnotation parent startPosition max: 1.
	last := anAnnotation parent stopPosition min: self text size.
	range := first to: last.
	composite
		styleAutoHiding: range
		and: range
		whenOutside: anAnnotation parent sourceInterval
]

{ #category : #styling }
LzTermStyler >> styleTermButton: aTermAnnotation [
	| attribute |
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			| button label |
			label := aTermAnnotation source.
			button := LeSnippetStylerVisitor textLinkButtonPadding:
				(BlInsets top: 2) margin: BlInsets empty.
			button aptitude fontName: LzCodeFont defaultFamily.
			button
				beSmallSize;
				label: label;
				action: [ :aButton |
					aButton phlow spawnObject: aTermAnnotation ].
			button ].
	self text
		attribute: attribute
		from: aTermAnnotation parent startPosition
		to: aTermAnnotation parent stopPosition
]

{ #category : #private }
LzTermStyler >> text [
	^ self composite text
]

{ #category : #visiting }
LzTermStyler >> visitParseTree: aParseTree [
	self halt.
	^ self visitSmaCCParseNode: aParseTree
]

{ #category : #visiting }
LzTermStyler >> visitSmaCCError: aSmaCCError [
	self halt.
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : #visiting }
LzTermStyler >> visitTerm: aTermAnnotation [
	self styleAnnotation: aTermAnnotation.
	self styleAutoHidingAnnotation: aTermAnnotation.
	self styleTermButton: aTermAnnotation
]
