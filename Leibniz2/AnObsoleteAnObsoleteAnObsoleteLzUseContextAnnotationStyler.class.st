Class {
	#name : #AnObsoleteAnObsoleteAnObsoleteLzUseContextAnnotationStyler,
	#superclass : #LeComponentStyler,
	#traits : 'AnObsoleteTLzUseContextNodeVisitor',
	#classTraits : 'AnObsoleteTLzUseContextNodeVisitor classTrait',
	#category : #Unclassified
}

{ #category : #initializing }
AnObsoleteAnObsoleteAnObsoleteLzUseContextAnnotationStyler class >> obsolete [
	LeSnippetStylerVisitor additionalStylers remove: self ifAbsent: [  ].
	^ super obsolete
]
