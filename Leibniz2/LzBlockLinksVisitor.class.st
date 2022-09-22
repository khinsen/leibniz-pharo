Class {
	#name : #LzBlockLinksVisitor,
	#superclass : #LeContentNodeVisitor,
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

{ #category : #scanning }
LzBlockLinksVisitor >> visitTopLevelUseContext: aTopLevelUseContext [
	| pageName |
	pageName := aTopLevelUseContext pageName value.
	self composite links
		add: (LzUseContextLink new
				node: aTopLevelUseContext;
				targetPageTitle: (pageName copyFrom: 2 to: pageName size - 1))
]
