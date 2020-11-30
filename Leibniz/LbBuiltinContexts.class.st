Class {
	#name : #LbBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz-6-Contexts'
}

{ #category : #builtins }
LbBuiltinContexts >> fpNumberContext [
	<gtExample>
	^ LbContext
		name: 'IEEE-floating-point'
		signature: (LbBuiltinSignatures fpNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems fpNumberRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts >> integerContext [
	<gtExample>
	^ LbContext
		name: 'integers'
		signature: (LbBuiltinSignatures integerSignature)
		rewriteSystem: (LbBuiltinRewriteSystems integerRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts >> rationalNumberContext [
	<gtExample>
	^ LbContext
		name: 'rational-numbers'
		signature: (LbBuiltinSignatures rationalNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems rationalNumberRewriteSystem)
]

{ #category : #builtins }
LbBuiltinContexts >> realNumberContext [
	<gtExample>
	^ LbContext
		name: 'real-numbers'
		signature: (LbBuiltinSignatures realNumberSignature)
		rewriteSystem: (LbBuiltinRewriteSystems realNumberRewriteSystem)
]

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
