package types

const (
	DefaultStakeDenom = "coco"
	
	Bech32MainPrefix = "cosmic"
	
	PrefixAccount   = "acc"
	PrefixValidator = "val"
	PrefixConsensus = "cons"
	PrefixPublic    = "pub"
	PrefixOperator  = "oper"
	PrefixAddress   = "addr"
	
	Bech32PrefixAccAddr  = Bech32MainPrefix
	Bech32PrefixAccPub   = Bech32MainPrefix + PrefixPublic
	Bech32PrefixValAddr  = Bech32MainPrefix + PrefixValidator + PrefixOperator
	Bech32PrefixValPub   = Bech32MainPrefix + PrefixValidator + PrefixOperator + PrefixPublic
	Bech32PrefixConsAddr = Bech32MainPrefix + PrefixValidator + PrefixConsensus
	Bech32PrefixConsPub  = Bech32MainPrefix + PrefixValidator + PrefixConsensus + PrefixPublic
)
