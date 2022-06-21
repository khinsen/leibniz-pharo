Class {
	#name : #LzParser2,
	#superclass : #SmaCCGLRParser,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParser2 class >> ambiguousTransitions [
^#(
#[ 0 70 1 41] 
#[ 0 74 1 53] 
#[ 0 74 1 57] 
#[ 0 74 1 61] 
#[ 0 118 1 53] 
#[ 0 118 1 57] 
#[ 0 118 1 61] 
#[ 0 74 0 118] 
#[ 0 66 1 117] 
#[ 0 58 1 129] 
#[ 0 138 1 41] 
#[ 0 178 0 182] 
#[ 0 174 0 206]
	).
]

{ #category : #'generated-accessing' }
LzParser2 class >> cacheId [
	^'2022-06-21T20:29:25.148799+02:00'
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
	: (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' Term 'replacement' (""|"" Term 'condition')? (Option 'option')* {{TopLevelRewriteRule}}
	| (Var 'var' "","" 'comma')* Term 'pattern' ""⇒"" 'arrow' ""Pharo:"" 'pharo' <string> 'code' (""|"" Term 'condition')? (Option 'option')* {{TopLevelFunctionRule}}
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
	#(75 1 #liftFirstValue: 4619269 false) 
	#(75 1 #liftFirstValue: 4619267 false) 
	#(75 1 #liftFirstValue: 4619265 false) 
	#(75 1 #liftFirstValue: 4619266 false) 
	#(75 1 #liftFirstValue: 4619268 false) 
	#(74 0 #reduceActionFor_Var__var_______comma___1: 4549633 false) 
	#(66 1 #reduceActionForStringLiteralTerm1: 4164609 false) 
	#(67 1 #reduceActionForIntegerLiteralTerm1: 4210689 false) 
	#(68 1 #reduceActionForRationalNumberLiteralTerm1: 4258817 false) 
	#(69 1 #reduceActionForFpNumberLiteralTerm1: 4321281 false) 
	#(58 1 #reduceActionForPrefixOpTerm1: 3543041 false) 
	#(59 1 #reduceActionForVarTerm2: 3672066 false) 
	#(37 2 #reduceActionFor_Var__var_______comma___2: 1133570 false) 
	#(39 0 #reduceActionFor_Option__option___1: 1192961 false) 
	#(50 1 #liftFirstValue: 2865154 false) 
	#(53 1 #liftFirstValue: 2975745 false) 
	#(56 1 #liftFirstValue: 3375106 false) 
	#(56 1 #liftFirstValue: 3375108 false) 
	#(56 1 #liftFirstValue: 3375109 false) 
	#(56 1 #liftFirstValue: 3375107 false) 
	#(56 1 #liftFirstValue: 3375105 false) 
	#(65 1 #liftFirstValue: 4051972 false) 
	#(65 1 #liftFirstValue: 4051969 false) 
	#(65 1 #liftFirstValue: 4051970 false) 
	#(65 1 #liftFirstValue: 4051971 false) 
	#(44 1 #reduceActionForOp1: 1986561 false) 
	#(48 1 #reduceActionForSimpleOpArg2: 2641922 false) 
	#(63 0 #reduceActionFor_Var__var_______comma___1: 3943425 false) 
	#(36 2 #reduceActionFor_Var__var_______comma__1: 1133569 false) 
	#(43 3 #reduceActionForTopLevelTerm1: 1904641 false) 
	#(52 1 #reduceActionFor__opIdentifier___opName__NonInfixTerm__arg___1: 2892801 false) 
	#(50 2 #reduceActionForTerm1: 2865153 false) 
	#(40 3 #reduceActionForTopLevelSort1: 1220609 false) 
	#(70 3 #reduceActionForTopLevelUseContext2: 4371458 false) 
	#(72 3 #reduceActionForTopLevelSpecialTerms1: 4498433 false) 
	#(74 2 #reduceActionFor_Var__var_______comma___2: 4549634 false) 
	#(57 3 #reduceActionForParenthesizedTerm1: 3467265 false) 
	#(64 1 #liftFirstValue: 4009985 false) 
	#(64 1 #liftFirstValue: 4009986 false) 
	#(60 3 #reduceActionForArrayTerm1: 3792897 false) 
	#(55 0 #reduceActionFor_Var__var_______comma___1: 3059713 false) 
	#(59 3 #reduceActionForVarTerm1: 3672065 false) 
	#(49 3 #reduceActionForVar1: 2795521 false) 
	#(38 1 #liftFirstValue: 1192961 false) 
	#(39 2 #reduceActionFor_Option__option___2: 1192962 false) 
	#(51 2 #reduceActionFor_Var__var_______comma__1: 2892801 false) 
	#(52 2 #reduceActionFor_Var__var_______comma___2: 2892802 false) 
	#(46 0 #reduceActionFor_Var__var_______comma___1: 2052097 false) 
	#(47 1 #reduceActionForOpArg2: 2546690 false) 
	#(44 3 #reduceActionForOp3: 1986563 false) 
	#(70 4 #reduceActionForTopLevelUseContext1: 4371457 false) 
	#(73 2 #reduceActionFor_Var__var_______comma__1: 4549633 false) 
	#(61 3 #reduceActionForArrayElements1: 3878913 false) 
	#(63 2 #reduceActionFor_Var__var_______comma___2: 3943426 false) 
	#(35 5 #reduceActionForTopLevelOp1: 1119233 false) 
	#(40 5 #reduceActionForTopLevelSort2: 1220610 false) 
	#(41 5 #reduceActionForTopLevelAxiom1: 1427457 false) 
	#(42 5 #reduceActionForTopLevelRule1: 1584129 false) 
	#(62 2 #reduceActionFor_Var__var_______comma__1: 3943425 false) 
	#(61 4 #reduceActionForArrayElements2: 3878914 false) 
	#(58 5 #reduceActionForPrefixOpTerm2: 3543042 false) 
	#(55 2 #reduceActionFor_Var__var_______comma___2: 3059714 false) 
	#(53 5 #reduceActionForNonInfixTerm2: 2975746 false) 
	#(53 5 #reduceActionForNonInfixTerm4: 2975748 false) 
	#(53 5 #reduceActionForNonInfixTerm3: 2975747 false) 
	#(48 5 #reduceActionForSimpleOpArg1: 2641921 false) 
	#(47 3 #reduceActionForOpArg1: 2546689 false) 
	#(44 5 #reduceActionForOp2: 1986562 false) 
	#(46 2 #reduceActionFor_Var__var_______comma___2: 2052098 false) 
	#(44 5 #reduceActionForOp4: 1986564 false) 
	#(44 5 #reduceActionForOp6: 1986566 false) 
	#(44 5 #reduceActionForOp5: 1986565 false) 
	#(42 6 #reduceActionForTopLevelRule3: 1584131 false) 
	#(54 2 #reduceActionFor_Var__var_______comma__1: 3059713 false) 
	#(34 4 #reduceActionForOption1: 1036289 false) 
	#(45 2 #reduceActionFor_Var__var_______comma__1: 2052097 false) 
	#(41 7 #reduceActionForTopLevelAxiom2: 1427458 false) 
	#(42 7 #reduceActionForTopLevelRule2: 1584130 false) 
	#(42 8 #reduceActionForTopLevelRule4: 1584132 false)
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
	^ #('"("' '")"' '","' '":"' '"="' '"Pharo:"' '"["' '"\("' '"]"' '"^("' '"arrays"' '"floatingPointNumbers"' '"integers"' '"name"' '"name="' '"no"' '"rationalNumbers"' '"strings"' '"yes"' '"{"' '"|"' '"}"' '"⇒"' '"⊆"' '<whitespace>' '<string>' '<integer>' '<rationalNumber>' '<fpNumber>' '<opIdentifier>' '<varIdentifier>' 'B e g i n' 'Start' 'Option' 'TopLevelOp' '(Var ''var'' "," ''comma'')' '(Var ''var'' "," ''comma'')*' '(Option ''option'')' '(Option ''option'')*' 'TopLevelSort' 'TopLevelAxiom' 'TopLevelRule' 'TopLevelTerm' 'Op' '("," ''comma'' OpArg ''arg'')' '("," ''comma'' OpArg ''arg'')*' 'OpArg' 'SimpleOpArg' 'Var' 'Term' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')' '(<opIdentifier> ''opName'' NonInfixTerm ''arg'')+' 'NonInfixTerm' '("," ''comma'' Term ''arg'')' '("," ''comma'' Term ''arg'')*' 'SimpleTerm' 'ParenthesizedTerm' 'PrefixOpTerm' 'VarTerm' 'ArrayTerm' 'ArrayElements' '("," ''comma'' ArrayElement ''element'')' '("," ''comma'' ArrayElement ''element'')*' 'ArrayElement' 'LiteralTerm' 'StringLiteralTerm' 'IntegerLiteralTerm' 'RationalNumberLiteralTerm' 'FpNumberLiteralTerm' 'TopLevelUseContext' 'YesNoFlag' 'TopLevelSpecialTerms' '("," ''comma'' SpecialTerm ''specialTerm'')' '("," ''comma'' SpecialTerm ''specialTerm'')*' 'SpecialTerm' 'E O F' 'error')
]

{ #category : #generated }
LzParser2 class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #LzTopLevelTermNode #LzTopLevelTermNode #LzOptionNode #LzTopLevelOpNode #OrderedCollection #OrderedCollection #LzOptionNode #OrderedCollection #LzParseTreeNode #LzTopLevelEqualityAxiomNode #LzTopLevelRuleNode #LzTopLevelTermNode #LzOpNode #OrderedCollection #OrderedCollection #LzOpArgNode #LzSimpleOpArgNode #LzVarNode #LzParseTreeNode #OrderedCollection #OrderedCollection #LzTermNode #OrderedCollection #OrderedCollection #LzTermNode #LzParenthesizedTermNode #LzPrefixOpTermNode #LzVarTermNode #LzArrayTermNode #LzArrayElementsNode #OrderedCollection #OrderedCollection #LzParseTreeNode #LzLiteralTermNode #LzStringLiteralTermNode #LzIntegerLiteralTermNode #LzRationalNumberLiteralTermNode #LzFpNumberLiteralTermNode #LzTopLevelUseContextNode #SmaCCToken #LzTopLevelSpecialTermsNode #OrderedCollection #OrderedCollection #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
LzParser2 class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 37 0 33 0 41 0 37 0 37 0 43] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 41 0 37 0 49 0 43] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 53 0 35 0 57 0 37] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 61 0 37 0 65 0 40] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 69 0 37 0 73 0 41] 
#[1 0 6 0 1 0 6 0 20 0 6 0 26 0 6 0 27 0 6 0 28 0 6 0 29 0 6 0 30 0 6 0 31 0 77 0 37 0 81 0 42] 
#[1 0 85 0 14 0 89 0 15 0 93 0 70] 
#[1 0 121 0 11 0 121 0 12 0 121 0 13 0 121 0 17 0 121 0 18 0 117 0 72 0 121 0 75] 
#[0 0 0 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 49 0 165 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 10 0 76] 
#[0 0 0 0 76] 
#[0 0 0 0 76] 
#[1 0 213 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 217 0 30 0 153 0 31 0 157 0 36 0 221 0 44 0 225 0 48 0 161 0 49 0 229 0 56 0 229 0 57 0 229 0 58 0 229 0 59 0 229 0 60 0 229 0 65 0 229 0 66 0 229 0 67 0 229 0 68 0 229 0 69] 
#[1 0 213 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 217 0 30 0 153 0 31 0 157 0 36 0 233 0 44 0 225 0 48 0 161 0 49 0 237 0 50 0 169 0 53 0 241 0 56 0 241 0 57 0 241 0 58 0 241 0 59 0 241 0 60 0 241 0 65 0 241 0 66 0 241 0 67 0 241 0 68 0 241 0 69] 
#[0 0 0 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 49 0 245 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 0 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 0 153 0 31 0 157 0 36 0 161 0 49 0 249 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 0 0 76] 
#[0 0 253 0 5] 
#[0 1 1 0 26] 
#[0 0 0 0 76] 
#[0 0 14 0 3 0 76] 
#[0 0 18 0 3 0 76] 
#[0 0 22 0 3 0 76] 
#[0 0 26 0 3 0 76] 
#[0 0 30 0 3 0 76] 
#[0 0 0 0 76] 
#[1 0 34 0 3 1 5 0 74 0 34 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 13 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 17 0 7 1 21 0 61] 
#[0 0 38 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 42 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 46 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 50 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 1 25 0 1 0 54 0 2 0 54 0 3 0 54 0 4 0 54 0 5 0 54 0 7 0 54 0 8 0 54 0 9 0 54 0 10 0 54 0 21 0 54 0 23 0 54 0 24 0 54 0 30 0 54 0 76] 
#[1 0 58 0 3 1 29 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 10 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 76] 
#[0 0 62 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[0 1 33 0 3] 
#[1 0 66 0 3 1 37 0 39 0 66 0 76] 
#[1 0 70 0 2 0 70 0 3 0 70 0 4 0 70 0 5 0 70 0 7 0 70 0 8 0 70 0 9 0 70 0 10 0 70 0 21 0 70 0 23 0 70 0 24 0 7 0 30 1 45 0 51 1 49 0 52 0 70 0 76] 
#[1 0 74 0 2 0 74 0 3 0 74 0 4 0 74 0 5 0 11 0 7 0 15 0 8 0 74 0 9 0 19 0 10 0 74 0 21 0 74 0 23 0 74 0 24 0 74 0 30 0 74 0 76] 
#[0 0 78 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 82 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 86 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 90 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 94 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 98 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 102 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 106 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 110 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 65 0 30 1 9 0 31 1 13 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 69 0 1 0 114 0 3 0 114 0 4 0 54 0 7 0 54 0 8 0 54 0 10 0 54 0 24 0 54 0 30 0 114 0 76] 
#[0 1 73 0 4] 
#[1 1 77 0 7 1 81 0 8 1 85 0 10 1 89 0 30] 
#[0 0 118 0 3 0 4 0 7 0 8 0 10 0 30 0 76] 
#[1 0 66 0 3 1 93 0 39 0 66 0 76] 
#[0 1 97 0 24] 
#[1 0 23 0 7 0 27 0 8 0 31 0 10 0 74 0 24 0 35 0 30] 
#[0 1 101 0 5] 
#[0 1 105 0 23] 
#[0 1 109 0 26] 
#[1 0 66 0 3 1 113 0 39 0 66 0 76] 
#[1 0 39 0 3 1 121 0 39 1 125 0 73 0 66 0 76] 
#[1 0 58 0 2 0 58 0 3 0 43 0 4 0 58 0 5 0 58 0 7 0 58 0 8 0 58 0 9 0 58 0 10 0 58 0 21 0 58 0 23 0 58 0 24 0 58 0 30 0 58 0 76] 
#[0 1 133 0 2] 
#[1 0 125 0 1 0 122 0 3 1 17 0 7 0 122 0 9 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 149 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 1 149 0 61 1 145 0 63 1 149 0 64 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 1 153 0 22] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 157 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 161 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 126 0 1 0 20 0 26 0 27 0 28 0 29 0 30 0 31] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 130 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 177 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 134 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 138 0 2 0 138 0 3 0 138 0 4 0 138 0 5 0 138 0 7 0 138 0 8 0 138 0 9 0 138 0 10 0 138 0 21 0 138 0 23 0 138 0 24 0 47 0 30 1 181 0 51 0 138 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 185 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 189 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 193 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 25 0 1 0 54 0 2 1 197 0 4 0 54 0 7 0 54 0 8 0 54 0 10 0 54 0 30] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 201 0 30 1 9 0 31 1 205 0 47 1 209 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 213 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 201 0 30 1 9 0 31 1 217 0 47 1 221 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 201 0 30 1 9 0 31 1 225 0 47 1 221 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 201 0 30 1 9 0 31 1 229 0 47 1 221 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 213 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 233 0 48 0 229 0 56 0 229 0 57 0 229 0 58 0 229 0 59 0 229 0 60 0 229 0 65 0 229 0 66 0 229 0 67 0 229 0 68 0 229 0 69] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 142 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 237 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 241 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 125 0 1 1 245 0 6 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 1 249 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 0 66 0 3 1 253 0 39 0 66 0 76] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 146 0 76] 
#[0 2 1 0 11 0 12 0 13 0 17 0 18 0 75] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 150 0 76] 
#[0 0 154 0 3 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 5 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 158 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 162 0 3 0 9] 
#[0 0 166 0 3 0 9] 
#[1 2 9 0 3 2 13 0 9 2 17 0 62] 
#[1 0 122 0 3 0 122 0 9 2 21 0 63] 
#[0 0 170 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 174 0 2 0 174 0 3 2 25 0 55] 
#[1 0 51 0 3 0 178 0 5 0 178 0 7 0 178 0 8 0 178 0 10 0 178 0 23 0 178 0 24 0 178 0 30 0 178 0 76] 
#[0 2 29 0 30] 
#[0 0 186 0 3 0 76] 
#[0 0 190 0 3 0 76] 
#[0 0 194 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 0 198 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 174 0 3 0 174 0 9 2 33 0 55] 
#[1 0 174 0 2 0 174 0 3 2 37 0 55] 
#[1 0 174 0 2 0 174 0 3 2 41 0 55] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 45 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 25 0 1 0 54 0 2 0 54 0 3 2 49 0 4 0 54 0 7 0 54 0 8 0 54 0 9 0 54 0 10 0 54 0 30] 
#[1 0 202 0 2 0 202 0 3 2 53 0 46] 
#[1 0 55 0 2 0 55 0 3 2 25 0 55] 
#[1 0 66 0 3 2 57 0 39 0 66 0 76] 
#[1 0 202 0 3 0 202 0 9 2 61 0 46] 
#[0 0 206 0 2 0 3 0 9] 
#[1 0 202 0 2 0 202 0 3 2 65 0 46] 
#[1 0 202 0 2 0 202 0 3 2 69 0 46] 
#[0 0 210 0 3 0 4 0 76] 
#[1 0 66 0 3 2 73 0 39 0 66 0 76] 
#[1 0 66 0 3 2 77 0 21 2 81 0 39 0 66 0 76] 
#[0 2 85 0 26] 
#[1 0 66 0 3 2 89 0 21 2 93 0 39 0 66 0 76] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 214 0 76] 
#[0 0 218 0 3 0 76] 
#[0 0 178 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 125 0 1 1 17 0 7 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 97 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 2 97 0 61 2 97 0 64 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 0 222 0 3 0 9 0 22] 
#[0 0 226 0 3 0 9] 
#[1 2 9 0 3 2 101 0 9 2 17 0 62] 
#[1 2 105 0 2 2 109 0 3 2 113 0 54] 
#[0 2 117 0 5] 
#[1 2 109 0 3 2 121 0 9 2 113 0 54] 
#[1 2 125 0 2 2 109 0 3 2 113 0 54] 
#[1 2 129 0 2 2 109 0 3 2 113 0 54] 
#[0 2 133 0 2] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 137 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 2 141 0 2 2 145 0 3 2 149 0 45] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 230 0 76] 
#[1 2 145 0 3 2 153 0 9 2 149 0 45] 
#[1 2 157 0 2 2 145 0 3 2 149 0 45] 
#[1 2 161 0 2 2 145 0 3 2 149 0 45] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 234 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 165 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 238 0 76] 
#[1 0 66 0 3 2 169 0 21 2 173 0 39 0 66 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 177 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 0 242 0 76] 
#[0 0 246 0 3 0 9] 
#[0 0 250 0 3 0 9 0 22] 
#[0 0 254 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 181 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 1 2 0 2 0 3 0 9] 
#[1 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 2 185 0 65 2 185 0 66 2 185 0 67 2 185 0 68 2 185 0 69] 
#[0 1 6 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 1 10 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 1 14 0 2 0 3 0 4 0 5 0 7 0 8 0 9 0 10 0 21 0 23 0 24 0 30 0 76] 
#[0 1 18 0 3 0 4 0 7 0 8 0 10 0 30 0 76] 
#[0 1 22 0 2 0 3 0 9] 
#[0 1 26 0 3 0 4 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 1 201 0 30 1 9 0 31 2 189 0 47 1 221 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[0 1 30 0 2 0 3 0 9] 
#[0 1 34 0 3 0 4 0 76] 
#[0 1 38 0 3 0 4 0 76] 
#[0 1 42 0 3 0 4 0 76] 
#[1 0 66 0 3 2 193 0 39 0 66 0 76] 
#[1 0 125 0 1 0 129 0 20 0 133 0 26 0 137 0 27 0 141 0 28 0 145 0 29 0 149 0 30 1 9 0 31 2 197 0 50 0 169 0 53 0 173 0 56 0 173 0 57 0 173 0 58 0 173 0 59 0 173 0 60 0 173 0 65 0 173 0 66 0 173 0 67 0 173 0 68 0 173 0 69] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 1 46 0 76] 
#[1 0 66 0 3 2 201 0 39 0 66 0 76] 
#[0 1 50 0 2 0 3 0 9] 
#[0 1 54 0 3 0 76] 
#[0 1 58 0 2 0 3 0 9] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 1 62 0 76] 
#[1 0 66 0 3 2 205 0 39 0 66 0 76] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 1 66 0 76] 
#[1 1 165 0 3 1 173 0 34 1 173 0 38 1 70 0 76]
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
LzParser2 >> reduceActionForTopLevelRule4: nodes [
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
