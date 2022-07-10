Auth = exports.plouffe_lib:Get("Auth")
Utils = exports.plouffe_lib:Get("Utils")

Server = {
	ready = false,
}

Sh = {}

Sh.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
    maxMoney = 5000
}

Sh.Shops = {
   	paleto_twentyfourseven = {
		coords = vector3(1737.4481201172, 6419.4443359375, 35.037181854248),
    },   
	sandyshores_twentyfourseven = {
		coords = vector3(1961.7028808594, 3750.3967285156, 32.343742370605),
    },
    ocean_liquor = {
		coords = vector3(-2959.5222167969, 387.04962158203, 14.043286323547),
    },
    sanandreas_liquor = {
		coords = vector3(-1220.9068603516, -915.8310546875, 11.32631778717),
    },
    grove_ltd = {
		coords = vector3(-43.41340637207, -1748.4196777344, 29.414152145386),
    },
    clinton_avenue = {
		coords = vector3(381.07971191406, 332.74963378906, 103.56638336182),
    },
    palomino_freeway = {
		coords = vector3(2549.3864746094, 387.8551940918, 108.62283325195),
    },
    senora_freeway = {
		coords = vector3(2674.3352050781, 3289.1655273438, 55.241035461426),
    },
    route_68 = {
		coords = vector3(1169.2463378906, 2717.8435058594, 37.157680511475),
    },
    route_68_2 = {
		coords = vector3(543.77978515625, 2662.5285644531, 42.156482696533),
    },
    ineseno_road = {
		coords = vector3(-3048.7180175781, 588.47277832031, 7.90886926651),
    },
    barbareno_road = {
		coords = vector3(-3249.7380371094, 1007.3698730469, 12.830649375916),
    },	
    prosperity_street = {
		coords = vector3(-1479.0809326172, -375.51547241211, 39.163368225098),
    },
    el_rancho_boulevard = {
		coords = vector3(1126.8041992188, -980.15734863281, 45.409744262695),
    },	
    mirror_ltd = {
		coords = vector3(1159.5627441406, -314.17001342773, 69.205024719238),
    },
    grapeseed_main_street = {
		coords = vector3(1707.9447021484, 4920.3383789063, 42.063613891602),
    },	
    littleseoul_twentyfourseven = {
		coords = vector3(-709.67846679688, -904.09851074219, 19.21558380127),
    },
	innocence_blvd = {
		coords = vector3(31.188018798828, -1339.1567382813, 29.496952056885),
    },
	rockfort_ltd = {
		coords = vector3(-1829.0972900391, 798.73101806641, 138.19023132324),
    }
}

