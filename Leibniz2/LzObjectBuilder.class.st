Class {
	#name : #LzObjectBuilder,
	#superclass : #LzParseTreeNodeVisitor,
	#instVars : [
		'context'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #accessing }
LzObjectBuilder >> context [
	^ context
]

{ #category : #accessing }
LzObjectBuilder >> context: aContext [
	context := aContext
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

{ #category : #visiting }
LzObjectBuilder >> sortFromTerm: aTerm vars: aVarList [
	| sortTerm |
	sortTerm := self patternFromTerm: aTerm vars: aVarList context: self context sortGraph sortContext.
	^ self context sortGraph sortWithTerm: sortTerm
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelSort: aTopLevelSort [
	| options declaration |
	options := self parseOptions: aTopLevelSort.
	declaration := LzDeclarationBuilder new acceptNode: aTopLevelSort.
	^ (options at: #example ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ declaration ]
		ifFalse: [ self context sortGraph familyForParsedOp: declaration op ]
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelSubsort: aTopLevelSubsort [
	| subsortAxiom |
	subsortAxiom := self context signature sortGraph sortContext signature parsedAxiom:
						(LzDeclarationBuilder new acceptNode: aTopLevelSubsort).
	^ LzSubsortRelation new
		sortGraph: self context signature sortGraph;
		axiom: subsortAxiom
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelTerm: aTopLevelTerm [
	| options term |
	options := self parseOptions: aTopLevelTerm.
	term := self context parsedPattern:
		(LzDeclarationBuilder new acceptNode: aTopLevelTerm).
	^ (options at: #withNormalForm ifAbsent: [ 'no' ]) = 'yes'
		ifTrue: [ LzTermWithNormalForm
					term: term
					context: self context]
		ifFalse: [ term ]
]
