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
