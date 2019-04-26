/* This file is generated, do not edit! */
package python;
@:pythonImport("netifaces") extern class Netifaces {
	static public var AF_APPLETALK : Dynamic;
	static public var AF_CCITT : Dynamic;
	static public var AF_CHAOS : Dynamic;
	static public var AF_CNT : Dynamic;
	static public var AF_COIP : Dynamic;
	static public var AF_DATAKIT : Dynamic;
	static public var AF_DECnet : Dynamic;
	static public var AF_DLI : Dynamic;
	static public var AF_ECMA : Dynamic;
	static public var AF_HYLINK : Dynamic;
	static public var AF_IMPLINK : Dynamic;
	static public var AF_INET : Dynamic;
	static public var AF_INET6 : Dynamic;
	static public var AF_IPX : Dynamic;
	static public var AF_ISDN : Dynamic;
	static public var AF_ISO : Dynamic;
	static public var AF_LAT : Dynamic;
	static public var AF_LINK : Dynamic;
	static public var AF_NATM : Dynamic;
	static public var AF_NDRV : Dynamic;
	static public var AF_NETBIOS : Dynamic;
	static public var AF_NS : Dynamic;
	static public var AF_PPP : Dynamic;
	static public var AF_PUP : Dynamic;
	static public var AF_ROUTE : Dynamic;
	static public var AF_SIP : Dynamic;
	static public var AF_SNA : Dynamic;
	static public var AF_SYSTEM : Dynamic;
	static public var AF_UNIX : Dynamic;
	static public var AF_UNSPEC : Dynamic;
	static public var IN6_IFF_AUTOCONF : Dynamic;
	static public var IN6_IFF_DYNAMIC : Dynamic;
	static public var IN6_IFF_OPTIMISTIC : Dynamic;
	static public var IN6_IFF_SECURED : Dynamic;
	static public var IN6_IFF_TEMPORARY : Dynamic;
	static public var __doc__ : Dynamic;
	static public var __file__ : Dynamic;
	static public var __loader__ : Dynamic;
	static public var __name__ : Dynamic;
	static public var __package__ : Dynamic;
	static public var __spec__ : Dynamic;
	static public var address_families : Dynamic;
	/**
		Obtain a list of the gateways on this machine.
		
		Returns a dict whose keys are equal to the address family constants,
		e.g. netifaces.AF_INET, and whose values are a list of tuples of the
		format (<address>, <interface>, <is_default>).
		
		There is also a special entry with the key 'default', which you can use
		to quickly obtain the default gateway for a particular address family.
		
		There may in general be multiple gateways; different address
		families may have different gateway settings (e.g. AF_INET vs AF_INET6)
		and on some systems it's also possible to have interface-specific
		default gateways.
	**/
	static public function gateways(args:haxe.extern.Rest<Dynamic>):Dynamic;
	/**
		Obtain information about the specified network interface.
		
		Returns a dict whose keys are equal to the address family constants,
		e.g. netifaces.AF_INET, and whose values are a list of addresses in
		that family that are attached to the network interface.
	**/
	static public function ifaddresses(args:haxe.extern.Rest<Dynamic>):Dynamic;
	/**
		Obtain a list of the interfaces available on this machine.
	**/
	static public function interfaces(args:haxe.extern.Rest<Dynamic>):Dynamic;
	static public var version : Dynamic;
}