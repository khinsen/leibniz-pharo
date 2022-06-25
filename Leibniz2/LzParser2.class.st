Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 6 0 77] 
#[ 0 70 1 61] 
#[ 0 74 1 73] 
#[ 0 74 1 77] 
#[ 0 74 1 81] 
#[ 0 118 1 73] 
#[ 0 118 1 77] 
#[ 0 118 1 81] 
#[ 0 74 0 118] 
#[ 0 66 1 145] 
#[ 0 58 1 157] 
#[ 0 142 1 61] 
#[ 0 182 0 186] 
#[ 0 178 0 210]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-06-25T09:58:55.034954+02:00'
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
%hierarchy Term (PrefixOpTerm BracketOpTerm SuperscriptOpTerm SubscriptOpTerm ParenthesizedTerm VarTerm ArrayTerm LiteralTerm);
%hierarchy Op (PrefixOp InfixOp BracketOp SuperscriptOp SubscriptOp);
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
	: (Var 'var' "","" 'comma')* Term 'left' ""="" 'equals' Term 'right' (""|"" Term 'condition')? (Option 'option')*  {{TopLevelEqualityAxiom}}
	;
TopLevelRule
	: (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? (Option 'option')* {{TopLevelRewriteRule}}
	| (RulePrefix 'prefix')?  (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' ""Pharo:"" 'pharo' <string> 'code' (""|"" Term 'condition')? (Option 'option')* {{TopLevelFunctionRule}}
	;
RulePrefix
	: <opIdentifier> 'label' (""["" <integer> 'order' ""]"")? "":""  {{}}
	;
TopLevelTerm
	: (Var 'var' "","" 'comma')* Term 'term' (Option 'option')* {{}}
	;
Op
	: <opIdentifier> 'opName'
		(""("" 'leftParen' OpArg 'arg'
			("","" 'comma' OpArg 'arg')* "")"" 'rightParen')? {{PrefixOp}}
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
YesNoFlag
	: ""yes""
	| ""no""
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
	#(37 0 #reduceActionFor_Var__var_______comma___1: 1133569 false) 
	#(33 1 #liftFirstValue: 1009665 false) 
	#(76 1 #liftFirstValue: 4749317 false) 
	#(76 1 #liftFirstValue: 4749315 false) 
	#(76 1 #liftFirstValue: 4749313 false) 
	#(76 1 #liftFirstValue: 4749314 false) 
	#(76 1 #liftFirstValue: 4749316 false) 
	#(75 0 #reduceActionFor_Var__var_______comma___1: 4679681 false) 
	#(67 1 #reduceActionForStringLiteralTerm1: 4294657 false) 
	#(68 1 #reduceActionForIntegerLiteralTerm1: 4340737 false) 
	#(69 1 #reduceActionForRationalNumberLiteralTerm1: 4388865 false) 
	#(70 1 #reduceActionForFpNumberLiteralTerm1: 4451329 false) 
	#(59 1 #reduceActionForPrefixOpTerm1: 3673089 false) 
	#(60 1 #reduceActionForVarTerm2: 3802114 false) 
	#(37 2 #reduceActionFor_Var__var_______comma___2: 1133570 false) 
	#(39 0 #reduceActionFor_Option__option___1: 1192961 false) 
	#(51 1 #liftFirstValue: 2995202 false) 
	#(54 1 #liftFirstValue: 3105793 false) 
	#(57 1 #liftFirstValue: 3505154 false) 
	#(57 1 #liftFirstValue: 3505156 false) 
	#(57 1 #liftFirstValue: 3505157 false) 
	#(57 1 #liftFirstValue: 3505155 false) 
	#(57 1 #liftFirstValue: 3505153 false) 
	#(66 1 #liftFirstValue: 4182020 false) 
	#(66 1 #liftFirstValue: 4182017 false) 
	#(66 1 #liftFirstValue: 4182018 false) 
	#(66 1 #liftFirstValue: 4182019 false) 
	#(45 1 #reduceActionForOp1: 2116609 false) 
	#(49 1 #reduceActionForSimpleOpArg2: 2771970 false) 
	#(43 2 #reduceActionForRulePrefix1: 1953793 false) 
	#(64 0 #reduceActionFor_Var__var_______comma___1: 4073473 false) 
	#(36 2 #reduceActionFor_Var__var_______comma__1: 1133569 false) 
	#(44 3 #reduceActionForTopLevelTerm1: 2034689 false) 
	#(53 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 3022849 false) 
	#(51 2 #reduceActionForTerm1: 2995201 false) 
	#(40 3 #reduceActionForTopLevelSort1: 1220609 false) 
	#(71 3 #reduceActionForTopLevelUseContext2: 4501506 false) 
	#(73 3 #reduceActionForTopLevelSpecialTerms1: 4628481 false) 
	#(75 2 #reduceActionFor_Var__var_______comma___2: 4679682 false) 
	#(58 3 #reduceActionForParenthesizedTerm1: 3597313 false) 
	#(65 1 #liftFirstValue: 4140033 false) 
	#(65 1 #liftFirstValue: 4140034 false) 
	#(61 3 #reduceActionForArrayTerm1: 3922945 false) 
	#(56 0 #reduceActionFor_Var__var_______comma___1: 3189761 false) 
	#(60 3 #reduceActionForVarTerm1: 3802113 false) 
	#(50 3 #reduceActionForVar1: 2925569 false) 
	#(38 1 #liftFirstValue: 1192961 false) 
	#(39 2 #reduceActionFor_Option__option___2: 1192962 false) 
	#(52 2 #reduceActionFor_Var__var_______comma__1: 3022849 false) 
	#(53 2 #reduceActionFor_Var__var_______comma___2: 3022850 false) 
	#(47 0 #reduceActionFor_Var__var_______comma___1: 2182145 false) 
	#(48 1 #reduceActionForOpArg2: 2676738 false) 
	#(45 3 #reduceActionForOp3: 2116611 false) 
	#(71 4 #reduceActionForTopLevelUseContext1: 4501505 false) 
	#(74 2 #reduceActionFor_Var__var_______comma__1: 4679681 false) 
	#(62 3 #reduceActionForArrayElements1: 4008961 false) 
	#(64 2 #reduceActionFor_Var__var_______comma___2: 4073474 false) 
	#(35 5 #reduceActionForTopLevelOp1: 1119233 false) 
	#(40 5 #reduceActionForTopLevelSort2: 1220610 false) 
	#(41 5 #reduceActionForTopLevelAxiom1: 1427457 false) 
	#(43 5 #reduceActionForRulePrefix2: 1953794 false) 
	#(42 5 #reduceActionForTopLevelRule1: 1584129 false) 
	#(63 2 #reduceActionFor_Var__var_______comma__1: 4073473 false) 
	#(62 4 #reduceActionForArrayElements2: 4008962 false) 
	#(59 5 #reduceActionForPrefixOpTerm2: 3673090 false) 
	#(56 2 #reduceActionFor_Var__var_______comma___2: 3189762 false) 
	#(54 5 #reduceActionForNonInfixTerm2: 3105794 false) 
	#(54 5 #reduceActionForNonInfixTerm4: 3105796 false) 
	#(54 5 #reduceActionForNonInfixTerm3: 3105795 false) 
	#(49 5 #reduceActionForSimpleOpArg1: 2771969 false) 
	#(48 3 #reduceActionForOpArg1: 2676737 false) 
	#(45 5 #reduceActionForOp2: 2116610 false) 
	#(47 2 #reduceActionFor_Var__var_______comma___2: 2182146 false) 
	#(45 5 #reduceActionForOp4: 2116612 false) 
	#(45 5 #reduceActionForOp6: 2116614 false) 
	#(45 5 #reduceActionForOp5: 2116613 false) 
	#(42 6 #reduceActionForTopLevelRule5: 1584133 false) 
	#(42 6 #reduceActionForTopLevelRule3: 1584131 false) 
	#(55 2 #reduceActionFor_Var__var_______comma__1: 3189761 false) 
	#(34 4 #reduceActionForOption1: 1036289 false) 
	#(46 2 #reduceActionFor_Var__var_______comma__1: 2182145 false) 
	#(41 7 #reduceActionForTopLevelAxiom2: 1427458 false) 
	#(42 7 #reduceActionForTopLevelRule2: 1584130 false) 
	#(42 7 #reduceActionForTopLevelRule7: 1584135 false) 
	#(42 8 #reduceActionForTopLevelRule6: 1584134 false) 
	#(42 8 #reduceActionForTopLevelRule4: 1584132 false) 
	#(42 9 #reduceActionForTopLevelRule8: 1584136 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"no"' '"rationalNumbers"' '"strings"' '"yes"' '"{"' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'TopLevelRule' 'RulePrefix' 'TopLevelTerm' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzTopLevelRuleNode #LzRulePrefixNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 37 0 33 0 41 0 37 0 37 0 44] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 41 0 37 0 49 0 44] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 53 0 35 0 57 0 37] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 61 0 37 0 65 0 40] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 69 0 37 0 73 0 41] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 7 0 30 0 6 0 31 0 81 0 37 0 85 0 42 0 89 0 43] 
#[1 0 93 0 14 0 97 0 15 0 101 0 71] 
#[1 0 129 0 11 0 129 0 12 0 129 0 13 0 129 0 17 0 129 0 18 0 125 0 73 0 129 0 76] 
#[0 0 0 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 0 161 0 31 0 165 0 36 0 169 0 50 0 173 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 10 0 77] 
#[0 0 0 0 77] 
#[0 0 0 0 77] 
#[1 0 221 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 225 0 30 0 161 0 31 0 165 0 36 0 229 0 45 0 233 0 49 0 169 0 50 0 237 0 57 0 237 0 58 0 237 0 59 0 237 0 60 0 237 0 61 0 237 0 66 0 237 0 67 0 237 0 68 0 237 0 69 0 237 0 70] 
#[1 0 221 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 225 0 30 0 161 0 31 0 165 0 36 0 241 0 45 0 233 0 49 0 169 0 50 0 245 0 51 0 177 0 54 0 249 0 57 0 249 0 58 0 249 0 59 0 249 0 60 0 249 0 61 0 249 0 66 0 249 0 67 0 249 0 68 0 249 0 69 0 249 0 70] 
#[0 0 0 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 0 161 0 31 0 165 0 36 0 169 0 50 0 253 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 0 0 77] 
#[1 1 1 0 4 1 5 0 7] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 0 161 0 31 0 165 0 36 0 169 0 50 1 9 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 0 0 77] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 1 13 0 37] 
#[0 1 17 0 5] 
#[0 1 21 0 26] 
#[0 0 0 0 77] 
#[0 0 14 0 3 0 77] 
#[0 0 18 0 3 0 77] 
#[0 0 22 0 3 0 77] 
#[0 0 26 0 3 0 77] 
#[0 0 30 0 3 0 77] 
#[0 0 0 0 77] 
#[1 0 34 0 3 1 25 0 75 0 34 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 33 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 37 0 7 1 41 0 62] 
#[0 0 38 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 42 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 1 45 0 1 0 54 0 2 0 54 0 3 0 54 0 4 0 54 0 5 0 54 0 7 0 54 0 8 0 54 0 9 0 54 0 10 0 54 0 21 0 54 0 23 0 54 0 24 0 54 0 30 0 54 0 77] 
#[1 0 58 0 3 1 49 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 10 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 77] 
#[0 0 62 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[0 1 53 0 3] 
#[1 0 66 0 3 1 57 0 39 0 66 0 77] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 70 0 5 0 70 0 7 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 21 0 70 0 23 0 70 0 24 0 11 0 30 1 65 0 52 1 69 0 53 0 70 0 77] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 15 0 7 0 19 0 8 0 74 0 9 0 23 0 10 0 74 0 21 0 74 0 23 0 74 0 24 0 74 0 30 0 74 0 77] 
#[0 0 78 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 82 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 86 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 94 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 98 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 106 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 110 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 85 0 30 1 29 0 31 1 33 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 89 0 1 0 114 0 3 0 114 0 4 0 54 0 7 0 54 0 8 0 54 0 10 0 54 0 24 0 54 0 30 0 114 0 77] 
#[0 1 93 0 4] 
#[1 1 97 0 7 1 101 0 8 1 105 0 10 1 109 0 30] 
#[0 0 118 0 3 0 4 0 7 0 8 0 10 0 30 0 77] 
#[1 0 66 0 3 1 113 0 39 0 66 0 77] 
#[0 1 117 0 24] 
#[1 0 27 0 7 0 31 0 8 0 35 0 10 0 74 0 24 0 39 0 30] 
#[0 1 121 0 5] 
#[0 0 122 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[0 1 125 0 27] 
#[0 1 129 0 23] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 0 161 0 31 0 165 0 36 0 169 0 50 1 133 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 1 137 0 26] 
#[1 0 66 0 3 1 141 0 39 0 66 0 77] 
#[1 0 43 0 3 1 149 0 39 1 153 0 74 0 66 0 77] 
#[1 0 58 0 2 0 58 0 3 0 47 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 9 0 58 0 10 0 58 0 21 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 77] 
#[0 1 161 0 2] 
#[1 0 133 0 1 0 126 0 3 1 37 0 7 0 126 0 9 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 177 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 1 177 0 62 1 173 0 64 1 177 0 65 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 1 181 0 22] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 185 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 189 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 130 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 134 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 205 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 138 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 142 0 2 0 142 0 3 0 142 0 4 0 142 0 5 0 142 0 7 0 142 0 8 0 142 0 9 0 142 0 10 0 142 0 21 0 142 0 23 0 142 0 24 0 51 0 30 1 209 0 52 0 142 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 213 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 217 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 221 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 45 0 1 0 54 0 2 1 225 0 4 0 54 0 7 0 54 0 8 0 54 0 10 0 54 0 30] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 229 0 30 1 29 0 31 1 233 0 48 1 237 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 1 241 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 229 0 30 1 29 0 31 1 245 0 48 1 249 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 229 0 30 1 29 0 31 1 253 0 48 1 249 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 229 0 30 1 29 0 31 2 1 0 48 1 249 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 221 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 5 0 49 0 237 0 57 0 237 0 58 0 237 0 59 0 237 0 60 0 237 0 61 0 237 0 66 0 237 0 67 0 237 0 68 0 237 0 69 0 237 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 146 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 9 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 13 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 2 17 0 9] 
#[1 0 133 0 1 2 21 0 6 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 25 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 2 29 0 23] 
#[1 0 66 0 3 2 33 0 39 0 66 0 77] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 150 0 77] 
#[0 2 37 0 11 0 12 0 13 0 17 0 18 0 76] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 154 0 77] 
#[0 0 158 0 3 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 41 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 162 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 166 0 3 0 9] 
#[0 0 170 0 3 0 9] 
#[1 2 45 0 3 2 49 0 9 2 53 0 63] 
#[1 0 126 0 3 0 126 0 9 2 57 0 64] 
#[0 0 174 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 178 0 2 0 178 0 3 2 61 0 56] 
#[1 0 55 0 3 0 182 0 5 0 182 0 7 0 182 0 8 0 182 0 10 0 182 0 23 0 182 0 24 0 182 0 30 0 182 0 77] 
#[0 2 65 0 30] 
#[0 0 190 0 3 0 77] 
#[0 0 194 0 3 0 77] 
#[0 0 198 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 0 202 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 178 0 3 0 178 0 9 2 69 0 56] 
#[1 0 178 0 2 0 178 0 3 2 73 0 56] 
#[1 0 178 0 2 0 178 0 3 2 77 0 56] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 81 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 45 0 1 0 54 0 2 0 54 0 3 2 85 0 4 0 54 0 7 0 54 0 8 0 54 0 9 0 54 0 10 0 54 0 30] 
#[1 0 206 0 2 0 206 0 3 2 89 0 47] 
#[1 0 59 0 2 0 59 0 3 2 61 0 56] 
#[1 0 66 0 3 2 93 0 39 0 66 0 77] 
#[1 0 206 0 3 0 206 0 9 2 97 0 47] 
#[0 0 210 0 2 0 3 0 9] 
#[1 0 206 0 2 0 206 0 3 2 101 0 47] 
#[1 0 206 0 2 0 206 0 3 2 105 0 47] 
#[0 0 214 0 3 0 4 0 77] 
#[1 0 66 0 3 2 109 0 39 0 66 0 77] 
#[1 0 66 0 3 2 113 0 21 2 117 0 39 0 66 0 77] 
#[0 2 121 0 4] 
#[0 2 125 0 26] 
#[1 0 66 0 3 2 129 0 21 2 133 0 39 0 66 0 77] 
#[1 0 133 0 1 2 137 0 6 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 141 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 218 0 77] 
#[0 0 222 0 3 0 77] 
#[0 0 182 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 133 0 1 1 37 0 7 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 145 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 2 145 0 62 2 145 0 65 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 0 226 0 3 0 9 0 22] 
#[0 0 230 0 3 0 9] 
#[1 2 45 0 3 2 149 0 9 2 53 0 63] 
#[1 2 153 0 2 2 157 0 3 2 161 0 55] 
#[0 2 165 0 5] 
#[1 2 157 0 3 2 169 0 9 2 161 0 55] 
#[1 2 173 0 2 2 157 0 3 2 161 0 55] 
#[1 2 177 0 2 2 157 0 3 2 161 0 55] 
#[0 2 181 0 2] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 185 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 2 189 0 2 2 193 0 3 2 197 0 46] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 234 0 77] 
#[1 2 193 0 3 2 201 0 9 2 197 0 46] 
#[1 2 205 0 2 2 193 0 3 2 197 0 46] 
#[1 2 209 0 2 2 193 0 3 2 197 0 46] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 238 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 213 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 242 0 77] 
#[0 0 246 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[1 0 66 0 3 2 217 0 21 2 221 0 39 0 66 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 225 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 0 250 0 77] 
#[0 2 229 0 26] 
#[1 0 66 0 3 2 233 0 21 2 237 0 39 0 66 0 77] 
#[0 0 254 0 3 0 9] 
#[0 1 2 0 3 0 9 0 22] 
#[0 1 6 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 2 241 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 1 10 0 2 0 3 0 9] 
#[1 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 2 245 0 66 2 245 0 67 2 245 0 68 2 245 0 69 2 245 0 70] 
#[0 1 14 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 1 18 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 1 22 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 77] 
#[0 1 26 0 3 0 4 0 7 0 8 0 10 0 30 0 77] 
#[0 1 30 0 2 0 3 0 9] 
#[0 1 34 0 3 0 4 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 1 229 0 30 1 29 0 31 2 249 0 48 1 249 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[0 1 38 0 2 0 3 0 9] 
#[0 1 42 0 3 0 4 0 77] 
#[0 1 46 0 3 0 4 0 77] 
#[0 1 50 0 3 0 4 0 77] 
#[1 0 66 0 3 2 253 0 39 0 66 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 3 1 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 54 0 77] 
#[1 0 66 0 3 3 5 0 39 0 66 0 77] 
#[1 0 66 0 3 3 9 0 21 3 13 0 39 0 66 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 3 17 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 58 0 77] 
#[0 1 62 0 2 0 3 0 9] 
#[0 1 66 0 3 0 77] 
#[0 1 70 0 2 0 3 0 9] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 74 0 77] 
#[1 0 66 0 3 3 21 0 39 0 66 0 77] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 78 0 77] 
#[1 0 133 0 1 0 137 0 20 0 141 0 26 0 145 0 27 0 149 0 28 0 153 0 29 0 157 0 30 1 29 0 31 3 25 0 51 0 177 0 54 0 181 0 57 0 181 0 58 0 181 0 59 0 181 0 60 0 181 0 61 0 181 0 66 0 181 0 67 0 181 0 68 0 181 0 69 0 181 0 70] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 82 0 77] 
#[1 0 66 0 3 3 29 0 39 0 66 0 77] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 86 0 77] 
#[1 0 66 0 3 3 33 0 39 0 66 0 77] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 90 0 77] 
#[1 1 193 0 3 1 201 0 34 1 201 0 38 1 94 0 77]
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
	result := LzInfixOpNode new.
	result addNode: (nodes at: 1) to: result args.
	result opName: (nodes at: 2).
	result addNode: (nodes at: 3) to: result args.
	^ result
]

{ #category : #'generated-reduction actions' }
LzParser2 >> reduceActionForOp4: nodes [
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
LzParser2 >> reduceActionForOp5: nodes [
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
LzParser2 >> reduceActionForOp6: nodes [
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
