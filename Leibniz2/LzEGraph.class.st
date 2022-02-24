Class {
	#name : #LzEGraph,
	#superclass : #Object,
	#instVars : [
		'disjointSets',
		'memo',
		'classes',
		'classIdsNeedingRebuild'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #accessing }
LzEGraph >> add: anENode [
	| classId class |
	(self findClassIdFor: anENode)
		ifNotNil: [ :id | ^ id ].
	classId := disjointSets makeSet.
	class := LzEClass new
				addNode: anENode.
	anENode do: [ :child |
		(classes at: child) addParentNode: anENode classId: classId ].
	classes at: classId put: class.
	memo at: anENode put: classId.
	^ classId
]

{ #category : #accessing }
LzEGraph >> canonicalize: anENode [
	anENode canonicalizeIn: self
]

{ #category : #accessing }
LzEGraph >> findClassIdFor: anENode [
	self canonicalize: anENode.
	^ memo at: anENode
		ifPresent: [ :id | self findRootFor:  id ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
LzEGraph >> findRootFor: anEClassId [
	^ disjointSets findRootFor: anEClassId
]

{ #category : #accessing }
LzEGraph >> initialize [
	disjointSets := LzDisjointIntegerSets new.
	memo := IdentityDictionary new.
	classes := Dictionary new.
	classIdsNeedingRebuild := OrderedCollection new.
]

{ #category : #testing }
LzEGraph >> is: anENode inSameClassAs: otherENode [
	^ disjointSets is: (memo at: anENode) inSameSetAs: (memo at: otherENode)
]

{ #category : #accessing }
LzEGraph >> makeSet [
]

{ #category : #accessing }
LzEGraph >> merge: anEClassId with: otherEClassId [
	| root1 root2 mergedId staleId mergedClass staleClass |
	root1 := self findRootFor: anEClassId.
	root2 := self findRootFor: otherEClassId.
	root1 = root2 ifTrue: [ ^ self ].
	mergedId := disjointSets merge: root1 with: root2.
	staleId := mergedId = root2
				ifTrue: [ root1 ] ifFalse: [ root2 ].
	"Transfer nodes from staleClass to mergedClass"
	mergedClass := classes at: mergedId.
	staleClass := classes at: staleId.
	mergedClass addNodes: staleClass nodes.
	staleClass nodesDo: [ :each | 
		self canonicalize: each.
		memo at: each put: mergedId ].
	staleClass parentsDo: [ :node :id | 
		mergedClass addParentNode: node classId: id ].
	classes removeKey: staleId.
	"Put the merged class on the todo list for the next rebuild."
	classIdsNeedingRebuild add: mergedId
]

{ #category : #rebuilding }
LzEGraph >> rebuild [
	[ classIdsNeedingRebuild isEmpty ] whileFalse: [
		| todo |
		todo := classIdsNeedingRebuild collect: [ :each |
			self findRootFor:  each ].
		classIdsNeedingRebuild := OrderedCollection new.
		todo do: [ :each | self repair: each ] ]
]

{ #category : #rebuilding }
LzEGraph >> repair: aClassId [
	| class newParents |
	class := classes at: aClassId.
	class parentsDo: [ :node :id |
		self canonicalize:  node.
		memo at: node put: ((self findRootFor:  id)) ].
	newParents := IdentityDictionary new.
	class parentsDo: [ :node :id |
		(newParents includesKey: node)
			ifTrue: [ self merge: id with: (newParents at: node)].
		newParents at: node put: (self findRootFor: id) ].
	class clearParents.
	newParents keysAndValuesDo: [ :node :id |
		class addParentNode: node classId: id ]
]
