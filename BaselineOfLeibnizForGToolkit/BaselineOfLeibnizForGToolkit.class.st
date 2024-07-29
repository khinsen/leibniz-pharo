Class {
	#name : #BaselineOfLeibnizForGToolkit,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibnizForGToolkit
}

{ #category : #accessing }
BaselineOfLeibnizForGToolkit class >> databaseName [
	^ 'Leibniz documentation'
]

{ #category : #accessing }
BaselineOfLeibnizForGToolkit class >> lepiterDatabase [
	| logicalDB |
	logicalDB := LeDatabasesRegistry defaultLogicalDatabase.
	logicalDB
		databaseNamed: self databaseName
		ifNone: [ self loadLepiter ].
	^ logicalDB
		databaseNamed: self databaseName
]

{ #category : #accessing }
BaselineOfLeibnizForGToolkit class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'leibniz-pharo' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'documentation'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> applyPatchForHtmlExportOfLfAndTab [
	"Patch GT's HTML generation code to properly deal with \n and \t in Lepiter text snippets.
	 Submitted as a PR: https://github.com/feenkcom/lepiter/pull/6"
	LeHtmlTextSnippetVisitor compile: 'visitText: aText
	| aString |
	aString := aText content.
	aString size = 1
		ifFalse: [ context html escape: aString ]
		ifTrue: [
	aString first = Character lf
		ifTrue: [ context html nextPutAll: ''<br>'' ]
		ifFalse: [
	aString first = Character tab
		ifTrue: [ context html nextPutAll: ''&emsp;'' ]
		ifFalse: [ context html escape: aString ] ] ].

	exportedNodes add: aText'.
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> applyPatchForHtmlExportOfMethodSourceCode [
	"Patch GT's HTML generation code to wrap exported method source code in a <pre> tag.
	 Submitted as a PR: https://github.com/feenkcom/lepiter/pull/7"
	 LeHtmlTextSnippetAnnotationVisitor compile: 'visitMethodAnnotation: aMethodAnnotation
	| methodNameArgument method methodExists |
	methodNameArgument := aMethodAnnotation nameNode.
	method := methodNameArgument imageObject.
	methodExists := method isNotNil.

	context html
		inlineTag: #code
		attributes: {#class. ''annotation annotation-label annotation-label-method annotation-label-code expandable-annotation-label {1}''
				format: {(aMethodAnnotation isExpanded and: [ methodExists ])
							ifTrue: [ ''annotation-sibling-is-expanded'' ]
							ifFalse: [ ''annotation-sibling-is-collapsed'' ]}}
		with: (aMethodAnnotation hasLabel
				ifTrue: [ aMethodAnnotation label ]
				ifFalse: [ methodNameArgument fullName ]).
				
	methodExists ifFalse: [ ^ self ].
				
	context html 
		tag: #span
		attributes: {#class. ''textual-snippet code-snippet pharo-method-snippet expandable-annotation-view {1}''
				format: {(aMethodAnnotation isExpanded)
							ifTrue: [ ''expanded-annotation-view'' ]
							ifFalse: [ ''collapsed-annotation-view'' ]}}
		do: [ 
			context html
				inlineTag: #pre
				do: [
					context html
						inlineTag: #code
						attributes: #(''class'' '''')
						with: method sourceCode ] ]'.
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> applyPatchForHtmlExportOfNestingLevelsForSnippets [
	"Patch GT's HTML generation code to add a class on each <div> for a text snippet that indicates
	 its nesting level in the page. This permits proper indentation via CSS. This code
	 relies on the extension method 'nestingLevel' on LeContent and subclasses 'LePage' and 'LeSnippet'."
	LeHtmlVisitor compile: 'visitTextSnippet: aLeTextSnippet
	context html
		tag: #div
		attributes: (self
				classesFor: aLeTextSnippet
				withClasses: ''snippet textual-snippet text-snippet nesting-level-'', (aLeTextSnippet nestingLevel printString))
		do: [ | visitor |
			visitor := LeHtmlTextSnippetVisitor new
					context: context;
					snippet: aLeTextSnippet.

			aLeTextSnippet ast acceptVisitor: visitor ].

	self visitContent: aLeTextSnippet'.
	"Same for Pharo snippets"
	LeHtmlVisitor compile: 'visitPharoSnippet: aLePharoSnippet
	context html
		tag: #div
		attributes: (self
				classesFor: aLePharoSnippet
				withClasses: ''snippet textual-snippet code-snippet pharo-snippet nesting-level-'', (aLePharoSnippet nestingLevel printString))
		do: [ context html
				tag: #pre
				attributes: #(''class'' ''no_bottom_margin'')
				with: aLePharoSnippet code ].
	^ self visitContent: aLePharoSnippet'.
	"Same for Python code snippet"
	LeHtmlVisitor compile: 'visitPythonSnippet: aLePythonSnippet
	context html
		tag: #div
		attributes: (self
				classesFor: aLePythonSnippet
				withClasses: ''snippet textual-snippet code-snippet python-snippet nesting-level-'', (aLePythonSnippet nestingLevel printString))
		do: [ context html
				tag: #pre
				attributes: #(''class'' ''no_bottom_margin'')
				with: aLePythonSnippet code ].
	^ self visitContent: aLePythonSnippet'
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec postLoadDoIt: #'postload:package:'.

		spec
			baseline: 'RecursiveWriteBarrier' 
			with: [ spec repository: 'github://khinsen/RecursiveWriteBarrier:master/src' ].

		spec
			baseline: 'SingletonTrait' 
			with: [ spec repository: 'github://khinsen/SingletonTrait:master' ].

		spec
			package: 'Leibniz2'
			with: [ spec requires:
						#('RecursiveWriteBarrier'
							'SingletonTrait') ].

		spec
			package: 'RecurrenceEquations'
			with: [ spec requires:
						#('Leibniz2') ].
]
]

{ #category : #baseline }
BaselineOfLeibnizForGToolkit >> postload: loader package: packageSpec [
	LzCodeFont chooseDefaultFamily.
	self applyPatchForHtmlExportOfLfAndTab.
	self applyPatchForHtmlExportOfMethodSourceCode.
	self applyPatchForHtmlExportOfNestingLevelsForSnippets.
	self class loadLepiter.
	GtWorld allInstances do: [ :aGtWorld |
		aGtWorld root children first home updateWidget ]
]
