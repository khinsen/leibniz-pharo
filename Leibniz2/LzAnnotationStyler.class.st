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
LzAnnotationStyler >> styleDeclarationButton: anLzAnnotation [
	| annotatedDeclaration declaration label attribute |
	annotatedDeclaration := LzDeclarationBuilder new
			acceptNode: anLzAnnotation.
	declaration := annotatedDeclaration declaration.
	label := (LzSyntaxLabel
				for: declaration
				color: (self colorFor: annotatedDeclaration))
				declaration: declaration.
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [ (label beSmallSize) asElement
					padding: (BlInsets top: 2 left: 0 bottom: 0 right: 0) ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleObjectButton: anLzAnnotation [
	| object annotatedDeclaration declaration label attribute |
	[
		object :=  LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: anLzAnnotation.
		annotatedDeclaration := object first.
		declaration := annotatedDeclaration declaration.
		object := object second.
		label := (LzSyntaxLabel
					for: declaration
					color: (self colorFor: annotatedDeclaration))
					declaration: declaration ;
					object: object.
	] on: Exception do: [ :ex |
		ex freeze.
		label := LzSyntaxLabel new
					text: (ex printString asRopedText foreground: Color red);
					declaration: ex ].
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [ (label beSmallSize) asElement
					padding: (BlInsets top: 2 left: 0 bottom: 0 right: 0) ].
	self text
		attribute: attribute
		from: anLzAnnotation parent startPosition
		to: anLzAnnotation parent stopPosition
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
	(self text from: aSmaCCError parent startPosition to: aSmaCCError parent stopPosition)
		fontName: LzCodeFont defaultFamily.
	(self text from: aSmaCCError startPosition to: aSmaCCError stopPosition)
		underlineColor: Color red
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	self styleAnnotation: aTopLevelEqualityAxiom.
	self styleAutoHidingAnnotation: aTopLevelEqualityAxiom.
	self styleObjectButton: aTopLevelEqualityAxiom
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
	| label attribute |
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.

	[
		| color object term annotatedDeclaration declaration  output |
		color := LzColors exampleColor.
		object := LzObjectBuilder new
			contextPageName: self page title;
			acceptNode: aTopLevelTermAnnotation.
		annotatedDeclaration := object first.
		declaration := annotatedDeclaration declaration.
		term := object second.
		output := annotatedDeclaration asRopedTextColored: color.
		term sort isKind ifTrue: [
			output attribute:
				(BlTextDecorationAttribute new
					underline;
					color: Color red) ].
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
				output append: (' ⇒ ' asRopedText foreground: color; fontName: LzCodeFont defaultFamily).
				output append: normalForm ].
		label := LzSyntaxLabel new
					text: output;
					declaration: declaration;
					object: term
	] on: Exception do: [ :ex |
	 	ex freeze.
	 	label := LzSyntaxLabel new
					text: (ex printString asRopedText foreground: Color red);
					declaration: ex  ].

	attribute := GtButtonAttribute new
		beAppend;
		stencil: [ label beSmallSize ].
	self text
		attribute: attribute
		from: aTopLevelTermAnnotation parent startPosition
		to: aTopLevelTermAnnotation parent stopPosition
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	| annotation declaration pageReference color attribute label |
	self styleAnnotation: aTopLevelUseContext.

	annotation := LzDeclarationBuilder new acceptNode: aTopLevelUseContext.
	declaration := annotation declaration.
	pageReference := declaration contextName.
	(LzBook hasPageNamed: pageReference)
		ifFalse: [
			self text
				attribute: (BlTextForegroundAttribute paint: Color red)
				from: aTopLevelUseContext parent startPosition
				to: aTopLevelUseContext parent stopPosition.
			^ self ].

	self styleAutoHidingAnnotation: aTopLevelUseContext.

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
