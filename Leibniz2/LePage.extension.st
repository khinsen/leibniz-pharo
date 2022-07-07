Extension { #name : #LePage }

{ #category : #'*Leibniz2' }
LePage >> gtDependentsFor: aView [
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
LePage >> lzContextFor: anAction [
	<gtAction>
	self database = LzBook database ifFalse: [ ^ anAction noAction ].
	^ anAction button
		tooltip: 'Inspect the page''s context';
		priority: 1;
		icon: BrGlamorousIcons fromhere;
		action: [ :aButton |
			aButton phlow spawnObject:
				(LzContextCache uniqueInstance
					contextForPageNamed: self title) ]
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
					pageDeclarationsFor:  self) ]
]
