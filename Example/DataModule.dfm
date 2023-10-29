object frmDataModule: TfrmDataModule
  Height = 480
  Width = 640
  object Tina4HttpServer1: TTina4HttpServer
    Bindings = <>
    MaxConnections = 1024
    Scheduler = IdSchedulerOfThreadPool1
    OnCommandGet = Tina4HttpServer1CommandGet
    Left = 264
    Top = 144
  end
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 328
    Top = 336
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\andre\IdeaProjects\tina4delphi\Example\Car_Dat' +
        'abase.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 192
    Top = 232
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 304
    Top = 232
  end
  object Tina4Route1: TTina4Route
    CRUD = False
    Left = 200
    Top = 384
  end
  object Tina4REST1: TTina4REST
    BaseUrl = 'https://api.publicapis.org'
    Left = 438
    Top = 147
  end
  object RESTRequest1: TRESTRequest
    Params = <>
    SynchronizedEvents = False
    Left = 486
    Top = 307
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    DataKey = 'entries'
    EndPoint = 'entries'
    MemTable = FDMemTable1
    Tina4REST = Tina4REST1
    JSONResponse.Strings = (
      
        '{"count":1427,"entries":[{"API":"AdoptAPet","Description":"Resou' +
        'rce to help get pets adopted","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.adoptapet.com\/public\/apis\/pet_l' +
        'ist.html","Category":"Animals"},{"API":"Axolotl","Description":"' +
        'Collection of axolotl pictures and facts","Auth":"","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/theaxolotlapi.netlify.app\/","Cat' +
        'egory":"Animals"},{"API":"Cat Facts","Description":"Daily cat fa' +
        'cts","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/alexwo' +
        'hlbruck.github.io\/cat-facts\/","Category":"Animals"},{"API":"Ca' +
        'taas","Description":"Cat as a service (cats pictures and gifs)",' +
        '"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/cataas.com\' +
        '/","Category":"Animals"},{"API":"Cats","Description":"Pictures o' +
        'f cats from Tumblr","Auth":"apiKey","HTTPS":true,"Cors":"no","Li' +
        'nk":"https:\/\/docs.thecatapi.com\/","Category":"Animals"},{"API' +
        '":"Dog Facts","Description":"Random dog facts","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/dukengn.github.io\/Dog-fact' +
        's-API\/","Category":"Animals"},{"API":"Dog Facts","Description":' +
        '"Random facts of Dogs","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/kinduff.github.io\/dog-api\/","Category":"Animals"}' +
        ',{"API":"Dogs","Description":"Based on the Stanford Dogs Dataset' +
        '","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/dog.ceo\' +
        '/dog-api\/","Category":"Animals"},{"API":"eBird","Description":"' +
        'Retrieve recent or notable birding observations within a region"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/docu' +
        'menter.getpostman.com\/view\/664302\/S1ENwy59","Category":"Anima' +
        'ls"},{"API":"FishWatch","Description":"Information and pictures ' +
        'about individual fish species","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/www.fishwatch.gov\/developers","Category":"' +
        'Animals"},{"API":"HTTP Cat","Description":"Cat for every HTTP St' +
        'atus","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/http' +
        '.cat\/","Category":"Animals"},{"API":"HTTP Dog","Description":"D' +
        'ogs for every HTTP response status code","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/http.dog\/","Category":"Animals"}' +
        ',{"API":"IUCN","Description":"IUCN Red List of Threatened Specie' +
        's","Auth":"apiKey","HTTPS":false,"Cors":"no","Link":"http:\/\/ap' +
        'iv3.iucnredlist.org\/api\/v3\/docs","Category":"Animals"},{"API"' +
        ':"MeowFacts","Description":"Get random cat facts","Auth":"","HTT' +
        'PS":true,"Cors":"no","Link":"https:\/\/github.com\/wh-iterabb-it' +
        '\/meowfacts","Category":"Animals"},{"API":"Movebank","Descriptio' +
        'n":"Movement and Migration data of animals","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/github.com\/movebank\/movebank' +
        '-api-doc","Category":"Animals"},{"API":"Petfinder","Description"' +
        ':"Petfinder is dedicated to helping pets find homes, another res' +
        'ource to get pets adopted","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/www.petfinder.com\/developers\/","Categor' +
        'y":"Animals"},{"API":"PlaceBear","Description":"Placeholder bear' +
        ' pictures","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/placebear.com\/","Category":"Animals"},{"API":"PlaceDog","Descr' +
        'iption":"Placeholder Dog pictures","Auth":"","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/place.dog","Category":"Animals"},{"API"' +
        ':"PlaceKitten","Description":"Placeholder Kitten pictures","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/placekitten.com' +
        '\/","Category":"Animals"},{"API":"RandomDog","Description":"Rand' +
        'om pictures of dogs","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/random.dog\/woof.json","Category":"Animals"},{"API":"' +
        'RandomDuck","Description":"Random pictures of ducks","Auth":"","' +
        'HTTPS":true,"Cors":"no","Link":"https:\/\/random-d.uk\/api","Cat' +
        'egory":"Animals"},{"API":"RandomFox","Description":"Random pictu' +
        'res of foxes","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\' +
        '/\/randomfox.ca\/floof\/","Category":"Animals"},{"API":"RescueGr' +
        'oups","Description":"Adoption","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/userguide.rescuegroups.org\/display\/AP' +
        'IDG\/API+Developers+Guide+Home","Category":"Animals"},{"API":"Sh' +
        'ibe.Online","Description":"Random pictures of Shiba Inu, cats or' +
        ' birds","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\/\/shi' +
        'be.online\/","Category":"Animals"},{"API":"The Dog","Description' +
        '":"A public service all about Dogs, free to use when making your' +
        ' fancy new App, Website or Service","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/thedogapi.com\/","Category":"Anim' +
        'als"},{"API":"xeno-canto","Description":"Bird recordings","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/xeno-canto.o' +
        'rg\/explore\/api","Category":"Animals"},{"API":"Zoo Animals","De' +
        'scription":"Facts and pictures of zoo animals","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/zoo-animal-api.herokuapp.co' +
        'm\/","Category":"Animals"},{"API":"AniAPI","Description":"Anime ' +
        'discovery, streaming & syncing with trackers","Auth":"OAuth","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/aniapi.com\/docs\/","Ca' +
        'tegory":"Anime"},{"API":"AniDB","Description":"Anime Database","' +
        'Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"https:\/\/' +
        'wiki.anidb.net\/HTTP_API_Definition","Category":"Anime"},{"API":' +
        '"AniList","Description":"Anime discovery & tracking","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/' +
        'AniList\/ApiV2-GraphQL-Docs","Category":"Anime"},{"API":"AnimeCh' +
        'an","Description":"Anime quotes (over 10k+)","Auth":"","HTTPS":t' +
        'rue,"Cors":"no","Link":"https:\/\/github.com\/RocktimSaikia\/ani' +
        'me-chan","Category":"Anime"},{"API":"AnimeFacts","Description":"' +
        'Anime Facts (over 100+)","Auth":"","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/chandan-02.github.io\/anime-facts-rest-api\/","Ca' +
        'tegory":"Anime"},{"API":"AnimeNewsNetwork","Description":"Anime ' +
        'industry news","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/www.animenewsnetwork.com\/encyclopedia\/api.php","Category"' +
        ':"Anime"},{"API":"Catboy","Description":"Neko images, funny GIFs' +
        ' & more","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/c' +
        'atboys.com\/api","Category":"Anime"},{"API":"Danbooru Anime","De' +
        'scription":"Thousands of anime artist database to find good anim' +
        'e art","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/danbooru.donmai.us\/wiki_pages\/help:api","Category":"Anime"}' +
        ',{"API":"Jikan","Description":"Unofficial MyAnimeList API","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/jikan.moe","Cat' +
        'egory":"Anime"},{"API":"Kitsu","Description":"Anime discovery pl' +
        'atform","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/kitsu.docs.apiary.io\/","Category":"Anime"},{"API":"MangaDex"' +
        ',"Description":"Manga Database and Community","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/api.mangadex.org\/' +
        'docs.html","Category":"Anime"},{"API":"Mangapi","Description":"T' +
        'ranslate manga pages from one language to another","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/rapidapi.com\' +
        '/pierre.carcellermeunier\/api\/mangapi3\/","Category":"Anime"},{' +
        '"API":"MyAnimeList","Description":"Anime and Manga Database and ' +
        'Community","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/myanimelist.net\/clubs.php?cid=13727","Category":"Anim' +
        'e"},{"API":"NekosBest","Description":"Neko Images & Anime rolepl' +
        'aying GIFs","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/docs.nekos.best","Category":"Anime"},{"API":"Shikimori","Descr' +
        'iption":"Anime discovery, tracking, forum, rates","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/shikimori.one\/' +
        'api\/doc","Category":"Anime"},{"API":"Studio Ghibli","Descriptio' +
        'n":"Resources from Studio Ghibli films","Auth":"","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/ghibliapi.herokuapp.com","Category' +
        '":"Anime"},{"API":"Trace Moe","Description":"A useful tool to ge' +
        't the exact scene of an anime from a screenshot","Auth":"","HTTP' +
        'S":true,"Cors":"no","Link":"https:\/\/soruly.github.io\/trace.mo' +
        'e-api\/#\/","Category":"Anime"},{"API":"Waifu.im","Description":' +
        '"Get waifu pictures from an archive of over 4000 images and mult' +
        'iple tags","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/waifu.im\/docs","Category":"Anime"},{"API":"Waifu.pics","Descri' +
        'ption":"Image sharing platform for anime images","Auth":"","HTTP' +
        'S":true,"Cors":"no","Link":"https:\/\/waifu.pics\/docs","Categor' +
        'y":"Anime"},{"API":"AbuseIPDB","Description":"IP\/domain\/URL re' +
        'putation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/docs.abuseipdb.com\/","Category":"Anti-Malware"},{"API' +
        '":"AlienVault Open Threat Exchange (OTX)","Description":"IP\/dom' +
        'ain\/URL reputation","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/otx.alienvault.com\/api","Category":"Anti-M' +
        'alware"},{"API":"CAPEsandbox","Description":"Malware execution a' +
        'nd analysis","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/capev2.readthedocs.io\/en\/latest\/usage\/api.html"' +
        ',"Category":"Anti-Malware"},{"API":"Google Safe Browsing","Descr' +
        'iption":"Google Link\/Domain Flagging","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developers.google.com\/sa' +
        'fe-browsing\/","Category":"Anti-Malware"},{"API":"MalDatabase","' +
        'Description":"Provide malware datasets and threat intelligence f' +
        'eeds","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/maldatabase.com\/api-doc.html","Category":"Anti-Malware"},' +
        '{"API":"MalShare","Description":"Malware Archive \/ file sourcin' +
        'g","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/ma' +
        'lshare.com\/doc.php","Category":"Anti-Malware"},{"API":"MalwareB' +
        'azaar","Description":"Collect and share malware samples","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bazaar.' +
        'abuse.ch\/api\/","Category":"Anti-Malware"},{"API":"Metacert","D' +
        'escription":"Metacert Link Flagging","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/metacert.com\/","Category":' +
        '"Anti-Malware"},{"API":"NoPhishy","Description":"Check links to ' +
        'see if they'#39're known phishing attempts","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/rapidapi.com\/Amiichu\/api\/' +
        'exerra-phishing-check\/","Category":"Anti-Malware"},{"API":"Phis' +
        'herman","Description":"IP\/domain\/URL reputation","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/phisherman.gg' +
        '\/","Category":"Anti-Malware"},{"API":"Scanii","Description":"Si' +
        'mple REST API that can scan submitted documents\/files for the p' +
        'resence of threats","Auth":"apiKey","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/docs.scanii.com\/","Category":"Anti-Malware"},{"' +
        'API":"URLhaus","Description":"Bulk queries and Download Malware ' +
        'Samples","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/u' +
        'rlhaus-api.abuse.ch\/","Category":"Anti-Malware"},{"API":"URLSca' +
        'n.io","Description":"Scan and Analyse URLs","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/urlscan.io\/about-ap' +
        'i\/","Category":"Anti-Malware"},{"API":"VirusTotal","Description' +
        '":"VirusTotal File\/URL Analysis","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.virustotal.com\/en\/docume' +
        'ntation\/public-api\/","Category":"Anti-Malware"},{"API":"Web of' +
        ' Trust","Description":"IP\/domain\/URL reputation","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/support.mywot' +
        '.com\/hc\/en-us\/sections\/360004477734-API-","Category":"Anti-M' +
        'alware"},{"API":"Am'#195#169'thyste","Description":"Generate images for ' +
        'Discord users","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/api.amethyste.moe\/","Category":"Art & Design"},{' +
        '"API":"Art Institute of Chicago","Description":"Art","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/api.artic.edu\/docs\/' +
        '","Category":"Art & Design"},{"API":"Colormind","Description":"C' +
        'olor scheme generator","Auth":"","HTTPS":false,"Cors":"unknown",' +
        '"Link":"http:\/\/colormind.io\/api-access\/","Category":"Art & D' +
        'esign"},{"API":"ColourLovers","Description":"Get various pattern' +
        's, palettes and images","Auth":"","HTTPS":false,"Cors":"unknown"' +
        ',"Link":"http:\/\/www.colourlovers.com\/api","Category":"Art & D' +
        'esign"},{"API":"Cooper Hewitt","Description":"Smithsonian Design' +
        ' Museum","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/collection.cooperhewitt.org\/api","Category":"Art & Des' +
        'ign"},{"API":"Dribbble","Description":"Discover the world'#226#8364#8482's to' +
        'p designers & creatives","Auth":"OAuth","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/developer.dribbble.com","Category":"Art ' +
        '& Design"},{"API":"EmojiHub","Description":"Get emojis by catego' +
        'ries and groups","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/github.com\/cheatsnake\/emojihub","Category":"Art & Desig' +
        'n"},{"API":"Europeana","Description":"European Museum and Galler' +
        'ies content","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/pro.europeana.eu\/resources\/apis\/search","Categor' +
        'y":"Art & Design"},{"API":"Harvard Art Museums","Description":"A' +
        'rt","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"https' +
        ':\/\/github.com\/harvardartmuseums\/api-docs","Category":"Art & ' +
        'Design"},{"API":"Icon Horse","Description":"Favicons for any web' +
        'site, with fallbacks","Auth":"","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/icon.horse","Category":"Art & Design"},{"API":"Iconf' +
        'inder","Description":"Icons","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/developer.iconfinder.com","Category' +
        '":"Art & Design"},{"API":"Icons8","Description":"Icons (find \"s' +
        'earch icon\" hyperlink in page)","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/img.icons8.com\/","Category":"Art & D' +
        'esign"},{"API":"Lordicon","Description":"Icons with predone Anim' +
        'ations","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/lo' +
        'rdicon.com\/","Category":"Art & Design"},{"API":"Metropolitan Mu' +
        'seum of Art","Description":"Met Museum of Art","Auth":"","HTTPS"' +
        ':true,"Cors":"no","Link":"https:\/\/metmuseum.github.io\/","Cate' +
        'gory":"Art & Design"},{"API":"Noun Project","Description":"Icons' +
        '","Auth":"OAuth","HTTPS":false,"Cors":"unknown","Link":"http:\/\' +
        '/api.thenounproject.com\/index.html","Category":"Art & Design"},' +
        '{"API":"PHP-Noise","Description":"Noise Background Image Generat' +
        'or","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/php-no' +
        'ise.com\/","Category":"Art & Design"},{"API":"Pixel Encounter","' +
        'Description":"SVG Icon Generator","Auth":"","HTTPS":true,"Cors":' +
        '"no","Link":"https:\/\/pixelencounter.com\/api","Category":"Art ' +
        '& Design"},{"API":"Rijksmuseum","Description":"RijksMuseum Data"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/data.rijksmuseum.nl\/object-metadata\/api\/","Category":"Art & ' +
        'Design"},{"API":"Word Cloud","Description":"Easily create word c' +
        'louds","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/wordcloudapi.com\/","Category":"Art & Design"},{"API":"xC' +
        'olors","Description":"Generate & convert colors","Auth":"","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/x-colors.herokuapp.com\/"' +
        ',"Category":"Art & Design"},{"API":"Auth0","Description":"Easy t' +
        'o implement, adaptable authentication and authorization platform' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/au' +
        'th0.com","Category":"Authentication & Authorization"},{"API":"Ge' +
        'tOTP","Description":"Implement OTP flow quickly","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"no","Link":"https:\/\/otp.dev\/en\/docs\/"' +
        ',"Category":"Authentication & Authorization"},{"API":"Micro User' +
        ' Service","Description":"User management and authentication","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/m3o.com\' +
        '/user","Category":"Authentication & Authorization"},{"API":"Mojo' +
        'Auth","Description":"Secure and modern passwordless authenticati' +
        'on platform","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/mojoauth.com","Category":"Authentication & Authorizatio' +
        'n"},{"API":"SAWO Labs","Description":"Simplify login and improve' +
        ' user experience by integrating passwordless authentication in y' +
        'our app","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/sawolabs.com","Category":"Authentication & Authorization"},' +
        '{"API":"Stytch","Description":"User infrastructure for modern ap' +
        'plications","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"htt' +
        'ps:\/\/stytch.com\/","Category":"Authentication & Authorization"' +
        '},{"API":"Warrant","Description":"APIs for authorization and acc' +
        'ess control","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/warrant.dev\/","Category":"Authentication & Authorizati' +
        'on"},{"API":"Bitquery","Description":"Onchain GraphQL APIs & DEX' +
        ' APIs","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/graphql.bitquery.io\/ide","Category":"Blockchain"},{"API":"Ch' +
        'ainlink","Description":"Build hybrid smart contracts with Chainl' +
        'ink","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/c' +
        'hain.link\/developer-resources","Category":"Blockchain"},{"API":' +
        '"Chainpoint","Description":"Chainpoint is a global network for a' +
        'nchoring data to the Bitcoin blockchain","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/tierion.com\/chainpoint\/","C' +
        'ategory":"Blockchain"},{"API":"Covalent","Description":"Multi-bl' +
        'ockchain data aggregator platform","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.covalenthq.com\/docs\/api' +
        '\/","Category":"Blockchain"},{"API":"Etherscan","Description":"E' +
        'thereum explorer API","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/etherscan.io\/apis","Category":"Blockchain"},{' +
        '"API":"Helium","Description":"Helium is a global, distributed ne' +
        'twork of Hotspots that create public, long-range wireless covera' +
        'ge","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/do' +
        'cs.helium.com\/api\/blockchain\/introduction\/","Category":"Bloc' +
        'kchain"},{"API":"Nownodes","Description":"Blockchain-as-a-servic' +
        'e solution that provides high-quality connection via API","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/nownod' +
        'es.io\/","Category":"Blockchain"},{"API":"Steem","Description":"' +
        'Blockchain-based blogging and social media website","Auth":"","H' +
        'TTPS":false,"Cors":"no","Link":"https:\/\/developers.steem.io\/"' +
        ',"Category":"Blockchain"},{"API":"The Graph","Description":"Inde' +
        'xing protocol for querying networks like Ethereum with GraphQL",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'thegraph.com","Category":"Blockchain"},{"API":"Walltime","Descri' +
        'ption":"To retrieve Walltime'#39's market info","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/walltime.info\/api.html","' +
        'Category":"Blockchain"},{"API":"Watchdata","Description":"Provid' +
        'e simple and reliable API access to Ethereum blockchain","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.wa' +
        'tchdata.io","Category":"Blockchain"},{"API":"A B'#195#173'blia Digital",' +
        '"Description":"Do not worry about managing the multiple versions' +
        ' of the Bible","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"' +
        'https:\/\/www.abibliadigital.com.br\/en","Category":"Books"},{"A' +
        'PI":"Bhagavad Gita","Description":"Open Source Shrimad Bhagavad ' +
        'Gita API including 21+ authors translation in Sanskrit\/English\' +
        '/Hindi","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/docs.bhagavadgitaapi.in","Category":"Books"},{"API":"Bhagava' +
        'd Gita","Description":"Bhagavad Gita text","Auth":"OAuth","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/bhagavadgita.io\/api","Cat' +
        'egory":"Books"},{"API":"Bhagavad Gita telugu","Description":"Bha' +
        'gavad Gita API in telugu and odia languages","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/gita-api.vercel.app","Categor' +
        'y":"Books"},{"API":"Bible-api","Description":"Free Bible API wit' +
        'h multiple languages","Auth":"","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/bible-api.com\/","Category":"Books"},{"API":"British' +
        ' National Bibliography","Description":"Books","Auth":"","HTTPS":' +
        'false,"Cors":"unknown","Link":"http:\/\/bnb.data.bl.uk\/","Categ' +
        'ory":"Books"},{"API":"Crossref Metadata Search","Description":"B' +
        'ooks & Articles Metadata","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/github.com\/CrossRef\/rest-api-doc","Categor' +
        'y":"Books"},{"API":"Ganjoor","Description":"Classic Persian poet' +
        'ry works including access to related manuscripts, recitations an' +
        'd music tracks","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/api.ganjoor.net","Category":"Books"},{"API":"Google B' +
        'ooks","Description":"Books","Auth":"OAuth","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/developers.google.com\/books\/","Cate' +
        'gory":"Books"},{"API":"GurbaniNow","Description":"Fast and Accur' +
        'ate Gurbani RESTful API","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/github.com\/GurbaniNow\/api","Category":"Book' +
        's"},{"API":"Gutendex","Description":"Web-API for fetching data f' +
        'rom Project Gutenberg Books Library","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/gutendex.com\/","Category":"Books' +
        '"},{"API":"Open Library","Description":"Books, book covers and r' +
        'elated data","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/' +
        '\/openlibrary.org\/developers\/api","Category":"Books"},{"API":"' +
        'Penguin Publishing","Description":"Books, book covers and relate' +
        'd data","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\/\/www' +
        '.penguinrandomhouse.biz\/webservices\/rest\/","Category":"Books"' +
        '},{"API":"PoetryDB","Description":"Enables you to get instant da' +
        'ta from our vast poetry collection","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/github.com\/thundercomb\/poetrydb#read' +
        'me","Category":"Books"},{"API":"Quran","Description":"RESTful Qu' +
        'ran API with multiple languages","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/quran.api-docs.io\/","Category":"Books"},' +
        '{"API":"Quran Cloud","Description":"A RESTful Quran API to retri' +
        'eve an Ayah, Surah, Juz or the entire Holy Quran","Auth":"","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/alquran.cloud\/api","Cat' +
        'egory":"Books"},{"API":"Quran-api","Description":"Free Quran API' +
        ' Service with 90+ different languages and 400+ translations","Au' +
        'th":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/f' +
        'awazahmed0\/quran-api#readme","Category":"Books"},{"API":"Rig Ve' +
        'da","Description":"Gods and poets, their categories, and the ver' +
        'se meters, with the mandal and sukta number","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/aninditabasu.github.io\/i' +
        'ndica\/html\/rv.html","Category":"Books"},{"API":"The Bible","De' +
        'scription":"Everything you need from the Bible in one discoverab' +
        'le place","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/docs.api.bible","Category":"Books"},{"API":"Thirukkura' +
        'l","Description":"1330 Thirukkural poems and explanation in Tami' +
        'l and English","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/api-thirukkural.web.app\/","Category":"Books"},{"API":"Vedi' +
        'c Society","Description":"Descriptions of all nouns (names, plac' +
        'es, animals, things) from vedic literature","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/aninditabasu.github.io\/in' +
        'dica\/html\/vs.html","Category":"Books"},{"API":"Wizard World","' +
        'Description":"Get information from the Harry Potter universe","A' +
        'uth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/wizard-world' +
        '-api.herokuapp.com\/swagger\/index.html","Category":"Books"},{"A' +
        'PI":"Wolne Lektury","Description":"API for obtaining information' +
        ' about e-books available on the WolneLektury.pl website","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/wolnelektury.' +
        'pl\/api\/","Category":"Books"},{"API":"Apache Superset","Descrip' +
        'tion":"API to manage your BI dashboards and data sources on Supe' +
        'rset","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/superset.apache.org\/docs\/api","Category":"Business"},{"API":' +
        '"Charity Search","Description":"Non-profit charity data","Auth":' +
        '"apiKey","HTTPS":false,"Cors":"unknown","Link":"http:\/\/charity' +
        'api.orghunter.com\/","Category":"Business"},{"API":"Clearbit Log' +
        'o","Description":"Search for company logos and embed them in you' +
        'r projects","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/clearbit.com\/docs#logo-api","Category":"Business"},' +
        '{"API":"Domainsdb.info","Description":"Registered Domain Names S' +
        'earch","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/doma' +
        'insdb.info\/","Category":"Business"},{"API":"Freelancer","Descri' +
        'ption":"Hire freelancers to get work done","Auth":"OAuth","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developers.freelancer.' +
        'com","Category":"Business"},{"API":"Gmail","Description":"Flexib' +
        'le, RESTful access to the user'#39's inbox","Auth":"OAuth","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developers.google.com\/gm' +
        'ail\/api\/","Category":"Business"},{"API":"Google Analytics","De' +
        'scription":"Collect, configure and analyze your data to reach th' +
        'e right audience","Auth":"OAuth","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developers.google.com\/analytics\/","Category":' +
        '"Business"},{"API":"Instatus","Description":"Post to and update ' +
        'maintenance and incidents on your status page through an HTTP RE' +
        'ST API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/instatus.com\/help\/api","Category":"Business"},{"API":"' +
        'Mailchimp","Description":"Send marketing campaigns and transacti' +
        'onal mails","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/mailchimp.com\/developer\/","Category":"Business"},{' +
        '"API":"mailjet","Description":"Marketing email can be sent and m' +
        'ail templates made in MJML or HTML can be sent using API","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ma' +
        'iljet.com\/","Category":"Business"},{"API":"markerapi","Descript' +
        'ion":"Trademark Search","Auth":"","HTTPS":false,"Cors":"unknown"' +
        ',"Link":"https:\/\/markerapi.com","Category":"Business"},{"API":' +
        '"ORB Intelligence","Description":"Company lookup","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.orb-intell' +
        'igence.com\/docs\/","Category":"Business"},{"API":"Redash","Desc' +
        'ription":"Access your queries and dashboards on Redash","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/redash.io\/h' +
        'elp\/user-guide\/integrations-and-api\/api","Category":"Business' +
        '"},{"API":"Smartsheet","Description":"Allows you to programmatic' +
        'ally access and Smartsheet data and account information","Auth":' +
        '"OAuth","HTTPS":true,"Cors":"no","Link":"https:\/\/smartsheet.re' +
        'doc.ly\/","Category":"Business"},{"API":"Square","Description":"' +
        'Easy way to take payments, manage refunds, and help customers ch' +
        'eckout online","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/developer.squareup.com\/reference\/square","Catego' +
        'ry":"Business"},{"API":"SwiftKanban","Description":"Kanban softw' +
        'are, Visualize Work, Increase Organizations Lead Time, Throughpu' +
        't & Productivity","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/www.digite.com\/knowledge-base\/swiftkanban\/a' +
        'rticle\/api-for-swift-kanban-web-services\/#restapi","Category":' +
        '"Business"},{"API":"Tenders in Hungary","Description":"Get data ' +
        'for procurements in Hungary in JSON format","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/tenders.guru\/hu\/api","Ca' +
        'tegory":"Business"},{"API":"Tenders in Poland","Description":"Ge' +
        't data for procurements in Poland in JSON format","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/tenders.guru\/pl\/ap' +
        'i","Category":"Business"},{"API":"Tenders in Romania","Descripti' +
        'on":"Get data for procurements in Romania in JSON format","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tenders.guru' +
        '\/ro\/api","Category":"Business"},{"API":"Tenders in Spain","Des' +
        'cription":"Get data for procurements in Spain in JSON format","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tenders.' +
        'guru\/es\/api","Category":"Business"},{"API":"Tenders in Ukraine' +
        '","Description":"Get data for procurements in Ukraine in JSON fo' +
        'rmat","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'tenders.guru\/ua\/api","Category":"Business"},{"API":"Tomba emai' +
        'l finder","Description":"Email Finder for B2B sales and email ma' +
        'rketing and email verifier","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/tomba.io\/api","Category":"Business"},{"' +
        'API":"Trello","Description":"Boards, lists and cards to help you' +
        ' organize and prioritize your projects","Auth":"OAuth","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developers.trello.com\/",' +
        '"Category":"Business"},{"API":"Abstract Public Holidays","Descri' +
        'ption":"Data on national, regional, and religious holidays via A' +
        'PI","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'www.abstractapi.com\/holidays-api","Category":"Calendar"},{"API"' +
        ':"Calendarific","Description":"Worldwide Holidays","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/calendarific.' +
        'com\/","Category":"Calendar"},{"API":"Checkiday - National Holid' +
        'ay API","Description":"Industry-leading Holiday API. Over 5,000 ' +
        'holidays and thousands of descriptions. Trusted by the World'#226#8364#8482's' +
        ' leading companies","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/apilayer.com\/marketplace\/checkiday-api","C' +
        'ategory":"Calendar"},{"API":"Church Calendar","Description":"Cat' +
        'holic liturgical calendar","Auth":"","HTTPS":false,"Cors":"unkno' +
        'wn","Link":"http:\/\/calapi.inadiutorium.cz\/","Category":"Calen' +
        'dar"},{"API":"Czech Namedays Calendar","Description":"Lookup for' +
        ' a name and returns nameday date","Auth":"","HTTPS":false,"Cors"' +
        ':"unknown","Link":"https:\/\/svatky.adresa.info","Category":"Cal' +
        'endar"},{"API":"Festivo Public Holidays","Description":"Fastest ' +
        'and most advanced public holiday and observance service on the m' +
        'arket","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/docs.getfestivo.com\/docs\/products\/public-holidays-api\/int' +
        'ro","Category":"Calendar"},{"API":"Google Calendar","Description' +
        '":"Display, create and modify Google calendar events","Auth":"OA' +
        'uth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.' +
        'google.com\/google-apps\/calendar\/","Category":"Calendar"},{"AP' +
        'I":"Hebrew Calendar","Description":"Convert between Gregorian an' +
        'd Hebrew, fetch Shabbat and Holiday times, etc","Auth":"","HTTPS' +
        '":false,"Cors":"unknown","Link":"https:\/\/www.hebcal.com\/home\' +
        '/developer-apis","Category":"Calendar"},{"API":"Holidays","Descr' +
        'iption":"Historical data regarding holidays","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/holidayapi.com\/","' +
        'Category":"Calendar"},{"API":"LectServe","Description":"Protesta' +
        'nt liturgical calendar","Auth":"","HTTPS":false,"Cors":"unknown"' +
        ',"Link":"http:\/\/www.lectserve.com","Category":"Calendar"},{"AP' +
        'I":"Nager.Date","Description":"Public holidays for more than 90 ' +
        'countries","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'date.nager.at","Category":"Calendar"},{"API":"Namedays Calendar"' +
        ',"Description":"Provides namedays for multiple countries","Auth"' +
        ':"","HTTPS":true,"Cors":"yes","Link":"https:\/\/nameday.abalin.n' +
        'et","Category":"Calendar"},{"API":"Non-Working Days","Descriptio' +
        'n":"Database of ICS files for non working days","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/github.com\/gadael\/ic' +
        'sdb","Category":"Calendar"},{"API":"Non-Working Days","Descripti' +
        'on":"Simple REST API for checking working, non-working or short ' +
        'days for Russia, CIS, USA and other","Auth":"","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/isdayoff.ru","Category":"Calendar"},{' +
        '"API":"Russian Calendar","Description":"Check if a date is a Rus' +
        'sian holiday or not","Auth":"","HTTPS":true,"Cors":"no","Link":"' +
        'https:\/\/github.com\/egno\/work-calendar","Category":"Calendar"' +
        '},{"API":"UK Bank Holidays","Description":"Bank holidays in Engl' +
        'and and Wales, Scotland and Northern Ireland","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.gov.uk\/bank-holiday' +
        's.json","Category":"Calendar"},{"API":"AnonFiles","Description":' +
        '"Upload and share your files anonymously","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/anonfiles.com\/docs\/api","C' +
        'ategory":"Cloud Storage & File Sharing"},{"API":"BayFiles","Desc' +
        'ription":"Upload and share your files","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/bayfiles.com\/docs\/api","Categ' +
        'ory":"Cloud Storage & File Sharing"},{"API":"Box","Description":' +
        '"File Sharing and Storage","Auth":"OAuth","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/developer.box.com\/","Category":"Cloud' +
        ' Storage & File Sharing"},{"API":"ddownload","Description":"File' +
        ' Sharing and Storage","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/ddownload.com\/api","Category":"Cloud Stor' +
        'age & File Sharing"},{"API":"Dropbox","Description":"File Sharin' +
        'g and Storage","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.dropbox.com\/developers","Category":"Cloud Sto' +
        'rage & File Sharing"},{"API":"File.io","Description":"Super simp' +
        'le file sharing, convenient, anonymous and secure","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/www.file.io","Categ' +
        'ory":"Cloud Storage & File Sharing"},{"API":"Filestack","Descrip' +
        'tion":"Filestack File Uploader & File Upload API","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.filestack.' +
        'com","Category":"Cloud Storage & File Sharing"},{"API":"GoFile",' +
        '"Description":"Unlimited size file uploads for free","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gofile.io\/' +
        'api","Category":"Cloud Storage & File Sharing"},{"API":"Google D' +
        'rive","Description":"File Sharing and Storage","Auth":"OAuth","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/developers.google.' +
        'com\/drive\/","Category":"Cloud Storage & File Sharing"},{"API":' +
        '"Gyazo","Description":"Save & Share screen captures instantly","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/g' +
        'yazo.com\/api\/docs","Category":"Cloud Storage & File Sharing"},' +
        '{"API":"Imgbb","Description":"Simple and quick private image sha' +
        'ring","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/api.imgbb.com\/","Category":"Cloud Storage & File Sharing"' +
        '},{"API":"OneDrive","Description":"File Sharing and Storage","Au' +
        'th":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/deve' +
        'loper.microsoft.com\/onedrive","Category":"Cloud Storage & File ' +
        'Sharing"},{"API":"Pantry","Description":"Free JSON storage for s' +
        'mall projects","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/getpantry.cloud\/","Category":"Cloud Storage & File Sharing' +
        '"},{"API":"Pastebin","Description":"Plain Text Storage","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pastebin' +
        '.com\/doc_api","Category":"Cloud Storage & File Sharing"},{"API"' +
        ':"Pinata","Description":"IPFS Pinning Services API","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.pinata.' +
        'cloud\/","Category":"Cloud Storage & File Sharing"},{"API":"Quip' +
        '","Description":"File Sharing and Storage for groups","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/quip.com\/dev\' +
        '/automation\/documentation","Category":"Cloud Storage & File Sha' +
        'ring"},{"API":"Storj","Description":"Decentralized Open-Source C' +
        'loud Storage","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/docs.storj.io\/dcs\/","Category":"Cloud Storage & ' +
        'File Sharing"},{"API":"The Null Pointer","Description":"No-bulls' +
        'hit file hosting and URL shortening service","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/0x0.st","Category":"Cloud' +
        ' Storage & File Sharing"},{"API":"Web3 Storage","Description":"F' +
        'ile Sharing and Storage for Free with 1TB Space","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/web3.storage\/","Ca' +
        'tegory":"Cloud Storage & File Sharing"},{"API":"Azure DevOps Hea' +
        'lth","Description":"Resource health helps you diagnose and get s' +
        'upport when an Azure issue impacts your resources","Auth":"apiKe' +
        'y","HTTPS":false,"Cors":"no","Link":"https:\/\/docs.microsoft.co' +
        'm\/en-us\/rest\/api\/resourcehealth","Category":"Continuous Inte' +
        'gration"},{"API":"Bitrise","Description":"Build tool and process' +
        'es integrations to create efficient development pipelines","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api-d' +
        'ocs.bitrise.io\/","Category":"Continuous Integration"},{"API":"B' +
        'uddy","Description":"The fastest continuous integration and cont' +
        'inuous delivery platform","Auth":"OAuth","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/buddy.works\/docs\/api\/getting-started' +
        '\/overview","Category":"Continuous Integration"},{"API":"CircleC' +
        'I","Description":"Automate the software development process usin' +
        'g continuous integration and continuous delivery","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/circleci.com\/' +
        'docs\/api\/v1-reference\/","Category":"Continuous Integration"},' +
        '{"API":"Codeship","Description":"Codeship is a Continuous Integr' +
        'ation Platform in the cloud","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/docs.cloudbees.com\/docs\/cloudbees' +
        '-codeship\/latest\/api-overview\/","Category":"Continuous Integr' +
        'ation"},{"API":"Travis CI","Description":"Sync your GitHub proje' +
        'cts with Travis CI to test your code in minutes","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.travis-ci.' +
        'com\/api\/","Category":"Continuous Integration"},{"API":"0x","De' +
        'scription":"API for querying token and pool stats across various' +
        ' liquidity pools","Auth":"","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/0x.org\/api","Category":"Cryptocurrency"},{"API":"1inch"' +
        ',"Description":"API for querying decentralize exchange","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/1inch.io\/api\' +
        '/","Category":"Cryptocurrency"},{"API":"Alchemy Ethereum","Descr' +
        'iption":"Ethereum Node-as-a-Service Provider","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/docs.alchemy.com\/alch' +
        'emy\/","Category":"Cryptocurrency"},{"API":"apilayer coinlayer",' +
        '"Description":"Real-time Crypto Currency Exchange Rates","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/coinlay' +
        'er.com","Category":"Cryptocurrency"},{"API":"Binance","Descripti' +
        'on":"Exchange for Trading Cryptocurrencies based in China","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/githu' +
        'b.com\/binance\/binance-spot-api-docs","Category":"Cryptocurrenc' +
        'y"},{"API":"Bitcambio","Description":"Get the list of all traded' +
        ' assets in the exchange","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/nova.bitcambio.com.br\/api\/v3\/docs#a-public' +
        '","Category":"Cryptocurrency"},{"API":"BitcoinAverage","Descript' +
        'ion":"Digital Asset Price Data for the blockchain industry","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apiv' +
        '2.bitcoinaverage.com\/","Category":"Cryptocurrency"},{"API":"Bit' +
        'coinCharts","Description":"Financial and Technical Data related ' +
        'to the Bitcoin Network","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/bitcoincharts.com\/about\/exchanges\/","Catego' +
        'ry":"Cryptocurrency"},{"API":"Bitfinex","Description":"Cryptocur' +
        'rency Trading Platform","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/docs.bitfinex.com\/docs","Category":"Cry' +
        'ptocurrency"},{"API":"Bitmex","Description":"Real-Time Cryptocur' +
        'rency derivatives trading platform based in Hong Kong","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.bitme' +
        'x.com\/app\/apiOverview","Category":"Cryptocurrency"},{"API":"Bi' +
        'ttrex","Description":"Next Generation Crypto Trading Platform","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/b' +
        'ittrex.github.io\/api\/v3","Category":"Cryptocurrency"},{"API":"' +
        'Block","Description":"Bitcoin Payment, Wallet & Transaction Data' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/block.io\/docs\/basic","Category":"Cryptocurrency"},{"API":"Bl' +
        'ockchain","Description":"Bitcoin Payment, Wallet & Transaction D' +
        'ata","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/www.blockchain.com\/api","Category":"Cryptocurrency"},{"API' +
        '":"blockfrost Cardano","Description":"Interaction with the Carda' +
        'no mainnet and several testnets","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/blockfrost.io\/","Category":"Cr' +
        'yptocurrency"},{"API":"Brave NewCoin","Description":"Real-time a' +
        'nd historic crypto data from more than 200+ exchanges","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bravenewc' +
        'oin.com\/developers","Category":"Cryptocurrency"},{"API":"BtcTur' +
        'k","Description":"Real-time cryptocurrency data, graphs and API ' +
        'that allows buy&sell","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/docs.btcturk.com\/","Category":"Cryptocurrency' +
        '"},{"API":"Bybit","Description":"Cryptocurrency data feed and al' +
        'gorithmic trading","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/bybit-exchange.github.io\/docs\/linear\/#t-in' +
        'troduction","Category":"Cryptocurrency"},{"API":"CoinAPI","Descr' +
        'iption":"All Currency Exchanges integrate under a single api","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/docs.co' +
        'inapi.io\/","Category":"Cryptocurrency"},{"API":"Coinbase","Desc' +
        'ription":"Bitcoin, Bitcoin Cash, Litecoin and Ethereum Prices","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/d' +
        'evelopers.coinbase.com","Category":"Cryptocurrency"},{"API":"Coi' +
        'nbase Pro","Description":"Cryptocurrency Trading Platform","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.' +
        'pro.coinbase.com\/#api","Category":"Cryptocurrency"},{"API":"Coi' +
        'nCap","Description":"Real time Cryptocurrency prices through a R' +
        'ESTful API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/docs.coincap.io\/","Category":"Cryptocurrency"},{"API":"Co' +
        'inDCX","Description":"Cryptocurrency Trading Platform","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.coin' +
        'dcx.com\/","Category":"Cryptocurrency"},{"API":"CoinDesk","Descr' +
        'iption":"CoinDesk'#39's Bitcoin Price Index (BPI) in multiple curren' +
        'cies","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'old.coindesk.com\/coindesk-api\/","Category":"Cryptocurrency"},{' +
        '"API":"CoinGecko","Description":"Cryptocurrency Price, Market, a' +
        'nd Developer\/Social Data","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"http:\/\/www.coingecko.com\/api","Category":"Cryptocurren' +
        'cy"},{"API":"Coinigy","Description":"Interacting with Coinigy Ac' +
        'counts and Exchange Directly","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/coinigy.docs.apiary.io","Category"' +
        ':"Cryptocurrency"},{"API":"Coinlib","Description":"Crypto Curren' +
        'cy Prices","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/coinlib.io\/apidocs","Category":"Cryptocurrency"},{"A' +
        'PI":"Coinlore","Description":"Cryptocurrencies prices, volume an' +
        'd more","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/www.coinlore.com\/cryptocurrency-data-api","Category":"Cryptoc' +
        'urrency"},{"API":"CoinMarketCap","Description":"Cryptocurrencies' +
        ' Prices","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/coinmarketcap.com\/api\/","Category":"Cryptocurrency"},' +
        '{"API":"Coinpaprika","Description":"Cryptocurrencies prices, vol' +
        'ume and more","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/api.coinpaprika.com","Category":"Cryptocurrency"},{"API":"Co' +
        'inRanking","Description":"Live Cryptocurrency data","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.c' +
        'oinranking.com\/api\/documentation","Category":"Cryptocurrency"}' +
        ',{"API":"Coinremitter","Description":"Cryptocurrencies Payment &' +
        ' Prices","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/coinremitter.com\/docs","Category":"Cryptocurrency"},{"' +
        'API":"CoinStats","Description":"Crypto Tracker","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/documenter.getpostman.' +
        'com\/view\/5734027\/RzZ6Hzr3?version=latest","Category":"Cryptoc' +
        'urrency"},{"API":"CryptAPI","Description":"Cryptocurrency Paymen' +
        't Processor","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/docs.cryptapi.io\/","Category":"Cryptocurrency"},{"API":"' +
        'CryptingUp","Description":"Cryptocurrency data","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/www.cryptingup.com\/ap' +
        'idoc\/#introduction","Category":"Cryptocurrency"},{"API":"Crypto' +
        'Compare","Description":"Cryptocurrencies Comparison","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.cryptocompare' +
        '.com\/api#","Category":"Cryptocurrency"},{"API":"CryptoMarket","' +
        'Description":"Cryptocurrencies Trading platform","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/api.exchange.crypto' +
        'mkt.com\/","Category":"Cryptocurrency"},{"API":"Cryptonator","De' +
        'scription":"Cryptocurrencies Exchange Rates","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.cryptonator.com\/api\' +
        '/","Category":"Cryptocurrency"},{"API":"dYdX","Description":"Dec' +
        'entralized cryptocurrency exchange","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/docs.dydx.exchange\/","Categ' +
        'ory":"Cryptocurrency"},{"API":"Ethplorer","Description":"Ethereu' +
        'm tokens, balances, addresses, history of transactions, contract' +
        's, and custom structures","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/github.com\/EverexIO\/Ethplorer\/wiki\' +
        '/Ethplorer-API","Category":"Cryptocurrency"},{"API":"EXMO","Desc' +
        'ription":"Cryptocurrencies exchange based in UK","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/documenter.getp' +
        'ostman.com\/view\/10287440\/SzYXWKPi","Category":"Cryptocurrency' +
        '"},{"API":"FTX","Description":"Complete REST, websocket, and FTX' +
        ' APIs to suit your algorithmic trading needs","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/docs.ftx.com\/","Categ' +
        'ory":"Cryptocurrency"},{"API":"Gateio","Description":"API provid' +
        'es spot, margin and futures trading operations","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.gate.io\/api' +
        '2","Category":"Cryptocurrency"},{"API":"Gemini","Description":"C' +
        'ryptocurrencies Exchange","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/docs.gemini.com\/rest-api\/","Category":"Cry' +
        'ptocurrency"},{"API":"Hirak Exchange Rates","Description":"Excha' +
        'nge rates between 162 currency & 300 crypto currency update each' +
        ' 5 min, accurate, no limits","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/rates.hirak.site\/","Category":"Cry' +
        'ptocurrency"},{"API":"Huobi","Description":"Seychelles based cry' +
        'ptocurrency exchange","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/huobiapi.github.io\/docs\/spot\/v1\/en\/",' +
        '"Category":"Cryptocurrency"},{"API":"icy.tools","Description":"G' +
        'raphQL based NFT API","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/developers.icy.tools\/","Category":"Crypto' +
        'currency"},{"API":"Indodax","Description":"Trade your Bitcoin an' +
        'd other assets with rupiah","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/github.com\/btcid\/indodax-official-' +
        'api-docs","Category":"Cryptocurrency"},{"API":"INFURA Ethereum",' +
        '"Description":"Interaction with the Ethereum mainnet and several' +
        ' testnets","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/infura.io\/product\/ethereum","Category":"Cryptocurrency"' +
        '},{"API":"Kraken","Description":"Cryptocurrencies Exchange","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs' +
        '.kraken.com\/rest\/","Category":"Cryptocurrency"},{"API":"KuCoin' +
        '","Description":"Cryptocurrency Trading Platform","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.kucoin.co' +
        'm\/","Category":"Cryptocurrency"},{"API":"Localbitcoins","Descri' +
        'ption":"P2P platform to buy and sell Bitcoins","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/localbitcoins.com\/api-' +
        'docs\/","Category":"Cryptocurrency"},{"API":"Mempool","Descripti' +
        'on":"Bitcoin API Service focusing on the transaction fee","Auth"' +
        ':"","HTTPS":true,"Cors":"no","Link":"https:\/\/mempool.space\/ap' +
        'i","Category":"Cryptocurrency"},{"API":"MercadoBitcoin","Descrip' +
        'tion":"Brazilian Cryptocurrency Information","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.mercadobitcoin.com.br' +
        '\/api-doc\/","Category":"Cryptocurrency"},{"API":"Messari","Desc' +
        'ription":"Provides API endpoints for thousands of crypto assets"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/messa' +
        'ri.io\/api","Category":"Cryptocurrency"},{"API":"Nexchange","Des' +
        'cription":"Automated cryptocurrency exchange service","Auth":"",' +
        '"HTTPS":false,"Cors":"yes","Link":"https:\/\/nexchange2.docs.api' +
        'ary.io\/","Category":"Cryptocurrency"},{"API":"Nomics","Descript' +
        'ion":"Historical and realtime cryptocurrency prices and market d' +
        'ata","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/nomics.com\/docs\/","Category":"Cryptocurrency"},{"API":"NovaDa' +
        'x","Description":"NovaDAX API to access all market data, trading' +
        ' management endpoints","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/doc.novadax.com\/en-US\/#introduction","C' +
        'ategory":"Cryptocurrency"},{"API":"OKEx","Description":"Cryptocu' +
        'rrency exchange based in Seychelles","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/www.okex.com\/docs\/","Cate' +
        'gory":"Cryptocurrency"},{"API":"Poloniex","Description":"US base' +
        'd digital asset exchange","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/docs.poloniex.com","Category":"Cryptoc' +
        'urrency"},{"API":"Solana JSON RPC","Description":"Provides vario' +
        'us endpoints to interact with the Solana Blockchain","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.solana.com\/' +
        'developing\/clients\/jsonrpc-api","Category":"Cryptocurrency"},{' +
        '"API":"Technical Analysis","Description":"Cryptocurrency prices ' +
        'and technical analysis","Auth":"apiKey","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/technical-analysis-api.com","Category":"Crypt' +
        'ocurrency"},{"API":"VALR","Description":"Cryptocurrency Exchange' +
        ' based in South Africa","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/docs.valr.com\/","Category":"Cryptocurre' +
        'ncy"},{"API":"WorldCoinIndex","Description":"Cryptocurrencies Pr' +
        'ices","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/www.worldcoinindex.com\/apiservice","Category":"Cryptocurr' +
        'ency"},{"API":"ZMOK","Description":"Ethereum JSON RPC API and We' +
        'b3 provider","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/zmok.io","Category":"Cryptocurrency"},{"API":"1Forge","De' +
        'scription":"Forex currency market data","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/1forge.com\/forex-data-a' +
        'pi\/api-documentation","Category":"Currency Exchange"},{"API":"A' +
        'mdoren","Description":"Free currency API with over 150 currencie' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/www.amdoren.com\/currency-api\/","Category":"Currency Exchang' +
        'e"},{"API":"apilayer fixer.io","Description":"Exchange rates and' +
        ' currency conversion","Auth":"apiKey","HTTPS":false,"Cors":"unkn' +
        'own","Link":"https:\/\/fixer.io","Category":"Currency Exchange"}' +
        ',{"API":"Bank of Russia","Description":"Exchange rates and curre' +
        'ncy conversion","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/www.cbr.ru\/development\/SXML\/","Category":"Currency ' +
        'Exchange"},{"API":"Currency-api","Description":"Free Currency Ex' +
        'change Rates API with 150+ Currencies & No Rate Limits","Auth":"' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/fawaza' +
        'hmed0\/currency-api#readme","Category":"Currency Exchange"},{"AP' +
        'I":"CurrencyFreaks","Description":"Provides current and historic' +
        'al currency exchange rates with free plan 1K requests\/month","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/curren' +
        'cyfreaks.com\/","Category":"Currency Exchange"},{"API":"Currency' +
        'layer","Description":"Exchange rates and currency conversion","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/cu' +
        'rrencylayer.com\/documentation","Category":"Currency Exchange"},' +
        '{"API":"CurrencyScoop","Description":"Real-time and historical c' +
        'urrency rates JSON API","Auth":"apiKey","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/currencyscoop.com\/api-documentation","Categ' +
        'ory":"Currency Exchange"},{"API":"Czech National Bank","Descript' +
        'ion":"A collection of exchange rates","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.cnb.cz\/cs\/financni_trhy\/d' +
        'evizovy_trh\/kurzy_devizoveho_trhu\/denni_kurz.xml","Category":"' +
        'Currency Exchange"},{"API":"Economia.Awesome","Description":"Por' +
        'tuguese free currency prices and conversion with no rate limits"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.' +
        'awesomeapi.com.br\/api-de-moedas","Category":"Currency Exchange"' +
        '},{"API":"ExchangeRate-API","Description":"Free currency convers' +
        'ion","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/www.exchangerate-api.com","Category":"Currency Exchange"},{"API' +
        '":"Exchangerate.host","Description":"Free foreign exchange & cry' +
        'pto rates API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/exchangerate.host","Category":"Currency Exchange"},{"AP' +
        'I":"Exchangeratesapi.io","Description":"Exchange rates with curr' +
        'ency conversion","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/exchangeratesapi.io","Category":"Currency Exchange"' +
        '},{"API":"Frankfurter","Description":"Exchange rates, currency c' +
        'onversion and time series","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/www.frankfurter.app\/docs","Category":"Currency' +
        ' Exchange"},{"API":"FreeForexAPI","Description":"Real-time forei' +
        'gn exchange rates for major currency pairs","Auth":"","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/freeforexapi.com\/Home\/Api","C' +
        'ategory":"Currency Exchange"},{"API":"National Bank of Poland","' +
        'Description":"A collection of currency exchange rates (data in X' +
        'ML and JSON)","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\' +
        '/\/api.nbp.pl\/en.html","Category":"Currency Exchange"},{"API":"' +
        'VATComply.com","Description":"Exchange rates, geolocation and VA' +
        'T number validation","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.vatcomply.com\/documentation","Category":"Currenc' +
        'y Exchange"},{"API":"Lob.com","Description":"US Address Verifica' +
        'tion","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/lob.com\/","Category":"Data Validation"},{"API":"Postman E' +
        'cho","Description":"Test api server to receive and return value ' +
        'from HTTP method","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.postman-echo.com","Category":"Data Validation"},' +
        '{"API":"PurgoMalum","Description":"Content validator against pro' +
        'fanity & obscenity","Auth":"","HTTPS":false,"Cors":"unknown","Li' +
        'nk":"http:\/\/www.purgomalum.com","Category":"Data Validation"},' +
        '{"API":"US Autocomplete","Description":"Enter address data quick' +
        'ly with real-time address suggestions","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.smarty.com\/docs\/cloud\/' +
        'us-autocomplete-pro-api","Category":"Data Validation"},{"API":"U' +
        'S Extract","Description":"Extract postal addresses from any text' +
        ' including emails","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/www.smarty.com\/products\/apis\/us-extract-api","' +
        'Category":"Data Validation"},{"API":"US Street Address","Descrip' +
        'tion":"Validate and append data for any US postal address","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.smart' +
        'y.com\/docs\/cloud\/us-street-api","Category":"Data Validation"}' +
        ',{"API":"vatlayer","Description":"VAT number validation","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/vatlaye' +
        'r.com\/documentation","Category":"Data Validation"},{"API":"24 P' +
        'ull Requests","Description":"Project to promote open source coll' +
        'aboration during December","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/24pullrequests.com\/api","Category":"Developmen' +
        't"},{"API":"Abstract Screenshot","Description":"Take programmati' +
        'c screenshots of web pages from any website","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/www.abstractapi.com\/we' +
        'bsite-screenshot-api","Category":"Development"},{"API":"Agify.io' +
        '","Description":"Estimates the age from a first name","Auth":"",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/agify.io","Category"' +
        ':"Development"},{"API":"API Gr'#195#161'tis","Description":"Multiples se' +
        'rvices and public APIs","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/apigratis.com.br\/","Category":"Development"},' +
        '{"API":"ApicAgent","Description":"Extract device details from us' +
        'er-agent string","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/www.apicagent.com","Category":"Development"},{"API":"ApiF' +
        'lash","Description":"Chrome based screenshot API for developers"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/apiflash.com\/","Category":"Development"},{"API":"apilayer user' +
        'stack","Description":"Secure User-Agent String Lookup JSON API",' +
        '"Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/u' +
        'serstack.com\/","Category":"Development"},{"API":"APIs.guru","De' +
        'scription":"Wikipedia for Web APIs, OpenAPI\/Swagger specs for p' +
        'ublic APIs","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/apis.guru\/api-doc\/","Category":"Development"},{"API":"Az' +
        'ure DevOps","Description":"The Azure DevOps basic components of ' +
        'a REST API request\/response pair","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/docs.microsoft.com\/en-us\/re' +
        'st\/api\/azure\/devops","Category":"Development"},{"API":"Base",' +
        '"Description":"Building quick backends","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/www.base-api.io\/","Category' +
        '":"Development"},{"API":"Beeceptor","Description":"Build a mock ' +
        'Rest API endpoint in seconds","Auth":"","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/beeceptor.com\/","Category":"Development"},{' +
        '"API":"Bitbucket","Description":"Bitbucket API","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.atlassi' +
        'an.com\/bitbucket\/api\/2\/reference\/","Category":"Development"' +
        '},{"API":"Blague.xyz","Description":"La plus grande API de Blagu' +
        'es FR\/The biggest FR jokes API","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/blague.xyz\/","Category":"Developme' +
        'nt"},{"API":"Blitapp","Description":"Schedule screenshots of web' +
        ' pages and sync them to your cloud","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/blitapp.com\/api\/","Categor' +
        'y":"Development"},{"API":"Blynk-Cloud","Description":"Control Io' +
        'T Devices from Blynk IoT Cloud","Auth":"apiKey","HTTPS":false,"C' +
        'ors":"unknown","Link":"https:\/\/blynkapi.docs.apiary.io\/#","Ca' +
        'tegory":"Development"},{"API":"Bored","Description":"Find random' +
        ' activities to fight boredom","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/www.boredapi.com\/","Category":"Developm' +
        'ent"},{"API":"Brainshop.ai","Description":"Make A Free A.I Brain' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/br' +
        'ainshop.ai\/","Category":"Development"},{"API":"Browshot","Descr' +
        'iption":"Easily make screenshots of web pages in any screen size' +
        ', as any device","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/browshot.com\/api\/documentation","Category":"Devel' +
        'opment"},{"API":"CDNJS","Description":"Library info on CDNJS","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.cdnj' +
        's.com\/libraries\/jquery","Category":"Development"},{"API":"Chan' +
        'gelogs.md","Description":"Structured changelog metadata from ope' +
        'n source projects","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/changelogs.md","Category":"Development"},{"API":"Ci' +
        'prand","Description":"Secure random string generator","Auth":"",' +
        '"HTTPS":true,"Cors":"no","Link":"https:\/\/github.com\/polarspet' +
        'roll\/ciprand","Category":"Development"},{"API":"Cloudflare Trac' +
        'e","Description":"Get IP Address, Timestamp, User Agent, Country' +
        ' Code, IATA, HTTP Version, TLS\/SSL Version & More","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/fawazahmed' +
        '0\/cloudflare-trace-api","Category":"Development"},{"API":"Codex' +
        '","Description":"Online Compiler for Various Languages","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/Ja' +
        'agrav\/CodeX","Category":"Development"},{"API":"Contentful Image' +
        's","Description":"Used to retrieve and apply transformations to ' +
        'images","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/www.contentful.com\/developers\/docs\/references\/images-api' +
        '\/","Category":"Development"},{"API":"CORS Proxy","Description":' +
        '"Get around the dreaded CORS error by using this proxy as a midd' +
        'le man","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/gi' +
        'thub.com\/burhanuday\/cors-proxy","Category":"Development"},{"AP' +
        'I":"CountAPI","Description":"Free and simple counting service. Y' +
        'ou can use it to track page hits and specific events","Auth":"",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/countapi.xyz","Categ' +
        'ory":"Development"},{"API":"Databricks","Description":"Service t' +
        'o manage your databricks account,clusters, notebooks, jobs and w' +
        'orkspaces","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/docs.databricks.com\/dev-tools\/api\/latest\/index.html",' +
        '"Category":"Development"},{"API":"DigitalOcean Status","Descript' +
        'ion":"Status of all DigitalOcean services","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/status.digitalocean.com\/ap' +
        'i","Category":"Development"},{"API":"Docker Hub","Description":"' +
        'Interact with Docker Hub","Auth":"apiKey","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/docs.docker.com\/docker-hub\/api\/latest\/' +
        '","Category":"Development"},{"API":"DomainDb Info","Description"' +
        ':"Domain name search to find all domains containing particular w' +
        'ords\/phrases\/etc","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/api.domainsdb.info\/","Category":"Development"},{"' +
        'API":"ExtendsClass JSON Storage","Description":"A simple JSON st' +
        'ore API","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/e' +
        'xtendsclass.com\/json-storage.html","Category":"Development"},{"' +
        'API":"GeekFlare","Description":"Provide numerous capabilities fo' +
        'r important testing and monitoring methods for websites","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apidocs' +
        '.geekflare.com\/docs\/geekflare-api","Category":"Development"},{' +
        '"API":"Genderize.io","Description":"Estimates a gender from a fi' +
        'rst name","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'genderize.io","Category":"Development"},{"API":"GETPing","Descri' +
        'ption":"Trigger an email notification with a simple GET request"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/www.getping.info","Category":"Development"},{"API":"Ghost","Des' +
        'cription":"Get Published content into your Website, App or other' +
        ' embedded media","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/ghost.org\/","Category":"Development"},{"API":"GitH' +
        'ub","Description":"Make use of GitHub repositories, code and use' +
        'r info programmatically","Auth":"OAuth","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/docs.github.com\/en\/free-pro-team@latest\/r' +
        'est","Category":"Development"},{"API":"Gitlab","Description":"Au' +
        'tomate GitLab interaction programmatically","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.gitlab.com\/ee\/' +
        'api\/","Category":"Development"},{"API":"Gitter","Description":"' +
        'Chat for Developers","Auth":"OAuth","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developer.gitter.im\/docs\/welcome","Categor' +
        'y":"Development"},{"API":"Glitterly","Description":"Image genera' +
        'tion API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/developers.glitterly.app","Category":"Development"},{"API"' +
        ':"Google Docs","Description":"API to read, write, and format Goo' +
        'gle Docs documents","Auth":"OAuth","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/developers.google.com\/docs\/api\/reference\/' +
        'rest","Category":"Development"},{"API":"Google Firebase","Descri' +
        'ption":"Google'#39's mobile application development platform that he' +
        'lps build, improve, and grow app","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/firebase.google.com\/docs","Catego' +
        'ry":"Development"},{"API":"Google Fonts","Description":"Metadata' +
        ' for all families served by Google Fonts","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developers.google.com\' +
        '/fonts\/docs\/developer_api","Category":"Development"},{"API":"G' +
        'oogle Keep","Description":"API to read, write, and format Google' +
        ' Keep notes","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/developers.google.com\/keep\/api\/reference\/rest","' +
        'Category":"Development"},{"API":"Google Sheets","Description":"A' +
        'PI to read, write, and format Google Sheets data","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.goog' +
        'le.com\/sheets\/api\/reference\/rest","Category":"Development"},' +
        '{"API":"Google Slides","Description":"API to read, write, and fo' +
        'rmat Google Slides presentations","Auth":"OAuth","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/developers.google.com\/slides\/' +
        'api\/reference\/rest","Category":"Development"},{"API":"Gorest",' +
        '"Description":"Online REST API for Testing and Prototyping","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gores' +
        't.co.in\/","Category":"Development"},{"API":"Hasura","Descriptio' +
        'n":"GraphQL and REST API Engine with built in Authorization","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/hasura.' +
        'io\/opensource\/","Category":"Development"},{"API":"Heroku","Des' +
        'cription":"REST API to programmatically create apps, provision a' +
        'dd-ons and perform other task on Heroku","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/devcenter.heroku.com\/articl' +
        'es\/platform-api-reference\/","Category":"Development"},{"API":"' +
        'host-t.com","Description":"Basic DNS query via HTTP GET request"' +
        ',"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/host-t.com' +
        '","Category":"Development"},{"API":"Host.io","Description":"Doma' +
        'ins Data API for Developers","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/host.io","Category":"Development"},{"AP' +
        'I":"HTTP2.Pro","Description":"Test endpoints for client and serv' +
        'er HTTP\/2 protocol support","Auth":"","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/http2.pro\/doc\/api","Category":"Developm' +
        'ent"},{"API":"Httpbin","Description":"A Simple HTTP Request & Re' +
        'sponse Service","Auth":"","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/httpbin.org\/","Category":"Development"},{"API":"Httpbin C' +
        'loudflare","Description":"A Simple HTTP Request & Response Servi' +
        'ce with HTTP\/3 Support by Cloudflare","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/cloudflare-quic.com\/b\/","Category' +
        '":"Development"},{"API":"Hunter","Description":"API for domain s' +
        'earch, professional email finder, author finder and email verifi' +
        'er","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/hunter.io\/api","Category":"Development"},{"API":"IBM Text t' +
        'o Speech","Description":"Convert text to speech","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/cloud.ibm.com\/docs' +
        '\/text-to-speech\/getting-started.html","Category":"Development"' +
        '},{"API":"Icanhazepoch","Description":"Get Epoch time","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/icanhazepoch.com","' +
        'Category":"Development"},{"API":"Icanhazip","Description":"IP Ad' +
        'dress API","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/major.io\/icanhazip-com-faq\/","Category":"Development"},{"API"' +
        ':"IFTTT","Description":"IFTTT Connect API","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/platform.ifttt.com\/docs\/c' +
        'onnect_api","Category":"Development"},{"API":"Image-Charts","Des' +
        'cription":"Generate charts, QR codes and graph images","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/documentation.image' +
        '-charts.com\/","Category":"Development"},{"API":"import.io","Des' +
        'cription":"Retrieve structured data from a website or RSS feed",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http:\/\/a' +
        'pi.docs.import.io\/","Category":"Development"},{"API":"ip-fast.c' +
        'om","Description":"IP address, country and city","Auth":"","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/ip-fast.com\/docs\/","Cat' +
        'egory":"Development"},{"API":"IP2WHOIS Information Lookup","Desc' +
        'ription":"WHOIS domain name lookup","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/www.ip2whois.com\/","Categor' +
        'y":"Development"},{"API":"ipfind.io","Description":"Geographic l' +
        'ocation of an IP address or any domain name along with some othe' +
        'r useful information","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/ipfind.io","Category":"Development"},{"API":"I' +
        'Pify","Description":"A simple IP Address API","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.ipify.org\/","Catego' +
        'ry":"Development"},{"API":"IPinfo","Description":"Another simple' +
        ' IP Address API","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/ipinfo.io\/developers","Category":"Development"},{"AP' +
        'I":"jsDelivr","Description":"Package info and download stats on ' +
        'jsDelivr CDN","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/github.com\/jsdelivr\/data.jsdelivr.com","Category":"Develop' +
        'ment"},{"API":"JSON 2 JSONP","Description":"Convert JSON to JSON' +
        'P (on-the-fly) for easy cross-domain data requests using client-' +
        'side JavaScript","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/json2jsonp.com\/","Category":"Development"},{"API":"J' +
        'SONbin.io","Description":"Free JSON storage service. Ideal for s' +
        'mall scale Web apps, Websites and Mobile apps","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/jsonbin.io","Category' +
        '":"Development"},{"API":"Kroki","Description":"Creates diagrams ' +
        'from textual descriptions","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/kroki.io","Category":"Development"},{"API":"Lic' +
        'ense-API","Description":"Unofficial REST API for choosealicense.' +
        'com","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/github' +
        '.com\/cmccandless\/license-api\/blob\/master\/README.md","Catego' +
        'ry":"Development"},{"API":"Logs.to","Description":"Generate logs' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/logs.to\/","Category":"Development"},{"API":"Lua Decompiler","' +
        'Description":"Online Lua 5.1 Decompiler","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/lua-decompiler.ferib.dev\/","Cate' +
        'gory":"Development"},{"API":"MAC address vendor lookup","Descrip' +
        'tion":"Retrieve vendor details and other information regarding a' +
        ' given MAC address or an OUI","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/macaddress.io\/api","Category":"Develo' +
        'pment"},{"API":"Micro DB","Description":"Simple database service' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/m3o.com\/db","Category":"Development"},{"API":"MicroENV","Desc' +
        'ription":"Fake Rest API for developers","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/microenv.com\/","Category":"De' +
        'velopment"},{"API":"Mocky","Description":"Mock user defined test' +
        ' JSON for REST API endpoints","Auth":"","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/designer.mocky.io\/","Category":"Development' +
        '"},{"API":"MY IP","Description":"Get IP address information","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.myip.' +
        'com\/api-docs\/","Category":"Development"},{"API":"Nationalize.i' +
        'o","Description":"Estimate the nationality of a first name","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/nationalize.io' +
        '","Category":"Development"},{"API":"Netlify","Description":"Netl' +
        'ify is a hosting service for the programmable web","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.netlify.c' +
        'om\/api\/get-started\/","Category":"Development"},{"API":"Networ' +
        'kCalc","Description":"Network calculators, including subnets, DN' +
        'S, binary, and security tools","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/networkcalc.com\/api\/docs","Category":"Dev' +
        'elopment"},{"API":"npm Registry","Description":"Query informatio' +
        'n about your favorite Node.js libraries programatically","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/n' +
        'pm\/registry\/blob\/master\/docs\/REGISTRY-API.md","Category":"D' +
        'evelopment"},{"API":"OneSignal","Description":"Self-serve custom' +
        'er engagement solution for Push Notifications, Email, SMS & In-A' +
        'pp","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/documentation.onesignal.com\/docs\/onesignal-api","Category"' +
        ':"Development"},{"API":"Open Page Rank","Description":"API for c' +
        'alculating and comparing metrics of different websites using Pag' +
        'e Rank algorithm","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/www.domcop.com\/openpagerank\/","Category":"De' +
        'velopment"},{"API":"OpenAPIHub","Description":"The All-in-one AP' +
        'I Platform","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/hub.openapihub.com\/","Category":"Development' +
        '"},{"API":"OpenGraphr","Description":"Really simple API to retri' +
        'eve Open Graph data from an URL","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/opengraphr.com\/docs\/1.0\/over' +
        'view","Category":"Development"},{"API":"oyyi","Description":"API' +
        ' for Fake Data, image\/video conversion, optimization, pdf optim' +
        'ization and thumbnail generation","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/oyyi.xyz\/docs\/1.0","Category":"Develop' +
        'ment"},{"API":"PageCDN","Description":"Public API for javascript' +
        ', css and font libraries on PageCDN","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/pagecdn.com\/docs\/public-api",' +
        '"Category":"Development"},{"API":"Postman","Description":"Tool f' +
        'or testing APIs","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.postman.com\/postman\/workspace\/postman-pu' +
        'blic-workspace\/documentation\/12959542-c8142d51-e97c-46b6-bd77-' +
        '52bb66712c9a","Category":"Development"},{"API":"ProxyCrawl","Des' +
        'cription":"Scraping and crawling anticaptcha service","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/proxycrawl' +
        '.com","Category":"Development"},{"API":"ProxyKingdom","Descripti' +
        'on":"Rotating Proxy API that produces a working proxy on every r' +
        'equest","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/proxykingdom.com","Category":"Development"},{"API":"Pusher B' +
        'eams","Description":"Push notifications for Android & iOS","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pushe' +
        'r.com\/beams","Category":"Development"},{"API":"QR code","Descri' +
        'ption":"Create an easy to read QR code and URL shortener","Auth"' +
        ':"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.qrtag.net\/a' +
        'pi\/","Category":"Development"},{"API":"QR code","Description":"' +
        'Generate and decode \/ read QR code graphics","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"http:\/\/goqr.me\/api\/","Category' +
        '":"Development"},{"API":"Qrcode Monkey","Description":"Integrate' +
        ' custom and unique looking QR codes into your system or workflow' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.' +
        'qrcode-monkey.com\/qr-code-api-with-logo\/","Category":"Developm' +
        'ent"},{"API":"QuickChart","Description":"Generate chart and grap' +
        'h images","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'quickchart.io\/","Category":"Development"},{"API":"Random Stuff"' +
        ',"Description":"Can be used to get AI Response, jokes, memes, an' +
        'd much more at lightning-fast speed","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/api-docs.pgamerx.com\/","Catego' +
        'ry":"Development"},{"API":"Rejax","Description":"Reverse AJAX se' +
        'rvice to notify clients","Auth":"apiKey","HTTPS":true,"Cors":"no' +
        '","Link":"https:\/\/rejax.io\/","Category":"Development"},{"API"' +
        ':"ReqRes","Description":"A hosted REST-API ready to respond to y' +
        'our AJAX requests","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/reqres.in\/ ","Category":"Development"},{"API":"RSS' +
        ' feed to JSON","Description":"Returns RSS feed in JSON format us' +
        'ing feed URL","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/rss-to-json-serverless-api.vercel.app","Category":"Developme' +
        'nt"},{"API":"SavePage.io","Description":"A free, RESTful API use' +
        'd to screenshot any desktop, or mobile website","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/www.savepage.io","Ca' +
        'tegory":"Development"},{"API":"ScrapeNinja","Description":"Scrap' +
        'ing API with Chrome fingerprint and residential proxies","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/scrapen' +
        'inja.net","Category":"Development"},{"API":"ScraperApi","Descrip' +
        'tion":"Easily build scalable web scrapers","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/www.scraperapi.com","' +
        'Category":"Development"},{"API":"scraperBox","Description":"Unde' +
        'tectable web scraping API","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/scraperbox.com\/","Category":"Development' +
        '"},{"API":"scrapestack","Description":"Real-time, Scalable Proxy' +
        ' & Web Scraping REST API","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/scrapestack.com\/","Category":"Develop' +
        'ment"},{"API":"ScrapingAnt","Description":"Headless Chrome scrap' +
        'ing with a simple API","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/scrapingant.com","Category":"Development"' +
        '},{"API":"ScrapingDog","Description":"Proxy API for Web scraping' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/www.scrapingdog.com\/","Category":"Development"},{"API":"Scree' +
        'nshotAPI.net","Description":"Create pixel-perfect website screen' +
        'shots","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/screenshotapi.net\/","Category":"Development"},{"API":"Serial' +
        'if Color","Description":"Color conversion, complementary, graysc' +
        'ale and contrasted text","Auth":"","HTTPS":true,"Cors":"no","Lin' +
        'k":"https:\/\/color.serialif.com\/","Category":"Development"},{"' +
        'API":"serpstack","Description":"Real-Time & Accurate Google Sear' +
        'ch Results API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/serpstack.com\/","Category":"Development"},{"API":"S' +
        'heetsu","Description":"Easy google sheets integration","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/sheetsu.c' +
        'om\/","Category":"Development"},{"API":"SHOUTCLOUD","Description' +
        '":"ALL-CAPS AS A SERVICE","Auth":"","HTTPS":false,"Cors":"unknow' +
        'n","Link":"http:\/\/shoutcloud.io\/","Category":"Development"},{' +
        '"API":"Sonar","Description":"Project Sonar DNS Enumeration API",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com' +
        '\/Cgboal\/SonarSearch","Category":"Development"},{"API":"SonarQu' +
        'be","Description":"SonarQube REST APIs to detect bugs, code smel' +
        'ls & security vulnerabilities","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/sonarcloud.io\/web_api","Category"' +
        ':"Development"},{"API":"StackExchange","Description":"Q&A forum ' +
        'for developers","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/api.stackexchange.com\/","Category":"Development"' +
        '},{"API":"Statically","Description":"A free CDN for developers",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/statically' +
        '.io\/","Category":"Development"},{"API":"Supportivekoala","Descr' +
        'iption":"Autogenerate images with template","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/developers.supportivekoa' +
        'la.com\/","Category":"Development"},{"API":"Tyk","Description":"' +
        'Api and service management platform","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/tyk.io\/open-source\/","Categor' +
        'y":"Development"},{"API":"Wandbox","Description":"Code compiler ' +
        'supporting 35+ languages mentioned at wandbox.org","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/melpon\' +
        '/wandbox\/blob\/master\/kennel2\/API.rst","Category":"Developmen' +
        't"},{"API":"WebScraping.AI","Description":"Web Scraping API with' +
        ' built-in proxies and JS rendering","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/webscraping.ai\/","Category":"De' +
        'velopment"},{"API":"ZenRows","Description":"Web Scraping API tha' +
        't bypasses anti-bot solutions while offering JS rendering, and r' +
        'otating proxies","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.zenrows.com\/","Category":"Development"},{"' +
        'API":"Chinese Character Web","Description":"Chinese character de' +
        'finitions and pronunciations","Auth":"","HTTPS":false,"Cors":"no' +
        '","Link":"http:\/\/ccdb.hemiola.com\/","Category":"Dictionaries"' +
        '},{"API":"Chinese Text Project","Description":"Online open-acces' +
        's digital library for pre-modern Chinese texts","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/ctext.org\/tools\/api"' +
        ',"Category":"Dictionaries"},{"API":"Collins","Description":"Bili' +
        'ngual Dictionary and Thesaurus Data","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/api.collinsdictionary.com\/' +
        'api\/v1\/documentation\/html\/","Category":"Dictionaries"},{"API' +
        '":"Free Dictionary","Description":"Definitions, phonetics, prono' +
        'unciations, parts of speech, examples, synonyms","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/dictionaryapi.dev\/",' +
        '"Category":"Dictionaries"},{"API":"Indonesia Dictionary","Descri' +
        'ption":"Indonesia dictionary many words","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/new-kbbi-api.herokuapp.com\/"' +
        ',"Category":"Dictionaries"},{"API":"Lingua Robot","Description":' +
        '"Word definitions, pronunciations, synonyms, antonyms and others' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/ww' +
        'w.linguarobot.io","Category":"Dictionaries"},{"API":"Merriam-Web' +
        'ster","Description":"Dictionary and Thesaurus Data","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dictionaryap' +
        'i.com\/","Category":"Dictionaries"},{"API":"OwlBot","Description' +
        '":"Definitions with example sentence and photo if available","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/owlbot.' +
        'info\/","Category":"Dictionaries"},{"API":"Oxford","Description"' +
        ':"Dictionary Data","Auth":"apiKey","HTTPS":true,"Cors":"no","Lin' +
        'k":"https:\/\/developer.oxforddictionaries.com\/","Category":"Di' +
        'ctionaries"},{"API":"Synonyms","Description":"Synonyms, thesauru' +
        's and antonyms information for any given word","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.synonyms.com\' +
        '/synonyms_api.php","Category":"Dictionaries"},{"API":"Wiktionary' +
        '","Description":"Collaborative dictionary data","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/en.wiktionary.org\/w\/api.' +
        'php","Category":"Dictionaries"},{"API":"Wordnik","Description":"' +
        'Dictionary Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developer.wordnik.com","Category":"Dictionaries' +
        '"},{"API":"Words","Description":"Definitions and synonyms for mo' +
        're than 150,000 words","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/www.wordsapi.com\/docs\/","Category":"Dic' +
        'tionaries"},{"API":"Airtable","Description":"Integrate with Airt' +
        'able","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/airtable.com\/api","Category":"Documents & Productivity"},' +
        '{"API":"Api2Convert","Description":"Online File Conversion API",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'www.api2convert.com\/","Category":"Documents & Productivity"},{"' +
        'API":"apilayer pdflayer","Description":"HTML\/URL to PDF","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pdflay' +
        'er.com","Category":"Documents & Productivity"},{"API":"Asana","D' +
        'escription":"Programmatic access to all data in your asana syste' +
        'm","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/d' +
        'evelopers.asana.com\/docs","Category":"Documents & Productivity"' +
        '},{"API":"ClickUp","Description":"ClickUp is a robust, cloud-bas' +
        'ed project management tool for boosting productivity","Auth":"OA' +
        'uth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/clickup.com' +
        '\/api","Category":"Documents & Productivity"},{"API":"Clockify",' +
        '"Description":"Clockify'#39's REST-based API can be used to push\/pu' +
        'll data to\/from it & integrate it with other systems","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/clockify.' +
        'me\/developers-api ","Category":"Documents & Productivity"},{"AP' +
        'I":"CloudConvert","Description":"Online file converter for audio' +
        ', video, document, ebook, archive, image, spreadsheet, presentat' +
        'ion","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/cloudconvert.com\/api\/v2","Category":"Documents & Producti' +
        'vity"},{"API":"Cloudmersive Document and Data Conversion","Descr' +
        'iption":"HTML\/URL to PDF\/PNG, Office documents to PDF, image c' +
        'onversion","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/cloudmersive.com\/convert-api","Category":"Documents & Pr' +
        'oductivity"},{"API":"Code::Stats","Description":"Automatic time ' +
        'tracking for programmers","Auth":"apiKey","HTTPS":true,"Cors":"n' +
        'o","Link":"https:\/\/codestats.net\/api-docs","Category":"Docume' +
        'nts & Productivity"},{"API":"CraftMyPDF","Description":"Generate' +
        ' PDF documents from templates with a drop-and-drop editor and a ' +
        'simple API","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"htt' +
        'ps:\/\/craftmypdf.com","Category":"Documents & Productivity"},{"' +
        'API":"Flowdash","Description":"Automate business workflows","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs' +
        '.flowdash.com\/docs\/api-introduction","Category":"Documents & P' +
        'roductivity"},{"API":"Html2PDF","Description":"HTML\/URL to PDF"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/html2pdf.app\/","Category":"Documents & Productivity"},{"API":"' +
        'iLovePDF","Description":"Convert, merge, split, extract text and' +
        ' add page numbers for PDFs. Free for 250 documents\/month","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/developer' +
        '.ilovepdf.com\/","Category":"Documents & Productivity"},{"API":"' +
        'JIRA","Description":"JIRA is a proprietary issue tracking produc' +
        't that allows bug tracking and agile project management","Auth":' +
        '"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/develope' +
        'r.atlassian.com\/server\/jira\/platform\/rest-apis\/","Category"' +
        ':"Documents & Productivity"},{"API":"Mattermost","Description":"' +
        'An open source platform for developer collaboration","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.mattermo' +
        'st.com\/","Category":"Documents & Productivity"},{"API":"Mercury' +
        '","Description":"Web parser","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/mercury.postlight.com\/web-parser\/' +
        '","Category":"Documents & Productivity"},{"API":"Monday","Descri' +
        'ption":"Programmatically access and update data inside a monday.' +
        'com account","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/api.developer.monday.com\/docs","Category":"Documen' +
        'ts & Productivity"},{"API":"Notion","Description":"Integrate wit' +
        'h Notion","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/developers.notion.com\/docs\/getting-started","Category' +
        '":"Documents & Productivity"},{"API":"PandaDoc","Description":"D' +
        'ocGen and eSignatures API","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'no","Link":"https:\/\/developers.pandadoc.com","Category":"Docum' +
        'ents & Productivity"},{"API":"Pocket","Description":"Bookmarking' +
        ' service","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/getpocket.com\/developer\/","Category":"Documents & Pro' +
        'ductivity"},{"API":"Podio","Description":"File sharing and produ' +
        'ctivity","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developers.podio.com","Category":"Documents & Productivi' +
        'ty"},{"API":"PrexView","Description":"Data from XML or JSON to P' +
        'DF, HTML or Image","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/prexview.com","Category":"Documents & Product' +
        'ivity"},{"API":"Restpack","Description":"Provides screenshot, HT' +
        'ML to PDF and content extraction APIs","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/restpack.io\/","Category"' +
        ':"Documents & Productivity"},{"API":"Todoist","Description":"Tod' +
        'o Lists","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developer.todoist.com","Category":"Documents & Productiv' +
        'ity"},{"API":"Smart Image Enhancement API","Description":"Perfor' +
        'ms image upscaling by adding detail to images through multiple s' +
        'uper-resolution algorithms","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/apilayer.com\/marketplace\/image_enh' +
        'ancement-api","Category":"Documents & Productivity"},{"API":"Vec' +
        'tor Express v2.0","Description":"Free vector file converting API' +
        '","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/vector.ex' +
        'press","Category":"Documents & Productivity"},{"API":"WakaTime",' +
        '"Description":"Automated time tracking leaderboards for programm' +
        'ers","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/w' +
        'akatime.com\/developers","Category":"Documents & Productivity"},' +
        '{"API":"Zube","Description":"Full stack project management","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/zube.' +
        'io\/docs\/api","Category":"Documents & Productivity"},{"API":"Ab' +
        'stract Email Validation","Description":"Validate email addresses' +
        ' for deliverability and spam","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.abstractapi.com\/email-verificatio' +
        'n-validation-api","Category":"Email"},{"API":"apilayer mailboxla' +
        'yer","Description":"Email address validation","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/mailboxlayer.com",' +
        '"Category":"Email"},{"API":"Cloudmersive Validate","Description"' +
        ':"Validate email addresses, phone numbers, VAT numbers and domai' +
        'n names","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/cloudmersive.com\/validate-api","Category":"Email"},{"API":' +
        '"Disify","Description":"Validate and detect disposable and tempo' +
        'rary email addresses","Auth":"","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/www.disify.com\/","Category":"Email"},{"API":"DropMa' +
        'il","Description":"GraphQL API for creating and managing ephemer' +
        'al e-mail inboxes","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/dropmail.me\/api\/#live-demo","Category":"Email"},{' +
        '"API":"EVA","Description":"Validate email addresses","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/eva.pingutil.com\/","' +
        'Category":"Email"},{"API":"Guerrilla Mail","Description":"Dispos' +
        'able temporary Email addresses","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/www.guerrillamail.com\/GuerrillaMailAP' +
        'I.html","Category":"Email"},{"API":"ImprovMX","Description":"API' +
        ' for free email forwarding service","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/improvmx.com\/api","Category' +
        '":"Email"},{"API":"Kickbox","Description":"Email verification AP' +
        'I","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/open.ki' +
        'ckbox.com\/","Category":"Email"},{"API":"mail.gw","Description":' +
        '"10 Minute Mail","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/docs.mail.gw","Category":"Email"},{"API":"mail.tm","Descr' +
        'iption":"Temporary Email Service","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/docs.mail.tm","Category":"Email"},{"API"' +
        ':"MailboxValidator","Description":"Validate email address to imp' +
        'rove deliverability","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.mailboxvalidator.com\/api-email-free","' +
        'Category":"Email"},{"API":"MailCheck.ai","Description":"Prevent ' +
        'users to sign up with temporary email addresses","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/www.mailcheck.ai\/#do' +
        'cumentation","Category":"Email"},{"API":"Mailtrap","Description"' +
        ':"A service for the safe testing of emails sent from the develop' +
        'ment and staging environments","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/mailtrap.docs.apiary.io\/#","Cate' +
        'gory":"Email"},{"API":"Sendgrid","Description":"A cloud-based SM' +
        'TP provider that allows you to send emails without having to mai' +
        'ntain email servers","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/docs.sendgrid.com\/api-reference\/","Catego' +
        'ry":"Email"},{"API":"Sendinblue","Description":"A service that p' +
        'rovides solutions relating to marketing and\/or transactional em' +
        'ail and\/or SMS","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developers.sendinblue.com\/docs","Category":"Em' +
        'ail"},{"API":"Verifier","Description":"Verifies that a given ema' +
        'il is real","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/verifier.meetchopra.com\/docs#\/","Category":"Email"},{"' +
        'API":"chucknorris.io","Description":"JSON API for hand curated C' +
        'huck Norris jokes","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/api.chucknorris.io","Category":"Entertainment"},{"A' +
        'PI":"Corporate Buzz Words","Description":"REST API for Corporate' +
        ' Buzz Words","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/github.com\/sameerkumar18\/corporate-bs-generator-api","Categ' +
        'ory":"Entertainment"},{"API":"Excuser","Description":"Get random' +
        ' excuses for various situations","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/excuser.herokuapp.com\/","Category":"' +
        'Entertainment"},{"API":"Fun Fact","Description":"A simple HTTPS ' +
        'api that can randomly select and return a fact from the FFA data' +
        'base","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.' +
        'aakhilv.me","Category":"Entertainment"},{"API":"Imgflip","Descri' +
        'ption":"Gets an array of popular memes","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/imgflip.com\/api","Category":"' +
        'Entertainment"},{"API":"Meme Maker","Description":"REST API for ' +
        'create your own meme","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/mememaker.github.io\/API\/","Category":"Entertai' +
        'nment"},{"API":"NaMoMemes","Description":"Memes on Narendra Modi' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gith' +
        'ub.com\/theIYD\/NaMoMemes","Category":"Entertainment"},{"API":"R' +
        'andom Useless Facts","Description":"Get useless, but true facts"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/usele' +
        'ssfacts.jsph.pl\/","Category":"Entertainment"},{"API":"Techy","D' +
        'escription":"JSON and Plaintext API for tech-savvy sounding phra' +
        'ses","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/t' +
        'echy-api.vercel.app\/","Category":"Entertainment"},{"API":"Yo Mo' +
        'mma Jokes","Description":"REST API for Yo Momma Jokes","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/bea' +
        'nboi7\/yomomma-apiv2","Category":"Entertainment"},{"API":"Breezo' +
        'Meter Pollen","Description":"Daily Forecast pollen conditions da' +
        'ta for a specific location","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/docs.breezometer.com\/api-documentat' +
        'ion\/pollen-api\/v2\/","Category":"Environment"},{"API":"Carbon ' +
        'Interface","Description":"API to calculate carbon (C02) emission' +
        's estimates for common C02 emitting activities","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.carboninterface' +
        '.com\/","Category":"Environment"},{"API":"Climatiq","Description' +
        '":"Calculate the environmental footprint created by a broad rang' +
        'e of emission-generating activities","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/docs.climatiq.io","Category":"E' +
        'nvironment"},{"API":"Cloverly","Description":"API calculates the' +
        ' impact of common carbon-intensive activities in real time","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.' +
        'cloverly.com\/carbon-offset-documentation","Category":"Environme' +
        'nt"},{"API":"CO2 Offset","Description":"API calculates and valid' +
        'ates the carbon footprint","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/co2offset.io\/api.html","Category":"Environ' +
        'ment"},{"API":"Danish data service Energi","Description":"Open e' +
        'nergy data from Energinet to society","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.energidataservice.dk\/","Cat' +
        'egory":"Environment"},{"API":"Gr'#195#188'nstromIndex","Description":"Gr' +
        'een Power Index for Germany (Gr'#195#188'nstromindex\/GSI)","Auth":"","H' +
        'TTPS":false,"Cors":"yes","Link":"https:\/\/gruenstromindex.de\/"' +
        ',"Category":"Environment"},{"API":"IQAir","Description":"Air qua' +
        'lity and weather data","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/www.iqair.com\/air-pollution-data-api","C' +
        'ategory":"Environment"},{"API":"Luchtmeetnet","Description":"Pre' +
        'dicted and actual air quality components for The Netherlands (RI' +
        'VM)","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/a' +
        'pi-docs.luchtmeetnet.nl\/","Category":"Environment"},{"API":"Nat' +
        'ional Grid ESO","Description":"Open data from Great Britain'#226#8364#8482's ' +
        'Electricity System Operator","Auth":"","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/data.nationalgrideso.com\/","Category":"E' +
        'nvironment"},{"API":"OpenAQ","Description":"Open air quality dat' +
        'a","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/docs.openaq.org\/","Category":"Environment"},{"API":"PM2.5 Op' +
        'en Data Portal","Description":"Open low-cost PM2.5 sensor data",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pm25.l' +
        'ass-net.org\/#apis","Category":"Environment"},{"API":"PM25.in","' +
        'Description":"Air quality of China","Auth":"apiKey","HTTPS":fals' +
        'e,"Cors":"unknown","Link":"http:\/\/www.pm25.in\/api_doc","Categ' +
        'ory":"Environment"},{"API":"PVWatts","Description":"Energy produ' +
        'ction photovoltaic (PV) energy systems","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/developer.nrel.gov\/docs' +
        '\/solar\/pvwatts\/v6\/","Category":"Environment"},{"API":"Srp En' +
        'ergy","Description":"Hourly usage energy report for Srp customer' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/sr' +
        'penergy-api-client-python.readthedocs.io\/en\/latest\/api.html",' +
        '"Category":"Environment"},{"API":"UK Carbon Intensity","Descript' +
        'ion":"The Official Carbon Intensity API for Great Britain develo' +
        'ped by National Grid","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/carbon-intensity.github.io\/api-definitions\/#ca' +
        'rbon-intensity-api-v1-0-0","Category":"Environment"},{"API":"Web' +
        'site Carbon","Description":"API to estimate the carbon footprint' +
        ' of loading web pages","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/api.websitecarbon.com\/","Category":"Environmen' +
        't"},{"API":"Eventbrite","Description":"Find events","Auth":"OAut' +
        'h","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.eventbrit' +
        'e.com\/platform\/api\/","Category":"Events"},{"API":"SeatGeek","' +
        'Description":"Search events, venues and performers","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/platform.sea' +
        'tgeek.com\/","Category":"Events"},{"API":"Ticketmaster","Descrip' +
        'tion":"Search events, attractions, or venues","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"http:\/\/developer.ticketmas' +
        'ter.com\/products-and-docs\/apis\/getting-started\/","Category":' +
        '"Events"},{"API":"Abstract VAT Validation","Description":"Valida' +
        'te VAT numbers and calculate VAT rates","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/www.abstractapi.com\/vat-val' +
        'idation-rates-api","Category":"Finance"},{"API":"Aletheia","Desc' +
        'ription":"Insider trading data, earnings call analysis, financia' +
        'l statements, and more","Auth":"apiKey","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/aletheiaapi.com\/","Category":"Finance"},{"A' +
        'PI":"Alpaca","Description":"Realtime and historical market data ' +
        'on all US equities and ETFs","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/alpaca.markets\/docs\/api-documentation' +
        '\/api-v2\/market-data\/alpaca-data-api-v2\/","Category":"Finance' +
        '"},{"API":"Alpha Vantage","Description":"Realtime and historical' +
        ' stock data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/www.alphavantage.co\/","Category":"Finance"},{"API"' +
        ':"apilayer marketstack","Description":"Real-Time, Intraday & His' +
        'torical Market Data API","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/marketstack.com\/","Category":"Finance"' +
        '},{"API":"Banco do Brasil","Description":"All Banco do Brasil fi' +
        'nancial transaction APIs","Auth":"OAuth","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/developers.bb.com.br\/home","Category":"Fin' +
        'ance"},{"API":"Bank Data API","Description":"Instant IBAN and SW' +
        'IFT number validation across the globe","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/apilayer.com\/marketplac' +
        'e\/bank_data-api","Category":"Finance"},{"API":"Billplz","Descri' +
        'ption":"Payment platform","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/www.billplz.com\/api","Category":"Fina' +
        'nce"},{"API":"Binlist","Description":"Public access to a databas' +
        'e of IIN\/BIN information","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/binlist.net\/","Category":"Finance"},{"API"' +
        ':"Boleto.Cloud","Description":"A api to generate boletos in Braz' +
        'il","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/boleto.cloud\/","Category":"Finance"},{"API":"Citi","Descrip' +
        'tion":"All Citigroup account and statement data APIs","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/sandbox.de' +
        'veloperhub.citi.com\/api-catalog-list","Category":"Finance"},{"A' +
        'PI":"Econdb","Description":"Global macroeconomic data","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/www.econdb.com\/api' +
        '\/","Category":"Finance"},{"API":"Fed Treasury","Description":"U' +
        '.S. Department of the Treasury Data","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/fiscaldata.treasury.gov\/api-docu' +
        'mentation\/","Category":"Finance"},{"API":"Finage","Description"' +
        ':"Finage is a stock, currency, cryptocurrency, indices, and ETFs' +
        ' real-time & historical data provider","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/finage.co.uk","Category":' +
        '"Finance"},{"API":"Financial Modeling Prep","Description":"Realt' +
        'ime and historical stock data","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/site.financialmodelingprep.com\/d' +
        'eveloper\/docs","Category":"Finance"},{"API":"Finnhub","Descript' +
        'ion":"Real-Time RESTful APIs and Websocket for Stocks, Currencie' +
        's, and Crypto","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/finnhub.io\/docs\/api","Category":"Finance"},{"AP' +
        'I":"FRED","Description":"Economic data from the Federal Reserve ' +
        'Bank of St. Louis","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/fred.stlouisfed.org\/docs\/api\/fred\/","Category' +
        '":"Finance"},{"API":"Front Accounting APIs","Description":"Front' +
        ' accounting is multilingual and multicurrency software for small' +
        ' businesses","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/frontaccounting.com\/fawiki\/index.php?n=Devel.SimpleAPI' +
        'Module","Category":"Finance"},{"API":"Hotstoks","Description":"S' +
        'tock market data powered by SQL","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/hotstoks.com?utm_source=public-apis' +
        '","Category":"Finance"},{"API":"IEX Cloud","Description":"Realti' +
        'me & Historical Stock and Market Data","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/iexcloud.io\/docs\/api\/","Ca' +
        'tegory":"Finance"},{"API":"IG","Description":"Spreadbetting and ' +
        'CFD Market Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/labs.ig.com\/gettingstarted","Category":"Financ' +
        'e"},{"API":"Indian Mutual Fund","Description":"Get complete hist' +
        'ory of India Mutual Funds Data","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/www.mfapi.in\/","Category":"Finance"},' +
        '{"API":"Intrinio","Description":"A wide selection of financial d' +
        'ata feeds","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/intrinio.com\/","Category":"Finance"},{"API":"Klarna"' +
        ',"Description":"Klarna payment and shopping service","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.klarna' +
        '.com\/klarna-payments\/api\/payments-api\/","Category":"Finance"' +
        '},{"API":"MercadoPago","Description":"Mercado Pago API reference' +
        ' - all the information you need to develop your integrations","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ww' +
        'w.mercadopago.com.br\/developers\/es\/reference","Category":"Fin' +
        'ance"},{"API":"Mono","Description":"Connect with users'#226#8364#8482' bank a' +
        'ccounts and access transaction data in Africa","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/mono.co\/","Categ' +
        'ory":"Finance"},{"API":"Moov","Description":"The Moov API makes ' +
        'it simple for platforms to send, receive, and store money","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.' +
        'moov.io\/api\/","Category":"Finance"},{"API":"Nordigen","Descrip' +
        'tion":"Connect to bank accounts using official bank APIs and get' +
        ' raw transaction data","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/nordigen.com\/en\/account_information_doc' +
        'umenation\/integration\/quickstart_guide\/","Category":"Finance"' +
        '},{"API":"OpenFIGI","Description":"Equity, index, futures, optio' +
        'ns symbology from Bloomberg LP","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/www.openfigi.com\/api","Category":"F' +
        'inance"},{"API":"Plaid","Description":"Connect with user'#39's bank ' +
        'accounts and access transaction data","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/plaid.com\/","Category":"F' +
        'inance"},{"API":"Polygon","Description":"Historical stock market' +
        ' data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/polygon.io\/","Category":"Finance"},{"API":"Portfolio Opt' +
        'imizer","Description":"Portfolio analysis and optimization","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/portfoliooptim' +
        'izer.io\/","Category":"Finance"},{"API":"Razorpay IFSC","Descrip' +
        'tion":"Indian Financial Systems Code (Bank Branch Codes)","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/razorpay.com' +
        '\/docs\/","Category":"Finance"},{"API":"Real Time Finance","Desc' +
        'ription":"Websocket API to access realtime stock data","Auth":"a' +
        'piKey","HTTPS":false,"Cors":"unknown","Link":"https:\/\/github.c' +
        'om\/Real-time-finance\/finance-websocket-API\/","Category":"Fina' +
        'nce"},{"API":"SEC EDGAR Data","Description":"API to access annua' +
        'l reports of public US companies","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/www.sec.gov\/edgar\/sec-api-documentatio' +
        'n","Category":"Finance"},{"API":"SmartAPI","Description":"Gain a' +
        'ccess to set of <SmartAPI> and create end-to-end broking service' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/smartapi.angelbroking.com\/","Category":"Finance"},{"API":"St' +
        'ockData","Description":"Real-Time, Intraday & Historical Market ' +
        'Data, News and Sentiment API","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.StockData.org","Category":"Finance' +
        '"},{"API":"Styvio","Description":"Realtime and historical stock ' +
        'data and current stock sentiment","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.Styvio.com","Category":"Fi' +
        'nance"},{"API":"Tax Data API","Description":"Instant VAT number ' +
        'and tax validation across the globe","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unkown","Link":"https:\/\/apilayer.com\/marketplace\/t' +
        'ax_data-api","Category":"Finance"},{"API":"Tradier","Description' +
        '":"US equity\/option market data (delayed, intraday, historical)' +
        '","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/dev' +
        'eloper.tradier.com","Category":"Finance"},{"API":"Twelve Data","' +
        'Description":"Stock market data (real-time & historical)","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/twelve' +
        'data.com\/","Category":"Finance"},{"API":"WallstreetBets","Descr' +
        'iption":"WallstreetBets Stock Comments Sentiment Analysis","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dashboard.n' +
        'bshare.io\/apps\/reddit\/api\/","Category":"Finance"},{"API":"Ya' +
        'hoo Finance","Description":"Real time low latency Yahoo Finance ' +
        'API for stock market, crypto currencies, and currency exchange",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.' +
        'yahoofinanceapi.com\/","Category":"Finance"},{"API":"YNAB","Desc' +
        'ription":"Budgeting & Planning","Auth":"OAuth","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/api.youneedabudget.com\/","Category":' +
        '"Finance"},{"API":"Zoho Books","Description":"Online accounting ' +
        'software, built for your business","Auth":"OAuth","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.zoho.com\/books\/api\/v3\/' +
        '","Category":"Finance"},{"API":"BaconMockup","Description":"Resi' +
        'zable bacon placeholder images","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/baconmockup.com\/","Category":"Food & Drin' +
        'k"},{"API":"Chomp","Description":"Data about various grocery pro' +
        'ducts and foods","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/chompthis.com\/api\/","Category":"Food & Drink"' +
        '},{"API":"Coffee","Description":"Random pictures of coffee","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/coffee.ale' +
        'xflipnote.dev\/","Category":"Food & Drink"},{"API":"Edamam nutri' +
        'tion","Description":"Nutrition Analysis","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/developer.edamam.com\/e' +
        'damam-docs-nutrition-api","Category":"Food & Drink"},{"API":"Eda' +
        'mam recipes","Description":"Recipe Search","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/developer.edamam.com\' +
        '/edamam-docs-recipe-api","Category":"Food & Drink"},{"API":"Food' +
        'ish","Description":"Random pictures of food dishes","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/surhud004\' +
        '/Foodish#readme","Category":"Food & Drink"},{"API":"Fruityvice",' +
        '"Description":"Data about all kinds of fruit","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.fruityvice.com","Cat' +
        'egory":"Food & Drink"},{"API":"Kroger","Description":"Supermarke' +
        't Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developer.kroger.com\/reference","Category":"Food & Drin' +
        'k"},{"API":"LCBO","Description":"Alcohol","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/lcboapi.com\/","Catego' +
        'ry":"Food & Drink"},{"API":"Open Brewery DB","Description":"Brew' +
        'eries, Cideries and Craft Beer Bottle Shops","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.openbrewerydb.org","Categ' +
        'ory":"Food & Drink"},{"API":"Open Food Facts","Description":"Foo' +
        'd Products Database","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/world.openfoodfacts.org\/data","Category":"Food &' +
        ' Drink"},{"API":"PunkAPI","Description":"Brewdog Beer Recipes","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/punkapi' +
        '.com\/","Category":"Food & Drink"},{"API":"Rustybeer","Descripti' +
        'on":"Beer brewing tools","Auth":"","HTTPS":true,"Cors":"no","Lin' +
        'k":"https:\/\/rustybeer.herokuapp.com\/","Category":"Food & Drin' +
        'k"},{"API":"Spoonacular","Description":"Recipes, Food Products, ' +
        'and Meal Planning","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/spoonacular.com\/food-api","Category":"Food &' +
        ' Drink"},{"API":"Systembolaget","Description":"Govornment owned ' +
        'liqour store in Sweden","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/api-portal.systembolaget.se","Category":' +
        '"Food & Drink"},{"API":"TacoFancy","Description":"Community-driv' +
        'en taco database","Auth":"","HTTPS":false,"Cors":"unknown","Link' +
        '":"https:\/\/github.com\/evz\/tacofancy-api","Category":"Food & ' +
        'Drink"},{"API":"Tasty","Description":"API to query data about re' +
        'cipe, plan, ingredients","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/rapidapi.com\/apidojo\/api\/tasty\/","C' +
        'ategory":"Food & Drink"},{"API":"The Report of the Week","Descri' +
        'ption":"Food & Drink Reviews","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/github.com\/andyklimczak\/TheReportOfThe' +
        'Week-API","Category":"Food & Drink"},{"API":"TheCocktailDB","Des' +
        'cription":"Cocktail Recipes","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/www.thecocktaildb.com\/api.php","Catego' +
        'ry":"Food & Drink"},{"API":"TheMealDB","Description":"Meal Recip' +
        'es","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'www.themealdb.com\/api.php","Category":"Food & Drink"},{"API":"U' +
        'ntappd","Description":"Social beer sharing","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/untappd.com\/api\/doc' +
        's","Category":"Food & Drink"},{"API":"What'#39's on the menu?","Desc' +
        'ription":"NYPL human-transcribed historical menu collection","Au' +
        'th":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http:\/\/nyp' +
        'l.github.io\/menus-api\/","Category":"Food & Drink"},{"API":"Whi' +
        'skyHunter","Description":"Past online whisky auctions statistica' +
        'l data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/whiskyhunter.net\/api\/","Category":"Food & Drink"},{"API":"Ze' +
        'stful","Description":"Parse recipe ingredients","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/zestfuldata.com\/","' +
        'Category":"Food & Drink"},{"API":"Age of Empires II","Descriptio' +
        'n":"Get information about Age of Empires II resources","Auth":""' +
        ',"HTTPS":true,"Cors":"no","Link":"https:\/\/age-of-empires-2-api' +
        '.herokuapp.com","Category":"Games & Comics"},{"API":"AmiiboAPI",' +
        '"Description":"Nintendo Amiibo Information","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/amiiboapi.com\/","Category":"G' +
        'ames & Comics"},{"API":"Animal Crossing: New Horizons","Descript' +
        'ion":"API for critters, fossils, art, music, furniture and villa' +
        'gers","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http:\/\/a' +
        'cnhapi.com\/","Category":"Games & Comics"},{"API":"Autochess VNG' +
        '","Description":"Rest Api for Autochess VNG","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/github.com\/didadadida93\/aut' +
        'ochess-vng-api","Category":"Games & Comics"},{"API":"Barter.VG",' +
        '"Description":"Provides information about Game, DLC, Bundles, Gi' +
        'veaways, Trading","Auth":"","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/github.com\/bartervg\/barter.vg\/wiki","Category":"Games' +
        ' & Comics"},{"API":"Battle.net","Description":"Diablo III, Heart' +
        'hstone, StarCraft II and World of Warcraft game data APIs","Auth' +
        '":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/develop.ba' +
        'ttle.net\/documentation\/guides\/getting-started","Category":"Ga' +
        'mes & Comics"},{"API":"Board Game Geek","Description":"Board gam' +
        'es, RPG and videogames","Auth":"","HTTPS":true,"Cors":"no","Link' +
        '":"https:\/\/boardgamegeek.com\/wiki\/page\/BGG_XML_API2","Categ' +
        'ory":"Games & Comics"},{"API":"Brawl Stars","Description":"Brawl' +
        ' Stars Game Information","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/developer.brawlstars.com","Category":"G' +
        'ames & Comics"},{"API":"Bugsnax","Description":"Get information ' +
        'about Bugsnax","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/www.bugsnaxapi.com\/","Category":"Games & Comics"},{"API":"' +
        'CheapShark","Description":"Steam\/PC Game Prices and Deals","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.cheapshark' +
        '.com\/api","Category":"Games & Comics"},{"API":"Chess.com","Desc' +
        'ription":"Chess.com read-only REST API","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.chess.com\/news\/view\/pub' +
        'lished-data-api","Category":"Games & Comics"},{"API":"Chuck Norr' +
        'is Database","Description":"Jokes","Auth":"","HTTPS":false,"Cors' +
        '":"unknown","Link":"http:\/\/www.icndb.com\/api\/","Category":"G' +
        'ames & Comics"},{"API":"Clash of Clans","Description":"Clash of ' +
        'Clans Game Information","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/developer.clashofclans.com","Category":"' +
        'Games & Comics"},{"API":"Clash Royale","Description":"Clash Roya' +
        'le Game Information","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/developer.clashroyale.com","Category":"Game' +
        's & Comics"},{"API":"Comic Vine","Description":"Comics","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/comicvine.game' +
        'spot.com\/api\/documentation","Category":"Games & Comics"},{"API' +
        '":"Crafatar","Description":"API for Minecraft skins and faces","' +
        'Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/crafatar.co' +
        'm","Category":"Games & Comics"},{"API":"Cross Universe","Descrip' +
        'tion":"Cross Universe Card Data","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/crossuniverse.psychpsyo.com\/apiDocs.html' +
        '","Category":"Games & Comics"},{"API":"Deck of Cards","Descripti' +
        'on":"Deck of Cards","Auth":"","HTTPS":false,"Cors":"unknown","Li' +
        'nk":"http:\/\/deckofcardsapi.com\/","Category":"Games & Comics"}' +
        ',{"API":"Destiny The Game","Description":"Bungie Platform API","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/b' +
        'ungie-net.github.io\/multi\/index.html","Category":"Games & Comi' +
        'cs"},{"API":"Digimon Information","Description":"Provides inform' +
        'ation about digimon creatures","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/digimon-api.vercel.app\/","Category":"G' +
        'ames & Comics"},{"API":"Digimon TCG","Description":"Search for D' +
        'igimon cards in digimoncard.io","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/documenter.getpostman.com\/view\/14059' +
        '948\/TzecB4fH","Category":"Games & Comics"},{"API":"Disney","Des' +
        'cription":"Information of Disney characters","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/disneyapi.dev","Category":"Ga' +
        'mes & Comics"},{"API":"Dota 2","Description":"Provides informati' +
        'on about Player stats , Match stats, Rankings for Dota 2","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.o' +
        'pendota.com\/","Category":"Games & Comics"},{"API":"Dungeons and' +
        ' Dragons","Description":"Reference for 5th edition spells, class' +
        'es, monsters, and more","Auth":"","HTTPS":false,"Cors":"no","Lin' +
        'k":"https:\/\/www.dnd5eapi.co\/docs\/","Category":"Games & Comic' +
        's"},{"API":"Dungeons and Dragons (Alternate)","Description":"Inc' +
        'ludes all monsters and spells from the SRD (System Reference Doc' +
        'ument) as well as a search API","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/open5e.com\/","Category":"Games & Comics"}' +
        ',{"API":"Eve Online","Description":"Third-Party Developer Docume' +
        'ntation","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/esi.evetech.net\/ui","Category":"Games & Comics"},{"API"' +
        ':"FFXIV Collect","Description":"Final Fantasy XIV data on collec' +
        'tables","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ff' +
        'xivcollect.com\/","Category":"Games & Comics"},{"API":"FIFA Ulti' +
        'mate Team","Description":"FIFA Ultimate Team items API","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.easports.c' +
        'om\/fifa\/ultimate-team\/api\/fut\/item","Category":"Games & Com' +
        'ics"},{"API":"Final Fantasy XIV","Description":"Final Fantasy XI' +
        'V Game data API","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/xivapi.com\/","Category":"Games & Comics"},{"API":"Fortni' +
        'te","Description":"Fortnite Stats","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/fortnitetracker.com\/site-api' +
        '","Category":"Games & Comics"},{"API":"Forza","Description":"Sho' +
        'w random image of car from Forza","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/docs.forza-api.tk","Category":"Games' +
        ' & Comics"},{"API":"FreeToGame","Description":"Free-To-Play Game' +
        's Database","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/www.freetogame.com\/api-doc","Category":"Games & Comics"},{"AP' +
        'I":"Fun Facts","Description":"Random Fun Facts","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/asli-fun-fact-api.herokuap' +
        'p.com\/","Category":"Games & Comics"},{"API":"FunTranslations","' +
        'Description":"Translate Text into funny languages","Auth":"","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/api.funtranslations.com' +
        '\/","Category":"Games & Comics"},{"API":"GamerPower","Descriptio' +
        'n":"Game Giveaways Tracker","Auth":"","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/www.gamerpower.com\/api-read","Category":"Game' +
        's & Comics"},{"API":"GDBrowser","Description":"Easy way to use t' +
        'he Geometry Dash Servers","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/gdbrowser.com\/api","Category":"Games & Comi' +
        'cs"},{"API":"Geek-Jokes","Description":"Fetch a random geeky\/pr' +
        'ogramming related joke for use in all sorts of applications","Au' +
        'th":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/s' +
        'ameerkumar18\/geek-joke-api","Category":"Games & Comics"},{"API"' +
        ':"Genshin Impact","Description":"Genshin Impact game data","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/genshin.dev","C' +
        'ategory":"Games & Comics"},{"API":"Giant Bomb","Description":"Vi' +
        'deo Games","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.giantbomb.com\/api\/documentation","Category":"Ga' +
        'mes & Comics"},{"API":"GraphQL Pokemon","Description":"GraphQL p' +
        'owered Pokemon API. Supports generations 1 through 8","Auth":"",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/favware\' +
        '/graphql-pokemon","Category":"Games & Comics"},{"API":"Guild War' +
        's 2","Description":"Guild Wars 2 Game Information","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/wiki.guildwar' +
        's2.com\/wiki\/API:Main","Category":"Games & Comics"},{"API":"GW2' +
        'Spidy","Description":"GW2Spidy API, Items data on the Guild Wars' +
        ' 2 Trade Market","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/github.com\/rubensayshi\/gw2spidy\/wiki","Category":"' +
        'Games & Comics"},{"API":"Halo","Description":"Halo 5 and Halo Wa' +
        'rs 2 Information","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/developer.haloapi.com\/","Category":"Games & C' +
        'omics"},{"API":"Hearthstone","Description":"Hearthstone Cards In' +
        'formation","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"unknown",' +
        '"Link":"http:\/\/hearthstoneapi.com\/","Category":"Games & Comic' +
        's"},{"API":"Humble Bundle","Description":"Humble Bundle'#39's curren' +
        't bundles","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/rapidapi.com\/Ziggoto\/api\/humble-bundle","Category"' +
        ':"Games & Comics"},{"API":"Humor","Description":"Humor, Jokes, a' +
        'nd Memes","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/humorapi.com","Category":"Games & Comics"},{"API":"Hyp' +
        'ixel","Description":"Hypixel player stats","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/api.hypixel.net\/","C' +
        'ategory":"Games & Comics"},{"API":"Hyrule Compendium","Descripti' +
        'on":"Data on all interactive items from The Legend of Zelda: BOT' +
        'W","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/git' +
        'hub.com\/gadhagod\/Hyrule-Compendium-API","Category":"Games & Co' +
        'mics"},{"API":"Hytale","Description":"Hytale blog posts and jobs' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/hyta' +
        'le-api.com\/","Category":"Games & Comics"},{"API":"IGDB.com","De' +
        'scription":"Video Game Database","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/api-docs.igdb.com","Category":"' +
        'Games & Comics"},{"API":"JokeAPI","Description":"Programming, Mi' +
        'scellaneous and Dark Jokes","Auth":"","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/sv443.net\/jokeapi\/v2\/","Category":"Games & ' +
        'Comics"},{"API":"Jokes One","Description":"Joke of the day and l' +
        'arge category of jokes accessible via REST API","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/jokes.one\/api\/joke' +
        '\/","Category":"Games & Comics"},{"API":"Jservice","Description"' +
        ':"Jeopardy Question Database","Auth":"","HTTPS":false,"Cors":"un' +
        'known","Link":"http:\/\/jservice.io","Category":"Games & Comics"' +
        '},{"API":"Lichess","Description":"Access to all data of users, g' +
        'ames, puzzles and etc on Lichess","Auth":"OAuth","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/lichess.org\/api","Category":"G' +
        'ames & Comics"},{"API":"Magic The Gathering","Description":"Magi' +
        'c The Gathering Game Information","Auth":"","HTTPS":false,"Cors"' +
        ':"unknown","Link":"http:\/\/magicthegathering.io\/","Category":"' +
        'Games & Comics"},{"API":"Mario Kart Tour","Description":"API for' +
        ' Drivers, Karts, Gliders and Courses","Auth":"OAuth","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/mario-kart-tour-api.herokua' +
        'pp.com\/","Category":"Games & Comics"},{"API":"Marvel","Descript' +
        'ion":"Marvel Comics","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/developer.marvel.com","Category":"Games & C' +
        'omics"},{"API":"Minecraft Server Status","Description":"API to g' +
        'et Information about a Minecraft Server","Auth":"","HTTPS":true,' +
        '"Cors":"no","Link":"https:\/\/api.mcsrvstat.us","Category":"Game' +
        's & Comics"},{"API":"MMO Games","Description":"MMO Games Databas' +
        'e, News and Giveaways","Auth":"","HTTPS":true,"Cors":"no","Link"' +
        ':"https:\/\/www.mmobomb.com\/api","Category":"Games & Comics"},{' +
        '"API":"mod.io","Description":"Cross Platform Mod API","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.mod.i' +
        'o","Category":"Games & Comics"},{"API":"Mojang","Description":"M' +
        'ojang \/ Minecraft API","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/wiki.vg\/Mojang_API","Category":"Games &' +
        ' Comics"},{"API":"Monster Hunter World","Description":"Monster H' +
        'unter World data","Auth":"","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/docs.mhw-db.com\/","Category":"Games & Comics"},{"API":"' +
        'Open Trivia","Description":"Trivia Questions","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/opentdb.com\/api_config.' +
        'php","Category":"Games & Comics"},{"API":"PandaScore","Descripti' +
        'on":"E-sports games and results","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/developers.pandascore.co\/","Ca' +
        'tegory":"Games & Comics"},{"API":"Path of Exile","Description":"' +
        'Path of Exile Game Information","Auth":"OAuth","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/www.pathofexile.com\/developer\/d' +
        'ocs","Category":"Games & Comics"},{"API":"PlayerDB","Description' +
        '":"Query Minecraft, Steam and XBox Accounts","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/playerdb.co\/","Category"' +
        ':"Games & Comics"},{"API":"Pok'#195#169'api","Description":"Pok'#195#169'mon Inf' +
        'ormation","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/pokeapi.co","Category":"Games & Comics"},{"API":"Pok'#195#169'API (G' +
        'raphQL)","Description":"The Unofficial GraphQL for PokeAPI","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/ma' +
        'zipan\/graphql-pokeapi","Category":"Games & Comics"},{"API":"Pok' +
        #195#169'mon TCG","Description":"Pok'#195#169'mon TCG Information","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/pokemontcg.io","Ca' +
        'tegory":"Games & Comics"},{"API":"Psychonauts","Description":"Ps' +
        'ychonauts World Characters Information and PSI Powers","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/psychonauts-api.net' +
        'lify.app\/","Category":"Games & Comics"},{"API":"PUBG","Descript' +
        'ion":"Access in-game PUBG data","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/developer.pubg.com\/","Category":"Ga' +
        'mes & Comics"},{"API":"Puyo Nexus","Description":"Puyo Puyo info' +
        'rmation from Puyo Nexus Wiki","Auth":"","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/github.com\/deltadex7\/puyodb-api-deno","Cat' +
        'egory":"Games & Comics"},{"API":"quizapi.io","Description":"Acce' +
        'ss to various kind of quiz questions","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/quizapi.io\/","Category":"Game' +
        's & Comics"},{"API":"Raider","Description":"Provides detailed ch' +
        'aracter and guild rankings for Raiding and Mythic+ content in Wo' +
        'rld of Warcraft","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/raider.io\/api","Category":"Games & Comics"},{"API":"' +
        'RAWG.io","Description":"500,000+ games for 50 platforms includin' +
        'g mobiles","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/rawg.io\/apidocs","Category":"Games & Comics"},{"API"' +
        ':"Rick and Morty","Description":"All the Rick and Morty informat' +
        'ion, including images","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/rickandmortyapi.com","Category":"Games & Comics"},{' +
        '"API":"Riot Games","Description":"League of Legends Game Informa' +
        'tion","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/developer.riotgames.com\/","Category":"Games & Comics"},{"' +
        'API":"RPS 101","Description":"Rock, Paper, Scissors with 101 obj' +
        'ects","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/rps1' +
        '01.pythonanywhere.com\/api","Category":"Games & Comics"},{"API":' +
        '"RuneScape","Description":"RuneScape and OSRS RPGs information",' +
        '"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/runescape.w' +
        'iki\/w\/Application_programming_interface","Category":"Games & C' +
        'omics"},{"API":"Sakura CardCaptor","Description":"Sakura CardCap' +
        'tor Cards Information","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/github.com\/JessVel\/sakura-card-captor-api","C' +
        'ategory":"Games & Comics"},{"API":"Scryfall","Description":"Magi' +
        'c: The Gathering database","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/scryfall.com\/docs\/api","Category":"Games & Co' +
        'mics"},{"API":"SpaceTradersAPI","Description":"A playable inter-' +
        'galactic space trading MMOAPI","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/spacetraders.io?rel=pub-apis","Categor' +
        'y":"Games & Comics"},{"API":"Steam","Description":"Steam Web API' +
        ' documentation","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":' +
        '"https:\/\/steamapi.xpaw.me\/","Category":"Games & Comics"},{"AP' +
        'I":"Steam","Description":"Internal Steam Web API documentation",' +
        '"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/github.com\' +
        '/Revadike\/InternalSteamWebAPI\/wiki","Category":"Games & Comics' +
        '"},{"API":"SuperHeroes","Description":"All SuperHeroes and Villa' +
        'ins data from all universes under a single API","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/superheroapi.com' +
        '","Category":"Games & Comics"},{"API":"TCGdex","Description":"Mu' +
        'lti languages Pok'#195#169'mon TCG Information","Auth":"","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/www.tcgdex.net\/docs","Category":"' +
        'Games & Comics"},{"API":"Tebex","Description":"Tebex API for inf' +
        'ormation about game purchases","Auth":"X-Mashape-Key","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/docs.tebex.io\/plugin\/","Categ' +
        'ory":"Games & Comics"},{"API":"TETR.IO","Description":"TETR.IO T' +
        'etra Channel API","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/tetr.io\/about\/api\/","Category":"Games & Comics"},' +
        '{"API":"Tronald Dump","Description":"The dumbest things Donald T' +
        'rump has ever said","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.tronalddump.io\/","Category":"Games & Comics"}' +
        ',{"API":"Universalis","Description":"Final Fantasy XIV market bo' +
        'ard data","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'universalis.app\/docs\/index.html","Category":"Games & Comics"},' +
        '{"API":"Valorant (non-official)","Description":"An extensive API' +
        ' containing data of most Valorant in-game items, assets and more' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/valo' +
        'rant-api.com","Category":"Games & Comics"},{"API":"Warface (non-' +
        'official)","Description":"Official API proxy with better data st' +
        'ructure and more features","Auth":"","HTTPS":true,"Cors":"no","L' +
        'ink":"https:\/\/api.wfstats.cf","Category":"Games & Comics"},{"A' +
        'PI":"Wargaming.net","Description":"Wargaming.net info and stats"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/deve' +
        'lopers.wargaming.net\/","Category":"Games & Comics"},{"API":"Whe' +
        'n is next MCU film","Description":"Upcoming MCU film information' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gith' +
        'ub.com\/DiljotSG\/MCU-Countdown\/blob\/develop\/docs\/API.md","C' +
        'ategory":"Games & Comics"},{"API":"xkcd","Description":"Retrieve' +
        ' xkcd comics as JSON","Auth":"","HTTPS":true,"Cors":"no","Link":' +
        '"https:\/\/xkcd.com\/json.html","Category":"Games & Comics"},{"A' +
        'PI":"Yu-Gi-Oh!","Description":"Yu-Gi-Oh! TCG Information","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/db.ygoprodec' +
        'k.com\/api-guide\/","Category":"Games & Comics"},{"API":"Abstrac' +
        't IP Geolocation","Description":"Geolocate website visitors from' +
        ' their IPs","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/www.abstractapi.com\/ip-geolocation-api","Category":"Geo' +
        'coding"},{"API":"Actinia Grass GIS","Description":"Actinia is an' +
        ' open source REST API for geographical data that uses GRASS GIS"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/actinia.mundialis.de\/api_docs\/","Category":"Geocoding"},{"API' +
        '":"administrative-divisons-db","Description":"Get all administra' +
        'tive divisions of a country","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/github.com\/kamikazechaser\/administrative-di' +
        'visions-db","Category":"Geocoding"},{"API":"adresse.data.gouv.fr' +
        '","Description":"Address database of France, geocoding and rever' +
        'se","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ad' +
        'resse.data.gouv.fr","Category":"Geocoding"},{"API":"Airtel IP","' +
        'Description":"IP Geolocation API. Collecting data from multiple ' +
        'sources","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/sys.airtel.lv\/ip2country\/1.1.1.1\/?full=true","Category":"G' +
        'eocoding"},{"API":"Apiip","Description":"Get location informatio' +
        'n by IP address","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/apiip.net\/","Category":"Geocoding"},{"API":"apilay' +
        'er ipstack","Description":"Locate and identify website visitors ' +
        'by IP address","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/ipstack.com\/","Category":"Geocoding"},{"API":"Ba' +
        'ttuta","Description":"A (country\/region\/city) in-cascade locat' +
        'ion API","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"' +
        'http:\/\/battuta.medunes.net","Category":"Geocoding"},{"API":"Bi' +
        'gDataCloud","Description":"Provides fast and accurate IP geoloca' +
        'tion APIs along with security checks and confidence area","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.bi' +
        'gdatacloud.com\/ip-geolocation-apis","Category":"Geocoding"},{"A' +
        'PI":"Bing Maps","Description":"Create\/customize digital maps ba' +
        'sed on Bing Maps data","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/www.microsoft.com\/maps\/","Category":"Ge' +
        'ocoding"},{"API":"bng2latlong","Description":"Convert British OS' +
        'GB36 easting and northing (British National Grid) to WGS84 latit' +
        'ude and longitude","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/www.getthedata.com\/bng2latlong","Category":"Geocoding"' +
        '},{"API":"Cartes.io","Description":"Create maps and markers for ' +
        'anything","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/github.com\/M-Media-Group\/Cartes.io\/wiki\/API","Category":' +
        '"Geocoding"},{"API":"Cep.la","Description":"Brazil RESTful API t' +
        'o find information about streets, zip codes, neighborhoods, citi' +
        'es and states","Auth":"","HTTPS":false,"Cors":"unknown","Link":"' +
        'http:\/\/cep.la\/","Category":"Geocoding"},{"API":"CitySDK","Des' +
        'cription":"Open APIs for select European cities","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"http:\/\/www.citysdk.eu\/citysd' +
        'k-toolkit\/","Category":"Geocoding"},{"API":"Country","Descripti' +
        'on":"Get your visitor'#39's country from their IP","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"http:\/\/country.is\/","Category":"Ge' +
        'ocoding"},{"API":"CountryStateCity","Description":"World countri' +
        'es, states, regions, provinces, cities & towns in JSON, SQL, XML' +
        ', YAML, & CSV format","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/countrystatecity.in\/","Category":"Geocoding"}' +
        ',{"API":"Ducks Unlimited","Description":"API explorer that gives' +
        ' a query URL with a JSON response of locations and cities","Auth' +
        '":"","HTTPS":true,"Cors":"no","Link":"https:\/\/gis.ducks.org\/d' +
        'atasets\/du-university-chapters\/api","Category":"Geocoding"},{"' +
        'API":"FreeGeoIP","Description":"Free geo ip information, no regi' +
        'stration required. 15k\/hour rate limit","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/freegeoip.app\/","Category":"Geoc' +
        'oding"},{"API":"GeoApi","Description":"French geographical data"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.g' +
        'ouv.fr\/api\/geoapi.html","Category":"Geocoding"},{"API":"Geoapi' +
        'fy","Description":"Forward and reverse geocoding, address autoco' +
        'mplete","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/www.geoapify.com\/api\/geocoding-api\/","Category":"Geocodin' +
        'g"},{"API":"Geocod.io","Description":"Address geocoding \/ rever' +
        'se geocoding in bulk","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.geocod.io\/","Category":"Geocoding"},{' +
        '"API":"Geocode.xyz","Description":"Provides worldwide forward\/r' +
        'everse geocoding, batch geocoding and geoparsing","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/geocode.xyz\/api","C' +
        'ategory":"Geocoding"},{"API":"Geocodify.com","Description":"Worl' +
        'dwide geocoding, geoparsing and autocomplete for addresses","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/geocodif' +
        'y.com\/","Category":"Geocoding"},{"API":"Geodata.gov.gr","Descri' +
        'ption":"Open geospatial data and API service for Greece","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/geodata.gov.g' +
        'r\/en\/","Category":"Geocoding"},{"API":"GeoDataSource","Descrip' +
        'tion":"Geocoding of city name by using latitude and longitude co' +
        'ordinates","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.geodatasource.com\/web-service","Category":"Geoco' +
        'ding"},{"API":"GeoDB Cities","Description":"Get global city, reg' +
        'ion, and country data","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"http:\/\/geodb-cities-api.wirefreethought.com\/","C' +
        'ategory":"Geocoding"},{"API":"GeographQL","Description":"A Count' +
        'ry, State, and City GraphQL API","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/geographql.netlify.app","Category":"Geoco' +
        'ding"},{"API":"GeoJS","Description":"IP geolocation with ChatOps' +
        ' integration","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/www.geojs.io\/","Category":"Geocoding"},{"API":"Geokeo","Des' +
        'cription":"Geokeo geocoding service- with 2500 free api requests' +
        ' daily","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ge' +
        'okeo.com","Category":"Geocoding"},{"API":"GeoNames","Description' +
        '":"Place names and other geographical data","Auth":"","HTTPS":fa' +
        'lse,"Cors":"unknown","Link":"http:\/\/www.geonames.org\/export\/' +
        'web-services.html","Category":"Geocoding"},{"API":"geoPlugin","D' +
        'escription":"IP geolocation and currency conversion","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/www.geoplugin.com","C' +
        'ategory":"Geocoding"},{"API":"Google Earth Engine","Description"' +
        ':"A cloud-based platform for planetary-scale environmental data ' +
        'analysis","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/developers.google.com\/earth-engine\/","Category":"Geo' +
        'coding"},{"API":"Google Maps","Description":"Create\/customize d' +
        'igital maps based on Google Maps data","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developers.google.com\/ma' +
        'ps\/","Category":"Geocoding"},{"API":"Graph Countries","Descript' +
        'ion":"Country-related data like currencies, languages, flags, re' +
        'gions+subregions and bordering countries","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/github.com\/lennertVanSever\' +
        '/graphcountries","Category":"Geocoding"},{"API":"HelloSalut","De' +
        'scription":"Get hello translation following user language","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/fourtonfish' +
        '.com\/project\/hellosalut-api\/","Category":"Geocoding"},{"API":' +
        '"HERE Maps","Description":"Create\/customize digital maps based ' +
        'on HERE Maps data","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/developer.here.com","Category":"Geocoding"},{' +
        '"API":"Hirak IP to Country","Description":"Ip to location with c' +
        'ountry code, currency code & currency name, fast response, unlim' +
        'ited requests","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/iplocation.hirak.site\/","Category":"Geocoding"},' +
        '{"API":"Hong Kong GeoData Store","Description":"API for accessin' +
        'g geo-data of Hong Kong","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/geodata.gov.hk\/gs\/","Category":"Geocoding"}' +
        ',{"API":"IBGE","Description":"Aggregate services of IBGE (Brazil' +
        'ian Institute of Geography and Statistics)","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/servicodados.ibge.gov.br\/' +
        'api\/docs\/","Category":"Geocoding"},{"API":"IP 2 Country","Desc' +
        'ription":"Map an IP to a country","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/ip2country.info","Category":"Geocodi' +
        'ng"},{"API":"IP Address Details","Description":"Find geolocation' +
        ' with ip address","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/ipinfo.io\/","Category":"Geocoding"},{"API":"IP Vigi' +
        'lante","Description":"Free IP Geolocation API","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.ipvigilante.com\/",' +
        '"Category":"Geocoding"},{"API":"ip-api","Description":"Find loca' +
        'tion with IP address or domain","Auth":"","HTTPS":false,"Cors":"' +
        'unknown","Link":"https:\/\/ip-api.com\/docs","Category":"Geocodi' +
        'ng"},{"API":"IP2Location","Description":"IP geolocation web serv' +
        'ice to get more than 55 parameters","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/www.ip2location.com\/web-ser' +
        'vice\/ip2location","Category":"Geocoding"},{"API":"IP2Proxy","De' +
        'scription":"Detect proxy and VPN using IP address","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ip2locati' +
        'on.com\/web-service\/ip2proxy","Category":"Geocoding"},{"API":"i' +
        'papi.co","Description":"Find IP address location information","A' +
        'uth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ipapi.co\/ap' +
        'i\/#introduction","Category":"Geocoding"},{"API":"ipapi.com","De' +
        'scription":"Real-time Geolocation & Reverse IP Lookup REST API",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'ipapi.com\/","Category":"Geocoding"},{"API":"IPGEO","Description' +
        '":"Unlimited free IP Address API with useful information","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.technikn' +
        'ews.net\/ipgeo\/","Category":"Geocoding"},{"API":"ipgeolocation"' +
        ',"Description":"IP Geolocation AP with free plan 30k requests pe' +
        'r month","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/ipgeolocation.io\/","Category":"Geocoding"},{"API":"IPInfoD' +
        'B","Description":"Free Geolocation tools and APIs for country, r' +
        'egion, city and time zone lookup by IP address","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ipinfodb.com' +
        '\/api","Category":"Geocoding"},{"API":"ipstack","Description":"L' +
        'ocate and identify website visitors by IP address","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ipstack.com\/' +
        '","Category":"Geocoding"},{"API":"Kakao Maps","Description":"Kak' +
        'ao Maps provide multiple APIs for Korean maps","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/apis.map.kakao.co' +
        'm","Category":"Geocoding"},{"API":"keycdn IP Location Finder","D' +
        'escription":"Get the IP geolocation data through the simple REST' +
        ' API. All the responses are JSON encoded","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/tools.keycdn.com\/geo"' +
        ',"Category":"Geocoding"},{"API":"LocationIQ","Description":"Prov' +
        'ides forward\/reverse geocoding and batch geocoding","Auth":"api' +
        'Key","HTTPS":true,"Cors":"yes","Link":"https:\/\/locationiq.org\' +
        '/docs\/","Category":"Geocoding"},{"API":"Longdo Map","Descriptio' +
        'n":"Interactive map with detailed places and information portal ' +
        'in Thailand","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/map.longdo.com\/docs\/","Category":"Geocoding"},{"API":' +
        '"Mapbox","Description":"Create\/customize beautiful digital maps' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/docs.mapbox.com\/","Category":"Geocoding"},{"API":"MapQuest","' +
        'Description":"To access tools and resources to map the world","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/develop' +
        'er.mapquest.com\/","Category":"Geocoding"},{"API":"Mexico","Desc' +
        'ription":"Mexico RESTful zip codes API","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/github.com\/IcaliaLabs\/sepome' +
        'x","Category":"Geocoding"},{"API":"Nominatim","Description":"Pro' +
        'vides worldwide forward \/ reverse geocoding","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/nominatim.org\/release-docs\' +
        '/latest\/api\/Overview\/","Category":"Geocoding"},{"API":"One Ma' +
        'p, Singapore","Description":"Singapore Land Authority REST API s' +
        'ervices for Singapore addresses","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/www.onemap.gov.sg\/docs\/","Cat' +
        'egory":"Geocoding"},{"API":"OnWater","Description":"Determine if' +
        ' a lat\/lon is on water or land","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/onwater.io\/","Category":"Geocoding"}' +
        ',{"API":"Open Topo Data","Description":"Elevation and ocean dept' +
        'h for a latitude and longitude","Auth":"","HTTPS":true,"Cors":"n' +
        'o","Link":"https:\/\/www.opentopodata.org","Category":"Geocoding' +
        '"},{"API":"OpenCage","Description":"Forward and reverse geocodin' +
        'g using open data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/opencagedata.com","Category":"Geocoding"},{"API":' +
        '"openrouteservice.org","Description":"Directions, POIs, isochron' +
        'es, geocoding (+reverse), elevation, and more","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/openrouteservice.' +
        'org\/","Category":"Geocoding"},{"API":"OpenStreetMap","Descripti' +
        'on":"Navigation, geolocation and geographical data","Auth":"OAut' +
        'h","HTTPS":false,"Cors":"unknown","Link":"http:\/\/wiki.openstre' +
        'etmap.org\/wiki\/API","Category":"Geocoding"},{"API":"Pinball Ma' +
        'p","Description":"A crowdsourced map of public pinball machines"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/pinballma' +
        'p.com\/api\/v1\/docs","Category":"Geocoding"},{"API":"positionst' +
        'ack","Description":"Forward & Reverse Batch Geocoding REST API",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'positionstack.com\/","Category":"Geocoding"},{"API":"Postali","D' +
        'escription":"Mexico Zip Codes API","Auth":"","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/postali.app\/api","Category":"Geocoding' +
        '"},{"API":"PostcodeData.nl","Description":"Provide geolocation d' +
        'ata based on postcode for Dutch addresses","Auth":"","HTTPS":fal' +
        'se,"Cors":"unknown","Link":"http:\/\/api.postcodedata.nl\/v1\/po' +
        'stcode\/?postcode=1211EP&streetnumber=60&ref=domeinnaam.nl&type=' +
        'json","Category":"Geocoding"},{"API":"Postcodes.io","Description' +
        '":"Postcode lookup & Geolocation for the UK","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/postcodes.io","Category":"Geo' +
        'coding"},{"API":"Queimadas INPE","Description":"Access to heat f' +
        'ocus data (probable wildfire)","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/queimadas.dgi.inpe.br\/queimadas\/dados' +
        '-abertos\/","Category":"Geocoding"},{"API":"REST Countries","Des' +
        'cription":"Get information about countries via a RESTful API","A' +
        'uth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/restcountrie' +
        's.com","Category":"Geocoding"},{"API":"RoadGoat Cities","Descrip' +
        'tion":"Cities content & photos API","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/www.roadgoat.com\/business\/citie' +
        's-api","Category":"Geocoding"},{"API":"Rwanda Locations","Descri' +
        'ption":"Rwanda Provences, Districts, Cities, Capital City, Secto' +
        'r, cells, villages and streets","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/rapidapi.com\/victorkarangwa4\/api\/rw' +
        'anda","Category":"Geocoding"},{"API":"SLF","Description":"German' +
        ' city, country, river, database","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/github.com\/slftool\/slftool.github.io\/b' +
        'lob\/master\/API.md","Category":"Geocoding"},{"API":"SpotSense",' +
        '"Description":"Add location based interactions to your mobile ap' +
        'p","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/spotsense.io\/","Category":"Geocoding"},{"API":"Telize","Desc' +
        'ription":"Telize offers location information from any IP address' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/ra' +
        'pidapi.com\/fcambus\/api\/telize\/","Category":"Geocoding"},{"AP' +
        'I":"TomTom","Description":"Maps, Directions, Places and Traffic ' +
        'APIs","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/developer.tomtom.com\/","Category":"Geocoding"},{"API":"Ueberm' +
        'aps","Description":"Discover and share maps with friends","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ueberm' +
        'aps.com\/api\/v2","Category":"Geocoding"},{"API":"US ZipCode","D' +
        'escription":"Validate and append data for any US ZipCode","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.smarty' +
        '.com\/docs\/cloud\/us-zipcode-api","Category":"Geocoding"},{"API' +
        '":"Utah AGRC","Description":"Utah Web API for geocoding Utah add' +
        'resses","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/api.mapserv.utah.gov","Category":"Geocoding"},{"API":"Vi' +
        'aCep","Description":"Brazil RESTful zip codes API","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/viacep.com.br","Cat' +
        'egory":"Geocoding"},{"API":"What3Words","Description":"Three wor' +
        'ds as rememberable and unique coordinates worldwide","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/what3words.' +
        'com","Category":"Geocoding"},{"API":"Yandex.Maps Geocoder","Desc' +
        'ription":"Use geocoding to get an object'#39's coordinates from its ' +
        'address","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/yandex.com\/dev\/maps\/geocoder","Category":"Geocoding"' +
        '},{"API":"ZipCodeAPI","Description":"US zip code distance, radiu' +
        's and location API","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/www.zipcodeapi.com","Category":"Geocoding"},' +
        '{"API":"Zippopotam.us","Description":"Get information about plac' +
        'e such as country, city, state, etc","Auth":"","HTTPS":false,"Co' +
        'rs":"unknown","Link":"http:\/\/www.zippopotam.us","Category":"Ge' +
        'ocoding"},{"API":"Ziptastic","Description":"Get the country, sta' +
        'te, and city of any US zip-code","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/ziptasticapi.com\/","Category":"Geoco' +
        'ding"},{"API":"Bank Negara Malaysia Open Data","Description":"Ma' +
        'laysia Central Bank Open Data","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/apikijangportal.bnm.gov.my\/","Category' +
        '":"Government"},{"API":"BCLaws","Description":"Access to the law' +
        's of British Columbia","Auth":"","HTTPS":false,"Cors":"unknown",' +
        '"Link":"https:\/\/www.bclaws.gov.bc.ca\/civix\/template\/complet' +
        'e\/api\/index.html","Category":"Government"},{"API":"Brazil","De' +
        'scription":"Community driven API for Brazil Public Data","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/brasilapi.com.br\' +
        '/","Category":"Government"},{"API":"Brazil Central Bank Open Dat' +
        'a","Description":"Brazil Central Bank Open Data","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/dadosabertos.bcb.gov.' +
        'br\/","Category":"Government"},{"API":"Brazil Receita WS","Descr' +
        'iption":"Consult companies by CNPJ for Brazilian companies","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.receit' +
        'aws.com.br\/","Category":"Government"},{"API":"Brazilian Chamber' +
        ' of Deputies Open Data","Description":"Provides legislative info' +
        'rmation in Apis XML and JSON, as well as files in various format' +
        's","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/dadosabe' +
        'rtos.camara.leg.br\/swagger\/api.html","Category":"Government"},' +
        '{"API":"Census.gov","Description":"The US Census Bureau provides' +
        ' various APIs and data sets on demographics and businesses","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.census' +
        '.gov\/data\/developers\/data-sets.html","Category":"Government"}' +
        ',{"API":"City, Berlin","Description":"Berlin(DE) City Open Data"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/daten' +
        '.berlin.de\/","Category":"Government"},{"API":"City, Gda'#197#8222'sk","D' +
        'escription":"Gda'#197#8222'sk (PL) City Open Data","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/ckan.multimediagdansk.pl\/en' +
        '","Category":"Government"},{"API":"City, Gdynia","Description":"' +
        'Gdynia (PL) City Open Data","Auth":"","HTTPS":false,"Cors":"unkn' +
        'own","Link":"http:\/\/otwartedane.gdynia.pl\/en\/api_doc.html","' +
        'Category":"Government"},{"API":"City, Helsinki","Description":"H' +
        'elsinki(FI) City Open Data","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/hri.fi\/en_gb\/","Category":"Government"},' +
        '{"API":"City, Lviv","Description":"Lviv(UA) City Open Data","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/opendata.c' +
        'ity-adm.lviv.ua\/","Category":"Government"},{"API":"City, Nantes' +
        ' Open Data","Description":"Nantes(FR) City Open Data","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.nante' +
        'smetropole.fr\/pages\/home\/","Category":"Government"},{"API":"C' +
        'ity, New York Open Data","Description":"New York (US) City Open ' +
        'Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'opendata.cityofnewyork.us\/","Category":"Government"},{"API":"Ci' +
        'ty, Prague Open Data","Description":"Prague(CZ) City Open Data",' +
        '"Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/openda' +
        'ta.praha.eu\/en","Category":"Government"},{"API":"City, Toronto ' +
        'Open Data","Description":"Toronto (CA) City Open Data","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/open.toronto.ca\/",' +
        '"Category":"Government"},{"API":"Code.gov","Description":"The pr' +
        'imary platform for Open Source and code sharing for the U.S. Fed' +
        'eral Government","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/code.gov","Category":"Government"},{"API":"Colo' +
        'rado Information Marketplace","Description":"Colorado State Gove' +
        'rnment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/data.colorado.gov\/","Category":"Government"},{"API"' +
        ':"Data USA","Description":"US Public Data","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/datausa.io\/about\/api\/","' +
        'Category":"Government"},{"API":"Data.gov","Description":"US Gove' +
        'rnment Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/api.data.gov\/","Category":"Government"},{"API":"Da' +
        'ta.parliament.uk","Description":"Contains live datasets includin' +
        'g information about petitions, bills, MP votes, attendance and m' +
        'ore","Auth":"","HTTPS":false,"Cors":"unknown","Link":"https:\/\/' +
        'explore.data.parliament.uk\/?learnmore=Members","Category":"Gove' +
        'rnment"},{"API":"Deutscher Bundestag DIP","Description":"This AP' +
        'I provides read access to DIP entities (e.g. activities, persons' +
        ', printed material)","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/dip.bundestag.de\/documents\/informationsbl' +
        'att_zur_dip_api_v01.pdf","Category":"Government"},{"API":"Distri' +
        'ct of Columbia Open Data","Description":"Contains D.C. governmen' +
        't public datasets, including crime, GIS, financial data, and so ' +
        'on","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http:\/\/ope' +
        'ndata.dc.gov\/pages\/using-apis","Category":"Government"},{"API"' +
        ':"EPA","Description":"Web services and data sets from the US Env' +
        'ironmental Protection Agency","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/www.epa.gov\/developers\/data-data-produ' +
        'cts#apis","Category":"Government"},{"API":"FBI Wanted","Descript' +
        'ion":"Access information on the FBI Wanted program","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/www.fbi.gov\/wante' +
        'd\/api","Category":"Government"},{"API":"FEC","Description":"Inf' +
        'ormation on campaign donations in federal elections","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.open.fe' +
        'c.gov\/developers\/","Category":"Government"},{"API":"Federal Re' +
        'gister","Description":"The Daily Journal of the United States Go' +
        'vernment","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/www.federalregister.gov\/reader-aids\/developer-resources\/r' +
        'est-api","Category":"Government"},{"API":"Food Standards Agency"' +
        ',"Description":"UK food hygiene rating data API","Auth":"","HTTP' +
        'S":false,"Cors":"unknown","Link":"http:\/\/ratings.food.gov.uk\/' +
        'open-data\/en-GB","Category":"Government"},{"API":"Gazette Data,' +
        ' UK","Description":"UK official public record API","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.thegazette' +
        '.co.uk\/data","Category":"Government"},{"API":"Gun Policy","Desc' +
        'ription":"International firearm injury prevention and policy","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ww' +
        'w.gunpolicy.org\/api","Category":"Government"},{"API":"INEI","De' +
        'scription":"Peruvian Statistical Government Open Data","Auth":""' +
        ',"HTTPS":false,"Cors":"unknown","Link":"http:\/\/iinei.inei.gob.' +
        'pe\/microdatos\/","Category":"Government"},{"API":"Interpol Red ' +
        'Notices","Description":"Access and search Interpol Red Notices",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/interp' +
        'ol.api.bund.dev\/","Category":"Government"},{"API":"Istanbul ('#196#176 +
        'BB) Open Data","Description":"Data sets from the '#196#176'stanbul Metro' +
        'politan Municipality ('#196#176'BB)","Auth":"","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/data.ibb.gov.tr","Category":"Government"}' +
        ',{"API":"National Park Service, US","Description":"Data from the' +
        ' US National Park Service","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/www.nps.gov\/subjects\/developer\/","Cate' +
        'gory":"Government"},{"API":"Open Government, ACT","Description":' +
        '"Australian Capital Territory Open Data","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.data.act.gov.au\/","Categ' +
        'ory":"Government"},{"API":"Open Government, Argentina","Descript' +
        'ion":"Argentina Government Open Data","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/datos.gob.ar\/","Category":"Gove' +
        'rnment"},{"API":"Open Government, Australia","Description":"Aust' +
        'ralian Government Open Data","Auth":"","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/www.data.gov.au\/","Category":"Government' +
        '"},{"API":"Open Government, Austria","Description":"Austria Gove' +
        'rnment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.data.gv.at\/","Category":"Government"},{"API":"O' +
        'pen Government, Belgium","Description":"Belgium Government Open ' +
        'Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'data.gov.be\/","Category":"Government"},{"API":"Open Government,' +
        ' Canada","Description":"Canadian Government Open Data","Auth":""' +
        ',"HTTPS":false,"Cors":"unknown","Link":"http:\/\/open.canada.ca\' +
        '/en","Category":"Government"},{"API":"Open Government, Colombia"' +
        ',"Description":"Colombia Government Open Data","Auth":"","HTTPS"' +
        ':false,"Cors":"unknown","Link":"https:\/\/www.dane.gov.co\/","Ca' +
        'tegory":"Government"},{"API":"Open Government, Cyprus","Descript' +
        'ion":"Cyprus Government Open Data","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/data.gov.cy\/?language=en","Categor' +
        'y":"Government"},{"API":"Open Government, Czech Republic","Descr' +
        'iption":"Czech Republic Government Open Data","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/data.gov.cz\/english\/",' +
        '"Category":"Government"},{"API":"Open Government, Denmark","Desc' +
        'ription":"Denmark Government Open Data","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.opendata.dk\/","Category":' +
        '"Government"},{"API":"Open Government, Estonia","Description":"E' +
        'stonia Government Open Data","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/avaandmed.eesti.ee\/instructions\/o' +
        'pendata-dataset-api","Category":"Government"},{"API":"Open Gover' +
        'nment, Finland","Description":"Finland Government Open Data","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.avoin' +
        'data.fi\/en","Category":"Government"},{"API":"Open Government, F' +
        'rance","Description":"French Government Open Data","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.data.gouv' +
        '.fr\/","Category":"Government"},{"API":"Open Government, Germany' +
        '","Description":"Germany Government Open Data","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.govdata.de\/daten\/' +
        '-\/details\/govdata-metadatenkatalog","Category":"Government"},{' +
        '"API":"Open Government, Greece","Description":"Greece Government' +
        ' Open Data","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/data.gov.gr\/","Category":"Government"},{"API":"Open ' +
        'Government, India","Description":"Indian Government Open Data","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/d' +
        'ata.gov.in\/","Category":"Government"},{"API":"Open Government, ' +
        'Ireland","Description":"Ireland Government Open Data","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.gov.ie\/pag' +
        'es\/developers","Category":"Government"},{"API":"Open Government' +
        ', Italy","Description":"Italy Government Open Data","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/www.dati.gov.it\/"' +
        ',"Category":"Government"},{"API":"Open Government, Korea","Descr' +
        'iption":"Korea Government Open Data","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/www.data.go.kr\/","Category' +
        '":"Government"},{"API":"Open Government, Lithuania","Description' +
        '":"Lithuania Government Open Data","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/data.gov.lt\/public\/api\/1","Categ' +
        'ory":"Government"},{"API":"Open Government, Luxembourg","Descrip' +
        'tion":"Luxembourgish Government Open Data","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/data.public.lu","Cate' +
        'gory":"Government"},{"API":"Open Government, Mexico","Descriptio' +
        'n":"Mexican Statistical Government Open Data","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.inegi.org.mx\/datos\' +
        '/","Category":"Government"},{"API":"Open Government, Mexico","De' +
        'scription":"Mexico Government Open Data","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/datos.gob.mx\/","Category":"G' +
        'overnment"},{"API":"Open Government, Netherlands","Description":' +
        '"Netherlands Government Open Data","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/data.overheid.nl\/en\/ondersteuning' +
        '\/data-publiceren\/api","Category":"Government"},{"API":"Open Go' +
        'vernment, New South Wales","Description":"New South Wales Govern' +
        'ment Open Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/api.nsw.gov.au\/","Category":"Government"},{"API' +
        '":"Open Government, New Zealand","Description":"New Zealand Gove' +
        'rnment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.data.govt.nz\/","Category":"Government"},{"API":' +
        '"Open Government, Norway","Description":"Norwegian Government Op' +
        'en Data","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/d' +
        'ata.norge.no\/dataservices","Category":"Government"},{"API":"Ope' +
        'n Government, Peru","Description":"Peru Government Open Data","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.dato' +
        'sabiertos.gob.pe\/","Category":"Government"},{"API":"Open Govern' +
        'ment, Poland","Description":"Poland Government Open Data","Auth"' +
        ':"","HTTPS":true,"Cors":"yes","Link":"https:\/\/dane.gov.pl\/en"' +
        ',"Category":"Government"},{"API":"Open Government, Portugal","De' +
        'scription":"Portugal Government Open Data","Auth":"","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/dados.gov.pt\/en\/docapi\/","Ca' +
        'tegory":"Government"},{"API":"Open Government, Queensland Govern' +
        'ment","Description":"Queensland Government Open Data","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.data.qld.gov' +
        '.au\/","Category":"Government"},{"API":"Open Government, Romania' +
        '","Description":"Romania Government Open Data","Auth":"","HTTPS"' +
        ':false,"Cors":"unknown","Link":"http:\/\/data.gov.ro\/","Categor' +
        'y":"Government"},{"API":"Open Government, Saudi Arabia","Descrip' +
        'tion":"Saudi Arabia Government Open Data","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/data.gov.sa","Category":"Gov' +
        'ernment"},{"API":"Open Government, Singapore","Description":"Sin' +
        'gapore Government Open Data","Auth":"","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/data.gov.sg\/developer","Category":"Gover' +
        'nment"},{"API":"Open Government, Slovakia","Description":"Slovak' +
        'ia Government Open Data","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/data.gov.sk\/en\/","Category":"Government"},{' +
        '"API":"Open Government, Slovenia","Description":"Slovenia Govern' +
        'ment Open Data","Auth":"","HTTPS":true,"Cors":"no","Link":"https' +
        ':\/\/podatki.gov.si\/","Category":"Government"},{"API":"Open Gov' +
        'ernment, South Australian Government","Description":"South Austr' +
        'alian Government Open Data","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/data.sa.gov.au\/","Category":"Government"}' +
        ',{"API":"Open Government, Spain","Description":"Spain Government' +
        ' Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/datos.gob.es\/en","Category":"Government"},{"API":"Open Go' +
        'vernment, Sweden","Description":"Sweden Government Open Data","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.data' +
        'portal.se\/en\/dataservice\/91_29789\/api-for-the-statistical-da' +
        'tabase","Category":"Government"},{"API":"Open Government, Switze' +
        'rland","Description":"Switzerland Government Open Data","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/handbook.opend' +
        'ata.swiss\/de\/content\/nutzen\/api-nutzen.html","Category":"Gov' +
        'ernment"},{"API":"Open Government, Taiwan","Description":"Taiwan' +
        ' Government Open Data","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/data.gov.tw\/","Category":"Government"},{"API":' +
        '"Open Government, Thailand","Description":"Thailand Government O' +
        'pen Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/data.go.th\/","Category":"Government"},{"API":"Open Go' +
        'vernment, UK","Description":"UK Government Open Data","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.gov.uk\/","' +
        'Category":"Government"},{"API":"Open Government, USA","Descripti' +
        'on":"United States Government Open Data","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.data.gov\/","Category":"G' +
        'overnment"},{"API":"Open Government, Victoria State Government",' +
        '"Description":"Victoria State Government Open Data","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/www.data.vic.gov.a' +
        'u\/","Category":"Government"},{"API":"Open Government, West Aust' +
        'ralia","Description":"West Australia Open Data","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/data.wa.gov.au\/","Cat' +
        'egory":"Government"},{"API":"PRC Exam Schedule","Description":"U' +
        'nofficial Philippine Professional Regulation Commission'#39's examin' +
        'ation schedule","Auth":"","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/api.whenisthenextboardexam.com\/docs\/","Category":"Govern' +
        'ment"},{"API":"Represent by Open North","Description":"Find Cana' +
        'dian Government Representatives","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/represent.opennorth.ca\/","Category":' +
        '"Government"},{"API":"UK Companies House","Description":"UK Comp' +
        'anies House Data from the UK government","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/developer.company-inform' +
        'ation.service.gov.uk\/","Category":"Government"},{"API":"US Pres' +
        'idential Election Data by TogaTech","Description":"Basic candida' +
        'te data and live electoral vote counts for top two parties in US' +
        ' presidential election","Auth":"","HTTPS":true,"Cors":"no","Link' +
        '":"https:\/\/uselection.togatech.org\/api\/","Category":"Governm' +
        'ent"},{"API":"USA.gov","Description":"Authoritative information ' +
        'on U.S. programs, events, services and more","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/www.usa.gov\/develo' +
        'per","Category":"Government"},{"API":"USAspending.gov","Descript' +
        'ion":"US federal spending data","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/api.usaspending.gov\/","Category":"Gov' +
        'ernment"},{"API":"CMS.gov","Description":"Access to the data fro' +
        'm the CMS - medicare.gov","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/data.cms.gov\/provider-data\/","Catego' +
        'ry":"Health"},{"API":"Coronavirus","Description":"HTTP API for L' +
        'atest Covid-19 Data","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/pipedream.com\/@pravin\/http-api-for-latest-wuhan' +
        '-coronavirus-data-2019-ncov-p_G6CLVM\/readme","Category":"Health' +
        '"},{"API":"Coronavirus in the UK","Description":"UK Government c' +
        'oronavirus data, including deaths and cases by region","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/coronavirus.dat' +
        'a.gov.uk\/details\/developers-guide","Category":"Health"},{"API"' +
        ':"Covid Tracking Project","Description":"Covid-19  data for the ' +
        'US","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/covidtr' +
        'acking.com\/data\/api\/version-2","Category":"Health"},{"API":"C' +
        'ovid-19","Description":"Covid 19 spread, infection and recovery"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/covid19ap' +
        'i.com\/","Category":"Health"},{"API":"Covid-19","Description":"C' +
        'ovid 19 cases, deaths and recovery per country","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/github.com\/M-Media-Group\' +
        '/Covid-19-API","Category":"Health"},{"API":"Covid-19 Datenhub","' +
        'Description":"Maps, datasets, applications and more in the conte' +
        'xt of COVID-19","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/npgeo-corona-npgeo-de.hub.arcgis.com","Category":"Heal' +
        'th"},{"API":"Covid-19 Government Response","Description":"Govern' +
        'ment measures tracker to fight against the Covid-19 pandemic","A' +
        'uth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/covidtracker' +
        '.bsg.ox.ac.uk","Category":"Health"},{"API":"Covid-19 India","Des' +
        'cription":"Covid 19 statistics state and district wise about cas' +
        'es, vaccinations, recovery within India","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/data.covid19india.org\/","Cat' +
        'egory":"Health"},{"API":"Covid-19 JHU CSSE","Description":"Open-' +
        'source API for exploring Covid19 cases based on JHU CSSE","Auth"' +
        ':"","HTTPS":true,"Cors":"yes","Link":"https:\/\/nuttaphat.com\/c' +
        'ovid19-api\/","Category":"Health"},{"API":"Covid-19 Live Data","' +
        'Description":"Global and countrywise data of Covid 19 daily Summ' +
        'ary, confirmed cases, recovered and deaths","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/github.com\/mathdroid\/covid-1' +
        '9-api","Category":"Health"},{"API":"Covid-19 Philippines","Descr' +
        'iption":"Unofficial Covid-19 Web API for Philippines from data c' +
        'ollected by DOH","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/github.com\/Simperfy\/Covid-19-API-Philippines-DOH","Cate' +
        'gory":"Health"},{"API":"COVID-19 Tracker Canada","Description":"' +
        'Details on Covid-19 cases across Canada","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/api.covid19tracker.ca\/docs\/' +
        '1.0\/overview","Category":"Health"},{"API":"COVID-19 Tracker Sri' +
        ' Lanka","Description":"Provides situation of the COVID-19 patien' +
        'ts reported in Sri Lanka","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/www.hpb.health.gov.lk\/en\/api-documentation' +
        '","Category":"Health"},{"API":"COVID-ID","Description":"Indonesi' +
        'an government Covid data per province","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/data.covid19.go.id\/public\/api\/pr' +
        'ov.json","Category":"Health"},{"API":"Dataflow Kit COVID-19","De' +
        'scription":"COVID-19 live statistics into sites per hour","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/covid-19.dat' +
        'aflowkit.com","Category":"Health"},{"API":"FoodData Central","De' +
        'scription":"National Nutrient Database for Standard Reference","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/f' +
        'dc.nal.usda.gov\/","Category":"Health"},{"API":"Healthcare.gov",' +
        '"Description":"Educational content about the US Health Insurance' +
        ' Marketplace","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/www.healthcare.gov\/developers\/","Category":"Health"},{' +
        '"API":"Humanitarian Data Exchange","Description":"Humanitarian D' +
        'ata Exchange (HDX) is open platform for sharing data across cris' +
        'es and organisations","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/data.humdata.org\/","Category":"Health"},{"API":' +
        '"Infermedica","Description":"NLP based symptom checker and patie' +
        'nt triage API for health diagnosis from text","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/developer.infermedica.' +
        'com\/docs\/","Category":"Health"},{"API":"LAPIS","Description":"' +
        'SARS-CoV-2 genomic sequences from public sources","Auth":"","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/cov-spectrum.ethz.ch\/pu' +
        'blic","Category":"Health"},{"API":"Lexigram","Description":"NLP ' +
        'that extracts mentions of clinical concepts from text, gives acc' +
        'ess to clinical ontology","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/docs.lexigram.io\/","Category":"Health' +
        '"},{"API":"Makeup","Description":"Makeup Information","Auth":"",' +
        '"HTTPS":false,"Cors":"unknown","Link":"http:\/\/makeup-api.herok' +
        'uapp.com\/","Category":"Health"},{"API":"MyVaccination","Descrip' +
        'tion":"Vaccination data for Malaysia","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/documenter.getpostman.com\/view\' +
        '/16605343\/Tzm8GG7u","Category":"Health"},{"API":"NPPES","Descri' +
        'ption":"National Plan & Provider Enumeration System, info on hea' +
        'lthcare providers registered in US","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/npiregistry.cms.hhs.gov\/registry\' +
        '/help-api","Category":"Health"},{"API":"Nutritionix","Descriptio' +
        'n":"Worlds largest verified nutrition database","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.nutrit' +
        'ionix.com\/","Category":"Health"},{"API":"Open Data NHS Scotland' +
        '","Description":"Medical reference data and statistics by Public' +
        ' Health Scotland","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.opendata.nhs.scot","Category":"Health"},{"API":"' +
        'Open Disease","Description":"API for Current cases and more stuf' +
        'f about COVID-19 and Influenza","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/disease.sh\/","Category":"Health"},{"API":' +
        '"openFDA","Description":"Public FDA data about drugs, devices an' +
        'd foods","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/open.fda.gov","Category":"Health"},{"API":"Orion Health' +
        '","Description":"Medical platform which allows the development o' +
        'f applications for different healthcare scenarios","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.orio' +
        'nhealth.io\/","Category":"Health"},{"API":"Quarantine","Descript' +
        'ion":"Coronavirus API with free COVID-19 live updates","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/quarantine.country\' +
        '/coronavirus\/api\/","Category":"Health"},{"API":"Adzuna","Descr' +
        'iption":"Job board aggregator","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/developer.adzuna.com\/overview","' +
        'Category":"Jobs"},{"API":"Arbeitnow","Description":"API for Job ' +
        'board aggregator in Europe \/ Remote","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/documenter.getpostman.com\/view\/185' +
        '45278\/UVJbJdKh","Category":"Jobs"},{"API":"Arbeitsamt","Descrip' +
        'tion":"API for the \"Arbeitsamt\", which is a german Job board a' +
        'ggregator","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/jobsuche.api.bund.dev\/","Category":"Jobs"},{"API":"Ca' +
        'reerjet","Description":"Job search engine","Auth":"apiKey","HTTP' +
        'S":false,"Cors":"unknown","Link":"https:\/\/www.careerjet.com\/p' +
        'artners\/api\/","Category":"Jobs"},{"API":"DevITjobs UK","Descri' +
        'ption":"Jobs with GraphQL","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/devitjobs.uk\/job_feed.xml","Category":"Jobs"},' +
        '{"API":"Findwork","Description":"Job board","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/findwork.dev\/develo' +
        'pers\/","Category":"Jobs"},{"API":"GraphQL Jobs","Description":"' +
        'Jobs with GraphQL","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/graphql.jobs\/docs\/api\/","Category":"Jobs"},{"API":"J' +
        'obs2Careers","Description":"Job aggregator","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"http:\/\/api.jobs2careers.com\' +
        '/api\/spec.pdf","Category":"Jobs"},{"API":"Jooble","Description"' +
        ':"Job search engine","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/jooble.org\/api\/about","Category":"Jobs"},' +
        '{"API":"Juju","Description":"Job search engine","Auth":"apiKey",' +
        '"HTTPS":false,"Cors":"unknown","Link":"http:\/\/www.juju.com\/pu' +
        'blisher\/spec\/","Category":"Jobs"},{"API":"Open Skills","Descri' +
        'ption":"Job titles, skills and related jobs data","Auth":"","HTT' +
        'PS":false,"Cors":"unknown","Link":"https:\/\/github.com\/workfor' +
        'ce-data-initiative\/skills-api\/wiki\/API-Overview","Category":"' +
        'Jobs"},{"API":"Reed","Description":"Job board aggregator","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.re' +
        'ed.co.uk\/developers","Category":"Jobs"},{"API":"The Muse","Desc' +
        'ription":"Job board and company profiles","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/www.themuse.com\/devel' +
        'opers\/api\/v2","Category":"Jobs"},{"API":"Upwork","Description"' +
        ':"Freelance job board and management system","Auth":"OAuth","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/developers.upwork.co' +
        'm\/","Category":"Jobs"},{"API":"USAJOBS","Description":"US gover' +
        'nment job board","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developer.usajobs.gov\/","Category":"Jobs"},{"A' +
        'PI":"WhatJobs","Description":"Job search engine","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.whatjobs.co' +
        'm\/affiliates","Category":"Jobs"},{"API":"ZipRecruiter","Descrip' +
        'tion":"Job search app and website","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.ziprecruiter.com\/publish' +
        'ers","Category":"Jobs"},{"API":"AI For Thai","Description":"Free' +
        ' Various Thai AI API","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/aiforthai.in.th\/index.php","Category":"Machin' +
        'e Learning"},{"API":"Clarifai","Description":"Computer Vision","' +
        'Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/do' +
        'cs.clarifai.com\/api-guide\/api-overview","Category":"Machine Le' +
        'arning"},{"API":"Cloudmersive","Description":"Image captioning, ' +
        'face recognition, NSFW classification","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.cloudmersive.com\/image-r' +
        'ecognition-and-processing-api","Category":"Machine Learning"},{"' +
        'API":"Deepcode","Description":"AI for code review","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/www.deepcode.ai","C' +
        'ategory":"Machine Learning"},{"API":"Dialogflow","Description":"' +
        'Natural Language Processing","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/cloud.google.com\/dialogflow\/docs\' +
        '/","Category":"Machine Learning"},{"API":"EXUDE-API","Descriptio' +
        'n":"Used for the primary ways for filtering the stopping, stemmi' +
        'ng words from the text data","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"http:\/\/uttesh.com\/exude-api\/","Category":"Machine L' +
        'earning"},{"API":"Hirak FaceAPI","Description":"Face detection, ' +
        'face recognition with age estimation\/gender estimation, accurat' +
        'e, no quota limits","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/faceapi.hirak.site\/","Category":"Machine Le' +
        'arning"},{"API":"Imagga","Description":"Image Recognition Soluti' +
        'ons like Tagging, Visual Search, NSFW moderation","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/imagga.com\/",' +
        '"Category":"Machine Learning"},{"API":"Inferdo","Description":"C' +
        'omputer Vision services like Facial detection, Image labeling, N' +
        'SFW classification","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/rapidapi.com\/user\/inferdo","Category":"Mac' +
        'hine Learning"},{"API":"IPS Online","Description":"Face and Lice' +
        'nse Plate Anonymization","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/docs.identity.ps\/docs","Category":"Mac' +
        'hine Learning"},{"API":"Irisnet","Description":"Realtime content' +
        ' moderation API that blocks or blurs unwanted images in real-tim' +
        'e","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/i' +
        'risnet.de\/api\/","Category":"Machine Learning"},{"API":"Keen IO' +
        '","Description":"Data Analytics","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/keen.io\/","Category":"Machine ' +
        'Learning"},{"API":"Machinetutors","Description":"AI Solutions: V' +
        'ideo\/Image Classification & Tagging, NSFW, Icon\/Image\/Audio S' +
        'earch, NLP","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/www.machinetutors.com\/portfolio\/MT_api.html","Category' +
        '":"Machine Learning"},{"API":"MessengerX.io","Description":"A FR' +
        'EE API for developers to build and monetize personalized ML base' +
        'd chat apps","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/messengerx.rtfd.io","Category":"Machine Learning"},{"AP' +
        'I":"NLP Cloud","Description":"NLP API using spaCy and transforme' +
        'rs for NER, sentiments, classification, summarization, and more"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/nlpcloud.io","Category":"Machine Learning"},{"API":"OpenVisionA' +
        'PI","Description":"Open source computer vision API based on open' +
        ' source models","Auth":"","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/openvisionapi.com","Category":"Machine Learning"},{"API":"' +
        'Perspective","Description":"NLP API to return probability that i' +
        'f text is toxic, obscene, insulting or threatening","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/perspectivea' +
        'pi.com","Category":"Machine Learning"},{"API":"Roboflow Universe' +
        '","Description":"Pre-trained computer vision models","Auth":"api' +
        'Key","HTTPS":true,"Cors":"yes","Link":"https:\/\/universe.robofl' +
        'ow.com","Category":"Machine Learning"},{"API":"SkyBiometry","Des' +
        'cription":"Face Detection, Face Recognition and Face Grouping","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/s' +
        'kybiometry.com\/documentation\/","Category":"Machine Learning"},' +
        '{"API":"Time Door","Description":"A time series analysis API","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/timedo' +
        'or.io","Category":"Machine Learning"},{"API":"Unplugg","Descript' +
        'ion":"Forecasting API for timeseries data","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/unplu.gg\/test_api.ht' +
        'ml","Category":"Machine Learning"},{"API":"WolframAlpha","Descri' +
        'ption":"Provides specific answers to questions using data and al' +
        'gorithms","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/products.wolframalpha.com\/api\/","Category":"Machine ' +
        'Learning"},{"API":"7digital","Description":"Api of Music store 7' +
        'digital","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/docs.7digital.com\/reference","Category":"Music"},{"API"' +
        ':"AI Mastering","Description":"Automated Music Mastering","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/aimasterin' +
        'g.com\/api_docs\/","Category":"Music"},{"API":"Audiomack","Descr' +
        'iption":"Api of the streaming music hub Audiomack","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.audiomack.' +
        'com\/data-api\/docs","Category":"Music"},{"API":"Bandcamp","Desc' +
        'ription":"API of Music store Bandcamp","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/bandcamp.com\/developer","' +
        'Category":"Music"},{"API":"Bandsintown","Description":"Music Eve' +
        'nts","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/a' +
        'pp.swaggerhub.com\/apis\/Bandsintown\/PublicAPI\/3.0.0","Categor' +
        'y":"Music"},{"API":"Deezer","Description":"Music","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.deez' +
        'er.com\/api","Category":"Music"},{"API":"Discogs","Description":' +
        '"Music","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/www.discogs.com\/developers\/","Category":"Music"},{"API"' +
        ':"Freesound","Description":"Music Samples","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/freesound.org\/docs\/' +
        'api\/","Category":"Music"},{"API":"Gaana","Description":"API to ' +
        'retrieve song information from Gaana","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/github.com\/cyberboysumanjay\/Ga' +
        'anaAPI","Category":"Music"},{"API":"Genius","Description":"Crowd' +
        'sourced lyrics and music knowledge","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/docs.genius.com\/","Category"' +
        ':"Music"},{"API":"Genrenator","Description":"Music genre generat' +
        'or","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bi' +
        'naryjazz.us\/genrenator-api\/","Category":"Music"},{"API":"iTune' +
        's Search","Description":"Software products","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/affiliate.itunes.apple.com' +
        '\/resources\/documentation\/itunes-store-web-service-search-api\' +
        '/","Category":"Music"},{"API":"Jamendo","Description":"Music","A' +
        'uth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dev' +
        'eloper.jamendo.com\/v3.0\/docs","Category":"Music"},{"API":"JioS' +
        'aavn","Description":"API to retrieve song information, album met' +
        'a data and many more from JioSaavn","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/github.com\/cyberboysumanjay\/JioS' +
        'aavnAPI","Category":"Music"},{"API":"KKBOX","Description":"Get m' +
        'usic libraries, playlists, charts, and perform out of KKBOX'#39's pl' +
        'atform","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/developer.kkbox.com","Category":"Music"},{"API":"KSoft.Si' +
        ' Lyrics","Description":"API to get lyrics for songs","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.ksoft.' +
        'si\/api\/lyrics-api","Category":"Music"},{"API":"LastFm","Descri' +
        'ption":"Music","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/www.last.fm\/api","Category":"Music"},{"API":"Lyr' +
        'ics.ovh","Description":"Simple API to retrieve the lyrics of a s' +
        'ong","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/l' +
        'yricsovh.docs.apiary.io","Category":"Music"},{"API":"Mixcloud","' +
        'Description":"Music","Auth":"OAuth","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/www.mixcloud.com\/developers\/","Category":"Musi' +
        'c"},{"API":"MusicBrainz","Description":"Music","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/musicbrainz.org\/doc\/D' +
        'evelopment\/XML_Web_Service\/Version_2","Category":"Music"},{"AP' +
        'I":"Musixmatch","Description":"Music","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/developer.musixmatch.com\/' +
        '","Category":"Music"},{"API":"Napster","Description":"Music","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/develop' +
        'er.napster.com\/api\/v2.2","Category":"Music"},{"API":"Openwhyd"' +
        ',"Description":"Download curated playlists of streaming tracks (' +
        'YouTube, SoundCloud, etc...)","Auth":"","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/openwhyd.github.io\/openwhyd\/API","Category"' +
        ':"Music"},{"API":"Phishin","Description":"A web-based archive of' +
        ' legal live audio recordings of the improvisational rock band Ph' +
        'ish","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'phish.in\/api-docs","Category":"Music"},{"API":"Radio Browser","' +
        'Description":"List of internet radio stations","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/api.radio-browser.info\/","' +
        'Category":"Music"},{"API":"Songkick","Description":"Music Events' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/www.songkick.com\/developer\/","Category":"Music"},{"API":"Son' +
        'glink \/ Odesli","Description":"Get all the services on which a ' +
        'song is available","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/www.notion.so\/API-d0ebe08a5e304a55928405eb682f67' +
        '41","Category":"Music"},{"API":"Songsterr","Description":"Provid' +
        'es guitar, bass and drums tabs and chords","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/www.songsterr.com\/a\/wa\/a' +
        'pi\/","Category":"Music"},{"API":"SoundCloud","Description":"Wit' +
        'h SoundCloud API you can build applications that will give more ' +
        'power to control your content","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/developers.soundcloud.com\/docs\/a' +
        'pi\/guide","Category":"Music"},{"API":"Spotify","Description":"V' +
        'iew Spotify music catalog, manage users'#39' libraries, get recommen' +
        'dations and more","Auth":"OAuth","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/beta.developer.spotify.com\/documentation\/web-' +
        'api\/","Category":"Music"},{"API":"TasteDive","Description":"Sim' +
        'ilar artist API (also works for movies and TV shows)","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tastedive.' +
        'com\/read\/api","Category":"Music"},{"API":"TheAudioDB","Descrip' +
        'tion":"Music","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.theaudiodb.com\/api_guide.php","Category":"Mus' +
        'ic"},{"API":"Vagalume","Description":"Crowdsourced lyrics and mu' +
        'sic knowledge","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/api.vagalume.com.br\/docs\/","Category":"Music"},' +
        '{"API":"apilayer mediastack","Description":"Free, Simple REST AP' +
        'I for Live News & Blog Articles","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/mediastack.com\/","Category":"N' +
        'ews"},{"API":"Associated Press","Description":"Search for news a' +
        'nd metadata from Associated Press","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/developer.ap.org\/","Category' +
        '":"News"},{"API":"Chronicling America","Description":"Provides a' +
        'ccess to millions of pages of historic US newspapers from the Li' +
        'brary of Congress","Auth":"","HTTPS":false,"Cors":"unknown","Lin' +
        'k":"http:\/\/chroniclingamerica.loc.gov\/about\/api\/","Category' +
        '":"News"},{"API":"Currents","Description":"Latest news published' +
        ' in various news sources, blogs and forums","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/currentsapi.services\/",' +
        '"Category":"News"},{"API":"Feedbin","Description":"RSS reader","' +
        'Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gi' +
        'thub.com\/feedbin\/feedbin-api","Category":"News"},{"API":"GNews' +
        '","Description":"Search for news from various sources","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/gnews.io\/","' +
        'Category":"News"},{"API":"Graphs for Coronavirus","Description":' +
        '"Each Country separately and Worldwide Graphs for Coronavirus. D' +
        'aily updates","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/corona.dnsforfamily.com\/api.txt","Category":"News"},{"API":' +
        '"Inshorts News","Description":"Provides news from inshorts","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com' +
        '\/cyberboysumanjay\/Inshorts-News-API","Category":"News"},{"API"' +
        ':"MarketAux","Description":"Live stock market news with tagged t' +
        'ickers + sentiment and stats JSON API","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.marketaux.com\/","Categor' +
        'y":"News"},{"API":"New York Times","Description":"The New York T' +
        'imes Developer Network","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/developer.nytimes.com\/","Category":"New' +
        's"},{"API":"News","Description":"Headlines currently published o' +
        'n a range of news sources and blogs","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/newsapi.org\/","Category":"' +
        'News"},{"API":"NewsData","Description":"News data API for live-b' +
        'reaking news and headlines from reputed  news sources","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/newsdata.' +
        'io\/docs","Category":"News"},{"API":"NewsX","Description":"Get o' +
        'r Search Latest Breaking News with ML Powered Summaries '#240#376#164#8211'","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ra' +
        'pidapi.com\/machaao-inc-machaao-inc-default\/api\/newsx\/","Cate' +
        'gory":"News"},{"API":"NPR One","Description":"Personalized news ' +
        'listening experience from NPR","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"unknown","Link":"http:\/\/dev.npr.org\/api\/","Category":"New' +
        's"},{"API":"Spaceflight News","Description":"Spaceflight related' +
        ' news '#240#376#353#8364'","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/spaceflightnewsapi.net","Category":"News"},{"API":"The Guardia' +
        'n","Description":"Access all the content the Guardian creates, c' +
        'ategorised by tags and section","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"http:\/\/open-platform.theguardian.com\/",' +
        '"Category":"News"},{"API":"The Old Reader","Description":"RSS re' +
        'ader","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/github.com\/theoldreader\/api","Category":"News"},{"API":"' +
        'TheNews","Description":"Aggregated headlines, top story and live' +
        ' news JSON API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/www.thenewsapi.com\/","Category":"News"},{"API":"Tro' +
        've","Description":"Search through the National Library of Austra' +
        'lia collection of 1000s of digitised newspapers","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/trove.nla.gov.a' +
        'u\/about\/create-something\/using-api","Category":"News"},{"API"' +
        ':"18F","Description":"Unofficial US Federal Government API Devel' +
        'opment","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/' +
        '\/18f.github.io\/API-All-the-X\/","Category":"Open Data"},{"API"' +
        ':"API Setu","Description":"An Indian Government platform that pr' +
        'ovides a lot of APIS for KYC, business, education & employment",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.apiset' +
        'u.gov.in\/","Category":"Open Data"},{"API":"Archive.org","Descri' +
        'ption":"The Internet Archive","Auth":"","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/archive.readme.io\/docs","Category":"Open Dat' +
        'a"},{"API":"Black History Facts","Description":"Contribute or se' +
        'arch one of the largest black history fact databases on the web"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www' +
        '.blackhistoryapi.io\/docs","Category":"Open Data"},{"API":"BotsA' +
        'rchive","Description":"JSON formatted details about Telegram Bot' +
        's available in database","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/botsarchive.com\/docs.html","Category":"Open ' +
        'Data"},{"API":"Callook.info","Description":"United States ham ra' +
        'dio callsigns","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/callook.info","Category":"Open Data"},{"API":"CARTO","D' +
        'escription":"Location Information Prediction","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/carto.com\/","Cate' +
        'gory":"Open Data"},{"API":"CollegeScoreCard.ed.gov","Description' +
        '":"Data on higher education institutions in the United States","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/college' +
        'scorecard.ed.gov\/data\/","Category":"Open Data"},{"API":"Enigma' +
        ' Public","Description":"Broadest collection of public data","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/develope' +
        'rs.enigma.com\/docs","Category":"Open Data"},{"API":"French Addr' +
        'ess Search","Description":"Address search via the French Governm' +
        'ent","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/g' +
        'eo.api.gouv.fr\/adresse","Category":"Open Data"},{"API":"GENESIS' +
        '","Description":"Federal Statistical Office Germany","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.destatis' +
        '.de\/EN\/Service\/OpenData\/api-webservice.html","Category":"Ope' +
        'n Data"},{"API":"Joshua Project","Description":"People groups of' +
        ' the world with the fewest followers of Christ","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.joshuaprojec' +
        't.net\/","Category":"Open Data"},{"API":"Kaggle","Description":"' +
        'Create and interact with Datasets, Notebooks, and connect with K' +
        'aggle","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/www.kaggle.com\/docs\/api","Category":"Open Data"},{"API"' +
        ':"LinkPreview","Description":"Get JSON formatted summary with ti' +
        'tle, description and preview image for any requested URL","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.linkpr' +
        'eview.net","Category":"Open Data"},{"API":"Lowy Asia Power Index' +
        '","Description":"Get measure resources and influence to rank the' +
        ' relative power of states in Asia","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/github.com\/0x0is1\/lowy-index-api-' +
        'docs","Category":"Open Data"},{"API":"Microlink.io","Description' +
        '":"Extract structured data from any website","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/microlink.io","Category":"Ope' +
        'n Data"},{"API":"Nasdaq Data Link","Description":"Stock market d' +
        'ata","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/docs.data.nasdaq.com\/","Category":"Open Data"},{"API":"Nob' +
        'el Prize","Description":"Open data about nobel prizes and events' +
        '","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.nobe' +
        'lprize.org\/about\/developer-zone-2\/","Category":"Open Data"},{' +
        '"API":"Open Data Minneapolis","Description":"Spatial (GIS) and n' +
        'on-spatial city data for Minneapolis","Auth":"","HTTPS":true,"Co' +
        'rs":"no","Link":"https:\/\/opendata.minneapolismn.gov\/","Catego' +
        'ry":"Open Data"},{"API":"openAFRICA","Description":"Large datase' +
        'ts repository of African open data","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/africaopendata.org\/","Category":"' +
        'Open Data"},{"API":"OpenCorporates","Description":"Data on corpo' +
        'rate entities and directors in many countries","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"http:\/\/api.opencorporates' +
        '.com\/documentation\/API-Reference","Category":"Open Data"},{"AP' +
        'I":"OpenSanctions","Description":"Data on international sanction' +
        's, crime and politically exposed persons","Auth":"","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/www.opensanctions.org\/docs\/api' +
        '\/","Category":"Open Data"},{"API":"PeakMetrics","Description":"' +
        'News articles and public datasets","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/rapidapi.com\/peakmetrics-pea' +
        'kmetrics-default\/api\/peakmetrics-news","Category":"Open Data"}' +
        ',{"API":"Recreation Information Database","Description":"Recreat' +
        'ional areas, federal lands, historic sites, museums, and other a' +
        'ttractions\/resources(US)","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/ridb.recreation.gov\/","Category":"Op' +
        'en Data"},{"API":"Scoop.it","Description":"Content Curation Serv' +
        'ice","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http' +
        ':\/\/www.scoop.it\/dev","Category":"Open Data"},{"API":"Socrata"' +
        ',"Description":"Access to Open Data from Governments, Non-profit' +
        's and NGOs around the world","Auth":"OAuth","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/dev.socrata.com\/","Category":"Open Data' +
        '"},{"API":"Teleport","Description":"Quality of Life Data","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.t' +
        'eleport.org\/","Category":"Open Data"},{"API":"Ume'#195#165' Open Data",' +
        '"Description":"Open data of the city Ume'#195#165' in northen Sweden","A' +
        'uth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/opendata.ume' +
        'a.se\/api\/","Category":"Open Data"},{"API":"Universities List",' +
        '"Description":"University names, countries and domains","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/Hi' +
        'po\/university-domains-list","Category":"Open Data"},{"API":"Uni' +
        'versity of Oslo","Description":"Courses, lecture videos, detaile' +
        'd information for courses etc. for the University of Oslo (Norwa' +
        'y)","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/da' +
        'ta.uio.no\/","Category":"Open Data"},{"API":"UPC database","Desc' +
        'ription":"More than 1.5 million barcode numbers from all around ' +
        'the world","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/upcdatabase.org\/api","Category":"Open Data"},{"API":' +
        '"Urban Observatory","Description":"The largest set of publicly a' +
        'vailable real time urban data in the UK","Auth":"","HTTPS":false' +
        ',"Cors":"no","Link":"https:\/\/urbanobservatory.ac.uk","Category' +
        '":"Open Data"},{"API":"Wikidata","Description":"Collaboratively ' +
        'edited knowledge base operated by the Wikimedia Foundation","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.w' +
        'ikidata.org\/w\/api.php?action=help","Category":"Open Data"},{"A' +
        'PI":"Wikipedia","Description":"Mediawiki Encyclopedia","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.mediawiki.o' +
        'rg\/wiki\/API:Main_page","Category":"Open Data"},{"API":"Yelp","' +
        'Description":"Find Local Business","Auth":"OAuth","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.yelp.com\/developers\/docu' +
        'mentation\/v3","Category":"Open Data"},{"API":"Countly","Descrip' +
        'tion":"Countly web analytics","Auth":"","HTTPS":false,"Cors":"un' +
        'known","Link":"https:\/\/api.count.ly\/reference","Category":"Op' +
        'en Source Projects"},{"API":"Creative Commons Catalog","Descript' +
        'ion":"Search among openly licensed and public domain works","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.creat' +
        'ivecommons.engineering\/","Category":"Open Source Projects"},{"A' +
        'PI":"Datamuse","Description":"Word-finding query engine","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.datamuse.' +
        'com\/api\/","Category":"Open Source Projects"},{"API":"Drupal.or' +
        'g","Description":"Drupal.org","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/www.drupal.org\/drupalorg\/docs\/api","C' +
        'ategory":"Open Source Projects"},{"API":"Evil Insult Generator",' +
        '"Description":"Evil Insults","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/evilinsult.com\/api","Category":"Open Source ' +
        'Projects"},{"API":"GitHub Contribution Chart Generator","Descrip' +
        'tion":"Create an image of your GitHub contributions","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/github-contributions.' +
        'vercel.app","Category":"Open Source Projects"},{"API":"GitHub Re' +
        'adMe Stats","Description":"Add dynamically generated statistics ' +
        'to your GitHub profile ReadMe","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/github.com\/anuraghazra\/github-readme-stat' +
        's","Category":"Open Source Projects"},{"API":"Metabase","Descrip' +
        'tion":"An open source Business Intelligence server to share data' +
        ' and analytics inside your company","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.metabase.com\/","Category":"Open S' +
        'ource Projects"},{"API":"Shields","Description":"Concise, consis' +
        'tent, and legible badges in SVG and raster format","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/shields.io\/","Cate' +
        'gory":"Open Source Projects"},{"API":"EPO","Description":"Europe' +
        'an patent search system api","Auth":"OAuth","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/developers.epo.org\/","Category":"Pa' +
        'tent"},{"API":"PatentsView ","Description":"API is intended to e' +
        'xplore and visualize trends\/patterns across the US innovation l' +
        'andscape","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/patentsview.org\/apis\/purpose","Category":"Patent"},{"API":' +
        '"TIPO","Description":"Taiwan patent search system api","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tiponet.t' +
        'ipo.gov.tw\/Gazette\/OpenData\/OD\/OD05.aspx?QryDS=API00","Categ' +
        'ory":"Patent"},{"API":"USPTO","Description":"USA patent api serv' +
        'ices","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'www.uspto.gov\/learning-and-resources\/open-data-and-mobility","' +
        'Category":"Patent"},{"API":"Advice Slip","Description":"Generate' +
        ' random advice slips","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"http:\/\/api.adviceslip.com\/","Category":"Personality"},{' +
        '"API":"Biriyani As A Service","Description":"Biriyani images pla' +
        'ceholder","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/b' +
        'iriyani.anoram.com\/","Category":"Personality"},{"API":"Dev.to",' +
        '"Description":"Access Forem articles, users and other resources ' +
        'via API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/developers.forem.com\/api","Category":"Personality"},{"' +
        'API":"Dictum","Description":"API to get access to the collection' +
        ' of the most inspiring expressions of mankind","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/github.com\/fisenkodv\/' +
        'dictum","Category":"Personality"},{"API":"FavQs.com","Descriptio' +
        'n":"FavQs allows you to collect, discover and share your favorit' +
        'e quotes","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/favqs.com\/api","Category":"Personality"},{"API":"FOAA' +
        'S","Description":"Fuck Off As A Service","Auth":"","HTTPS":false' +
        ',"Cors":"unknown","Link":"http:\/\/www.foaas.com\/","Category":"' +
        'Personality"},{"API":"Forismatic","Description":"Inspirational Q' +
        'uotes","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\' +
        '/forismatic.com\/en\/api\/","Category":"Personality"},{"API":"ic' +
        'anhazdadjoke","Description":"The largest selection of dad jokes ' +
        'on the internet","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/icanhazdadjoke.com\/api","Category":"Personality"},{"' +
        'API":"Inspiration","Description":"Motivational and Inspirational' +
        ' quotes","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/i' +
        'nspiration.goprogram.ai\/docs\/","Category":"Personality"},{"API' +
        '":"kanye.rest","Description":"REST API for random Kanye West quo' +
        'tes","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/kanye' +
        '.rest","Category":"Personality"},{"API":"kimiquotes","Descriptio' +
        'n":"Team radio and interview quotes by Finnish F1 legend Kimi R'#195 +
        #164'ikk'#195#182'nen","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/kimiquotes.herokuapp.com\/doc","Category":"Personality"},{"API"' +
        ':"Medium","Description":"Community of readers and writers offeri' +
        'ng unique perspectives on ideas","Auth":"OAuth","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/github.com\/Medium\/medium-api-d' +
        'ocs","Category":"Personality"},{"API":"Programming Quotes","Desc' +
        'ription":"Programming Quotes API for open source projects","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\' +
        '/skolakoda\/programming-quotes-api","Category":"Personality"},{"' +
        'API":"Quotable Quotes","Description":"Quotable is a free, open s' +
        'ource quotations API","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/github.com\/lukePeavey\/quotable","Category":"Pe' +
        'rsonality"},{"API":"Quote Garden","Description":"REST API for mo' +
        're than 5000 famous quotes","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/pprathameshmore.github.io\/QuoteGarden\/",' +
        '"Category":"Personality"},{"API":"quoteclear","Description":"Eve' +
        'r-growing list of James Clear quotes from the 3-2-1 Newsletter",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/quoteclear' +
        '.web.app\/","Category":"Personality"},{"API":"Quotes on Design",' +
        '"Description":"Inspirational Quotes","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/quotesondesign.com\/api\/","Categ' +
        'ory":"Personality"},{"API":"Stoicism Quote","Description":"Quote' +
        's about Stoicism","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/github.com\/tlcheah2\/stoic-quote-lambda-public-api"' +
        ',"Category":"Personality"},{"API":"They Said So Quotes","Descrip' +
        'tion":"Quotes Trusted by many fortune brands around the world","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/theysai' +
        'dso.com\/api\/","Category":"Personality"},{"API":"Traitify","Des' +
        'cription":"Assess, collect and analyze Personality","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/app.traitify.com\/' +
        'developer","Category":"Personality"},{"API":"Udemy(instructor)",' +
        '"Description":"API for instructors on Udemy","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/www.udemy.com\/deve' +
        'lopers\/instructor\/","Category":"Personality"},{"API":"Vadivelu' +
        ' HTTP Codes","Description":"On demand HTTP Codes with images","A' +
        'uth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/vadivelu.anor' +
        'am.com\/","Category":"Personality"},{"API":"Zen Quotes","Descrip' +
        'tion":"Large collection of Zen quotes for inspiration","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/zenquotes.io\/","Ca' +
        'tegory":"Personality"},{"API":"Abstract Phone Validation","Descr' +
        'iption":"Validate phone numbers globally","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/www.abstractapi.com\/phone' +
        '-validation-api","Category":"Phone"},{"API":"apilayer numverify"' +
        ',"Description":"Phone number validation","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/numverify.com","Categor' +
        'y":"Phone"},{"API":"Cloudmersive Validate","Description":"Valida' +
        'te international phone numbers","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/cloudmersive.com\/phone-number-valid' +
        'ation-API","Category":"Phone"},{"API":"Phone Specification","Des' +
        'cription":"Rest Api for Phone specifications","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/github.com\/azharimm\/phone-' +
        'specs-api","Category":"Phone"},{"API":"Veriphone","Description":' +
        '"Phone number validation & carrier lookup","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/veriphone.io","Category":' +
        '"Phone"},{"API":"apilayer screenshotlayer","Description":"URL 2 ' +
        'Image","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/screenshotlayer.com","Category":"Photography"},{"API":"APITempl' +
        'ate.io","Description":"Dynamically generate images and PDFs from' +
        ' templates with a simple API","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/apitemplate.io","Category":"Photograph' +
        'y"},{"API":"Bruzu","Description":"Image generation with query st' +
        'ring","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/docs.bruzu.com","Category":"Photography"},{"API":"CheetahO","D' +
        'escription":"Photo optimization and resize","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/cheetaho.com\/docs\/' +
        'getting-started\/","Category":"Photography"},{"API":"Dagpi","Des' +
        'cription":"Image manipulation and processing","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/dagpi.xyz","Catego' +
        'ry":"Photography"},{"API":"Duply","Description":"Generate, Edit,' +
        ' Scale and Manage Images and Videos Smarter & Faster","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/duply.co\/docs' +
        '#getting-started-api","Category":"Photography"},{"API":"DynaPict' +
        'ures","Description":"Generate Hundreds of Personalized Images in' +
        ' Minutes","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/dynapictures.com\/docs\/","Category":"Photography"},{"API"' +
        ':"Flickr","Description":"Flickr Services","Auth":"OAuth","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.flickr.com\/service' +
        's\/api\/","Category":"Photography"},{"API":"Getty Images","Descr' +
        'iption":"Build applications using the world'#39's most powerful imag' +
        'ery","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"http:\' +
        '/\/developers.gettyimages.com\/en\/","Category":"Photography"},{' +
        '"API":"Gfycat","Description":"Jiffier GIFs","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/developers.gfycat.com' +
        '\/api\/","Category":"Photography"},{"API":"Giphy","Description":' +
        '"Get all your gifs","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developers.giphy.com\/docs\/","Category":"Ph' +
        'otography"},{"API":"Google Photos","Description":"Integrate Goog' +
        'le Photos with your apps or devices","Auth":"OAuth","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/developers.google.com\/photo' +
        's","Category":"Photography"},{"API":"Image Upload","Description"' +
        ':"Image Optimization","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/apilayer.com\/marketplace\/image_upload-ap' +
        'i","Category":"Photography"},{"API":"Imgur","Description":"Image' +
        's","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/apidocs.imgur.com\/","Category":"Photography"},{"API":"Imsea",' +
        '"Description":"Free image search","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/imsea.herokuapp.com\/","Category":"P' +
        'hotography"},{"API":"Lorem Picsum","Description":"Images from Un' +
        'splash","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/picsum.photos\/","Category":"Photography"},{"API":"ObjectCut",' +
        '"Description":"Image Background removal","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/objectcut.com\/","Category"' +
        ':"Photography"},{"API":"Pexels","Description":"Free Stock Photos' +
        ' and Videos","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/www.pexels.com\/api\/","Category":"Photography"},{"API"' +
        ':"PhotoRoom","Description":"Remove background from images","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.p' +
        'hotoroom.com\/api\/","Category":"Photography"},{"API":"Pixabay",' +
        '"Description":"Photography","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/pixabay.com\/sk\/service\/about\/api' +
        '\/","Category":"Photography"},{"API":"PlaceKeanu","Description":' +
        '"Resizable Keanu Reeves placeholder images with grayscale and yo' +
        'ung Keanu options","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/placekeanu.com\/","Category":"Photography"},{"API":' +
        '"Readme typing SVG","Description":"Customizable typing and delet' +
        'ing text SVG","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/github.com\/DenverCoder1\/readme-typing-svg","Category":' +
        '"Photography"},{"API":"Remove.bg","Description":"Image Backgroun' +
        'd removal","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.remove.bg\/api","Category":"Photography"},{"API":' +
        '"ReSmush.it","Description":"Photo optimization","Auth":"","HTTPS' +
        '":false,"Cors":"unknown","Link":"https:\/\/resmush.it\/api","Cat' +
        'egory":"Photography"},{"API":"shutterstock","Description":"Stock' +
        ' Photos and Videos","Auth":"OAuth","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/api-reference.shutterstock.com\/","Category":' +
        '"Photography"},{"API":"Sirv","Description":"Image management sol' +
        'utions like optimization, manipulation, hosting","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/apidocs.sirv.co' +
        'm\/","Category":"Photography"},{"API":"Unsplash","Description":"' +
        'Photography","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/unsplash.com\/developers","Category":"Photography"},' +
        '{"API":"Wallhaven","Description":"Wallpapers","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/wallhaven.cc\/help' +
        '\/api","Category":"Photography"},{"API":"Webdam","Description":"' +
        'Images","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/www.damsuccess.com\/hc\/en-us\/articles\/202134055-REST-A' +
        'PI","Category":"Photography"},{"API":"Codeforces","Description":' +
        '"Get access to Codeforces data","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/codeforces.com\/apiHelp","Catego' +
        'ry":"Programming"},{"API":"Hackerearth","Description":"For compi' +
        'ling and running code in several languages","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/www.hackerearth.com\' +
        '/docs\/wiki\/developers\/v4\/","Category":"Programming"},{"API":' +
        '"Judge0 CE","Description":"Online code execution system","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ce.judg' +
        'e0.com\/","Category":"Programming"},{"API":"KONTESTS","Descripti' +
        'on":"For upcoming and ongoing competitive coding contests","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/kontests.ne' +
        't\/api","Category":"Programming"},{"API":"Mintlify","Description' +
        '":"For programmatically generating documentation for code","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.mint' +
        'lify.com","Category":"Programming"},{"API":"arcsecond.io","Descr' +
        'iption":"Multiple astronomy data sources","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/api.arcsecond.io\/","Categor' +
        'y":"Science & Math"},{"API":"arXiv","Description":"Curated resea' +
        'rch-sharing platform: physics, mathematics, quantitative finance' +
        ', and economics","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/arxiv.org\/help\/api\/user-manual","Category":"Scienc' +
        'e & Math"},{"API":"CORE","Description":"Access the world'#39's Open ' +
        'Access research papers","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/core.ac.uk\/services#api","Category":"Sc' +
        'ience & Math"},{"API":"GBIF","Description":"Global Biodiversity ' +
        'Information Facility","Auth":"","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/www.gbif.org\/developer\/summary","Category":"Scienc' +
        'e & Math"},{"API":"iDigBio","Description":"Access millions of mu' +
        'seum specimens from organizations around the world","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/idigbi' +
        'o\/idigbio-search-api\/wiki","Category":"Science & Math"},{"API"' +
        ':"inspirehep.net","Description":"High Energy Physics info. syste' +
        'm","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/git' +
        'hub.com\/inspirehep\/rest-api-doc","Category":"Science & Math"},' +
        '{"API":"isEven (humor)","Description":"Check if a number is even' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/isev' +
        'enapi.xyz\/","Category":"Science & Math"},{"API":"ISRO","Descrip' +
        'tion":"ISRO Space Crafts Information","Auth":"","HTTPS":true,"Co' +
        'rs":"no","Link":"https:\/\/isro.vercel.app","Category":"Science ' +
        '& Math"},{"API":"ITIS","Description":"Integrated Taxonomic Infor' +
        'mation System","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/www.itis.gov\/ws_description.html","Category":"Science ' +
        '& Math"},{"API":"Launch Library 2","Description":"Spaceflight la' +
        'unches and events database","Auth":"","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/thespacedevs.com\/llapi","Category":"Science &' +
        ' Math"},{"API":"Materials Platform for Data Science","Descriptio' +
        'n":"Curated experimental data for materials science","Auth":"api' +
        'Key","HTTPS":true,"Cors":"no","Link":"https:\/\/mpds.io","Catego' +
        'ry":"Science & Math"},{"API":"Minor Planet Center","Description"' +
        ':"Asterank.com Information","Auth":"","HTTPS":false,"Cors":"unkn' +
        'own","Link":"http:\/\/www.asterank.com\/mpc","Category":"Science' +
        ' & Math"},{"API":"NASA","Description":"NASA data, including imag' +
        'ery","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/api.na' +
        'sa.gov","Category":"Science & Math"},{"API":"NASA ADS","Descript' +
        'ion":"NASA Astrophysics Data System","Auth":"OAuth","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/ui.adsabs.harvard.edu\/help\/api' +
        '\/api-docs.html","Category":"Science & Math"},{"API":"Newton","D' +
        'escription":"Symbolic and Arithmetic Math Calculator","Auth":"",' +
        '"HTTPS":true,"Cors":"no","Link":"https:\/\/newton.vercel.app","C' +
        'ategory":"Science & Math"},{"API":"Noctua","Description":"REST A' +
        'PI used to access NoctuaSky features","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/api.noctuasky.com\/api\/v1\/swag' +
        'gerdoc\/","Category":"Science & Math"},{"API":"Numbers","Descrip' +
        'tion":"Number of the day, random number, number facts and anythi' +
        'ng else you want to do with numbers","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"no","Link":"https:\/\/math.tools\/api\/numbers\/","Cat' +
        'egory":"Science & Math"},{"API":"Numbers","Description":"Facts a' +
        'bout numbers","Auth":"","HTTPS":false,"Cors":"no","Link":"http:\' +
        '/\/numbersapi.com","Category":"Science & Math"},{"API":"Ocean Fa' +
        'cts","Description":"Facts pertaining to the physical science of ' +
        'Oceanography","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/oceanfacts.herokuapp.com\/","Category":"Science & Math"}' +
        ',{"API":"Open Notify","Description":"ISS astronauts, current loc' +
        'ation, etc","Auth":"","HTTPS":false,"Cors":"no","Link":"http:\/\' +
        '/open-notify.org\/Open-Notify-API\/","Category":"Science & Math"' +
        '},{"API":"Open Science Framework","Description":"Repository and ' +
        'archive for study designs, research materials, data, manuscripts' +
        ', etc","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/developer.osf.io","Category":"Science & Math"},{"API":"Purple A' +
        'ir","Description":"Real Time Air Quality Monitoring","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www2.purpleair.co' +
        'm\/","Category":"Science & Math"},{"API":"Remote Calc","Descript' +
        'ion":"Decodes base64 encoding and parses it to return a solution' +
        ' to the calculation in JSON","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/github.com\/elizabethadegbaju\/remotecalc","C' +
        'ategory":"Science & Math"},{"API":"SHARE","Description":"A free,' +
        ' open, dataset about research and scholarly activities","Auth":"' +
        '","HTTPS":true,"Cors":"no","Link":"https:\/\/share.osf.io\/api\/' +
        'v2\/","Category":"Science & Math"},{"API":"SpaceX","Description"' +
        ':"Company, vehicle, launchpad and launch data","Auth":"","HTTPS"' +
        ':true,"Cors":"no","Link":"https:\/\/github.com\/r-spacex\/SpaceX' +
        '-API","Category":"Science & Math"},{"API":"SpaceX","Description"' +
        ':"GraphQL, Company, Ships, launchpad and launch data","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.spacex.land\' +
        '/graphql\/","Category":"Science & Math"},{"API":"Sunrise and Sun' +
        'set","Description":"Sunset and sunrise times for a given latitud' +
        'e and longitude","Auth":"","HTTPS":true,"Cors":"no","Link":"http' +
        's:\/\/sunrise-sunset.org\/api","Category":"Science & Math"},{"AP' +
        'I":"Times Adder","Description":"With this API you can add each o' +
        'f the times introduced in the array sended","Auth":"","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/github.com\/FranP-code\/API-Tim' +
        'es-Adder","Category":"Science & Math"},{"API":"TLE","Description' +
        '":"Satellite information","Auth":"","HTTPS":true,"Cors":"no","Li' +
        'nk":"https:\/\/tle.ivanstanojevic.me\/#\/docs","Category":"Scien' +
        'ce & Math"},{"API":"USGS Earthquake Hazards Program","Descriptio' +
        'n":"Earthquakes data real-time","Auth":"","HTTPS":true,"Cors":"n' +
        'o","Link":"https:\/\/earthquake.usgs.gov\/fdsnws\/event\/1\/","C' +
        'ategory":"Science & Math"},{"API":"USGS Water Services","Descrip' +
        'tion":"Water quality and level info for rivers and lakes","Auth"' +
        ':"","HTTPS":true,"Cors":"no","Link":"https:\/\/waterservices.usg' +
        's.gov\/","Category":"Science & Math"},{"API":"World Bank","Descr' +
        'iption":"World Data","Auth":"","HTTPS":true,"Cors":"no","Link":"' +
        'https:\/\/datahelpdesk.worldbank.org\/knowledgebase\/topics\/125' +
        '589","Category":"Science & Math"},{"API":"xMath","Description":"' +
        'Random mathematical expressions","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/x-math.herokuapp.com\/","Category":"Scien' +
        'ce & Math"},{"API":"Application Environment Verification","Descr' +
        'iption":"Android library and API to verify the safety of user de' +
        'vices, detect rooted devices and other risks","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/fingerprin' +
        'tjs\/aev","Category":"Security"},{"API":"BinaryEdge","Descriptio' +
        'n":"Provide access to BinaryEdge 40fy scanning platform","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.binary' +
        'edge.io\/api-v2.html","Category":"Security"},{"API":"BitWarden",' +
        '"Description":"Best open-source password manager","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/bitwarden.com\/' +
        'help\/api\/","Category":"Security"},{"API":"Botd","Description":' +
        '"Botd is a browser library for JavaScript bot detection","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\' +
        '/fingerprintjs\/botd","Category":"Security"},{"API":"Bugcrowd","' +
        'Description":"Bugcrowd API for interacting and tracking the repo' +
        'rted issues programmatically","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/docs.bugcrowd.com\/api\/getting-st' +
        'arted\/","Category":"Security"},{"API":"Censys","Description":"S' +
        'earch engine for Internet connected host and devices","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"no","Link":"https:\/\/search.censys.i' +
        'o\/api","Category":"Security"},{"API":"Classify","Description":"' +
        'Encrypting & decrypting text messages","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/classify-web.herokuapp.com\/#\/api"' +
        ',"Category":"Security"},{"API":"Complete Criminal Checks","Descr' +
        'iption":"Provides data of offenders from all U.S. States and Pur' +
        'eto Rico","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/completecriminalchecks.com\/Developers","Category":"Securi' +
        'ty"},{"API":"CRXcavator","Description":"Chrome extension risk sc' +
        'oring","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/crxcavator.io\/apidocs","Category":"Security"},{"API":"De' +
        'hash.lt","Description":"Hash decryption MD5, SHA1, SHA3, SHA256,' +
        ' SHA384, SHA512","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/github.com\/Dehash-lt\/api","Category":"Security"},{"' +
        'API":"EmailRep","Description":"Email address threat and risk pre' +
        'diction","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/docs.emailrep.io\/","Category":"Security"},{"API":"Escape","D' +
        'escription":"An API for escaping different kind of queries","Aut' +
        'h":"","HTTPS":true,"Cors":"no","Link":"https:\/\/github.com\/pol' +
        'arspetroll\/EscapeAPI","Category":"Security"},{"API":"FilterList' +
        's","Description":"Lists of filters for adblockers and firewalls"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/filte' +
        'rlists.com","Category":"Security"},{"API":"FingerprintJS Pro","D' +
        'escription":"Fraud detection API offering highly accurate browse' +
        'r fingerprinting","Auth":"apiKey","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/dev.fingerprintjs.com\/docs","Category":"Security"' +
        '},{"API":"FraudLabs Pro","Description":"Screen order information' +
        ' using AI to detect frauds","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/www.fraudlabspro.com\/developer\/api' +
        '\/screen-order","Category":"Security"},{"API":"FullHunt","Descri' +
        'ption":"Searchable attack surface database of the entire interne' +
        't","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/api-docs.fullhunt.io\/#introduction","Category":"Security"},{' +
        '"API":"GitGuardian","Description":"Scan files for secrets (API K' +
        'eys, database credentials)","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"no","Link":"https:\/\/api.gitguardian.com\/doc","Category":"Sec' +
        'urity"},{"API":"GreyNoise","Description":"Query IPs in the GreyN' +
        'oise dataset and retrieve a subset of the full IP context data",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'docs.greynoise.io\/reference\/get_v3-community-ip","Category":"S' +
        'ecurity"},{"API":"HackerOne","Description":"The industry'#226#8364#8482's fir' +
        'st hacker API that helps increase productivity towards creative ' +
        'bug bounty hunting","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/api.hackerone.com\/","Category":"Security"},' +
        '{"API":"Hashable","Description":"A REST API to access high level' +
        ' cryptographic functions and methods","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/hashable.space\/pages\/api\/","Categ' +
        'ory":"Security"},{"API":"HaveIBeenPwned","Description":"Password' +
        's which have previously been exposed in data breaches","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/haveibeen' +
        'pwned.com\/API\/v3","Category":"Security"},{"API":"Intelligence ' +
        'X","Description":"Perform OSINT via Intelligence X","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/' +
        'IntelligenceX\/SDK\/blob\/master\/Intelligence%20X%20API.pdf","C' +
        'ategory":"Security"},{"API":"LoginRadius","Description":"Managed' +
        ' User Authentication Service","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.loginradius.com\/docs\/","Category' +
        '":"Security"},{"API":"Microsoft Security Response Center (MSRC)"' +
        ',"Description":"Programmatic interfaces to engage with the Micro' +
        'soft Security Response Center (MSRC)","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/msrc.microsoft.com\/report\/deve' +
        'loper","Category":"Security"},{"API":"Mozilla http scanner","Des' +
        'cription":"Mozilla observatory http scanner","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/github.com\/mozilla\/http' +
        '-observatory\/blob\/master\/httpobs\/docs\/api.md","Category":"S' +
        'ecurity"},{"API":"Mozilla tls scanner","Description":"Mozilla ob' +
        'servatory tls scanner","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/github.com\/mozilla\/tls-observatory#api-endpoi' +
        'nts","Category":"Security"},{"API":"National Vulnerability Datab' +
        'ase","Description":"U.S. National Vulnerability Database","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/nvd.nist.gov' +
        '\/vuln\/Data-Feeds\/JSON-feed-changelog","Category":"Security"},' +
        '{"API":"Passwordinator","Description":"Generate random passwords' +
        ' of varying complexities","Auth":"","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/github.com\/fawazsullia\/password-generator\/","' +
        'Category":"Security"},{"API":"PhishStats","Description":"Phishin' +
        'g database","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/phishstats.info\/","Category":"Security"},{"API":"Privacy.' +
        'com","Description":"Generate merchant-specific and one-time use ' +
        'credit card numbers that link back to your bank","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/privacy.com\/de' +
        'veloper\/docs","Category":"Security"},{"API":"Pulsedive","Descri' +
        'ption":"Scan, search and collect threat intelligence data in rea' +
        'l-time","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/pulsedive.com\/api\/","Category":"Security"},{"API":"Sec' +
        'urityTrails","Description":"Domain and IP related information su' +
        'ch as current and historical WHOIS and DNS records","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/securitytrai' +
        'ls.com\/corp\/apidocs","Category":"Security"},{"API":"Shodan","D' +
        'escription":"Search engine for Internet connected devices","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/devel' +
        'oper.shodan.io\/","Category":"Security"},{"API":"Spyse","Descrip' +
        'tion":"Access data on all Internet assets and build powerful att' +
        'ack surface management applications","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/spyse-dev.readme.io\/refere' +
        'nce\/quick-start","Category":"Security"},{"API":"Threat Jammer",' +
        '"Description":"Risk scoring service from curated threat intellig' +
        'ence data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/threatjammer.com\/docs\/index","Category":"Security"}' +
        ',{"API":"UK Police","Description":"UK Police data","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/data.police.uk\/doc' +
        's\/","Category":"Security"},{"API":"Virushee","Description":"Vir' +
        'ushee file\/data scanning","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/api.virushee.com\/","Category":"Security"},{"AP' +
        'I":"VulDB","Description":"VulDB API allows to initiate queries f' +
        'or one or more items along with transactional bots","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/vuldb.com\/?' +
        'doc.api","Category":"Security"},{"API":"Best Buy","Description":' +
        '"Products, Buying Options, Categories, Recommendations, Stores a' +
        'nd Commerce","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/bestbuyapis.github.io\/api-documentation\/#overview' +
        '","Category":"Shopping"},{"API":"Digi-Key","Description":"Retrie' +
        've price and inventory of electronic components as well as place' +
        ' orders","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/www.digikey.com\/en\/resources\/api-solutions","Category' +
        '":"Shopping"},{"API":"Dummy Products","Description":"An api to f' +
        'etch dummy e-commerce products JSON data with placeholder images' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/du' +
        'mmyproducts-api.herokuapp.com\/","Category":"Shopping"},{"API":"' +
        'eBay","Description":"Sell and Buy on eBay","Auth":"OAuth","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developer.ebay.com\/",' +
        '"Category":"Shopping"},{"API":"Etsy","Description":"Manage shop ' +
        'and interact with listings","Auth":"OAuth","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/www.etsy.com\/developers\/documentati' +
        'on\/getting_started\/api_basics","Category":"Shopping"},{"API":"' +
        'Flipkart Marketplace","Description":"Product listing management,' +
        ' Order Fulfilment in the Flipkart Marketplace","Auth":"OAuth","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/seller.flipkart.com\/a' +
        'pi-docs\/FMSAPI.html","Category":"Shopping"},{"API":"Lazada","De' +
        'scription":"Retrieve product ratings and seller performance metr' +
        'ics","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/open.lazada.com\/doc\/doc.htm","Category":"Shopping"},{"API' +
        '":"Mercadolibre","Description":"Manage sales, ads, products, ser' +
        'vices and Shops","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developers.mercadolibre.cl\/es_ar\/api-docs-es"' +
        ',"Category":"Shopping"},{"API":"Octopart","Description":"Electro' +
        'nic part data for manufacturing, design, and sourcing","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/octopart.' +
        'com\/api\/v4\/reference","Category":"Shopping"},{"API":"OLX Pola' +
        'nd","Description":"Integrate with local sites by posting, managi' +
        'ng adverts and communicating with OLX users","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/developer.olx.pl\/a' +
        'pi\/doc#section\/","Category":"Shopping"},{"API":"Rappi","Descri' +
        'ption":"Manage orders from Rappi'#39's app","Auth":"OAuth","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/dev-portal.rappi.com\/","' +
        'Category":"Shopping"},{"API":"Shopee","Description":"Shopee'#39's of' +
        'ficial API for integration of various services from Shopee","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/open' +
        '.shopee.com\/documents?version=1","Category":"Shopping"},{"API":' +
        '"Tokopedia","Description":"Tokopedia'#39's Official API for integrat' +
        'ion of various services from Tokopedia","Auth":"OAuth","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developer.tokopedia.com\/' +
        'openapi\/guide\/#\/","Category":"Shopping"},{"API":"WooCommerce"' +
        ',"Description":"WooCommerce REST APIS to create, read, update, a' +
        'nd delete data on wordpress website in JSON format","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/woocommerce.gith' +
        'ub.io\/woocommerce-rest-api-docs\/","Category":"Shopping"},{"API' +
        '":"4chan","Description":"Simple image-based bulletin board dedic' +
        'ated to a variety of topics","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/github.com\/4chan\/4chan-API","Category":"Soc' +
        'ial"},{"API":"Ayrshare","Description":"Social media APIs to post' +
        ', get analytics, and manage multiple users social media accounts' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/ww' +
        'w.ayrshare.com","Category":"Social"},{"API":"aztro","Description' +
        '":"Daily horoscope info for yesterday, today, and tomorrow","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/aztro.same' +
        'erkumar.website\/","Category":"Social"},{"API":"Blogger","Descri' +
        'ption":"The Blogger APIs allows client applications to view and ' +
        'update Blogger content","Auth":"OAuth","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/developers.google.com\/blogger\/","Catego' +
        'ry":"Social"},{"API":"Cisco Spark","Description":"Team Collabora' +
        'tion Software","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/developer.ciscospark.com","Category":"Social"},{"A' +
        'PI":"Dangerous Discord Database","Description":"Database of mali' +
        'cious Discord accounts","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/discord.riverside.rocks\/docs\/index.php' +
        '","Category":"Social"},{"API":"Discord","Description":"Make bots' +
        ' for Discord, integrate Discord onto an external platform","Auth' +
        '":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/discor' +
        'd.com\/developers\/docs\/intro","Category":"Social"},{"API":"Dis' +
        'qus","Description":"Communicate with Disqus data","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/disqus.com\/api' +
        '\/docs\/auth\/","Category":"Social"},{"API":"Doge-Meme","Descrip' +
        'tion":"Top meme posts from r\/dogecoin which include '#39'Meme'#39' flai' +
        'r","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.dog' +
        'e-meme.lol\/docs","Category":"Social"},{"API":"Facebook","Descri' +
        'ption":"Facebook Login, Share on FB, Social Plugins, Analytics a' +
        'nd more","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developers.facebook.com\/","Category":"Social"},{"API":"' +
        'Foursquare","Description":"Interact with Foursquare users and pl' +
        'aces (geolocation-based checkins, photos, tips, events, etc)","A' +
        'uth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dev' +
        'eloper.foursquare.com\/","Category":"Social"},{"API":"Fuck Off a' +
        's a Service","Description":"Asks someone to fuck off","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.foaas.com","' +
        'Category":"Social"},{"API":"Full Contact","Description":"Get Soc' +
        'ial Media profiles and contact Information","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.fullcontact.com\' +
        '/","Category":"Social"},{"API":"HackerNews","Description":"Socia' +
        'l news for CS and entrepreneurship","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/github.com\/HackerNews\/API","Cate' +
        'gory":"Social"},{"API":"Hashnode","Description":"A blogging plat' +
        'form built for developers","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/hashnode.com","Category":"Social"},{"API":"' +
        'Instagram","Description":"Instagram Login, Share on Instagram, S' +
        'ocial Plugins and more","Auth":"OAuth","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/www.instagram.com\/developer\/","Category' +
        '":"Social"},{"API":"Kakao","Description":"Kakao Login, Share on ' +
        'KakaoTalk, Social Plugins and more","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/developers.kakao.com\/","Cate' +
        'gory":"Social"},{"API":"Lanyard","Description":"Retrieve your pr' +
        'esence on Discord through an HTTP REST API or WebSocket","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/Phine' +
        'as\/lanyard","Category":"Social"},{"API":"Line","Description":"L' +
        'ine Login, Share on Line, Social Plugins and more","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.lin' +
        'e.biz\/","Category":"Social"},{"API":"LinkedIn","Description":"T' +
        'he foundation of all digital integrations with LinkedIn","Auth":' +
        '"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.mic' +
        'rosoft.com\/en-us\/linkedin\/?context=linkedin\/context","Catego' +
        'ry":"Social"},{"API":"Meetup.com","Description":"Data about Meet' +
        'ups from Meetup.com","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.meetup.com\/api\/guide","Category":"Soc' +
        'ial"},{"API":"Microsoft Graph","Description":"Access the data an' +
        'd intelligence in Microsoft 365, Windows 10, and Enterprise Mobi' +
        'lity","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/docs.microsoft.com\/en-us\/graph\/api\/overview","Category"' +
        ':"Social"},{"API":"NAVER","Description":"NAVER Login, Share on N' +
        'AVER, Social Plugins and more","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/developers.naver.com\/main\/","Cat' +
        'egory":"Social"},{"API":"Open Collective","Description":"Get Ope' +
        'n Collective data","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/docs.opencollective.com\/help\/developers\/api","Ca' +
        'tegory":"Social"},{"API":"Pinterest","Description":"The world'#39's ' +
        'catalog of ideas","Auth":"OAuth","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/developers.pinterest.com\/","Category":"Social"' +
        '},{"API":"Product Hunt","Description":"The best new products in ' +
        'tech","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/api.producthunt.com\/v2\/docs","Category":"Social"},{"API":' +
        '"Reddit","Description":"Homepage of the internet","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.reddit.com\' +
        '/dev\/api","Category":"Social"},{"API":"Revolt","Description":"R' +
        'evolt open source Discord alternative","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developers.revolt.chat\/a' +
        'pi\/","Category":"Social"},{"API":"Saidit","Description":"Open S' +
        'ource Reddit Clone","Auth":"OAuth","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/www.saidit.net\/dev\/api","Category":"Social"' +
        '},{"API":"Slack","Description":"Team Instant Messaging","Auth":"' +
        'OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.slack' +
        '.com\/","Category":"Social"},{"API":"TamTam","Description":"Bot ' +
        'API to interact with TamTam","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/dev.tamtam.chat\/","Category":"Soci' +
        'al"},{"API":"Telegram Bot","Description":"Simplified HTTP versio' +
        'n of the MTProto API for bots","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/core.telegram.org\/bots\/api","Ca' +
        'tegory":"Social"},{"API":"Telegram MTProto","Description":"Read ' +
        'and write Telegram data","Auth":"OAuth","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/core.telegram.org\/api#getting-started",' +
        '"Category":"Social"},{"API":"Telegraph","Description":"Create at' +
        'tractive blogs easily, to share","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/telegra.ph\/api","Category":"So' +
        'cial"},{"API":"TikTok","Description":"Fetches user info and user' +
        #39's video posts on TikTok platform","Auth":"OAuth","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/developers.tiktok.com\/doc\/lo' +
        'gin-kit-web","Category":"Social"},{"API":"Trash Nothing","Descri' +
        'ption":"A freecycling community with thousands of free items pos' +
        'ted every day","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/trashnothing.com\/developer","Category":"Social"},{"AP' +
        'I":"Tumblr","Description":"Read and write Tumblr Data","Auth":"O' +
        'Auth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.tumblr' +
        '.com\/docs\/en\/api\/v2","Category":"Social"},{"API":"Twitch","D' +
        'escription":"Game Streaming API","Auth":"OAuth","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/dev.twitch.tv\/docs","Category":' +
        '"Social"},{"API":"Twitter","Description":"Read and write Twitter' +
        ' data","Auth":"OAuth","HTTPS":true,"Cors":"no","Link":"https:\/\' +
        '/developer.twitter.com\/en\/docs","Category":"Social"},{"API":"v' +
        'k","Description":"Read and write vk data","Auth":"OAuth","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/vk.com\/dev\/sites","Ca' +
        'tegory":"Social"},{"API":"API-FOOTBALL","Description":"Get infor' +
        'mation about Football Leagues & Cups","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/www.api-football.com\/document' +
        'ation-v3","Category":"Sports & Fitness"},{"API":"ApiMedic","Desc' +
        'ription":"ApiMedic offers a medical symptom checker API primaril' +
        'y for patients","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/apimedic.com\/","Category":"Sports & Fitness"},{' +
        '"API":"balldontlie","Description":"Balldontlie provides access t' +
        'o stats data from the NBA","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/www.balldontlie.io","Category":"Sports & Fitnes' +
        's"},{"API":"Canadian Football League (CFL)","Description":"Offic' +
        'ial JSON API providing real-time league, team and player statist' +
        'ics about the CFL","Auth":"apiKey","HTTPS":true,"Cors":"no","Lin' +
        'k":"http:\/\/api.cfl.ca\/","Category":"Sports & Fitness"},{"API"' +
        ':"City Bikes","Description":"City Bikes around the world","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.citybik.' +
        'es\/v2\/","Category":"Sports & Fitness"},{"API":"Cloudbet","Desc' +
        'ription":"Official Cloudbet API provides real-time sports odds a' +
        'nd betting API to place bets programmatically","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/www.cloudbet.com\/api' +
        '\/","Category":"Sports & Fitness"},{"API":"CollegeFootballData.c' +
        'om","Description":"Unofficial detailed American college football' +
        ' statistics, records, and results API","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/collegefootballdata.com",' +
        '"Category":"Sports & Fitness"},{"API":"Ergast F1","Description":' +
        '"F1 data from the beginning of the world championships in 1950",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"http:\/\/ergast.' +
        'com\/mrd\/","Category":"Sports & Fitness"},{"API":"Fitbit","Desc' +
        'ription":"Fitbit Information","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/dev.fitbit.com\/","Category":"Sport' +
        's & Fitness"},{"API":"Football","Description":"A simple Open Sou' +
        'rce Football API to get squads'#226#8364#8482' stats, best scorers and more",' +
        '"Auth":"X-Mashape-Key","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/rapidapi.com\/GiulianoCrescimbeni\/api\/football98\/","Ca' +
        'tegory":"Sports & Fitness"},{"API":"Football (Soccer) Videos","D' +
        'escription":"Embed codes for goals and highlights from Premier L' +
        'eague, Bundesliga, Serie A and many more","Auth":"","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/www.scorebat.com\/video-api\/","' +
        'Category":"Sports & Fitness"},{"API":"Football Standings","Descr' +
        'iption":"Display football standings e.g epl, la liga, serie a et' +
        'c. The data is based on espn site","Auth":"","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/github.com\/azharimm\/football-standing' +
        's-api","Category":"Sports & Fitness"},{"API":"Football-Data","De' +
        'scription":"Football data with matches info, players, teams, and' +
        ' competitions","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.football-data.org","Category":"Sports ' +
        '& Fitness"},{"API":"JCDecaux Bike","Description":"JCDecaux'#39's sel' +
        'f-service bicycles","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developer.jcdecaux.com\/","Category":"Sports' +
        ' & Fitness"},{"API":"MLB Records and Stats","Description":"Curre' +
        'nt and historical MLB statistics","Auth":"","HTTPS":false,"Cors"' +
        ':"unknown","Link":"https:\/\/appac.github.io\/mlb-data-api-docs\' +
        '/","Category":"Sports & Fitness"},{"API":"NBA Data","Description' +
        '":"All NBA Stats DATA, Games, Livescore, Standings, Statistics",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'rapidapi.com\/api-sports\/api\/api-nba\/","Category":"Sports & F' +
        'itness"},{"API":"NBA Stats","Description":"Current and historica' +
        'l NBA Statistics","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/any-api.com\/nba_com\/nba_com\/docs\/API_Description' +
        '","Category":"Sports & Fitness"},{"API":"NHL Records and Stats",' +
        '"Description":"NHL historical data and statistics","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/gitlab.com\/dword4\' +
        '/nhlapi","Category":"Sports & Fitness"},{"API":"Oddsmagnet","Des' +
        'cription":"Odds history from multiple UK bookmakers","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/data.oddsmagnet.com",' +
        '"Category":"Sports & Fitness"},{"API":"OpenLigaDB","Description"' +
        ':"Crowd sourced sports league results","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/www.openligadb.de","Category":"Spor' +
        'ts & Fitness"},{"API":"Premier League Standings ","Description":' +
        '"All Current Premier League Standings and Statistics","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/rapidapi.c' +
        'om\/heisenbug\/api\/premier-league-live-scores\/","Category":"Sp' +
        'orts & Fitness"},{"API":"Sport Data","Description":"Get sports d' +
        'ata from all over the world","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/sportdataapi.com","Category":"Sport' +
        's & Fitness"},{"API":"Sport List & Data","Description":"List of ' +
        'and resources related to sports","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/developers.decathlon.com\/products\/sport' +
        's","Category":"Sports & Fitness"},{"API":"Sport Places","Descrip' +
        'tion":"Crowd-source sports places around the world","Auth":"","H' +
        'TTPS":true,"Cors":"no","Link":"https:\/\/developers.decathlon.co' +
        'm\/products\/sport-places","Category":"Sports & Fitness"},{"API"' +
        ':"Sport Vision","Description":"Identify sport, brands and gear i' +
        'n an image. Also does image sports captioning","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/developers.decathlon.' +
        'com\/products\/sport-vision","Category":"Sports & Fitness"},{"AP' +
        'I":"Sportmonks Cricket","Description":"Live cricket score, playe' +
        'r statistics and fantasy API","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/docs.sportmonks.com\/cricket\/","C' +
        'ategory":"Sports & Fitness"},{"API":"Sportmonks Football","Descr' +
        'iption":"Football score\/schedule, news api, tv channels, stats,' +
        ' history, display standing e.g. epl, la liga","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/docs.sportmonks.co' +
        'm\/football\/","Category":"Sports & Fitness"},{"API":"Squiggle",' +
        '"Description":"Fixtures, results and predictions for Australian ' +
        'Football League matches","Auth":"","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/api.squiggle.com.au","Category":"Sports & Fitness' +
        '"},{"API":"Strava","Description":"Connect with athletes, activit' +
        'ies and more","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/strava.github.io\/api\/","Category":"Sports & Fitne' +
        'ss"},{"API":"SuredBits","Description":"Query sports data, includ' +
        'ing teams, players, games, scores and statistics","Auth":"","HTT' +
        'PS":false,"Cors":"no","Link":"https:\/\/suredbits.com\/api\/","C' +
        'ategory":"Sports & Fitness"},{"API":"TheSportsDB","Description":' +
        '"Crowd-Sourced Sports Data and Artwork","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/www.thesportsdb.com\/api.php' +
        '","Category":"Sports & Fitness"},{"API":"Tredict","Description":' +
        '"Get and set activities, health data and more","Auth":"OAuth","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/www.tredict.com\/b' +
        'log\/oauth_docs\/","Category":"Sports & Fitness"},{"API":"Wger",' +
        '"Description":"Workout manager data as exercises, muscles or equ' +
        'ipment","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/wger.de\/en\/software\/api","Category":"Sports & Fitness' +
        '"},{"API":"Bacon Ipsum","Description":"A Meatier Lorem Ipsum Gen' +
        'erator","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/baconipsum.com\/json-api\/","Category":"Test Data"},{"API":"Di' +
        'cebear Avatars","Description":"Generate random pixel-art avatars' +
        '","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/avatars.d' +
        'icebear.com\/","Category":"Test Data"},{"API":"English Random Wo' +
        'rds","Description":"Generate English Random Words with Pronuncia' +
        'tion","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/rando' +
        'm-words-api.vercel.app\/word","Category":"Test Data"},{"API":"Fa' +
        'keJSON","Description":"Service to generate test and fake data","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/fakej' +
        'son.com","Category":"Test Data"},{"API":"FakerAPI","Description"' +
        ':"APIs collection to get fake data","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/fakerapi.it\/en","Category":"Test Data' +
        '"},{"API":"FakeStoreAPI","Description":"Fake store rest API for ' +
        'your e-commerce or shopping website prototype","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/fakestoreapi.com\/","Ca' +
        'tegory":"Test Data"},{"API":"GeneradorDNI","Description":"Data g' +
        'enerator API. Profiles, vehicles, banks and cards, etc","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.gene' +
        'radordni.es","Category":"Test Data"},{"API":"ItsThisForThat","De' +
        'scription":"Generate Random startup ideas","Auth":"","HTTPS":tru' +
        'e,"Cors":"no","Link":"https:\/\/itsthisforthat.com\/api.php","Ca' +
        'tegory":"Test Data"},{"API":"JSONPlaceholder","Description":"Fak' +
        'e data for testing and prototyping","Auth":"","HTTPS":false,"Cor' +
        's":"unknown","Link":"http:\/\/jsonplaceholder.typicode.com\/","C' +
        'ategory":"Test Data"},{"API":"Loripsum","Description":"The \"lor' +
        'em ipsum\" generator that doesn'#39't suck","Auth":"","HTTPS":false,' +
        '"Cors":"unknown","Link":"http:\/\/loripsum.net\/","Category":"Te' +
        'st Data"},{"API":"Mailsac","Description":"Disposable Email","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/mail' +
        'sac.com\/docs\/api","Category":"Test Data"},{"API":"Metaphorsum"' +
        ',"Description":"Generate demo paragraphs giving number of words ' +
        'and sentences","Auth":"","HTTPS":false,"Cors":"unknown","Link":"' +
        'http:\/\/metaphorpsum.com\/","Category":"Test Data"},{"API":"Moc' +
        'karoo","Description":"Generate fake data to JSON, CSV, TXT, SQL ' +
        'and XML","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/www.mockaroo.com\/docs","Category":"Test Data"},{"API":' +
        '"QuickMocker","Description":"API mocking tool to generate contex' +
        'tual, fake or random data","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/quickmocker.com","Category":"Test Data"},{"API"' +
        ':"Random Data","Description":"Random data generator","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/random-data-api.c' +
        'om","Category":"Test Data"},{"API":"Randommer","Description":"Ra' +
        'ndom data generator","Auth":"apiKey","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/randommer.io\/randommer-api","Category":"Test D' +
        'ata"},{"API":"RandomUser","Description":"Generates and list user' +
        ' data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/randomuser.me","Category":"Test Data"},{"API":"RoboHash","Descr' +
        'iption":"Generate random robot\/alien avatars","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/robohash.org\/","Catego' +
        'ry":"Test Data"},{"API":"Spanish random names","Description":"Ge' +
        'nerate spanish names (with gender) randomly","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/random-names-api.herokuap' +
        'p.com\/public","Category":"Test Data"},{"API":"Spanish random wo' +
        'rds","Description":"Generate spanish words randomly","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/palabras-aleatori' +
        'as-public-api.herokuapp.com","Category":"Test Data"},{"API":"Thi' +
        's Person Does not Exist","Description":"Generates real-life face' +
        's of people who do not exist","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/thispersondoesnotexist.com","Category":"' +
        'Test Data"},{"API":"Toolcarton","Description":"Generate random t' +
        'estimonial data","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/testimonialapi.toolcarton.com\/","Category":"Test Dat' +
        'a"},{"API":"UUID Generator","Description":"Generate UUIDs","Auth' +
        '":"","HTTPS":true,"Cors":"no","Link":"https:\/\/www.uuidtools.co' +
        'm\/docs","Category":"Test Data"},{"API":"What The Commit","Descr' +
        'iption":"Random commit message generator","Auth":"","HTTPS":fals' +
        'e,"Cors":"yes","Link":"http:\/\/whatthecommit.com\/index.txt","C' +
        'ategory":"Test Data"},{"API":"Yes No","Description":"Generate ye' +
        's or no randomly","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/yesno.wtf\/api","Category":"Test Data"},{"API":"Code' +
        ' Detection API","Description":"Detect, label, format and enrich ' +
        'the code in your app or in your data pipeline","Auth":"OAuth","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/codedetectionapi.r' +
        'untime.dev","Category":"Text Analysis"},{"API":"apilayer languag' +
        'elayer","Description":"Language Detection JSON API supporting 17' +
        '3 languages","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/languagelayer.com\/","Category":"Text Analysis"},{"A' +
        'PI":"Aylien Text Analysis","Description":"A collection of inform' +
        'ation retrieval and natural language APIs","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.aylien.com\/text' +
        'api\/#getting-started","Category":"Text Analysis"},{"API":"Cloud' +
        'mersive Natural Language Processing","Description":"Natural lang' +
        'uage processing and text analysis","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/www.cloudmersive.com\/nlp-api","C' +
        'ategory":"Text Analysis"},{"API":"Detect Language","Description"' +
        ':"Detects text language","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/detectlanguage.com\/","Category":"Text ' +
        'Analysis"},{"API":"ELI","Description":"Natural Language Processi' +
        'ng Tools for Thai Language","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/nlp.insightera.co.th\/docs\/v1.0","C' +
        'ategory":"Text Analysis"},{"API":"Google Cloud Natural","Descrip' +
        'tion":"Natural language understanding technology, including sent' +
        'iment, entity and syntax analysis","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/cloud.google.com\/natural-lan' +
        'guage\/docs\/","Category":"Text Analysis"},{"API":"Hirak OCR","D' +
        'escription":"Image to text -text recognition- from image more th' +
        'an 100 language, accurate, unlimited requests","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/ocr.hirak.site\/"' +
        ',"Category":"Text Analysis"},{"API":"Hirak Translation","Descrip' +
        'tion":"Translate between 21 of most used languages, accurate, un' +
        'limited requests","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/translate.hirak.site\/","Category":"Text Analy' +
        'sis"},{"API":"Lecto Translation","Description":"Translation API ' +
        'with free tier and reasonable prices","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/rapidapi.com\/lecto-lecto-defa' +
        'ult\/api\/lecto-translation\/","Category":"Text Analysis"},{"API' +
        '":"LibreTranslate","Description":"Translation tool with 17 avail' +
        'able languages","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/libretranslate.com\/docs","Category":"Text Analysis"},' +
        '{"API":"Semantria","Description":"Text Analytics with sentiment ' +
        'analysis, categorization & named entity extraction","Auth":"OAut' +
        'h","HTTPS":true,"Cors":"unknown","Link":"https:\/\/semantria.rea' +
        'dme.io\/docs","Category":"Text Analysis"},{"API":"Sentiment Anal' +
        'ysis","Description":"Multilingual sentiment analysis of texts fr' +
        'om different sources","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/www.meaningcloud.com\/developer\/sentiment-ana' +
        'lysis","Category":"Text Analysis"},{"API":"Tisane","Description"' +
        ':"Text Analytics with focus on detection of abusive content and ' +
        'law enforcement applications","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/tisane.ai\/","Category":"Text Analysis"' +
        '},{"API":"Watson Natural Language Understanding","Description":"' +
        'Natural language processing for advanced text analysis","Auth":"' +
        'OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/cloud.ibm' +
        '.com\/apidocs\/natural-language-understanding\/natural-language-' +
        'understanding","Category":"Text Analysis"},{"API":"Aftership","D' +
        'escription":"API to update, manage and track shipment efficientl' +
        'y","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/d' +
        'evelopers.aftership.com\/reference\/quick-start","Category":"Tra' +
        'cking"},{"API":"Correios","Description":"Integration to provide ' +
        'information and prepare shipments using Correio'#39's services","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/cws.' +
        'correios.com.br\/ajuda","Category":"Tracking"},{"API":"Pixela","' +
        'Description":"API for recording and tracking habits or effort, r' +
        'outines","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/pixe.la","Category":"Tracking"},{"API":"PostalPinCod' +
        'e","Description":"API for getting Pincode details in India","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"http:\/\/www.postalp' +
        'incode.in\/Api-Details","Category":"Tracking"},{"API":"Postmon",' +
        '"Description":"An API to query Brazilian ZIP codes and orders ea' +
        'sily, quickly and free","Auth":"","HTTPS":false,"Cors":"unknown"' +
        ',"Link":"http:\/\/postmon.com.br","Category":"Tracking"},{"API":' +
        '"PostNord","Description":"Provides information about parcels in ' +
        'transport for Sweden and Denmark","Auth":"apiKey","HTTPS":false,' +
        '"Cors":"unknown","Link":"https:\/\/developer.postnord.com\/api",' +
        '"Category":"Tracking"},{"API":"UPS","Description":"Shipment and ' +
        'Address information","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.ups.com\/upsdeveloperkit","Category":"T' +
        'racking"},{"API":"WeCanTrack","Description":"Automatically place' +
        ' subids in affiliate links to attribute affiliate conversions to' +
        ' click data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/docs.wecantrack.com","Category":"Tracking"},{"API":"Wha' +
        'tPulse","Description":"Small application that measures your keyb' +
        'oard\/mouse usage","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/developer.whatpulse.org\/#web-api","Category":"Trac' +
        'king"},{"API":"ADS-B Exchange","Description":"Access real-time a' +
        'nd historical data of any and all airborne aircraft","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.adsbexchange.' +
        'com\/data\/","Category":"Transportation"},{"API":"airportsapi","' +
        'Description":"Get name and website-URL for airports by ICAO code' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/airp' +
        'ort-web.appspot.com\/api\/docs\/","Category":"Transportation"},{' +
        '"API":"AIS Hub","Description":"Real-time data of any marine and ' +
        'inland vessel equipped with AIS tracking system","Auth":"apiKey"' +
        ',"HTTPS":false,"Cors":"unknown","Link":"http:\/\/www.aishub.net\' +
        '/api","Category":"Transportation"},{"API":"Amadeus for Developer' +
        's","Description":"Travel Search - Limited usage","Auth":"OAuth",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.amade' +
        'us.com\/self-service","Category":"Transportation"},{"API":"apila' +
        'yer aviationstack","Description":"Real-time Flight Status & Glob' +
        'al Aviation Data API","Auth":"OAuth","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/aviationstack.com\/","Category":"Transporta' +
        'tion"},{"API":"AviationAPI","Description":"FAA Aeronautical Char' +
        'ts and Publications, Airport Information, and Airport Weather","' +
        'Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/docs.aviatio' +
        'napi.com","Category":"Transportation"},{"API":"AZ511","Descripti' +
        'on":"Access traffic data from the ADOT API","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/www.az511.com\/devel' +
        'opers\/doc","Category":"Transportation"},{"API":"Bay Area Rapid ' +
        'Transit","Description":"Stations and predicted arrivals for BART' +
        '","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http:\/' +
        '\/api.bart.gov","Category":"Transportation"},{"API":"BC Ferries"' +
        ',"Description":"Sailing times and capacities for BC Ferries","Au' +
        'th":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.bcferries' +
        'api.ca","Category":"Transportation"},{"API":"BIC-Boxtech","Descr' +
        'iption":"Container technical detail for the global container fle' +
        'et","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/docs.bic-boxtech.org\/","Category":"Transportation"},{"API":"' +
        'BlaBlaCar","Description":"Search car sharing trips","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dev.blablaca' +
        'r.com","Category":"Transportation"},{"API":"Boston MBTA Transit"' +
        ',"Description":"Stations and predicted arrivals for MBTA","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.mb' +
        'ta.com\/developers\/v3-api","Category":"Transportation"},{"API":' +
        '"Community Transit","Description":"Transitland API","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/transi' +
        'tland\/transitland-datastore\/blob\/master\/README.md#api-endpoi' +
        'nts","Category":"Transportation"},{"API":"Compare Flight Prices"' +
        ',"Description":"API for comparing flight prices across platforms' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/rapidapi.com\/obryan-software-obryan-software-default\/api\/co' +
        'mpare-flight-prices\/","Category":"Transportation"},{"API":"CTS"' +
        ',"Description":"CTS Realtime API","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/api.cts-strasbourg.eu\/","Category' +
        '":"Transportation"},{"API":"Grab","Description":"Track deliverie' +
        's, ride fares, payments and loyalty points","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/developer.grab.com\/d' +
        'ocs\/","Category":"Transportation"},{"API":"GraphHopper","Descri' +
        'ption":"A-to-B routing with turn-by-turn instructions","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.grap' +
        'hhopper.com\/","Category":"Transportation"},{"API":"Icelandic AP' +
        'Is","Description":"Open APIs that deliver services in or regardi' +
        'ng Iceland","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        ':\/\/docs.apis.is\/","Category":"Transportation"},{"API":"Impala' +
        ' Hotel Bookings","Description":"Hotel content, rates and room bo' +
        'okings","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\' +
        '/\/docs.impala.travel\/docs\/booking-api\/","Category":"Transpor' +
        'tation"},{"API":"Izi","Description":"Audio guide for travellers"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http:\/\/' +
        'api-docs.izi.travel\/","Category":"Transportation"},{"API":"Land' +
        ' Transport Authority DataMall, Singapore","Description":"Singapo' +
        're transport information","Auth":"apiKey","HTTPS":false,"Cors":"' +
        'unknown","Link":"https:\/\/datamall.lta.gov.sg\/content\/dam\/da' +
        'tamall\/datasets\/LTA_DataMall_API_User_Guide.pdf","Category":"T' +
        'ransportation"},{"API":"Metro Lisboa","Description":"Delays in s' +
        'ubway lines","Auth":"","HTTPS":false,"Cors":"no","Link":"http:\/' +
        '\/app.metrolisboa.pt\/status\/getLinhas.php","Category":"Transpo' +
        'rtation"},{"API":"Navitia","Description":"The open API for build' +
        'ing cool stuff with transport data","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/doc.navitia.io\/","Category"' +
        ':"Transportation"},{"API":"Open Charge Map","Description":"Globa' +
        'l public registry of electric vehicle charging locations","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/opencharge' +
        'map.org\/site\/develop\/api","Category":"Transportation"},{"API"' +
        ':"OpenSky Network","Description":"Free real-time ADS-B aviation ' +
        'data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'opensky-network.org\/apidoc\/index.html","Category":"Transportat' +
        'ion"},{"API":"Railway Transport for France","Description":"SNCF ' +
        'public API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.digital.sncf.com\/startup\/api","Category":"Tran' +
        'sportation"},{"API":"REFUGE Restrooms","Description":"Provides s' +
        'afe restroom access for transgender, intersex and gender nonconf' +
        'orming individuals","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.refugerestrooms.org\/api\/docs\/#!\/restrooms"' +
        ',"Category":"Transportation"},{"API":"Sabre for Developers","Des' +
        'cription":"Travel Search - Limited usage","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developer.sabre.com\/g' +
        'uides\/travel-agency\/quickstart\/getting-started-in-travel","Ca' +
        'tegory":"Transportation"},{"API":"Schiphol Airport","Description' +
        '":"Schiphol","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/developer.schiphol.nl\/","Category":"Transportation' +
        '"},{"API":"Tankerkoenig","Description":"German realtime gas\/die' +
        'sel prices","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/creativecommons.tankerkoenig.de\/swagger\/","Category":"' +
        'Transportation"},{"API":"TransitLand","Description":"Transit Agg' +
        'regation","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/www.transit.land\/documentation\/datastore\/api-endpoints.ht' +
        'ml","Category":"Transportation"},{"API":"Transport for Atlanta, ' +
        'US","Description":"Marta","Auth":"","HTTPS":false,"Cors":"unknow' +
        'n","Link":"http:\/\/www.itsmarta.com\/app-developer-resources.as' +
        'px","Category":"Transportation"},{"API":"Transport for Auckland,' +
        ' New Zealand","Description":"Auckland Transport","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/dev-portal.at.govt.nz' +
        '\/","Category":"Transportation"},{"API":"Transport for Belgium",' +
        '"Description":"The iRail API is a third-party API for Belgian pu' +
        'blic transport by train","Auth":"","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/docs.irail.be\/","Category":"Transportation"},{"A' +
        'PI":"Transport for Berlin, Germany","Description":"Third-party V' +
        'BB API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/github.com\/derhuerst\/vbb-rest\/blob\/3\/docs\/index.md","Cat' +
        'egory":"Transportation"},{"API":"Transport for Bordeaux, France"' +
        ',"Description":"Bordeaux M'#195#169'tropole public transport and more (F' +
        'rance)","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/opendata.bordeaux-metropole.fr\/explore\/","Category":"T' +
        'ransportation"},{"API":"Transport for Budapest, Hungary","Descri' +
        'ption":"Budapest public transport API","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/bkkfutar.docs.apiary.io","Categ' +
        'ory":"Transportation"},{"API":"Transport for Chicago, US","Descr' +
        'iption":"Chicago Transit Authority (CTA)","Auth":"apiKey","HTTPS' +
        '":false,"Cors":"unknown","Link":"http:\/\/www.transitchicago.com' +
        '\/developers\/","Category":"Transportation"},{"API":"Transport f' +
        'or Czech Republic","Description":"Czech transport API","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.chaps.cz\/e' +
        'ng\/products\/idos-internet","Category":"Transportation"},{"API"' +
        ':"Transport for Denver, US","Description":"RTD","Auth":"","HTTPS' +
        '":false,"Cors":"unknown","Link":"http:\/\/www.rtd-denver.com\/gt' +
        'fs-developer-guide.shtml","Category":"Transportation"},{"API":"T' +
        'ransport for Finland","Description":"Finnish transport API","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/digitransi' +
        't.fi\/en\/developers\/ ","Category":"Transportation"},{"API":"Tr' +
        'ansport for Germany","Description":"Deutsche Bahn (DB) API","Aut' +
        'h":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http:\/\/data' +
        '.deutschebahn.com\/dataset\/api-fahrplan","Category":"Transporta' +
        'tion"},{"API":"Transport for Grenoble, France","Description":"Gr' +
        'enoble public transport","Auth":"","HTTPS":false,"Cors":"no","Li' +
        'nk":"https:\/\/www.mobilites-m.fr\/pages\/opendata\/OpenDataApi.' +
        'html","Category":"Transportation"},{"API":"Transport for Hessen,' +
        ' Germany","Description":"RMV API (Public Transport in Hessen)","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/opendat' +
        'a.rmv.de\/site\/start.html","Category":"Transportation"},{"API":' +
        '"Transport for Honolulu, US","Description":"Honolulu Transportat' +
        'ion Information","Auth":"apiKey","HTTPS":false,"Cors":"unknown",' +
        '"Link":"http:\/\/hea.thebus.org\/api_info.asp","Category":"Trans' +
        'portation"},{"API":"Transport for Lisbon, Portugal","Description' +
        '":"Data about buses routes, parking and traffic","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/emel.city-platf' +
        'orm.com\/opendata\/","Category":"Transportation"},{"API":"Transp' +
        'ort for London, England","Description":"TfL API","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.tfl.gov.uk"' +
        ',"Category":"Transportation"},{"API":"Transport for Los Angeles,' +
        ' US","Description":"Data about positions of Metro vehicles in re' +
        'al time and travel their routes","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/developer.metro.net\/api\/","Category' +
        '":"Transportation"},{"API":"Transport for Manchester, England","' +
        'Description":"TfGM transport network data","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"no","Link":"https:\/\/developer.tfgm.com\/","Cat' +
        'egory":"Transportation"},{"API":"Transport for Norway","Descript' +
        'ion":"Transport APIs and dataset for Norway","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/developer.entur.org\/","C' +
        'ategory":"Transportation"},{"API":"Transport for Ottawa, Canada"' +
        ',"Description":"OC Transpo API","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.octranspo.com\/en\/plan-your' +
        '-trip\/travel-tools\/developers","Category":"Transportation"},{"' +
        'API":"Transport for Paris, France","Description":"RATP Open Data' +
        ' API","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/' +
        'data.ratp.fr\/api\/v1\/console\/datasets\/1.0\/search\/","Catego' +
        'ry":"Transportation"},{"API":"Transport for Philadelphia, US","D' +
        'escription":"SEPTA APIs","Auth":"","HTTPS":false,"Cors":"unknown' +
        '","Link":"http:\/\/www3.septa.org\/hackathon\/","Category":"Tran' +
        'sportation"},{"API":"Transport for Sao Paulo, Brazil","Descripti' +
        'on":"SPTrans","Auth":"OAuth","HTTPS":false,"Cors":"unknown","Lin' +
        'k":"http:\/\/www.sptrans.com.br\/desenvolvedores\/api-do-olho-vi' +
        'vo-guia-de-referencia\/documentacao-api\/","Category":"Transport' +
        'ation"},{"API":"Transport for Spain","Description":"Public train' +
        's of Spain","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/data.renfe.com\/api\/1\/util\/snippet\/api_info.html?resou' +
        'rce_id=a2368cff-1562-4dde-8466-9635ea3a572a","Category":"Transpo' +
        'rtation"},{"API":"Transport for Sweden","Description":"Public Tr' +
        'ansport consumer","Auth":"OAuth","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.trafiklab.se\/api","Category":"Transportati' +
        'on"},{"API":"Transport for Switzerland","Description":"Official ' +
        'Swiss Public Transport Open Data","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/opentransportdata.swiss\/en\/"' +
        ',"Category":"Transportation"},{"API":"Transport for Switzerland"' +
        ',"Description":"Swiss public transport API","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/transport.opendata.ch\/","' +
        'Category":"Transportation"},{"API":"Transport for The Netherland' +
        's","Description":"NS, only trains","Auth":"apiKey","HTTPS":false' +
        ',"Cors":"unknown","Link":"http:\/\/www.ns.nl\/reisinformatie\/ns' +
        '-api","Category":"Transportation"},{"API":"Transport for The Net' +
        'herlands","Description":"OVAPI, country-wide public transport","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.' +
        'com\/skywave\/KV78Turbo-OVAPI\/wiki","Category":"Transportation"' +
        '},{"API":"Transport for Toronto, Canada","Description":"TTC","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/myttc.ca\' +
        '/developers","Category":"Transportation"},{"API":"Transport for ' +
        'UK","Description":"Transport API and dataset for UK","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.t' +
        'ransportapi.com","Category":"Transportation"},{"API":"Transport ' +
        'for United States","Description":"NextBus API","Auth":"","HTTPS"' +
        ':false,"Cors":"unknown","Link":"https:\/\/retro.umoiq.com\/xmlFe' +
        'edDocs\/NextBusXMLFeed.pdf","Category":"Transportation"},{"API":' +
        '"Transport for Vancouver, Canada","Description":"TransLink","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/devel' +
        'oper.translink.ca\/","Category":"Transportation"},{"API":"Transp' +
        'ort for Washington, US","Description":"Washington Metro transpor' +
        't API","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/developer.wmata.com\/","Category":"Transportation"},{"API"' +
        ':"transport.rest","Description":"Community maintained, developer' +
        '-friendly public transport API","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/transport.rest","Category":"Transportation' +
        '"},{"API":"Tripadvisor","Description":"Rating content for a hote' +
        'l, restaurant, attraction or destination","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developer-tripadvisor.' +
        'com\/home\/","Category":"Transportation"},{"API":"Uber","Descrip' +
        'tion":"Uber ride requests and price estimation","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/developer.uber.com\/p' +
        'roducts","Category":"Transportation"},{"API":"Velib metropolis, ' +
        'Paris, France","Description":"Velib Open Data API","Auth":"","HT' +
        'TPS":true,"Cors":"no","Link":"https:\/\/www.velib-metropole.fr\/' +
        'donnees-open-data-gbfs-du-service-velib-metropole","Category":"T' +
        'ransportation"},{"API":"1pt","Description":"A simple URL shorten' +
        'er","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github' +
        '.com\/1pt-co\/api\/blob\/main\/README.md","Category":"URL Shorte' +
        'ners"},{"API":"Bitly","Description":"URL shortener and link mana' +
        'gement","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'p:\/\/dev.bitly.com\/get_started.html","Category":"URL Shortener' +
        's"},{"API":"CleanURI","Description":"URL shortener service","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/cleanuri.com\/' +
        'docs","Category":"URL Shorteners"},{"API":"ClickMeter","Descript' +
        'ion":"Monitor, compare and optimize your marketing links","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/suppor' +
        't.clickmeter.com\/hc\/en-us\/categories\/201474986","Category":"' +
        'URL Shorteners"},{"API":"Clico","Description":"URL shortener ser' +
        'vice","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/cli.com\/swagger-ui\/index.html?configUrl=\/v3\/api-docs\/' +
        'swagger-config","Category":"URL Shorteners"},{"API":"Cutt.ly","D' +
        'escription":"URL shortener service","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/cutt.ly\/api-documentation\/' +
        'cuttly-links-api","Category":"URL Shorteners"},{"API":"Drivet UR' +
        'L Shortener","Description":"Shorten a long URL easily and fast",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/wiki.d' +
        'rivet.xyz\/en\/url-shortener\/add-links","Category":"URL Shorten' +
        'ers"},{"API":"Free Url Shortener","Description":"Free URL Shorte' +
        'ner offers a powerful API to interact with other sites","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ulvis.net\/dev' +
        'eloper.html","Category":"URL Shorteners"},{"API":"Git.io","Descr' +
        'iption":"Git.io URL shortener","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/github.blog\/2011-11-10-git-io-github-u' +
        'rl-shortener\/","Category":"URL Shorteners"},{"API":"GoTiny","De' +
        'scription":"A lightweight URL shortener, focused on ease-of-use ' +
        'for the developer and end-user","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/github.com\/robvanbakel\/gotiny-api","Cate' +
        'gory":"URL Shorteners"},{"API":"Kutt","Description":"Free Modern' +
        ' URL Shortener","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/docs.kutt.it\/","Category":"URL Shorteners"},{"API":' +
        '"Mgnet.me","Description":"Torrent URL shorten API","Auth":"","HT' +
        'TPS":true,"Cors":"no","Link":"http:\/\/mgnet.me\/api.html","Cate' +
        'gory":"URL Shorteners"},{"API":"owo","Description":"A simple lin' +
        'k obfuscator\/shortener","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/owo.vc\/api","Category":"URL Shorteners"},{"A' +
        'PI":"Rebrandly","Description":"Custom URL shortener for sharing ' +
        'branded links","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/developers.rebrandly.com\/v1\/docs","Category":"U' +
        'RL Shorteners"},{"API":"Short Link","Description":"Short URLs su' +
        'pport so many domains","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/github.com\/FayasNoushad\/Short-Link-API","Cate' +
        'gory":"URL Shorteners"},{"API":"Shrtcode","Description":"URl Sho' +
        'rtener with multiple Domains","Auth":"","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/shrtco.de\/docs","Category":"URL Shorteners"' +
        '},{"API":"Shrtlnk","Description":"Simple and efficient short lin' +
        'k creation","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/shrtlnk.dev\/developer","Category":"URL Shorteners"},{"A' +
        'PI":"TinyURL","Description":"Shorten long URLs","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"no","Link":"https:\/\/tinyurl.com\/app\/dev' +
        '","Category":"URL Shorteners"},{"API":"UrlBae","Description":"Si' +
        'mple and efficient short link creation","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/urlbae.com\/developers","Cat' +
        'egory":"URL Shorteners"},{"API":"Brazilian Vehicles and Prices",' +
        '"Description":"Vehicles information from Funda'#195#167#195#163'o Instituto de' +
        ' Pesquisas Econ'#195#180'micas - Fipe","Auth":"","HTTPS":true,"Cors":"no' +
        '","Link":"https:\/\/deividfortuna.github.io\/fipe\/","Category":' +
        '"Vehicle"},{"API":"Helipaddy sites","Description":"Helicopter an' +
        'd passenger drone landing site directory, Helipaddy data and muc' +
        'h more","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/helipaddy.com\/api\/","Category":"Vehicle"},{"API":"Kell' +
        'ey Blue Book","Description":"Vehicle info, pricing, configuratio' +
        'n, plus much more","Auth":"apiKey","HTTPS":true,"Cors":"no","Lin' +
        'k":"http:\/\/developer.kbb.com\/#!\/data\/1-Default","Category":' +
        '"Vehicle"},{"API":"Mercedes-Benz","Description":"Telematics data' +
        ', remotely access vehicle functions, car configurator, locate se' +
        'rvice dealers","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"' +
        'https:\/\/developer.mercedes-benz.com\/apis","Category":"Vehicle' +
        '"},{"API":"NHTSA","Description":"NHTSA Product Information Catal' +
        'og and Vehicle Listing","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/vpic.nhtsa.dot.gov\/api\/","Category":"Vehicle' +
        '"},{"API":"Smartcar","Description":"Lock and unlock vehicles and' +
        ' get data like odometer reading and location. Works on most new ' +
        'cars","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/smartcar.com\/docs\/","Category":"Vehicle"},{"API":"An API of I' +
        'ce And Fire","Description":"Game Of Thrones API","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/anapioficeandfire.com' +
        '\/","Category":"Video"},{"API":"Bob'#39's Burgers","Description":"Bo' +
        'b'#39's Burgers API","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/bobs-burgers-api-ui.herokuapp.com","Category":"Video"},{"' +
        'API":"Breaking Bad","Description":"Breaking Bad API","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/breakingbadapi.co' +
        'm\/documentation","Category":"Video"},{"API":"Breaking Bad Quote' +
        's","Description":"Some Breaking Bad quotes","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/github.com\/shevabam\/brea' +
        'king-bad-quotes","Category":"Video"},{"API":"Catalogopolis","Des' +
        'cription":"Doctor Who API","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/api.catalogopolis.xyz\/docs\/","Category":"' +
        'Video"},{"API":"Catch The Show","Description":"REST API for next' +
        '-episode.net","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/catchtheshow.herokuapp.com\/api\/documentation","Categor' +
        'y":"Video"},{"API":"Czech Television","Description":"TV programm' +
        'e of Czech TV","Auth":"","HTTPS":false,"Cors":"unknown","Link":"' +
        'http:\/\/www.ceskatelevize.cz\/xml\/tv-program\/","Category":"Vi' +
        'deo"},{"API":"Dailymotion","Description":"Dailymotion Developer ' +
        'API","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/developer.dailymotion.com\/","Category":"Video"},{"API":"Dun' +
        'e","Description":"A simple API which provides you with book, cha' +
        'racter, movie and quotes JSON data","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/github.com\/ywalia01\/dune-api","Categ' +
        'ory":"Video"},{"API":"Final Space","Description":"Final Space AP' +
        'I","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/finalsp' +
        'aceapi.com\/docs\/","Category":"Video"},{"API":"Game of Thrones ' +
        'Quotes","Description":"Some Game of Thrones quotes","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/gameofthronesquote' +
        's.xyz\/","Category":"Video"},{"API":"Harry Potter Charactes","De' +
        'scription":"Harry Potter Characters Data with with imagery","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/hp-api.her' +
        'okuapp.com\/","Category":"Video"},{"API":"IMDb-API","Description' +
        '":"API for receiving movie, serial and cast information","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/imdb-ap' +
        'i.com\/","Category":"Video"},{"API":"IMDbOT","Description":"Unof' +
        'ficial IMDb Movie \/ Series Information","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/github.com\/SpEcHiDe\/IMDbOT","Ca' +
        'tegory":"Video"},{"API":"JSON2Video","Description":"Create and e' +
        'dit videos programmatically: watermarks,resizing,slideshows,voic' +
        'e-over,text animations","Auth":"apiKey","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/json2video.com","Category":"Video"},{"API":"L' +
        'ucifer Quotes","Description":"Returns Lucifer quotes","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/shad' +
        'owoff09\/lucifer-quotes","Category":"Video"},{"API":"MCU Countdo' +
        'wn","Description":"A Countdown to the next MCU Film","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/DiljotSG\' +
        '/MCU-Countdown","Category":"Video"},{"API":"Motivational Quotes"' +
        ',"Description":"Random Motivational Quotes","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/nodejs-quoteapp.herokuapp.' +
        'com\/","Category":"Video"},{"API":"Movie Quote","Description":"R' +
        'andom Movie and Series Quotes","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/github.com\/F4R4N\/movie-quote\/","Category' +
        '":"Video"},{"API":"Open Movie Database","Description":"Movie inf' +
        'ormation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'http:\/\/www.omdbapi.com\/","Category":"Video"},{"API":"Owen Wil' +
        'son Wow","Description":"API for actor Owen Wilson'#39's \"wow\" excl' +
        'amations in movies","Auth":"","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/owen-wilson-wow-api.herokuapp.com","Category":"Video"}' +
        ',{"API":"Ron Swanson Quotes","Description":"Television","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/ja' +
        'messeanwright\/ron-swanson-quotes#ron-swanson-quotes-api","Categ' +
        'ory":"Video"},{"API":"Simkl","Description":"Movie, TV and Anime ' +
        'data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/simkl.docs.apiary.io","Category":"Video"},{"API":"STAPI","' +
        'Description":"Information on all things Star Trek","Auth":"","HT' +
        'TPS":false,"Cors":"no","Link":"http:\/\/stapi.co","Category":"Vi' +
        'deo"},{"API":"Stranger Things Quotes","Description":"Returns Str' +
        'anger Things quotes","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/github.com\/shadowoff09\/strangerthings-quotes","' +
        'Category":"Video"},{"API":"Stream","Description":"Czech internet' +
        ' television, films, series and online videos for free","Auth":""' +
        ',"HTTPS":true,"Cors":"no","Link":"https:\/\/api.stream.cz\/graph' +
        'iql","Category":"Video"},{"API":"Stromberg Quotes","Description"' +
        ':"Returns Stromberg quotes and more","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/www.stromberg-api.de\/","Category' +
        '":"Video"},{"API":"SWAPI","Description":"All the Star Wars data ' +
        'you'#39've ever wanted","Auth":"","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/swapi.dev\/","Category":"Video"},{"API":"SWAPI","Descr' +
        'iption":"All things Star Wars","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/www.swapi.tech","Category":"Video"},{"API":' +
        '"SWAPI GraphQL","Description":"Star Wars GraphQL API","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/graphql.org\/swa' +
        'pi-graphql","Category":"Video"},{"API":"The Lord of the Rings","' +
        'Description":"The Lord of the Rings API","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/the-one-api.dev\/","Cat' +
        'egory":"Video"},{"API":"The Vampire Diaries","Description":"TV S' +
        'how Data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/vampire-diaries-api.netlify.app\/","Category":"Video"},{"A' +
        'PI":"ThronesApi","Description":"Game Of Thrones Characters Data ' +
        'with imagery","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/thronesapi.com\/","Category":"Video"},{"API":"TMDb","Des' +
        'cription":"Community-based movie data","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.themoviedb.org\/docum' +
        'entation\/api","Category":"Video"},{"API":"TrailerAddict","Descr' +
        'iption":"Easily embed trailers from TrailerAddict","Auth":"apiKe' +
        'y","HTTPS":false,"Cors":"unknown","Link":"https:\/\/www.trailera' +
        'ddict.com\/trailerapi","Category":"Video"},{"API":"Trakt","Descr' +
        'iption":"Movie and TV Data","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/trakt.docs.apiary.io\/","Category":"Vide' +
        'o"},{"API":"TVDB","Description":"Television data","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/thetvdb.com\/a' +
        'pi-information","Category":"Video"},{"API":"TVMaze","Description' +
        '":"TV Show Data","Auth":"","HTTPS":false,"Cors":"unknown","Link"' +
        ':"http:\/\/www.tvmaze.com\/api","Category":"Video"},{"API":"uNoG' +
        'S","Description":"Unofficial Netflix Online Global Search, Searc' +
        'h all netflix regions in one place","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/rapidapi.com\/unogs\/api\/unogsn' +
        'g","Category":"Video"},{"API":"Vimeo","Description":"Vimeo Devel' +
        'oper API","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/developer.vimeo.com\/","Category":"Video"},{"API":"Watc' +
        'hmode","Description":"API for finding out the streaming availabi' +
        'lity of movies & shows","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/api.watchmode.com\/","Category":"Video"}' +
        ',{"API":"Web Series Quotes Generator","Description":"API generat' +
        'es various Web Series Quote Images","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/github.com\/yogeshwaran01\/web-series-' +
        'quotes","Category":"Video"},{"API":"YouTube","Description":"Add ' +
        'YouTube functionality to your sites and apps","Auth":"OAuth","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/developers.google.c' +
        'om\/youtube\/","Category":"Video"},{"API":"7Timer!","Description' +
        '":"Weather, especially for Astroweather","Auth":"","HTTPS":false' +
        ',"Cors":"unknown","Link":"http:\/\/www.7timer.info\/doc.php?lang' +
        '=en","Category":"Weather"},{"API":"AccuWeather","Description":"W' +
        'eather and forecast data","Auth":"apiKey","HTTPS":false,"Cors":"' +
        'unknown","Link":"https:\/\/developer.accuweather.com\/apis","Cat' +
        'egory":"Weather"},{"API":"Aemet","Description":"Weather and fore' +
        'cast data from Spain","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/opendata.aemet.es\/centrodedescargas\/inic' +
        'io","Category":"Weather"},{"API":"apilayer weatherstack","Descri' +
        'ption":"Real-Time & Historical World Weather Data API","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/weatherst' +
        'ack.com\/","Category":"Weather"},{"API":"APIXU","Description":"W' +
        'eather","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/www.apixu.com\/doc\/request.aspx","Category":"Weather"},' +
        '{"API":"AQICN","Description":"Air Quality Index Data for over 10' +
        '00 cities","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/aqicn.org\/api\/","Category":"Weather"},{"API":"Aviat' +
        'ionWeather","Description":"NOAA aviation weather forecasts and o' +
        'bservations","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/www.aviationweather.gov\/dataserver","Category":"Weather"' +
        '},{"API":"ColorfulClouds","Description":"Weather","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/open.caiyunapp.com' +
        '\/ColorfulClouds_Weather_API","Category":"Weather"},{"API":"Eusk' +
        'almet","Description":"Meteorological data of the Basque Country"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/opendata.euskadi.eus\/api-euskalmet\/-\/api-de-euskalmet\/","Ca' +
        'tegory":"Weather"},{"API":"Foreca","Description":"Weather","Auth' +
        '":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/develo' +
        'per.foreca.com","Category":"Weather"},{"API":"HG Weather","Descr' +
        'iption":"Provides weather forecast data for cities in Brazil","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/hgbras' +
        'il.com\/status\/weather","Category":"Weather"},{"API":"Hong Kong' +
        ' Obervatory","Description":"Provide weather information, earthqu' +
        'ake information, and climate data","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/www.hko.gov.hk\/en\/abouthko\/opend' +
        'ata_intro.htm","Category":"Weather"},{"API":"MetaWeather","Descr' +
        'iption":"Weather","Auth":"","HTTPS":true,"Cors":"no","Link":"htt' +
        'ps:\/\/www.metaweather.com\/api\/","Category":"Weather"},{"API":' +
        '"Meteorologisk Institutt","Description":"Weather and climate dat' +
        'a","Auth":"User-Agent","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/api.met.no\/weatherapi\/documentation","Category":"Weathe' +
        'r"},{"API":"Micro Weather","Description":"Real time weather fore' +
        'casts and historic data","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/m3o.com\/weather\/api","Category":"Weat' +
        'her"},{"API":"ODWeather","Description":"Weather and weather webc' +
        'ams","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/a' +
        'pi.oceandrivers.com\/static\/docs.html","Category":"Weather"},{"' +
        'API":"Oikolab","Description":"70+ years of global, hourly histor' +
        'ical and forecast weather data from NOAA and ECMWF","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.oikolab.com' +
        '","Category":"Weather"},{"API":"Open-Meteo","Description":"Globa' +
        'l weather forecast API for non-commercial use","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/open-meteo.com\/","Category' +
        '":"Weather"},{"API":"openSenseMap","Description":"Data from Pers' +
        'onal Weather Stations called senseBoxes","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/api.opensensemap.org\/","Category' +
        '":"Weather"},{"API":"OpenUV","Description":"Real-time UV Index F' +
        'orecast","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/www.openuv.io","Category":"Weather"},{"API":"OpenWeathe' +
        'rMap","Description":"Weather","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/openweathermap.org\/api","Category' +
        '":"Weather"},{"API":"QWeather","Description":"Location-based wea' +
        'ther data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/dev.qweather.com\/en\/","Category":"Weather"},{"API":"Rai' +
        'nViewer","Description":"Radar data collected from different webs' +
        'ites across the Internet","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/www.rainviewer.com\/api.html","Category":"We' +
        'ather"},{"API":"Storm Glass","Description":"Global marine weathe' +
        'r from multiple sources","Auth":"apiKey","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/stormglass.io\/","Category":"Weather"},{"AP' +
        'I":"Tomorrow","Description":"Weather API Powered by Proprietary ' +
        'Technology","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/docs.tomorrow.io","Category":"Weather"},{"API":"US W' +
        'eather","Description":"US National Weather Service","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/www.weather.gov\/docum' +
        'entation\/services-web-api","Category":"Weather"},{"API":"Visual' +
        ' Crossing","Description":"Global historical and weather forecast' +
        ' data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/www.visualcrossing.com\/weather-api","Category":"Weather"},{"' +
        'API":"weather-api","Description":"A RESTful free API to check th' +
        'e weather","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'github.com\/robertoduessmann\/weather-api","Category":"Weather"}' +
        ',{"API":"WeatherAPI","Description":"Weather API with other stuff' +
        ' like Astronomy and Geolocation API","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/www.weatherapi.com\/","Category' +
        '":"Weather"},{"API":"Weatherbit","Description":"Weather","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.wea' +
        'therbit.io\/api","Category":"Weather"},{"API":"Yandex.Weather","' +
        'Description":"Assesses weather condition in specific locations",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/yande' +
        'x.com\/dev\/weather\/","Category":"Weather"}]}')
    Left = 429
    Top = 237
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'API'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Auth'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'HTTPS'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Cors'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Link'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Category'
        DataType = ftString
        Size = 1000
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 360
    Top = 64
  end
end
