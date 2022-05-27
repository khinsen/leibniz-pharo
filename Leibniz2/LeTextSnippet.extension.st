Extension { #name : #LeTextSnippet }

{ #category : #'*Leibniz2' }
LeTextSnippet >> gtASTFor: aView [
	<gtView>
	^ aView forward
		title: 'AST';
		priority: 5;
		object: [ self ast ];
		view: #gtTreeFor:;
		yourself
]
