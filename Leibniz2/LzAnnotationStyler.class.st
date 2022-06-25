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
LzAnnotationStyler >> colorFor: aDeclarationAnnotation [
	| color |
	color := LzColors declarationColor.
	(aDeclarationAnnotation optionsAt: #example)
		ifTrue: [ color := LzColors exampleColor ].
	(aDeclarationAnnotation optionsAt: #subcontext)
		ifNotNil: [ color := LzColors exampleColor ].
	^ color
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
LzAnnotationStyler >> styleDeclarationButton: anLzAnnotation [
	| annotatedDeclaration declaration color |
	annotatedDeclaration := LzDeclarationBuilder new
			acceptNode: anLzAnnotation.
	declaration := annotatedDeclaration declaration.
	color := self colorFor: annotatedDeclaration.
	self
		styleButton: anLzAnnotation
		label: (declaration asRopedTextColored: color)
		spawning: [ declaration ].
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation [
	| text object annotatedDeclaration color |
	text := [
		object :=  LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: anLzAnnotation.
		annotatedDeclaration := object first.
		object := object second.
		color := self colorFor: annotatedDeclaration.
		annotatedDeclaration asRopedTextColored: color.
	] on: Exception do: [ :ex |
		ex debug.
		object := ex.
		ex return: (ex printString asRopedText foreground: Color red) ].
	self
		styleButton: anLzAnnotation
		label: text
		spawning: [ object ].
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation color: aColor [
	| text object annotatedDeclaration color |
	text := [
		object :=  LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: anLzAnnotation.
		annotatedDeclaration := object first.
		object := object second.
		color := self colorFor: annotatedDeclaration.
		annotatedDeclaration asRopedTextColored: color.
	] on: Exception do: [ :ex |
		ex debug.
		ex return: (ex printString asRopedText foreground: Color red) ].
	self
		styleButton: anLzAnnotation
		label: text
		spawning: [ object second ].
]

{ #category : #styling }
LzAnnotationStyler >> styleUseContextButton: aTopLevelUseContext [
	| declaration pageReference color attribute label |
	self styleAutoHidingAnnotation: aTopLevelUseContext.

	declaration := LzDeclarationBuilder new acceptNode: aTopLevelUseContext.
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
		from: aTopLevelUseContext parent startPosition
		to: aTopLevelUseContext parent stopPosition
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
	self styleDeclarationButton: aTopLevelEqualityAxiom
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleDeclarationButton: aTopLevelOpAnnotation
]

{ #category : #visiting }
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

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	self styleDeclarationButton: aTopLevelSpecialTerms
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleObjectButton: aTopLevelSubsort
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	| object term text color annotatedDeclaration |
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.

	color := LzColors exampleColor.
	text := [
		| output |
		object := LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: aTopLevelTermAnnotation.
		annotatedDeclaration := object first.
		term := object second.
		output := annotatedDeclaration asRopedTextColored: color.
		(annotatedDeclaration optionsAt: #withSort)
			ifTrue: [
				| value colon sort |
				value := annotatedDeclaration asRopedTextColored: color.
				colon := ' : ' asRopedText foreground: color lzDeemphasized.
				sort := term sort asRopedTextColored: color lzDeemphasized.
				output append: colon.
				output append: sort ].
		(annotatedDeclaration optionsAt: #withNormalForm)
			ifTrue: [
				| normalForm |
				normalForm := term normalForm asRopedTextColored: color.
				output append: (' ⇒ ' asRopedText foreground: color).
				output append: normalForm ].
		output
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
	| annotation declaration pageReference color attribute label subcontext |
	self styleAutoHidingAnnotation: aTopLevelUseContext.

	annotation := LzDeclarationBuilder new acceptNode: aTopLevelUseContext.
	declaration := annotation declaration.
	pageReference := declaration contextName.
	(LzBook hasPageNamed: pageReference)
		ifFalse: [ ^ self ].

	color := self colorFor: annotation.
	label := pageReference asRopedText
		foreground: color.
	declaration subcontext ifNotNil: [ :s |
		label append: (('/', s) asRopedText foreground:  color) ].
	(annotation optionsAt: #forSorts)
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
		from: aTopLevelUseContext parent startPosition
		to: aTopLevelUseContext parent stopPosition
]
