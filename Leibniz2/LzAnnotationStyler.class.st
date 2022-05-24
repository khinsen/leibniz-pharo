Class {
	#name : #LzAnnotationStyler,
	#superclass : #LeComponentStyler,
	#traits : 'TLzParseTreeNodeVisitor',
	#classTraits : 'TLzParseTreeNodeVisitor classTrait',
	#category : #'Leibniz2-Lepiter'
}

{ #category : #initializing }
LzAnnotationStyler class >> initialize [
	LeSnippetStylerVisitor additionalStylers add: self
]

{ #category : #initializing }
LzAnnotationStyler class >> obsolete [
	LeSnippetStylerVisitor additionalStylers remove: self ifAbsent: [  ].
	^ super obsolete
]

{ #category : #accessing }
LzAnnotationStyler >> page [
	^ self snippet page
]

{ #category : #accessing }
LzAnnotationStyler >> snippet [
	^ self composite snippetViewModel snippetModel
]

{ #category : #styling }
LzAnnotationStyler >> styleAnnotation: anAnnotation [
	(self text from: anAnnotation parent startPosition to: anAnnotation parent stopPosition)
		fontName: LzCodeFont defaultFamily
]

{ #category : #styling }
LzAnnotationStyler >> styleAutoHidingAnnotation: anAnnotation [
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
LzAnnotationStyler >> styleGenericButton: anLzAnnotation [
	| attribute |
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			| button label |
			label := anLzAnnotation source.
			button := LeSnippetStylerVisitor textLinkButtonPadding:
				(BlInsets top: 2) margin: BlInsets empty.
			button aptitude fontName: LzCodeFont defaultFamily.
			button
				beSmallSize;
				label: label;
				action: [ :aButton |
					aButton phlow spawnObject: anLzAnnotation ].
			button ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleOpButton: aTopLevelOpAnnotation [
	self styleGenericButton: aTopLevelOpAnnotation
]

{ #category : #styling }
LzAnnotationStyler >> styleSortButton: aTopLevelSortAnnotation [
	self styleGenericButton: aTopLevelSortAnnotation
]

{ #category : #styling }
LzAnnotationStyler >> styleTermButton: aTermAnnotation [
	self styleGenericButton: aTermAnnotation
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: anAnnotation [
	| attribute pageReference forSortsFlag |
	pageReference := anAnnotation pageName value allButFirst allButLast.
	(LzBook new database hasPageNamed: pageReference)
		ifFalse: [ ^ self ].
	forSortsFlag := anAnnotation sortFlag
		ifNil: [ false ]
		ifNotNil: [ :f | f value = 'yes' ].
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			| button label |
			label := forSortsFlag
				ifTrue: [ pageReference, ' (in sorts)' ]
				ifFalse: [ pageReference ].
			button := LeSnippetStylerVisitor textLinkButtonPadding:
				(BlInsets top: 2) margin: BlInsets empty.
			button aptitude glamorousRegularFont.
			button
				beSmallSize;
				label: label;
				action: [ :aButton |
					aButton phlow spawnTool:
						(LzBook new database
							pageNamed: pageReference)
							asPhlowTool ].
			button ].
	self text
		attribute: attribute
		from: anAnnotation parent startPosition
		to: anAnnotation parent stopPosition
]

{ #category : #private }
LzAnnotationStyler >> text [
	^ self composite text
]

{ #category : #visiting }
LzAnnotationStyler >> visitParseTree: aParseTree [
	^ self visitSmaCCParseNode: aParseTree
]

{ #category : #visiting }
LzAnnotationStyler >> visitSmaCCError: aSmaCCError [
	self halt.
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	self styleAnnotation: aTopLevelEqualityAxiom.
	self styleAutoHidingAnnotation: aTopLevelEqualityAxiom.
	self styleGenericButton: aTopLevelEqualityAxiom
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleOpButton: aTopLevelOpAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSort: aTopLevelSortAnnotation [
	self styleAnnotation: aTopLevelSortAnnotation.
	self styleAutoHidingAnnotation: aTopLevelSortAnnotation.
	self styleSortButton: aTopLevelSortAnnotation
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.
	self styleTermButton: aTopLevelTermAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	self styleAutoHidingAnnotation: aTopLevelUseContext.
	self styleUseContextButton: aTopLevelUseContext
]
