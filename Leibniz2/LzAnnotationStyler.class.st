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

{ #category : #private }
LzAnnotationStyler >> inTextButton: aString type: aSymbol [
	| color button |

	button := BrButton new.
	button connector beVisualSource.

	aSymbol = #declaration
		ifTrue: [ color := LzColors declarationColor ].
	aSymbol = #example
		ifTrue: [ color := LzColors exampleColor ].

	button 
		addAptitude: (BrGlamorousButtonLabelAptitude new 
			defaultColor: color;
			hoveredColor: color muchDarker;
			fontName: LzCodeFont defaultFamily);
		padding: (BlInsets top: 2 left: 0 bottom: 0 right: 0);
		margin: (BlInsets top: -1 left: 0 bottom: 0 right: 0);
		icon: BrGlamorousVectorIcons inspect;
		beSmallSize;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent. ];
		label: aString.
	^ button
]

{ #category : #private }
LzAnnotationStyler >> inTextButton: aString type: aSymbol spawning: aBlock [
	^ (self inTextButton: aString type: aSymbol)
		action: [ :aButton |
					aButton phlow spawnObject: aBlock value ]
]

{ #category : #accessing }
LzAnnotationStyler >> page [
	^ self snippet page
]

{ #category : #private }
LzAnnotationStyler >> parseOptions: aTopLevelAnnotation [
	^ (aTopLevelAnnotation options collect: [ :each |
		each key source
			-> (LzDeclarationBuilder new acceptNode: each value) value ])
		asDictionary
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
LzAnnotationStyler >> styleButton: anLzAnnotation label: aString type: aSymbol spawning: aBlock [
	| attribute |
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			self inTextButton: aString type: aSymbol spawning: aBlock ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleButton: anLzAnnotation type: aSymbol spawning: aBlock [
	| label |
	label := (LzDeclarationBuilder new acceptNode: anLzAnnotation)
				asLeibnizSyntaxString "anLzAnnotation source".
	self styleButton: anLzAnnotation label: label type: aSymbol spawning: aBlock
]

{ #category : #styling }
LzAnnotationStyler >> styleDeclarationButton: anLzAnnotation type: aSymbol [
	| declaration |
	declaration := LzDeclarationBuilder new
			acceptNode: anLzAnnotation.
	self
		styleButton: anLzAnnotation
		label: declaration asLeibnizSyntaxString
		type: aSymbol
		spawning: [ declaration ].
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation text: aBlock type: aSymbol [
	| object label |
	object := [ LzObjectBuilder new
					context: self context;
					acceptNode: anLzAnnotation ]
			on: Exception do: [ :ex | ex debug. ex return: ex ].
	label := [ aBlock value: object first ]
			on: Exception do: [ object second printString ].
	self
		styleButton: anLzAnnotation
		label: label
		type: aSymbol
		spawning: [ object second ].
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation type: aSymbol [
	self styleObjectButton: anLzAnnotation text: #asLeibnizSyntaxString type: aSymbol
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: anAnnotation options: aDictionary [
	| attribute pageReference forSortsFlag |
	pageReference := anAnnotation pageName value allButFirst allButLast.
	(LzBook hasPageNamed: pageReference)
		ifFalse: [ ^ self ].
	forSortsFlag := (aDictionary at: 'forSorts' ifAbsent: [ 'no' ]) = 'yes'.
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			| button label |
			label := forSortsFlag
				ifTrue: [ pageReference, ' (in sorts)' ]
				ifFalse: [ pageReference ].
			button := self inTextButton: label
				type: #declaration.
			button
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
	self styleDeclarationButton: aTopLevelEqualityAxiom type: #declaration
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleDeclarationButton: aTopLevelOpAnnotation type: #declaration
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelRule: aTopLevelRule [
	self styleAnnotation: aTopLevelRule.
	self styleAutoHidingAnnotation: aTopLevelRule.
	self styleDeclarationButton: aTopLevelRule type: #declaration
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSort: aTopLevelSortAnnotation [
	| options type |
	options := self parseOptions: aTopLevelSortAnnotation.
	type := (options at: #example ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ #example ]
		ifFalse: [ #declaration ].
	self styleAnnotation: aTopLevelSortAnnotation.
	self styleAutoHidingAnnotation: aTopLevelSortAnnotation.
	self styleObjectButton: aTopLevelSortAnnotation type: type
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	self styleDeclarationButton: aTopLevelSpecialTerms type: #declaration
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleObjectButton: aTopLevelSubsort type: #declaration
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	| options display |
	options := self parseOptions: aTopLevelTermAnnotation.
	display := (options at: 'withSort' ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ [ :term |
			term asLeibnizSyntaxString , ' : ', term sort asLeibnizSyntaxString] ]
		ifFalse: [ #asLeibnizSyntaxString ].
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.
	self styleObjectButton: aTopLevelTermAnnotation text: display type: #example
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	| options type |
	options := self parseOptions: aTopLevelUseContext.
	self styleAutoHidingAnnotation: aTopLevelUseContext.
	self styleUseContextButton: aTopLevelUseContext options: options
]
