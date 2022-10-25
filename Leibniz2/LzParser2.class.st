Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 37] 
#[ 0 6 0 89] 
#[ 0 78 1 93] 
#[ 0 82 1 105] 
#[ 0 82 1 109] 
#[ 0 82 1 113] 
#[ 0 130 1 105] 
#[ 0 130 1 109] 
#[ 0 130 1 113] 
#[ 0 82 0 130] 
#[ 0 74 1 193] 
#[ 0 66 1 205] 
#[ 0 154 1 93] 
#[ 0 158 1 213] 
#[ 0 198 0 202] 
#[ 0 158 0 194]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-10-25T14:25:48.251594+02:00'
]

{ #category : #generated }
LzParser2 class >> definitionComment [
"%unicode;
%glr;
%root ParseTree;
%prefix Lz;
%suffix Node;
%start TopLevelTerm TopLevelOp TopLevelSort TopLevelAxiom TopLevelRule TopLevelUseContext TopLevelSpecialTerms;
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
]

{ #category : #accessing }
LzParser2 class >> obsolete [
	{ 'lzSort'. 'lzOp'. 'lzAxiom'.  'lzRule'. 'lzTerm'.
		'lzUseContext'. 'lzSpecialTerms' }
		do: [ :each |
			LeParser annotationParsers removeKey: each  ifAbsent: [  ] ].
	^ super obsolete
]

{ #category : #generated }
LzParser2 class >> reduceTable [
^#(
	#(36 0 #reduceActionFor_Var__var_______comma___1: 1152001 false) 
	#(32 1 #liftFirstValue: 1028097 false) 
	#(76 1 #liftFirstValue: 5092357 false) 
	#(76 1 #liftFirstValue: 5092355 false) 
	#(76 1 #liftFirstValue: 5092353 false) 
	#(76 1 #liftFirstValue: 5092354 false) 
	#(76 1 #liftFirstValue: 5092356 false) 
	#(76 1 #liftFirstValue: 5092358 false) 
	#(75 0 #reduceActionFor_Var__var_______comma___1: 5022721 false) 
	#(41 2 #reduceActionForAssetPrefix1: 1627137 false) 
	#(68 1 #reduceActionForStringLiteralTerm1: 4668417 false) 
	#(69 1 #reduceActionForIntegerLiteralTerm1: 4714497 false) 
	#(70 1 #reduceActionForRationalNumberLiteralTerm1: 4762625 false) 
	#(71 1 #reduceActionForFpNumberLiteralTerm1: 4825089 false) 
	#(59 1 #reduceActionForPrefixOpTerm1: 3926017 false) 
	#(60 1 #reduceActionForVarTerm2: 4055042 false) 
	#(36 2 #reduceActionFor_Var__var_______comma___2: 1152002 false) 
	#(38 0 #reduceActionFor_Option__option___1: 1211393 false) 
	#(51 1 #liftFirstValue: 3234818 false) 
	#(54 1 #liftFirstValue: 3345409 false) 
	#(57 1 #liftFirstValue: 3744770 false) 
	#(57 1 #liftFirstValue: 3744773 false) 
	#(57 1 #liftFirstValue: 3744774 false) 
	#(57 1 #liftFirstValue: 3744771 false) 
	#(57 1 #liftFirstValue: 3744772 false) 
	#(57 1 #liftFirstValue: 3744769 false) 
	#(67 1 #liftFirstValue: 4555780 false) 
	#(67 1 #liftFirstValue: 4555777 false) 
	#(67 1 #liftFirstValue: 4555778 false) 
	#(67 1 #liftFirstValue: 4555779 false) 
	#(45 1 #reduceActionForOp1: 2235393 false) 
	#(49 1 #reduceActionForSimpleOpArg2: 3011586 false) 
	#(43 2 #reduceActionForRulePrefix1: 2048001 false) 
	#(64 0 #reduceActionFor_Var__var_______comma___1: 4326401 false) 
	#(35 2 #reduceActionFor_Var__var_______comma__1: 1152001 false) 
	#(44 3 #reduceActionForTopLevelTerm1: 2128897 false) 
	#(53 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3262465 false) 
	#(51 2 #reduceActionForTerm1: 3234817 false) 
	#(48 1 #reduceActionForOpArg2: 2916354 false) 
	#(39 3 #reduceActionForTopLevelSort1: 1239041 false) 
	#(72 3 #reduceActionForTopLevelUseContext2: 4875266 false) 
	#(73 3 #reduceActionForTopLevelSpecialTerms1: 4971521 false) 
	#(75 2 #reduceActionFor_Var__var_______comma___2: 5022722 false) 
	#(58 3 #reduceActionForParenthesizedTerm1: 3850241 false) 
	#(65 1 #liftFirstValue: 4392961 false) 
	#(65 1 #liftFirstValue: 4392962 false) 
	#(61 3 #reduceActionForArrayTerm1: 4175873 false) 
	#(56 0 #reduceActionFor_Var__var_______comma___1: 3429377 false) 
	#(50 3 #reduceActionForVar1: 3165185 false) 
	#(60 3 #reduceActionForVarTerm1: 4055041 false) 
	#(37 1 #liftFirstValue: 1211393 false) 
	#(38 2 #reduceActionFor_Option__option___2: 1211394 false) 
	#(52 2 #reduceActionFor_Var__var_______comma__1: 3262465 false) 
	#(53 2 #reduceActionFor_Var__var_______comma___2: 3262466 false) 
	#(44 4 #reduceActionForTopLevelTerm2: 2128898 false) 
	#(47 0 #reduceActionFor_Var__var_______comma___1: 2300929 false) 
	#(45 3 #reduceActionForOp5: 2235397 false) 
	#(72 4 #reduceActionForTopLevelUseContext1: 4875265 false) 
	#(74 2 #reduceActionFor_Var__var_______comma__1: 5022721 false) 
	#(66 4 #reduceActionForTupleTerm1: 4434945 false) 
	#(62 3 #reduceActionForArrayElements1: 4261889 false) 
	#(64 2 #reduceActionFor_Var__var_______comma___2: 4326402 false) 
	#(48 3 #reduceActionForOpArg1: 2916353 false) 
	#(45 4 #reduceActionForOp3: 2235395 false) 
	#(34 5 #reduceActionForTopLevelOp1: 1137665 false) 
	#(39 5 #reduceActionForTopLevelSort2: 1239042 false) 
	#(40 5 #reduceActionForTopLevelAxiom1: 1445889 false) 
	#(43 5 #reduceActionForRulePrefix2: 2048002 false) 
	#(42 5 #reduceActionForTopLevelRule1: 1678337 false) 
	#(63 2 #reduceActionFor_Var__var_______comma__1: 4326401 false) 
	#(62 4 #reduceActionForArrayElements2: 4261890 false) 
	#(59 5 #reduceActionForPrefixOpTerm2: 3926018 false) 
	#(56 2 #reduceActionFor_Var__var_______comma___2: 3429378 false) 
	#(54 5 #reduceActionForNonInfixTerm2: 3345410 false) 
	#(54 5 #reduceActionForNonInfixTerm4: 3345412 false) 
	#(54 5 #reduceActionForNonInfixTerm3: 3345411 false) 
	#(49 5 #reduceActionForSimpleOpArg1: 3011585 false) 
	#(45 5 #reduceActionForOp2: 2235394 false) 
	#(47 2 #reduceActionFor_Var__var_______comma___2: 2300930 false) 
	#(45 5 #reduceActionForOp6: 2235398 false) 
	#(45 5 #reduceActionForOp8: 2235400 false) 
	#(45 5 #reduceActionForOp7: 2235399 false) 
	#(40 6 #reduceActionForTopLevelAxiom3: 1445891 false) 
	#(42 6 #reduceActionForTopLevelRule5: 1678341 false) 
	#(42 6 #reduceActionForTopLevelRule3: 1678339 false) 
	#(66 6 #reduceActionForTupleTerm2: 4434946 false) 
	#(55 2 #reduceActionFor_Var__var_______comma__1: 3429377 false) 
	#(33 4 #reduceActionForOption1: 1054721 false) 
	#(45 6 #reduceActionForOp4: 2235396 false) 
	#(46 2 #reduceActionFor_Var__var_______comma__1: 2300929 false) 
	#(40 7 #reduceActionForTopLevelAxiom2: 1445890 false) 
	#(42 7 #reduceActionForTopLevelRule2: 1678338 false) 
	#(42 7 #reduceActionForTopLevelRule7: 1678343 false) 
	#(40 8 #reduceActionForTopLevelAxiom4: 1445892 false) 
	#(42 8 #reduceActionForTopLevelRule6: 1678342 false) 
	#(42 8 #reduceActionForTopLevelRule4: 1678340 false) 
	#(42 9 #reduceActionForTopLevelRule8: 1678344 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"rationalNumbers"' '"strings"' '"termClasses"' '"{"' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'AssetPrefix' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'TupleTerm' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzAssetPrefixNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzTupleTermNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 41 0 32 0 45 0 36 0 49 0 41 0 41 0 44] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 45 0 36 0 49 0 41 0 57 0 44] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 61 0 34 0 65 0 36] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 69 0 36 0 73 0 39] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 7 0 29 0 6 0 30 0 77 0 36 0 81 0 40 0 85 0 41] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 11 0 29 0 6 0 30 0 93 0 36 0 97 0 42 0 101 0 43] 
#[1 0 105 0 14 0 109 0 15 0 113 0 72] 
#[1 0 145 0 11 0 145 0 12 0 145 0 13 0 145 0 16 0 145 0 17 0 145 0 18 0 141 0 73 0 145 0 76] 
#[0 0 149 0 4] 
#[0 0 0 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 0 193 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 245 0 36] 
#[0 0 10 0 77] 
#[0 0 0 0 77] 
#[0 0 0 0 77] 
#[1 0 249 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 253 0 29 0 181 0 30 0 185 0 35 1 1 0 45 1 5 0 49 0 189 0 50 1 9 0 57 1 9 0 58 1 9 0 59 1 9 0 60 1 9 0 61 1 9 0 66 1 9 0 67 1 9 0 68 1 9 0 69 1 9 0 70 1 9 0 71] 
#[1 0 249 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 253 0 29 0 181 0 30 0 185 0 35 1 13 0 45 1 5 0 49 0 189 0 50 1 17 0 51 0 197 0 54 1 21 0 57 1 21 0 58 1 21 0 59 1 21 0 60 1 21 0 61 1 21 0 66 1 21 0 67 1 21 0 68 1 21 0 69 1 21 0 70 1 21 0 71] 
#[0 0 0 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 1 25 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 0 0 77] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 1 29 0 36] 
#[1 1 33 0 4 1 37 0 7] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 1 41 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 0 0 77] 
#[1 0 6 0 1 0 6 0 19 0 6 0 25 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 1 45 0 36] 
#[0 1 49 0 5] 
#[0 1 53 0 25] 
#[0 0 0 0 77] 
#[0 0 14 0 3 0 77] 
#[0 0 18 0 3 0 77] 
#[0 0 22 0 3 0 77] 
#[0 0 26 0 3 0 77] 
#[0 0 30 0 3 0 77] 
#[0 0 34 0 3 0 77] 
#[0 0 0 0 77] 
#[1 0 38 0 3 1 57 0 75 0 38 0 77] 
#[0 0 42 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 1 65 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 69 0 7 1 73 0 62] 
#[0 0 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 54 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 58 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 1 77 0 1 0 62 0 2 0 62 0 3 0 62 0 4 0 62 0 5 0 62 0 7 0 62 0 8 0 62 0 9 0 62 0 10 0 62 0 20 0 62 0 22 0 62 0 23 0 62 0 29 0 62 0 77] 
#[1 0 66 0 3 1 81 0 4 0 66 0 5 0 66 0 7 0 66 0 8 0 66 0 10 0 66 0 22 0 66 0 23 0 66 0 29 0 66 0 77] 
#[0 0 70 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[0 1 85 0 3] 
#[1 0 74 0 3 1 89 0 38 0 74 0 77] 
#[1 0 78 0 2 0 78 0 3 0 78 0 4 0 78 0 5 0 78 0 7 0 78 0 8 0 78 0 9 0 78 0 10 0 78 0 20 0 78 0 22 0 78 0 23 0 15 0 29 1 97 0 52 1 101 0 53 0 78 0 77] 
#[1 0 82 0 2 0 82 0 3 0 82 0 4 0 82 0 5 0 19 0 7 0 23 0 8 0 82 0 9 0 27 0 10 0 82 0 20 0 82 0 22 0 82 0 23 0 82 0 29 0 82 0 77] 
#[0 0 86 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 94 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 98 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 106 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 110 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 114 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 118 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 122 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 1 117 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 1 121 0 29 1 61 0 30 1 125 0 48 1 129 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 133 0 1 0 126 0 3 0 126 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 23 0 62 0 29 0 126 0 77] 
#[0 1 137 0 4] 
#[1 1 141 0 7 1 145 0 8 1 149 0 10 1 153 0 29] 
#[0 0 130 0 3 0 4 0 7 0 8 0 10 0 29 0 77] 
#[1 0 74 0 3 1 157 0 38 0 74 0 77] 
#[0 1 161 0 23] 
#[1 0 31 0 7 0 35 0 8 0 39 0 10 0 82 0 23 0 43 0 29] 
#[0 1 165 0 5] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 1 169 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 134 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[0 1 173 0 26] 
#[0 1 177 0 22] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 0 181 0 30 0 185 0 35 0 189 0 50 1 181 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 1 185 0 25] 
#[1 0 74 0 3 1 189 0 38 0 74 0 77] 
#[1 0 47 0 3 1 197 0 38 1 201 0 74 0 74 0 77] 
#[1 0 66 0 2 0 66 0 3 0 51 0 4 0 66 0 5 0 66 0 7 0 66 0 8 0 66 0 9 0 66 0 10 0 66 0 20 0 66 0 22 0 66 0 23 0 66 0 29 0 66 0 77] 
#[1 1 209 0 2 1 213 0 3] 
#[1 0 153 0 1 0 138 0 3 1 69 0 7 0 138 0 9 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 1 229 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 1 229 0 62 1 225 0 64 1 229 0 65 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 1 233 0 21] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 1 237 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 1 241 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 142 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 146 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 1 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 150 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 154 0 2 0 154 0 3 0 154 0 4 0 154 0 5 0 154 0 7 0 154 0 8 0 154 0 9 0 154 0 10 0 154 0 20 0 154 0 22 0 154 0 23 0 55 0 29 2 5 0 52 0 154 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 9 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 13 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 17 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 74 0 3 2 21 0 38 0 74 0 77] 
#[1 1 77 0 1 0 62 0 2 0 62 0 3 2 25 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 29] 
#[0 2 29 0 3] 
#[1 1 209 0 2 0 59 0 3] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 2 37 0 48 2 41 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 45 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 2 49 0 48 2 53 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 2 57 0 48 2 53 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 2 61 0 48 2 53 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 2 65 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 69 0 49 1 9 0 57 1 9 0 58 1 9 0 59 1 9 0 60 1 9 0 61 1 9 0 66 1 9 0 67 1 9 0 68 1 9 0 69 1 9 0 70 1 9 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 162 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 73 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 77 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 2 81 0 5] 
#[0 2 85 0 9] 
#[1 0 153 0 1 2 89 0 6 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 93 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 2 97 0 22] 
#[1 0 74 0 3 2 101 0 38 0 74 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 166 0 77] 
#[0 2 105 0 11 0 12 0 13 0 16 0 17 0 18 0 76] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 170 0 77] 
#[0 0 174 0 3 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 109 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 178 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 153 0 1 2 113 0 2 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 117 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 182 0 3 0 9] 
#[0 0 186 0 3 0 9] 
#[1 2 121 0 3 2 125 0 9 2 129 0 63] 
#[1 0 138 0 3 0 138 0 9 2 133 0 64] 
#[0 0 190 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 194 0 2 0 194 0 3 2 137 0 56] 
#[1 0 63 0 3 0 202 0 5 0 202 0 7 0 202 0 8 0 202 0 10 0 202 0 22 0 202 0 23 0 202 0 29 0 202 0 77] 
#[0 2 141 0 29] 
#[0 0 206 0 3 0 77] 
#[0 0 210 0 3 0 77] 
#[0 0 214 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 218 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 194 0 3 0 194 0 9 2 145 0 56] 
#[1 0 194 0 2 0 194 0 3 2 149 0 56] 
#[1 0 194 0 2 0 194 0 3 2 153 0 56] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 222 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 157 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 153 0 1 2 161 0 2 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 2 165 0 48 2 53 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 77 0 1 0 62 0 2 0 62 0 3 2 169 0 4 0 62 0 7 0 62 0 8 0 62 0 9 0 62 0 10 0 62 0 29] 
#[1 0 226 0 2 0 226 0 3 2 173 0 47] 
#[1 0 67 0 2 0 67 0 3 2 137 0 56] 
#[1 0 74 0 3 2 177 0 38 0 74 0 77] 
#[1 0 226 0 3 0 226 0 9 2 181 0 47] 
#[0 0 158 0 2 0 3 0 9] 
#[1 0 226 0 2 0 226 0 3 2 185 0 47] 
#[1 0 226 0 2 0 226 0 3 2 189 0 47] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 193 0 29 1 61 0 30 1 65 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 230 0 3 0 4 0 77] 
#[1 0 74 0 3 2 197 0 38 0 74 0 77] 
#[1 0 74 0 3 2 201 0 20 2 205 0 38 0 74 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 209 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 2 213 0 4] 
#[0 2 217 0 25] 
#[1 0 74 0 3 2 221 0 20 2 225 0 38 0 74 0 77] 
#[1 0 153 0 1 2 229 0 6 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 233 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 0 234 0 77] 
#[0 0 238 0 3 0 77] 
#[0 0 202 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 0 242 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 194 0 2 0 194 0 3 2 237 0 56] 
#[1 0 153 0 1 1 69 0 7 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 2 241 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 2 241 0 62 2 241 0 65 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 0 246 0 3 0 9 0 21] 
#[0 0 250 0 3 0 9] 
#[1 2 121 0 3 2 245 0 9 2 129 0 63] 
#[1 2 249 0 2 2 253 0 3 3 1 0 55] 
#[0 3 5 0 5] 
#[1 2 253 0 3 3 9 0 9 3 1 0 55] 
#[1 3 13 0 2 2 253 0 3 3 1 0 55] 
#[1 3 17 0 2 2 253 0 3 3 1 0 55] 
#[1 3 21 0 2 0 254 0 3] 
#[0 1 2 0 3 0 4 0 77] 
#[1 0 226 0 2 0 226 0 3 3 25 0 47] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 29 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 3 33 0 2 3 37 0 3 3 41 0 46] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 6 0 77] 
#[1 3 37 0 3 3 45 0 9 3 41 0 46] 
#[1 3 49 0 2 3 37 0 3 3 41 0 46] 
#[1 3 53 0 2 3 37 0 3 3 41 0 46] 
#[1 1 77 0 1 0 62 0 2 0 62 0 3 3 57 0 4 0 62 0 7 0 62 0 8 0 62 0 10 0 62 0 29] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 10 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 61 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 14 0 77] 
#[1 0 74 0 3 3 65 0 20 3 69 0 38 0 74 0 77] 
#[0 1 18 0 1 0 19 0 25 0 26 0 27 0 28 0 29 0 30] 
#[1 0 74 0 3 3 73 0 20 3 77 0 38 0 74 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 81 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 22 0 77] 
#[0 3 85 0 25] 
#[1 0 74 0 3 3 89 0 20 3 93 0 38 0 74 0 77] 
#[1 3 97 0 2 2 253 0 3 3 1 0 55] 
#[0 1 26 0 3 0 9] 
#[0 1 30 0 3 0 9 0 21] 
#[0 1 34 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 101 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 1 38 0 2 0 3 0 9] 
#[1 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 3 105 0 67 3 105 0 68 3 105 0 69 3 105 0 70 3 105 0 71] 
#[0 1 42 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 1 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 1 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 1 54 0 3 0 4 0 7 0 8 0 10 0 29 0 77] 
#[1 3 109 0 2 3 37 0 3 3 41 0 46] 
#[0 0 254 0 2 0 3 0 9] 
#[0 1 58 0 3 0 4 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 2 33 0 29 1 61 0 30 3 113 0 48 2 53 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[0 1 62 0 2 0 3 0 9] 
#[0 1 66 0 3 0 4 0 77] 
#[0 1 70 0 3 0 4 0 77] 
#[0 1 74 0 3 0 4 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 117 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 0 74 0 3 3 121 0 38 0 74 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 125 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 78 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 129 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 82 0 77] 
#[1 0 74 0 3 3 133 0 38 0 74 0 77] 
#[1 0 74 0 3 3 137 0 20 3 141 0 38 0 74 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 145 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 86 0 77] 
#[0 1 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 20 0 22 0 23 0 29 0 77] 
#[0 1 94 0 2 0 3 0 9] 
#[0 1 98 0 3 0 77] 
#[0 1 102 0 3 0 4 0 77] 
#[0 1 106 0 2 0 3 0 9] 
#[0 3 21 0 2] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 110 0 77] 
#[1 0 74 0 3 3 149 0 38 0 74 0 77] 
#[1 0 74 0 3 3 153 0 38 0 74 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 114 0 77] 
#[1 0 153 0 1 0 157 0 19 0 161 0 25 0 165 0 26 0 169 0 27 0 173 0 28 0 177 0 29 1 61 0 30 3 157 0 51 0 197 0 54 0 201 0 57 0 201 0 58 0 201 0 59 0 201 0 60 0 201 0 61 0 201 0 66 0 201 0 67 0 201 0 68 0 201 0 69 0 201 0 70 0 201 0 71] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 118 0 77] 
#[1 0 74 0 3 3 161 0 38 0 74 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 122 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 126 0 77] 
#[1 0 74 0 3 3 165 0 38 0 74 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 130 0 77] 
#[1 1 245 0 3 1 253 0 33 1 253 0 37 1 134 0 77]
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
