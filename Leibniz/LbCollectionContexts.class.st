Class {
	#name : #LbCollectionContexts,
	#superclass : #Object,
	#category : #'Leibniz-6-Contexts'
}

{ #category : #private }
LbCollectionContexts class >> emptyListOpSymbolFor: sortSymbol [
	^ #'∅.', sortSymbol
]

{ #category : #builtins }
LbCollectionContexts class >> listOf: sortSymbol [
	| listSortSymbol nonEmptyListSortSymbol |
	listSortSymbol := LbListSort sortNamePrefix , sortSymbol.
	nonEmptyListSortSymbol := LbListSort sortNamePrefix , 'ne.', sortSymbol.
	^ (LbContextBuilder name: 'list-of-', sortSymbol)
		include: (LbBuiltinContexts integerContext) mode: #use;
		parseAndAddSort: sortSymbol;
		parseAndAddSort: listSortSymbol;
		parseAndAddSort: nonEmptyListSortSymbol , ' ⊆ ', listSortSymbol;
		parseAndAddOp: (self emptyListOpSymbolFor: sortSymbol), ' : ', listSortSymbol;
		"Make a list with two elements"
		parseAndAddOp: sortSymbol, ' ++ ', sortSymbol, ' : ', nonEmptyListSortSymbol;
		"Add an element to a list"
		parseAndAddOp: sortSymbol, ' ++ ', listSortSymbol, ' : ', nonEmptyListSortSymbol;
		parseAndAddOp: listSortSymbol, ' ++ ', sortSymbol, ' : ', nonEmptyListSortSymbol;
		"List concatenation"
		parseAndAddOp: listSortSymbol, ' || ', listSortSymbol, ' : ', nonEmptyListSortSymbol;
		parseAndAddOp: 'size(' , listSortSymbol, ') : ℕ';
		parseAndAddRule: 'size(', (self emptyListOpSymbolFor: sortSymbol), ') ⇒ 0';
	context
]
