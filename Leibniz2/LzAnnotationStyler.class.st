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
					contextPageName: self page title;
					acceptNode: anLzAnnotation ]
			on: Exception do: [ :ex | ex debug. ex return: ex ].
	label := [ aBlock cull: object first ]
			on: Exception do: [ object second printString asRopedText attribute: (BlTextForegroundAttribute color: Color red)].
	self
		styleButton: anLzAnnotation
		label: label
		spawning: [ object second ].
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: anAnnotation [
	| declaration pageReference color attribute label |
	declaration := LzDeclarationBuilder new acceptNode: anAnnotation.
	pageReference := declaration declaration contextName.
	(LzBook hasPageNamed: pageReference)
		ifFalse: [ ^ self ].

	color := LzColors declarationColor.
	label := pageReference asRopedText
		foreground: color.
	(declaration optionsAt: #forSorts)
		ifTrue: [
			label append:
				(' (in sorts)' asRopedText foreground:  color lzDeemphasized) ].
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			(self inTextButton: label)
				action: [ :aButton |
					aButton phlow spawnTool:
						(LzBook pageNamed: pageReference)
							asPhlowTool ];
				yourself ].
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

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	self styleAnnotation: aTopLevelEqualityAxiom.
	self styleAutoHidingAnnotation: aTopLevelEqualityAxiom.
	self styleDeclarationButton: aTopLevelEqualityAxiom color: LzColors declarationColor
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleDeclarationButton: aTopLevelOpAnnotation color: LzColors declarationColor
]

{ #category : #visiting }
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

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	self styleDeclarationButton: aTopLevelSpecialTerms color: LzColors declarationColor
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleObjectButton: aTopLevelSubsort color: LzColors declarationColor
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	| object term text color annotatedDeclaration |
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.

	color := LzColors exampleColor.

	text := [
		object := LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: aTopLevelTermAnnotation.
		annotatedDeclaration := object first.
		term := object second.
		(annotatedDeclaration optionsAt: #withSort)
			ifTrue: [
				| value colon sort |
				value := term asLeibnizSyntaxTextColored: color.
				colon := ' : ' asRopedText foreground: color lzDeemphasized.
				sort := term sort asLeibnizSyntaxTextColored: color lzDeemphasized.
				value, colon, sort ]
			ifFalse: [ term asLeibnizSyntaxTextColored: color ].
	 ] on: Exception do: [ :ex |
	 	ex debug.
	 	ex return: (ex printString asRopedText foreground: Color red) ].

	self
		styleButton: aTopLevelTermAnnotation
		label: text
		spawning: [ term ]
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	| type |
	self styleAutoHidingAnnotation: aTopLevelUseContext.
	self styleUseContextButton: aTopLevelUseContext
]
