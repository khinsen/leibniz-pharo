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

{ #category : #private }
LzObjectBuilder >> patternFromTerm: aTerm vars: aVarList context: aContext [
	^ (LzASTPattern new
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
	^ self context sortGraph familyForParsedOp:
		(LzDeclarationBuilder new acceptNode: aTopLevelSort)
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelSubsort: aTopLevelSubsort [
	| subsortAxiom subsort supersort |
	subsortAxiom := LzDeclarationBuilder new acceptNode: aTopLevelSubsort.
	subsort := self sortFromTerm: subsortAxiom subsort vars: subsortAxiom variables.
	supersort := self sortFromTerm: subsortAxiom supersort vars: subsortAxiom variables.
	^ LzSortPair
		sort1: subsort
		sort2: supersort.
	"^ LzSortFamilySubsortRelation new
		subsort: (self context sortGraph familyForParsedOp: subsortAxiom subsort);
		supersort: (self context sortGraph familyForParsedOp: subsortAxiom supersort)."
]

{ #category : #visiting }
LzObjectBuilder >> visitTopLevelTerm: aTopLevelTerm [
	^ self context parsedPattern:
		(LzDeclarationBuilder new acceptNode: aTopLevelTerm)
]
