Class {
	#name : #LzBlockLinksVisitor,
	#superclass : #LzParseTreeNodeVisitor,
	#traits : 'TSmaCCComponentVisitor + TLzParseTreeNodeVisitor',
	#classTraits : 'TSmaCCComponentVisitor classTrait + TLzParseTreeNodeVisitor classTrait',
	#category : #'Leibniz2-Lepiter'
}

{ #category : #initializing }
LzBlockLinksVisitor class >> initialize [
	LeBlockLinksVisitor addComponentVisitorClass: self.
]

{ #category : #initializing }
LzBlockLinksVisitor class >> obsolete [
	LeBlockLinksVisitor removeComponentVisitorClass: self.
	^ super obsolete
]

{ #category : #visiting }
LzBlockLinksVisitor >> acceptNode: aSmaCCParseNode [
	"A copy of TSmaCCComponentVisitor>>#acceptNode: for
	 resolving a trait conflict."
	aSmaCCParseNode isNil
		ifTrue: [ ^ nil ].
	^ composite notNil
		ifTrue: [ composite acceptNode: aSmaCCParseNode ]
		ifFalse: [ aSmaCCParseNode acceptVisitor: self ]
]

{ #category : #scanning }
LzBlockLinksVisitor >> visitTopLevelUseContext: aTopLevelUseContext [
	| pageName |
	pageName := aTopLevelUseContext pageName value.
	pageName := pageName copyFrom: 2 to: pageName size - 1.
	pageName := ($/ split: pageName) first.
	self composite links
		add: (LzUseContextLink new
				node: aTopLevelUseContext;
				targetPageTitle: pageName)
]
