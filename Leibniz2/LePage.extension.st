Extension { #name : #LePage }

{ #category : #'*Leibniz2' }
LePage >> asLzPage [
	^ self
]

{ #category : #'*Leibniz2' }
LePage >> lzContext [
	^ (LzGlobalCache uniqueInstance
		contextCacheFor: self) pageContext
]

{ #category : #'*Leibniz2' }
LePage >> lzContextFor: anAction [
	<gtAction>
	self database = LzBook database ifFalse: [ ^ anAction noAction ].
	^ anAction button
		tooltip: 'Inspect the page''s contexts';
		priority: 1;
		icon: BrGlamorousIcons fromhere;
		action: [ :aButton |
			aButton phlow spawnObject:
				(LzGlobalCache uniqueInstance
					contextCacheFor: self) ]
]

{ #category : #'*Leibniz2' }
LePage >> lzDeclarationsFor: anAction [
	<gtAction>
	self database = LzBook database ifFalse: [ ^ anAction noAction ].
	^ anAction button
		tooltip: 'Inspect the page''s declarations';
		priority: 2;
		icon: BrGlamorousIcons debug;
		action: [ :aButton |
			aButton phlow spawnObject:
				(LzGlobalCache uniqueInstance
					declarationCacheFor:  self) ]
]

{ #category : #'*Leibniz2' }
LePage >> lzDependenciesFor: aView [
	<gtView>
	^ aView list
		title: 'Dependencies';
		priority: 6;
		items: [ (LzGlobalCache uniqueInstance
					recursiveDependenciesOf: self title)
					asArray ];
		send: [ :each | LzBook pageNamed: each ];
		yourself
]

{ #category : #'*Leibniz2' }
LePage >> lzDependencyGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Dependency graph';
		priority: 4;
		initialize: self lzDependencyMondrian
]

{ #category : #'*Leibniz2' }
LePage >> lzDependencyMondrian [
	| aMondrian nodesAndEdges nodes edges findPage |
	nodesAndEdges := (LzGlobalCache uniqueInstance
							dependenceGraphOf: self title).
	findPage := [ :title | LzBook pageNamed: title ].
	nodes := nodesAndEdges first collect: [ :each |
		findPage value: each ].
	edges := nodesAndEdges second collect: [ :each |
		{ findPage value: each first . findPage value: each second } ].
	aMondrian := GtMondrian new.
	aMondrian nodes
		shape: [ :page | LzGraphicsElements
					graphNodeLabelled: page title
					highlightColor:
						(page == self
							ifTrue: [ Color black ]
							ifFalse: [ nil ])];
		with: nodes.
	aMondrian edges
		shape: [ :x | LzGraphicsElements graphArrow ];
		fromCenterTop;
		toCenterBottom;
		connect: edges
			from: #first
			to: #second.
	aMondrian layout
		custom: (GtGradHorizontalDominanceTreeLayout new reverse: true).
	^ aMondrian
]

{ #category : #'*Leibniz2' }
LePage >> lzDependentsFor: aView [
	<gtView>
	^ aView list
		title: 'Dependents';
		priority: 5;
		items: [ (LzGlobalCache uniqueInstance
					recursiveDependentsOf: self title)
					asArray ];
		send: [ :each | LzBook pageNamed: each ];
		yourself
]

{ #category : #'*Leibniz2' }
LePage >> lzHTMLLocalExportActionFor: anAction [
	<gtAction>
	self database ifNil: [ ^ anAction noAction ].
	self database isDatabase ifFalse: [ ^ anAction noAction ].

	^ anAction button
		label: 'LzHTML';
		tooltip: 'Export the page into Leibniz HTML format and store locally';
		priority: 10;
		icon: BrGlamorousVectorIcons spawn;
		action: [ :aButton | 
			| tempDir output |
			tempDir := GtTemporaryDirectory new.
			output := LzHtmlPageExporter exportPage: self to: tempDir reference.
			output optionAt: GtTemporaryDirectory put: tempDir.
			aButton phlow spawnObject: output ]
]

{ #category : #'*Leibniz2' }
LePage >> lzSubcontext: aSubcontextName [
	^ (LzGlobalCache uniqueInstance
		contextCacheFor: self) subcontext: aSubcontextName
]

{ #category : #'*Leibniz2' }
LePage >> nestingLevel [
	^ 0
]
