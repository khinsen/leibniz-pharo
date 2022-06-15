Extension { #name : #LePage }

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
