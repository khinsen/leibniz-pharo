Class {
	#name : #LbBuiltinContexts,
	#superclass : #Object,
	#category : 'Leibniz-6-Contexts'
}

{ #category : #builtins }
LbBuiltinContexts class >> fpNumberContext [
	<gtExample>
	^ LbContext
		name: 'IEEE-floating-point'
		signature: (LbBuiltinSignatures fpNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems fpNumberRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts class >> integerContext [
	<gtExample>
	^ LbContext
		name: 'integers'
		signature: (LbBuiltinSignatures integerSignature)
		rewriteSystem: (LbBuiltinRewriteSystems integerRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts class >> rationalNumberContext [
	<gtExample>
	^ LbContext
		name: 'rational-numbers'
		signature: (LbBuiltinSignatures rationalNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems rationalNumberRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts class >> realNumberContext [
	<gtExample>
	^ LbContext
		name: 'real-numbers'
		signature: (LbBuiltinSignatures realNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems realNumberRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts class >> stringContext [
	<gtExample>
	^ (LbContextBuilder name: 'strings')
		parseAndAddSort: 'string';
		addBuiltin: #strings;
		parseAndAddOp: 'string + string : string';
		context
]

{ #category : #builtins }
LbBuiltinContexts class >> truthContext [
	<gtExample>
	^ (LbContextBuilder name: 'truth')
		parseAndAddSort: 'boolean';
		addBuiltin: #truth;
		parseAndAddOp: 'true : boolean';
		parseAndAddOp: 'false : boolean';
		context
]
