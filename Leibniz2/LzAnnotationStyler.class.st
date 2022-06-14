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
LzAnnotationStyler >> inTextButton: aText [
	| button |

	button := BrButton new.
	button connector beVisualSource.

	button 
		addAptitude: LzButtonLabelAptitude new;
		padding: (BlInsets top: 2 left: 0 bottom: 0 right: 0);
		margin: (BlInsets top: -1 left: 0 bottom: 0 right: 0);
		beSmallSize;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent. ];
		label: aText.
	^ button
]

{ #category : #private }
LzAnnotationStyler >> inTextButton: aText spawning: aBlock [
	^ (self inTextButton: aText)
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
LzAnnotationStyler >> styleButton: anLzAnnotation label: aText spawning: aBlock [
	| attribute |
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			self inTextButton: aText spawning: aBlock ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleDeclarationButton: anLzAnnotation color: aColor [
	| declaration |
	declaration := LzDeclarationBuilder new
			acceptNode: anLzAnnotation.
	self
		styleButton: anLzAnnotation
		label: (declaration asLeibnizSyntaxTextColored: aColor)
		spawning: [ declaration ].
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation color: aColor [
	self
		styleObjectButton: anLzAnnotation
		text: [ :each | each  asLeibnizSyntaxTextColored: aColor ]
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation text: aBlock [
	| object label |
	object := [ LzObjectBuilder new
					context: self context;
					acceptNode: anLzAnnotation ]
			on: Exception do: [ :ex | ex debug. ex return: ex ].
	label := [ aBlock value: object first ]
			on: Exception do: [ object second printString asRopedText attribute: (BlTextForegroundAttribute color: Color red)].
	self
		styleButton: anLzAnnotation
		label: label
		spawning: [ object second ].
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: anAnnotation options: aDictionary [
	| color attribute pageReference label |
	pageReference := anAnnotation pageName value allButFirst allButLast.
	(LzBook hasPageNamed: pageReference)
		ifFalse: [ ^ self ].

	color := LzColors declarationColor.
	label := pageReference asRopedText
		attribute: (BlTextForegroundAttribute color: color).
	(aDictionary at: 'forSorts' ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ label append: (' (in sorts)' asRopedText attribute: (BlTextForegroundAttribute color: color quiteWhiter)) ].
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			| button |
			button := self inTextButton: label asRopedText.
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
	self styleAnnotation: aSmaCCError.
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	self styleAnnotation: aTopLevelEqualityAxiom.
	self styleAutoHidingAnnotation: aTopLevelEqualityAxiom.
	self styleDeclarationButton: aTopLevelEqualityAxiom color: LzColors declarationColor
]

{ #category : #styling }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleDeclarationButton: aTopLevelOpAnnotation color: LzColors declarationColor
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelRule: aTopLevelRule [
	self styleAnnotation: aTopLevelRule.
	self styleAutoHidingAnnotation: aTopLevelRule.
	self styleDeclarationButton: aTopLevelRule color: LzColors declarationColor
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSort: aTopLevelSortAnnotation [
	| options color |
	options := self parseOptions: aTopLevelSortAnnotation.
	color := (options at: #example ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ LzColors exampleColor ]
		ifFalse: [ LzColors declarationColor ].
	self styleAnnotation: aTopLevelSortAnnotation.
	self styleAutoHidingAnnotation: aTopLevelSortAnnotation.
	self styleObjectButton: aTopLevelSortAnnotation color: color
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	self styleDeclarationButton: aTopLevelSpecialTerms color: LzColors declarationColor
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleObjectButton: aTopLevelSubsort color: LzColors declarationColor
]

{ #category : #generated }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	| options display color |
	color := LzColors exampleColor.
	options := self parseOptions: aTopLevelTermAnnotation.
	display := (options at: 'withSort' ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ [ :term |
			term asLeibnizSyntaxTextColored: color , ' : ', term sort asLeibnizSyntaxTextColored: color] ]
		ifFalse: [ [ :term |  term asLeibnizSyntaxTextColored: color ] ].
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.
	self styleObjectButton: aTopLevelTermAnnotation text: display
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	| options type |
	options := self parseOptions: aTopLevelUseContext.
	self styleAutoHidingAnnotation: aTopLevelUseContext.
	self styleUseContextButton: aTopLevelUseContext options: options
]
