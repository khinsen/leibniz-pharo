private
privateEqualityTestWith: otherKinds and: otherSupersorts and: otherSubsorts 
	^ (kinds = otherKinds)
	  and: [ (supersorts = otherSupersorts)
			and: [ subsorts = otherSubsorts  ]]
