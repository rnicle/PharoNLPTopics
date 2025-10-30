Class {
	#name : 'BaselineOfBPE4',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfBPE4',
	#package : 'BaselineOfBPE4'
}

{ #category : 'baselines' }
BaselineOfBPE4 >> baseline: spec [
    <baseline>
    spec for: #common do: [
			spec
				package: #'BPE4'.
			spec
				group: 'Core' with: #( 'BPE4' );
				group: 'default'
				with: #( 'BPE4' ) ]
]
