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
LzAnnotationStyler >> context [
	^ LzContextCache uniqueInstance
		contextForPageNamed: self page title
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
LzAnnotationStyler >> styleButton: anLzAnnotation spawning: aBlock [
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
					aButton phlow spawnObject: aBlock value ].
			button ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation [
	self styleButton: anLzAnnotation spawning: [
		LzObjectBuilder new
			context: self context;
			acceptNode: anLzAnnotation ].
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: anAnnotation [
	| attribute pageReference forSortsFlag |
	pageReference := anAnnotation pageName value allButFirst allButLast.
	(LzBook hasPageNamed: pageReference)
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
						(LzBook pageNamed: pageReference)
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
	self styleObjectButton: aTopLevelEqualityAxiom
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleObjectButton: aTopLevelOpAnnotation
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelRule: aTopLevelRule [
	self styleAnnotation: aTopLevelRule.
	self styleAutoHidingAnnotation: aTopLevelRule.
	self styleObjectButton: aTopLevelRule
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSort: aTopLevelSortAnnotation [
	self styleAnnotation: aTopLevelSortAnnotation.
	self styleAutoHidingAnnotation: aTopLevelSortAnnotation.
	self styleObjectButton: aTopLevelSortAnnotation
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	self styleObjectButton: aTopLevelSpecialTerms
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleObjectButton: aTopLevelSubsort
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.
	self styleObjectButton: aTopLevelTermAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	self styleAutoHidingAnnotation: aTopLevelUseContext.
	self styleUseContextButton: aTopLevelUseContext
]
