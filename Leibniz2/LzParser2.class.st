Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 45] 
#[ 0 6 0 97] 
#[ 0 70 1 129] 
#[ 0 74 1 133] 
#[ 0 78 1 145] 
#[ 0 78 1 149] 
#[ 0 78 1 153] 
#[ 0 138 1 145] 
#[ 0 138 1 149] 
#[ 0 138 1 153] 
#[ 0 78 0 138] 
#[ 0 46 1 245] 
#[ 0 166 1 133] 
#[ 0 178 2 21] 
#[ 0 226 0 238] 
#[ 0 178 0 222]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2024-08-05T15:36:07.712783+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms TopLevelAsset Term;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm StepTerm TupleTerm LiteralTerm);
%hierarchy Op (PrefixOp TupleOp InfixOp BracketOp SuperscriptOp SubscriptOp);
%hierarchy OpArg (SimpleOpArg);
%hierarchy TopLevelRule (TopLevelRewriteRule TopLevelFunctionRule);
<whitespace>
	: \s+
	;
<string>
	: \"" [^""]* \""
	;
<integer>
	: \-? \d+
	;
<rationalNumber>
	: \-?  \d+ \/ [1-9] \d*
	;
<fpNumber>
	: (<integer> \. \d* (e <integer>)?) | (<integer> e <integer>)
	;
<identifierCharacter>
	: <isLzIdentifierCharacter>
	;
<opIdentifier>
	: <identifierCharacter> (\d | \. | <identifierCharacter>)*
	;
<varIdentifier>
	: <opIdentifier> \_+
	;
Start 
	: TopLevelTerm
	;
Option
	: "","" 'comma' <opIdentifier> 'key' ""="" LiteralTerm 'value' {{Option}}
	;
TopLevelOp
	: (Var 'var' "","" 'comma')* Op 'op'  "":"" 'colon' Term 'sort' (Option 'option')* {{}}
	;
TopLevelSort
	: (Var 'var' "","" 'comma')* Op 'op' (Option 'option')* {{TopLevelSort}}
	| (Var 'var' "","" 'comma')* Term 'subsort' ""⊆"" 'subsetOf' Term 'supersort' (Option 'option')* {{TopLevelSubsort}}
	;
TopLevelAxiom
	: (AssetPrefix 'prefix')? (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? (Option 'option')*  {{TopLevelEqualityAxiom}}
	;
AssetPrefix
	: <opIdentifier> 'label' "":"" {{}}
	;
TopLevelRule
	: (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? (Option 'option')* {{TopLevelRewriteRule}}
	| (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' ""Pharo:"" 'pharo' <string> 'code' (""|"" Term 'condition')? (Option 'option')* {{TopLevelFunctionRule}}
	;
RulePrefix
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? "":""  {{}}
	;
TopLevelTerm
	: (AssetPrefix 'prefix')? (Var 'var' "","" 'comma')* Term 'term' (Option 'option')* {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' OpArg 'arg'
			("","" 'comma' OpArg 'arg')* "")"" 'rightParen')? {{PrefixOp}}
	| ""("" 'leftParen' OpArg 'arg' "","" 'comma'
			(OpArg 'arg' ("","" 'comma' OpArg 'arg')* )? "")"" 'rightParen' {{TupleOp}}
	| SimpleOpArg 'arg' <opIdentifier> 'opName' SimpleOpArg 'arg' {{InfixOp}}
	| SimpleOpArg 'arg'
		""["" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		""]"" 'rightBracket' {{BracketOp}}
	| SimpleOpArg 'arg'
		""^("" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		"")"" 'rightParen' {{SuperscriptOp}}
	| SimpleOpArg 'arg'
		""\("" 'opName'  OpArg 'arg'
			("","" 'comma' OpArg 'arg')*
		"")"" 'rightParen' {{SubscriptOp}}
	;
OpArg
	: <opIdentifier> 'name' "":"" 'colon' Term 'sort' {{OpArg}}
	| Term 'sort' {{OpArg}}
	;
SimpleOpArg
	: ""("" 'leftParen' <opIdentifier> 'name' "":"" 'colon' Term 'sort' "")"" 'rightParen' {{SimpleOpArg}}
	| SimpleTerm 'sort' {{SimpleOpArg}}
	;
Var
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{Var}}
	;
Term
	: NonInfixTerm 'arg' (<opIdentifier> 'opName' NonInfixTerm 'arg')+ {{InfixOpTerm}}
	| NonInfixTerm
	;
NonInfixTerm
	: SimpleTerm
	| SimpleTerm 'arg'
		""["" 'leftBracket'  Term 'arg'
			("","" 'comma' Term 'arg')*
		""]"" 'rightBracket' {{BracketOpTerm}}
	| SimpleTerm 'arg'
		""^("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SuperscriptOpTerm}}
	| SimpleTerm 'arg'
		""\("" 'leftParen'  Term 'arg'
			("","" 'comma' Term 'arg')*
		"")"" 'rightParen' {{SubscriptOpTerm}}
	;
SimpleTerm
	: LiteralTerm
	| ParenthesizedTerm
	| ArrayTerm
	| StepTerm
	| TupleTerm
	| PrefixOpTerm
	| VarTerm
	;
StepTerm
	: ""{."" 'leftDelimiter'
			Step 'step' 
			("","" 'comma' Step 'step')*
		"".}"" 'rightDelimiter'
		{{}}
	;
Step
	: Term 'term' ""⇒"" 'arrow' VarTerm 'var' {{}}
	| Term 'term' {{}}
	;
ParenthesizedTerm
	: ""("" 'leftParen' Term 'term' "")"" 'rightParen' {{}}
	;
PrefixOpTerm
	: <opIdentifier> 'opName'
		(""("" 'leftParen' Term 'arg'
			("","" 'comma' Term 'arg')* "")"" 'rightParen')? {{}}
	;
VarTerm
	: <varIdentifier> 'varName' "":"" 'colon' Term 'sort' {{VarTermWithSort}}
	| <varIdentifier> 'varName' {{}}
	;
ArrayTerm
	: ""{"" 'leftBrace' ArrayElements 'arrayElements' ""}"" 'rightBrace' {{}}
	;
ArrayElements
	: ""["" 'leftBracket'
			(ArrayElement 'element')?
			("","" 'comma' ArrayElement 'element')* ""]""
		'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
	;
TupleTerm
	: ""("" 'leftParen'
			Term 'arg' "","" 'comma'
				(Term 'arg' ("","" 'comma' Term 'arg')* )?
		"")"" 'rightParen'
		{{}}
	;
LiteralTerm
	: IntegerLiteralTerm
	| RationalNumberLiteralTerm
	| FpNumberLiteralTerm
	| StringLiteralTerm
	;
StringLiteralTerm
	: <string> 'text' {{}}
	;
IntegerLiteralTerm
	: <integer> 'text' {{}}
	;
RationalNumberLiteralTerm
	: <rationalNumber> 'text' {{}}
	;
FpNumberLiteralTerm
	: <fpNumber> 'text' {{}}
	;
TopLevelUseContext 
	: (""name"" ""="" | ""name="") <string> 'pageName' (Option 'option')*  {{}}
	;
TopLevelSpecialTerms
	: SpecialTerm 'specialTerm' ("","" 'comma' SpecialTerm 'specialTerm')* (Option 'option')* {{}}
	;
SpecialTerm
	: ""integers""
	| ""rationalNumbers""
	| ""floatingPointNumbers""
	| ""strings""
	| ""arrays""
	| ""steps""
	| ""termClasses""
	;
TopLevelAsset
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? (Option 'option')* {{}}
	;"
]

{ #category : #initializing }
LzParser2 class >> initialize [
	LeParser annotationParsers
		at: 'lzSort'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSort ].
	LeParser annotationParsers
		at: 'lzOp'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelOp ].
	LeParser annotationParsers
		at: 'lzAxiom'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAxiom ].
	LeParser annotationParsers
		at: 'lzRule'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelRule ].
	LeParser annotationParsers
		at: 'lzTerm'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelTerm ].
	LeParser annotationParsers
		at: 'lzUseContext'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelUseContext ].
	LeParser annotationParsers
		at: 'lzSpecialTerms'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelSpecialTerms ].
	LeParser annotationParsers
		at: 'lzAsset'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelAsset ].
]

{ #category : #initializing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'.
		'lzUseContext'. 'lzSpecialTerms'. 'lzAsset' }
		do: [ :each |
			LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(39 0 #reduceActionFor_Var__var_______comma___1: 1180673 false) 
	#(35 1 #liftFirstValue: 1056769 false) 
	#(83 1 #liftFirstValue: 5342213 false) 
	#(83 1 #liftFirstValue: 5342211 false) 
	#(83 1 #liftFirstValue: 5342209 false) 
	#(83 1 #liftFirstValue: 5342210 false) 
	#(83 1 #liftFirstValue: 5342214 false) 
	#(83 1 #liftFirstValue: 5342212 false) 
	#(83 1 #liftFirstValue: 5342215 false) 
	#(82 0 #reduceActionFor_Var__var_______comma___1: 5272577 false) 
	#(41 0 #reduceActionFor_Option__option___1: 1240065 false) 
	#(75 1 #reduceActionForStringLiteralTerm1: 4918273 false) 
	#(76 1 #reduceActionForIntegerLiteralTerm1: 4964353 false) 
	#(77 1 #reduceActionForRationalNumberLiteralTerm1: 5012481 false) 
	#(78 1 #reduceActionForFpNumberLiteralTerm1: 5074945 false) 
	#(66 1 #reduceActionForPrefixOpTerm1: 4158465 false) 
	#(67 1 #reduceActionForVarTerm2: 4287490 false) 
	#(54 1 #liftFirstValue: 3263490 false) 
	#(57 1 #liftFirstValue: 3374081 false) 
	#(60 1 #liftFirstValue: 3773444 false) 
	#(60 1 #liftFirstValue: 3773442 false) 
	#(60 1 #liftFirstValue: 3773446 false) 
	#(60 1 #liftFirstValue: 3773447 false) 
	#(60 1 #liftFirstValue: 3773443 false) 
	#(60 1 #liftFirstValue: 3773445 false) 
	#(60 1 #liftFirstValue: 3773441 false) 
	#(74 1 #liftFirstValue: 4805636 false) 
	#(74 1 #liftFirstValue: 4805633 false) 
	#(74 1 #liftFirstValue: 4805634 false) 
	#(74 1 #liftFirstValue: 4805635 false) 
	#(44 2 #reduceActionForAssetPrefix1: 1655809 false) 
	#(39 2 #reduceActionFor_Var__var_______comma___2: 1180674 false) 
	#(48 1 #reduceActionForOp1: 2264065 false) 
	#(52 1 #reduceActionForSimpleOpArg2: 3040258 false) 
	#(46 2 #reduceActionForRulePrefix1: 2076673 false) 
	#(84 2 #reduceActionForTopLevelAsset1: 5474305 false) 
	#(71 0 #reduceActionFor_Var__var_______comma___1: 4562945 false) 
	#(64 1 #reduceActionForStep2: 4006914 false) 
	#(63 0 #reduceActionFor_Var__var_______comma___1: 3944449 false) 
	#(56 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3291137 false) 
	#(54 2 #reduceActionForTerm1: 3263489 false) 
	#(38 2 #reduceActionFor_Var__var_______comma__1: 1180673 false) 
	#(47 3 #reduceActionForTopLevelTerm1: 2157569 false) 
	#(51 1 #reduceActionForOpArg2: 2945026 false) 
	#(42 3 #reduceActionForTopLevelSort1: 1267713 false) 
	#(79 3 #reduceActionForTopLevelUseContext2: 5125122 false) 
	#(80 3 #reduceActionForTopLevelSpecialTerms1: 5221377 false) 
	#(82 2 #reduceActionFor_Var__var_______comma___2: 5272578 false) 
	#(40 1 #liftFirstValue: 1240065 false) 
	#(41 2 #reduceActionFor_Option__option___2: 1240066 false) 
	#(65 3 #reduceActionForParenthesizedTerm1: 4082689 false) 
	#(72 1 #liftFirstValue: 4631553 false) 
	#(72 1 #liftFirstValue: 4631554 false) 
	#(68 3 #reduceActionForArrayTerm1: 4408321 false) 
	#(59 0 #reduceActionFor_Var__var_______comma___1: 3458049 false) 
	#(67 3 #reduceActionForVarTerm1: 4287489 false) 
	#(55 2 #reduceActionFor_Var__var_______comma__1: 3291137 false) 
	#(56 2 #reduceActionFor_Var__var_______comma___2: 3291138 false) 
	#(53 3 #reduceActionForVar1: 3193857 false) 
	#(47 4 #reduceActionForTopLevelTerm2: 2157570 false) 
	#(50 0 #reduceActionFor_Var__var_______comma___1: 2329601 false) 
	#(48 3 #reduceActionForOp5: 2264069 false) 
	#(79 4 #reduceActionForTopLevelUseContext1: 5125121 false) 
	#(81 2 #reduceActionFor_Var__var_______comma__1: 5272577 false) 
	#(73 4 #reduceActionForTupleTerm1: 4673537 false) 
	#(69 3 #reduceActionForArrayElements1: 4494337 false) 
	#(71 2 #reduceActionFor_Var__var_______comma___2: 4562946 false) 
	#(64 3 #reduceActionForStep1: 4006913 false) 
	#(61 4 #reduceActionForStepTerm1: 3891201 false) 
	#(63 2 #reduceActionFor_Var__var_______comma___2: 3944450 false) 
	#(51 3 #reduceActionForOpArg1: 2945025 false) 
	#(48 4 #reduceActionForOp3: 2264067 false) 
	#(37 5 #reduceActionForTopLevelOp1: 1166337 false) 
	#(42 5 #reduceActionForTopLevelSort2: 1267714 false) 
	#(43 5 #reduceActionForTopLevelAxiom1: 1474561 false) 
	#(46 5 #reduceActionForRulePrefix2: 2076674 false) 
	#(45 5 #reduceActionForTopLevelRule1: 1707009 false) 
	#(84 5 #reduceActionForTopLevelAsset2: 5474306 false) 
	#(70 2 #reduceActionFor_Var__var_______comma__1: 4562945 false) 
	#(69 4 #reduceActionForArrayElements2: 4494338 false) 
	#(62 2 #reduceActionFor_Var__var_______comma__1: 3944449 false) 
	#(66 5 #reduceActionForPrefixOpTerm2: 4158466 false) 
	#(59 2 #reduceActionFor_Var__var_______comma___2: 3458050 false) 
	#(57 5 #reduceActionForNonInfixTerm2: 3374082 false) 
	#(57 5 #reduceActionForNonInfixTerm4: 3374084 false) 
	#(57 5 #reduceActionForNonInfixTerm3: 3374083 false) 
	#(52 5 #reduceActionForSimpleOpArg1: 3040257 false) 
	#(48 5 #reduceActionForOp2: 2264066 false) 
	#(50 2 #reduceActionFor_Var__var_______comma___2: 2329602 false) 
	#(48 5 #reduceActionForOp6: 2264070 false) 
	#(48 5 #reduceActionForOp8: 2264072 false) 
	#(48 5 #reduceActionForOp7: 2264071 false) 
	#(43 6 #reduceActionForTopLevelAxiom3: 1474563 false) 
	#(45 6 #reduceActionForTopLevelRule5: 1707013 false) 
	#(45 6 #reduceActionForTopLevelRule3: 1707011 false) 
	#(36 4 #reduceActionForOption1: 1083393 false) 
	#(73 6 #reduceActionForTupleTerm2: 4673538 false) 
	#(58 2 #reduceActionFor_Var__var_______comma__1: 3458049 false) 
	#(48 6 #reduceActionForOp4: 2264068 false) 
	#(49 2 #reduceActionFor_Var__var_______comma__1: 2329601 false) 
	#(43 7 #reduceActionForTopLevelAxiom2: 1474562 false) 
	#(45 7 #reduceActionForTopLevelRule2: 1707010 false) 
	#(45 7 #reduceActionForTopLevelRule7: 1707015 false) 
	#(43 8 #reduceActionForTopLevelAxiom4: 1474564 false) 
	#(45 8 #reduceActionForTopLevelRule6: 1707014 false) 
	#(45 8 #reduceActionForTopLevelRule4: 1707012 false) 
	#(45 9 #reduceActionForTopLevelRule8: 1707016 false)
	).
]

{ #category : #generated }
LzParser2 class >> scannerClass [
	^LzScanner
]

{ #category : #generated }
LzParser2 class >> startingStateForStart [
	^ 1
]

{ #category : #generated }
LzParser2 class >> startingStateForTerm [
	^ 10
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAsset [
	^ 9
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelAxiom [
	^ 5
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelOp [
	^ 3
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelRule [
	^ 6
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSort [
	^ 4
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelSpecialTerms [
	^ 8
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelTerm [
	^ 2
]

{ #category : #generated }
LzParser2 class >> startingStateForTopLevelUseContext [
	^ 7
]

{ #category : #generated }
LzParser2 class >> symbolNames [
	^ #('"("' '")"' '","' '".}"' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"rationalNumbers"' '"steps"' '"strings"' '"termClasses"' '"{"' '"{."' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'StepTerm' '("," ''comma'' Step ''step'')' '("," ''comma'' Step ''step'')*' 'Step' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'TopLevelAsset' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzStepTermNode #OrderedCollection #OrderedCollection #LzStepNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #LzTopLevelAssetNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 49 0 35 0 53 0 39 0 57 0 44 0 49 0 47] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 53 0 39 0 57 0 44 0 65 0 47] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 69 0 37 0 73 0 39] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 77 0 39 0 81 0 42] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 7 0 32 0 6 0 33 0 85 0 39 0 89 0 43 0 93 0 44] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 11 0 32 0 6 0 33 0 101 0 39 0 105 0 45 0 109 0 46] 
#[1 0 113 0 15 0 117 0 16 0 121 0 79] 
#[1 0 157 0 12 0 157 0 13 0 157 0 14 0 157 0 17 0 157 0 18 0 157 0 19 0 157 0 20 0 153 0 80 0 157 0 83] 
#[1 0 161 0 32 0 165 0 84] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 0 205 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 5 0 5] 
#[0 0 0 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 21 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 25 0 39] 
#[0 0 10 0 85] 
#[0 0 0 0 85] 
#[0 0 0 0 85] 
#[1 1 29 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 1 33 0 32 1 9 0 33 1 13 0 38 1 37 0 48 1 41 0 52 1 17 0 53 1 45 0 60 1 45 0 61 1 45 0 65 1 45 0 66 1 45 0 67 1 45 0 68 1 45 0 73 1 45 0 74 1 45 0 75 1 45 0 76 1 45 0 77 1 45 0 78] 
#[1 1 29 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 1 33 0 32 1 9 0 33 1 13 0 38 1 49 0 48 1 41 0 52 1 17 0 53 1 53 0 54 0 209 0 57 1 57 0 60 1 57 0 61 1 57 0 65 1 57 0 66 1 57 0 67 1 57 0 68 1 57 0 73 1 57 0 74 1 57 0 75 1 57 0 76 1 57 0 77 1 57 0 78] 
#[0 0 0 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 61 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 0 0 85] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 65 0 39] 
#[1 1 69 0 5 1 73 0 8] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 77 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 0 0 85] 
#[1 0 6 0 1 0 6 0 21 0 6 0 22 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 1 81 0 39] 
#[0 1 85 0 6] 
#[0 1 89 0 28] 
#[0 0 0 0 85] 
#[0 0 14 0 3 0 85] 
#[0 0 18 0 3 0 85] 
#[0 0 22 0 3 0 85] 
#[0 0 26 0 3 0 85] 
#[0 0 30 0 3 0 85] 
#[0 0 34 0 3 0 85] 
#[0 0 38 0 3 0 85] 
#[0 0 0 0 85] 
#[1 0 42 0 3 1 93 0 82 0 42 0 85] 
#[1 0 46 0 3 1 97 0 8 1 101 0 41 0 46 0 85] 
#[0 0 0 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 1 105 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 1 109 0 8 1 113 0 69] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 1 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 1 121 0 64 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 50 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 54 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 58 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 62 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 1 125 0 1 0 66 0 2 0 66 0 3 0 66 0 4 0 66 0 5 0 66 0 6 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 23 0 66 0 25 0 66 0 26 0 66 0 32 0 66 0 85] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 15 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 11 0 70 0 23 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 85] 
#[0 0 0 0 85] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 74 0 6 0 74 0 8 0 74 0 9 0 74 0 10 0 74 0 11 0 74 0 23 0 74 0 25 0 74 0 26 0 19 0 32 1 137 0 55 1 141 0 56 0 74 0 85] 
#[1 0 78 0 2 0 78 0 3 0 78 0 4 0 78 0 5 0 78 0 6 0 23 0 8 0 27 0 9 0 78 0 10 0 31 0 11 0 78 0 23 0 78 0 25 0 78 0 26 0 78 0 32 0 78 0 85] 
#[0 0 82 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 86 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 94 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 98 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 102 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 106 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 110 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 114 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 118 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 122 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 126 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 70 0 3 1 157 0 5 0 70 0 6 0 70 0 8 0 70 0 9 0 70 0 11 0 70 0 25 0 70 0 26 0 70 0 32 0 70 0 85] 
#[0 0 130 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 1 161 0 3] 
#[1 0 46 0 3 1 165 0 41 0 46 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 169 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 1 173 0 32 0 201 0 33 1 177 0 51 1 181 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 1 185 0 1 0 134 0 3 0 134 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 26 0 66 0 32 0 134 0 85] 
#[0 1 189 0 5] 
#[1 1 193 0 8 1 197 0 9 1 201 0 11 1 205 0 32] 
#[0 0 138 0 3 0 5 0 8 0 9 0 11 0 32 0 85] 
#[1 0 46 0 3 1 209 0 41 0 46 0 85] 
#[0 1 213 0 26] 
#[1 0 35 0 8 0 39 0 9 0 43 0 11 0 78 0 26 0 47 0 32] 
#[0 1 217 0 6] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 221 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 142 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[0 1 225 0 29] 
#[0 1 229 0 25] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 1 9 0 33 1 13 0 38 1 17 0 53 1 233 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 237 0 28] 
#[1 0 46 0 3 1 241 0 41 0 46 0 85] 
#[1 0 51 0 3 1 249 0 41 1 253 0 81 0 46 0 85] 
#[0 2 1 0 29] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 146 0 85] 
#[1 2 17 0 2 2 21 0 3] 
#[1 0 169 0 1 0 150 0 3 1 109 0 8 0 150 0 10 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 37 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 2 37 0 69 2 33 0 71 2 37 0 72 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 2 41 0 24] 
#[1 0 154 0 3 0 154 0 4 2 45 0 25] 
#[1 0 158 0 3 0 158 0 4 2 49 0 63] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 53 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 57 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 61 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 162 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 166 0 2 0 166 0 3 0 166 0 4 0 166 0 5 0 166 0 6 0 166 0 8 0 166 0 9 0 166 0 10 0 166 0 11 0 166 0 23 0 166 0 25 0 166 0 26 0 55 0 32 2 65 0 55 0 166 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 69 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 73 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 77 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 81 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 170 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 174 0 85] 
#[1 0 46 0 3 2 85 0 41 0 46 0 85] 
#[1 1 125 0 1 0 66 0 2 0 66 0 3 2 89 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[0 2 93 0 3] 
#[1 2 17 0 2 0 59 0 3] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 2 101 0 51 2 105 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 109 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 2 113 0 51 2 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 2 121 0 51 2 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 2 125 0 51 2 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 129 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 133 0 52 1 45 0 60 1 45 0 61 1 45 0 65 1 45 0 66 1 45 0 67 1 45 0 68 1 45 0 73 1 45 0 74 1 45 0 75 1 45 0 76 1 45 0 77 1 45 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 182 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 137 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 141 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 2 145 0 6] 
#[0 2 149 0 10] 
#[1 0 169 0 1 2 153 0 7 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 157 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 2 161 0 25] 
#[1 0 46 0 3 2 165 0 41 0 46 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 186 0 85] 
#[0 2 169 0 12 0 13 0 14 0 17 0 18 0 19 0 20 0 83] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 190 0 85] 
#[0 0 194 0 3 0 85] 
#[0 2 173 0 10] 
#[0 2 177 0 32] 
#[0 0 198 0 3 0 85] 
#[0 0 202 0 3 0 85] 
#[0 0 206 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 169 0 1 2 181 0 2 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 185 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 210 0 3 0 10] 
#[0 0 214 0 3 0 10] 
#[1 2 189 0 3 2 193 0 10 2 197 0 70] 
#[1 0 150 0 3 0 150 0 10 2 201 0 71] 
#[0 0 218 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 201 0 33 2 205 0 67] 
#[1 2 209 0 3 2 213 0 4 2 217 0 62] 
#[1 0 222 0 2 0 222 0 3 2 221 0 59] 
#[0 0 226 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 230 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 0 234 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 222 0 3 0 222 0 10 2 225 0 59] 
#[1 0 222 0 2 0 222 0 3 2 229 0 59] 
#[1 0 222 0 2 0 222 0 3 2 233 0 59] 
#[1 0 63 0 3 0 226 0 6 0 226 0 8 0 226 0 9 0 226 0 11 0 226 0 25 0 226 0 26 0 226 0 32 0 226 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 242 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 2 237 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 169 0 1 2 241 0 2 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 2 245 0 51 2 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 1 125 0 1 0 66 0 2 0 66 0 3 2 249 0 5 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 32] 
#[1 0 246 0 2 0 246 0 3 2 253 0 50] 
#[1 0 67 0 2 0 67 0 3 2 221 0 59] 
#[1 0 46 0 3 3 1 0 41 0 46 0 85] 
#[1 0 246 0 3 0 246 0 10 3 5 0 50] 
#[0 0 178 0 2 0 3 0 10] 
#[1 0 246 0 2 0 246 0 3 3 9 0 50] 
#[1 0 246 0 2 0 246 0 3 3 13 0 50] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 3 17 0 32 0 201 0 33 1 105 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 0 250 0 3 0 5 0 85] 
#[1 0 46 0 3 3 21 0 41 0 46 0 85] 
#[1 0 46 0 3 3 25 0 23 3 29 0 41 0 46 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 33 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 3 37 0 5] 
#[0 3 41 0 28] 
#[1 0 46 0 3 3 45 0 23 3 49 0 41 0 46 0 85] 
#[1 0 169 0 1 3 53 0 7 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 57 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 0 254 0 85] 
#[0 1 2 0 3 0 85] 
#[1 0 46 0 3 3 61 0 41 0 46 0 85] 
#[0 3 65 0 6] 
#[0 1 6 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 222 0 2 0 222 0 3 3 69 0 59] 
#[1 0 169 0 1 1 109 0 8 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 73 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 3 73 0 69 3 73 0 72 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 10 0 3 0 10 0 24] 
#[0 1 14 0 3 0 10] 
#[1 2 189 0 3 3 77 0 10 2 197 0 70] 
#[0 1 18 0 3 0 4] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 1 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 3 81 0 64 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 22 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 1 26 0 3 0 4] 
#[1 3 85 0 2 3 89 0 3 3 93 0 58] 
#[1 3 89 0 3 3 97 0 10 3 93 0 58] 
#[1 3 101 0 2 3 89 0 3 3 93 0 58] 
#[1 3 105 0 2 3 89 0 3 3 93 0 58] 
#[1 3 109 0 2 1 30 0 3] 
#[0 1 34 0 3 0 5 0 85] 
#[1 0 246 0 2 0 246 0 3 3 113 0 50] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 3 121 0 2 3 125 0 3 3 129 0 49] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 38 0 85] 
#[1 3 125 0 3 3 133 0 10 3 129 0 49] 
#[1 3 137 0 2 3 125 0 3 3 129 0 49] 
#[1 3 141 0 2 3 125 0 3 3 129 0 49] 
#[1 1 125 0 1 0 66 0 2 0 66 0 3 3 145 0 5 0 66 0 8 0 66 0 9 0 66 0 11 0 66 0 32] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 42 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 149 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 46 0 85] 
#[1 0 46 0 3 3 153 0 23 3 157 0 41 0 46 0 85] 
#[0 1 50 0 1 0 21 0 22 0 28 0 29 0 30 0 31 0 32 0 33] 
#[1 0 46 0 3 3 161 0 23 3 165 0 41 0 46 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 169 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 54 0 85] 
#[0 3 173 0 28] 
#[1 0 46 0 3 3 177 0 23 3 181 0 41 0 46 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 58 0 85] 
#[1 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 3 185 0 74 3 185 0 75 3 185 0 76 3 185 0 77 3 185 0 78] 
#[1 3 189 0 2 3 89 0 3 3 93 0 58] 
#[0 1 62 0 3 0 10] 
#[0 1 66 0 3 0 10 0 24] 
#[0 1 70 0 3 0 4] 
#[0 1 74 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 193 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 78 0 2 0 3 0 10] 
#[0 1 82 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 1 86 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 1 90 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 1 94 0 3 0 5 0 8 0 9 0 11 0 32 0 85] 
#[1 3 197 0 2 3 125 0 3 3 129 0 49] 
#[0 1 30 0 2 0 3 0 10] 
#[0 1 98 0 3 0 5 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 2 97 0 32 0 201 0 33 3 201 0 51 2 117 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[0 1 102 0 2 0 3 0 10] 
#[0 1 106 0 3 0 5 0 85] 
#[0 1 110 0 3 0 5 0 85] 
#[0 1 114 0 3 0 5 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 205 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 0 46 0 3 3 209 0 41 0 46 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 213 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 118 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 217 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 122 0 85] 
#[1 0 46 0 3 3 221 0 41 0 46 0 85] 
#[1 0 46 0 3 3 225 0 23 3 229 0 41 0 46 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 233 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 126 0 85] 
#[0 1 130 0 3 0 85] 
#[0 1 134 0 2 0 3 0 4 0 5 0 6 0 8 0 9 0 10 0 11 0 23 0 25 0 26 0 32 0 85] 
#[0 1 138 0 2 0 3 0 10] 
#[0 1 142 0 3 0 5 0 85] 
#[0 1 146 0 2 0 3 0 10] 
#[0 3 109 0 2] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 150 0 85] 
#[1 0 46 0 3 3 237 0 41 0 46 0 85] 
#[1 0 46 0 3 3 241 0 41 0 46 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 154 0 85] 
#[1 0 169 0 1 0 173 0 21 0 177 0 22 0 181 0 28 0 185 0 29 0 189 0 30 0 193 0 31 0 197 0 32 0 201 0 33 3 245 0 54 0 209 0 57 0 213 0 60 0 213 0 61 0 213 0 65 0 213 0 66 0 213 0 67 0 213 0 68 0 213 0 73 0 213 0 74 0 213 0 75 0 213 0 76 0 213 0 77 0 213 0 78] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 158 0 85] 
#[1 0 46 0 3 3 249 0 41 0 46 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 162 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 166 0 85] 
#[1 0 46 0 3 3 253 0 41 0 46 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 170 0 85] 
#[1 2 5 0 3 2 13 0 36 2 13 0 40 1 174 0 85]
	).
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements1: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addNodes: ((nodes at: 2) at: 2) to: result elements.
	result rightBracket: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayElements2: nodes [
	| result |
	result := LzArrayElementsNode new.
	result leftBracket: (nodes at: 1).
	result addNode: (nodes at: 2) to: result elements.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result elements.
	result rightBracket: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForArrayTerm1: nodes [
	| result |
	result := LzArrayTermNode new.
	result leftBrace: (nodes at: 1).
	result arrayElements: (nodes at: 2).
	result rightBrace: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForAssetPrefix1: nodes [
	| result |
	result := LzAssetPrefixNode new.
	result label: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForFpNumberLiteralTerm1: nodes [
	| result |
	result := LzFpNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForIntegerLiteralTerm1: nodes [
	| result |
	result := LzIntegerLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm2: nodes [
	| result |
	result := LzBracketOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftBracket: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm3: nodes [
	| result |
	result := LzSuperscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForNonInfixTerm4: nodes [
	| result |
	result := LzSubscriptOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp1: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp2: nodes [
	| result |
	result := LzPrefixOpNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp3: nodes [
	| result |
	result := LzTupleOpNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result rightParen: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp4: nodes [
	| result |
	result := LzTupleOpNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result addNode: (nodes at: 4) to: result args.
	result addTokens: ((nodes at: 5) at: 1) to: result commas.
	result addNodes: ((nodes at: 5) at: 2) to: result args.
	result rightParen: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp5: nodes [
	| result |
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp6: nodes [
	| result |
	result := LzBracketOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightBracket: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp7: nodes [
	| result |
	result := LzSuperscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp8: nodes [
	| result |
	result := LzSubscriptOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOpArg1: nodes [
	| result |
	result := LzOpArgNode new.
	result name: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOpArg2: nodes [
	| result |
	result := LzOpArgNode new.
	result sort: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOption1: nodes [
	| result |
	result := LzOptionNode new.
	result comma: (nodes at: 1).
	result key: (nodes at: 2).
	result value: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForParenthesizedTerm1: nodes [
	| result |
	result := LzParenthesizedTermNode new.
	result leftParen: (nodes at: 1).
	result term: (nodes at: 2).
	result rightParen: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm1: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForPrefixOpTerm2: nodes [
	| result |
	result := LzPrefixOpTermNode new.
	result opName: (nodes at: 1).
	result leftParen: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	result addTokens: ((nodes at: 4) at: 1) to: result commas.
	result addNodes: ((nodes at: 4) at: 2) to: result args.
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRationalNumberLiteralTerm1: nodes [
	| result |
	result := LzRationalNumberLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRulePrefix1: nodes [
	| result |
	result := LzRulePrefixNode new.
	result label: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForRulePrefix2: nodes [
	| result |
	result := LzRulePrefixNode new.
	result label: (nodes at: 1).
	result order: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForSimpleOpArg1: nodes [
	| result |
	result := LzSimpleOpArgNode new.
	result leftParen: (nodes at: 1).
	result name: (nodes at: 2).
	result colon: (nodes at: 3).
	result sort: (nodes at: 4).
	result rightParen: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForSimpleOpArg2: nodes [
	| result |
	result := LzSimpleOpArgNode new.
	result sort: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStep1: nodes [
	| result |
	result := LzStepNode new.
	result term: (nodes at: 1).
	result arrow: (nodes at: 2).
	result var: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStep2: nodes [
	| result |
	result := LzStepNode new.
	result term: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStepTerm1: nodes [
	| result |
	result := LzStepTermNode new.
	result leftDelimiter: (nodes at: 1).
	result addNode: (nodes at: 2) to: result steps.
	result addTokens: ((nodes at: 3) at: 1) to: result commas.
	result addNodes: ((nodes at: 3) at: 2) to: result steps.
	result rightDelimiter: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForStringLiteralTerm1: nodes [
	| result |
	result := LzStringLiteralTermNode new.
	result text: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTerm1: nodes [
	| result |
	result := LzInfixOpTermNode new.
	result addNode: (nodes at: 1) to: result args.
	result addTokens: ((nodes at: 2) at: 1) to: result opNames.
	result addNodes: ((nodes at: 2) at: 2) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAsset1: nodes [
	| result |
	result := LzTopLevelAssetNode new.
	result label: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAsset2: nodes [
	| result |
	result := LzTopLevelAssetNode new.
	result label: (nodes at: 1).
	result order: (nodes at: 3).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom1: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom2: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result left: (nodes at: 2).
	result equals: (nodes at: 3).
	result right: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom3: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result left: (nodes at: 3).
	result equals: (nodes at: 4).
	result right: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelAxiom4: nodes [
	| result |
	result := LzTopLevelEqualityAxiomNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result left: (nodes at: 3).
	result equals: (nodes at: 4).
	result right: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelOp1: nodes [
	| result |
	result := LzTopLevelOpNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result colon: (nodes at: 3).
	result sort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule1: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule2: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result replacement: (nodes at: 4).
	result condition: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule3: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result replacement: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule4: nodes [
	| result |
	result := LzTopLevelRewriteRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result replacement: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule5: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule6: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result pattern: (nodes at: 2).
	result arrow: (nodes at: 3).
	result pharo: (nodes at: 4).
	result code: (nodes at: 5).
	result condition: (nodes at: 7).
	result addNodes: (nodes at: 8) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule7: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result pharo: (nodes at: 5).
	result code: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelRule8: nodes [
	| result |
	result := LzTopLevelFunctionRuleNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result pattern: (nodes at: 3).
	result arrow: (nodes at: 4).
	result pharo: (nodes at: 5).
	result code: (nodes at: 6).
	result condition: (nodes at: 8).
	result addNodes: (nodes at: 9) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort1: nodes [
	| result |
	result := LzTopLevelSortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result op: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSort2: nodes [
	| result |
	result := LzTopLevelSubsortNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result subsort: (nodes at: 2).
	result subsetOf: (nodes at: 3).
	result supersort: (nodes at: 4).
	result addNodes: (nodes at: 5) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelSpecialTerms1: nodes [
	| result |
	result := LzTopLevelSpecialTermsNode new.
	result addToken: (nodes at: 1) to: result specialTerms.
	result addTokens: ((nodes at: 2) at: 1) to: result commas.
	result addTokens: ((nodes at: 2) at: 2) to: result specialTerms.
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm2: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result prefix: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result vars.
	result addTokens: ((nodes at: 2) at: 2) to: result commas.
	result term: (nodes at: 3).
	result addNodes: (nodes at: 4) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext1: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 3).
	result addNodes: (nodes at: 4) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelUseContext2: nodes [
	| result |
	result := LzTopLevelUseContextNode new.
	result pageName: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTupleTerm1: nodes [
	| result |
	result := LzTupleTermNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result rightParen: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTupleTerm2: nodes [
	| result |
	result := LzTupleTermNode new.
	result leftParen: (nodes at: 1).
	result addNode: (nodes at: 2) to: result args.
	result addToken: (nodes at: 3) to: result commas.
	result addNode: (nodes at: 4) to: result args.
	result addTokens: ((nodes at: 5) at: 1) to: result commas.
	result addNodes: ((nodes at: 5) at: 2) to: result args.
	result rightParen: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVar1: nodes [
	| result |
	result := LzVarNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm1: nodes [
	| result |
	result := LzVarTermWithSortNode new.
	result varName: (nodes at: 1).
	result colon: (nodes at: 2).
	result sort: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForVarTerm2: nodes [
	| result |
	result := LzVarTermNode new.
	result varName: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Option__option___2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor_Var__var_______comma___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]
