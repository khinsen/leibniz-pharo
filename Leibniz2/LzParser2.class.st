Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 49] 
#[ 0 6 0 105] 
#[ 0 70 1 149] 
#[ 0 78 1 153] 
#[ 0 82 1 165] 
#[ 0 82 1 169] 
#[ 0 82 1 173] 
#[ 0 146 1 165] 
#[ 0 146 1 169] 
#[ 0 146 1 173] 
#[ 0 82 0 146] 
#[ 0 14 2 17] 
#[ 0 170 1 153] 
#[ 0 190 2 41] 
#[ 0 210 0 234] 
#[ 0 190 0 230]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2024-08-12T11:57:00.848032+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms TopLevelAsset TopLevelState Term;
%hierarchy LiteralTerm (IntegerLiteralTerm RationalNumberLiteralTerm FpNumberLiteralTerm StringLiteralTerm);
%hierarchy VarTerm (VarTermWithSort);
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm ProgramTerm TupleTerm LiteralTerm);
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
	: (AssetPrefix 'prefix')? Pattern 'pattern' (Option 'option')* {{}}
	;
Pattern
	: (Var 'var' "","" 'comma')* Term 'term' {{}}
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
	| CompoundStepTerm
	| TupleTerm
	| PrefixOpTerm
	| VarTerm
	;
ProgramTerm
	: ""{."" 'leftDelimiter'
			Step 'step' 
			("";"" 'semicolon' Step 'step')*
		"".}"" 'rightDelimiter'
		{{}}
	;
Step
	: Term 'term' ""⇒"" 'arrow' Pattern 'pattern' {{}}
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
	| ""programs""
	| ""termClasses""
	;
TopLevelAsset
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? (Option 'option')* {{}}
	;
TopLevelState
	:  Var 'var' (Option 'option')* {{}}
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
		at: 'lzState'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForTopLevelState ].
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
	#(41 0 #reduceActionFor_Var__var_______comma___1: 1198081 false) 
	#(37 1 #liftFirstValue: 1074177 false) 
	#(43 0 #reduceActionFor_Option__option___1: 1257473 false) 
	#(86 1 #liftFirstValue: 5416965 false) 
	#(86 1 #liftFirstValue: 5416963 false) 
	#(86 1 #liftFirstValue: 5416961 false) 
	#(86 1 #liftFirstValue: 5416966 false) 
	#(86 1 #liftFirstValue: 5416962 false) 
	#(86 1 #liftFirstValue: 5416964 false) 
	#(86 1 #liftFirstValue: 5416967 false) 
	#(85 0 #reduceActionFor_Var__var_______comma___1: 5347329 false) 
	#(78 1 #reduceActionForStringLiteralTerm1: 4993025 false) 
	#(79 1 #reduceActionForIntegerLiteralTerm1: 5039105 false) 
	#(80 1 #reduceActionForRationalNumberLiteralTerm1: 5087233 false) 
	#(81 1 #reduceActionForFpNumberLiteralTerm1: 5149697 false) 
	#(69 1 #reduceActionForPrefixOpTerm1: 4233217 false) 
	#(70 1 #reduceActionForVarTerm2: 4362242 false) 
	#(63 1 #liftFirstValue: 3828740 false) 
	#(57 1 #liftFirstValue: 3318786 false) 
	#(60 1 #liftFirstValue: 3429377 false) 
	#(63 1 #liftFirstValue: 3828738 false) 
	#(63 1 #liftFirstValue: 3828742 false) 
	#(63 1 #liftFirstValue: 3828743 false) 
	#(63 1 #liftFirstValue: 3828739 false) 
	#(63 1 #liftFirstValue: 3828741 false) 
	#(63 1 #liftFirstValue: 3828737 false) 
	#(77 1 #liftFirstValue: 4880388 false) 
	#(77 1 #liftFirstValue: 4880385 false) 
	#(77 1 #liftFirstValue: 4880386 false) 
	#(77 1 #liftFirstValue: 4880387 false) 
	#(46 2 #reduceActionForAssetPrefix1: 1673217 false) 
	#(41 2 #reduceActionFor_Var__var_______comma___2: 1198082 false) 
	#(50 2 #reduceActionForPattern1: 2262017 false) 
	#(49 2 #reduceActionForTopLevelTerm1: 2174977 false) 
	#(51 1 #reduceActionForOp1: 2319361 false) 
	#(55 1 #reduceActionForSimpleOpArg2: 3095554 false) 
	#(48 2 #reduceActionForRulePrefix1: 2094081 false) 
	#(87 2 #reduceActionForTopLevelAsset1: 5552129 false) 
	#(88 2 #reduceActionForTopLevelState1: 5650433 false) 
	#(74 0 #reduceActionFor_Var__var_______comma___1: 4637697 false) 
	#(59 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3346433 false) 
	#(57 2 #reduceActionForTerm1: 3318785 false) 
	#(40 2 #reduceActionFor_Var__var_______comma__1: 1198081 false) 
	#(49 3 #reduceActionForTopLevelTerm2: 2174978 false) 
	#(42 1 #liftFirstValue: 1257473 false) 
	#(43 2 #reduceActionFor_Option__option___2: 1257474 false) 
	#(54 1 #reduceActionForOpArg2: 3000322 false) 
	#(44 3 #reduceActionForTopLevelSort1: 1285121 false) 
	#(82 3 #reduceActionForTopLevelUseContext2: 5199874 false) 
	#(83 3 #reduceActionForTopLevelSpecialTerms1: 5296129 false) 
	#(85 2 #reduceActionFor_Var__var_______comma___2: 5347330 false) 
	#(56 3 #reduceActionForVar1: 3249153 false) 
	#(68 3 #reduceActionForParenthesizedTerm1: 4157441 false) 
	#(75 1 #liftFirstValue: 4706305 false) 
	#(75 1 #liftFirstValue: 4706306 false) 
	#(71 3 #reduceActionForArrayTerm1: 4483073 false) 
	#(62 0 #reduceActionFor_Var__var_______comma___1: 3513345 false) 
	#(70 3 #reduceActionForVarTerm1: 4362241 false) 
	#(58 2 #reduceActionFor_Var__var_______comma__1: 3346433 false) 
	#(59 2 #reduceActionFor_Var__var_______comma___2: 3346434 false) 
	#(53 0 #reduceActionFor_Var__var_______comma___1: 2384897 false) 
	#(51 3 #reduceActionForOp5: 2319365 false) 
	#(82 4 #reduceActionForTopLevelUseContext1: 5199873 false) 
	#(84 2 #reduceActionFor_Var__var_______comma__1: 5347329 false) 
	#(76 4 #reduceActionForTupleTerm1: 4748289 false) 
	#(72 3 #reduceActionForArrayElements1: 4569089 false) 
	#(74 2 #reduceActionFor_Var__var_______comma___2: 4637698 false) 
	#(54 3 #reduceActionForOpArg1: 3000321 false) 
	#(51 4 #reduceActionForOp3: 2319363 false) 
	#(39 5 #reduceActionForTopLevelOp1: 1183745 false) 
	#(44 5 #reduceActionForTopLevelSort2: 1285122 false) 
	#(45 5 #reduceActionForTopLevelAxiom1: 1491969 false) 
	#(48 5 #reduceActionForRulePrefix2: 2094082 false) 
	#(47 5 #reduceActionForTopLevelRule1: 1724417 false) 
	#(87 5 #reduceActionForTopLevelAsset2: 5552130 false) 
	#(73 2 #reduceActionFor_Var__var_______comma__1: 4637697 false) 
	#(72 4 #reduceActionForArrayElements2: 4569090 false) 
	#(69 5 #reduceActionForPrefixOpTerm2: 4233218 false) 
	#(62 2 #reduceActionFor_Var__var_______comma___2: 3513346 false) 
	#(60 5 #reduceActionForNonInfixTerm2: 3429378 false) 
	#(60 5 #reduceActionForNonInfixTerm4: 3429380 false) 
	#(60 5 #reduceActionForNonInfixTerm3: 3429379 false) 
	#(38 4 #reduceActionForOption1: 1100801 false) 
	#(55 5 #reduceActionForSimpleOpArg1: 3095553 false) 
	#(51 5 #reduceActionForOp2: 2319362 false) 
	#(53 2 #reduceActionFor_Var__var_______comma___2: 2384898 false) 
	#(51 5 #reduceActionForOp6: 2319366 false) 
	#(51 5 #reduceActionForOp8: 2319368 false) 
	#(51 5 #reduceActionForOp7: 2319367 false) 
	#(45 6 #reduceActionForTopLevelAxiom3: 1491971 false) 
	#(47 6 #reduceActionForTopLevelRule5: 1724421 false) 
	#(47 6 #reduceActionForTopLevelRule3: 1724419 false) 
	#(76 6 #reduceActionForTupleTerm2: 4748290 false) 
	#(61 2 #reduceActionFor_Var__var_______comma__1: 3513345 false) 
	#(51 6 #reduceActionForOp4: 2319364 false) 
	#(52 2 #reduceActionFor_Var__var_______comma__1: 2384897 false) 
	#(45 7 #reduceActionForTopLevelAxiom2: 1491970 false) 
	#(47 7 #reduceActionForTopLevelRule2: 1724418 false) 
	#(47 7 #reduceActionForTopLevelRule7: 1724423 false) 
	#(45 8 #reduceActionForTopLevelAxiom4: 1491972 false) 
	#(47 8 #reduceActionForTopLevelRule6: 1724422 false) 
	#(47 8 #reduceActionForTopLevelRule4: 1724420 false) 
	#(47 9 #reduceActionForTopLevelRule8: 1724424 false)
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
	^ 11
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
LzParser2 class >> startingStateForTopLevelState [
	^ 10
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
	^ #('"("' '")"' '","' '".}"' '":"' '";"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"programs"' '"rationalNumbers"' '"strings"' '"termClasses"' '"{"' '"{."' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'CompoundStepTerm' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Pattern' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'ProgramTerm' '(";" ''semicolon'' Step ''step'')' '(";" ''semicolon'' Step ''step'')*' 'Step' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'TopLevelAsset' 'TopLevelState' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #Object #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzPatternNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzProgramTermNode #OrderedCollection #OrderedCollection #LzStepNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #LzTopLevelAssetNode #LzTopLevelStateNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 3 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 7 0 33 0 6 0 34 0 53 0 37 0 57 0 41 0 61 0 46 0 53 0 49 0 69 0 50 0 6 0 89] 
#[1 0 6 0 1 0 6 0 3 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 7 0 33 0 6 0 34 0 57 0 41 0 61 0 46 0 73 0 49 0 69 0 50 0 6 0 89] 
#[1 0 6 0 1 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 6 0 34 0 77 0 39 0 81 0 41] 
#[1 0 6 0 1 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 27 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 6 0 34 0 85 0 41 0 89 0 44] 
#[1 0 6 0 1 0 6 0 7 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 7 0 33 0 6 0 34 0 93 0 41 0 97 0 45 0 101 0 46] 
#[1 0 6 0 1 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 26 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 11 0 33 0 6 0 34 0 109 0 41 0 113 0 47 0 117 0 48] 
#[1 0 121 0 16 0 125 0 17 0 129 0 82] 
#[1 0 165 0 13 0 165 0 14 0 165 0 15 0 165 0 18 0 165 0 19 0 165 0 20 0 165 0 21 0 161 0 83 0 165 0 86] 
#[1 0 169 0 33 0 173 0 87] 
#[1 0 177 0 34 0 181 0 56 0 185 0 88] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 0 225 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 1 21 0 5] 
#[0 0 0 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 1 25 0 34 0 233 0 36 1 29 0 40 1 33 0 56 1 37 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 6 0 1 0 6 0 3 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 6 0 34 0 57 0 41 1 41 0 50 0 6 0 89] 
#[0 0 10 0 89] 
#[1 0 14 0 3 1 45 0 43 0 14 0 89] 
#[0 0 0 0 89] 
#[0 0 0 0 89] 
#[1 1 49 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 1 53 0 33 1 25 0 34 1 65 0 36 1 29 0 40 1 57 0 51 1 61 0 55 1 33 0 56 1 65 0 63 1 65 0 68 1 65 0 69 1 65 0 70 1 65 0 71 1 65 0 76 1 65 0 77 1 65 0 78 1 65 0 79 1 65 0 80 1 65 0 81] 
#[1 1 49 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 1 53 0 33 1 25 0 34 1 77 0 36 1 29 0 40 1 69 0 51 1 61 0 55 1 33 0 56 1 73 0 57 0 229 0 60 1 77 0 63 1 77 0 68 1 77 0 69 1 77 0 70 1 77 0 71 1 77 0 76 1 77 0 77 1 77 0 78 1 77 0 79 1 77 0 80 1 77 0 81] 
#[0 0 0 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 1 25 0 34 0 233 0 36 1 29 0 40 1 33 0 56 1 81 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 0 0 89] 
#[1 0 6 0 1 0 6 0 7 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 6 0 34 1 85 0 41] 
#[1 1 89 0 5 1 93 0 9] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 1 25 0 34 0 233 0 36 1 29 0 40 1 33 0 56 1 97 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 0 0 89] 
#[1 0 6 0 1 0 6 0 9 0 6 0 10 0 6 0 12 0 6 0 22 0 6 0 26 0 6 0 29 0 6 0 30 0 6 0 31 0 6 0 32 0 6 0 33 0 6 0 34 1 101 0 41] 
#[0 1 105 0 7] 
#[0 1 109 0 29] 
#[0 0 0 0 89] 
#[0 0 18 0 3 0 89] 
#[0 0 22 0 3 0 89] 
#[0 0 26 0 3 0 89] 
#[0 0 30 0 3 0 89] 
#[0 0 34 0 3 0 89] 
#[0 0 38 0 3 0 89] 
#[0 0 42 0 3 0 89] 
#[0 0 0 0 89] 
#[1 0 46 0 3 1 113 0 85 0 46 0 89] 
#[1 0 14 0 3 1 117 0 9 1 121 0 43 0 14 0 89] 
#[0 0 0 0 89] 
#[0 1 125 0 5] 
#[1 0 14 0 3 1 129 0 43 0 14 0 89] 
#[0 0 0 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 1 133 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 137 0 9 1 141 0 72] 
#[0 0 50 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 54 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 58 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 62 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 1 145 0 1 0 66 0 2 0 66 0 3 0 66 0 5 0 66 0 7 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 12 0 66 0 24 0 66 0 26 0 66 0 27 0 66 0 33 0 66 0 89] 
#[1 0 70 0 2 0 70 0 3 0 15 0 5 0 70 0 7 0 70 0 9 0 70 0 10 0 70 0 11 0 70 0 12 0 70 0 24 0 70 0 26 0 70 0 27 0 70 0 33 0 70 0 89] 
#[0 0 74 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 0 0 89] 
#[1 0 78 0 2 0 78 0 3 0 78 0 5 0 78 0 7 0 78 0 9 0 78 0 10 0 78 0 11 0 78 0 12 0 78 0 24 0 78 0 26 0 78 0 27 0 19 0 33 1 157 0 58 1 161 0 59 0 78 0 89] 
#[1 0 82 0 2 0 82 0 3 0 82 0 5 0 82 0 7 0 23 0 9 0 27 0 10 0 82 0 11 0 31 0 12 0 82 0 24 0 82 0 26 0 82 0 27 0 82 0 33 0 82 0 89] 
#[0 0 86 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 90 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 94 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 98 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 102 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 106 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 110 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 114 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 118 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 122 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 126 0 1 0 3 0 7 0 9 0 10 0 12 0 22 0 29 0 30 0 31 0 32 0 33 0 34 0 89] 
#[1 0 70 0 3 1 177 0 5 0 70 0 7 0 70 0 9 0 70 0 10 0 70 0 12 0 70 0 26 0 70 0 27 0 70 0 33 0 70 0 89] 
#[0 0 130 0 1 0 3 0 7 0 9 0 10 0 12 0 22 0 26 0 27 0 29 0 30 0 31 0 32 0 33 0 34 0 89] 
#[0 1 181 0 3] 
#[0 0 134 0 3 0 89] 
#[1 0 14 0 3 1 185 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 138 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 1 201 0 33 0 217 0 34 0 233 0 36 1 205 0 54 1 209 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 213 0 1 0 142 0 3 0 142 0 5 0 66 0 9 0 66 0 10 0 66 0 12 0 66 0 27 0 66 0 33 0 142 0 89] 
#[0 1 217 0 5] 
#[1 1 221 0 9 1 225 0 10 1 229 0 12 1 233 0 33] 
#[0 0 146 0 3 0 5 0 9 0 10 0 12 0 33 0 89] 
#[1 0 14 0 3 1 237 0 43 0 14 0 89] 
#[0 1 241 0 27] 
#[1 0 35 0 9 0 39 0 10 0 43 0 12 0 82 0 27 0 47 0 33] 
#[0 1 245 0 7] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 1 25 0 34 0 233 0 36 1 29 0 40 1 33 0 56 1 249 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 150 0 1 0 9 0 10 0 12 0 22 0 26 0 29 0 30 0 31 0 32 0 33 0 34] 
#[0 1 253 0 30] 
#[0 2 1 0 26] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 1 25 0 34 0 233 0 36 1 29 0 40 1 33 0 56 2 5 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 2 9 0 29] 
#[1 0 14 0 3 2 13 0 43 0 14 0 89] 
#[1 0 51 0 3 2 21 0 43 2 25 0 84 0 14 0 89] 
#[0 2 29 0 30] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 154 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 33 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 158 0 89] 
#[1 2 37 0 2 2 41 0 3] 
#[1 0 189 0 1 0 162 0 3 1 137 0 9 0 162 0 11 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 57 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 2 57 0 72 2 53 0 74 2 57 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 2 61 0 25] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 65 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 69 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 73 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 166 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 170 0 2 0 170 0 3 0 170 0 5 0 170 0 7 0 170 0 9 0 170 0 10 0 170 0 11 0 170 0 12 0 170 0 24 0 170 0 26 0 170 0 27 0 55 0 33 2 77 0 58 0 170 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 81 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 85 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 89 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 93 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 174 0 1 0 3 0 7 0 9 0 10 0 12 0 22 0 26 0 27 0 29 0 30 0 31 0 32 0 33 0 34 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 178 0 89] 
#[0 2 97 0 33] 
#[0 0 182 0 3 0 89] 
#[0 0 186 0 3 0 89] 
#[1 1 145 0 1 0 66 0 2 0 66 0 3 2 101 0 5 0 66 0 9 0 66 0 10 0 66 0 12 0 66 0 33] 
#[0 2 105 0 3] 
#[1 2 37 0 2 0 59 0 3] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 2 113 0 54 2 117 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 121 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 2 125 0 54 2 129 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 2 133 0 54 2 129 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 2 137 0 54 2 129 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 2 141 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 1 65 0 36 2 145 0 55 1 65 0 63 1 65 0 68 1 65 0 69 1 65 0 70 1 65 0 71 1 65 0 76 1 65 0 77 1 65 0 78 1 65 0 79 1 65 0 80 1 65 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 194 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 149 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 153 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 2 157 0 7] 
#[0 2 161 0 11] 
#[1 0 189 0 1 2 165 0 8 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 169 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 2 173 0 26] 
#[1 0 14 0 3 2 177 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 198 0 89] 
#[0 2 181 0 13 0 14 0 15 0 18 0 19 0 20 0 21 0 86] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 202 0 89] 
#[0 0 206 0 3 0 89] 
#[0 2 185 0 11] 
#[0 0 210 0 3 0 89] 
#[0 0 214 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 189 0 1 2 189 0 2 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 193 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 218 0 3 0 11] 
#[0 0 222 0 3 0 11] 
#[1 2 197 0 3 2 201 0 11 2 205 0 73] 
#[1 0 162 0 3 0 162 0 11 2 209 0 74] 
#[0 0 226 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 230 0 2 0 230 0 3 2 213 0 62] 
#[0 0 234 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 238 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 0 242 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 230 0 3 0 230 0 11 2 217 0 62] 
#[1 0 230 0 2 0 230 0 3 2 221 0 62] 
#[1 0 230 0 2 0 230 0 3 2 225 0 62] 
#[1 0 63 0 3 0 234 0 7 0 234 0 9 0 234 0 10 0 234 0 12 0 234 0 26 0 234 0 27 0 234 0 33 0 234 0 89] 
#[0 2 229 0 7] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 2 233 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 189 0 1 2 237 0 2 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 2 241 0 54 2 129 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 145 0 1 0 66 0 2 0 66 0 3 2 245 0 5 0 66 0 9 0 66 0 10 0 66 0 11 0 66 0 12 0 66 0 33] 
#[1 0 246 0 2 0 246 0 3 2 249 0 53] 
#[1 0 67 0 2 0 67 0 3 2 213 0 62] 
#[1 0 14 0 3 2 253 0 43 0 14 0 89] 
#[1 0 246 0 3 0 246 0 11 3 1 0 53] 
#[0 0 190 0 2 0 3 0 11] 
#[1 0 246 0 2 0 246 0 3 3 5 0 53] 
#[1 0 246 0 2 0 246 0 3 3 9 0 53] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 3 13 0 33 0 217 0 34 0 233 0 36 1 133 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 0 250 0 3 0 5 0 89] 
#[1 0 14 0 3 3 17 0 43 0 14 0 89] 
#[1 0 14 0 3 3 21 0 24 3 25 0 43 0 14 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 29 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 3 33 0 5] 
#[0 3 37 0 29] 
#[1 0 14 0 3 3 41 0 24 3 45 0 43 0 14 0 89] 
#[1 0 189 0 1 3 49 0 8 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 53 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 0 254 0 89] 
#[0 1 2 0 3 0 89] 
#[1 0 14 0 3 3 57 0 43 0 14 0 89] 
#[0 1 6 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 230 0 2 0 230 0 3 3 61 0 62] 
#[1 0 189 0 1 1 137 0 9 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 65 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 3 65 0 72 3 65 0 75 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 1 10 0 3 0 11 0 25] 
#[0 1 14 0 3 0 11] 
#[1 2 197 0 3 3 69 0 11 2 205 0 73] 
#[1 3 73 0 2 3 77 0 3 3 81 0 61] 
#[1 3 77 0 3 3 85 0 11 3 81 0 61] 
#[1 3 89 0 2 3 77 0 3 3 81 0 61] 
#[1 3 93 0 2 3 77 0 3 3 81 0 61] 
#[1 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 3 97 0 77 3 97 0 78 3 97 0 79 3 97 0 80 3 97 0 81] 
#[1 3 101 0 2 1 18 0 3] 
#[0 1 22 0 3 0 5 0 89] 
#[1 0 246 0 2 0 246 0 3 3 105 0 53] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 109 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 3 113 0 2 3 117 0 3 3 121 0 52] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 26 0 89] 
#[1 3 117 0 3 3 125 0 11 3 121 0 52] 
#[1 3 129 0 2 3 117 0 3 3 121 0 52] 
#[1 3 133 0 2 3 117 0 3 3 121 0 52] 
#[1 1 145 0 1 0 66 0 2 0 66 0 3 3 137 0 5 0 66 0 9 0 66 0 10 0 66 0 12 0 66 0 33] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 30 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 141 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 34 0 89] 
#[1 0 14 0 3 3 145 0 24 3 149 0 43 0 14 0 89] 
#[0 1 38 0 1 0 9 0 10 0 12 0 22 0 26 0 29 0 30 0 31 0 32 0 33 0 34] 
#[1 0 14 0 3 3 153 0 24 3 157 0 43 0 14 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 161 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 42 0 89] 
#[0 3 165 0 29] 
#[1 0 14 0 3 3 169 0 24 3 173 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 46 0 89] 
#[1 3 177 0 2 3 77 0 3 3 81 0 61] 
#[0 1 50 0 3 0 11] 
#[0 1 54 0 3 0 11 0 25] 
#[0 1 58 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 181 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 1 62 0 2 0 3 0 11] 
#[0 1 66 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 1 70 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 1 74 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 1 78 0 3 0 89] 
#[0 1 82 0 3 0 5 0 9 0 10 0 12 0 33 0 89] 
#[1 3 185 0 2 3 117 0 3 3 121 0 52] 
#[0 1 18 0 2 0 3 0 11] 
#[0 1 86 0 3 0 5 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 2 109 0 33 0 217 0 34 0 233 0 36 3 189 0 54 2 129 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[0 1 90 0 2 0 3 0 11] 
#[0 1 94 0 3 0 5 0 89] 
#[0 1 98 0 3 0 5 0 89] 
#[0 1 102 0 3 0 5 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 193 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 0 14 0 3 3 197 0 43 0 14 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 201 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 106 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 205 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 110 0 89] 
#[1 0 14 0 3 3 209 0 43 0 14 0 89] 
#[1 0 14 0 3 3 213 0 24 3 217 0 43 0 14 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 221 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 114 0 89] 
#[0 1 118 0 2 0 3 0 5 0 7 0 9 0 10 0 11 0 12 0 24 0 26 0 27 0 33 0 89] 
#[0 1 122 0 2 0 3 0 11] 
#[0 1 126 0 3 0 5 0 89] 
#[0 1 130 0 2 0 3 0 11] 
#[0 3 101 0 2] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 134 0 89] 
#[1 0 14 0 3 3 225 0 43 0 14 0 89] 
#[1 0 14 0 3 3 229 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 138 0 89] 
#[1 0 189 0 1 0 193 0 22 0 197 0 29 0 201 0 30 0 205 0 31 0 209 0 32 0 213 0 33 0 217 0 34 0 233 0 36 3 233 0 57 0 229 0 60 0 233 0 63 0 233 0 68 0 233 0 69 0 233 0 70 0 233 0 71 0 233 0 76 0 233 0 77 0 233 0 78 0 233 0 79 0 233 0 80 0 233 0 81] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 142 0 89] 
#[1 0 14 0 3 3 237 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 146 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 150 0 89] 
#[1 0 14 0 3 3 241 0 43 0 14 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 154 0 89] 
#[1 1 189 0 3 1 197 0 38 1 197 0 42 1 158 0 89]
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
LzParser2 >> reduceActionForPattern1: nodes [
	| result |
	result := LzPatternNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result vars.
	result addTokens: ((nodes at: 1) at: 2) to: result commas.
	result term: (nodes at: 2).
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
LzParser2 >> reduceActionForTopLevelState1: nodes [
	| result |
	result := LzTopLevelStateNode new.
	result var: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm1: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result pattern: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result options.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForTopLevelTerm2: nodes [
	| result |
	result := LzTopLevelTermNode new.
	result prefix: (nodes at: 1).
	result pattern: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result options.
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
