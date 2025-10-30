Class {
	#name : 'EndOfWord',
	#superclass : 'Object',
	#classVars : [
		'UniqueInstance'
	],
	#category : ' BPE4',
	#package : ' BPE4'
}

{ #category : 'instance creation' }
EndOfWord class >> uniqueInstance [
	^UniqueInstance ifNil: [ UniqueInstance := self new ].
]

{ #category : 'build' }
EndOfWord >> buildPairFrom: aNode in: aBPE [
	^self
]

{ #category : 'build' }
EndOfWord >> buildPairWith: aNode in: aBPE [
	^self
]

{ #category : 'update' }
EndOfWord >> updatePairAt: aNode in: aBPE [
	^self
]

{ #category : 'update' }
EndOfWord >> updatePairFromNode: aNode in: aBPE [
	^self
]
