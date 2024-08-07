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
LzAnnotationStyler >> elements [
	^ self composite elements
]

{ #category : #private }
LzAnnotationStyler >> expanded [
	^ self composite expanded
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
LzAnnotationStyler >> styleAutoUpdatingObjectButton: anAnnotation [ 
	^ self
		styleAutoUpdatingObjectButton: anAnnotation
		text: [ :declaration :object :options |
			| color |
			color := LzColors declarationColor.
			(options at: #example ifAbsent: [ false ])
				ifTrue: [ color := LzColors exampleColor ].
			(self subcontextPrefix: (options at: #subcontext ifAbsent: nil)),
				(declaration asRopedTextColored: color) ]
]

{ #category : #styling }
LzAnnotationStyler >> styleAutoUpdatingObjectButton: anAnnotation text: aBlock [
	| annotatedDeclaration declaration attribute |
	annotatedDeclaration := LzDeclarationBuilder new
		acceptNode: anAnnotation.
	declaration := annotatedDeclaration declaration.
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [
			[ LzAutoUpdatingSyntaxLabel new
				page: self page;
				subcontext: (annotatedDeclaration optionsAt: #subcontext);
				declaration: annotatedDeclaration declaration;
				options: annotatedDeclaration options;
				textBlock: aBlock;
				setUp.
			] on: Exception do: [ :ex | ex freeze. ex inspect ] ].
	self text
		attribute: attribute
		from: (anAnnotation parent stopPosition - 1)
		to: anAnnotation parent stopPosition
]

{ #category : #styling }
LzAnnotationStyler >> styleExpandingObject: aTerm in: anAnnotation [
	| cacheKey attribute |
	aTerm hasInlineView ifFalse: [ ^ self ].

	cacheKey := anAnnotation source.
	attribute := (GtCachedTextExpandButtonAttribute new)
		isExpanded: (self expanded at: cacheKey ifAbsentPut: [ true ]);
		attributesCreatingBlock:
				[ (GtResizablePreviewAttribute new)
						withCache: self elements key: cacheKey;
						result: aTerm inlineView;
						showSelector: #gtLiveFor:;
						height: 300 ];
		onCachingDo: [ :aBoolean :theAttribute |
			self expanded at: cacheKey put: aBoolean ].

	self text
		attribute: attribute
		from: anAnnotation parent startPosition
		to: anAnnotation parent stopPosition
]

{ #category : #accessing }
LzAnnotationStyler >> subcontext: aString [
	^ (self page lzDBCache
			contextCacheFor: self page title)
		cachedSubcontext: aString
]

{ #category : #private }
LzAnnotationStyler >> subcontextPrefix: aStringOrNil [
	| prefix |
	aStringOrNil ifNil: [ ^ '' asRopedText ].
	prefix := ('[', aStringOrNil, '] ') asRopedText.
	prefix fontSize: 8.
	prefix attribute:
		(BlTextForegroundAttribute new
			paint: LzColors subcontextColor).
	^ prefix
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
LzAnnotationStyler >> visitTopLevelAsset: aTopLevelAsset [
	self styleAnnotation: aTopLevelAsset.
	self styleAutoHidingAnnotation: aTopLevelAsset.
	self
		styleAutoUpdatingObjectButton: aTopLevelAsset
		text: [ :declaration :object :options |
			| color prefix displayedObject |
			color := LzColors declarationColor.
			(options at: #example ifAbsent: [ false ])
				ifFalse: [ color := LzColors exampleColor ].
			prefix := self subcontextPrefix:
				(options at: #subcontext ifAbsent: nil).
			(options at: #withNormalForm ifAbsent: [ false ])
				ifTrue: [
					| context | 
					context := self subcontext:(options at: #subcontext ifAbsent: [ nil ]).
					displayedObject := object normalFormIn: context ]
				ifFalse: [
					(options at: #withValue ifAbsent: [ false ])
						ifTrue: [ displayedObject := object ]
						ifFalse: [ displayedObject := declaration ] ].
			prefix, (displayedObject asRopedTextColored: color) ]
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	self styleAnnotation: aTopLevelEqualityAxiom.
	self styleAutoHidingAnnotation: aTopLevelEqualityAxiom.
	self styleAutoUpdatingObjectButton: aTopLevelEqualityAxiom
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelOp: aTopLevelOpAnnotation [
	self styleAnnotation: aTopLevelOpAnnotation.
	self styleAutoHidingAnnotation: aTopLevelOpAnnotation.
	self styleAutoUpdatingObjectButton: aTopLevelOpAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelRule: aTopLevelRule [
	self styleAnnotation: aTopLevelRule.
	self styleAutoHidingAnnotation: aTopLevelRule.
	self styleAutoUpdatingObjectButton: aTopLevelRule
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSort: aTopLevelSortAnnotation [
	self styleAnnotation: aTopLevelSortAnnotation.
	self styleAutoHidingAnnotation: aTopLevelSortAnnotation.
	self styleAutoUpdatingObjectButton: aTopLevelSortAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	| annotation declaration prefix label attribute |
	self styleAnnotation: aTopLevelSpecialTerms.
	self styleAutoHidingAnnotation: aTopLevelSpecialTerms.
	annotation := LzDeclarationBuilder new
			acceptNode: aTopLevelSpecialTerms.
	declaration := annotation declaration.
	prefix := self subcontextPrefix:
				(annotation optionsAt: #subcontext).
	label := declaration asRopedTextColored: annotation color.
	attribute := GtButtonAttribute new
		beAppend;
		stencil: [ self inTextButton: prefix, label ].
	self text
		attribute: attribute
		from: aTopLevelSpecialTerms parent startPosition
		to: aTopLevelSpecialTerms parent stopPosition
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelState: aTopLevelStateAnnotation [
	self styleAnnotation: aTopLevelStateAnnotation.
	self styleAutoHidingAnnotation: aTopLevelStateAnnotation.
	self styleAutoUpdatingObjectButton: aTopLevelStateAnnotation
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelSubsort: aTopLevelSubsort [
	self styleAnnotation: aTopLevelSubsort.
	self styleAutoHidingAnnotation: aTopLevelSubsort.
	self styleAutoUpdatingObjectButton: aTopLevelSubsort
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelTerm: aTopLevelTermAnnotation [
	self styleAnnotation: aTopLevelTermAnnotation.
	self styleAutoHidingAnnotation: aTopLevelTermAnnotation.
	self
		styleAutoUpdatingObjectButton: aTopLevelTermAnnotation
		text: [ :declaration :object :options |
			| color output |
			color := LzColors exampleColor.
			output := self subcontextPrefix:
				(options at: #subcontext ifAbsent: nil).
			output := output, (declaration asRopedTextColored: color).
			(object isKindOf: LzTermInContext) ifTrue: [
				(object term sort isKind) ifTrue: [
					output attribute:
						(BlTextDecorationAttribute new
							underline;
							color: Color red) ].

				(options at: #withSort ifAbsent: [ false ]) ifTrue: [
					| value colon sort |
					value := declaration asRopedTextColored: color.
					colon := ' : ' asRopedText foreground: color lzDeemphasized.
					sort := object term sort asRopedTextColored: color lzDeemphasized.
					output append: colon.
					output append: sort ].

				(options at: #withNormalForm) ifTrue: [
					| normalForm |
					normalForm := object normalForm
									asRopedTextColored: LzColors resultColor.
					output append: (' ⇒ ' asRopedText
										foreground: LzColors resultColor;
										fontName: LzCodeFont defaultFamily).
					output append: normalForm ] ].
			output ]
]

{ #category : #visiting }
LzAnnotationStyler >> visitTopLevelUseContext: aTopLevelUseContext [
	| annotation declaration pageReference color attribute label |
	self styleAnnotation: aTopLevelUseContext.
	self styleAutoHidingAnnotation: aTopLevelUseContext.

	annotation := LzDeclarationBuilder new acceptNode: aTopLevelUseContext.
	declaration := annotation declaration.
	pageReference := declaration contextName.
	(self page database hasPageNamed: pageReference)
		ifFalse: [
			self text
				attribute: (BlTextForegroundAttribute paint: Color red)
				from: aTopLevelUseContext parent startPosition
				to: aTopLevelUseContext parent stopPosition.
			^ self ].

	color := annotation color.
	label := (self subcontextPrefix:
				(annotation optionsAt: #subcontext)),
				(pageReference asRopedText foreground: color).
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
						(self page database pageNamed: pageReference)
							asPhlowTool ];
				yourself ].

	self text
		attribute: attribute
		from: aTopLevelUseContext parent startPosition
		to: aTopLevelUseContext parent stopPosition
]
