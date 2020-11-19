Class {
	#name : #LbBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz-6-Contexts'
}

{ #category : #builtins }
LbBuiltinContexts >> stringContext [
	<gtExample>
	^ (LbContextBuilder name: 'strings')
		parseAndAddSort: 'string';
		addBuiltin: #strings;
		parseAndAddOp: 'string + string : string';
		context
]

{ #category : #builtins }
LbBuiltinContexts >> truthContext [
	<gtExample>
	^ (LbContextBuilder name: 'truth')
		parseAndAddSort: 'boolean';
		addBuiltin: #truth;
		parseAndAddOp: 'true : boolean';
		parseAndAddOp: 'false : boolean';
		context
]
