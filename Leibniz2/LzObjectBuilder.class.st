Class {
	#name : #LzObjectBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#instVars : [
		'contextPageName'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #accessing }
LzObjectBuilder >> contextPageName [
	^ contextPageName
]

{ #category : #accessing }
LzObjectBuilder >> contextPageName: aString [
	contextPageName := aString
]

{ #category : #accessing }
LzObjectBuilder >> parseOptions: aTopLevelAnnotation [
	^ (aTopLevelAnnotation options collect: [ :each |
		each key source
			-> (LzDeclarationBuilder new acceptNode: each value) value ])
		asDictionary
]

{ #category : #private }
LzObjectBuilder >> patternFromTerm: aTerm vars: aVarList context: aContext [
	^ (LzPatternDeclaration new
		variables: aVarList;
		term: aTerm)
		buildFor: aContext signature
]

{ #category : #building }
LzObjectBuilder >> rewriteCacheAndSubcontext: aString [
	^ (LzGlobalCache uniqueInstance
			contextCacheFor: self contextPageName)
		rewriteCacheAndSubcontext: aString
]

{ #category : #visiting }
LzObjectBuilder >> sortFromTerm: aTerm vars: aVarList [
	| sortTerm |
	sortTerm := self patternFromTerm: aTerm vars: aVarList context: self context sortGraph sortContext.
	^ self context sortGraph sortWithTerm: sortTerm
]

{ #category : #building }
LzObjectBuilder >> subcontext: aString [
	^ (LzGlobalCache uniqueInstance
			contextCacheFor: self contextPageName)
		subcontext: aString
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	| annotation declaration context |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelEqualityAxiom.
	declaration := annotation declaration.
	context := self subcontext:(annotation optionsAt: #subcontext).
	^ (annotation optionsAt: #example)
		ifTrue: [ { annotation.
						declaration } ]
		ifFalse: [ { annotation.
						context signature parsedAxiom: declaration } ]
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelOp: aTopLevelOp [
	| annotation declaration context |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelOp.
	declaration := annotation declaration.
	context := self subcontext:(annotation optionsAt: #subcontext).
	^ (annotation optionsAt: #example)
		ifTrue: [ { annotation.
						declaration } ]
		ifFalse: [ { annotation.
						context signature operators findOp: declaration } ]
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelRule: aTopLevelRule [
	| annotation declaration context |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelRule.
	declaration := annotation declaration.
	context := self subcontext:(annotation optionsAt: #subcontext).
	^ (annotation optionsAt: #example)
		ifTrue: [ { annotation.
						declaration } ]
		ifFalse: [ { annotation.
						context signature parsedRule: declaration } ]
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelSort: aTopLevelSort [
	| annotation declaration context |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelSort.
	declaration := annotation declaration.
	context := self subcontext:(annotation optionsAt: #subcontext).
	^ (annotation optionsAt: #example)
		ifTrue: [ { annotation.
						declaration } ]
		ifFalse: [ { annotation.
						context sortGraph familyForParsedOp: declaration op } ]
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelSubsort: aTopLevelSubsort [
	| annotation declaration context subsortAxiom |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelSubsort.
	declaration := annotation declaration.
	context := self subcontext:(annotation optionsAt: #subcontext).
	subsortAxiom := context signature sortGraph sortContext signature
						parsedAxiom: declaration.
	^ { annotation.
			LzSubsortRelation new
				sortGraph: context signature sortGraph;
				axiom: subsortAxiom }
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelTerm: aTopLevelTerm [
	| annotation declaration cacheAndContext term |
	annotation := LzDeclarationBuilder new acceptNode: aTopLevelTerm.
	declaration := annotation declaration.
	cacheAndContext := self rewriteCacheAndSubcontext:(annotation optionsAt: #subcontext).
	term := cacheAndContext second parsedPattern: declaration.
	^ { annotation.
		LzTermInContext
			term: term
			context: cacheAndContext second
			rewriteCache: cacheAndContext first }
]
