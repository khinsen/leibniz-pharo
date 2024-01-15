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
#[ 0 66 1 109] 
#[ 0 70 1 113] 
#[ 0 74 1 125] 
#[ 0 74 1 129] 
#[ 0 74 1 133] 
#[ 0 130 1 125] 
#[ 0 130 1 129] 
#[ 0 130 1 133] 
#[ 0 74 0 130] 
#[ 0 42 1 225] 
#[ 0 150 1 113] 
#[ 0 162 2 1] 
#[ 0 210 0 222] 
#[ 0 162 0 206]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2024-01-15T17:45:41.157983+01:00'
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
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm TupleTerm LiteralTerm);
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
	| TupleTerm
	| PrefixOpTerm
	| VarTerm
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
	: ""["" 'leftBracket' (ArrayElement 'element')?
		("","" 'comma' ArrayElement 'element')* ""]"" 'rightBracket' {{}}
	;
ArrayElement
	: Term
	| ArrayElements
	;
TupleTerm
	: ""("" 'leftParen' Term 'arg' "","" 'comma' (Term 'arg' ("","" 'comma' Term 'arg')* )? "")"" 'rightParen' {{}}
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
	#(36 0 #reduceActionFor_Var__var_______comma___1: 1171457 false) 
	#(32 1 #liftFirstValue: 1047553 false) 
	#(76 1 #liftFirstValue: 5111813 false) 
	#(76 1 #liftFirstValue: 5111811 false) 
	#(76 1 #liftFirstValue: 5111809 false) 
	#(76 1 #liftFirstValue: 5111810 false) 
	#(76 1 #liftFirstValue: 5111812 false) 
	#(76 1 #liftFirstValue: 5111814 false) 
	#(75 0 #reduceActionFor_Var__var_______comma___1: 5042177 false) 
	#(38 0 #reduceActionFor_Option__option___1: 1230849 false) 
	#(68 1 #reduceActionForStringLiteralTerm1: 4687873 false) 
	#(69 1 #reduceActionForIntegerLiteralTerm1: 4733953 false) 
	#(70 1 #reduceActionForRationalNumberLiteralTerm1: 4782081 false) 
	#(71 1 #reduceActionForFpNumberLiteralTerm1: 4844545 false) 
	#(59 1 #reduceActionForPrefixOpTerm1: 3945473 false) 
	#(60 1 #reduceActionForVarTerm2: 4074498 false) 
	#(51 1 #liftFirstValue: 3254274 false) 
	#(54 1 #liftFirstValue: 3364865 false) 
	#(57 1 #liftFirstValue: 3764226 false) 
	#(57 1 #liftFirstValue: 3764229 false) 
	#(57 1 #liftFirstValue: 3764230 false) 
	#(57 1 #liftFirstValue: 3764227 false) 
	#(57 1 #liftFirstValue: 3764228 false) 
	#(57 1 #liftFirstValue: 3764225 false) 
	#(67 1 #liftFirstValue: 4575236 false) 
	#(67 1 #liftFirstValue: 4575233 false) 
	#(67 1 #liftFirstValue: 4575234 false) 
	#(67 1 #liftFirstValue: 4575235 false) 
	#(41 2 #reduceActionForAssetPrefix1: 1646593 false) 
	#(36 2 #reduceActionFor_Var__var_______comma___2: 1171458 false) 
	#(45 1 #reduceActionForOp1: 2254849 false) 
	#(49 1 #reduceActionForSimpleOpArg2: 3031042 false) 
	#(43 2 #reduceActionForRulePrefix1: 2067457 false) 
	#(77 2 #reduceActionForTopLevelAsset1: 5232641 false) 
	#(64 0 #reduceActionFor_Var__var_______comma___1: 4345857 false) 
	#(53 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3281921 false) 
	#(51 2 #reduceActionForTerm1: 3254273 false) 
	#(35 2 #reduceActionFor_Var__var_______comma__1: 1171457 false) 
	#(44 3 #reduceActionForTopLevelTerm1: 2148353 false) 
	#(48 1 #reduceActionForOpArg2: 2935810 false) 
	#(39 3 #reduceActionForTopLevelSort1: 1258497 false) 
	#(72 3 #reduceActionForTopLevelUseContext2: 4894722 false) 
	#(73 3 #reduceActionForTopLevelSpecialTerms1: 4990977 false) 
	#(75 2 #reduceActionFor_Var__var_______comma___2: 5042178 false) 
	#(37 1 #liftFirstValue: 1230849 false) 
	#(38 2 #reduceActionFor_Option__option___2: 1230850 false) 
	#(58 3 #reduceActionForParenthesizedTerm1: 3869697 false) 
	#(65 1 #liftFirstValue: 4412417 false) 
	#(65 1 #liftFirstValue: 4412418 false) 
	#(61 3 #reduceActionForArrayTerm1: 4195329 false) 
	#(56 0 #reduceActionFor_Var__var_______comma___1: 3448833 false) 
	#(60 3 #reduceActionForVarTerm1: 4074497 false) 
	#(52 2 #reduceActionFor_Var__var_______comma__1: 3281921 false) 
	#(53 2 #reduceActionFor_Var__var_______comma___2: 3281922 false) 
	#(50 3 #reduceActionForVar1: 3184641 false) 
	#(44 4 #reduceActionForTopLevelTerm2: 2148354 false) 
	#(47 0 #reduceActionFor_Var__var_______comma___1: 2320385 false) 
	#(45 3 #reduceActionForOp5: 2254853 false) 
	#(72 4 #reduceActionForTopLevelUseContext1: 4894721 false) 
	#(74 2 #reduceActionFor_Var__var_______comma__1: 5042177 false) 
	#(66 4 #reduceActionForTupleTerm1: 4454401 false) 
	#(62 3 #reduceActionForArrayElements1: 4281345 false) 
	#(64 2 #reduceActionFor_Var__var_______comma___2: 4345858 false) 
	#(48 3 #reduceActionForOpArg1: 2935809 false) 
	#(45 4 #reduceActionForOp3: 2254851 false) 
	#(34 5 #reduceActionForTopLevelOp1: 1157121 false) 
	#(39 5 #reduceActionForTopLevelSort2: 1258498 false) 
	#(40 5 #reduceActionForTopLevelAxiom1: 1465345 false) 
	#(43 5 #reduceActionForRulePrefix2: 2067458 false) 
	#(42 5 #reduceActionForTopLevelRule1: 1697793 false) 
	#(77 5 #reduceActionForTopLevelAsset2: 5232642 false) 
	#(63 2 #reduceActionFor_Var__var_______comma__1: 4345857 false) 
	#(62 4 #reduceActionForArrayElements2: 4281346 false) 
	#(59 5 #reduceActionForPrefixOpTerm2: 3945474 false) 
	#(56 2 #reduceActionFor_Var__var_______comma___2: 3448834 false) 
	#(54 5 #reduceActionForNonInfixTerm2: 3364866 false) 
	#(54 5 #reduceActionForNonInfixTerm4: 3364868 false) 
	#(54 5 #reduceActionForNonInfixTerm3: 3364867 false) 
	#(49 5 #reduceActionForSimpleOpArg1: 3031041 false) 
	#(45 5 #reduceActionForOp2: 2254850 false) 
	#(47 2 #reduceActionFor_Var__var_______comma___2: 2320386 false) 
	#(45 5 #reduceActionForOp6: 2254854 false) 
	#(45 5 #reduceActionForOp8: 2254856 false) 
	#(45 5 #reduceActionForOp7: 2254855 false) 
	#(40 6 #reduceActionForTopLevelAxiom3: 1465347 false) 
	#(42 6 #reduceActionForTopLevelRule5: 1697797 false) 
	#(42 6 #reduceActionForTopLevelRule3: 1697795 false) 
	#(33 4 #reduceActionForOption1: 1074177 false) 
	#(66 6 #reduceActionForTupleTerm2: 4454402 false) 
	#(55 2 #reduceActionFor_Var__var_______comma__1: 3448833 false) 
	#(45 6 #reduceActionForOp4: 2254852 false) 
	#(46 2 #reduceActionFor_Var__var_______comma__1: 2320385 false) 
	#(40 7 #reduceActionForTopLevelAxiom2: 1465346 false) 
	#(42 7 #reduceActionForTopLevelRule2: 1697794 false) 
	#(42 7 #reduceActionForTopLevelRule7: 1697799 false) 
	#(40 8 #reduceActionForTopLevelAxiom4: 1465348 false) 
	#(42 8 #reduceActionForTopLevelRule6: 1697798 false) 
	#(42 8 #reduceActionForTopLevelRule4: 1697796 false) 
	#(42 9 #reduceActionForTopLevelRule8: 1697800 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"rationalNumbers"' '"strings"' '"termClasses"' '"{"' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'TopLevelAsset' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #LzTopLevelAssetNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 49 0 32 0 53 0 36 0 57 0 41 0 49 0 44] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 53 0 36 0 57 0 41 0 65 0 44] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 69 0 34 0 73 0 36] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 77 0 36 0 81 0 39] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 85 0 36 0 89 0 40 0 93 0 41] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 11 0 29 0 6 0 30 0 101 0 36 0 105 0 42 0 109 0 43] 
#[1 0 113 0 14 0 117 0 15 0 121 0 72] 
#[1 0 153 0 11 0 153 0 12 0 153 0 13 0 153 0 16 0 153 0 17 0 153 0 18 0 149 0 73 0 153 0 76] 
#[1 0 157 0 29 0 161 0 77] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 0 197 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 249 0 4] 
#[0 0 0 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 9 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 1 13 0 36] 
#[0 0 10 0 78] 
#[0 0 0 0 78] 
#[0 0 0 0 78] 
#[1 1 17 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 1 21 0 29 0 253 0 30 1 1 0 35 1 25 0 45 1 29 0 49 1 5 0 50 1 33 0 57 1 33 0 58 1 33 0 59 1 33 0 60 1 33 0 61 1 33 0 66 1 33 0 67 1 33 0 68 1 33 0 69 1 33 0 70 1 33 0 71] 
#[1 1 17 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 1 21 0 29 0 253 0 30 1 1 0 35 1 37 0 45 1 29 0 49 1 5 0 50 1 41 0 51 0 201 0 54 1 45 0 57 1 45 0 58 1 45 0 59 1 45 0 60 1 45 0 61 1 45 0 66 1 45 0 67 1 45 0 68 1 45 0 69 1 45 0 70 1 45 0 71] 
#[0 0 0 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 49 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 0 0 78] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 1 53 0 36] 
#[1 1 57 0 4 1 61 0 7] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 65 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 0 0 78] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 1 69 0 36] 
#[0 1 73 0 5] 
#[0 1 77 0 25] 
#[0 0 0 0 78] 
#[0 0 14 0 3 0 78] 
#[0 0 18 0 3 0 78] 
#[0 0 22 0 3 0 78] 
#[0 0 26 0 3 0 78] 
#[0 0 30 0 3 0 78] 
#[0 0 34 0 3 0 78] 
#[0 0 0 0 78] 
#[1 0 38 0 3 1 81 0 75 0 38 0 78] 
#[1 0 42 0 3 1 85 0 7 1 89 0 38 0 42 0 78] 
#[0 0 0 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 1 93 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 97 0 7 1 101 0 62] 
#[0 0 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 54 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 58 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 1 105 0 1 0 62 0 2 0 62 0 3 0 62 0 4 0 62 0 5 0 62 0 7 0 62 0 8 0 62 0 9 0 62 0 10 0 62 0 20 0 62 0 22 0 62 0 23 0 62 0 29 0 62 0 78] 
#[1 0 66 0 2 0 66 0 3 0 15 0 4 0 66 0 5 0 66 0 7 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 20 0 66 0 22 0 66 0 23 0 66 0 29 0 66 0 78] 
#[0 0 0 0 78] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 70 0 5 0 70 0 7 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 20 0 70 0 22 0 70 0 23 0 19 0 29 1 117 0 52 1 121 0 53 0 70 0 78] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 23 0 7 0 27 0 8 0 74 0 9 0 31 0 10 0 74 0 20 0 74 0 22 0 74 0 23 0 74 0 29 0 74 0 78] 
#[0 0 78 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 82 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 86 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 94 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 98 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 106 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 110 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 114 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 118 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 0 66 0 3 1 137 0 4 0 66 0 5 0 66 0 7 0 66 0 8 0 66 0 10 0 66 0 22 0 66 0 23 0 66 0 29 0 66 0 78] 
#[0 0 122 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[0 1 141 0 3] 
#[1 0 42 0 3 1 145 0 38 0 42 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 149 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 1 153 0 29 0 193 0 30 1 157 0 48 1 161 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 165 0 1 0 126 0 3 0 126 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 23 0 62 0 29 0 126 0 78] 
#[0 1 169 0 4] 
#[1 1 173 0 7 1 177 0 8 1 181 0 10 1 185 0 29] 
#[0 0 130 0 3 0 4 0 7 0 8 0 10 0 29 0 78] 
#[1 0 42 0 3 1 189 0 38 0 42 0 78] 
#[0 1 193 0 23] 
#[1 0 35 0 7 0 39 0 8 0 43 0 10 0 74 0 23 0 47 0 29] 
#[0 1 197 0 5] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 201 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 134 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[0 1 205 0 26] 
#[0 1 209 0 22] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 253 0 30 1 1 0 35 1 5 0 50 1 213 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 1 217 0 25] 
#[1 0 42 0 3 1 221 0 38 0 42 0 78] 
#[1 0 51 0 3 1 229 0 38 1 233 0 74 0 42 0 78] 
#[0 1 237 0 26] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 138 0 78] 
#[1 1 253 0 2 2 1 0 3] 
#[1 0 165 0 1 0 142 0 3 1 97 0 7 0 142 0 9 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 17 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 2 17 0 62 2 13 0 64 2 17 0 65 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 2 21 0 21] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 25 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 29 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 33 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 146 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 150 0 2 0 150 0 3 0 150 0 4 0 150 0 5 0 150 0 7 0 150 0 8 0 150 0 9 0 150 0 10 0 150 0 20 0 150 0 22 0 150 0 23 0 55 0 29 2 37 0 52 0 150 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 41 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 45 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 49 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 53 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 154 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 158 0 78] 
#[1 0 42 0 3 2 57 0 38 0 42 0 78] 
#[1 1 105 0 1 0 62 0 2 0 62 0 3 2 61 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 29] 
#[0 2 65 0 3] 
#[1 1 253 0 2 0 59 0 3] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 2 73 0 48 2 77 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 81 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 2 85 0 48 2 89 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 2 93 0 48 2 89 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 2 97 0 48 2 89 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 2 101 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 105 0 49 1 33 0 57 1 33 0 58 1 33 0 59 1 33 0 60 1 33 0 61 1 33 0 66 1 33 0 67 1 33 0 68 1 33 0 69 1 33 0 70 1 33 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 166 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 109 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 113 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 2 117 0 5] 
#[0 2 121 0 9] 
#[1 0 165 0 1 2 125 0 6 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 129 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 2 133 0 22] 
#[1 0 42 0 3 2 137 0 38 0 42 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 170 0 78] 
#[0 2 141 0 11 0 12 0 13 0 16 0 17 0 18 0 76] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 174 0 78] 
#[0 0 178 0 3 0 78] 
#[0 2 145 0 9] 
#[0 2 149 0 29] 
#[0 0 182 0 3 0 78] 
#[0 0 186 0 3 0 78] 
#[0 0 190 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 165 0 1 2 153 0 2 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 157 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 194 0 3 0 9] 
#[0 0 198 0 3 0 9] 
#[1 2 161 0 3 2 165 0 9 2 169 0 63] 
#[1 0 142 0 3 0 142 0 9 2 173 0 64] 
#[0 0 202 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 206 0 2 0 206 0 3 2 177 0 56] 
#[0 0 210 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 214 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 0 218 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 206 0 3 0 206 0 9 2 181 0 56] 
#[1 0 206 0 2 0 206 0 3 2 185 0 56] 
#[1 0 206 0 2 0 206 0 3 2 189 0 56] 
#[1 0 63 0 3 0 210 0 5 0 210 0 7 0 210 0 8 0 210 0 10 0 210 0 22 0 210 0 23 0 210 0 29 0 210 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 226 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 193 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 165 0 1 2 197 0 2 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 2 201 0 48 2 89 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 105 0 1 0 62 0 2 0 62 0 3 2 205 0 4 0 62 0 7 0 62 0 8 0 62 0 9 0 62 0 10 0 62 0 29] 
#[1 0 230 0 2 0 230 0 3 2 209 0 47] 
#[1 0 67 0 2 0 67 0 3 2 177 0 56] 
#[1 0 42 0 3 2 213 0 38 0 42 0 78] 
#[1 0 230 0 3 0 230 0 9 2 217 0 47] 
#[0 0 162 0 2 0 3 0 9] 
#[1 0 230 0 2 0 230 0 3 2 221 0 47] 
#[1 0 230 0 2 0 230 0 3 2 225 0 47] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 229 0 29 0 193 0 30 1 93 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 234 0 3 0 4 0 78] 
#[1 0 42 0 3 2 233 0 38 0 42 0 78] 
#[1 0 42 0 3 2 237 0 20 2 241 0 38 0 42 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 2 245 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 2 249 0 4] 
#[0 2 253 0 25] 
#[1 0 42 0 3 3 1 0 20 3 5 0 38 0 42 0 78] 
#[1 0 165 0 1 3 9 0 6 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 13 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 0 238 0 78] 
#[0 0 242 0 3 0 78] 
#[1 0 42 0 3 3 17 0 38 0 42 0 78] 
#[0 3 21 0 5] 
#[0 0 246 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 206 0 2 0 206 0 3 3 25 0 56] 
#[1 0 165 0 1 1 97 0 7 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 29 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 3 29 0 62 3 29 0 65 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 0 250 0 3 0 9 0 21] 
#[0 0 254 0 3 0 9] 
#[1 2 161 0 3 3 33 0 9 2 169 0 63] 
#[1 3 37 0 2 3 41 0 3 3 45 0 55] 
#[1 3 41 0 3 3 49 0 9 3 45 0 55] 
#[1 3 53 0 2 3 41 0 3 3 45 0 55] 
#[1 3 57 0 2 3 41 0 3 3 45 0 55] 
#[1 3 61 0 2 1 2 0 3] 
#[0 1 6 0 3 0 4 0 78] 
#[1 0 230 0 2 0 230 0 3 3 65 0 47] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 69 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 3 73 0 2 3 77 0 3 3 81 0 46] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 10 0 78] 
#[1 3 77 0 3 3 85 0 9 3 81 0 46] 
#[1 3 89 0 2 3 77 0 3 3 81 0 46] 
#[1 3 93 0 2 3 77 0 3 3 81 0 46] 
#[1 1 105 0 1 0 62 0 2 0 62 0 3 3 97 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 29] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 14 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 101 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 18 0 78] 
#[1 0 42 0 3 3 105 0 20 3 109 0 38 0 42 0 78] 
#[0 1 22 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 0 42 0 3 3 113 0 20 3 117 0 38 0 42 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 121 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 26 0 78] 
#[0 3 125 0 25] 
#[1 0 42 0 3 3 129 0 20 3 133 0 38 0 42 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 30 0 78] 
#[1 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 3 137 0 67 3 137 0 68 3 137 0 69 3 137 0 70 3 137 0 71] 
#[1 3 141 0 2 3 41 0 3 3 45 0 55] 
#[0 1 34 0 3 0 9] 
#[0 1 38 0 3 0 9 0 21] 
#[0 1 42 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 145 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 1 46 0 2 0 3 0 9] 
#[0 1 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 1 54 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 1 58 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 1 62 0 3 0 4 0 7 0 8 0 10 0 29 0 78] 
#[1 3 149 0 2 3 77 0 3 3 81 0 46] 
#[0 1 2 0 2 0 3 0 9] 
#[0 1 66 0 3 0 4 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 2 69 0 29 0 193 0 30 3 153 0 48 2 89 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[0 1 70 0 2 0 3 0 9] 
#[0 1 74 0 3 0 4 0 78] 
#[0 1 78 0 3 0 4 0 78] 
#[0 1 82 0 3 0 4 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 157 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 0 42 0 3 3 161 0 38 0 42 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 165 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 86 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 169 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 90 0 78] 
#[1 0 42 0 3 3 173 0 38 0 42 0 78] 
#[1 0 42 0 3 3 177 0 20 3 181 0 38 0 42 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 185 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 94 0 78] 
#[0 1 98 0 3 0 78] 
#[0 1 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 78] 
#[0 1 106 0 2 0 3 0 9] 
#[0 1 110 0 3 0 4 0 78] 
#[0 1 114 0 2 0 3 0 9] 
#[0 3 61 0 2] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 118 0 78] 
#[1 0 42 0 3 3 189 0 38 0 42 0 78] 
#[1 0 42 0 3 3 193 0 38 0 42 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 122 0 78] 
#[1 0 165 0 1 0 169 0 19 0 173 0 25 0 177 0 26 0 181 0 27 0 185 0 28 0 189 0 29 0 193 0 30 3 197 0 51 0 201 0 54 0 205 0 57 0 205 0 58 0 205 0 59 0 205 0 60 0 205 0 61 0 205 0 66 0 205 0 67 0 205 0 68 0 205 0 69 0 205 0 70 0 205 0 71] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 126 0 78] 
#[1 0 42 0 3 3 201 0 38 0 42 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 130 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 134 0 78] 
#[1 0 42 0 3 3 205 0 38 0 42 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 138 0 78] 
#[1 1 241 0 3 1 249 0 33 1 249 0 37 1 142 0 78]
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
