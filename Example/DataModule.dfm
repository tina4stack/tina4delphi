object frmDataModule: TfrmDataModule
  Height = 600
  Width = 800
  PixelsPerInch = 120
  object Tina4HttpServer1: TTina4HttpServer
    Bindings = <>
    MaxConnections = 1024
    Scheduler = IdSchedulerOfThreadPool1
    OnCommandGet = Tina4HttpServer1CommandGet
    Left = 330
    Top = 180
  end
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 410
    Top = 420
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\andre\IdeaProjects\tina4delphi\Example\Car_Dat' +
        'abase.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 240
    Top = 290
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 380
    Top = 290
  end
  object Tina4Route1: TTina4Route
    Left = 250
    Top = 480
  end
  object Tina4REST1: TTina4REST
    BaseUrl = 'https://api.publicapis.org'
    Left = 548
    Top = 184
  end
  object RESTRequest1: TRESTRequest
    Params = <>
    SynchronizedEvents = False
    Left = 608
    Top = 384
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    EndPoint = 'entries'
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
        'alware"},{"API":"Am'#233'thyste","Description":"Generate images for D' +
        'iscord users","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/api.amethyste.moe\/","Category":"Art & Design"},{"' +
        'API":"Art Institute of Chicago","Description":"Art","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/api.artic.edu\/docs\/"' +
        ',"Category":"Art & Design"},{"API":"Colormind","Description":"Co' +
        'lor scheme generator","Auth":"","HTTPS":false,"Cors":"unknown","' +
        'Link":"http:\/\/colormind.io\/api-access\/","Category":"Art & De' +
        'sign"},{"API":"ColourLovers","Description":"Get various patterns' +
        ', palettes and images","Auth":"","HTTPS":false,"Cors":"unknown",' +
        '"Link":"http:\/\/www.colourlovers.com\/api","Category":"Art & De' +
        'sign"},{"API":"Cooper Hewitt","Description":"Smithsonian Design ' +
        'Museum","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/collection.cooperhewitt.org\/api","Category":"Art & Desi' +
        'gn"},{"API":"Dribbble","Description":"Discover the world'#8217's top d' +
        'esigners & creatives","Auth":"OAuth","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/developer.dribbble.com","Category":"Art & D' +
        'esign"},{"API":"EmojiHub","Description":"Get emojis by categorie' +
        's and groups","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/github.com\/cheatsnake\/emojihub","Category":"Art & Design"}' +
        ',{"API":"Europeana","Description":"European Museum and Galleries' +
        ' content","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/pro.europeana.eu\/resources\/apis\/search","Category":' +
        '"Art & Design"},{"API":"Harvard Art Museums","Description":"Art"' +
        ',"Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"https:\/' +
        '\/github.com\/harvardartmuseums\/api-docs","Category":"Art & Des' +
        'ign"},{"API":"Icon Horse","Description":"Favicons for any websit' +
        'e, with fallbacks","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/icon.horse","Category":"Art & Design"},{"API":"Iconfind' +
        'er","Description":"Icons","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/developer.iconfinder.com","Category":"' +
        'Art & Design"},{"API":"Icons8","Description":"Icons (find \"sear' +
        'ch icon\" hyperlink in page)","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/img.icons8.com\/","Category":"Art & Desi' +
        'gn"},{"API":"Lordicon","Description":"Icons with predone Animati' +
        'ons","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/lordi' +
        'con.com\/","Category":"Art & Design"},{"API":"Metropolitan Museu' +
        'm of Art","Description":"Met Museum of Art","Auth":"","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/metmuseum.github.io\/","Categor' +
        'y":"Art & Design"},{"API":"Noun Project","Description":"Icons","' +
        'Auth":"OAuth","HTTPS":false,"Cors":"unknown","Link":"http:\/\/ap' +
        'i.thenounproject.com\/index.html","Category":"Art & Design"},{"A' +
        'PI":"PHP-Noise","Description":"Noise Background Image Generator"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/php-noise' +
        '.com\/","Category":"Art & Design"},{"API":"Pixel Encounter","Des' +
        'cription":"SVG Icon Generator","Auth":"","HTTPS":true,"Cors":"no' +
        '","Link":"https:\/\/pixelencounter.com\/api","Category":"Art & D' +
        'esign"},{"API":"Rijksmuseum","Description":"RijksMuseum Data","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/da' +
        'ta.rijksmuseum.nl\/object-metadata\/api\/","Category":"Art & Des' +
        'ign"},{"API":"Word Cloud","Description":"Easily create word clou' +
        'ds","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/wordcloudapi.com\/","Category":"Art & Design"},{"API":"xColo' +
        'rs","Description":"Generate & convert colors","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/x-colors.herokuapp.com\/","C' +
        'ategory":"Art & Design"},{"API":"Auth0","Description":"Easy to i' +
        'mplement, adaptable authentication and authorization platform","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/auth0' +
        '.com","Category":"Authentication & Authorization"},{"API":"GetOT' +
        'P","Description":"Implement OTP flow quickly","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"no","Link":"https:\/\/otp.dev\/en\/docs\/","C' +
        'ategory":"Authentication & Authorization"},{"API":"Micro User Se' +
        'rvice","Description":"User management and authentication","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/m3o.com\/us' +
        'er","Category":"Authentication & Authorization"},{"API":"MojoAut' +
        'h","Description":"Secure and modern passwordless authentication ' +
        'platform","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/mojoauth.com","Category":"Authentication & Authorization"}' +
        ',{"API":"SAWO Labs","Description":"Simplify login and improve us' +
        'er experience by integrating passwordless authentication in your' +
        ' app","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/sawolabs.com","Category":"Authentication & Authorization"},{"A' +
        'PI":"Stytch","Description":"User infrastructure for modern appli' +
        'cations","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:' +
        '\/\/stytch.com\/","Category":"Authentication & Authorization"},{' +
        '"API":"Warrant","Description":"APIs for authorization and access' +
        ' control","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/warrant.dev\/","Category":"Authentication & Authorization"' +
        '},{"API":"Bitquery","Description":"Onchain GraphQL APIs & DEX AP' +
        'Is","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'graphql.bitquery.io\/ide","Category":"Blockchain"},{"API":"Chain' +
        'link","Description":"Build hybrid smart contracts with Chainlink' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/chai' +
        'n.link\/developer-resources","Category":"Blockchain"},{"API":"Ch' +
        'ainpoint","Description":"Chainpoint is a global network for anch' +
        'oring data to the Bitcoin blockchain","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/tierion.com\/chainpoint\/","Cate' +
        'gory":"Blockchain"},{"API":"Covalent","Description":"Multi-block' +
        'chain data aggregator platform","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.covalenthq.com\/docs\/api\/"' +
        ',"Category":"Blockchain"},{"API":"Etherscan","Description":"Ethe' +
        'reum explorer API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/etherscan.io\/apis","Category":"Blockchain"},{"AP' +
        'I":"Helium","Description":"Helium is a global, distributed netwo' +
        'rk of Hotspots that create public, long-range wireless coverage"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.' +
        'helium.com\/api\/blockchain\/introduction\/","Category":"Blockch' +
        'ain"},{"API":"Nownodes","Description":"Blockchain-as-a-service s' +
        'olution that provides high-quality connection via API","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/nownodes.' +
        'io\/","Category":"Blockchain"},{"API":"Steem","Description":"Blo' +
        'ckchain-based blogging and social media website","Auth":"","HTTP' +
        'S":false,"Cors":"no","Link":"https:\/\/developers.steem.io\/","C' +
        'ategory":"Blockchain"},{"API":"The Graph","Description":"Indexin' +
        'g protocol for querying networks like Ethereum with GraphQL","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/the' +
        'graph.com","Category":"Blockchain"},{"API":"Walltime","Descripti' +
        'on":"To retrieve Walltime'#39's market info","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/walltime.info\/api.html","Cat' +
        'egory":"Blockchain"},{"API":"Watchdata","Description":"Provide s' +
        'imple and reliable API access to Ethereum blockchain","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.watch' +
        'data.io","Category":"Blockchain"},{"API":"A B'#237'blia Digital","Des' +
        'cription":"Do not worry about managing the multiple versions of ' +
        'the Bible","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"http' +
        's:\/\/www.abibliadigital.com.br\/en","Category":"Books"},{"API":' +
        '"Bhagavad Gita","Description":"Open Source Shrimad Bhagavad Gita' +
        ' API including 21+ authors translation in Sanskrit\/English\/Hin' +
        'di","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'docs.bhagavadgitaapi.in","Category":"Books"},{"API":"Bhagavad Gi' +
        'ta","Description":"Bhagavad Gita text","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/bhagavadgita.io\/api","Categor' +
        'y":"Books"},{"API":"Bhagavad Gita telugu","Description":"Bhagava' +
        'd Gita API in telugu and odia languages","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/gita-api.vercel.app","Category":"' +
        'Books"},{"API":"Bible-api","Description":"Free Bible API with mu' +
        'ltiple languages","Auth":"","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/bible-api.com\/","Category":"Books"},{"API":"British Nat' +
        'ional Bibliography","Description":"Books","Auth":"","HTTPS":fals' +
        'e,"Cors":"unknown","Link":"http:\/\/bnb.data.bl.uk\/","Category"' +
        ':"Books"},{"API":"Crossref Metadata Search","Description":"Books' +
        ' & Articles Metadata","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/github.com\/CrossRef\/rest-api-doc","Category":"' +
        'Books"},{"API":"Ganjoor","Description":"Classic Persian poetry w' +
        'orks including access to related manuscripts, recitations and mu' +
        'sic tracks","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/api.ganjoor.net","Category":"Books"},{"API":"Google Books' +
        '","Description":"Books","Auth":"OAuth","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/developers.google.com\/books\/","Category' +
        '":"Books"},{"API":"GurbaniNow","Description":"Fast and Accurate ' +
        'Gurbani RESTful API","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/github.com\/GurbaniNow\/api","Category":"Books"},' +
        '{"API":"Gutendex","Description":"Web-API for fetching data from ' +
        'Project Gutenberg Books Library","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/gutendex.com\/","Category":"Books"},{' +
        '"API":"Open Library","Description":"Books, book covers and relat' +
        'ed data","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/op' +
        'enlibrary.org\/developers\/api","Category":"Books"},{"API":"Peng' +
        'uin Publishing","Description":"Books, book covers and related da' +
        'ta","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\/\/www.pen' +
        'guinrandomhouse.biz\/webservices\/rest\/","Category":"Books"},{"' +
        'API":"PoetryDB","Description":"Enables you to get instant data f' +
        'rom our vast poetry collection","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/github.com\/thundercomb\/poetrydb#readme",' +
        '"Category":"Books"},{"API":"Quran","Description":"RESTful Quran ' +
        'API with multiple languages","Auth":"","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/quran.api-docs.io\/","Category":"Books"},{"AP' +
        'I":"Quran Cloud","Description":"A RESTful Quran API to retrieve ' +
        'an Ayah, Surah, Juz or the entire Holy Quran","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/alquran.cloud\/api","Categor' +
        'y":"Books"},{"API":"Quran-api","Description":"Free Quran API Ser' +
        'vice with 90+ different languages and 400+ translations","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/fawaz' +
        'ahmed0\/quran-api#readme","Category":"Books"},{"API":"Rig Veda",' +
        '"Description":"Gods and poets, their categories, and the verse m' +
        'eters, with the mandal and sukta number","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/aninditabasu.github.io\/indic' +
        'a\/html\/rv.html","Category":"Books"},{"API":"The Bible","Descri' +
        'ption":"Everything you need from the Bible in one discoverable p' +
        'lace","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/docs.api.bible","Category":"Books"},{"API":"Thirukkural","' +
        'Description":"1330 Thirukkural poems and explanation in Tamil an' +
        'd English","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/api-thirukkural.web.app\/","Category":"Books"},{"API":"Vedic So' +
        'ciety","Description":"Descriptions of all nouns (names, places, ' +
        'animals, things) from vedic literature","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/aninditabasu.github.io\/indica' +
        '\/html\/vs.html","Category":"Books"},{"API":"Wizard World","Desc' +
        'ription":"Get information from the Harry Potter universe","Auth"' +
        ':"","HTTPS":true,"Cors":"yes","Link":"https:\/\/wizard-world-api' +
        '.herokuapp.com\/swagger\/index.html","Category":"Books"},{"API":' +
        '"Wolne Lektury","Description":"API for obtaining information abo' +
        'ut e-books available on the WolneLektury.pl website","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/wolnelektury.pl\/' +
        'api\/","Category":"Books"},{"API":"Apache Superset","Description' +
        '":"API to manage your BI dashboards and data sources on Superset' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/su' +
        'perset.apache.org\/docs\/api","Category":"Business"},{"API":"Cha' +
        'rity Search","Description":"Non-profit charity data","Auth":"api' +
        'Key","HTTPS":false,"Cors":"unknown","Link":"http:\/\/charityapi.' +
        'orghunter.com\/","Category":"Business"},{"API":"Clearbit Logo","' +
        'Description":"Search for company logos and embed them in your pr' +
        'ojects","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/clearbit.com\/docs#logo-api","Category":"Business"},{"AP' +
        'I":"Domainsdb.info","Description":"Registered Domain Names Searc' +
        'h","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/domainsd' +
        'b.info\/","Category":"Business"},{"API":"Freelancer","Descriptio' +
        'n":"Hire freelancers to get work done","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/developers.freelancer.com"' +
        ',"Category":"Business"},{"API":"Gmail","Description":"Flexible, ' +
        'RESTful access to the user'#39's inbox","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/developers.google.com\/gmail\' +
        '/api\/","Category":"Business"},{"API":"Google Analytics","Descri' +
        'ption":"Collect, configure and analyze your data to reach the ri' +
        'ght audience","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/developers.google.com\/analytics\/","Category":"Bus' +
        'iness"},{"API":"Instatus","Description":"Post to and update main' +
        'tenance and incidents on your status page through an HTTP REST A' +
        'PI","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/instatus.com\/help\/api","Category":"Business"},{"API":"Mail' +
        'chimp","Description":"Send marketing campaigns and transactional' +
        ' mails","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/mailchimp.com\/developer\/","Category":"Business"},{"API' +
        '":"mailjet","Description":"Marketing email can be sent and mail ' +
        'templates made in MJML or HTML can be sent using API","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.mailje' +
        't.com\/","Category":"Business"},{"API":"markerapi","Description"' +
        ':"Trademark Search","Auth":"","HTTPS":false,"Cors":"unknown","Li' +
        'nk":"https:\/\/markerapi.com","Category":"Business"},{"API":"ORB' +
        ' Intelligence","Description":"Company lookup","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/api.orb-intelligen' +
        'ce.com\/docs\/","Category":"Business"},{"API":"Redash","Descript' +
        'ion":"Access your queries and dashboards on Redash","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/redash.io\/help\' +
        '/user-guide\/integrations-and-api\/api","Category":"Business"},{' +
        '"API":"Smartsheet","Description":"Allows you to programmatically' +
        ' access and Smartsheet data and account information","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"no","Link":"https:\/\/smartsheet.redoc.' +
        'ly\/","Category":"Business"},{"API":"Square","Description":"Easy' +
        ' way to take payments, manage refunds, and help customers checko' +
        'ut online","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/developer.squareup.com\/reference\/square","Category":' +
        '"Business"},{"API":"SwiftKanban","Description":"Kanban software,' +
        ' Visualize Work, Increase Organizations Lead Time, Throughput & ' +
        'Productivity","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.digite.com\/knowledge-base\/swiftkanban\/artic' +
        'le\/api-for-swift-kanban-web-services\/#restapi","Category":"Bus' +
        'iness"},{"API":"Tenders in Hungary","Description":"Get data for ' +
        'procurements in Hungary in JSON format","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/tenders.guru\/hu\/api","Catego' +
        'ry":"Business"},{"API":"Tenders in Poland","Description":"Get da' +
        'ta for procurements in Poland in JSON format","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/tenders.guru\/pl\/api","' +
        'Category":"Business"},{"API":"Tenders in Romania","Description":' +
        '"Get data for procurements in Romania in JSON format","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/tenders.guru\/ro' +
        '\/api","Category":"Business"},{"API":"Tenders in Spain","Descrip' +
        'tion":"Get data for procurements in Spain in JSON format","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tenders.guru' +
        '\/es\/api","Category":"Business"},{"API":"Tenders in Ukraine","D' +
        'escription":"Get data for procurements in Ukraine in JSON format' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tend' +
        'ers.guru\/ua\/api","Category":"Business"},{"API":"Tomba email fi' +
        'nder","Description":"Email Finder for B2B sales and email market' +
        'ing and email verifier","Auth":"apiKey","HTTPS":true,"Cors":"yes' +
        '","Link":"https:\/\/tomba.io\/api","Category":"Business"},{"API"' +
        ':"Trello","Description":"Boards, lists and cards to help you org' +
        'anize and prioritize your projects","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/developers.trello.com\/","Cat' +
        'egory":"Business"},{"API":"Abstract Public Holidays","Descriptio' +
        'n":"Data on national, regional, and religious holidays via API",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.' +
        'abstractapi.com\/holidays-api","Category":"Calendar"},{"API":"Ca' +
        'lendarific","Description":"Worldwide Holidays","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/calendarific.com\' +
        '/","Category":"Calendar"},{"API":"Checkiday - National Holiday A' +
        'PI","Description":"Industry-leading Holiday API. Over 5,000 holi' +
        'days and thousands of descriptions. Trusted by the World'#8217's leadi' +
        'ng companies","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/apilayer.com\/marketplace\/checkiday-api","Categor' +
        'y":"Calendar"},{"API":"Church Calendar","Description":"Catholic ' +
        'liturgical calendar","Auth":"","HTTPS":false,"Cors":"unknown","L' +
        'ink":"http:\/\/calapi.inadiutorium.cz\/","Category":"Calendar"},' +
        '{"API":"Czech Namedays Calendar","Description":"Lookup for a nam' +
        'e and returns nameday date","Auth":"","HTTPS":false,"Cors":"unkn' +
        'own","Link":"https:\/\/svatky.adresa.info","Category":"Calendar"' +
        '},{"API":"Festivo Public Holidays","Description":"Fastest and mo' +
        'st advanced public holiday and observance service on the market"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/doc' +
        's.getfestivo.com\/docs\/products\/public-holidays-api\/intro","C' +
        'ategory":"Calendar"},{"API":"Google Calendar","Description":"Dis' +
        'play, create and modify Google calendar events","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.google' +
        '.com\/google-apps\/calendar\/","Category":"Calendar"},{"API":"He' +
        'brew Calendar","Description":"Convert between Gregorian and Hebr' +
        'ew, fetch Shabbat and Holiday times, etc","Auth":"","HTTPS":fals' +
        'e,"Cors":"unknown","Link":"https:\/\/www.hebcal.com\/home\/devel' +
        'oper-apis","Category":"Calendar"},{"API":"Holidays","Description' +
        '":"Historical data regarding holidays","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/holidayapi.com\/","Catego' +
        'ry":"Calendar"},{"API":"LectServe","Description":"Protestant lit' +
        'urgical calendar","Auth":"","HTTPS":false,"Cors":"unknown","Link' +
        '":"http:\/\/www.lectserve.com","Category":"Calendar"},{"API":"Na' +
        'ger.Date","Description":"Public holidays for more than 90 countr' +
        'ies","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/date.n' +
        'ager.at","Category":"Calendar"},{"API":"Namedays Calendar","Desc' +
        'ription":"Provides namedays for multiple countries","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/nameday.abalin.net","C' +
        'ategory":"Calendar"},{"API":"Non-Working Days","Description":"Da' +
        'tabase of ICS files for non working days","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/github.com\/gadael\/icsdb","' +
        'Category":"Calendar"},{"API":"Non-Working Days","Description":"S' +
        'imple REST API for checking working, non-working or short days f' +
        'or Russia, CIS, USA and other","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/isdayoff.ru","Category":"Calendar"},{"API":' +
        '"Russian Calendar","Description":"Check if a date is a Russian h' +
        'oliday or not","Auth":"","HTTPS":true,"Cors":"no","Link":"https:' +
        '\/\/github.com\/egno\/work-calendar","Category":"Calendar"},{"AP' +
        'I":"UK Bank Holidays","Description":"Bank holidays in England an' +
        'd Wales, Scotland and Northern Ireland","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.gov.uk\/bank-holidays.json' +
        '","Category":"Calendar"},{"API":"AnonFiles","Description":"Uploa' +
        'd and share your files anonymously","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/anonfiles.com\/docs\/api","Categor' +
        'y":"Cloud Storage & File Sharing"},{"API":"BayFiles","Descriptio' +
        'n":"Upload and share your files","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/bayfiles.com\/docs\/api","Category":"' +
        'Cloud Storage & File Sharing"},{"API":"Box","Description":"File ' +
        'Sharing and Storage","Auth":"OAuth","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developer.box.com\/","Category":"Cloud Stora' +
        'ge & File Sharing"},{"API":"ddownload","Description":"File Shari' +
        'ng and Storage","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/ddownload.com\/api","Category":"Cloud Storage & ' +
        'File Sharing"},{"API":"Dropbox","Description":"File Sharing and ' +
        'Storage","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/www.dropbox.com\/developers","Category":"Cloud Storage &' +
        ' File Sharing"},{"API":"File.io","Description":"Super simple fil' +
        'e sharing, convenient, anonymous and secure","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.file.io","Category":"' +
        'Cloud Storage & File Sharing"},{"API":"Filestack","Description":' +
        '"Filestack File Uploader & File Upload API","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/www.filestack.com","' +
        'Category":"Cloud Storage & File Sharing"},{"API":"GoFile","Descr' +
        'iption":"Unlimited size file uploads for free","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/gofile.io\/api","' +
        'Category":"Cloud Storage & File Sharing"},{"API":"Google Drive",' +
        '"Description":"File Sharing and Storage","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/developers.google.com\/d' +
        'rive\/","Category":"Cloud Storage & File Sharing"},{"API":"Gyazo' +
        '","Description":"Save & Share screen captures instantly","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gyazo.c' +
        'om\/api\/docs","Category":"Cloud Storage & File Sharing"},{"API"' +
        ':"Imgbb","Description":"Simple and quick private image sharing",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'api.imgbb.com\/","Category":"Cloud Storage & File Sharing"},{"AP' +
        'I":"OneDrive","Description":"File Sharing and Storage","Auth":"O' +
        'Auth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.' +
        'microsoft.com\/onedrive","Category":"Cloud Storage & File Sharin' +
        'g"},{"API":"Pantry","Description":"Free JSON storage for small p' +
        'rojects","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/g' +
        'etpantry.cloud\/","Category":"Cloud Storage & File Sharing"},{"A' +
        'PI":"Pastebin","Description":"Plain Text Storage","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pastebin.com\/' +
        'doc_api","Category":"Cloud Storage & File Sharing"},{"API":"Pina' +
        'ta","Description":"IPFS Pinning Services API","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/docs.pinata.cloud\' +
        '/","Category":"Cloud Storage & File Sharing"},{"API":"Quip","Des' +
        'cription":"File Sharing and Storage for groups","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/quip.com\/dev\/autom' +
        'ation\/documentation","Category":"Cloud Storage & File Sharing"}' +
        ',{"API":"Storj","Description":"Decentralized Open-Source Cloud S' +
        'torage","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/docs.storj.io\/dcs\/","Category":"Cloud Storage & File S' +
        'haring"},{"API":"The Null Pointer","Description":"No-bullshit fi' +
        'le hosting and URL shortening service","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/0x0.st","Category":"Cloud Stora' +
        'ge & File Sharing"},{"API":"Web3 Storage","Description":"File Sh' +
        'aring and Storage for Free with 1TB Space","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/web3.storage\/","Category' +
        '":"Cloud Storage & File Sharing"},{"API":"Azure DevOps Health","' +
        'Description":"Resource health helps you diagnose and get support' +
        ' when an Azure issue impacts your resources","Auth":"apiKey","HT' +
        'TPS":false,"Cors":"no","Link":"https:\/\/docs.microsoft.com\/en-' +
        'us\/rest\/api\/resourcehealth","Category":"Continuous Integratio' +
        'n"},{"API":"Bitrise","Description":"Build tool and processes int' +
        'egrations to create efficient development pipelines","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api-docs.bi' +
        'trise.io\/","Category":"Continuous Integration"},{"API":"Buddy",' +
        '"Description":"The fastest continuous integration and continuous' +
        ' delivery platform","Auth":"OAuth","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/buddy.works\/docs\/api\/getting-started\/over' +
        'view","Category":"Continuous Integration"},{"API":"CircleCI","De' +
        'scription":"Automate the software development process using cont' +
        'inuous integration and continuous delivery","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/circleci.com\/docs\/' +
        'api\/v1-reference\/","Category":"Continuous Integration"},{"API"' +
        ':"Codeship","Description":"Codeship is a Continuous Integration ' +
        'Platform in the cloud","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/docs.cloudbees.com\/docs\/cloudbees-codes' +
        'hip\/latest\/api-overview\/","Category":"Continuous Integration"' +
        '},{"API":"Travis CI","Description":"Sync your GitHub projects wi' +
        'th Travis CI to test your code in minutes","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.travis-ci.com\/a' +
        'pi\/","Category":"Continuous Integration"},{"API":"0x","Descript' +
        'ion":"API for querying token and pool stats across various liqui' +
        'dity pools","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/0x.org\/api","Category":"Cryptocurrency"},{"API":"1inch","Desc' +
        'ription":"API for querying decentralize exchange","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/1inch.io\/api\/","Ca' +
        'tegory":"Cryptocurrency"},{"API":"Alchemy Ethereum","Description' +
        '":"Ethereum Node-as-a-Service Provider","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/docs.alchemy.com\/alchemy\/"' +
        ',"Category":"Cryptocurrency"},{"API":"apilayer coinlayer","Descr' +
        'iption":"Real-time Crypto Currency Exchange Rates","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/coinlayer.com' +
        '","Category":"Cryptocurrency"},{"API":"Binance","Description":"E' +
        'xchange for Trading Cryptocurrencies based in China","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\' +
        '/binance\/binance-spot-api-docs","Category":"Cryptocurrency"},{"' +
        'API":"Bitcambio","Description":"Get the list of all traded asset' +
        's in the exchange","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/nova.bitcambio.com.br\/api\/v3\/docs#a-public","Cat' +
        'egory":"Cryptocurrency"},{"API":"BitcoinAverage","Description":"' +
        'Digital Asset Price Data for the blockchain industry","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apiv2.bitc' +
        'oinaverage.com\/","Category":"Cryptocurrency"},{"API":"BitcoinCh' +
        'arts","Description":"Financial and Technical Data related to the' +
        ' Bitcoin Network","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/bitcoincharts.com\/about\/exchanges\/","Category":"C' +
        'ryptocurrency"},{"API":"Bitfinex","Description":"Cryptocurrency ' +
        'Trading Platform","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/docs.bitfinex.com\/docs","Category":"Cryptocur' +
        'rency"},{"API":"Bitmex","Description":"Real-Time Cryptocurrency ' +
        'derivatives trading platform based in Hong Kong","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.bitmex.com\' +
        '/app\/apiOverview","Category":"Cryptocurrency"},{"API":"Bittrex"' +
        ',"Description":"Next Generation Crypto Trading Platform","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bittrex' +
        '.github.io\/api\/v3","Category":"Cryptocurrency"},{"API":"Block"' +
        ',"Description":"Bitcoin Payment, Wallet & Transaction Data","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bloc' +
        'k.io\/docs\/basic","Category":"Cryptocurrency"},{"API":"Blockcha' +
        'in","Description":"Bitcoin Payment, Wallet & Transaction Data","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/w' +
        'ww.blockchain.com\/api","Category":"Cryptocurrency"},{"API":"blo' +
        'ckfrost Cardano","Description":"Interaction with the Cardano mai' +
        'nnet and several testnets","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/blockfrost.io\/","Category":"Cryptocu' +
        'rrency"},{"API":"Brave NewCoin","Description":"Real-time and his' +
        'toric crypto data from more than 200+ exchanges","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/bravenewcoin.co' +
        'm\/developers","Category":"Cryptocurrency"},{"API":"BtcTurk","De' +
        'scription":"Real-time cryptocurrency data, graphs and API that a' +
        'llows buy&sell","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/docs.btcturk.com\/","Category":"Cryptocurrency"},{"A' +
        'PI":"Bybit","Description":"Cryptocurrency data feed and algorith' +
        'mic trading","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/bybit-exchange.github.io\/docs\/linear\/#t-introduc' +
        'tion","Category":"Cryptocurrency"},{"API":"CoinAPI","Description' +
        '":"All Currency Exchanges integrate under a single api","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/docs.coinapi.' +
        'io\/","Category":"Cryptocurrency"},{"API":"Coinbase","Descriptio' +
        'n":"Bitcoin, Bitcoin Cash, Litecoin and Ethereum Prices","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/develop' +
        'ers.coinbase.com","Category":"Cryptocurrency"},{"API":"Coinbase ' +
        'Pro","Description":"Cryptocurrency Trading Platform","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.pro.co' +
        'inbase.com\/#api","Category":"Cryptocurrency"},{"API":"CoinCap",' +
        '"Description":"Real time Cryptocurrency prices through a RESTful' +
        ' API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'docs.coincap.io\/","Category":"Cryptocurrency"},{"API":"CoinDCX"' +
        ',"Description":"Cryptocurrency Trading Platform","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.coindcx.co' +
        'm\/","Category":"Cryptocurrency"},{"API":"CoinDesk","Description' +
        '":"CoinDesk'#39's Bitcoin Price Index (BPI) in multiple currencies",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/old.co' +
        'indesk.com\/coindesk-api\/","Category":"Cryptocurrency"},{"API":' +
        '"CoinGecko","Description":"Cryptocurrency Price, Market, and Dev' +
        'eloper\/Social Data","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"http:\/\/www.coingecko.com\/api","Category":"Cryptocurrency"},{' +
        '"API":"Coinigy","Description":"Interacting with Coinigy Accounts' +
        ' and Exchange Directly","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/coinigy.docs.apiary.io","Category":"Cryp' +
        'tocurrency"},{"API":"Coinlib","Description":"Crypto Currency Pri' +
        'ces","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/coinlib.io\/apidocs","Category":"Cryptocurrency"},{"API":"C' +
        'oinlore","Description":"Cryptocurrencies prices, volume and more' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.' +
        'coinlore.com\/cryptocurrency-data-api","Category":"Cryptocurrenc' +
        'y"},{"API":"CoinMarketCap","Description":"Cryptocurrencies Price' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/coinmarketcap.com\/api\/","Category":"Cryptocurrency"},{"API"' +
        ':"Coinpaprika","Description":"Cryptocurrencies prices, volume an' +
        'd more","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ap' +
        'i.coinpaprika.com","Category":"Cryptocurrency"},{"API":"CoinRank' +
        'ing","Description":"Live Cryptocurrency data","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/developers.coinran' +
        'king.com\/api\/documentation","Category":"Cryptocurrency"},{"API' +
        '":"Coinremitter","Description":"Cryptocurrencies Payment & Price' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/coinremitter.com\/docs","Category":"Cryptocurrency"},{"API":"' +
        'CoinStats","Description":"Crypto Tracker","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/documenter.getpostman.com\/v' +
        'iew\/5734027\/RzZ6Hzr3?version=latest","Category":"Cryptocurrenc' +
        'y"},{"API":"CryptAPI","Description":"Cryptocurrency Payment Proc' +
        'essor","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/docs.cryptapi.io\/","Category":"Cryptocurrency"},{"API":"Crypti' +
        'ngUp","Description":"Cryptocurrency data","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/www.cryptingup.com\/apidoc\/' +
        '#introduction","Category":"Cryptocurrency"},{"API":"CryptoCompar' +
        'e","Description":"Cryptocurrencies Comparison","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.cryptocompare.com\/' +
        'api#","Category":"Cryptocurrency"},{"API":"CryptoMarket","Descri' +
        'ption":"Cryptocurrencies Trading platform","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/api.exchange.cryptomkt.co' +
        'm\/","Category":"Cryptocurrency"},{"API":"Cryptonator","Descript' +
        'ion":"Cryptocurrencies Exchange Rates","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/www.cryptonator.com\/api\/","Ca' +
        'tegory":"Cryptocurrency"},{"API":"dYdX","Description":"Decentral' +
        'ized cryptocurrency exchange","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/docs.dydx.exchange\/","Category":"' +
        'Cryptocurrency"},{"API":"Ethplorer","Description":"Ethereum toke' +
        'ns, balances, addresses, history of transactions, contracts, and' +
        ' custom structures","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/github.com\/EverexIO\/Ethplorer\/wiki\/Ethpl' +
        'orer-API","Category":"Cryptocurrency"},{"API":"EXMO","Descriptio' +
        'n":"Cryptocurrencies exchange based in UK","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/documenter.getpostman' +
        '.com\/view\/10287440\/SzYXWKPi","Category":"Cryptocurrency"},{"A' +
        'PI":"FTX","Description":"Complete REST, websocket, and FTX APIs ' +
        'to suit your algorithmic trading needs","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/docs.ftx.com\/","Category":"' +
        'Cryptocurrency"},{"API":"Gateio","Description":"API provides spo' +
        't, margin and futures trading operations","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/www.gate.io\/api2","Ca' +
        'tegory":"Cryptocurrency"},{"API":"Gemini","Description":"Cryptoc' +
        'urrencies Exchange","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/docs.gemini.com\/rest-api\/","Category":"Cryptocur' +
        'rency"},{"API":"Hirak Exchange Rates","Description":"Exchange ra' +
        'tes between 162 currency & 300 crypto currency update each 5 min' +
        ', accurate, no limits","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/rates.hirak.site\/","Category":"Cryptocur' +
        'rency"},{"API":"Huobi","Description":"Seychelles based cryptocur' +
        'rency exchange","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/huobiapi.github.io\/docs\/spot\/v1\/en\/","Categ' +
        'ory":"Cryptocurrency"},{"API":"icy.tools","Description":"GraphQL' +
        ' based NFT API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/developers.icy.tools\/","Category":"Cryptocurren' +
        'cy"},{"API":"Indodax","Description":"Trade your Bitcoin and othe' +
        'r assets with rupiah","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/github.com\/btcid\/indodax-official-api-do' +
        'cs","Category":"Cryptocurrency"},{"API":"INFURA Ethereum","Descr' +
        'iption":"Interaction with the Ethereum mainnet and several testn' +
        'ets","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/infura.io\/product\/ethereum","Category":"Cryptocurrency"},{"AP' +
        'I":"Kraken","Description":"Cryptocurrencies Exchange","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.krake' +
        'n.com\/rest\/","Category":"Cryptocurrency"},{"API":"KuCoin","Des' +
        'cription":"Cryptocurrency Trading Platform","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/docs.kucoin.com\/","' +
        'Category":"Cryptocurrency"},{"API":"Localbitcoins","Description"' +
        ':"P2P platform to buy and sell Bitcoins","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/localbitcoins.com\/api-docs\/' +
        '","Category":"Cryptocurrency"},{"API":"Mempool","Description":"B' +
        'itcoin API Service focusing on the transaction fee","Auth":"","H' +
        'TTPS":true,"Cors":"no","Link":"https:\/\/mempool.space\/api","Ca' +
        'tegory":"Cryptocurrency"},{"API":"MercadoBitcoin","Description":' +
        '"Brazilian Cryptocurrency Information","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/www.mercadobitcoin.com.br\/api-' +
        'doc\/","Category":"Cryptocurrency"},{"API":"Messari","Descriptio' +
        'n":"Provides API endpoints for thousands of crypto assets","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/messari.io\' +
        '/api","Category":"Cryptocurrency"},{"API":"Nexchange","Descripti' +
        'on":"Automated cryptocurrency exchange service","Auth":"","HTTPS' +
        '":false,"Cors":"yes","Link":"https:\/\/nexchange2.docs.apiary.io' +
        '\/","Category":"Cryptocurrency"},{"API":"Nomics","Description":"' +
        'Historical and realtime cryptocurrency prices and market data","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/nomic' +
        's.com\/docs\/","Category":"Cryptocurrency"},{"API":"NovaDax","De' +
        'scription":"NovaDAX API to access all market data, trading manag' +
        'ement endpoints","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/doc.novadax.com\/en-US\/#introduction","Categor' +
        'y":"Cryptocurrency"},{"API":"OKEx","Description":"Cryptocurrency' +
        ' exchange based in Seychelles","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/www.okex.com\/docs\/","Category":' +
        '"Cryptocurrency"},{"API":"Poloniex","Description":"US based digi' +
        'tal asset exchange","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/docs.poloniex.com","Category":"Cryptocurrenc' +
        'y"},{"API":"Solana JSON RPC","Description":"Provides various end' +
        'points to interact with the Solana Blockchain","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/docs.solana.com\/develo' +
        'ping\/clients\/jsonrpc-api","Category":"Cryptocurrency"},{"API":' +
        '"Technical Analysis","Description":"Cryptocurrency prices and te' +
        'chnical analysis","Auth":"apiKey","HTTPS":true,"Cors":"no","Link' +
        '":"https:\/\/technical-analysis-api.com","Category":"Cryptocurre' +
        'ncy"},{"API":"VALR","Description":"Cryptocurrency Exchange based' +
        ' in South Africa","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/docs.valr.com\/","Category":"Cryptocurrency"},' +
        '{"API":"WorldCoinIndex","Description":"Cryptocurrencies Prices",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'www.worldcoinindex.com\/apiservice","Category":"Cryptocurrency"}' +
        ',{"API":"ZMOK","Description":"Ethereum JSON RPC API and Web3 pro' +
        'vider","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/zmok.io","Category":"Cryptocurrency"},{"API":"1Forge","Descript' +
        'ion":"Forex currency market data","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/1forge.com\/forex-data-api\/ap' +
        'i-documentation","Category":"Currency Exchange"},{"API":"Amdoren' +
        '","Description":"Free currency API with over 150 currencies","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www' +
        '.amdoren.com\/currency-api\/","Category":"Currency Exchange"},{"' +
        'API":"apilayer fixer.io","Description":"Exchange rates and curre' +
        'ncy conversion","Auth":"apiKey","HTTPS":false,"Cors":"unknown","' +
        'Link":"https:\/\/fixer.io","Category":"Currency Exchange"},{"API' +
        '":"Bank of Russia","Description":"Exchange rates and currency co' +
        'nversion","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/www.cbr.ru\/development\/SXML\/","Category":"Currency Exchan' +
        'ge"},{"API":"Currency-api","Description":"Free Currency Exchange' +
        ' Rates API with 150+ Currencies & No Rate Limits","Auth":"","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/github.com\/fawazahmed0\' +
        '/currency-api#readme","Category":"Currency Exchange"},{"API":"Cu' +
        'rrencyFreaks","Description":"Provides current and historical cur' +
        'rency exchange rates with free plan 1K requests\/month","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/currencyfrea' +
        'ks.com\/","Category":"Currency Exchange"},{"API":"Currencylayer"' +
        ',"Description":"Exchange rates and currency conversion","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/currency' +
        'layer.com\/documentation","Category":"Currency Exchange"},{"API"' +
        ':"CurrencyScoop","Description":"Real-time and historical currenc' +
        'y rates JSON API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/currencyscoop.com\/api-documentation","Category":"' +
        'Currency Exchange"},{"API":"Czech National Bank","Description":"' +
        'A collection of exchange rates","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/www.cnb.cz\/cs\/financni_trhy\/devizov' +
        'y_trh\/kurzy_devizoveho_trhu\/denni_kurz.xml","Category":"Curren' +
        'cy Exchange"},{"API":"Economia.Awesome","Description":"Portugues' +
        'e free currency prices and conversion with no rate limits","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.awesom' +
        'eapi.com.br\/api-de-moedas","Category":"Currency Exchange"},{"AP' +
        'I":"ExchangeRate-API","Description":"Free currency conversion","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.e' +
        'xchangerate-api.com","Category":"Currency Exchange"},{"API":"Exc' +
        'hangerate.host","Description":"Free foreign exchange & crypto ra' +
        'tes API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/exchangerate.host","Category":"Currency Exchange"},{"API":"Ex' +
        'changeratesapi.io","Description":"Exchange rates with currency c' +
        'onversion","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/exchangeratesapi.io","Category":"Currency Exchange"},{"AP' +
        'I":"Frankfurter","Description":"Exchange rates, currency convers' +
        'ion and time series","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.frankfurter.app\/docs","Category":"Currency Excha' +
        'nge"},{"API":"FreeForexAPI","Description":"Real-time foreign exc' +
        'hange rates for major currency pairs","Auth":"","HTTPS":true,"Co' +
        'rs":"no","Link":"https:\/\/freeforexapi.com\/Home\/Api","Categor' +
        'y":"Currency Exchange"},{"API":"National Bank of Poland","Descri' +
        'ption":"A collection of currency exchange rates (data in XML and' +
        ' JSON)","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\/\/api' +
        '.nbp.pl\/en.html","Category":"Currency Exchange"},{"API":"VATCom' +
        'ply.com","Description":"Exchange rates, geolocation and VAT numb' +
        'er validation","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/www.vatcomply.com\/documentation","Category":"Currency Exch' +
        'ange"},{"API":"Lob.com","Description":"US Address Verification",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'lob.com\/","Category":"Data Validation"},{"API":"Postman Echo","' +
        'Description":"Test api server to receive and return value from H' +
        'TTP method","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/www.postman-echo.com","Category":"Data Validation"},{"API"' +
        ':"PurgoMalum","Description":"Content validator against profanity' +
        ' & obscenity","Auth":"","HTTPS":false,"Cors":"unknown","Link":"h' +
        'ttp:\/\/www.purgomalum.com","Category":"Data Validation"},{"API"' +
        ':"US Autocomplete","Description":"Enter address data quickly wit' +
        'h real-time address suggestions","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/www.smarty.com\/docs\/cloud\/us-aut' +
        'ocomplete-pro-api","Category":"Data Validation"},{"API":"US Extr' +
        'act","Description":"Extract postal addresses from any text inclu' +
        'ding emails","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/www.smarty.com\/products\/apis\/us-extract-api","Catego' +
        'ry":"Data Validation"},{"API":"US Street Address","Description":' +
        '"Validate and append data for any US postal address","Auth":"api' +
        'Key","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.smarty.com\' +
        '/docs\/cloud\/us-street-api","Category":"Data Validation"},{"API' +
        '":"vatlayer","Description":"VAT number validation","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/vatlayer.com\' +
        '/documentation","Category":"Data Validation"},{"API":"24 Pull Re' +
        'quests","Description":"Project to promote open source collaborat' +
        'ion during December","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/24pullrequests.com\/api","Category":"Development"},{"' +
        'API":"Abstract Screenshot","Description":"Take programmatic scre' +
        'enshots of web pages from any website","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.abstractapi.com\/website-' +
        'screenshot-api","Category":"Development"},{"API":"Agify.io","Des' +
        'cription":"Estimates the age from a first name","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/agify.io","Category":"Deve' +
        'lopment"},{"API":"API Gr'#225'tis","Description":"Multiples services ' +
        'and public APIs","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/apigratis.com.br\/","Category":"Development"},{"API":' +
        '"ApicAgent","Description":"Extract device details from user-agen' +
        't string","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'www.apicagent.com","Category":"Development"},{"API":"ApiFlash","' +
        'Description":"Chrome based screenshot API for developers","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apifla' +
        'sh.com\/","Category":"Development"},{"API":"apilayer userstack",' +
        '"Description":"Secure User-Agent String Lookup JSON API","Auth":' +
        '"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/userstac' +
        'k.com\/","Category":"Development"},{"API":"APIs.guru","Descripti' +
        'on":"Wikipedia for Web APIs, OpenAPI\/Swagger specs for public A' +
        'PIs","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/a' +
        'pis.guru\/api-doc\/","Category":"Development"},{"API":"Azure Dev' +
        'Ops","Description":"The Azure DevOps basic components of a REST ' +
        'API request\/response pair","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/docs.microsoft.com\/en-us\/rest\/api' +
        '\/azure\/devops","Category":"Development"},{"API":"Base","Descri' +
        'ption":"Building quick backends","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/www.base-api.io\/","Category":"Deve' +
        'lopment"},{"API":"Beeceptor","Description":"Build a mock Rest AP' +
        'I endpoint in seconds","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/beeceptor.com\/","Category":"Development"},{"API":"' +
        'Bitbucket","Description":"Bitbucket API","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/developer.atlassian.com\' +
        '/bitbucket\/api\/2\/reference\/","Category":"Development"},{"API' +
        '":"Blague.xyz","Description":"La plus grande API de Blagues FR\/' +
        'The biggest FR jokes API","Auth":"apiKey","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/blague.xyz\/","Category":"Development"},{"' +
        'API":"Blitapp","Description":"Schedule screenshots of web pages ' +
        'and sync them to your cloud","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/blitapp.com\/api\/","Category":"Dev' +
        'elopment"},{"API":"Blynk-Cloud","Description":"Control IoT Devic' +
        'es from Blynk IoT Cloud","Auth":"apiKey","HTTPS":false,"Cors":"u' +
        'nknown","Link":"https:\/\/blynkapi.docs.apiary.io\/#","Category"' +
        ':"Development"},{"API":"Bored","Description":"Find random activi' +
        'ties to fight boredom","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.boredapi.com\/","Category":"Development"},{' +
        '"API":"Brainshop.ai","Description":"Make A Free A.I Brain","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/brainshop' +
        '.ai\/","Category":"Development"},{"API":"Browshot","Description"' +
        ':"Easily make screenshots of web pages in any screen size, as an' +
        'y device","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/browshot.com\/api\/documentation","Category":"Development"' +
        '},{"API":"CDNJS","Description":"Library info on CDNJS","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.cdnjs.com\/' +
        'libraries\/jquery","Category":"Development"},{"API":"Changelogs.' +
        'md","Description":"Structured changelog metadata from open sourc' +
        'e projects","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/changelogs.md","Category":"Development"},{"API":"Ciprand",' +
        '"Description":"Secure random string generator","Auth":"","HTTPS"' +
        ':true,"Cors":"no","Link":"https:\/\/github.com\/polarspetroll\/c' +
        'iprand","Category":"Development"},{"API":"Cloudflare Trace","Des' +
        'cription":"Get IP Address, Timestamp, User Agent, Country Code, ' +
        'IATA, HTTP Version, TLS\/SSL Version & More","Auth":"","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/github.com\/fawazahmed0\/clou' +
        'dflare-trace-api","Category":"Development"},{"API":"Codex","Desc' +
        'ription":"Online Compiler for Various Languages","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/github.com\/Jaagrav\/' +
        'CodeX","Category":"Development"},{"API":"Contentful Images","Des' +
        'cription":"Used to retrieve and apply transformations to images"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www' +
        '.contentful.com\/developers\/docs\/references\/images-api\/","Ca' +
        'tegory":"Development"},{"API":"CORS Proxy","Description":"Get ar' +
        'ound the dreaded CORS error by using this proxy as a middle man"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.co' +
        'm\/burhanuday\/cors-proxy","Category":"Development"},{"API":"Cou' +
        'ntAPI","Description":"Free and simple counting service. You can ' +
        'use it to track page hits and specific events","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/countapi.xyz","Category":"D' +
        'evelopment"},{"API":"Databricks","Description":"Service to manag' +
        'e your databricks account,clusters, notebooks, jobs and workspac' +
        'es","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'docs.databricks.com\/dev-tools\/api\/latest\/index.html","Catego' +
        'ry":"Development"},{"API":"DigitalOcean Status","Description":"S' +
        'tatus of all DigitalOcean services","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/status.digitalocean.com\/api","Cat' +
        'egory":"Development"},{"API":"Docker Hub","Description":"Interac' +
        't with Docker Hub","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/docs.docker.com\/docker-hub\/api\/latest\/","Cate' +
        'gory":"Development"},{"API":"DomainDb Info","Description":"Domai' +
        'n name search to find all domains containing particular words\/p' +
        'hrases\/etc","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/api.domainsdb.info\/","Category":"Development"},{"API":"E' +
        'xtendsClass JSON Storage","Description":"A simple JSON store API' +
        '","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/extendsc' +
        'lass.com\/json-storage.html","Category":"Development"},{"API":"G' +
        'eekFlare","Description":"Provide numerous capabilities for impor' +
        'tant testing and monitoring methods for websites","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apidocs.geekfl' +
        'are.com\/docs\/geekflare-api","Category":"Development"},{"API":"' +
        'Genderize.io","Description":"Estimates a gender from a first nam' +
        'e","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/genderi' +
        'ze.io","Category":"Development"},{"API":"GETPing","Description":' +
        '"Trigger an email notification with a simple GET request","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ge' +
        'tping.info","Category":"Development"},{"API":"Ghost","Descriptio' +
        'n":"Get Published content into your Website, App or other embedd' +
        'ed media","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/ghost.org\/","Category":"Development"},{"API":"GitHub","De' +
        'scription":"Make use of GitHub repositories, code and user info ' +
        'programmatically","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/docs.github.com\/en\/free-pro-team@latest\/rest","C' +
        'ategory":"Development"},{"API":"Gitlab","Description":"Automate ' +
        'GitLab interaction programmatically","Auth":"OAuth","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/docs.gitlab.com\/ee\/api\/",' +
        '"Category":"Development"},{"API":"Gitter","Description":"Chat fo' +
        'r Developers","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/developer.gitter.im\/docs\/welcome","Category":"Dev' +
        'elopment"},{"API":"Glitterly","Description":"Image generation AP' +
        'I","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/d' +
        'evelopers.glitterly.app","Category":"Development"},{"API":"Googl' +
        'e Docs","Description":"API to read, write, and format Google Doc' +
        's documents","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/developers.google.com\/docs\/api\/reference\/rest","' +
        'Category":"Development"},{"API":"Google Firebase","Description":' +
        '"Google'#39's mobile application development platform that helps bui' +
        'ld, improve, and grow app","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/firebase.google.com\/docs","Category":"De' +
        'velopment"},{"API":"Google Fonts","Description":"Metadata for al' +
        'l families served by Google Fonts","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/developers.google.com\/fonts\' +
        '/docs\/developer_api","Category":"Development"},{"API":"Google K' +
        'eep","Description":"API to read, write, and format Google Keep n' +
        'otes","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developers.google.com\/keep\/api\/reference\/rest","Categor' +
        'y":"Development"},{"API":"Google Sheets","Description":"API to r' +
        'ead, write, and format Google Sheets data","Auth":"OAuth","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developers.google.com\' +
        '/sheets\/api\/reference\/rest","Category":"Development"},{"API":' +
        '"Google Slides","Description":"API to read, write, and format Go' +
        'ogle Slides presentations","Auth":"OAuth","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/developers.google.com\/slides\/api\/re' +
        'ference\/rest","Category":"Development"},{"API":"Gorest","Descri' +
        'ption":"Online REST API for Testing and Prototyping","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gorest.co.in' +
        '\/","Category":"Development"},{"API":"Hasura","Description":"Gra' +
        'phQL and REST API Engine with built in Authorization","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/hasura.io\/ope' +
        'nsource\/","Category":"Development"},{"API":"Heroku","Descriptio' +
        'n":"REST API to programmatically create apps, provision add-ons ' +
        'and perform other task on Heroku","Auth":"OAuth","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/devcenter.heroku.com\/articles\/pla' +
        'tform-api-reference\/","Category":"Development"},{"API":"host-t.' +
        'com","Description":"Basic DNS query via HTTP GET request","Auth"' +
        ':"","HTTPS":true,"Cors":"no","Link":"https:\/\/host-t.com","Cate' +
        'gory":"Development"},{"API":"Host.io","Description":"Domains Dat' +
        'a API for Developers","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/host.io","Category":"Development"},{"API":"HTT' +
        'P2.Pro","Description":"Test endpoints for client and server HTTP' +
        '\/2 protocol support","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/http2.pro\/doc\/api","Category":"Development"},{' +
        '"API":"Httpbin","Description":"A Simple HTTP Request & Response ' +
        'Service","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/h' +
        'ttpbin.org\/","Category":"Development"},{"API":"Httpbin Cloudfla' +
        're","Description":"A Simple HTTP Request & Response Service with' +
        ' HTTP\/3 Support by Cloudflare","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/cloudflare-quic.com\/b\/","Category":"Deve' +
        'lopment"},{"API":"Hunter","Description":"API for domain search, ' +
        'professional email finder, author finder and email verifier","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/hun' +
        'ter.io\/api","Category":"Development"},{"API":"IBM Text to Speec' +
        'h","Description":"Convert text to speech","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/cloud.ibm.com\/docs\/text-' +
        'to-speech\/getting-started.html","Category":"Development"},{"API' +
        '":"Icanhazepoch","Description":"Get Epoch time","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/icanhazepoch.com","Categor' +
        'y":"Development"},{"API":"Icanhazip","Description":"IP Address A' +
        'PI","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/major.' +
        'io\/icanhazip-com-faq\/","Category":"Development"},{"API":"IFTTT' +
        '","Description":"IFTTT Connect API","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/platform.ifttt.com\/docs\/connect_' +
        'api","Category":"Development"},{"API":"Image-Charts","Descriptio' +
        'n":"Generate charts, QR codes and graph images","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/documentation.image-charts' +
        '.com\/","Category":"Development"},{"API":"import.io","Descriptio' +
        'n":"Retrieve structured data from a website or RSS feed","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"http:\/\/api.docs' +
        '.import.io\/","Category":"Development"},{"API":"ip-fast.com","De' +
        'scription":"IP address, country and city","Auth":"","HTTPS":true' +
        ',"Cors":"yes","Link":"https:\/\/ip-fast.com\/docs\/","Category":' +
        '"Development"},{"API":"IP2WHOIS Information Lookup","Description' +
        '":"WHOIS domain name lookup","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/www.ip2whois.com\/","Category":"Dev' +
        'elopment"},{"API":"ipfind.io","Description":"Geographic location' +
        ' of an IP address or any domain name along with some other usefu' +
        'l information","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/ipfind.io","Category":"Development"},{"API":"IPify","' +
        'Description":"A simple IP Address API","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/www.ipify.org\/","Category":"De' +
        'velopment"},{"API":"IPinfo","Description":"Another simple IP Add' +
        'ress API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/ipinfo.io\/developers","Category":"Development"},{"API":"jsD' +
        'elivr","Description":"Package info and download stats on jsDeliv' +
        'r CDN","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/git' +
        'hub.com\/jsdelivr\/data.jsdelivr.com","Category":"Development"},' +
        '{"API":"JSON 2 JSONP","Description":"Convert JSON to JSONP (on-t' +
        'he-fly) for easy cross-domain data requests using client-side Ja' +
        'vaScript","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/json2jsonp.com\/","Category":"Development"},{"API":"JSONbin.' +
        'io","Description":"Free JSON storage service. Ideal for small sc' +
        'ale Web apps, Websites and Mobile apps","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/jsonbin.io","Category":"Deve' +
        'lopment"},{"API":"Kroki","Description":"Creates diagrams from te' +
        'xtual descriptions","Auth":"","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/kroki.io","Category":"Development"},{"API":"License-AP' +
        'I","Description":"Unofficial REST API for choosealicense.com","A' +
        'uth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/github.com\/c' +
        'mccandless\/license-api\/blob\/master\/README.md","Category":"De' +
        'velopment"},{"API":"Logs.to","Description":"Generate logs","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/logs.' +
        'to\/","Category":"Development"},{"API":"Lua Decompiler","Descrip' +
        'tion":"Online Lua 5.1 Decompiler","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/lua-decompiler.ferib.dev\/","Category":"' +
        'Development"},{"API":"MAC address vendor lookup","Description":"' +
        'Retrieve vendor details and other information regarding a given ' +
        'MAC address or an OUI","Auth":"apiKey","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/macaddress.io\/api","Category":"Development"}' +
        ',{"API":"Micro DB","Description":"Simple database service","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/m3o.c' +
        'om\/db","Category":"Development"},{"API":"MicroENV","Description' +
        '":"Fake Rest API for developers","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/microenv.com\/","Category":"Developme' +
        'nt"},{"API":"Mocky","Description":"Mock user defined test JSON f' +
        'or REST API endpoints","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/designer.mocky.io\/","Category":"Development"},{"AP' +
        'I":"MY IP","Description":"Get IP address information","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.myip.com\/ap' +
        'i-docs\/","Category":"Development"},{"API":"Nationalize.io","Des' +
        'cription":"Estimate the nationality of a first name","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/nationalize.io","Cate' +
        'gory":"Development"},{"API":"Netlify","Description":"Netlify is ' +
        'a hosting service for the programmable web","Auth":"OAuth","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.netlify.com\/api' +
        '\/get-started\/","Category":"Development"},{"API":"NetworkCalc",' +
        '"Description":"Network calculators, including subnets, DNS, bina' +
        'ry, and security tools","Auth":"","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/networkcalc.com\/api\/docs","Category":"Developmen' +
        't"},{"API":"npm Registry","Description":"Query information about' +
        ' your favorite Node.js libraries programatically","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/github.com\/npm\/reg' +
        'istry\/blob\/master\/docs\/REGISTRY-API.md","Category":"Developm' +
        'ent"},{"API":"OneSignal","Description":"Self-serve customer enga' +
        'gement solution for Push Notifications, Email, SMS & In-App","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/doc' +
        'umentation.onesignal.com\/docs\/onesignal-api","Category":"Devel' +
        'opment"},{"API":"Open Page Rank","Description":"API for calculat' +
        'ing and comparing metrics of different websites using Page Rank ' +
        'algorithm","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.domcop.com\/openpagerank\/","Category":"Developme' +
        'nt"},{"API":"OpenAPIHub","Description":"The All-in-one API Platf' +
        'orm","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/hub.openapihub.com\/","Category":"Development"},{"AP' +
        'I":"OpenGraphr","Description":"Really simple API to retrieve Ope' +
        'n Graph data from an URL","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/opengraphr.com\/docs\/1.0\/overview","' +
        'Category":"Development"},{"API":"oyyi","Description":"API for Fa' +
        'ke Data, image\/video conversion, optimization, pdf optimization' +
        ' and thumbnail generation","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/oyyi.xyz\/docs\/1.0","Category":"Development"},' +
        '{"API":"PageCDN","Description":"Public API for javascript, css a' +
        'nd font libraries on PageCDN","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/pagecdn.com\/docs\/public-api","Catego' +
        'ry":"Development"},{"API":"Postman","Description":"Tool for test' +
        'ing APIs","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/www.postman.com\/postman\/workspace\/postman-public-wo' +
        'rkspace\/documentation\/12959542-c8142d51-e97c-46b6-bd77-52bb667' +
        '12c9a","Category":"Development"},{"API":"ProxyCrawl","Descriptio' +
        'n":"Scraping and crawling anticaptcha service","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/proxycrawl.com","' +
        'Category":"Development"},{"API":"ProxyKingdom","Description":"Ro' +
        'tating Proxy API that produces a working proxy on every request"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/pro' +
        'xykingdom.com","Category":"Development"},{"API":"Pusher Beams","' +
        'Description":"Push notifications for Android & iOS","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pusher.com\/' +
        'beams","Category":"Development"},{"API":"QR code","Description":' +
        '"Create an easy to read QR code and URL shortener","Auth":"","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/www.qrtag.net\/api\/","' +
        'Category":"Development"},{"API":"QR code","Description":"Generat' +
        'e and decode \/ read QR code graphics","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"http:\/\/goqr.me\/api\/","Category":"Deve' +
        'lopment"},{"API":"Qrcode Monkey","Description":"Integrate custom' +
        ' and unique looking QR codes into your system or workflow","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.qrcode-' +
        'monkey.com\/qr-code-api-with-logo\/","Category":"Development"},{' +
        '"API":"QuickChart","Description":"Generate chart and graph image' +
        's","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/quickch' +
        'art.io\/","Category":"Development"},{"API":"Random Stuff","Descr' +
        'iption":"Can be used to get AI Response, jokes, memes, and much ' +
        'more at lightning-fast speed","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/api-docs.pgamerx.com\/","Category":"De' +
        'velopment"},{"API":"Rejax","Description":"Reverse AJAX service t' +
        'o notify clients","Auth":"apiKey","HTTPS":true,"Cors":"no","Link' +
        '":"https:\/\/rejax.io\/","Category":"Development"},{"API":"ReqRe' +
        's","Description":"A hosted REST-API ready to respond to your AJA' +
        'X requests","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/reqres.in\/ ","Category":"Development"},{"API":"RSS feed t' +
        'o JSON","Description":"Returns RSS feed in JSON format using fee' +
        'd URL","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/rss' +
        '-to-json-serverless-api.vercel.app","Category":"Development"},{"' +
        'API":"SavePage.io","Description":"A free, RESTful API used to sc' +
        'reenshot any desktop, or mobile website","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/www.savepage.io","Category"' +
        ':"Development"},{"API":"ScrapeNinja","Description":"Scraping API' +
        ' with Chrome fingerprint and residential proxies","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/scrapeninja.ne' +
        't","Category":"Development"},{"API":"ScraperApi","Description":"' +
        'Easily build scalable web scrapers","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/www.scraperapi.com","Categor' +
        'y":"Development"},{"API":"scraperBox","Description":"Undetectabl' +
        'e web scraping API","Auth":"apiKey","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/scraperbox.com\/","Category":"Development"},{"AP' +
        'I":"scrapestack","Description":"Real-time, Scalable Proxy & Web ' +
        'Scraping REST API","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/scrapestack.com\/","Category":"Development"},' +
        '{"API":"ScrapingAnt","Description":"Headless Chrome scraping wit' +
        'h a simple API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/scrapingant.com","Category":"Development"},{"API' +
        '":"ScrapingDog","Description":"Proxy API for Web scraping","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.s' +
        'crapingdog.com\/","Category":"Development"},{"API":"ScreenshotAP' +
        'I.net","Description":"Create pixel-perfect website screenshots",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/scre' +
        'enshotapi.net\/","Category":"Development"},{"API":"Serialif Colo' +
        'r","Description":"Color conversion, complementary, grayscale and' +
        ' contrasted text","Auth":"","HTTPS":true,"Cors":"no","Link":"htt' +
        'ps:\/\/color.serialif.com\/","Category":"Development"},{"API":"s' +
        'erpstack","Description":"Real-Time & Accurate Google Search Resu' +
        'lts API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/serpstack.com\/","Category":"Development"},{"API":"Sheetsu"' +
        ',"Description":"Easy google sheets integration","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/sheetsu.com\/","' +
        'Category":"Development"},{"API":"SHOUTCLOUD","Description":"ALL-' +
        'CAPS AS A SERVICE","Auth":"","HTTPS":false,"Cors":"unknown","Lin' +
        'k":"http:\/\/shoutcloud.io\/","Category":"Development"},{"API":"' +
        'Sonar","Description":"Project Sonar DNS Enumeration API","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/Cgboa' +
        'l\/SonarSearch","Category":"Development"},{"API":"SonarQube","De' +
        'scription":"SonarQube REST APIs to detect bugs, code smells & se' +
        'curity vulnerabilities","Auth":"OAuth","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/sonarcloud.io\/web_api","Category":"Devel' +
        'opment"},{"API":"StackExchange","Description":"Q&A forum for dev' +
        'elopers","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/api.stackexchange.com\/","Category":"Development"},{"API' +
        '":"Statically","Description":"A free CDN for developers","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/statically.io\/",' +
        '"Category":"Development"},{"API":"Supportivekoala","Description"' +
        ':"Autogenerate images with template","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/developers.supportivekoala.com\' +
        '/","Category":"Development"},{"API":"Tyk","Description":"Api and' +
        ' service management platform","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/tyk.io\/open-source\/","Category":"Dev' +
        'elopment"},{"API":"Wandbox","Description":"Code compiler support' +
        'ing 35+ languages mentioned at wandbox.org","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/github.com\/melpon\/wandbo' +
        'x\/blob\/master\/kennel2\/API.rst","Category":"Development"},{"A' +
        'PI":"WebScraping.AI","Description":"Web Scraping API with built-' +
        'in proxies and JS rendering","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/webscraping.ai\/","Category":"Developme' +
        'nt"},{"API":"ZenRows","Description":"Web Scraping API that bypas' +
        'ses anti-bot solutions while offering JS rendering, and rotating' +
        ' proxies","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/www.zenrows.com\/","Category":"Development"},{"API":"C' +
        'hinese Character Web","Description":"Chinese character definitio' +
        'ns and pronunciations","Auth":"","HTTPS":false,"Cors":"no","Link' +
        '":"http:\/\/ccdb.hemiola.com\/","Category":"Dictionaries"},{"API' +
        '":"Chinese Text Project","Description":"Online open-access digit' +
        'al library for pre-modern Chinese texts","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/ctext.org\/tools\/api","Categ' +
        'ory":"Dictionaries"},{"API":"Collins","Description":"Bilingual D' +
        'ictionary and Thesaurus Data","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/api.collinsdictionary.com\/api\/v1' +
        '\/documentation\/html\/","Category":"Dictionaries"},{"API":"Free' +
        ' Dictionary","Description":"Definitions, phonetics, pronounciati' +
        'ons, parts of speech, examples, synonyms","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/dictionaryapi.dev\/","Catego' +
        'ry":"Dictionaries"},{"API":"Indonesia Dictionary","Description":' +
        '"Indonesia dictionary many words","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/new-kbbi-api.herokuapp.com\/","Categ' +
        'ory":"Dictionaries"},{"API":"Lingua Robot","Description":"Word d' +
        'efinitions, pronunciations, synonyms, antonyms and others","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.lingu' +
        'arobot.io","Category":"Dictionaries"},{"API":"Merriam-Webster","' +
        'Description":"Dictionary and Thesaurus Data","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/dictionaryapi.com\/' +
        '","Category":"Dictionaries"},{"API":"OwlBot","Description":"Defi' +
        'nitions with example sentence and photo if available","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/owlbot.info\/"' +
        ',"Category":"Dictionaries"},{"API":"Oxford","Description":"Dicti' +
        'onary Data","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"htt' +
        'ps:\/\/developer.oxforddictionaries.com\/","Category":"Dictionar' +
        'ies"},{"API":"Synonyms","Description":"Synonyms, thesaurus and a' +
        'ntonyms information for any given word","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.synonyms.com\/synony' +
        'ms_api.php","Category":"Dictionaries"},{"API":"Wiktionary","Desc' +
        'ription":"Collaborative dictionary data","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/en.wiktionary.org\/w\/api.php","C' +
        'ategory":"Dictionaries"},{"API":"Wordnik","Description":"Diction' +
        'ary Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/developer.wordnik.com","Category":"Dictionaries"},{"AP' +
        'I":"Words","Description":"Definitions and synonyms for more than' +
        ' 150,000 words","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/www.wordsapi.com\/docs\/","Category":"Dictionari' +
        'es"},{"API":"Airtable","Description":"Integrate with Airtable","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/a' +
        'irtable.com\/api","Category":"Documents & Productivity"},{"API":' +
        '"Api2Convert","Description":"Online File Conversion API","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.api' +
        '2convert.com\/","Category":"Documents & Productivity"},{"API":"a' +
        'pilayer pdflayer","Description":"HTML\/URL to PDF","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pdflayer.com"' +
        ',"Category":"Documents & Productivity"},{"API":"Asana","Descript' +
        'ion":"Programmatic access to all data in your asana system","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/develope' +
        'rs.asana.com\/docs","Category":"Documents & Productivity"},{"API' +
        '":"ClickUp","Description":"ClickUp is a robust, cloud-based proj' +
        'ect management tool for boosting productivity","Auth":"OAuth","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/clickup.com\/api",' +
        '"Category":"Documents & Productivity"},{"API":"Clockify","Descri' +
        'ption":"Clockify'#39's REST-based API can be used to push\/pull data' +
        ' to\/from it & integrate it with other systems","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/clockify.me\/dev' +
        'elopers-api ","Category":"Documents & Productivity"},{"API":"Clo' +
        'udConvert","Description":"Online file converter for audio, video' +
        ', document, ebook, archive, image, spreadsheet, presentation","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/cl' +
        'oudconvert.com\/api\/v2","Category":"Documents & Productivity"},' +
        '{"API":"Cloudmersive Document and Data Conversion","Description"' +
        ':"HTML\/URL to PDF\/PNG, Office documents to PDF, image conversi' +
        'on","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'cloudmersive.com\/convert-api","Category":"Documents & Productiv' +
        'ity"},{"API":"Code::Stats","Description":"Automatic time trackin' +
        'g for programmers","Auth":"apiKey","HTTPS":true,"Cors":"no","Lin' +
        'k":"https:\/\/codestats.net\/api-docs","Category":"Documents & P' +
        'roductivity"},{"API":"CraftMyPDF","Description":"Generate PDF do' +
        'cuments from templates with a drop-and-drop editor and a simple ' +
        'API","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'craftmypdf.com","Category":"Documents & Productivity"},{"API":"F' +
        'lowdash","Description":"Automate business workflows","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.flowda' +
        'sh.com\/docs\/api-introduction","Category":"Documents & Producti' +
        'vity"},{"API":"Html2PDF","Description":"HTML\/URL to PDF","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/html2p' +
        'df.app\/","Category":"Documents & Productivity"},{"API":"iLovePD' +
        'F","Description":"Convert, merge, split, extract text and add pa' +
        'ge numbers for PDFs. Free for 250 documents\/month","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/developer.ilovep' +
        'df.com\/","Category":"Documents & Productivity"},{"API":"JIRA","' +
        'Description":"JIRA is a proprietary issue tracking product that ' +
        'allows bug tracking and agile project management","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.atlas' +
        'sian.com\/server\/jira\/platform\/rest-apis\/","Category":"Docum' +
        'ents & Productivity"},{"API":"Mattermost","Description":"An open' +
        ' source platform for developer collaboration","Auth":"OAuth","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/api.mattermost.com\' +
        '/","Category":"Documents & Productivity"},{"API":"Mercury","Desc' +
        'ription":"Web parser","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/mercury.postlight.com\/web-parser\/","Cate' +
        'gory":"Documents & Productivity"},{"API":"Monday","Description":' +
        '"Programmatically access and update data inside a monday.com acc' +
        'ount","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/api.developer.monday.com\/docs","Category":"Documents & Pr' +
        'oductivity"},{"API":"Notion","Description":"Integrate with Notio' +
        'n","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/developers.notion.com\/docs\/getting-started","Category":"Docu' +
        'ments & Productivity"},{"API":"PandaDoc","Description":"DocGen a' +
        'nd eSignatures API","Auth":"apiKey","HTTPS":true,"Cors":"no","Li' +
        'nk":"https:\/\/developers.pandadoc.com","Category":"Documents & ' +
        'Productivity"},{"API":"Pocket","Description":"Bookmarking servic' +
        'e","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/getpocket.com\/developer\/","Category":"Documents & Productivi' +
        'ty"},{"API":"Podio","Description":"File sharing and productivity' +
        '","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/developers.podio.com","Category":"Documents & Productivity"},{"' +
        'API":"PrexView","Description":"Data from XML or JSON to PDF, HTM' +
        'L or Image","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/prexview.com","Category":"Documents & Productivity"}' +
        ',{"API":"Restpack","Description":"Provides screenshot, HTML to P' +
        'DF and content extraction APIs","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/restpack.io\/","Category":"Docum' +
        'ents & Productivity"},{"API":"Todoist","Description":"Todo Lists' +
        '","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/developer.todoist.com","Category":"Documents & Productivity"},{' +
        '"API":"Smart Image Enhancement API","Description":"Performs imag' +
        'e upscaling by adding detail to images through multiple super-re' +
        'solution algorithms","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/apilayer.com\/marketplace\/image_enhancemen' +
        't-api","Category":"Documents & Productivity"},{"API":"Vector Exp' +
        'ress v2.0","Description":"Free vector file converting API","Auth' +
        '":"","HTTPS":true,"Cors":"no","Link":"https:\/\/vector.express",' +
        '"Category":"Documents & Productivity"},{"API":"WakaTime","Descri' +
        'ption":"Automated time tracking leaderboards for programmers","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/wakatime' +
        '.com\/developers","Category":"Documents & Productivity"},{"API":' +
        '"Zube","Description":"Full stack project management","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"unknown","Link":"https:\/\/zube.io\/doc' +
        's\/api","Category":"Documents & Productivity"},{"API":"Abstract ' +
        'Email Validation","Description":"Validate email addresses for de' +
        'liverability and spam","Auth":"apiKey","HTTPS":true,"Cors":"yes"' +
        ',"Link":"https:\/\/www.abstractapi.com\/email-verification-valid' +
        'ation-api","Category":"Email"},{"API":"apilayer mailboxlayer","D' +
        'escription":"Email address validation","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/mailboxlayer.com","Catego' +
        'ry":"Email"},{"API":"Cloudmersive Validate","Description":"Valid' +
        'ate email addresses, phone numbers, VAT numbers and domain names' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/cl' +
        'oudmersive.com\/validate-api","Category":"Email"},{"API":"Disify' +
        '","Description":"Validate and detect disposable and temporary em' +
        'ail addresses","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/www.disify.com\/","Category":"Email"},{"API":"DropMail","De' +
        'scription":"GraphQL API for creating and managing ephemeral e-ma' +
        'il inboxes","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/dropmail.me\/api\/#live-demo","Category":"Email"},{"API":"' +
        'EVA","Description":"Validate email addresses","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/eva.pingutil.com\/","Categor' +
        'y":"Email"},{"API":"Guerrilla Mail","Description":"Disposable te' +
        'mporary Email addresses","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/www.guerrillamail.com\/GuerrillaMailAPI.html"' +
        ',"Category":"Email"},{"API":"ImprovMX","Description":"API for fr' +
        'ee email forwarding service","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/improvmx.com\/api","Category":"Emai' +
        'l"},{"API":"Kickbox","Description":"Email verification API","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/open.kickbox.c' +
        'om\/","Category":"Email"},{"API":"mail.gw","Description":"10 Min' +
        'ute Mail","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'docs.mail.gw","Category":"Email"},{"API":"mail.tm","Description"' +
        ':"Temporary Email Service","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/docs.mail.tm","Category":"Email"},{"API":"Mailb' +
        'oxValidator","Description":"Validate email address to improve de' +
        'liverability","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.mailboxvalidator.com\/api-email-free","Categor' +
        'y":"Email"},{"API":"MailCheck.ai","Description":"Prevent users t' +
        'o sign up with temporary email addresses","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/www.mailcheck.ai\/#documenta' +
        'tion","Category":"Email"},{"API":"Mailtrap","Description":"A ser' +
        'vice for the safe testing of emails sent from the development an' +
        'd staging environments","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/mailtrap.docs.apiary.io\/#","Category":"' +
        'Email"},{"API":"Sendgrid","Description":"A cloud-based SMTP prov' +
        'ider that allows you to send emails without having to maintain e' +
        'mail servers","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/docs.sendgrid.com\/api-reference\/","Category":"Em' +
        'ail"},{"API":"Sendinblue","Description":"A service that provides' +
        ' solutions relating to marketing and\/or transactional email and' +
        '\/or SMS","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/developers.sendinblue.com\/docs","Category":"Email"},{' +
        '"API":"Verifier","Description":"Verifies that a given email is r' +
        'eal","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\' +
        '/verifier.meetchopra.com\/docs#\/","Category":"Email"},{"API":"c' +
        'hucknorris.io","Description":"JSON API for hand curated Chuck No' +
        'rris jokes","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/api.chucknorris.io","Category":"Entertainment"},{"API":"Co' +
        'rporate Buzz Words","Description":"REST API for Corporate Buzz W' +
        'ords","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/gith' +
        'ub.com\/sameerkumar18\/corporate-bs-generator-api","Category":"E' +
        'ntertainment"},{"API":"Excuser","Description":"Get random excuse' +
        's for various situations","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/excuser.herokuapp.com\/","Category":"Enterta' +
        'inment"},{"API":"Fun Fact","Description":"A simple HTTPS api tha' +
        't can randomly select and return a fact from the FFA database","' +
        'Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.aakhilv' +
        '.me","Category":"Entertainment"},{"API":"Imgflip","Description":' +
        '"Gets an array of popular memes","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/imgflip.com\/api","Category":"Enterta' +
        'inment"},{"API":"Meme Maker","Description":"REST API for create ' +
        'your own meme","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/mememaker.github.io\/API\/","Category":"Entertainment"}' +
        ',{"API":"NaMoMemes","Description":"Memes on Narendra Modi","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\' +
        '/theIYD\/NaMoMemes","Category":"Entertainment"},{"API":"Random U' +
        'seless Facts","Description":"Get useless, but true facts","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/uselessfacts' +
        '.jsph.pl\/","Category":"Entertainment"},{"API":"Techy","Descript' +
        'ion":"JSON and Plaintext API for tech-savvy sounding phrases","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/techy-ap' +
        'i.vercel.app\/","Category":"Entertainment"},{"API":"Yo Momma Jok' +
        'es","Description":"REST API for Yo Momma Jokes","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/github.com\/beanboi7\/' +
        'yomomma-apiv2","Category":"Entertainment"},{"API":"BreezoMeter P' +
        'ollen","Description":"Daily Forecast pollen conditions data for ' +
        'a specific location","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/docs.breezometer.com\/api-documentation\/po' +
        'llen-api\/v2\/","Category":"Environment"},{"API":"Carbon Interfa' +
        'ce","Description":"API to calculate carbon (C02) emissions estim' +
        'ates for common C02 emitting activities","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/docs.carboninterface.com\/"' +
        ',"Category":"Environment"},{"API":"Climatiq","Description":"Calc' +
        'ulate the environmental footprint created by a broad range of em' +
        'ission-generating activities","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/docs.climatiq.io","Category":"Environm' +
        'ent"},{"API":"Cloverly","Description":"API calculates the impact' +
        ' of common carbon-intensive activities in real time","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.cloverl' +
        'y.com\/carbon-offset-documentation","Category":"Environment"},{"' +
        'API":"CO2 Offset","Description":"API calculates and validates th' +
        'e carbon footprint","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/co2offset.io\/api.html","Category":"Environment"},' +
        '{"API":"Danish data service Energi","Description":"Open energy d' +
        'ata from Energinet to society","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/www.energidataservice.dk\/","Category":' +
        '"Environment"},{"API":"Gr'#252'nstromIndex","Description":"Green Powe' +
        'r Index for Germany (Gr'#252'nstromindex\/GSI)","Auth":"","HTTPS":fal' +
        'se,"Cors":"yes","Link":"https:\/\/gruenstromindex.de\/","Categor' +
        'y":"Environment"},{"API":"IQAir","Description":"Air quality and ' +
        'weather data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.iqair.com\/air-pollution-data-api","Category":' +
        '"Environment"},{"API":"Luchtmeetnet","Description":"Predicted an' +
        'd actual air quality components for The Netherlands (RIVM)","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api-docs.l' +
        'uchtmeetnet.nl\/","Category":"Environment"},{"API":"National Gri' +
        'd ESO","Description":"Open data from Great Britain'#8217's Electricity' +
        ' System Operator","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/data.nationalgrideso.com\/","Category":"Environment"' +
        '},{"API":"OpenAQ","Description":"Open air quality data","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.ope' +
        'naq.org\/","Category":"Environment"},{"API":"PM2.5 Open Data Por' +
        'tal","Description":"Open low-cost PM2.5 sensor data","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/pm25.lass-net.org' +
        '\/#apis","Category":"Environment"},{"API":"PM25.in","Description' +
        '":"Air quality of China","Auth":"apiKey","HTTPS":false,"Cors":"u' +
        'nknown","Link":"http:\/\/www.pm25.in\/api_doc","Category":"Envir' +
        'onment"},{"API":"PVWatts","Description":"Energy production photo' +
        'voltaic (PV) energy systems","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/developer.nrel.gov\/docs\/solar\/pv' +
        'watts\/v6\/","Category":"Environment"},{"API":"Srp Energy","Desc' +
        'ription":"Hourly usage energy report for Srp customers","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/srpenergy-api' +
        '-client-python.readthedocs.io\/en\/latest\/api.html","Category":' +
        '"Environment"},{"API":"UK Carbon Intensity","Description":"The O' +
        'fficial Carbon Intensity API for Great Britain developed by Nati' +
        'onal Grid","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/carbon-intensity.github.io\/api-definitions\/#carbon-intens' +
        'ity-api-v1-0-0","Category":"Environment"},{"API":"Website Carbon' +
        '","Description":"API to estimate the carbon footprint of loading' +
        ' web pages","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/api.websitecarbon.com\/","Category":"Environment"},{"API":' +
        '"Eventbrite","Description":"Find events","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.eventbrite.com\/plat' +
        'form\/api\/","Category":"Events"},{"API":"SeatGeek","Description' +
        '":"Search events, venues and performers","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/platform.seatgeek.com\/' +
        '","Category":"Events"},{"API":"Ticketmaster","Description":"Sear' +
        'ch events, attractions, or venues","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"http:\/\/developer.ticketmaster.com\/pr' +
        'oducts-and-docs\/apis\/getting-started\/","Category":"Events"},{' +
        '"API":"Abstract VAT Validation","Description":"Validate VAT numb' +
        'ers and calculate VAT rates","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/www.abstractapi.com\/vat-validation-rat' +
        'es-api","Category":"Finance"},{"API":"Aletheia","Description":"I' +
        'nsider trading data, earnings call analysis, financial statement' +
        's, and more","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/aletheiaapi.com\/","Category":"Finance"},{"API":"Alpaca' +
        '","Description":"Realtime and historical market data on all US e' +
        'quities and ETFs","Auth":"apiKey","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/alpaca.markets\/docs\/api-documentation\/api-v2\/m' +
        'arket-data\/alpaca-data-api-v2\/","Category":"Finance"},{"API":"' +
        'Alpha Vantage","Description":"Realtime and historical stock data' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/www.alphavantage.co\/","Category":"Finance"},{"API":"apilayer ' +
        'marketstack","Description":"Real-Time, Intraday & Historical Mar' +
        'ket Data API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/marketstack.com\/","Category":"Finance"},{"API":"B' +
        'anco do Brasil","Description":"All Banco do Brasil financial tra' +
        'nsaction APIs","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/developers.bb.com.br\/home","Category":"Finance"},{"AP' +
        'I":"Bank Data API","Description":"Instant IBAN and SWIFT number ' +
        'validation across the globe","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/apilayer.com\/marketplace\/bank_dat' +
        'a-api","Category":"Finance"},{"API":"Billplz","Description":"Pay' +
        'ment platform","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/www.billplz.com\/api","Category":"Finance"},{"API' +
        '":"Binlist","Description":"Public access to a database of IIN\/B' +
        'IN information","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/binlist.net\/","Category":"Finance"},{"API":"Boleto.Cl' +
        'oud","Description":"A api to generate boletos in Brazil","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/boleto.' +
        'cloud\/","Category":"Finance"},{"API":"Citi","Description":"All ' +
        'Citigroup account and statement data APIs","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/sandbox.developerhub.' +
        'citi.com\/api-catalog-list","Category":"Finance"},{"API":"Econdb' +
        '","Description":"Global macroeconomic data","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/www.econdb.com\/api\/","Catego' +
        'ry":"Finance"},{"API":"Fed Treasury","Description":"U.S. Departm' +
        'ent of the Treasury Data","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/fiscaldata.treasury.gov\/api-documentation\/' +
        '","Category":"Finance"},{"API":"Finage","Description":"Finage is' +
        ' a stock, currency, cryptocurrency, indices, and ETFs real-time ' +
        '& historical data provider","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/finage.co.uk","Category":"Finance"},' +
        '{"API":"Financial Modeling Prep","Description":"Realtime and his' +
        'torical stock data","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/site.financialmodelingprep.com\/developer\/d' +
        'ocs","Category":"Finance"},{"API":"Finnhub","Description":"Real-' +
        'Time RESTful APIs and Websocket for Stocks, Currencies, and Cryp' +
        'to","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/finnhub.io\/docs\/api","Category":"Finance"},{"API":"FRED","' +
        'Description":"Economic data from the Federal Reserve Bank of St.' +
        ' Louis","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/fred.stlouisfed.org\/docs\/api\/fred\/","Category":"Finance"' +
        '},{"API":"Front Accounting APIs","Description":"Front accounting' +
        ' is multilingual and multicurrency software for small businesses' +
        '","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/fro' +
        'ntaccounting.com\/fawiki\/index.php?n=Devel.SimpleAPIModule","Ca' +
        'tegory":"Finance"},{"API":"Hotstoks","Description":"Stock market' +
        ' data powered by SQL","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/hotstoks.com?utm_source=public-apis","Category' +
        '":"Finance"},{"API":"IEX Cloud","Description":"Realtime & Histor' +
        'ical Stock and Market Data","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/iexcloud.io\/docs\/api\/","Category":"Fi' +
        'nance"},{"API":"IG","Description":"Spreadbetting and CFD Market ' +
        'Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/labs.ig.com\/gettingstarted","Category":"Finance"},{"API":' +
        '"Indian Mutual Fund","Description":"Get complete history of Indi' +
        'a Mutual Funds Data","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/www.mfapi.in\/","Category":"Finance"},{"API":"Int' +
        'rinio","Description":"A wide selection of financial data feeds",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'intrinio.com\/","Category":"Finance"},{"API":"Klarna","Descripti' +
        'on":"Klarna payment and shopping service","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/docs.klarna.com\/klarn' +
        'a-payments\/api\/payments-api\/","Category":"Finance"},{"API":"M' +
        'ercadoPago","Description":"Mercado Pago API reference - all the ' +
        'information you need to develop your integrations","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.mercadopa' +
        'go.com.br\/developers\/es\/reference","Category":"Finance"},{"AP' +
        'I":"Mono","Description":"Connect with users'#8217' bank accounts and a' +
        'ccess transaction data in Africa","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/mono.co\/","Category":"Finance' +
        '"},{"API":"Moov","Description":"The Moov API makes it simple for' +
        ' platforms to send, receive, and store money","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/docs.moov.io\/api\' +
        '/","Category":"Finance"},{"API":"Nordigen","Description":"Connec' +
        't to bank accounts using official bank APIs and get raw transact' +
        'ion data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/nordigen.com\/en\/account_information_documenation\/in' +
        'tegration\/quickstart_guide\/","Category":"Finance"},{"API":"Ope' +
        'nFIGI","Description":"Equity, index, futures, options symbology ' +
        'from Bloomberg LP","Auth":"apiKey","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/www.openfigi.com\/api","Category":"Finance"},{"AP' +
        'I":"Plaid","Description":"Connect with user'#39's bank accounts and ' +
        'access transaction data","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/plaid.com\/","Category":"Finance"},{"AP' +
        'I":"Polygon","Description":"Historical stock market data","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/polygo' +
        'n.io\/","Category":"Finance"},{"API":"Portfolio Optimizer","Desc' +
        'ription":"Portfolio analysis and optimization","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/portfoliooptimizer.io\/","C' +
        'ategory":"Finance"},{"API":"Razorpay IFSC","Description":"Indian' +
        ' Financial Systems Code (Bank Branch Codes)","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/razorpay.com\/docs\/","Ca' +
        'tegory":"Finance"},{"API":"Real Time Finance","Description":"Web' +
        'socket API to access realtime stock data","Auth":"apiKey","HTTPS' +
        '":false,"Cors":"unknown","Link":"https:\/\/github.com\/Real-time' +
        '-finance\/finance-websocket-API\/","Category":"Finance"},{"API":' +
        '"SEC EDGAR Data","Description":"API to access annual reports of ' +
        'public US companies","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.sec.gov\/edgar\/sec-api-documentation","Category"' +
        ':"Finance"},{"API":"SmartAPI","Description":"Gain access to set ' +
        'of <SmartAPI> and create end-to-end broking services","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/smartapi.a' +
        'ngelbroking.com\/","Category":"Finance"},{"API":"StockData","Des' +
        'cription":"Real-Time, Intraday & Historical Market Data, News an' +
        'd Sentiment API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/www.StockData.org","Category":"Finance"},{"API":"St' +
        'yvio","Description":"Realtime and historical stock data and curr' +
        'ent stock sentiment","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.Styvio.com","Category":"Finance"},{"API' +
        '":"Tax Data API","Description":"Instant VAT number and tax valid' +
        'ation across the globe","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'own","Link":"https:\/\/apilayer.com\/marketplace\/tax_data-api",' +
        '"Category":"Finance"},{"API":"Tradier","Description":"US equity\' +
        '/option market data (delayed, intraday, historical)","Auth":"OAu' +
        'th","HTTPS":true,"Cors":"yes","Link":"https:\/\/developer.tradie' +
        'r.com","Category":"Finance"},{"API":"Twelve Data","Description":' +
        '"Stock market data (real-time & historical)","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/twelvedata.com\/","' +
        'Category":"Finance"},{"API":"WallstreetBets","Description":"Wall' +
        'streetBets Stock Comments Sentiment Analysis","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/dashboard.nbshare.io\/ap' +
        'ps\/reddit\/api\/","Category":"Finance"},{"API":"Yahoo Finance",' +
        '"Description":"Real time low latency Yahoo Finance API for stock' +
        ' market, crypto currencies, and currency exchange","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.yahoofinancea' +
        'pi.com\/","Category":"Finance"},{"API":"YNAB","Description":"Bud' +
        'geting & Planning","Auth":"OAuth","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/api.youneedabudget.com\/","Category":"Finance"},{"' +
        'API":"Zoho Books","Description":"Online accounting software, bui' +
        'lt for your business","Auth":"OAuth","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.zoho.com\/books\/api\/v3\/","Category":' +
        '"Finance"},{"API":"BaconMockup","Description":"Resizable bacon p' +
        'laceholder images","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/baconmockup.com\/","Category":"Food & Drink"},{"API":"C' +
        'homp","Description":"Data about various grocery products and foo' +
        'ds","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/chompthis.com\/api\/","Category":"Food & Drink"},{"API":"Cof' +
        'fee","Description":"Random pictures of coffee","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/coffee.alexflipnote.dev' +
        '\/","Category":"Food & Drink"},{"API":"Edamam nutrition","Descri' +
        'ption":"Nutrition Analysis","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/developer.edamam.com\/edamam-docs-nu' +
        'trition-api","Category":"Food & Drink"},{"API":"Edamam recipes",' +
        '"Description":"Recipe Search","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/developer.edamam.com\/edamam-docs-' +
        'recipe-api","Category":"Food & Drink"},{"API":"Foodish","Descrip' +
        'tion":"Random pictures of food dishes","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/github.com\/surhud004\/Foodish#read' +
        'me","Category":"Food & Drink"},{"API":"Fruityvice","Description"' +
        ':"Data about all kinds of fruit","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/www.fruityvice.com","Category":"Food ' +
        '& Drink"},{"API":"Kroger","Description":"Supermarket Data","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/devel' +
        'oper.kroger.com\/reference","Category":"Food & Drink"},{"API":"L' +
        'CBO","Description":"Alcohol","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/lcboapi.com\/","Category":"Food & D' +
        'rink"},{"API":"Open Brewery DB","Description":"Breweries, Cideri' +
        'es and Craft Beer Bottle Shops","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/www.openbrewerydb.org","Category":"Food & ' +
        'Drink"},{"API":"Open Food Facts","Description":"Food Products Da' +
        'tabase","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/world.openfoodfacts.org\/data","Category":"Food & Drink"},{"AP' +
        'I":"PunkAPI","Description":"Brewdog Beer Recipes","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/punkapi.com\/","Cate' +
        'gory":"Food & Drink"},{"API":"Rustybeer","Description":"Beer bre' +
        'wing tools","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\' +
        '/rustybeer.herokuapp.com\/","Category":"Food & Drink"},{"API":"S' +
        'poonacular","Description":"Recipes, Food Products, and Meal Plan' +
        'ning","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/spoonacular.com\/food-api","Category":"Food & Drink"},{"AP' +
        'I":"Systembolaget","Description":"Govornment owned liqour store ' +
        'in Sweden","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/api-portal.systembolaget.se","Category":"Food & Drink' +
        '"},{"API":"TacoFancy","Description":"Community-driven taco datab' +
        'ase","Auth":"","HTTPS":false,"Cors":"unknown","Link":"https:\/\/' +
        'github.com\/evz\/tacofancy-api","Category":"Food & Drink"},{"API' +
        '":"Tasty","Description":"API to query data about recipe, plan, i' +
        'ngredients","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/rapidapi.com\/apidojo\/api\/tasty\/","Category":"Foo' +
        'd & Drink"},{"API":"The Report of the Week","Description":"Food ' +
        '& Drink Reviews","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/github.com\/andyklimczak\/TheReportOfTheWeek-API","Ca' +
        'tegory":"Food & Drink"},{"API":"TheCocktailDB","Description":"Co' +
        'cktail Recipes","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/www.thecocktaildb.com\/api.php","Category":"Food & D' +
        'rink"},{"API":"TheMealDB","Description":"Meal Recipes","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.themealdb' +
        '.com\/api.php","Category":"Food & Drink"},{"API":"Untappd","Desc' +
        'ription":"Social beer sharing","Auth":"OAuth","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/untappd.com\/api\/docs","Category"' +
        ':"Food & Drink"},{"API":"What'#39's on the menu?","Description":"NYP' +
        'L human-transcribed historical menu collection","Auth":"apiKey",' +
        '"HTTPS":false,"Cors":"unknown","Link":"http:\/\/nypl.github.io\/' +
        'menus-api\/","Category":"Food & Drink"},{"API":"WhiskyHunter","D' +
        'escription":"Past online whisky auctions statistical data","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/whiskyhunte' +
        'r.net\/api\/","Category":"Food & Drink"},{"API":"Zestful","Descr' +
        'iption":"Parse recipe ingredients","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/zestfuldata.com\/","Category":"Fo' +
        'od & Drink"},{"API":"Age of Empires II","Description":"Get infor' +
        'mation about Age of Empires II resources","Auth":"","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/age-of-empires-2-api.herokuapp.co' +
        'm","Category":"Games & Comics"},{"API":"AmiiboAPI","Description"' +
        ':"Nintendo Amiibo Information","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/amiiboapi.com\/","Category":"Games & Comics' +
        '"},{"API":"Animal Crossing: New Horizons","Description":"API for' +
        ' critters, fossils, art, music, furniture and villagers","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"http:\/\/acnhapi.com\/"' +
        ',"Category":"Games & Comics"},{"API":"Autochess VNG","Descriptio' +
        'n":"Rest Api for Autochess VNG","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/github.com\/didadadida93\/autochess-vng-ap' +
        'i","Category":"Games & Comics"},{"API":"Barter.VG","Description"' +
        ':"Provides information about Game, DLC, Bundles, Giveaways, Trad' +
        'ing","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/githu' +
        'b.com\/bartervg\/barter.vg\/wiki","Category":"Games & Comics"},{' +
        '"API":"Battle.net","Description":"Diablo III, Hearthstone, StarC' +
        'raft II and World of Warcraft game data APIs","Auth":"OAuth","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/develop.battle.net\/doc' +
        'umentation\/guides\/getting-started","Category":"Games & Comics"' +
        '},{"API":"Board Game Geek","Description":"Board games, RPG and v' +
        'ideogames","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'boardgamegeek.com\/wiki\/page\/BGG_XML_API2","Category":"Games &' +
        ' Comics"},{"API":"Brawl Stars","Description":"Brawl Stars Game I' +
        'nformation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/developer.brawlstars.com","Category":"Games & Comics' +
        '"},{"API":"Bugsnax","Description":"Get information about Bugsnax' +
        '","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.bugs' +
        'naxapi.com\/","Category":"Games & Comics"},{"API":"CheapShark","' +
        'Description":"Steam\/PC Game Prices and Deals","Auth":"","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/www.cheapshark.com\/api","C' +
        'ategory":"Games & Comics"},{"API":"Chess.com","Description":"Che' +
        'ss.com read-only REST API","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.chess.com\/news\/view\/published-data-a' +
        'pi","Category":"Games & Comics"},{"API":"Chuck Norris Database",' +
        '"Description":"Jokes","Auth":"","HTTPS":false,"Cors":"unknown","' +
        'Link":"http:\/\/www.icndb.com\/api\/","Category":"Games & Comics' +
        '"},{"API":"Clash of Clans","Description":"Clash of Clans Game In' +
        'formation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/developer.clashofclans.com","Category":"Games & Comic' +
        's"},{"API":"Clash Royale","Description":"Clash Royale Game Infor' +
        'mation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developer.clashroyale.com","Category":"Games & Comics"},' +
        '{"API":"Comic Vine","Description":"Comics","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/comicvine.gamespot.com\/api' +
        '\/documentation","Category":"Games & Comics"},{"API":"Crafatar",' +
        '"Description":"API for Minecraft skins and faces","Auth":"","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/crafatar.com","Category"' +
        ':"Games & Comics"},{"API":"Cross Universe","Description":"Cross ' +
        'Universe Card Data","Auth":"","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/crossuniverse.psychpsyo.com\/apiDocs.html","Category":' +
        '"Games & Comics"},{"API":"Deck of Cards","Description":"Deck of ' +
        'Cards","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\' +
        '/deckofcardsapi.com\/","Category":"Games & Comics"},{"API":"Dest' +
        'iny The Game","Description":"Bungie Platform API","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bungie-net.git' +
        'hub.io\/multi\/index.html","Category":"Games & Comics"},{"API":"' +
        'Digimon Information","Description":"Provides information about d' +
        'igimon creatures","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/digimon-api.vercel.app\/","Category":"Games & Comics' +
        '"},{"API":"Digimon TCG","Description":"Search for Digimon cards ' +
        'in digimoncard.io","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/documenter.getpostman.com\/view\/14059948\/TzecB4fH' +
        '","Category":"Games & Comics"},{"API":"Disney","Description":"In' +
        'formation of Disney characters","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/disneyapi.dev","Category":"Games & Comics"' +
        '},{"API":"Dota 2","Description":"Provides information about Play' +
        'er stats , Match stats, Rankings for Dota 2","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/docs.opendota.com\/' +
        '","Category":"Games & Comics"},{"API":"Dungeons and Dragons","De' +
        'scription":"Reference for 5th edition spells, classes, monsters,' +
        ' and more","Auth":"","HTTPS":false,"Cors":"no","Link":"https:\/\' +
        '/www.dnd5eapi.co\/docs\/","Category":"Games & Comics"},{"API":"D' +
        'ungeons and Dragons (Alternate)","Description":"Includes all mon' +
        'sters and spells from the SRD (System Reference Document) as wel' +
        'l as a search API","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/open5e.com\/","Category":"Games & Comics"},{"API":"Eve ' +
        'Online","Description":"Third-Party Developer Documentation","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/esi.e' +
        'vetech.net\/ui","Category":"Games & Comics"},{"API":"FFXIV Colle' +
        'ct","Description":"Final Fantasy XIV data on collectables","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ffxivcollect.co' +
        'm\/","Category":"Games & Comics"},{"API":"FIFA Ultimate Team","D' +
        'escription":"FIFA Ultimate Team items API","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/www.easports.com\/fifa\/ult' +
        'imate-team\/api\/fut\/item","Category":"Games & Comics"},{"API":' +
        '"Final Fantasy XIV","Description":"Final Fantasy XIV Game data A' +
        'PI","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/xivapi' +
        '.com\/","Category":"Games & Comics"},{"API":"Fortnite","Descript' +
        'ion":"Fortnite Stats","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/fortnitetracker.com\/site-api","Category":' +
        '"Games & Comics"},{"API":"Forza","Description":"Show random imag' +
        'e of car from Forza","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/docs.forza-api.tk","Category":"Games & Comics"},{' +
        '"API":"FreeToGame","Description":"Free-To-Play Games Database","' +
        'Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.freetog' +
        'ame.com\/api-doc","Category":"Games & Comics"},{"API":"Fun Facts' +
        '","Description":"Random Fun Facts","Auth":"","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/asli-fun-fact-api.herokuapp.com\/","Cat' +
        'egory":"Games & Comics"},{"API":"FunTranslations","Description":' +
        '"Translate Text into funny languages","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/api.funtranslations.com\/","Category' +
        '":"Games & Comics"},{"API":"GamerPower","Description":"Game Give' +
        'aways Tracker","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/www.gamerpower.com\/api-read","Category":"Games & Comics"},' +
        '{"API":"GDBrowser","Description":"Easy way to use the Geometry D' +
        'ash Servers","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/gdbrowser.com\/api","Category":"Games & Comics"},{"API":"' +
        'Geek-Jokes","Description":"Fetch a random geeky\/programming rel' +
        'ated joke for use in all sorts of applications","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/github.com\/sameerkumar18\' +
        '/geek-joke-api","Category":"Games & Comics"},{"API":"Genshin Imp' +
        'act","Description":"Genshin Impact game data","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/genshin.dev","Category":"Gam' +
        'es & Comics"},{"API":"Giant Bomb","Description":"Video Games","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ww' +
        'w.giantbomb.com\/api\/documentation","Category":"Games & Comics"' +
        '},{"API":"GraphQL Pokemon","Description":"GraphQL powered Pokemo' +
        'n API. Supports generations 1 through 8","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/github.com\/favware\/graphql-poke' +
        'mon","Category":"Games & Comics"},{"API":"Guild Wars 2","Descrip' +
        'tion":"Guild Wars 2 Game Information","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/wiki.guildwars2.com\/wiki\' +
        '/API:Main","Category":"Games & Comics"},{"API":"GW2Spidy","Descr' +
        'iption":"GW2Spidy API, Items data on the Guild Wars 2 Trade Mark' +
        'et","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gi' +
        'thub.com\/rubensayshi\/gw2spidy\/wiki","Category":"Games & Comic' +
        's"},{"API":"Halo","Description":"Halo 5 and Halo Wars 2 Informat' +
        'ion","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developer.haloapi.com\/","Category":"Games & Comics"},{"API' +
        '":"Hearthstone","Description":"Hearthstone Cards Information","A' +
        'uth":"X-Mashape-Key","HTTPS":true,"Cors":"unknown","Link":"http:' +
        '\/\/hearthstoneapi.com\/","Category":"Games & Comics"},{"API":"H' +
        'umble Bundle","Description":"Humble Bundle'#39's current bundles","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ra' +
        'pidapi.com\/Ziggoto\/api\/humble-bundle","Category":"Games & Com' +
        'ics"},{"API":"Humor","Description":"Humor, Jokes, and Memes","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/hum' +
        'orapi.com","Category":"Games & Comics"},{"API":"Hypixel","Descri' +
        'ption":"Hypixel player stats","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/api.hypixel.net\/","Category":"Gam' +
        'es & Comics"},{"API":"Hyrule Compendium","Description":"Data on ' +
        'all interactive items from The Legend of Zelda: BOTW","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/gadh' +
        'agod\/Hyrule-Compendium-API","Category":"Games & Comics"},{"API"' +
        ':"Hytale","Description":"Hytale blog posts and jobs","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/hytale-api.com\/"' +
        ',"Category":"Games & Comics"},{"API":"IGDB.com","Description":"V' +
        'ideo Game Database","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/api-docs.igdb.com","Category":"Games & Comic' +
        's"},{"API":"JokeAPI","Description":"Programming, Miscellaneous a' +
        'nd Dark Jokes","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/sv443.net\/jokeapi\/v2\/","Category":"Games & Comics"},{"AP' +
        'I":"Jokes One","Description":"Joke of the day and large category' +
        ' of jokes accessible via REST API","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/jokes.one\/api\/joke\/","Category' +
        '":"Games & Comics"},{"API":"Jservice","Description":"Jeopardy Qu' +
        'estion Database","Auth":"","HTTPS":false,"Cors":"unknown","Link"' +
        ':"http:\/\/jservice.io","Category":"Games & Comics"},{"API":"Lic' +
        'hess","Description":"Access to all data of users, games, puzzles' +
        ' and etc on Lichess","Auth":"OAuth","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/lichess.org\/api","Category":"Games & Comics' +
        '"},{"API":"Magic The Gathering","Description":"Magic The Gatheri' +
        'ng Game Information","Auth":"","HTTPS":false,"Cors":"unknown","L' +
        'ink":"http:\/\/magicthegathering.io\/","Category":"Games & Comic' +
        's"},{"API":"Mario Kart Tour","Description":"API for Drivers, Kar' +
        'ts, Gliders and Courses","Auth":"OAuth","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/mario-kart-tour-api.herokuapp.com\/","Ca' +
        'tegory":"Games & Comics"},{"API":"Marvel","Description":"Marvel ' +
        'Comics","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developer.marvel.com","Category":"Games & Comics"},{"API' +
        '":"Minecraft Server Status","Description":"API to get Informatio' +
        'n about a Minecraft Server","Auth":"","HTTPS":true,"Cors":"no","' +
        'Link":"https:\/\/api.mcsrvstat.us","Category":"Games & Comics"},' +
        '{"API":"MMO Games","Description":"MMO Games Database, News and G' +
        'iveaways","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/w' +
        'ww.mmobomb.com\/api","Category":"Games & Comics"},{"API":"mod.io' +
        '","Description":"Cross Platform Mod API","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/docs.mod.io","Category"' +
        ':"Games & Comics"},{"API":"Mojang","Description":"Mojang \/ Mine' +
        'craft API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/wiki.vg\/Mojang_API","Category":"Games & Comics"},{"A' +
        'PI":"Monster Hunter World","Description":"Monster Hunter World d' +
        'ata","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.' +
        'mhw-db.com\/","Category":"Games & Comics"},{"API":"Open Trivia",' +
        '"Description":"Trivia Questions","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/opentdb.com\/api_config.php","Categor' +
        'y":"Games & Comics"},{"API":"PandaScore","Description":"E-sports' +
        ' games and results","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developers.pandascore.co\/","Category":"Game' +
        's & Comics"},{"API":"Path of Exile","Description":"Path of Exile' +
        ' Game Information","Auth":"OAuth","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/www.pathofexile.com\/developer\/docs","Categor' +
        'y":"Games & Comics"},{"API":"PlayerDB","Description":"Query Mine' +
        'craft, Steam and XBox Accounts","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/playerdb.co\/","Category":"Games & Com' +
        'ics"},{"API":"Pok'#233'api","Description":"Pok'#233'mon Information","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pokeapi.co"' +
        ',"Category":"Games & Comics"},{"API":"Pok'#233'API (GraphQL)","Descri' +
        'ption":"The Unofficial GraphQL for PokeAPI","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/github.com\/mazipan\/graphql-p' +
        'okeapi","Category":"Games & Comics"},{"API":"Pok'#233'mon TCG","Descr' +
        'iption":"Pok'#233'mon TCG Information","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/pokemontcg.io","Category":"Games & C' +
        'omics"},{"API":"Psychonauts","Description":"Psychonauts World Ch' +
        'aracters Information and PSI Powers","Auth":"","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/psychonauts-api.netlify.app\/","Categ' +
        'ory":"Games & Comics"},{"API":"PUBG","Description":"Access in-ga' +
        'me PUBG data","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/developer.pubg.com\/","Category":"Games & Comics"},{"A' +
        'PI":"Puyo Nexus","Description":"Puyo Puyo information from Puyo ' +
        'Nexus Wiki","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/github.com\/deltadex7\/puyodb-api-deno","Category":"Games & Co' +
        'mics"},{"API":"quizapi.io","Description":"Access to various kind' +
        ' of quiz questions","Auth":"apiKey","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/quizapi.io\/","Category":"Games & Comics"},{"API' +
        '":"Raider","Description":"Provides detailed character and guild ' +
        'rankings for Raiding and Mythic+ content in World of Warcraft","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/raider.' +
        'io\/api","Category":"Games & Comics"},{"API":"RAWG.io","Descript' +
        'ion":"500,000+ games for 50 platforms including mobiles","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/rawg.io' +
        '\/apidocs","Category":"Games & Comics"},{"API":"Rick and Morty",' +
        '"Description":"All the Rick and Morty information, including ima' +
        'ges","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ricka' +
        'ndmortyapi.com","Category":"Games & Comics"},{"API":"Riot Games"' +
        ',"Description":"League of Legends Game Information","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.ri' +
        'otgames.com\/","Category":"Games & Comics"},{"API":"RPS 101","De' +
        'scription":"Rock, Paper, Scissors with 101 objects","Auth":"","H' +
        'TTPS":true,"Cors":"yes","Link":"https:\/\/rps101.pythonanywhere.' +
        'com\/api","Category":"Games & Comics"},{"API":"RuneScape","Descr' +
        'iption":"RuneScape and OSRS RPGs information","Auth":"","HTTPS":' +
        'true,"Cors":"no","Link":"https:\/\/runescape.wiki\/w\/Applicatio' +
        'n_programming_interface","Category":"Games & Comics"},{"API":"Sa' +
        'kura CardCaptor","Description":"Sakura CardCaptor Cards Informat' +
        'ion","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/g' +
        'ithub.com\/JessVel\/sakura-card-captor-api","Category":"Games & ' +
        'Comics"},{"API":"Scryfall","Description":"Magic: The Gathering d' +
        'atabase","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/s' +
        'cryfall.com\/docs\/api","Category":"Games & Comics"},{"API":"Spa' +
        'ceTradersAPI","Description":"A playable inter-galactic space tra' +
        'ding MMOAPI","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/spacetraders.io?rel=pub-apis","Category":"Games & Comics' +
        '"},{"API":"Steam","Description":"Steam Web API documentation","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/steamap' +
        'i.xpaw.me\/","Category":"Games & Comics"},{"API":"Steam","Descri' +
        'ption":"Internal Steam Web API documentation","Auth":"","HTTPS":' +
        'true,"Cors":"no","Link":"https:\/\/github.com\/Revadike\/Interna' +
        'lSteamWebAPI\/wiki","Category":"Games & Comics"},{"API":"SuperHe' +
        'roes","Description":"All SuperHeroes and Villains data from all ' +
        'universes under a single API","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/superheroapi.com","Category":"Game' +
        's & Comics"},{"API":"TCGdex","Description":"Multi languages Pok'#233 +
        'mon TCG Information","Auth":"","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.tcgdex.net\/docs","Category":"Games & Comics"},{"' +
        'API":"Tebex","Description":"Tebex API for information about game' +
        ' purchases","Auth":"X-Mashape-Key","HTTPS":true,"Cors":"no","Lin' +
        'k":"https:\/\/docs.tebex.io\/plugin\/","Category":"Games & Comic' +
        's"},{"API":"TETR.IO","Description":"TETR.IO Tetra Channel API","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/tetr.io' +
        '\/about\/api\/","Category":"Games & Comics"},{"API":"Tronald Dum' +
        'p","Description":"The dumbest things Donald Trump has ever said"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.t' +
        'ronalddump.io\/","Category":"Games & Comics"},{"API":"Universali' +
        's","Description":"Final Fantasy XIV market board data","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/universalis.app\/do' +
        'cs\/index.html","Category":"Games & Comics"},{"API":"Valorant (n' +
        'on-official)","Description":"An extensive API containing data of' +
        ' most Valorant in-game items, assets and more","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/valorant-api.com","Cate' +
        'gory":"Games & Comics"},{"API":"Warface (non-official)","Descrip' +
        'tion":"Official API proxy with better data structure and more fe' +
        'atures","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/api' +
        '.wfstats.cf","Category":"Games & Comics"},{"API":"Wargaming.net"' +
        ',"Description":"Wargaming.net info and stats","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"no","Link":"https:\/\/developers.wargaming.ne' +
        't\/","Category":"Games & Comics"},{"API":"When is next MCU film"' +
        ',"Description":"Upcoming MCU film information","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/github.com\/DiljotSG\/M' +
        'CU-Countdown\/blob\/develop\/docs\/API.md","Category":"Games & C' +
        'omics"},{"API":"xkcd","Description":"Retrieve xkcd comics as JSO' +
        'N","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/xkcd.com' +
        '\/json.html","Category":"Games & Comics"},{"API":"Yu-Gi-Oh!","De' +
        'scription":"Yu-Gi-Oh! TCG Information","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/db.ygoprodeck.com\/api-guide\/"' +
        ',"Category":"Games & Comics"},{"API":"Abstract IP Geolocation","' +
        'Description":"Geolocate website visitors from their IPs","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.abstrac' +
        'tapi.com\/ip-geolocation-api","Category":"Geocoding"},{"API":"Ac' +
        'tinia Grass GIS","Description":"Actinia is an open source REST A' +
        'PI for geographical data that uses GRASS GIS","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/actinia.mundialis.' +
        'de\/api_docs\/","Category":"Geocoding"},{"API":"administrative-d' +
        'ivisons-db","Description":"Get all administrative divisions of a' +
        ' country","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'github.com\/kamikazechaser\/administrative-divisions-db","Catego' +
        'ry":"Geocoding"},{"API":"adresse.data.gouv.fr","Description":"Ad' +
        'dress database of France, geocoding and reverse","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/adresse.data.gouv.fr"' +
        ',"Category":"Geocoding"},{"API":"Airtel IP","Description":"IP Ge' +
        'olocation API. Collecting data from multiple sources","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/sys.airtel.lv\/i' +
        'p2country\/1.1.1.1\/?full=true","Category":"Geocoding"},{"API":"' +
        'Apiip","Description":"Get location information by IP address","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/apiip.' +
        'net\/","Category":"Geocoding"},{"API":"apilayer ipstack","Descri' +
        'ption":"Locate and identify website visitors by IP address","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ipst' +
        'ack.com\/","Category":"Geocoding"},{"API":"Battuta","Description' +
        '":"A (country\/region\/city) in-cascade location API","Auth":"ap' +
        'iKey","HTTPS":false,"Cors":"unknown","Link":"http:\/\/battuta.me' +
        'dunes.net","Category":"Geocoding"},{"API":"BigDataCloud","Descri' +
        'ption":"Provides fast and accurate IP geolocation APIs along wit' +
        'h security checks and confidence area","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.bigdatacloud.com\/ip-' +
        'geolocation-apis","Category":"Geocoding"},{"API":"Bing Maps","De' +
        'scription":"Create\/customize digital maps based on Bing Maps da' +
        'ta","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/www.microsoft.com\/maps\/","Category":"Geocoding"},{"API":"b' +
        'ng2latlong","Description":"Convert British OSGB36 easting and no' +
        'rthing (British National Grid) to WGS84 latitude and longitude",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.getthe' +
        'data.com\/bng2latlong","Category":"Geocoding"},{"API":"Cartes.io' +
        '","Description":"Create maps and markers for anything","Auth":""' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/M-M' +
        'edia-Group\/Cartes.io\/wiki\/API","Category":"Geocoding"},{"API"' +
        ':"Cep.la","Description":"Brazil RESTful API to find information ' +
        'about streets, zip codes, neighborhoods, cities and states","Aut' +
        'h":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/cep.la\/",' +
        '"Category":"Geocoding"},{"API":"CitySDK","Description":"Open API' +
        's for select European cities","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"http:\/\/www.citysdk.eu\/citysdk-toolkit\/","Categ' +
        'ory":"Geocoding"},{"API":"Country","Description":"Get your visit' +
        'or'#39's country from their IP","Auth":"","HTTPS":true,"Cors":"yes",' +
        '"Link":"http:\/\/country.is\/","Category":"Geocoding"},{"API":"C' +
        'ountryStateCity","Description":"World countries, states, regions' +
        ', provinces, cities & towns in JSON, SQL, XML, YAML, & CSV forma' +
        't","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/c' +
        'ountrystatecity.in\/","Category":"Geocoding"},{"API":"Ducks Unli' +
        'mited","Description":"API explorer that gives a query URL with a' +
        ' JSON response of locations and cities","Auth":"","HTTPS":true,"' +
        'Cors":"no","Link":"https:\/\/gis.ducks.org\/datasets\/du-univers' +
        'ity-chapters\/api","Category":"Geocoding"},{"API":"FreeGeoIP","D' +
        'escription":"Free geo ip information, no registration required. ' +
        '15k\/hour rate limit","Auth":"","HTTPS":true,"Cors":"yes","Link"' +
        ':"https:\/\/freegeoip.app\/","Category":"Geocoding"},{"API":"Geo' +
        'Api","Description":"French geographical data","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/api.gouv.fr\/api\/geoapi' +
        '.html","Category":"Geocoding"},{"API":"Geoapify","Description":"' +
        'Forward and reverse geocoding, address autocomplete","Auth":"api' +
        'Key","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.geoapify.co' +
        'm\/api\/geocoding-api\/","Category":"Geocoding"},{"API":"Geocod.' +
        'io","Description":"Address geocoding \/ reverse geocoding in bul' +
        'k","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/www.geocod.io\/","Category":"Geocoding"},{"API":"Geocode.xyz"' +
        ',"Description":"Provides worldwide forward\/reverse geocoding, b' +
        'atch geocoding and geoparsing","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/geocode.xyz\/api","Category":"Geocoding' +
        '"},{"API":"Geocodify.com","Description":"Worldwide geocoding, ge' +
        'oparsing and autocomplete for addresses","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/geocodify.com\/","Category"' +
        ':"Geocoding"},{"API":"Geodata.gov.gr","Description":"Open geospa' +
        'tial data and API service for Greece","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/geodata.gov.gr\/en\/","Category"' +
        ':"Geocoding"},{"API":"GeoDataSource","Description":"Geocoding of' +
        ' city name by using latitude and longitude coordinates","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.geod' +
        'atasource.com\/web-service","Category":"Geocoding"},{"API":"GeoD' +
        'B Cities","Description":"Get global city, region, and country da' +
        'ta","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http:\' +
        '/\/geodb-cities-api.wirefreethought.com\/","Category":"Geocoding' +
        '"},{"API":"GeographQL","Description":"A Country, State, and City' +
        ' GraphQL API","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/geographql.netlify.app","Category":"Geocoding"},{"API":"GeoJ' +
        'S","Description":"IP geolocation with ChatOps integration","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.geojs.io\/"' +
        ',"Category":"Geocoding"},{"API":"Geokeo","Description":"Geokeo g' +
        'eocoding service- with 2500 free api requests daily","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/geokeo.com","Category' +
        '":"Geocoding"},{"API":"GeoNames","Description":"Place names and ' +
        'other geographical data","Auth":"","HTTPS":false,"Cors":"unknown' +
        '","Link":"http:\/\/www.geonames.org\/export\/web-services.html",' +
        '"Category":"Geocoding"},{"API":"geoPlugin","Description":"IP geo' +
        'location and currency conversion","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/www.geoplugin.com","Category":"Geocoding' +
        '"},{"API":"Google Earth Engine","Description":"A cloud-based pla' +
        'tform for planetary-scale environmental data analysis","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer' +
        's.google.com\/earth-engine\/","Category":"Geocoding"},{"API":"Go' +
        'ogle Maps","Description":"Create\/customize digital maps based o' +
        'n Google Maps data","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developers.google.com\/maps\/","Category":"G' +
        'eocoding"},{"API":"Graph Countries","Description":"Country-relat' +
        'ed data like currencies, languages, flags, regions+subregions an' +
        'd bordering countries","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/github.com\/lennertVanSever\/graphcountries","C' +
        'ategory":"Geocoding"},{"API":"HelloSalut","Description":"Get hel' +
        'lo translation following user language","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/fourtonfish.com\/project\/hell' +
        'osalut-api\/","Category":"Geocoding"},{"API":"HERE Maps","Descri' +
        'ption":"Create\/customize digital maps based on HERE Maps data",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'developer.here.com","Category":"Geocoding"},{"API":"Hirak IP to ' +
        'Country","Description":"Ip to location with country code, curren' +
        'cy code & currency name, fast response, unlimited requests","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/iplo' +
        'cation.hirak.site\/","Category":"Geocoding"},{"API":"Hong Kong G' +
        'eoData Store","Description":"API for accessing geo-data of Hong ' +
        'Kong","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'geodata.gov.hk\/gs\/","Category":"Geocoding"},{"API":"IBGE","Des' +
        'cription":"Aggregate services of IBGE (Brazilian Institute of Ge' +
        'ography and Statistics)","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/servicodados.ibge.gov.br\/api\/docs\/","Categ' +
        'ory":"Geocoding"},{"API":"IP 2 Country","Description":"Map an IP' +
        ' to a country","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/ip2country.info","Category":"Geocoding"},{"API":"IP Add' +
        'ress Details","Description":"Find geolocation with ip address","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ipinfo.' +
        'io\/","Category":"Geocoding"},{"API":"IP Vigilante","Description' +
        '":"Free IP Geolocation API","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.ipvigilante.com\/","Category":"Geocodi' +
        'ng"},{"API":"ip-api","Description":"Find location with IP addres' +
        's or domain","Auth":"","HTTPS":false,"Cors":"unknown","Link":"ht' +
        'tps:\/\/ip-api.com\/docs","Category":"Geocoding"},{"API":"IP2Loc' +
        'ation","Description":"IP geolocation web service to get more tha' +
        'n 55 parameters","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.ip2location.com\/web-service\/ip2location",' +
        '"Category":"Geocoding"},{"API":"IP2Proxy","Description":"Detect ' +
        'proxy and VPN using IP address","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.ip2location.com\/web-service' +
        '\/ip2proxy","Category":"Geocoding"},{"API":"ipapi.co","Descripti' +
        'on":"Find IP address location information","Auth":"","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/ipapi.co\/api\/#introduction","' +
        'Category":"Geocoding"},{"API":"ipapi.com","Description":"Real-ti' +
        'me Geolocation & Reverse IP Lookup REST API","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/ipapi.com\/","Categ' +
        'ory":"Geocoding"},{"API":"IPGEO","Description":"Unlimited free I' +
        'P Address API with useful information","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/api.techniknews.net\/ipgeo\/","' +
        'Category":"Geocoding"},{"API":"ipgeolocation","Description":"IP ' +
        'Geolocation AP with free plan 30k requests per month","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/ipgeolocation.' +
        'io\/","Category":"Geocoding"},{"API":"IPInfoDB","Description":"F' +
        'ree Geolocation tools and APIs for country, region, city and tim' +
        'e zone lookup by IP address","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/www.ipinfodb.com\/api","Category":"' +
        'Geocoding"},{"API":"ipstack","Description":"Locate and identify ' +
        'website visitors by IP address","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/ipstack.com\/","Category":"Geoco' +
        'ding"},{"API":"Kakao Maps","Description":"Kakao Maps provide mul' +
        'tiple APIs for Korean maps","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/apis.map.kakao.com","Category":"Geoc' +
        'oding"},{"API":"keycdn IP Location Finder","Description":"Get th' +
        'e IP geolocation data through the simple REST API. All the respo' +
        'nses are JSON encoded","Auth":"apiKey","HTTPS":true,"Cors":"unkn' +
        'own","Link":"https:\/\/tools.keycdn.com\/geo","Category":"Geocod' +
        'ing"},{"API":"LocationIQ","Description":"Provides forward\/rever' +
        'se geocoding and batch geocoding","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/locationiq.org\/docs\/","Category"' +
        ':"Geocoding"},{"API":"Longdo Map","Description":"Interactive map' +
        ' with detailed places and information portal in Thailand","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/map.longdo' +
        '.com\/docs\/","Category":"Geocoding"},{"API":"Mapbox","Descripti' +
        'on":"Create\/customize beautiful digital maps","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.mapbox.com\/' +
        '","Category":"Geocoding"},{"API":"MapQuest","Description":"To ac' +
        'cess tools and resources to map the world","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"no","Link":"https:\/\/developer.mapquest.com\/",' +
        '"Category":"Geocoding"},{"API":"Mexico","Description":"Mexico RE' +
        'STful zip codes API","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/github.com\/IcaliaLabs\/sepomex","Category":"Geoc' +
        'oding"},{"API":"Nominatim","Description":"Provides worldwide for' +
        'ward \/ reverse geocoding","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/nominatim.org\/release-docs\/latest\/api\/Overv' +
        'iew\/","Category":"Geocoding"},{"API":"One Map, Singapore","Desc' +
        'ription":"Singapore Land Authority REST API services for Singapo' +
        're addresses","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.onemap.gov.sg\/docs\/","Category":"Geocoding"}' +
        ',{"API":"OnWater","Description":"Determine if a lat\/lon is on w' +
        'ater or land","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/onwater.io\/","Category":"Geocoding"},{"API":"Open Topo ' +
        'Data","Description":"Elevation and ocean depth for a latitude an' +
        'd longitude","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/' +
        '\/www.opentopodata.org","Category":"Geocoding"},{"API":"OpenCage' +
        '","Description":"Forward and reverse geocoding using open data",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/open' +
        'cagedata.com","Category":"Geocoding"},{"API":"openrouteservice.o' +
        'rg","Description":"Directions, POIs, isochrones, geocoding (+rev' +
        'erse), elevation, and more","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/openrouteservice.org\/","Category":"' +
        'Geocoding"},{"API":"OpenStreetMap","Description":"Navigation, ge' +
        'olocation and geographical data","Auth":"OAuth","HTTPS":false,"C' +
        'ors":"unknown","Link":"http:\/\/wiki.openstreetmap.org\/wiki\/AP' +
        'I","Category":"Geocoding"},{"API":"Pinball Map","Description":"A' +
        ' crowdsourced map of public pinball machines","Auth":"","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/pinballmap.com\/api\/v1\/doc' +
        's","Category":"Geocoding"},{"API":"positionstack","Description":' +
        '"Forward & Reverse Batch Geocoding REST API","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/positionstack.com\/' +
        '","Category":"Geocoding"},{"API":"Postali","Description":"Mexico' +
        ' Zip Codes API","Auth":"","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/postali.app\/api","Category":"Geocoding"},{"API":"Postcode' +
        'Data.nl","Description":"Provide geolocation data based on postco' +
        'de for Dutch addresses","Auth":"","HTTPS":false,"Cors":"unknown"' +
        ',"Link":"http:\/\/api.postcodedata.nl\/v1\/postcode\/?postcode=1' +
        '211EP&streetnumber=60&ref=domeinnaam.nl&type=json","Category":"G' +
        'eocoding"},{"API":"Postcodes.io","Description":"Postcode lookup ' +
        '& Geolocation for the UK","Auth":"","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/postcodes.io","Category":"Geocoding"},{"API":"Qu' +
        'eimadas INPE","Description":"Access to heat focus data (probable' +
        ' wildfire)","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/queimadas.dgi.inpe.br\/queimadas\/dados-abertos\/","Catego' +
        'ry":"Geocoding"},{"API":"REST Countries","Description":"Get info' +
        'rmation about countries via a RESTful API","Auth":"","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/restcountries.com","Category":"' +
        'Geocoding"},{"API":"RoadGoat Cities","Description":"Cities conte' +
        'nt & photos API","Auth":"apiKey","HTTPS":true,"Cors":"no","Link"' +
        ':"https:\/\/www.roadgoat.com\/business\/cities-api","Category":"' +
        'Geocoding"},{"API":"Rwanda Locations","Description":"Rwanda Prov' +
        'ences, Districts, Cities, Capital City, Sector, cells, villages ' +
        'and streets","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/rapidapi.com\/victorkarangwa4\/api\/rwanda","Category":"G' +
        'eocoding"},{"API":"SLF","Description":"German city, country, riv' +
        'er, database","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/github.com\/slftool\/slftool.github.io\/blob\/master\/API.md' +
        '","Category":"Geocoding"},{"API":"SpotSense","Description":"Add ' +
        'location based interactions to your mobile app","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/spotsense.io\/",' +
        '"Category":"Geocoding"},{"API":"Telize","Description":"Telize of' +
        'fers location information from any IP address","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/rapidapi.com\/fcambus' +
        '\/api\/telize\/","Category":"Geocoding"},{"API":"TomTom","Descri' +
        'ption":"Maps, Directions, Places and Traffic APIs","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"yes","Link":"https:\/\/developer.tomtom.' +
        'com\/","Category":"Geocoding"},{"API":"Uebermaps","Description":' +
        '"Discover and share maps with friends","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/uebermaps.com\/api\/v2","' +
        'Category":"Geocoding"},{"API":"US ZipCode","Description":"Valida' +
        'te and append data for any US ZipCode","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/www.smarty.com\/docs\/cloud\/' +
        'us-zipcode-api","Category":"Geocoding"},{"API":"Utah AGRC","Desc' +
        'ription":"Utah Web API for geocoding Utah addresses","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.mapserv' +
        '.utah.gov","Category":"Geocoding"},{"API":"ViaCep","Description"' +
        ':"Brazil RESTful zip codes API","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/viacep.com.br","Category":"Geocoding"}' +
        ',{"API":"What3Words","Description":"Three words as rememberable ' +
        'and unique coordinates worldwide","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/what3words.com","Category":"Ge' +
        'ocoding"},{"API":"Yandex.Maps Geocoder","Description":"Use geoco' +
        'ding to get an object'#39's coordinates from its address","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/yandex.com' +
        '\/dev\/maps\/geocoder","Category":"Geocoding"},{"API":"ZipCodeAP' +
        'I","Description":"US zip code distance, radius and location API"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/www.zipcodeapi.com","Category":"Geocoding"},{"API":"Zippopotam.' +
        'us","Description":"Get information about place such as country, ' +
        'city, state, etc","Auth":"","HTTPS":false,"Cors":"unknown","Link' +
        '":"http:\/\/www.zippopotam.us","Category":"Geocoding"},{"API":"Z' +
        'iptastic","Description":"Get the country, state, and city of any' +
        ' US zip-code","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/ziptasticapi.com\/","Category":"Geocoding"},{"API":"Bank' +
        ' Negara Malaysia Open Data","Description":"Malaysia Central Bank' +
        ' Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/apikijangportal.bnm.gov.my\/","Category":"Government"},{"A' +
        'PI":"BCLaws","Description":"Access to the laws of British Columb' +
        'ia","Auth":"","HTTPS":false,"Cors":"unknown","Link":"https:\/\/w' +
        'ww.bclaws.gov.bc.ca\/civix\/template\/complete\/api\/index.html"' +
        ',"Category":"Government"},{"API":"Brazil","Description":"Communi' +
        'ty driven API for Brazil Public Data","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/brasilapi.com.br\/","Category":"Gove' +
        'rnment"},{"API":"Brazil Central Bank Open Data","Description":"B' +
        'razil Central Bank Open Data","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/dadosabertos.bcb.gov.br\/","Category":"G' +
        'overnment"},{"API":"Brazil Receita WS","Description":"Consult co' +
        'mpanies by CNPJ for Brazilian companies","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.receitaws.com.br\/","Cate' +
        'gory":"Government"},{"API":"Brazilian Chamber of Deputies Open D' +
        'ata","Description":"Provides legislative information in Apis XML' +
        ' and JSON, as well as files in various formats","Auth":"","HTTPS' +
        '":true,"Cors":"no","Link":"https:\/\/dadosabertos.camara.leg.br\' +
        '/swagger\/api.html","Category":"Government"},{"API":"Census.gov"' +
        ',"Description":"The US Census Bureau provides various APIs and d' +
        'ata sets on demographics and businesses","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/www.census.gov\/data\/develop' +
        'ers\/data-sets.html","Category":"Government"},{"API":"City, Berl' +
        'in","Description":"Berlin(DE) City Open Data","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/daten.berlin.de\/","Cate' +
        'gory":"Government"},{"API":"City, Gda'#324'sk","Description":"Gda'#324'sk ' +
        '(PL) City Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/ckan.multimediagdansk.pl\/en","Category":"Governm' +
        'ent"},{"API":"City, Gdynia","Description":"Gdynia (PL) City Open' +
        ' Data","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\' +
        '/otwartedane.gdynia.pl\/en\/api_doc.html","Category":"Government' +
        '"},{"API":"City, Helsinki","Description":"Helsinki(FI) City Open' +
        ' Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/hri.fi\/en_gb\/","Category":"Government"},{"API":"City, Lviv","' +
        'Description":"Lviv(UA) City Open Data","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/opendata.city-adm.lviv.ua\/","C' +
        'ategory":"Government"},{"API":"City, Nantes Open Data","Descript' +
        'ion":"Nantes(FR) City Open Data","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/data.nantesmetropole.fr\/pages\' +
        '/home\/","Category":"Government"},{"API":"City, New York Open Da' +
        'ta","Description":"New York (US) City Open Data","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/opendata.cityofnewyor' +
        'k.us\/","Category":"Government"},{"API":"City, Prague Open Data"' +
        ',"Description":"Prague(CZ) City Open Data","Auth":"","HTTPS":fal' +
        'se,"Cors":"unknown","Link":"http:\/\/opendata.praha.eu\/en","Cat' +
        'egory":"Government"},{"API":"City, Toronto Open Data","Descripti' +
        'on":"Toronto (CA) City Open Data","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/open.toronto.ca\/","Category":"Governmen' +
        't"},{"API":"Code.gov","Description":"The primary platform for Op' +
        'en Source and code sharing for the U.S. Federal Government","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/code' +
        '.gov","Category":"Government"},{"API":"Colorado Information Mark' +
        'etplace","Description":"Colorado State Government Open Data","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.colo' +
        'rado.gov\/","Category":"Government"},{"API":"Data USA","Descript' +
        'ion":"US Public Data","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/datausa.io\/about\/api\/","Category":"Government' +
        '"},{"API":"Data.gov","Description":"US Government Data","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.data' +
        '.gov\/","Category":"Government"},{"API":"Data.parliament.uk","De' +
        'scription":"Contains live datasets including information about p' +
        'etitions, bills, MP votes, attendance and more","Auth":"","HTTPS' +
        '":false,"Cors":"unknown","Link":"https:\/\/explore.data.parliame' +
        'nt.uk\/?learnmore=Members","Category":"Government"},{"API":"Deut' +
        'scher Bundestag DIP","Description":"This API provides read acces' +
        's to DIP entities (e.g. activities, persons, printed material)",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'dip.bundestag.de\/documents\/informationsblatt_zur_dip_api_v01.p' +
        'df","Category":"Government"},{"API":"District of Columbia Open D' +
        'ata","Description":"Contains D.C. government public datasets, in' +
        'cluding crime, GIS, financial data, and so on","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"http:\/\/opendata.dc.gov\/pages\/' +
        'using-apis","Category":"Government"},{"API":"EPA","Description":' +
        '"Web services and data sets from the US Environmental Protection' +
        ' Agency","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/www.epa.gov\/developers\/data-data-products#apis","Category":' +
        '"Government"},{"API":"FBI Wanted","Description":"Access informat' +
        'ion on the FBI Wanted program","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/www.fbi.gov\/wanted\/api","Category":"G' +
        'overnment"},{"API":"FEC","Description":"Information on campaign ' +
        'donations in federal elections","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/api.open.fec.gov\/developers\/",' +
        '"Category":"Government"},{"API":"Federal Register","Description"' +
        ':"The Daily Journal of the United States Government","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.federalregist' +
        'er.gov\/reader-aids\/developer-resources\/rest-api","Category":"' +
        'Government"},{"API":"Food Standards Agency","Description":"UK fo' +
        'od hygiene rating data API","Auth":"","HTTPS":false,"Cors":"unkn' +
        'own","Link":"http:\/\/ratings.food.gov.uk\/open-data\/en-GB","Ca' +
        'tegory":"Government"},{"API":"Gazette Data, UK","Description":"U' +
        'K official public record API","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/www.thegazette.co.uk\/data","Catego' +
        'ry":"Government"},{"API":"Gun Policy","Description":"Internation' +
        'al firearm injury prevention and policy","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.gunpolicy.org\/api"' +
        ',"Category":"Government"},{"API":"INEI","Description":"Peruvian ' +
        'Statistical Government Open Data","Auth":"","HTTPS":false,"Cors"' +
        ':"unknown","Link":"http:\/\/iinei.inei.gob.pe\/microdatos\/","Ca' +
        'tegory":"Government"},{"API":"Interpol Red Notices","Description' +
        '":"Access and search Interpol Red Notices","Auth":"","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/interpol.api.bund.dev\/","C' +
        'ategory":"Government"},{"API":"Istanbul ('#304'BB) Open Data","Descri' +
        'ption":"Data sets from the '#304'stanbul Metropolitan Municipality ('#304 +
        'BB)","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/d' +
        'ata.ibb.gov.tr","Category":"Government"},{"API":"National Park S' +
        'ervice, US","Description":"Data from the US National Park Servic' +
        'e","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/w' +
        'ww.nps.gov\/subjects\/developer\/","Category":"Government"},{"AP' +
        'I":"Open Government, ACT","Description":"Australian Capital Terr' +
        'itory Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.data.act.gov.au\/","Category":"Government"},{"API' +
        '":"Open Government, Argentina","Description":"Argentina Governme' +
        'nt Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/datos.gob.ar\/","Category":"Government"},{"API":"Open Go' +
        'vernment, Australia","Description":"Australian Government Open D' +
        'ata","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/w' +
        'ww.data.gov.au\/","Category":"Government"},{"API":"Open Governme' +
        'nt, Austria","Description":"Austria Government Open Data","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.data.gv.' +
        'at\/","Category":"Government"},{"API":"Open Government, Belgium"' +
        ',"Description":"Belgium Government Open Data","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/data.gov.be\/","Category' +
        '":"Government"},{"API":"Open Government, Canada","Description":"' +
        'Canadian Government Open Data","Auth":"","HTTPS":false,"Cors":"u' +
        'nknown","Link":"http:\/\/open.canada.ca\/en","Category":"Governm' +
        'ent"},{"API":"Open Government, Colombia","Description":"Colombia' +
        ' Government Open Data","Auth":"","HTTPS":false,"Cors":"unknown",' +
        '"Link":"https:\/\/www.dane.gov.co\/","Category":"Government"},{"' +
        'API":"Open Government, Cyprus","Description":"Cyprus Government ' +
        'Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/data.gov.cy\/?language=en","Category":"Government"},{"API":' +
        '"Open Government, Czech Republic","Description":"Czech Republic ' +
        'Government Open Data","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/data.gov.cz\/english\/","Category":"Government"}' +
        ',{"API":"Open Government, Denmark","Description":"Denmark Govern' +
        'ment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/www.opendata.dk\/","Category":"Government"},{"API":"Op' +
        'en Government, Estonia","Description":"Estonia Government Open D' +
        'ata","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/avaandmed.eesti.ee\/instructions\/opendata-dataset-api","Ca' +
        'tegory":"Government"},{"API":"Open Government, Finland","Descrip' +
        'tion":"Finland Government Open Data","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/www.avoindata.fi\/en","Category":' +
        '"Government"},{"API":"Open Government, France","Description":"Fr' +
        'ench Government Open Data","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/www.data.gouv.fr\/","Category":"Gover' +
        'nment"},{"API":"Open Government, Germany","Description":"Germany' +
        ' Government Open Data","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.govdata.de\/daten\/-\/details\/govdata-meta' +
        'datenkatalog","Category":"Government"},{"API":"Open Government, ' +
        'Greece","Description":"Greece Government Open Data","Auth":"OAut' +
        'h","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.gov.gr\/' +
        '","Category":"Government"},{"API":"Open Government, India","Desc' +
        'ription":"Indian Government Open Data","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/data.gov.in\/","Category"' +
        ':"Government"},{"API":"Open Government, Ireland","Description":"' +
        'Ireland Government Open Data","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/data.gov.ie\/pages\/developers","Categor' +
        'y":"Government"},{"API":"Open Government, Italy","Description":"' +
        'Italy Government Open Data","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.dati.gov.it\/","Category":"Government"' +
        '},{"API":"Open Government, Korea","Description":"Korea Governmen' +
        't Open Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/www.data.go.kr\/","Category":"Government"},{"API":"' +
        'Open Government, Lithuania","Description":"Lithuania Government ' +
        'Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/data.gov.lt\/public\/api\/1","Category":"Government"},{"API' +
        '":"Open Government, Luxembourg","Description":"Luxembourgish Gov' +
        'ernment Open Data","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/data.public.lu","Category":"Government"},{"AP' +
        'I":"Open Government, Mexico","Description":"Mexican Statistical ' +
        'Government Open Data","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/www.inegi.org.mx\/datos\/","Category":"Governmen' +
        't"},{"API":"Open Government, Mexico","Description":"Mexico Gover' +
        'nment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/datos.gob.mx\/","Category":"Government"},{"API":"Open' +
        ' Government, Netherlands","Description":"Netherlands Government ' +
        'Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/data.overheid.nl\/en\/ondersteuning\/data-publiceren\/api",' +
        '"Category":"Government"},{"API":"Open Government, New South Wale' +
        's","Description":"New South Wales Government Open Data","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.nsw.' +
        'gov.au\/","Category":"Government"},{"API":"Open Government, New ' +
        'Zealand","Description":"New Zealand Government Open Data","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.data.gov' +
        't.nz\/","Category":"Government"},{"API":"Open Government, Norway' +
        '","Description":"Norwegian Government Open Data","Auth":"","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/data.norge.no\/dataservic' +
        'es","Category":"Government"},{"API":"Open Government, Peru","Des' +
        'cription":"Peru Government Open Data","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.datosabiertos.gob.pe\/","Cat' +
        'egory":"Government"},{"API":"Open Government, Poland","Descripti' +
        'on":"Poland Government Open Data","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/dane.gov.pl\/en","Category":"Government"' +
        '},{"API":"Open Government, Portugal","Description":"Portugal Gov' +
        'ernment Open Data","Auth":"","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/dados.gov.pt\/en\/docapi\/","Category":"Government"},{"' +
        'API":"Open Government, Queensland Government","Description":"Que' +
        'ensland Government Open Data","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/www.data.qld.gov.au\/","Category":"Gover' +
        'nment"},{"API":"Open Government, Romania","Description":"Romania' +
        ' Government Open Data","Auth":"","HTTPS":false,"Cors":"unknown",' +
        '"Link":"http:\/\/data.gov.ro\/","Category":"Government"},{"API":' +
        '"Open Government, Saudi Arabia","Description":"Saudi Arabia Gove' +
        'rnment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/data.gov.sa","Category":"Government"},{"API":"Open G' +
        'overnment, Singapore","Description":"Singapore Government Open D' +
        'ata","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/d' +
        'ata.gov.sg\/developer","Category":"Government"},{"API":"Open Gov' +
        'ernment, Slovakia","Description":"Slovakia Government Open Data"' +
        ',"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.' +
        'gov.sk\/en\/","Category":"Government"},{"API":"Open Government, ' +
        'Slovenia","Description":"Slovenia Government Open Data","Auth":"' +
        '","HTTPS":true,"Cors":"no","Link":"https:\/\/podatki.gov.si\/","' +
        'Category":"Government"},{"API":"Open Government, South Australia' +
        'n Government","Description":"South Australian Government Open Da' +
        'ta","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/da' +
        'ta.sa.gov.au\/","Category":"Government"},{"API":"Open Government' +
        ', Spain","Description":"Spain Government Open Data","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/datos.gob.es\/en",' +
        '"Category":"Government"},{"API":"Open Government, Sweden","Descr' +
        'iption":"Sweden Government Open Data","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.dataportal.se\/en\/dataservi' +
        'ce\/91_29789\/api-for-the-statistical-database","Category":"Gove' +
        'rnment"},{"API":"Open Government, Switzerland","Description":"Sw' +
        'itzerland Government Open Data","Auth":"","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/handbook.opendata.swiss\/de\/content\/' +
        'nutzen\/api-nutzen.html","Category":"Government"},{"API":"Open G' +
        'overnment, Taiwan","Description":"Taiwan Government Open Data","' +
        'Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.go' +
        'v.tw\/","Category":"Government"},{"API":"Open Government, Thaila' +
        'nd","Description":"Thailand Government Open Data","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.go.th\/",' +
        '"Category":"Government"},{"API":"Open Government, UK","Descripti' +
        'on":"UK Government Open Data","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/data.gov.uk\/","Category":"Government"},' +
        '{"API":"Open Government, USA","Description":"United States Gover' +
        'nment Open Data","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.data.gov\/","Category":"Government"},{"API":"Open' +
        ' Government, Victoria State Government","Description":"Victoria ' +
        'State Government Open Data","Auth":"","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.data.vic.gov.au\/","Category":"Governm' +
        'ent"},{"API":"Open Government, West Australia","Description":"We' +
        'st Australia Open Data","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/data.wa.gov.au\/","Category":"Government"},{"A' +
        'PI":"PRC Exam Schedule","Description":"Unofficial Philippine Pro' +
        'fessional Regulation Commission'#39's examination schedule","Auth":"' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.whenisthenextb' +
        'oardexam.com\/docs\/","Category":"Government"},{"API":"Represent' +
        ' by Open North","Description":"Find Canadian Government Represen' +
        'tatives","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/represent.opennorth.ca\/","Category":"Government"},{"API":"UK' +
        ' Companies House","Description":"UK Companies House Data from th' +
        'e UK government","Auth":"OAuth","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/developer.company-information.service.gov.uk\/",' +
        '"Category":"Government"},{"API":"US Presidential Election Data b' +
        'y TogaTech","Description":"Basic candidate data and live elector' +
        'al vote counts for top two parties in US presidential election",' +
        '"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/uselection.' +
        'togatech.org\/api\/","Category":"Government"},{"API":"USA.gov","' +
        'Description":"Authoritative information on U.S. programs, events' +
        ', services and more","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.usa.gov\/developer","Category":"Governm' +
        'ent"},{"API":"USAspending.gov","Description":"US federal spendin' +
        'g data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/api.usaspending.gov\/","Category":"Government"},{"API":"CMS.go' +
        'v","Description":"Access to the data from the CMS - medicare.gov' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/data.cms.gov\/provider-data\/","Category":"Health"},{"API":"Co' +
        'ronavirus","Description":"HTTP API for Latest Covid-19 Data","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pipedream' +
        '.com\/@pravin\/http-api-for-latest-wuhan-coronavirus-data-2019-n' +
        'cov-p_G6CLVM\/readme","Category":"Health"},{"API":"Coronavirus i' +
        'n the UK","Description":"UK Government coronavirus data, includi' +
        'ng deaths and cases by region","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/coronavirus.data.gov.uk\/details\/devel' +
        'opers-guide","Category":"Health"},{"API":"Covid Tracking Project' +
        '","Description":"Covid-19  data for the US","Auth":"","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/covidtracking.com\/data\/api\/v' +
        'ersion-2","Category":"Health"},{"API":"Covid-19","Description":"' +
        'Covid 19 spread, infection and recovery","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/covid19api.com\/","Category":"Hea' +
        'lth"},{"API":"Covid-19","Description":"Covid 19 cases, deaths an' +
        'd recovery per country","Auth":"","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/github.com\/M-Media-Group\/Covid-19-API","Category' +
        '":"Health"},{"API":"Covid-19 Datenhub","Description":"Maps, data' +
        'sets, applications and more in the context of COVID-19","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/npgeo-corona-n' +
        'pgeo-de.hub.arcgis.com","Category":"Health"},{"API":"Covid-19 Go' +
        'vernment Response","Description":"Government measures tracker to' +
        ' fight against the Covid-19 pandemic","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/covidtracker.bsg.ox.ac.uk","Category' +
        '":"Health"},{"API":"Covid-19 India","Description":"Covid 19 stat' +
        'istics state and district wise about cases, vaccinations, recove' +
        'ry within India","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/data.covid19india.org\/","Category":"Health"},{"API":' +
        '"Covid-19 JHU CSSE","Description":"Open-source API for exploring' +
        ' Covid19 cases based on JHU CSSE","Auth":"","HTTPS":true,"Cors":' +
        '"yes","Link":"https:\/\/nuttaphat.com\/covid19-api\/","Category"' +
        ':"Health"},{"API":"Covid-19 Live Data","Description":"Global and' +
        ' countrywise data of Covid 19 daily Summary, confirmed cases, re' +
        'covered and deaths","Auth":"","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/github.com\/mathdroid\/covid-19-api","Category":"Healt' +
        'h"},{"API":"Covid-19 Philippines","Description":"Unofficial Covi' +
        'd-19 Web API for Philippines from data collected by DOH","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/Simpe' +
        'rfy\/Covid-19-API-Philippines-DOH","Category":"Health"},{"API":"' +
        'COVID-19 Tracker Canada","Description":"Details on Covid-19 case' +
        's across Canada","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/api.covid19tracker.ca\/docs\/1.0\/overview","Category' +
        '":"Health"},{"API":"COVID-19 Tracker Sri Lanka","Description":"P' +
        'rovides situation of the COVID-19 patients reported in Sri Lanka' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.' +
        'hpb.health.gov.lk\/en\/api-documentation","Category":"Health"},{' +
        '"API":"COVID-ID","Description":"Indonesian government Covid data' +
        ' per province","Auth":"","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/data.covid19.go.id\/public\/api\/prov.json","Category":"Hea' +
        'lth"},{"API":"Dataflow Kit COVID-19","Description":"COVID-19 liv' +
        'e statistics into sites per hour","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/covid-19.dataflowkit.com","Category"' +
        ':"Health"},{"API":"FoodData Central","Description":"National Nut' +
        'rient Database for Standard Reference","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/fdc.nal.usda.gov\/","Cate' +
        'gory":"Health"},{"API":"Healthcare.gov","Description":"Education' +
        'al content about the US Health Insurance Marketplace","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.healthcare.g' +
        'ov\/developers\/","Category":"Health"},{"API":"Humanitarian Data' +
        ' Exchange","Description":"Humanitarian Data Exchange (HDX) is op' +
        'en platform for sharing data across crises and organisations","A' +
        'uth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/data.hum' +
        'data.org\/","Category":"Health"},{"API":"Infermedica","Descripti' +
        'on":"NLP based symptom checker and patient triage API for health' +
        ' diagnosis from text","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/developer.infermedica.com\/docs\/","Category":' +
        '"Health"},{"API":"LAPIS","Description":"SARS-CoV-2 genomic seque' +
        'nces from public sources","Auth":"","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/cov-spectrum.ethz.ch\/public","Category":"Health' +
        '"},{"API":"Lexigram","Description":"NLP that extracts mentions o' +
        'f clinical concepts from text, gives access to clinical ontology' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/docs.lexigram.io\/","Category":"Health"},{"API":"Makeup","Desc' +
        'ription":"Makeup Information","Auth":"","HTTPS":false,"Cors":"un' +
        'known","Link":"http:\/\/makeup-api.herokuapp.com\/","Category":"' +
        'Health"},{"API":"MyVaccination","Description":"Vaccination data ' +
        'for Malaysia","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/documenter.getpostman.com\/view\/16605343\/Tzm8GG7u","Ca' +
        'tegory":"Health"},{"API":"NPPES","Description":"National Plan & ' +
        'Provider Enumeration System, info on healthcare providers regist' +
        'ered in US","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/npiregistry.cms.hhs.gov\/registry\/help-api","Category":"H' +
        'ealth"},{"API":"Nutritionix","Description":"Worlds largest verif' +
        'ied nutrition database","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/developer.nutritionix.com\/","Category":' +
        '"Health"},{"API":"Open Data NHS Scotland","Description":"Medical' +
        ' reference data and statistics by Public Health Scotland","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.opendata' +
        '.nhs.scot","Category":"Health"},{"API":"Open Disease","Descripti' +
        'on":"API for Current cases and more stuff about COVID-19 and Inf' +
        'luenza","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/di' +
        'sease.sh\/","Category":"Health"},{"API":"openFDA","Description":' +
        '"Public FDA data about drugs, devices and foods","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/open.fda.gov","' +
        'Category":"Health"},{"API":"Orion Health","Description":"Medical' +
        ' platform which allows the development of applications for diffe' +
        'rent healthcare scenarios","Auth":"OAuth","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/developer.orionhealth.io\/","Category"' +
        ':"Health"},{"API":"Quarantine","Description":"Coronavirus API wi' +
        'th free COVID-19 live updates","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/quarantine.country\/coronavirus\/api\/","Ca' +
        'tegory":"Health"},{"API":"Adzuna","Description":"Job board aggre' +
        'gator","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/developer.adzuna.com\/overview","Category":"Jobs"},{"API"' +
        ':"Arbeitnow","Description":"API for Job board aggregator in Euro' +
        'pe \/ Remote","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/documenter.getpostman.com\/view\/18545278\/UVJbJdKh","Catego' +
        'ry":"Jobs"},{"API":"Arbeitsamt","Description":"API for the \"Arb' +
        'eitsamt\", which is a german Job board aggregator","Auth":"OAuth' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/jobsuche.api.b' +
        'und.dev\/","Category":"Jobs"},{"API":"Careerjet","Description":"' +
        'Job search engine","Auth":"apiKey","HTTPS":false,"Cors":"unknown' +
        '","Link":"https:\/\/www.careerjet.com\/partners\/api\/","Categor' +
        'y":"Jobs"},{"API":"DevITjobs UK","Description":"Jobs with GraphQ' +
        'L","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/devitjo' +
        'bs.uk\/job_feed.xml","Category":"Jobs"},{"API":"Findwork","Descr' +
        'iption":"Job board","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/findwork.dev\/developers\/","Category":"Jobs' +
        '"},{"API":"GraphQL Jobs","Description":"Jobs with GraphQL","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/graphql.jobs\/d' +
        'ocs\/api\/","Category":"Jobs"},{"API":"Jobs2Careers","Descriptio' +
        'n":"Job aggregator","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"http:\/\/api.jobs2careers.com\/api\/spec.pdf","Categor' +
        'y":"Jobs"},{"API":"Jooble","Description":"Job search engine","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/joo' +
        'ble.org\/api\/about","Category":"Jobs"},{"API":"Juju","Descripti' +
        'on":"Job search engine","Auth":"apiKey","HTTPS":false,"Cors":"un' +
        'known","Link":"http:\/\/www.juju.com\/publisher\/spec\/","Catego' +
        'ry":"Jobs"},{"API":"Open Skills","Description":"Job titles, skil' +
        'ls and related jobs data","Auth":"","HTTPS":false,"Cors":"unknow' +
        'n","Link":"https:\/\/github.com\/workforce-data-initiative\/skil' +
        'ls-api\/wiki\/API-Overview","Category":"Jobs"},{"API":"Reed","De' +
        'scription":"Job board aggregator","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.reed.co.uk\/developers","C' +
        'ategory":"Jobs"},{"API":"The Muse","Description":"Job board and ' +
        'company profiles","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/www.themuse.com\/developers\/api\/v2","Categor' +
        'y":"Jobs"},{"API":"Upwork","Description":"Freelance job board an' +
        'd management system","Auth":"OAuth","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/developers.upwork.com\/","Category":"Jobs"},' +
        '{"API":"USAJOBS","Description":"US government job board","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/develop' +
        'er.usajobs.gov\/","Category":"Jobs"},{"API":"WhatJobs","Descript' +
        'ion":"Job search engine","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/www.whatjobs.com\/affiliates","Category' +
        '":"Jobs"},{"API":"ZipRecruiter","Description":"Job search app an' +
        'd website","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.ziprecruiter.com\/publishers","Category":"Jobs"},' +
        '{"API":"AI For Thai","Description":"Free Various Thai AI API","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/aifort' +
        'hai.in.th\/index.php","Category":"Machine Learning"},{"API":"Cla' +
        'rifai","Description":"Computer Vision","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/docs.clarifai.com\/api-gui' +
        'de\/api-overview","Category":"Machine Learning"},{"API":"Cloudme' +
        'rsive","Description":"Image captioning, face recognition, NSFW c' +
        'lassification","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.cloudmersive.com\/image-recognition-and-processin' +
        'g-api","Category":"Machine Learning"},{"API":"Deepcode","Descrip' +
        'tion":"AI for code review","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.deepcode.ai","Category":"Machine Learni' +
        'ng"},{"API":"Dialogflow","Description":"Natural Language Process' +
        'ing","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/cloud.google.com\/dialogflow\/docs\/","Category":"Machine L' +
        'earning"},{"API":"EXUDE-API","Description":"Used for the primary' +
        ' ways for filtering the stopping, stemming words from the text d' +
        'ata","Auth":"","HTTPS":true,"Cors":"yes","Link":"http:\/\/uttesh' +
        '.com\/exude-api\/","Category":"Machine Learning"},{"API":"Hirak ' +
        'FaceAPI","Description":"Face detection, face recognition with ag' +
        'e estimation\/gender estimation, accurate, no quota limits","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/face' +
        'api.hirak.site\/","Category":"Machine Learning"},{"API":"Imagga"' +
        ',"Description":"Image Recognition Solutions like Tagging, Visual' +
        ' Search, NSFW moderation","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/imagga.com\/","Category":"Machine Lear' +
        'ning"},{"API":"Inferdo","Description":"Computer Vision services ' +
        'like Facial detection, Image labeling, NSFW classification","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/rapi' +
        'dapi.com\/user\/inferdo","Category":"Machine Learning"},{"API":"' +
        'IPS Online","Description":"Face and License Plate Anonymization"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/docs.identity.ps\/docs","Category":"Machine Learning"},{"API":"' +
        'Irisnet","Description":"Realtime content moderation API that blo' +
        'cks or blurs unwanted images in real-time","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/irisnet.de\/api\/","Categ' +
        'ory":"Machine Learning"},{"API":"Keen IO","Description":"Data An' +
        'alytics","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/keen.io\/","Category":"Machine Learning"},{"API":"Machi' +
        'netutors","Description":"AI Solutions: Video\/Image Classificati' +
        'on & Tagging, NSFW, Icon\/Image\/Audio Search, NLP","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.machinetutor' +
        's.com\/portfolio\/MT_api.html","Category":"Machine Learning"},{"' +
        'API":"MessengerX.io","Description":"A FREE API for developers to' +
        ' build and monetize personalized ML based chat apps","Auth":"api' +
        'Key","HTTPS":true,"Cors":"yes","Link":"https:\/\/messengerx.rtfd' +
        '.io","Category":"Machine Learning"},{"API":"NLP Cloud","Descript' +
        'ion":"NLP API using spaCy and transformers for NER, sentiments, ' +
        'classification, summarization, and more","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/nlpcloud.io","Category"' +
        ':"Machine Learning"},{"API":"OpenVisionAPI","Description":"Open ' +
        'source computer vision API based on open source models","Auth":"' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/openvisionapi.com"' +
        ',"Category":"Machine Learning"},{"API":"Perspective","Descriptio' +
        'n":"NLP API to return probability that if text is toxic, obscene' +
        ', insulting or threatening","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/perspectiveapi.com","Category":"Mach' +
        'ine Learning"},{"API":"Roboflow Universe","Description":"Pre-tra' +
        'ined computer vision models","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/universe.roboflow.com","Category":"Mach' +
        'ine Learning"},{"API":"SkyBiometry","Description":"Face Detectio' +
        'n, Face Recognition and Face Grouping","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/skybiometry.com\/document' +
        'ation\/","Category":"Machine Learning"},{"API":"Time Door","Desc' +
        'ription":"A time series analysis API","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/timedoor.io","Category":"Machi' +
        'ne Learning"},{"API":"Unplugg","Description":"Forecasting API fo' +
        'r timeseries data","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/unplu.gg\/test_api.html","Category":"Machine ' +
        'Learning"},{"API":"WolframAlpha","Description":"Provides specifi' +
        'c answers to questions using data and algorithms","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/products.wolfr' +
        'amalpha.com\/api\/","Category":"Machine Learning"},{"API":"7digi' +
        'tal","Description":"Api of Music store 7digital","Auth":"OAuth",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.7digital.co' +
        'm\/reference","Category":"Music"},{"API":"AI Mastering","Descrip' +
        'tion":"Automated Music Mastering","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/aimastering.com\/api_docs\/","Cate' +
        'gory":"Music"},{"API":"Audiomack","Description":"Api of the stre' +
        'aming music hub Audiomack","Auth":"OAuth","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/www.audiomack.com\/data-api\/docs","Ca' +
        'tegory":"Music"},{"API":"Bandcamp","Description":"API of Music s' +
        'tore Bandcamp","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/bandcamp.com\/developer","Category":"Music"},{"API' +
        '":"Bandsintown","Description":"Music Events","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/app.swaggerhub.com\/apis\' +
        '/Bandsintown\/PublicAPI\/3.0.0","Category":"Music"},{"API":"Deez' +
        'er","Description":"Music","Auth":"OAuth","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/developers.deezer.com\/api","Category":' +
        '"Music"},{"API":"Discogs","Description":"Music","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.discogs.com\/' +
        'developers\/","Category":"Music"},{"API":"Freesound","Descriptio' +
        'n":"Music Samples","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/freesound.org\/docs\/api\/","Category":"Music' +
        '"},{"API":"Gaana","Description":"API to retrieve song informatio' +
        'n from Gaana","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/github.com\/cyberboysumanjay\/GaanaAPI","Category":"Musi' +
        'c"},{"API":"Genius","Description":"Crowdsourced lyrics and music' +
        ' knowledge","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/docs.genius.com\/","Category":"Music"},{"API":"Genren' +
        'ator","Description":"Music genre generator","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/binaryjazz.us\/genrenator-' +
        'api\/","Category":"Music"},{"API":"iTunes Search","Description":' +
        '"Software products","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/affiliate.itunes.apple.com\/resources\/documentati' +
        'on\/itunes-store-web-service-search-api\/","Category":"Music"},{' +
        '"API":"Jamendo","Description":"Music","Auth":"OAuth","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/developer.jamendo.com\/v3.0' +
        '\/docs","Category":"Music"},{"API":"JioSaavn","Description":"API' +
        ' to retrieve song information, album meta data and many more fro' +
        'm JioSaavn","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/github.com\/cyberboysumanjay\/JioSaavnAPI","Category":"Mus' +
        'ic"},{"API":"KKBOX","Description":"Get music libraries, playlist' +
        's, charts, and perform out of KKBOX'#39's platform","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.kkbox.c' +
        'om","Category":"Music"},{"API":"KSoft.Si Lyrics","Description":"' +
        'API to get lyrics for songs","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/docs.ksoft.si\/api\/lyrics-api","Ca' +
        'tegory":"Music"},{"API":"LastFm","Description":"Music","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.last.' +
        'fm\/api","Category":"Music"},{"API":"Lyrics.ovh","Description":"' +
        'Simple API to retrieve the lyrics of a song","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/lyricsovh.docs.apiary.io"' +
        ',"Category":"Music"},{"API":"Mixcloud","Description":"Music","Au' +
        'th":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.mixc' +
        'loud.com\/developers\/","Category":"Music"},{"API":"MusicBrainz"' +
        ',"Description":"Music","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/musicbrainz.org\/doc\/Development\/XML_Web_Serv' +
        'ice\/Version_2","Category":"Music"},{"API":"Musixmatch","Descrip' +
        'tion":"Music","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/developer.musixmatch.com\/","Category":"Music"},{"' +
        'API":"Napster","Description":"Music","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/developer.napster.com\/api\/v2.' +
        '2","Category":"Music"},{"API":"Openwhyd","Description":"Download' +
        ' curated playlists of streaming tracks (YouTube, SoundCloud, etc' +
        '...)","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/openw' +
        'hyd.github.io\/openwhyd\/API","Category":"Music"},{"API":"Phishi' +
        'n","Description":"A web-based archive of legal live audio record' +
        'ings of the improvisational rock band Phish","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"no","Link":"https:\/\/phish.in\/api-docs","Cat' +
        'egory":"Music"},{"API":"Radio Browser","Description":"List of in' +
        'ternet radio stations","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/api.radio-browser.info\/","Category":"Music"},{"API' +
        '":"Songkick","Description":"Music Events","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/www.songkick.com\/deve' +
        'loper\/","Category":"Music"},{"API":"Songlink \/ Odesli","Descri' +
        'ption":"Get all the services on which a song is available","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.notio' +
        'n.so\/API-d0ebe08a5e304a55928405eb682f6741","Category":"Music"},' +
        '{"API":"Songsterr","Description":"Provides guitar, bass and drum' +
        's tabs and chords","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/www.songsterr.com\/a\/wa\/api\/","Category":"Music"' +
        '},{"API":"SoundCloud","Description":"With SoundCloud API you can' +
        ' build applications that will give more power to control your co' +
        'ntent","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/developers.soundcloud.com\/docs\/api\/guide","Category":"M' +
        'usic"},{"API":"Spotify","Description":"View Spotify music catalo' +
        'g, manage users'#39' libraries, get recommendations and more","Auth"' +
        ':"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/beta.de' +
        'veloper.spotify.com\/documentation\/web-api\/","Category":"Music' +
        '"},{"API":"TasteDive","Description":"Similar artist API (also wo' +
        'rks for movies and TV shows)","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/tastedive.com\/read\/api","Categor' +
        'y":"Music"},{"API":"TheAudioDB","Description":"Music","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.theaud' +
        'iodb.com\/api_guide.php","Category":"Music"},{"API":"Vagalume","' +
        'Description":"Crowdsourced lyrics and music knowledge","Auth":"a' +
        'piKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.vagal' +
        'ume.com.br\/docs\/","Category":"Music"},{"API":"apilayer mediast' +
        'ack","Description":"Free, Simple REST API for Live News & Blog A' +
        'rticles","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/mediastack.com\/","Category":"News"},{"API":"Associated' +
        ' Press","Description":"Search for news and metadata from Associa' +
        'ted Press","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/developer.ap.org\/","Category":"News"},{"API":"Chroni' +
        'cling America","Description":"Provides access to millions of pag' +
        'es of historic US newspapers from the Library of Congress","Auth' +
        '":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/chronicling' +
        'america.loc.gov\/about\/api\/","Category":"News"},{"API":"Curren' +
        'ts","Description":"Latest news published in various news sources' +
        ', blogs and forums","Auth":"apiKey","HTTPS":true,"Cors":"yes","L' +
        'ink":"https:\/\/currentsapi.services\/","Category":"News"},{"API' +
        '":"Feedbin","Description":"RSS reader","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/github.com\/feedbin\/feedb' +
        'in-api","Category":"News"},{"API":"GNews","Description":"Search ' +
        'for news from various sources","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/gnews.io\/","Category":"News"},{"API"' +
        ':"Graphs for Coronavirus","Description":"Each Country separately' +
        ' and Worldwide Graphs for Coronavirus. Daily updates","Auth":"",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/corona.dnsforfamily.' +
        'com\/api.txt","Category":"News"},{"API":"Inshorts News","Descrip' +
        'tion":"Provides news from inshorts","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/github.com\/cyberboysumanjay\/Insh' +
        'orts-News-API","Category":"News"},{"API":"MarketAux","Descriptio' +
        'n":"Live stock market news with tagged tickers + sentiment and s' +
        'tats JSON API","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":' +
        '"https:\/\/www.marketaux.com\/","Category":"News"},{"API":"New Y' +
        'ork Times","Description":"The New York Times Developer Network",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'developer.nytimes.com\/","Category":"News"},{"API":"News","Descr' +
        'iption":"Headlines currently published on a range of news source' +
        's and blogs","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/newsapi.org\/","Category":"News"},{"API":"NewsData"' +
        ',"Description":"News data API for live-breaking news and headlin' +
        'es from reputed  news sources","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/newsdata.io\/docs","Category":"Ne' +
        'ws"},{"API":"NewsX","Description":"Get or Search Latest Breaking' +
        ' News with ML Powered Summaries '#55358#56598'","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/rapidapi.com\/machaao-inc-ma' +
        'chaao-inc-default\/api\/newsx\/","Category":"News"},{"API":"NPR ' +
        'One","Description":"Personalized news listening experience from ' +
        'NPR","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"http:\' +
        '/\/dev.npr.org\/api\/","Category":"News"},{"API":"Spaceflight Ne' +
        'ws","Description":"Spaceflight related news '#55357#56960'","Auth":"","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/spaceflightnewsapi.net","C' +
        'ategory":"News"},{"API":"The Guardian","Description":"Access all' +
        ' the content the Guardian creates, categorised by tags and secti' +
        'on","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http:\' +
        '/\/open-platform.theguardian.com\/","Category":"News"},{"API":"T' +
        'he Old Reader","Description":"RSS reader","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/github.com\/theoldread' +
        'er\/api","Category":"News"},{"API":"TheNews","Description":"Aggr' +
        'egated headlines, top story and live news JSON API","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.thenewsapi.c' +
        'om\/","Category":"News"},{"API":"Trove","Description":"Search th' +
        'rough the National Library of Australia collection of 1000s of d' +
        'igitised newspapers","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/trove.nla.gov.au\/about\/create-something\/' +
        'using-api","Category":"News"},{"API":"18F","Description":"Unoffi' +
        'cial US Federal Government API Development","Auth":"","HTTPS":fa' +
        'lse,"Cors":"unknown","Link":"http:\/\/18f.github.io\/API-All-the' +
        '-X\/","Category":"Open Data"},{"API":"API Setu","Description":"A' +
        'n Indian Government platform that provides a lot of APIS for KYC' +
        ', business, education & employment","Auth":"","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.apisetu.gov.in\/","Category":"Open' +
        ' Data"},{"API":"Archive.org","Description":"The Internet Archive' +
        '","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/archive.r' +
        'eadme.io\/docs","Category":"Open Data"},{"API":"Black History Fa' +
        'cts","Description":"Contribute or search one of the largest blac' +
        'k history fact databases on the web","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/www.blackhistoryapi.io\/docs","' +
        'Category":"Open Data"},{"API":"BotsArchive","Description":"JSON ' +
        'formatted details about Telegram Bots available in database","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/botsarchi' +
        've.com\/docs.html","Category":"Open Data"},{"API":"Callook.info"' +
        ',"Description":"United States ham radio callsigns","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/callook.info","Cate' +
        'gory":"Open Data"},{"API":"CARTO","Description":"Location Inform' +
        'ation Prediction","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/carto.com\/","Category":"Open Data"},{"API":"C' +
        'ollegeScoreCard.ed.gov","Description":"Data on higher education ' +
        'institutions in the United States","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/collegescorecard.ed.gov\/data\/","C' +
        'ategory":"Open Data"},{"API":"Enigma Public","Description":"Broa' +
        'dest collection of public data","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/developers.enigma.com\/docs","Catego' +
        'ry":"Open Data"},{"API":"French Address Search","Description":"A' +
        'ddress search via the French Government","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/geo.api.gouv.fr\/adresse","Ca' +
        'tegory":"Open Data"},{"API":"GENESIS","Description":"Federal Sta' +
        'tistical Office Germany","Auth":"OAuth","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/www.destatis.de\/EN\/Service\/OpenData\/' +
        'api-webservice.html","Category":"Open Data"},{"API":"Joshua Proj' +
        'ect","Description":"People groups of the world with the fewest f' +
        'ollowers of Christ","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/api.joshuaproject.net\/","Category":"Open Da' +
        'ta"},{"API":"Kaggle","Description":"Create and interact with Dat' +
        'asets, Notebooks, and connect with Kaggle","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/www.kaggle.com\/docs\' +
        '/api","Category":"Open Data"},{"API":"LinkPreview","Description"' +
        ':"Get JSON formatted summary with title, description and preview' +
        ' image for any requested URL","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"yes","Link":"https:\/\/www.linkpreview.net","Category":"Open ' +
        'Data"},{"API":"Lowy Asia Power Index","Description":"Get measure' +
        ' resources and influence to rank the relative power of states in' +
        ' Asia","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/github.com\/0x0is1\/lowy-index-api-docs","Category":"Open Data"' +
        '},{"API":"Microlink.io","Description":"Extract structured data f' +
        'rom any website","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/microlink.io","Category":"Open Data"},{"API":"Nasdaq Data' +
        ' Link","Description":"Stock market data","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/docs.data.nasdaq.com\/"' +
        ',"Category":"Open Data"},{"API":"Nobel Prize","Description":"Ope' +
        'n data about nobel prizes and events","Auth":"","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/www.nobelprize.org\/about\/developer' +
        '-zone-2\/","Category":"Open Data"},{"API":"Open Data Minneapolis' +
        '","Description":"Spatial (GIS) and non-spatial city data for Min' +
        'neapolis","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/o' +
        'pendata.minneapolismn.gov\/","Category":"Open Data"},{"API":"ope' +
        'nAFRICA","Description":"Large datasets repository of African ope' +
        'n data","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/africaopendata.org\/","Category":"Open Data"},{"API":"OpenCorp' +
        'orates","Description":"Data on corporate entities and directors ' +
        'in many countries","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"http:\/\/api.opencorporates.com\/documentation\/API-Ref' +
        'erence","Category":"Open Data"},{"API":"OpenSanctions","Descript' +
        'ion":"Data on international sanctions, crime and politically exp' +
        'osed persons","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/www.opensanctions.org\/docs\/api\/","Category":"Open Data"},' +
        '{"API":"PeakMetrics","Description":"News articles and public dat' +
        'asets","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/rapidapi.com\/peakmetrics-peakmetrics-default\/api\/peakm' +
        'etrics-news","Category":"Open Data"},{"API":"Recreation Informat' +
        'ion Database","Description":"Recreational areas, federal lands, ' +
        'historic sites, museums, and other attractions\/resources(US)","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/r' +
        'idb.recreation.gov\/","Category":"Open Data"},{"API":"Scoop.it",' +
        '"Description":"Content Curation Service","Auth":"apiKey","HTTPS"' +
        ':false,"Cors":"unknown","Link":"http:\/\/www.scoop.it\/dev","Cat' +
        'egory":"Open Data"},{"API":"Socrata","Description":"Access to Op' +
        'en Data from Governments, Non-profits and NGOs around the world"' +
        ',"Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/dev.' +
        'socrata.com\/","Category":"Open Data"},{"API":"Teleport","Descri' +
        'ption":"Quality of Life Data","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/developers.teleport.org\/","Category":"O' +
        'pen Data"},{"API":"Ume'#229' Open Data","Description":"Open data of t' +
        'he city Ume'#229' in northen Sweden","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/opendata.umea.se\/api\/","Category":"Open ' +
        'Data"},{"API":"Universities List","Description":"University name' +
        's, countries and domains","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/github.com\/Hipo\/university-domains-list","' +
        'Category":"Open Data"},{"API":"University of Oslo","Description"' +
        ':"Courses, lecture videos, detailed information for courses etc.' +
        ' for the University of Oslo (Norway)","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/data.uio.no\/","Category":"Open ' +
        'Data"},{"API":"UPC database","Description":"More than 1.5 millio' +
        'n barcode numbers from all around the world","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/upcdatabase.org\/ap' +
        'i","Category":"Open Data"},{"API":"Urban Observatory","Descripti' +
        'on":"The largest set of publicly available real time urban data ' +
        'in the UK","Auth":"","HTTPS":false,"Cors":"no","Link":"https:\/\' +
        '/urbanobservatory.ac.uk","Category":"Open Data"},{"API":"Wikidat' +
        'a","Description":"Collaboratively edited knowledge base operated' +
        ' by the Wikimedia Foundation","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/www.wikidata.org\/w\/api.php?action' +
        '=help","Category":"Open Data"},{"API":"Wikipedia","Description":' +
        '"Mediawiki Encyclopedia","Auth":"","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/www.mediawiki.org\/wiki\/API:Main_page","Cate' +
        'gory":"Open Data"},{"API":"Yelp","Description":"Find Local Busin' +
        'ess","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/www.yelp.com\/developers\/documentation\/v3","Category":"Ope' +
        'n Data"},{"API":"Countly","Description":"Countly web analytics",' +
        '"Auth":"","HTTPS":false,"Cors":"unknown","Link":"https:\/\/api.c' +
        'ount.ly\/reference","Category":"Open Source Projects"},{"API":"C' +
        'reative Commons Catalog","Description":"Search among openly lice' +
        'nsed and public domain works","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/api.creativecommons.engineering\/","Cat' +
        'egory":"Open Source Projects"},{"API":"Datamuse","Description":"' +
        'Word-finding query engine","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/www.datamuse.com\/api\/","Category":"Open S' +
        'ource Projects"},{"API":"Drupal.org","Description":"Drupal.org",' +
        '"Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.dr' +
        'upal.org\/drupalorg\/docs\/api","Category":"Open Source Projects' +
        '"},{"API":"Evil Insult Generator","Description":"Evil Insults","' +
        'Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/evilinsult.' +
        'com\/api","Category":"Open Source Projects"},{"API":"GitHub Cont' +
        'ribution Chart Generator","Description":"Create an image of your' +
        ' GitHub contributions","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/github-contributions.vercel.app","Category":"Open S' +
        'ource Projects"},{"API":"GitHub ReadMe Stats","Description":"Add' +
        ' dynamically generated statistics to your GitHub profile ReadMe"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.co' +
        'm\/anuraghazra\/github-readme-stats","Category":"Open Source Pro' +
        'jects"},{"API":"Metabase","Description":"An open source Business' +
        ' Intelligence server to share data and analytics inside your com' +
        'pany","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.' +
        'metabase.com\/","Category":"Open Source Projects"},{"API":"Shiel' +
        'ds","Description":"Concise, consistent, and legible badges in SV' +
        'G and raster format","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/shields.io\/","Category":"Open Source Projects"},' +
        '{"API":"EPO","Description":"European patent search system api","' +
        'Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/de' +
        'velopers.epo.org\/","Category":"Patent"},{"API":"PatentsView ","' +
        'Description":"API is intended to explore and visualize trends\/p' +
        'atterns across the US innovation landscape","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/patentsview.org\/apis\/pur' +
        'pose","Category":"Patent"},{"API":"TIPO","Description":"Taiwan p' +
        'atent search system api","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/tiponet.tipo.gov.tw\/Gazette\/OpenData\' +
        '/OD\/OD05.aspx?QryDS=API00","Category":"Patent"},{"API":"USPTO",' +
        '"Description":"USA patent api services","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/www.uspto.gov\/learning-and-re' +
        'sources\/open-data-and-mobility","Category":"Patent"},{"API":"Ad' +
        'vice Slip","Description":"Generate random advice slips","Auth":"' +
        '","HTTPS":true,"Cors":"unknown","Link":"http:\/\/api.adviceslip.' +
        'com\/","Category":"Personality"},{"API":"Biriyani As A Service",' +
        '"Description":"Biriyani images placeholder","Auth":"","HTTPS":tr' +
        'ue,"Cors":"no","Link":"https:\/\/biriyani.anoram.com\/","Categor' +
        'y":"Personality"},{"API":"Dev.to","Description":"Access Forem ar' +
        'ticles, users and other resources via API","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/developers.forem.com\' +
        '/api","Category":"Personality"},{"API":"Dictum","Description":"A' +
        'PI to get access to the collection of the most inspiring express' +
        'ions of mankind","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/github.com\/fisenkodv\/dictum","Category":"Personalit' +
        'y"},{"API":"FavQs.com","Description":"FavQs allows you to collec' +
        't, discover and share your favorite quotes","Auth":"apiKey","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/favqs.com\/api","Cat' +
        'egory":"Personality"},{"API":"FOAAS","Description":"Fuck Off As ' +
        'A Service","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http' +
        ':\/\/www.foaas.com\/","Category":"Personality"},{"API":"Forismat' +
        'ic","Description":"Inspirational Quotes","Auth":"","HTTPS":false' +
        ',"Cors":"unknown","Link":"http:\/\/forismatic.com\/en\/api\/","C' +
        'ategory":"Personality"},{"API":"icanhazdadjoke","Description":"T' +
        'he largest selection of dad jokes on the internet","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/icanhazdadjoke.com\' +
        '/api","Category":"Personality"},{"API":"Inspiration","Descriptio' +
        'n":"Motivational and Inspirational quotes","Auth":"","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/inspiration.goprogram.ai\/docs\' +
        '/","Category":"Personality"},{"API":"kanye.rest","Description":"' +
        'REST API for random Kanye West quotes","Auth":"","HTTPS":true,"C' +
        'ors":"yes","Link":"https:\/\/kanye.rest","Category":"Personality' +
        '"},{"API":"kimiquotes","Description":"Team radio and interview q' +
        'uotes by Finnish F1 legend Kimi R'#228'ikk'#246'nen","Auth":"","HTTPS":tru' +
        'e,"Cors":"yes","Link":"https:\/\/kimiquotes.herokuapp.com\/doc",' +
        '"Category":"Personality"},{"API":"Medium","Description":"Communi' +
        'ty of readers and writers offering unique perspectives on ideas"' +
        ',"Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'github.com\/Medium\/medium-api-docs","Category":"Personality"},{' +
        '"API":"Programming Quotes","Description":"Programming Quotes API' +
        ' for open source projects","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/github.com\/skolakoda\/programming-quotes-a' +
        'pi","Category":"Personality"},{"API":"Quotable Quotes","Descript' +
        'ion":"Quotable is a free, open source quotations API","Auth":"",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/luke' +
        'Peavey\/quotable","Category":"Personality"},{"API":"Quote Garden' +
        '","Description":"REST API for more than 5000 famous quotes","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pprathames' +
        'hmore.github.io\/QuoteGarden\/","Category":"Personality"},{"API"' +
        ':"quoteclear","Description":"Ever-growing list of James Clear qu' +
        'otes from the 3-2-1 Newsletter","Auth":"","HTTPS":true,"Cors":"y' +
        'es","Link":"https:\/\/quoteclear.web.app\/","Category":"Personal' +
        'ity"},{"API":"Quotes on Design","Description":"Inspirational Quo' +
        'tes","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/q' +
        'uotesondesign.com\/api\/","Category":"Personality"},{"API":"Stoi' +
        'cism Quote","Description":"Quotes about Stoicism","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/github.com\/tlcheah2' +
        '\/stoic-quote-lambda-public-api","Category":"Personality"},{"API' +
        '":"They Said So Quotes","Description":"Quotes Trusted by many fo' +
        'rtune brands around the world","Auth":"","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/theysaidso.com\/api\/","Category":"Pers' +
        'onality"},{"API":"Traitify","Description":"Assess, collect and a' +
        'nalyze Personality","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/app.traitify.com\/developer","Category":"Personali' +
        'ty"},{"API":"Udemy(instructor)","Description":"API for instructo' +
        'rs on Udemy","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/www.udemy.com\/developers\/instructor\/","Category"' +
        ':"Personality"},{"API":"Vadivelu HTTP Codes","Description":"On d' +
        'emand HTTP Codes with images","Auth":"","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/vadivelu.anoram.com\/","Category":"Personalit' +
        'y"},{"API":"Zen Quotes","Description":"Large collection of Zen q' +
        'uotes for inspiration","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/zenquotes.io\/","Category":"Personality"},{"API":"A' +
        'bstract Phone Validation","Description":"Validate phone numbers ' +
        'globally","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/www.abstractapi.com\/phone-validation-api","Category":"Pho' +
        'ne"},{"API":"apilayer numverify","Description":"Phone number val' +
        'idation","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/numverify.com","Category":"Phone"},{"API":"Cloudmersive' +
        ' Validate","Description":"Validate international phone numbers",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/clou' +
        'dmersive.com\/phone-number-validation-API","Category":"Phone"},{' +
        '"API":"Phone Specification","Description":"Rest Api for Phone sp' +
        'ecifications","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:' +
        '\/\/github.com\/azharimm\/phone-specs-api","Category":"Phone"},{' +
        '"API":"Veriphone","Description":"Phone number validation & carri' +
        'er lookup","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/veriphone.io","Category":"Phone"},{"API":"apilayer screen' +
        'shotlayer","Description":"URL 2 Image","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/screenshotlayer.com","Category"' +
        ':"Photography"},{"API":"APITemplate.io","Description":"Dynamical' +
        'ly generate images and PDFs from templates with a simple API","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/apitem' +
        'plate.io","Category":"Photography"},{"API":"Bruzu","Description"' +
        ':"Image generation with query string","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/docs.bruzu.com","Category":"Ph' +
        'otography"},{"API":"CheetahO","Description":"Photo optimization ' +
        'and resize","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/cheetaho.com\/docs\/getting-started\/","Category":"P' +
        'hotography"},{"API":"Dagpi","Description":"Image manipulation an' +
        'd processing","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/dagpi.xyz","Category":"Photography"},{"API":"Duply' +
        '","Description":"Generate, Edit, Scale and Manage Images and Vid' +
        'eos Smarter & Faster","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/duply.co\/docs#getting-started-api","Category"' +
        ':"Photography"},{"API":"DynaPictures","Description":"Generate Hu' +
        'ndreds of Personalized Images in Minutes","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/dynapictures.com\/docs\/",' +
        '"Category":"Photography"},{"API":"Flickr","Description":"Flickr ' +
        'Services","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/www.flickr.com\/services\/api\/","Category":"Photograph' +
        'y"},{"API":"Getty Images","Description":"Build applications usin' +
        'g the world'#39's most powerful imagery","Auth":"OAuth","HTTPS":true' +
        ',"Cors":"unknown","Link":"http:\/\/developers.gettyimages.com\/e' +
        'n\/","Category":"Photography"},{"API":"Gfycat","Description":"Ji' +
        'ffier GIFs","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/developers.gfycat.com\/api\/","Category":"Photography' +
        '"},{"API":"Giphy","Description":"Get all your gifs","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.g' +
        'iphy.com\/docs\/","Category":"Photography"},{"API":"Google Photo' +
        's","Description":"Integrate Google Photos with your apps or devi' +
        'ces","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/developers.google.com\/photos","Category":"Photography"},{"A' +
        'PI":"Image Upload","Description":"Image Optimization","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/apilayer.c' +
        'om\/marketplace\/image_upload-api","Category":"Photography"},{"A' +
        'PI":"Imgur","Description":"Images","Auth":"OAuth","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/apidocs.imgur.com\/","Category' +
        '":"Photography"},{"API":"Imsea","Description":"Free image search' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/imse' +
        'a.herokuapp.com\/","Category":"Photography"},{"API":"Lorem Picsu' +
        'm","Description":"Images from Unsplash","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"https:\/\/picsum.photos\/","Category":"P' +
        'hotography"},{"API":"ObjectCut","Description":"Image Background ' +
        'removal","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https' +
        ':\/\/objectcut.com\/","Category":"Photography"},{"API":"Pexels",' +
        '"Description":"Free Stock Photos and Videos","Auth":"apiKey","HT' +
        'TPS":true,"Cors":"yes","Link":"https:\/\/www.pexels.com\/api\/",' +
        '"Category":"Photography"},{"API":"PhotoRoom","Description":"Remo' +
        've background from images","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/www.photoroom.com\/api\/","Category":' +
        '"Photography"},{"API":"Pixabay","Description":"Photography","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/pixa' +
        'bay.com\/sk\/service\/about\/api\/","Category":"Photography"},{"' +
        'API":"PlaceKeanu","Description":"Resizable Keanu Reeves placehol' +
        'der images with grayscale and young Keanu options","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/placekeanu.com\/","' +
        'Category":"Photography"},{"API":"Readme typing SVG","Description' +
        '":"Customizable typing and deleting text SVG","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/github.com\/DenverCoder1' +
        '\/readme-typing-svg","Category":"Photography"},{"API":"Remove.bg' +
        '","Description":"Image Background removal","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/www.remove.bg\/api","' +
        'Category":"Photography"},{"API":"ReSmush.it","Description":"Phot' +
        'o optimization","Auth":"","HTTPS":false,"Cors":"unknown","Link":' +
        '"https:\/\/resmush.it\/api","Category":"Photography"},{"API":"sh' +
        'utterstock","Description":"Stock Photos and Videos","Auth":"OAut' +
        'h","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api-reference' +
        '.shutterstock.com\/","Category":"Photography"},{"API":"Sirv","De' +
        'scription":"Image management solutions like optimization, manipu' +
        'lation, hosting","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/apidocs.sirv.com\/","Category":"Photography"},{' +
        '"API":"Unsplash","Description":"Photography","Auth":"OAuth","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/unsplash.com\/develo' +
        'pers","Category":"Photography"},{"API":"Wallhaven","Description"' +
        ':"Wallpapers","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/wallhaven.cc\/help\/api","Category":"Photography"}' +
        ',{"API":"Webdam","Description":"Images","Auth":"OAuth","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/www.damsuccess.com\/hc\/e' +
        'n-us\/articles\/202134055-REST-API","Category":"Photography"},{"' +
        'API":"Codeforces","Description":"Get access to Codeforces data",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'codeforces.com\/apiHelp","Category":"Programming"},{"API":"Hacke' +
        'rearth","Description":"For compiling and running code in several' +
        ' languages","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.hackerearth.com\/docs\/wiki\/developers\/v4\/","' +
        'Category":"Programming"},{"API":"Judge0 CE","Description":"Onlin' +
        'e code execution system","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/ce.judge0.com\/","Category":"Programmin' +
        'g"},{"API":"KONTESTS","Description":"For upcoming and ongoing co' +
        'mpetitive coding contests","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/kontests.net\/api","Category":"Programming"' +
        '},{"API":"Mintlify","Description":"For programmatically generati' +
        'ng documentation for code","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/docs.mintlify.com","Category":"Programmin' +
        'g"},{"API":"arcsecond.io","Description":"Multiple astronomy data' +
        ' sources","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:' +
        '\/\/api.arcsecond.io\/","Category":"Science & Math"},{"API":"arX' +
        'iv","Description":"Curated research-sharing platform: physics, m' +
        'athematics, quantitative finance, and economics","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/arxiv.org\/help\/api\' +
        '/user-manual","Category":"Science & Math"},{"API":"CORE","Descri' +
        'ption":"Access the world'#39's Open Access research papers","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/core.ac.' +
        'uk\/services#api","Category":"Science & Math"},{"API":"GBIF","De' +
        'scription":"Global Biodiversity Information Facility","Auth":"",' +
        '"HTTPS":true,"Cors":"yes","Link":"https:\/\/www.gbif.org\/develo' +
        'per\/summary","Category":"Science & Math"},{"API":"iDigBio","Des' +
        'cription":"Access millions of museum specimens from organization' +
        's around the world","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/github.com\/idigbio\/idigbio-search-api\/wiki","Ca' +
        'tegory":"Science & Math"},{"API":"inspirehep.net","Description":' +
        '"High Energy Physics info. system","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/github.com\/inspirehep\/rest-api-do' +
        'c","Category":"Science & Math"},{"API":"isEven (humor)","Descrip' +
        'tion":"Check if a number is even","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/isevenapi.xyz\/","Category":"Science' +
        ' & Math"},{"API":"ISRO","Description":"ISRO Space Crafts Informa' +
        'tion","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/isro.' +
        'vercel.app","Category":"Science & Math"},{"API":"ITIS","Descript' +
        'ion":"Integrated Taxonomic Information System","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/www.itis.gov\/ws_descri' +
        'ption.html","Category":"Science & Math"},{"API":"Launch Library ' +
        '2","Description":"Spaceflight launches and events database","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/thespacedevs.c' +
        'om\/llapi","Category":"Science & Math"},{"API":"Materials Platfo' +
        'rm for Data Science","Description":"Curated experimental data fo' +
        'r materials science","Auth":"apiKey","HTTPS":true,"Cors":"no","L' +
        'ink":"https:\/\/mpds.io","Category":"Science & Math"},{"API":"Mi' +
        'nor Planet Center","Description":"Asterank.com Information","Aut' +
        'h":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/www.astera' +
        'nk.com\/mpc","Category":"Science & Math"},{"API":"NASA","Descrip' +
        'tion":"NASA data, including imagery","Auth":"","HTTPS":true,"Cor' +
        's":"no","Link":"https:\/\/api.nasa.gov","Category":"Science & Ma' +
        'th"},{"API":"NASA ADS","Description":"NASA Astrophysics Data Sys' +
        'tem","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'ui.adsabs.harvard.edu\/help\/api\/api-docs.html","Category":"Sci' +
        'ence & Math"},{"API":"Newton","Description":"Symbolic and Arithm' +
        'etic Math Calculator","Auth":"","HTTPS":true,"Cors":"no","Link":' +
        '"https:\/\/newton.vercel.app","Category":"Science & Math"},{"API' +
        '":"Noctua","Description":"REST API used to access NoctuaSky feat' +
        'ures","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'api.noctuasky.com\/api\/v1\/swaggerdoc\/","Category":"Science & ' +
        'Math"},{"API":"Numbers","Description":"Number of the day, random' +
        ' number, number facts and anything else you want to do with numb' +
        'ers","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/' +
        'math.tools\/api\/numbers\/","Category":"Science & Math"},{"API":' +
        '"Numbers","Description":"Facts about numbers","Auth":"","HTTPS":' +
        'false,"Cors":"no","Link":"http:\/\/numbersapi.com","Category":"S' +
        'cience & Math"},{"API":"Ocean Facts","Description":"Facts pertai' +
        'ning to the physical science of Oceanography","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/oceanfacts.herokuapp.com' +
        '\/","Category":"Science & Math"},{"API":"Open Notify","Descripti' +
        'on":"ISS astronauts, current location, etc","Auth":"","HTTPS":fa' +
        'lse,"Cors":"no","Link":"http:\/\/open-notify.org\/Open-Notify-AP' +
        'I\/","Category":"Science & Math"},{"API":"Open Science Framework' +
        '","Description":"Repository and archive for study designs, resea' +
        'rch materials, data, manuscripts, etc","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/developer.osf.io","Category":"S' +
        'cience & Math"},{"API":"Purple Air","Description":"Real Time Air' +
        ' Quality Monitoring","Auth":"","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/www2.purpleair.com\/","Category":"Science & Math"' +
        '},{"API":"Remote Calc","Description":"Decodes base64 encoding an' +
        'd parses it to return a solution to the calculation in JSON","Au' +
        'th":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/e' +
        'lizabethadegbaju\/remotecalc","Category":"Science & Math"},{"API' +
        '":"SHARE","Description":"A free, open, dataset about research an' +
        'd scholarly activities","Auth":"","HTTPS":true,"Cors":"no","Link' +
        '":"https:\/\/share.osf.io\/api\/v2\/","Category":"Science & Math' +
        '"},{"API":"SpaceX","Description":"Company, vehicle, launchpad an' +
        'd launch data","Auth":"","HTTPS":true,"Cors":"no","Link":"https:' +
        '\/\/github.com\/r-spacex\/SpaceX-API","Category":"Science & Math' +
        '"},{"API":"SpaceX","Description":"GraphQL, Company, Ships, launc' +
        'hpad and launch data","Auth":"","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/api.spacex.land\/graphql\/","Category":"Science ' +
        '& Math"},{"API":"Sunrise and Sunset","Description":"Sunset and s' +
        'unrise times for a given latitude and longitude","Auth":"","HTTP' +
        'S":true,"Cors":"no","Link":"https:\/\/sunrise-sunset.org\/api","' +
        'Category":"Science & Math"},{"API":"Times Adder","Description":"' +
        'With this API you can add each of the times introduced in the ar' +
        'ray sended","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\' +
        '/github.com\/FranP-code\/API-Times-Adder","Category":"Science & ' +
        'Math"},{"API":"TLE","Description":"Satellite information","Auth"' +
        ':"","HTTPS":true,"Cors":"no","Link":"https:\/\/tle.ivanstanojevi' +
        'c.me\/#\/docs","Category":"Science & Math"},{"API":"USGS Earthqu' +
        'ake Hazards Program","Description":"Earthquakes data real-time",' +
        '"Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/earthquake.' +
        'usgs.gov\/fdsnws\/event\/1\/","Category":"Science & Math"},{"API' +
        '":"USGS Water Services","Description":"Water quality and level i' +
        'nfo for rivers and lakes","Auth":"","HTTPS":true,"Cors":"no","Li' +
        'nk":"https:\/\/waterservices.usgs.gov\/","Category":"Science & M' +
        'ath"},{"API":"World Bank","Description":"World Data","Auth":"","' +
        'HTTPS":true,"Cors":"no","Link":"https:\/\/datahelpdesk.worldbank' +
        '.org\/knowledgebase\/topics\/125589","Category":"Science & Math"' +
        '},{"API":"xMath","Description":"Random mathematical expressions"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/x-math.he' +
        'rokuapp.com\/","Category":"Science & Math"},{"API":"Application ' +
        'Environment Verification","Description":"Android library and API' +
        ' to verify the safety of user devices, detect rooted devices and' +
        ' other risks","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"' +
        'https:\/\/github.com\/fingerprintjs\/aev","Category":"Security"}' +
        ',{"API":"BinaryEdge","Description":"Provide access to BinaryEdge' +
        ' 40fy scanning platform","Auth":"apiKey","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/docs.binaryedge.io\/api-v2.html","Category"' +
        ':"Security"},{"API":"BitWarden","Description":"Best open-source ' +
        'password manager","Auth":"OAuth","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/bitwarden.com\/help\/api\/","Category":"Securit' +
        'y"},{"API":"Botd","Description":"Botd is a browser library for J' +
        'avaScript bot detection","Auth":"apiKey","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/github.com\/fingerprintjs\/botd","Category"' +
        ':"Security"},{"API":"Bugcrowd","Description":"Bugcrowd API for i' +
        'nteracting and tracking the reported issues programmatically","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/do' +
        'cs.bugcrowd.com\/api\/getting-started\/","Category":"Security"},' +
        '{"API":"Censys","Description":"Search engine for Internet connec' +
        'ted host and devices","Auth":"apiKey","HTTPS":true,"Cors":"no","' +
        'Link":"https:\/\/search.censys.io\/api","Category":"Security"},{' +
        '"API":"Classify","Description":"Encrypting & decrypting text mes' +
        'sages","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/cla' +
        'ssify-web.herokuapp.com\/#\/api","Category":"Security"},{"API":"' +
        'Complete Criminal Checks","Description":"Provides data of offend' +
        'ers from all U.S. States and Pureto Rico","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"yes","Link":"https:\/\/completecriminalchecks.com' +
        '\/Developers","Category":"Security"},{"API":"CRXcavator","Descri' +
        'ption":"Chrome extension risk scoring","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/crxcavator.io\/apidocs","' +
        'Category":"Security"},{"API":"Dehash.lt","Description":"Hash dec' +
        'ryption MD5, SHA1, SHA3, SHA256, SHA384, SHA512","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/github.com\/Dehash-lt' +
        '\/api","Category":"Security"},{"API":"EmailRep","Description":"E' +
        'mail address threat and risk prediction","Auth":"","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/docs.emailrep.io\/","Category' +
        '":"Security"},{"API":"Escape","Description":"An API for escaping' +
        ' different kind of queries","Auth":"","HTTPS":true,"Cors":"no","' +
        'Link":"https:\/\/github.com\/polarspetroll\/EscapeAPI","Category' +
        '":"Security"},{"API":"FilterLists","Description":"Lists of filte' +
        'rs for adblockers and firewalls","Auth":"","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/filterlists.com","Category":"Security' +
        '"},{"API":"FingerprintJS Pro","Description":"Fraud detection API' +
        ' offering highly accurate browser fingerprinting","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/dev.fingerprintjs.' +
        'com\/docs","Category":"Security"},{"API":"FraudLabs Pro","Descri' +
        'ption":"Screen order information using AI to detect frauds","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.' +
        'fraudlabspro.com\/developer\/api\/screen-order","Category":"Secu' +
        'rity"},{"API":"FullHunt","Description":"Searchable attack surfac' +
        'e database of the entire internet","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/api-docs.fullhunt.io\/#introd' +
        'uction","Category":"Security"},{"API":"GitGuardian","Description' +
        '":"Scan files for secrets (API Keys, database credentials)","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\/api.gitgu' +
        'ardian.com\/doc","Category":"Security"},{"API":"GreyNoise","Desc' +
        'ription":"Query IPs in the GreyNoise dataset and retrieve a subs' +
        'et of the full IP context data","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/docs.greynoise.io\/reference\/ge' +
        't_v3-community-ip","Category":"Security"},{"API":"HackerOne","De' +
        'scription":"The industry'#8217's first hacker API that helps increase ' +
        'productivity towards creative bug bounty hunting","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.hackerone.' +
        'com\/","Category":"Security"},{"API":"Hashable","Description":"A' +
        ' REST API to access high level cryptographic functions and metho' +
        'ds","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/hashab' +
        'le.space\/pages\/api\/","Category":"Security"},{"API":"HaveIBeen' +
        'Pwned","Description":"Passwords which have previously been expos' +
        'ed in data breaches","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/haveibeenpwned.com\/API\/v3","Category":"Se' +
        'curity"},{"API":"Intelligence X","Description":"Perform OSINT vi' +
        'a Intelligence X","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/github.com\/IntelligenceX\/SDK\/blob\/master\/' +
        'Intelligence%20X%20API.pdf","Category":"Security"},{"API":"Login' +
        'Radius","Description":"Managed User Authentication Service","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.logi' +
        'nradius.com\/docs\/","Category":"Security"},{"API":"Microsoft Se' +
        'curity Response Center (MSRC)","Description":"Programmatic inter' +
        'faces to engage with the Microsoft Security Response Center (MSR' +
        'C)","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ms' +
        'rc.microsoft.com\/report\/developer","Category":"Security"},{"AP' +
        'I":"Mozilla http scanner","Description":"Mozilla observatory htt' +
        'p scanner","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/github.com\/mozilla\/http-observatory\/blob\/master\/httpob' +
        's\/docs\/api.md","Category":"Security"},{"API":"Mozilla tls scan' +
        'ner","Description":"Mozilla observatory tls scanner","Auth":"","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.com\/mozil' +
        'la\/tls-observatory#api-endpoints","Category":"Security"},{"API"' +
        ':"National Vulnerability Database","Description":"U.S. National ' +
        'Vulnerability Database","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/nvd.nist.gov\/vuln\/Data-Feeds\/JSON-feed-chan' +
        'gelog","Category":"Security"},{"API":"Passwordinator","Descripti' +
        'on":"Generate random passwords of varying complexities","Auth":"' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/fawazs' +
        'ullia\/password-generator\/","Category":"Security"},{"API":"Phis' +
        'hStats","Description":"Phishing database","Auth":"","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/phishstats.info\/","Category' +
        '":"Security"},{"API":"Privacy.com","Description":"Generate merch' +
        'ant-specific and one-time use credit card numbers that link back' +
        ' to your bank","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/privacy.com\/developer\/docs","Category":"Securit' +
        'y"},{"API":"Pulsedive","Description":"Scan, search and collect t' +
        'hreat intelligence data in real-time","Auth":"apiKey","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/pulsedive.com\/api\/","Cat' +
        'egory":"Security"},{"API":"SecurityTrails","Description":"Domain' +
        ' and IP related information such as current and historical WHOIS' +
        ' and DNS records","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/securitytrails.com\/corp\/apidocs","Category":' +
        '"Security"},{"API":"Shodan","Description":"Search engine for Int' +
        'ernet connected devices","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/developer.shodan.io\/","Category":"Secu' +
        'rity"},{"API":"Spyse","Description":"Access data on all Internet' +
        ' assets and build powerful attack surface management application' +
        's","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/spyse-dev.readme.io\/reference\/quick-start","Category":"Secu' +
        'rity"},{"API":"Threat Jammer","Description":"Risk scoring servic' +
        'e from curated threat intelligence data","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/threatjammer.com\/docs\' +
        '/index","Category":"Security"},{"API":"UK Police","Description":' +
        '"UK Police data","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/data.police.uk\/docs\/","Category":"Security"},{"API"' +
        ':"Virushee","Description":"Virushee file\/data scanning","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.virushee.com\' +
        '/","Category":"Security"},{"API":"VulDB","Description":"VulDB AP' +
        'I allows to initiate queries for one or more items along with tr' +
        'ansactional bots","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/vuldb.com\/?doc.api","Category":"Security"},{"' +
        'API":"Best Buy","Description":"Products, Buying Options, Categor' +
        'ies, Recommendations, Stores and Commerce","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/bestbuyapis.github.io' +
        '\/api-documentation\/#overview","Category":"Shopping"},{"API":"D' +
        'igi-Key","Description":"Retrieve price and inventory of electron' +
        'ic components as well as place orders","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/www.digikey.com\/en\/resou' +
        'rces\/api-solutions","Category":"Shopping"},{"API":"Dummy Produc' +
        'ts","Description":"An api to fetch dummy e-commerce products JSO' +
        'N data with placeholder images","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/dummyproducts-api.herokuapp.com\/","' +
        'Category":"Shopping"},{"API":"eBay","Description":"Sell and Buy ' +
        'on eBay","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/developer.ebay.com\/","Category":"Shopping"},{"API":"Ets' +
        'y","Description":"Manage shop and interact with listings","Auth"' +
        ':"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ets' +
        'y.com\/developers\/documentation\/getting_started\/api_basics","' +
        'Category":"Shopping"},{"API":"Flipkart Marketplace","Description' +
        '":"Product listing management, Order Fulfilment in the Flipkart ' +
        'Marketplace","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/seller.flipkart.com\/api-docs\/FMSAPI.html","Category":"' +
        'Shopping"},{"API":"Lazada","Description":"Retrieve product ratin' +
        'gs and seller performance metrics","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/open.lazada.com\/doc\/doc.htm' +
        '","Category":"Shopping"},{"API":"Mercadolibre","Description":"Ma' +
        'nage sales, ads, products, services and Shops","Auth":"apiKey","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.mercad' +
        'olibre.cl\/es_ar\/api-docs-es","Category":"Shopping"},{"API":"Oc' +
        'topart","Description":"Electronic part data for manufacturing, d' +
        'esign, and sourcing","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/octopart.com\/api\/v4\/reference","Category' +
        '":"Shopping"},{"API":"OLX Poland","Description":"Integrate with ' +
        'local sites by posting, managing adverts and communicating with ' +
        'OLX users","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/developer.olx.pl\/api\/doc#section\/","Category":"Sho' +
        'pping"},{"API":"Rappi","Description":"Manage orders from Rappi'#39's' +
        ' app","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/dev-portal.rappi.com\/","Category":"Shopping"},{"API":"Shop' +
        'ee","Description":"Shopee'#39's official API for integration of vari' +
        'ous services from Shopee","Auth":"apiKey","HTTPS":true,"Cors":"u' +
        'nknown","Link":"https:\/\/open.shopee.com\/documents?version=1",' +
        '"Category":"Shopping"},{"API":"Tokopedia","Description":"Tokoped' +
        'ia'#39's Official API for integration of various services from Tokop' +
        'edia","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developer.tokopedia.com\/openapi\/guide\/#\/","Category":"S' +
        'hopping"},{"API":"WooCommerce","Description":"WooCommerce REST A' +
        'PIS to create, read, update, and delete data on wordpress websit' +
        'e in JSON format","Auth":"apiKey","HTTPS":true,"Cors":"yes","Lin' +
        'k":"https:\/\/woocommerce.github.io\/woocommerce-rest-api-docs\/' +
        '","Category":"Shopping"},{"API":"4chan","Description":"Simple im' +
        'age-based bulletin board dedicated to a variety of topics","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/4ch' +
        'an\/4chan-API","Category":"Social"},{"API":"Ayrshare","Descripti' +
        'on":"Social media APIs to post, get analytics, and manage multip' +
        'le users social media accounts","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"yes","Link":"https:\/\/www.ayrshare.com","Category":"Social' +
        '"},{"API":"aztro","Description":"Daily horoscope info for yester' +
        'day, today, and tomorrow","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/aztro.sameerkumar.website\/","Category":"Soc' +
        'ial"},{"API":"Blogger","Description":"The Blogger APIs allows cl' +
        'ient applications to view and update Blogger content","Auth":"OA' +
        'uth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.' +
        'google.com\/blogger\/","Category":"Social"},{"API":"Cisco Spark"' +
        ',"Description":"Team Collaboration Software","Auth":"OAuth","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/developer.ciscospark' +
        '.com","Category":"Social"},{"API":"Dangerous Discord Database","' +
        'Description":"Database of malicious Discord accounts","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/discord.ri' +
        'verside.rocks\/docs\/index.php","Category":"Social"},{"API":"Dis' +
        'cord","Description":"Make bots for Discord, integrate Discord on' +
        'to an external platform","Auth":"OAuth","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/discord.com\/developers\/docs\/intro","C' +
        'ategory":"Social"},{"API":"Disqus","Description":"Communicate wi' +
        'th Disqus data","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/disqus.com\/api\/docs\/auth\/","Category":"Social' +
        '"},{"API":"Doge-Meme","Description":"Top meme posts from r\/doge' +
        'coin which include '#39'Meme'#39' flair","Auth":"","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/api.doge-meme.lol\/docs","Category":"Soci' +
        'al"},{"API":"Facebook","Description":"Facebook Login, Share on F' +
        'B, Social Plugins, Analytics and more","Auth":"OAuth","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/developers.facebook.com\/"' +
        ',"Category":"Social"},{"API":"Foursquare","Description":"Interac' +
        't with Foursquare users and places (geolocation-based checkins, ' +
        'photos, tips, events, etc)","Auth":"OAuth","HTTPS":true,"Cors":"' +
        'unknown","Link":"https:\/\/developer.foursquare.com\/","Category' +
        '":"Social"},{"API":"Fuck Off as a Service","Description":"Asks s' +
        'omeone to fuck off","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/www.foaas.com","Category":"Social"},{"API":"Full C' +
        'ontact","Description":"Get Social Media profiles and contact Inf' +
        'ormation","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/docs.fullcontact.com\/","Category":"Social"},{"API":"Ha' +
        'ckerNews","Description":"Social news for CS and entrepreneurship' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gith' +
        'ub.com\/HackerNews\/API","Category":"Social"},{"API":"Hashnode",' +
        '"Description":"A blogging platform built for developers","Auth":' +
        '"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/hashnode.com"' +
        ',"Category":"Social"},{"API":"Instagram","Description":"Instagra' +
        'm Login, Share on Instagram, Social Plugins and more","Auth":"OA' +
        'uth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.instagr' +
        'am.com\/developer\/","Category":"Social"},{"API":"Kakao","Descri' +
        'ption":"Kakao Login, Share on KakaoTalk, Social Plugins and more' +
        '","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/developers.kakao.com\/","Category":"Social"},{"API":"Lanyard","' +
        'Description":"Retrieve your presence on Discord through an HTTP ' +
        'REST API or WebSocket","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/github.com\/Phineas\/lanyard","Category":"Social"},' +
        '{"API":"Line","Description":"Line Login, Share on Line, Social P' +
        'lugins and more","Auth":"OAuth","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/developers.line.biz\/","Category":"Social"},{"AP' +
        'I":"LinkedIn","Description":"The foundation of all digital integ' +
        'rations with LinkedIn","Auth":"OAuth","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/docs.microsoft.com\/en-us\/linkedin\/?cont' +
        'ext=linkedin\/context","Category":"Social"},{"API":"Meetup.com",' +
        '"Description":"Data about Meetups from Meetup.com","Auth":"apiKe' +
        'y","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.meetup.co' +
        'm\/api\/guide","Category":"Social"},{"API":"Microsoft Graph","De' +
        'scription":"Access the data and intelligence in Microsoft 365, W' +
        'indows 10, and Enterprise Mobility","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/docs.microsoft.com\/en-us\/gr' +
        'aph\/api\/overview","Category":"Social"},{"API":"NAVER","Descrip' +
        'tion":"NAVER Login, Share on NAVER, Social Plugins and more","Au' +
        'th":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/deve' +
        'lopers.naver.com\/main\/","Category":"Social"},{"API":"Open Coll' +
        'ective","Description":"Get Open Collective data","Auth":"","HTTP' +
        'S":true,"Cors":"unknown","Link":"https:\/\/docs.opencollective.c' +
        'om\/help\/developers\/api","Category":"Social"},{"API":"Pinteres' +
        't","Description":"The world'#39's catalog of ideas","Auth":"OAuth","' +
        'HTTPS":true,"Cors":"unknown","Link":"https:\/\/developers.pinter' +
        'est.com\/","Category":"Social"},{"API":"Product Hunt","Descripti' +
        'on":"The best new products in tech","Auth":"OAuth","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/api.producthunt.com\/v2\/docs' +
        '","Category":"Social"},{"API":"Reddit","Description":"Homepage o' +
        'f the internet","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/www.reddit.com\/dev\/api","Category":"Social"},{"' +
        'API":"Revolt","Description":"Revolt open source Discord alternat' +
        'ive","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developers.revolt.chat\/api\/","Category":"Social"},{"API":' +
        '"Saidit","Description":"Open Source Reddit Clone","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.saidit.net\' +
        '/dev\/api","Category":"Social"},{"API":"Slack","Description":"Te' +
        'am Instant Messaging","Auth":"OAuth","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/api.slack.com\/","Category":"Social"},{"API' +
        '":"TamTam","Description":"Bot API to interact with TamTam","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dev.t' +
        'amtam.chat\/","Category":"Social"},{"API":"Telegram Bot","Descri' +
        'ption":"Simplified HTTP version of the MTProto API for bots","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/cor' +
        'e.telegram.org\/bots\/api","Category":"Social"},{"API":"Telegram' +
        ' MTProto","Description":"Read and write Telegram data","Auth":"O' +
        'Auth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/core.teleg' +
        'ram.org\/api#getting-started","Category":"Social"},{"API":"Teleg' +
        'raph","Description":"Create attractive blogs easily, to share","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/t' +
        'elegra.ph\/api","Category":"Social"},{"API":"TikTok","Descriptio' +
        'n":"Fetches user info and user'#39's video posts on TikTok platform"' +
        ',"Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'developers.tiktok.com\/doc\/login-kit-web","Category":"Social"},' +
        '{"API":"Trash Nothing","Description":"A freecycling community wi' +
        'th thousands of free items posted every day","Auth":"OAuth","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/trashnothing.com\/develo' +
        'per","Category":"Social"},{"API":"Tumblr","Description":"Read an' +
        'd write Tumblr Data","Auth":"OAuth","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/www.tumblr.com\/docs\/en\/api\/v2","Category' +
        '":"Social"},{"API":"Twitch","Description":"Game Streaming API","' +
        'Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/de' +
        'v.twitch.tv\/docs","Category":"Social"},{"API":"Twitter","Descri' +
        'ption":"Read and write Twitter data","Auth":"OAuth","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/developer.twitter.com\/en\/docs",' +
        '"Category":"Social"},{"API":"vk","Description":"Read and write v' +
        'k data","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/vk.com\/dev\/sites","Category":"Social"},{"API":"API-FOOT' +
        'BALL","Description":"Get information about Football Leagues & Cu' +
        'ps","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'www.api-football.com\/documentation-v3","Category":"Sports & Fit' +
        'ness"},{"API":"ApiMedic","Description":"ApiMedic offers a medica' +
        'l symptom checker API primarily for patients","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/apimedic.com\/","C' +
        'ategory":"Sports & Fitness"},{"API":"balldontlie","Description":' +
        '"Balldontlie provides access to stats data from the NBA","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.balldontlie.i' +
        'o","Category":"Sports & Fitness"},{"API":"Canadian Football Leag' +
        'ue (CFL)","Description":"Official JSON API providing real-time l' +
        'eague, team and player statistics about the CFL","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"no","Link":"http:\/\/api.cfl.ca\/","Catego' +
        'ry":"Sports & Fitness"},{"API":"City Bikes","Description":"City ' +
        'Bikes around the world","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/api.citybik.es\/v2\/","Category":"Sports & Fit' +
        'ness"},{"API":"Cloudbet","Description":"Official Cloudbet API pr' +
        'ovides real-time sports odds and betting API to place bets progr' +
        'ammatically","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"h' +
        'ttps:\/\/www.cloudbet.com\/api\/","Category":"Sports & Fitness"}' +
        ',{"API":"CollegeFootballData.com","Description":"Unofficial deta' +
        'iled American college football statistics, records, and results ' +
        'API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/collegefootballdata.com","Category":"Sports & Fitness"},{"A' +
        'PI":"Ergast F1","Description":"F1 data from the beginning of the' +
        ' world championships in 1950","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"http:\/\/ergast.com\/mrd\/","Category":"Sports & F' +
        'itness"},{"API":"Fitbit","Description":"Fitbit Information","Aut' +
        'h":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https:\/\/dev.f' +
        'itbit.com\/","Category":"Sports & Fitness"},{"API":"Football","D' +
        'escription":"A simple Open Source Football API to get squads'#8217' st' +
        'ats, best scorers and more","Auth":"X-Mashape-Key","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/rapidapi.com\/GiulianoCrescim' +
        'beni\/api\/football98\/","Category":"Sports & Fitness"},{"API":"' +
        'Football (Soccer) Videos","Description":"Embed codes for goals a' +
        'nd highlights from Premier League, Bundesliga, Serie A and many ' +
        'more","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.' +
        'scorebat.com\/video-api\/","Category":"Sports & Fitness"},{"API"' +
        ':"Football Standings","Description":"Display football standings ' +
        'e.g epl, la liga, serie a etc. The data is based on espn site","' +
        'Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\' +
        '/azharimm\/football-standings-api","Category":"Sports & Fitness"' +
        '},{"API":"Football-Data","Description":"Football data with match' +
        'es info, players, teams, and competitions","Auth":"X-Mashape-Key' +
        '","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.football-d' +
        'ata.org","Category":"Sports & Fitness"},{"API":"JCDecaux Bike","' +
        'Description":"JCDecaux'#39's self-service bicycles","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.jcdeca' +
        'ux.com\/","Category":"Sports & Fitness"},{"API":"MLB Records and' +
        ' Stats","Description":"Current and historical MLB statistics","A' +
        'uth":"","HTTPS":false,"Cors":"unknown","Link":"https:\/\/appac.g' +
        'ithub.io\/mlb-data-api-docs\/","Category":"Sports & Fitness"},{"' +
        'API":"NBA Data","Description":"All NBA Stats DATA, Games, Livesc' +
        'ore, Standings, Statistics","Auth":"apiKey","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/rapidapi.com\/api-sports\/api\/api-n' +
        'ba\/","Category":"Sports & Fitness"},{"API":"NBA Stats","Descrip' +
        'tion":"Current and historical NBA Statistics","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/any-api.com\/nba_com\/nb' +
        'a_com\/docs\/API_Description","Category":"Sports & Fitness"},{"A' +
        'PI":"NHL Records and Stats","Description":"NHL historical data a' +
        'nd statistics","Auth":"","HTTPS":true,"Cors":"unknown","Link":"h' +
        'ttps:\/\/gitlab.com\/dword4\/nhlapi","Category":"Sports & Fitnes' +
        's"},{"API":"Oddsmagnet","Description":"Odds history from multipl' +
        'e UK bookmakers","Auth":"","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/data.oddsmagnet.com","Category":"Sports & Fitness"},{"API' +
        '":"OpenLigaDB","Description":"Crowd sourced sports league result' +
        's","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.ope' +
        'nligadb.de","Category":"Sports & Fitness"},{"API":"Premier Leagu' +
        'e Standings ","Description":"All Current Premier League Standing' +
        's and Statistics","Auth":"apiKey","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/rapidapi.com\/heisenbug\/api\/premier-league-l' +
        'ive-scores\/","Category":"Sports & Fitness"},{"API":"Sport Data"' +
        ',"Description":"Get sports data from all over the world","Auth":' +
        '"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/sportda' +
        'taapi.com","Category":"Sports & Fitness"},{"API":"Sport List & D' +
        'ata","Description":"List of and resources related to sports","Au' +
        'th":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/developers.de' +
        'cathlon.com\/products\/sports","Category":"Sports & Fitness"},{"' +
        'API":"Sport Places","Description":"Crowd-source sports places ar' +
        'ound the world","Auth":"","HTTPS":true,"Cors":"no","Link":"https' +
        ':\/\/developers.decathlon.com\/products\/sport-places","Category' +
        '":"Sports & Fitness"},{"API":"Sport Vision","Description":"Ident' +
        'ify sport, brands and gear in an image. Also does image sports c' +
        'aptioning","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"htt' +
        'ps:\/\/developers.decathlon.com\/products\/sport-vision","Catego' +
        'ry":"Sports & Fitness"},{"API":"Sportmonks Cricket","Description' +
        '":"Live cricket score, player statistics and fantasy API","Auth"' +
        ':"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/docs.s' +
        'portmonks.com\/cricket\/","Category":"Sports & Fitness"},{"API":' +
        '"Sportmonks Football","Description":"Football score\/schedule, n' +
        'ews api, tv channels, stats, history, display standing e.g. epl,' +
        ' la liga","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/docs.sportmonks.com\/football\/","Category":"Sports & ' +
        'Fitness"},{"API":"Squiggle","Description":"Fixtures, results and' +
        ' predictions for Australian Football League matches","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/api.squiggle.com.au",' +
        '"Category":"Sports & Fitness"},{"API":"Strava","Description":"Co' +
        'nnect with athletes, activities and more","Auth":"OAuth","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/strava.github.io\/api\/' +
        '","Category":"Sports & Fitness"},{"API":"SuredBits","Description' +
        '":"Query sports data, including teams, players, games, scores an' +
        'd statistics","Auth":"","HTTPS":false,"Cors":"no","Link":"https:' +
        '\/\/suredbits.com\/api\/","Category":"Sports & Fitness"},{"API":' +
        '"TheSportsDB","Description":"Crowd-Sourced Sports Data and Artwo' +
        'rk","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/' +
        'www.thesportsdb.com\/api.php","Category":"Sports & Fitness"},{"A' +
        'PI":"Tredict","Description":"Get and set activities, health data' +
        ' and more","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/www.tredict.com\/blog\/oauth_docs\/","Category":"Sport' +
        's & Fitness"},{"API":"Wger","Description":"Workout manager data ' +
        'as exercises, muscles or equipment","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/wger.de\/en\/software\/api",' +
        '"Category":"Sports & Fitness"},{"API":"Bacon Ipsum","Description' +
        '":"A Meatier Lorem Ipsum Generator","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/baconipsum.com\/json-api\/","Categ' +
        'ory":"Test Data"},{"API":"Dicebear Avatars","Description":"Gener' +
        'ate random pixel-art avatars","Auth":"","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/avatars.dicebear.com\/","Category":"Test Data' +
        '"},{"API":"English Random Words","Description":"Generate English' +
        ' Random Words with Pronunciation","Auth":"","HTTPS":true,"Cors":' +
        '"no","Link":"https:\/\/random-words-api.vercel.app\/word","Categ' +
        'ory":"Test Data"},{"API":"FakeJSON","Description":"Service to ge' +
        'nerate test and fake data","Auth":"apiKey","HTTPS":true,"Cors":"' +
        'yes","Link":"https:\/\/fakejson.com","Category":"Test Data"},{"A' +
        'PI":"FakerAPI","Description":"APIs collection to get fake data",' +
        '"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/fakerapi.i' +
        't\/en","Category":"Test Data"},{"API":"FakeStoreAPI","Descriptio' +
        'n":"Fake store rest API for your e-commerce or shopping website ' +
        'prototype","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/fakestoreapi.com\/","Category":"Test Data"},{"API":"Generad' +
        'orDNI","Description":"Data generator API. Profiles, vehicles, ba' +
        'nks and cards, etc","Auth":"apiKey","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/api.generadordni.es","Category":"Test Data"}' +
        ',{"API":"ItsThisForThat","Description":"Generate Random startup ' +
        'ideas","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\/\/itst' +
        'hisforthat.com\/api.php","Category":"Test Data"},{"API":"JSONPla' +
        'ceholder","Description":"Fake data for testing and prototyping",' +
        '"Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/jsonpl' +
        'aceholder.typicode.com\/","Category":"Test Data"},{"API":"Lorips' +
        'um","Description":"The \"lorem ipsum\" generator that doesn'#39't su' +
        'ck","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/lo' +
        'ripsum.net\/","Category":"Test Data"},{"API":"Mailsac","Descript' +
        'ion":"Disposable Email","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/mailsac.com\/docs\/api","Category":"Test' +
        ' Data"},{"API":"Metaphorsum","Description":"Generate demo paragr' +
        'aphs giving number of words and sentences","Auth":"","HTTPS":fal' +
        'se,"Cors":"unknown","Link":"http:\/\/metaphorpsum.com\/","Catego' +
        'ry":"Test Data"},{"API":"Mockaroo","Description":"Generate fake ' +
        'data to JSON, CSV, TXT, SQL and XML","Auth":"apiKey","HTTPS":tru' +
        'e,"Cors":"unknown","Link":"https:\/\/www.mockaroo.com\/docs","Ca' +
        'tegory":"Test Data"},{"API":"QuickMocker","Description":"API moc' +
        'king tool to generate contextual, fake or random data","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/quickmocker.com","C' +
        'ategory":"Test Data"},{"API":"Random Data","Description":"Random' +
        ' data generator","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/random-data-api.com","Category":"Test Data"},{"API":"' +
        'Randommer","Description":"Random data generator","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/randommer.io\/rando' +
        'mmer-api","Category":"Test Data"},{"API":"RandomUser","Descripti' +
        'on":"Generates and list user data","Auth":"","HTTPS":true,"Cors"' +
        ':"unknown","Link":"https:\/\/randomuser.me","Category":"Test Dat' +
        'a"},{"API":"RoboHash","Description":"Generate random robot\/alie' +
        'n avatars","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/robohash.org\/","Category":"Test Data"},{"API":"Spanish ran' +
        'dom names","Description":"Generate spanish names (with gender) r' +
        'andomly","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/random-names-api.herokuapp.com\/public","Category":"Test Data' +
        '"},{"API":"Spanish random words","Description":"Generate spanish' +
        ' words randomly","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/palabras-aleatorias-public-api.herokuapp.com","Catego' +
        'ry":"Test Data"},{"API":"This Person Does not Exist","Descriptio' +
        'n":"Generates real-life faces of people who do not exist","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/thispersondo' +
        'esnotexist.com","Category":"Test Data"},{"API":"Toolcarton","Des' +
        'cription":"Generate random testimonial data","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/testimonialapi.toolcarton' +
        '.com\/","Category":"Test Data"},{"API":"UUID Generator","Descrip' +
        'tion":"Generate UUIDs","Auth":"","HTTPS":true,"Cors":"no","Link"' +
        ':"https:\/\/www.uuidtools.com\/docs","Category":"Test Data"},{"A' +
        'PI":"What The Commit","Description":"Random commit message gener' +
        'ator","Auth":"","HTTPS":false,"Cors":"yes","Link":"http:\/\/what' +
        'thecommit.com\/index.txt","Category":"Test Data"},{"API":"Yes No' +
        '","Description":"Generate yes or no randomly","Auth":"","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/yesno.wtf\/api","Categor' +
        'y":"Test Data"},{"API":"Code Detection API","Description":"Detec' +
        't, label, format and enrich the code in your app or in your data' +
        ' pipeline","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/codedetectionapi.runtime.dev","Category":"Text Analysi' +
        's"},{"API":"apilayer languagelayer","Description":"Language Dete' +
        'ction JSON API supporting 173 languages","Auth":"OAuth","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/languagelayer.com\/","Ca' +
        'tegory":"Text Analysis"},{"API":"Aylien Text Analysis","Descript' +
        'ion":"A collection of information retrieval and natural language' +
        ' APIs","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/docs.aylien.com\/textapi\/#getting-started","Category":"T' +
        'ext Analysis"},{"API":"Cloudmersive Natural Language Processing"' +
        ',"Description":"Natural language processing and text analysis","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.c' +
        'loudmersive.com\/nlp-api","Category":"Text Analysis"},{"API":"De' +
        'tect Language","Description":"Detects text language","Auth":"api' +
        'Key","HTTPS":true,"Cors":"unknown","Link":"https:\/\/detectlangu' +
        'age.com\/","Category":"Text Analysis"},{"API":"ELI","Description' +
        '":"Natural Language Processing Tools for Thai Language","Auth":"' +
        'apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/nlp.insi' +
        'ghtera.co.th\/docs\/v1.0","Category":"Text Analysis"},{"API":"Go' +
        'ogle Cloud Natural","Description":"Natural language understandin' +
        'g technology, including sentiment, entity and syntax analysis","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/c' +
        'loud.google.com\/natural-language\/docs\/","Category":"Text Anal' +
        'ysis"},{"API":"Hirak OCR","Description":"Image to text -text rec' +
        'ognition- from image more than 100 language, accurate, unlimited' +
        ' requests","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/ocr.hirak.site\/","Category":"Text Analysis"},{"API":' +
        '"Hirak Translation","Description":"Translate between 21 of most ' +
        'used languages, accurate, unlimited requests","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/translate.hirak.si' +
        'te\/","Category":"Text Analysis"},{"API":"Lecto Translation","De' +
        'scription":"Translation API with free tier and reasonable prices' +
        '","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/ra' +
        'pidapi.com\/lecto-lecto-default\/api\/lecto-translation\/","Cate' +
        'gory":"Text Analysis"},{"API":"LibreTranslate","Description":"Tr' +
        'anslation tool with 17 available languages","Auth":"","HTTPS":tr' +
        'ue,"Cors":"unknown","Link":"https:\/\/libretranslate.com\/docs",' +
        '"Category":"Text Analysis"},{"API":"Semantria","Description":"Te' +
        'xt Analytics with sentiment analysis, categorization & named ent' +
        'ity extraction","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/semantria.readme.io\/docs","Category":"Text Analy' +
        'sis"},{"API":"Sentiment Analysis","Description":"Multilingual se' +
        'ntiment analysis of texts from different sources","Auth":"apiKey' +
        '","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.meaningcloud.c' +
        'om\/developer\/sentiment-analysis","Category":"Text Analysis"},{' +
        '"API":"Tisane","Description":"Text Analytics with focus on detec' +
        'tion of abusive content and law enforcement applications","Auth"' +
        ':"OAuth","HTTPS":true,"Cors":"yes","Link":"https:\/\/tisane.ai\/' +
        '","Category":"Text Analysis"},{"API":"Watson Natural Language Un' +
        'derstanding","Description":"Natural language processing for adva' +
        'nced text analysis","Auth":"OAuth","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/cloud.ibm.com\/apidocs\/natural-language-unde' +
        'rstanding\/natural-language-understanding","Category":"Text Anal' +
        'ysis"},{"API":"Aftership","Description":"API to update, manage a' +
        'nd track shipment efficiently","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/developers.aftership.com\/reference\/' +
        'quick-start","Category":"Tracking"},{"API":"Correios","Descripti' +
        'on":"Integration to provide information and prepare shipments us' +
        'ing Correio'#39's services","Auth":"apiKey","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/cws.correios.com.br\/ajuda","Category":"' +
        'Tracking"},{"API":"Pixela","Description":"API for recording and ' +
        'tracking habits or effort, routines","Auth":"X-Mashape-Key","HTT' +
        'PS":true,"Cors":"yes","Link":"https:\/\/pixe.la","Category":"Tra' +
        'cking"},{"API":"PostalPinCode","Description":"API for getting Pi' +
        'ncode details in India","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"http:\/\/www.postalpincode.in\/Api-Details","Category":"' +
        'Tracking"},{"API":"Postmon","Description":"An API to query Brazi' +
        'lian ZIP codes and orders easily, quickly and free","Auth":"","H' +
        'TTPS":false,"Cors":"unknown","Link":"http:\/\/postmon.com.br","C' +
        'ategory":"Tracking"},{"API":"PostNord","Description":"Provides i' +
        'nformation about parcels in transport for Sweden and Denmark","A' +
        'uth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"https:\/\/d' +
        'eveloper.postnord.com\/api","Category":"Tracking"},{"API":"UPS",' +
        '"Description":"Shipment and Address information","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.ups.com\/up' +
        'sdeveloperkit","Category":"Tracking"},{"API":"WeCanTrack","Descr' +
        'iption":"Automatically place subids in affiliate links to attrib' +
        'ute affiliate conversions to click data","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"yes","Link":"https:\/\/docs.wecantrack.com","Categ' +
        'ory":"Tracking"},{"API":"WhatPulse","Description":"Small applica' +
        'tion that measures your keyboard\/mouse usage","Auth":"","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/developer.whatpulse.org' +
        '\/#web-api","Category":"Tracking"},{"API":"ADS-B Exchange","Desc' +
        'ription":"Access real-time and historical data of any and all ai' +
        'rborne aircraft","Auth":"","HTTPS":true,"Cors":"unknown","Link":' +
        '"https:\/\/www.adsbexchange.com\/data\/","Category":"Transportat' +
        'ion"},{"API":"airportsapi","Description":"Get name and website-U' +
        'RL for airports by ICAO code","Auth":"","HTTPS":true,"Cors":"unk' +
        'nown","Link":"https:\/\/airport-web.appspot.com\/api\/docs\/","C' +
        'ategory":"Transportation"},{"API":"AIS Hub","Description":"Real-' +
        'time data of any marine and inland vessel equipped with AIS trac' +
        'king system","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Lin' +
        'k":"http:\/\/www.aishub.net\/api","Category":"Transportation"},{' +
        '"API":"Amadeus for Developers","Description":"Travel Search - Li' +
        'mited usage","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/developers.amadeus.com\/self-service","Category":"Tr' +
        'ansportation"},{"API":"apilayer aviationstack","Description":"Re' +
        'al-time Flight Status & Global Aviation Data API","Auth":"OAuth"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/aviationstack.c' +
        'om\/","Category":"Transportation"},{"API":"AviationAPI","Descrip' +
        'tion":"FAA Aeronautical Charts and Publications, Airport Informa' +
        'tion, and Airport Weather","Auth":"","HTTPS":true,"Cors":"no","L' +
        'ink":"https:\/\/docs.aviationapi.com","Category":"Transportation' +
        '"},{"API":"AZ511","Description":"Access traffic data from the AD' +
        'OT API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/www.az511.com\/developers\/doc","Category":"Transportati' +
        'on"},{"API":"Bay Area Rapid Transit","Description":"Stations and' +
        ' predicted arrivals for BART","Auth":"apiKey","HTTPS":false,"Cor' +
        's":"unknown","Link":"http:\/\/api.bart.gov","Category":"Transpor' +
        'tation"},{"API":"BC Ferries","Description":"Sailing times and ca' +
        'pacities for BC Ferries","Auth":"","HTTPS":true,"Cors":"yes","Li' +
        'nk":"https:\/\/www.bcferriesapi.ca","Category":"Transportation"}' +
        ',{"API":"BIC-Boxtech","Description":"Container technical detail ' +
        'for the global container fleet","Auth":"OAuth","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/docs.bic-boxtech.org\/","Category' +
        '":"Transportation"},{"API":"BlaBlaCar","Description":"Search car' +
        ' sharing trips","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/dev.blablacar.com","Category":"Transportation"},' +
        '{"API":"Boston MBTA Transit","Description":"Stations and predict' +
        'ed arrivals for MBTA","Auth":"apiKey","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/www.mbta.com\/developers\/v3-api","Categor' +
        'y":"Transportation"},{"API":"Community Transit","Description":"T' +
        'ransitland API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/github.com\/transitland\/transitland-datastore\/blob\/' +
        'master\/README.md#api-endpoints","Category":"Transportation"},{"' +
        'API":"Compare Flight Prices","Description":"API for comparing fl' +
        'ight prices across platforms","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/rapidapi.com\/obryan-software-obry' +
        'an-software-default\/api\/compare-flight-prices\/","Category":"T' +
        'ransportation"},{"API":"CTS","Description":"CTS Realtime API","A' +
        'uth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.ct' +
        's-strasbourg.eu\/","Category":"Transportation"},{"API":"Grab","D' +
        'escription":"Track deliveries, ride fares, payments and loyalty ' +
        'points","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/developer.grab.com\/docs\/","Category":"Transportation"},' +
        '{"API":"GraphHopper","Description":"A-to-B routing with turn-by-' +
        'turn instructions","Auth":"apiKey","HTTPS":true,"Cors":"unknown"' +
        ',"Link":"https:\/\/docs.graphhopper.com\/","Category":"Transport' +
        'ation"},{"API":"Icelandic APIs","Description":"Open APIs that de' +
        'liver services in or regarding Iceland","Auth":"","HTTPS":true,"' +
        'Cors":"unknown","Link":"http:\/\/docs.apis.is\/","Category":"Tra' +
        'nsportation"},{"API":"Impala Hotel Bookings","Description":"Hote' +
        'l content, rates and room bookings","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/docs.impala.travel\/docs\/booking' +
        '-api\/","Category":"Transportation"},{"API":"Izi","Description":' +
        '"Audio guide for travellers","Auth":"apiKey","HTTPS":true,"Cors"' +
        ':"unknown","Link":"http:\/\/api-docs.izi.travel\/","Category":"T' +
        'ransportation"},{"API":"Land Transport Authority DataMall, Singa' +
        'pore","Description":"Singapore transport information","Auth":"ap' +
        'iKey","HTTPS":false,"Cors":"unknown","Link":"https:\/\/datamall.' +
        'lta.gov.sg\/content\/dam\/datamall\/datasets\/LTA_DataMall_API_U' +
        'ser_Guide.pdf","Category":"Transportation"},{"API":"Metro Lisboa' +
        '","Description":"Delays in subway lines","Auth":"","HTTPS":false' +
        ',"Cors":"no","Link":"http:\/\/app.metrolisboa.pt\/status\/getLin' +
        'has.php","Category":"Transportation"},{"API":"Navitia","Descript' +
        'ion":"The open API for building cool stuff with transport data",' +
        '"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/' +
        'doc.navitia.io\/","Category":"Transportation"},{"API":"Open Char' +
        'ge Map","Description":"Global public registry of electric vehicl' +
        'e charging locations","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/openchargemap.org\/site\/develop\/api","Catego' +
        'ry":"Transportation"},{"API":"OpenSky Network","Description":"Fr' +
        'ee real-time ADS-B aviation data","Auth":"","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/opensky-network.org\/apidoc\/index.h' +
        'tml","Category":"Transportation"},{"API":"Railway Transport for ' +
        'France","Description":"SNCF public API","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"unknown","Link":"https:\/\/www.digital.sncf.com\/st' +
        'artup\/api","Category":"Transportation"},{"API":"REFUGE Restroom' +
        's","Description":"Provides safe restroom access for transgender,' +
        ' intersex and gender nonconforming individuals","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/www.refugerestrooms.or' +
        'g\/api\/docs\/#!\/restrooms","Category":"Transportation"},{"API"' +
        ':"Sabre for Developers","Description":"Travel Search - Limited u' +
        'sage","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/developer.sabre.com\/guides\/travel-agency\/quickstart\/ge' +
        'tting-started-in-travel","Category":"Transportation"},{"API":"Sc' +
        'hiphol Airport","Description":"Schiphol","Auth":"apiKey","HTTPS"' +
        ':true,"Cors":"unknown","Link":"https:\/\/developer.schiphol.nl\/' +
        '","Category":"Transportation"},{"API":"Tankerkoenig","Descriptio' +
        'n":"German realtime gas\/diesel prices","Auth":"apiKey","HTTPS":' +
        'true,"Cors":"yes","Link":"https:\/\/creativecommons.tankerkoenig' +
        '.de\/swagger\/","Category":"Transportation"},{"API":"TransitLand' +
        '","Description":"Transit Aggregation","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.transit.land\/documentation\' +
        '/datastore\/api-endpoints.html","Category":"Transportation"},{"A' +
        'PI":"Transport for Atlanta, US","Description":"Marta","Auth":"",' +
        '"HTTPS":false,"Cors":"unknown","Link":"http:\/\/www.itsmarta.com' +
        '\/app-developer-resources.aspx","Category":"Transportation"},{"A' +
        'PI":"Transport for Auckland, New Zealand","Description":"Aucklan' +
        'd Transport","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/dev-portal.at.govt.nz\/","Category":"Transportation"},{"A' +
        'PI":"Transport for Belgium","Description":"The iRail API is a th' +
        'ird-party API for Belgian public transport by train","Auth":"","' +
        'HTTPS":true,"Cors":"yes","Link":"https:\/\/docs.irail.be\/","Cat' +
        'egory":"Transportation"},{"API":"Transport for Berlin, Germany",' +
        '"Description":"Third-party VBB API","Auth":"","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/github.com\/derhuerst\/vbb-rest\/b' +
        'lob\/3\/docs\/index.md","Category":"Transportation"},{"API":"Tra' +
        'nsport for Bordeaux, France","Description":"Bordeaux M'#233'tropole p' +
        'ublic transport and more (France)","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/opendata.bordeaux-metropole.f' +
        'r\/explore\/","Category":"Transportation"},{"API":"Transport for' +
        ' Budapest, Hungary","Description":"Budapest public transport API' +
        '","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/bkkf' +
        'utar.docs.apiary.io","Category":"Transportation"},{"API":"Transp' +
        'ort for Chicago, US","Description":"Chicago Transit Authority (C' +
        'TA)","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http' +
        ':\/\/www.transitchicago.com\/developers\/","Category":"Transport' +
        'ation"},{"API":"Transport for Czech Republic","Description":"Cze' +
        'ch transport API","Auth":"","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/www.chaps.cz\/eng\/products\/idos-internet","Categor' +
        'y":"Transportation"},{"API":"Transport for Denver, US","Descript' +
        'ion":"RTD","Auth":"","HTTPS":false,"Cors":"unknown","Link":"http' +
        ':\/\/www.rtd-denver.com\/gtfs-developer-guide.shtml","Category":' +
        '"Transportation"},{"API":"Transport for Finland","Description":"' +
        'Finnish transport API","Auth":"","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/digitransit.fi\/en\/developers\/ ","Category":"' +
        'Transportation"},{"API":"Transport for Germany","Description":"D' +
        'eutsche Bahn (DB) API","Auth":"apiKey","HTTPS":false,"Cors":"unk' +
        'nown","Link":"http:\/\/data.deutschebahn.com\/dataset\/api-fahrp' +
        'lan","Category":"Transportation"},{"API":"Transport for Grenoble' +
        ', France","Description":"Grenoble public transport","Auth":"","H' +
        'TTPS":false,"Cors":"no","Link":"https:\/\/www.mobilites-m.fr\/pa' +
        'ges\/opendata\/OpenDataApi.html","Category":"Transportation"},{"' +
        'API":"Transport for Hessen, Germany","Description":"RMV API (Pub' +
        'lic Transport in Hessen)","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/opendata.rmv.de\/site\/start.html","Category' +
        '":"Transportation"},{"API":"Transport for Honolulu, US","Descrip' +
        'tion":"Honolulu Transportation Information","Auth":"apiKey","HTT' +
        'PS":false,"Cors":"unknown","Link":"http:\/\/hea.thebus.org\/api_' +
        'info.asp","Category":"Transportation"},{"API":"Transport for Lis' +
        'bon, Portugal","Description":"Data about buses routes, parking a' +
        'nd traffic","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/emel.city-platform.com\/opendata\/","Category":"Tran' +
        'sportation"},{"API":"Transport for London, England","Description' +
        '":"TfL API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link"' +
        ':"https:\/\/api.tfl.gov.uk","Category":"Transportation"},{"API":' +
        '"Transport for Los Angeles, US","Description":"Data about positi' +
        'ons of Metro vehicles in real time and travel their routes","Aut' +
        'h":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/developer.' +
        'metro.net\/api\/","Category":"Transportation"},{"API":"Transport' +
        ' for Manchester, England","Description":"TfGM transport network ' +
        'data","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"https:\/\' +
        '/developer.tfgm.com\/","Category":"Transportation"},{"API":"Tran' +
        'sport for Norway","Description":"Transport APIs and dataset for ' +
        'Norway","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/' +
        '\/developer.entur.org\/","Category":"Transportation"},{"API":"Tr' +
        'ansport for Ottawa, Canada","Description":"OC Transpo API","Auth' +
        '":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.o' +
        'ctranspo.com\/en\/plan-your-trip\/travel-tools\/developers","Cat' +
        'egory":"Transportation"},{"API":"Transport for Paris, France","D' +
        'escription":"RATP Open Data API","Auth":"","HTTPS":false,"Cors":' +
        '"unknown","Link":"http:\/\/data.ratp.fr\/api\/v1\/console\/datas' +
        'ets\/1.0\/search\/","Category":"Transportation"},{"API":"Transpo' +
        'rt for Philadelphia, US","Description":"SEPTA APIs","Auth":"","H' +
        'TTPS":false,"Cors":"unknown","Link":"http:\/\/www3.septa.org\/ha' +
        'ckathon\/","Category":"Transportation"},{"API":"Transport for Sa' +
        'o Paulo, Brazil","Description":"SPTrans","Auth":"OAuth","HTTPS":' +
        'false,"Cors":"unknown","Link":"http:\/\/www.sptrans.com.br\/dese' +
        'nvolvedores\/api-do-olho-vivo-guia-de-referencia\/documentacao-a' +
        'pi\/","Category":"Transportation"},{"API":"Transport for Spain",' +
        '"Description":"Public trains of Spain","Auth":"","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/data.renfe.com\/api\/1\/util\/s' +
        'nippet\/api_info.html?resource_id=a2368cff-1562-4dde-8466-9635ea' +
        '3a572a","Category":"Transportation"},{"API":"Transport for Swede' +
        'n","Description":"Public Transport consumer","Auth":"OAuth","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/www.trafiklab.se\/ap' +
        'i","Category":"Transportation"},{"API":"Transport for Switzerlan' +
        'd","Description":"Official Swiss Public Transport Open Data","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/ope' +
        'ntransportdata.swiss\/en\/","Category":"Transportation"},{"API":' +
        '"Transport for Switzerland","Description":"Swiss public transpor' +
        't API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/transport.opendata.ch\/","Category":"Transportation"},{"API":"T' +
        'ransport for The Netherlands","Description":"NS, only trains","A' +
        'uth":"apiKey","HTTPS":false,"Cors":"unknown","Link":"http:\/\/ww' +
        'w.ns.nl\/reisinformatie\/ns-api","Category":"Transportation"},{"' +
        'API":"Transport for The Netherlands","Description":"OVAPI, count' +
        'ry-wide public transport","Auth":"","HTTPS":true,"Cors":"unknown' +
        '","Link":"https:\/\/github.com\/skywave\/KV78Turbo-OVAPI\/wiki",' +
        '"Category":"Transportation"},{"API":"Transport for Toronto, Cana' +
        'da","Description":"TTC","Auth":"","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/myttc.ca\/developers","Category":"Transportati' +
        'on"},{"API":"Transport for UK","Description":"Transport API and ' +
        'dataset for UK","Auth":"apiKey","HTTPS":true,"Cors":"unknown","L' +
        'ink":"https:\/\/developer.transportapi.com","Category":"Transpor' +
        'tation"},{"API":"Transport for United States","Description":"Nex' +
        'tBus API","Auth":"","HTTPS":false,"Cors":"unknown","Link":"https' +
        ':\/\/retro.umoiq.com\/xmlFeedDocs\/NextBusXMLFeed.pdf","Category' +
        '":"Transportation"},{"API":"Transport for Vancouver, Canada","De' +
        'scription":"TransLink","Auth":"OAuth","HTTPS":true,"Cors":"unkno' +
        'wn","Link":"https:\/\/developer.translink.ca\/","Category":"Tran' +
        'sportation"},{"API":"Transport for Washington, US","Description"' +
        ':"Washington Metro transport API","Auth":"OAuth","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/developer.wmata.com\/","Categor' +
        'y":"Transportation"},{"API":"transport.rest","Description":"Comm' +
        'unity maintained, developer-friendly public transport API","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/transport.rest"' +
        ',"Category":"Transportation"},{"API":"Tripadvisor","Description"' +
        ':"Rating content for a hotel, restaurant, attraction or destinat' +
        'ion","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developer-tripadvisor.com\/home\/","Category":"Transportati' +
        'on"},{"API":"Uber","Description":"Uber ride requests and price e' +
        'stimation","Auth":"OAuth","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/developer.uber.com\/products","Category":"Transportation"}' +
        ',{"API":"Velib metropolis, Paris, France","Description":"Velib O' +
        'pen Data API","Auth":"","HTTPS":true,"Cors":"no","Link":"https:\' +
        '/\/www.velib-metropole.fr\/donnees-open-data-gbfs-du-service-vel' +
        'ib-metropole","Category":"Transportation"},{"API":"1pt","Descrip' +
        'tion":"A simple URL shortener","Auth":"","HTTPS":true,"Cors":"ye' +
        's","Link":"https:\/\/github.com\/1pt-co\/api\/blob\/main\/README' +
        '.md","Category":"URL Shorteners"},{"API":"Bitly","Description":"' +
        'URL shortener and link management","Auth":"OAuth","HTTPS":true,"' +
        'Cors":"unknown","Link":"http:\/\/dev.bitly.com\/get_started.html' +
        '","Category":"URL Shorteners"},{"API":"CleanURI","Description":"' +
        'URL shortener service","Auth":"","HTTPS":true,"Cors":"yes","Link' +
        '":"https:\/\/cleanuri.com\/docs","Category":"URL Shorteners"},{"' +
        'API":"ClickMeter","Description":"Monitor, compare and optimize y' +
        'our marketing links","Auth":"apiKey","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/support.clickmeter.com\/hc\/en-us\/categori' +
        'es\/201474986","Category":"URL Shorteners"},{"API":"Clico","Desc' +
        'ription":"URL shortener service","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/cli.com\/swagger-ui\/index.html' +
        '?configUrl=\/v3\/api-docs\/swagger-config","Category":"URL Short' +
        'eners"},{"API":"Cutt.ly","Description":"URL shortener service","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/c' +
        'utt.ly\/api-documentation\/cuttly-links-api","Category":"URL Sho' +
        'rteners"},{"API":"Drivet URL Shortener","Description":"Shorten a' +
        ' long URL easily and fast","Auth":"","HTTPS":true,"Cors":"unknow' +
        'n","Link":"https:\/\/wiki.drivet.xyz\/en\/url-shortener\/add-lin' +
        'ks","Category":"URL Shorteners"},{"API":"Free Url Shortener","De' +
        'scription":"Free URL Shortener offers a powerful API to interact' +
        ' with other sites","Auth":"","HTTPS":true,"Cors":"unknown","Link' +
        '":"https:\/\/ulvis.net\/developer.html","Category":"URL Shortene' +
        'rs"},{"API":"Git.io","Description":"Git.io URL shortener","Auth"' +
        ':"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/github.blog\' +
        '/2011-11-10-git-io-github-url-shortener\/","Category":"URL Short' +
        'eners"},{"API":"GoTiny","Description":"A lightweight URL shorten' +
        'er, focused on ease-of-use for the developer and end-user","Auth' +
        '":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/rob' +
        'vanbakel\/gotiny-api","Category":"URL Shorteners"},{"API":"Kutt"' +
        ',"Description":"Free Modern URL Shortener","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"yes","Link":"https:\/\/docs.kutt.it\/","Category' +
        '":"URL Shorteners"},{"API":"Mgnet.me","Description":"Torrent URL' +
        ' shorten API","Auth":"","HTTPS":true,"Cors":"no","Link":"http:\/' +
        '\/mgnet.me\/api.html","Category":"URL Shorteners"},{"API":"owo",' +
        '"Description":"A simple link obfuscator\/shortener","Auth":"","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/owo.vc\/api","Cate' +
        'gory":"URL Shorteners"},{"API":"Rebrandly","Description":"Custom' +
        ' URL shortener for sharing branded links","Auth":"apiKey","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/developers.rebrandly.c' +
        'om\/v1\/docs","Category":"URL Shorteners"},{"API":"Short Link","' +
        'Description":"Short URLs support so many domains","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/github.com\/FayasNou' +
        'shad\/Short-Link-API","Category":"URL Shorteners"},{"API":"Shrtc' +
        'ode","Description":"URl Shortener with multiple Domains","Auth":' +
        '"","HTTPS":true,"Cors":"yes","Link":"https:\/\/shrtco.de\/docs",' +
        '"Category":"URL Shorteners"},{"API":"Shrtlnk","Description":"Sim' +
        'ple and efficient short link creation","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"yes","Link":"https:\/\/shrtlnk.dev\/developer","Cate' +
        'gory":"URL Shorteners"},{"API":"TinyURL","Description":"Shorten ' +
        'long URLs","Auth":"apiKey","HTTPS":true,"Cors":"no","Link":"http' +
        's:\/\/tinyurl.com\/app\/dev","Category":"URL Shorteners"},{"API"' +
        ':"UrlBae","Description":"Simple and efficient short link creatio' +
        'n","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/u' +
        'rlbae.com\/developers","Category":"URL Shorteners"},{"API":"Braz' +
        'ilian Vehicles and Prices","Description":"Vehicles information f' +
        'rom Funda'#231#227'o Instituto de Pesquisas Econ'#244'micas - Fipe","Auth":""' +
        ',"HTTPS":true,"Cors":"no","Link":"https:\/\/deividfortuna.github' +
        '.io\/fipe\/","Category":"Vehicle"},{"API":"Helipaddy sites","Des' +
        'cription":"Helicopter and passenger drone landing site directory' +
        ', Helipaddy data and much more","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/helipaddy.com\/api\/","Category"' +
        ':"Vehicle"},{"API":"Kelley Blue Book","Description":"Vehicle inf' +
        'o, pricing, configuration, plus much more","Auth":"apiKey","HTTP' +
        'S":true,"Cors":"no","Link":"http:\/\/developer.kbb.com\/#!\/data' +
        '\/1-Default","Category":"Vehicle"},{"API":"Mercedes-Benz","Descr' +
        'iption":"Telematics data, remotely access vehicle functions, car' +
        ' configurator, locate service dealers","Auth":"apiKey","HTTPS":t' +
        'rue,"Cors":"no","Link":"https:\/\/developer.mercedes-benz.com\/a' +
        'pis","Category":"Vehicle"},{"API":"NHTSA","Description":"NHTSA P' +
        'roduct Information Catalog and Vehicle Listing","Auth":"","HTTPS' +
        '":true,"Cors":"unknown","Link":"https:\/\/vpic.nhtsa.dot.gov\/ap' +
        'i\/","Category":"Vehicle"},{"API":"Smartcar","Description":"Lock' +
        ' and unlock vehicles and get data like odometer reading and loca' +
        'tion. Works on most new cars","Auth":"OAuth","HTTPS":true,"Cors"' +
        ':"yes","Link":"https:\/\/smartcar.com\/docs\/","Category":"Vehic' +
        'le"},{"API":"An API of Ice And Fire","Description":"Game Of Thro' +
        'nes API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\' +
        '/\/anapioficeandfire.com\/","Category":"Video"},{"API":"Bob'#39's Bu' +
        'rgers","Description":"Bob'#39's Burgers API","Auth":"","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/bobs-burgers-api-ui.herokuapp.com' +
        '","Category":"Video"},{"API":"Breaking Bad","Description":"Break' +
        'ing Bad API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"htt' +
        'ps:\/\/breakingbadapi.com\/documentation","Category":"Video"},{"' +
        'API":"Breaking Bad Quotes","Description":"Some Breaking Bad quot' +
        'es","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/gi' +
        'thub.com\/shevabam\/breaking-bad-quotes","Category":"Video"},{"A' +
        'PI":"Catalogopolis","Description":"Doctor Who API","Auth":"","HT' +
        'TPS":true,"Cors":"unknown","Link":"https:\/\/api.catalogopolis.x' +
        'yz\/docs\/","Category":"Video"},{"API":"Catch The Show","Descrip' +
        'tion":"REST API for next-episode.net","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/catchtheshow.herokuapp.com\/api\' +
        '/documentation","Category":"Video"},{"API":"Czech Television","D' +
        'escription":"TV programme of Czech TV","Auth":"","HTTPS":false,"' +
        'Cors":"unknown","Link":"http:\/\/www.ceskatelevize.cz\/xml\/tv-p' +
        'rogram\/","Category":"Video"},{"API":"Dailymotion","Description"' +
        ':"Dailymotion Developer API","Auth":"OAuth","HTTPS":true,"Cors":' +
        '"unknown","Link":"https:\/\/developer.dailymotion.com\/","Catego' +
        'ry":"Video"},{"API":"Dune","Description":"A simple API which pro' +
        'vides you with book, character, movie and quotes JSON data","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/yw' +
        'alia01\/dune-api","Category":"Video"},{"API":"Final Space","Desc' +
        'ription":"Final Space API","Auth":"","HTTPS":true,"Cors":"yes","' +
        'Link":"https:\/\/finalspaceapi.com\/docs\/","Category":"Video"},' +
        '{"API":"Game of Thrones Quotes","Description":"Some Game of Thro' +
        'nes quotes","Auth":"","HTTPS":true,"Cors":"unknown","Link":"http' +
        's:\/\/gameofthronesquotes.xyz\/","Category":"Video"},{"API":"Har' +
        'ry Potter Charactes","Description":"Harry Potter Characters Data' +
        ' with with imagery","Auth":"","HTTPS":true,"Cors":"unknown","Lin' +
        'k":"https:\/\/hp-api.herokuapp.com\/","Category":"Video"},{"API"' +
        ':"IMDb-API","Description":"API for receiving movie, serial and c' +
        'ast information","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/imdb-api.com\/","Category":"Video"},{"API":"IMD' +
        'bOT","Description":"Unofficial IMDb Movie \/ Series Information"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.co' +
        'm\/SpEcHiDe\/IMDbOT","Category":"Video"},{"API":"JSON2Video","De' +
        'scription":"Create and edit videos programmatically: watermarks,' +
        'resizing,slideshows,voice-over,text animations","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"no","Link":"https:\/\/json2video.com","Cate' +
        'gory":"Video"},{"API":"Lucifer Quotes","Description":"Returns Lu' +
        'cifer quotes","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/github.com\/shadowoff09\/lucifer-quotes","Category":"Vid' +
        'eo"},{"API":"MCU Countdown","Description":"A Countdown to the ne' +
        'xt MCU Film","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\' +
        '/\/github.com\/DiljotSG\/MCU-Countdown","Category":"Video"},{"AP' +
        'I":"Motivational Quotes","Description":"Random Motivational Quot' +
        'es","Auth":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/no' +
        'dejs-quoteapp.herokuapp.com\/","Category":"Video"},{"API":"Movie' +
        ' Quote","Description":"Random Movie and Series Quotes","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/F4R4N\/' +
        'movie-quote\/","Category":"Video"},{"API":"Open Movie Database",' +
        '"Description":"Movie information","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"unknown","Link":"http:\/\/www.omdbapi.com\/","Category":"' +
        'Video"},{"API":"Owen Wilson Wow","Description":"API for actor Ow' +
        'en Wilson'#39's \"wow\" exclamations in movies","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/owen-wilson-wow-api.herokuapp.' +
        'com","Category":"Video"},{"API":"Ron Swanson Quotes","Descriptio' +
        'n":"Television","Auth":"","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/github.com\/jamesseanwright\/ron-swanson-quotes#ron-sw' +
        'anson-quotes-api","Category":"Video"},{"API":"Simkl","Descriptio' +
        'n":"Movie, TV and Anime data","Auth":"apiKey","HTTPS":true,"Cors' +
        '":"unknown","Link":"https:\/\/simkl.docs.apiary.io","Category":"' +
        'Video"},{"API":"STAPI","Description":"Information on all things ' +
        'Star Trek","Auth":"","HTTPS":false,"Cors":"no","Link":"http:\/\/' +
        'stapi.co","Category":"Video"},{"API":"Stranger Things Quotes","D' +
        'escription":"Returns Stranger Things quotes","Auth":"","HTTPS":t' +
        'rue,"Cors":"unknown","Link":"https:\/\/github.com\/shadowoff09\/' +
        'strangerthings-quotes","Category":"Video"},{"API":"Stream","Desc' +
        'ription":"Czech internet television, films, series and online vi' +
        'deos for free","Auth":"","HTTPS":true,"Cors":"no","Link":"https:' +
        '\/\/api.stream.cz\/graphiql","Category":"Video"},{"API":"Strombe' +
        'rg Quotes","Description":"Returns Stromberg quotes and more","Au' +
        'th":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.strom' +
        'berg-api.de\/","Category":"Video"},{"API":"SWAPI","Description":' +
        '"All the Star Wars data you'#39've ever wanted","Auth":"","HTTPS":tr' +
        'ue,"Cors":"yes","Link":"https:\/\/swapi.dev\/","Category":"Video' +
        '"},{"API":"SWAPI","Description":"All things Star Wars","Auth":""' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/www.swapi.tech","Ca' +
        'tegory":"Video"},{"API":"SWAPI GraphQL","Description":"Star Wars' +
        ' GraphQL API","Auth":"","HTTPS":true,"Cors":"unknown","Link":"ht' +
        'tps:\/\/graphql.org\/swapi-graphql","Category":"Video"},{"API":"' +
        'The Lord of the Rings","Description":"The Lord of the Rings API"' +
        ',"Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\' +
        '/the-one-api.dev\/","Category":"Video"},{"API":"The Vampire Diar' +
        'ies","Description":"TV Show Data","Auth":"apiKey","HTTPS":true,"' +
        'Cors":"yes","Link":"https:\/\/vampire-diaries-api.netlify.app\/"' +
        ',"Category":"Video"},{"API":"ThronesApi","Description":"Game Of ' +
        'Thrones Characters Data with imagery","Auth":"","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/thronesapi.com\/","Category":"Vi' +
        'deo"},{"API":"TMDb","Description":"Community-based movie data","' +
        'Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/w' +
        'ww.themoviedb.org\/documentation\/api","Category":"Video"},{"API' +
        '":"TrailerAddict","Description":"Easily embed trailers from Trai' +
        'lerAddict","Auth":"apiKey","HTTPS":false,"Cors":"unknown","Link"' +
        ':"https:\/\/www.traileraddict.com\/trailerapi","Category":"Video' +
        '"},{"API":"Trakt","Description":"Movie and TV Data","Auth":"apiK' +
        'ey","HTTPS":true,"Cors":"yes","Link":"https:\/\/trakt.docs.apiar' +
        'y.io\/","Category":"Video"},{"API":"TVDB","Description":"Televis' +
        'ion data","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Link":"' +
        'https:\/\/thetvdb.com\/api-information","Category":"Video"},{"AP' +
        'I":"TVMaze","Description":"TV Show Data","Auth":"","HTTPS":false' +
        ',"Cors":"unknown","Link":"http:\/\/www.tvmaze.com\/api","Categor' +
        'y":"Video"},{"API":"uNoGS","Description":"Unofficial Netflix Onl' +
        'ine Global Search, Search all netflix regions in one place","Aut' +
        'h":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/rapidapi' +
        '.com\/unogs\/api\/unogsng","Category":"Video"},{"API":"Vimeo","D' +
        'escription":"Vimeo Developer API","Auth":"OAuth","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/developer.vimeo.com\/","Categor' +
        'y":"Video"},{"API":"Watchmode","Description":"API for finding ou' +
        't the streaming availability of movies & shows","Auth":"apiKey",' +
        '"HTTPS":true,"Cors":"unknown","Link":"https:\/\/api.watchmode.co' +
        'm\/","Category":"Video"},{"API":"Web Series Quotes Generator","D' +
        'escription":"API generates various Web Series Quote Images","Aut' +
        'h":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/github.com\/yo' +
        'geshwaran01\/web-series-quotes","Category":"Video"},{"API":"YouT' +
        'ube","Description":"Add YouTube functionality to your sites and ' +
        'apps","Auth":"OAuth","HTTPS":true,"Cors":"unknown","Link":"https' +
        ':\/\/developers.google.com\/youtube\/","Category":"Video"},{"API' +
        '":"7Timer!","Description":"Weather, especially for Astroweather"' +
        ',"Auth":"","HTTPS":false,"Cors":"unknown","Link":"http:\/\/www.7' +
        'timer.info\/doc.php?lang=en","Category":"Weather"},{"API":"AccuW' +
        'eather","Description":"Weather and forecast data","Auth":"apiKey' +
        '","HTTPS":false,"Cors":"unknown","Link":"https:\/\/developer.acc' +
        'uweather.com\/apis","Category":"Weather"},{"API":"Aemet","Descri' +
        'ption":"Weather and forecast data from Spain","Auth":"apiKey","H' +
        'TTPS":true,"Cors":"unknown","Link":"https:\/\/opendata.aemet.es\' +
        '/centrodedescargas\/inicio","Category":"Weather"},{"API":"apilay' +
        'er weatherstack","Description":"Real-Time & Historical World Wea' +
        'ther Data API","Auth":"apiKey","HTTPS":true,"Cors":"unknown","Li' +
        'nk":"https:\/\/weatherstack.com\/","Category":"Weather"},{"API":' +
        '"APIXU","Description":"Weather","Auth":"apiKey","HTTPS":true,"Co' +
        'rs":"unknown","Link":"https:\/\/www.apixu.com\/doc\/request.aspx' +
        '","Category":"Weather"},{"API":"AQICN","Description":"Air Qualit' +
        'y Index Data for over 1000 cities","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"unknown","Link":"https:\/\/aqicn.org\/api\/","Category":' +
        '"Weather"},{"API":"AviationWeather","Description":"NOAA aviation' +
        ' weather forecasts and observations","Auth":"","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/www.aviationweather.gov\/dataserv' +
        'er","Category":"Weather"},{"API":"ColorfulClouds","Description":' +
        '"Weather","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"http' +
        's:\/\/open.caiyunapp.com\/ColorfulClouds_Weather_API","Category"' +
        ':"Weather"},{"API":"Euskalmet","Description":"Meteorological dat' +
        'a of the Basque Country","Auth":"apiKey","HTTPS":true,"Cors":"un' +
        'known","Link":"https:\/\/opendata.euskadi.eus\/api-euskalmet\/-\' +
        '/api-de-euskalmet\/","Category":"Weather"},{"API":"Foreca","Desc' +
        'ription":"Weather","Auth":"OAuth","HTTPS":true,"Cors":"unknown",' +
        '"Link":"https:\/\/developer.foreca.com","Category":"Weather"},{"' +
        'API":"HG Weather","Description":"Provides weather forecast data ' +
        'for cities in Brazil","Auth":"apiKey","HTTPS":true,"Cors":"yes",' +
        '"Link":"https:\/\/hgbrasil.com\/status\/weather","Category":"Wea' +
        'ther"},{"API":"Hong Kong Obervatory","Description":"Provide weat' +
        'her information, earthquake information, and climate data","Auth' +
        '":"","HTTPS":true,"Cors":"unknown","Link":"https:\/\/www.hko.gov' +
        '.hk\/en\/abouthko\/opendata_intro.htm","Category":"Weather"},{"A' +
        'PI":"MetaWeather","Description":"Weather","Auth":"","HTTPS":true' +
        ',"Cors":"no","Link":"https:\/\/www.metaweather.com\/api\/","Cate' +
        'gory":"Weather"},{"API":"Meteorologisk Institutt","Description":' +
        '"Weather and climate data","Auth":"User-Agent","HTTPS":true,"Cor' +
        's":"unknown","Link":"https:\/\/api.met.no\/weatherapi\/documenta' +
        'tion","Category":"Weather"},{"API":"Micro Weather","Description"' +
        ':"Real time weather forecasts and historic data","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"unknown","Link":"https:\/\/m3o.com\/weathe' +
        'r\/api","Category":"Weather"},{"API":"ODWeather","Description":"' +
        'Weather and weather webcams","Auth":"","HTTPS":false,"Cors":"unk' +
        'nown","Link":"http:\/\/api.oceandrivers.com\/static\/docs.html",' +
        '"Category":"Weather"},{"API":"Oikolab","Description":"70+ years ' +
        'of global, hourly historical and forecast weather data from NOAA' +
        ' and ECMWF","Auth":"apiKey","HTTPS":true,"Cors":"yes","Link":"ht' +
        'tps:\/\/docs.oikolab.com","Category":"Weather"},{"API":"Open-Met' +
        'eo","Description":"Global weather forecast API for non-commercia' +
        'l use","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/ope' +
        'n-meteo.com\/","Category":"Weather"},{"API":"openSenseMap","Desc' +
        'ription":"Data from Personal Weather Stations called senseBoxes"' +
        ',"Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/\/api.opens' +
        'ensemap.org\/","Category":"Weather"},{"API":"OpenUV","Descriptio' +
        'n":"Real-time UV Index Forecast","Auth":"apiKey","HTTPS":true,"C' +
        'ors":"unknown","Link":"https:\/\/www.openuv.io","Category":"Weat' +
        'her"},{"API":"OpenWeatherMap","Description":"Weather","Auth":"ap' +
        'iKey","HTTPS":true,"Cors":"unknown","Link":"https:\/\/openweathe' +
        'rmap.org\/api","Category":"Weather"},{"API":"QWeather","Descript' +
        'ion":"Location-based weather data","Auth":"apiKey","HTTPS":true,' +
        '"Cors":"yes","Link":"https:\/\/dev.qweather.com\/en\/","Category' +
        '":"Weather"},{"API":"RainViewer","Description":"Radar data colle' +
        'cted from different websites across the Internet","Auth":"","HTT' +
        'PS":true,"Cors":"unknown","Link":"https:\/\/www.rainviewer.com\/' +
        'api.html","Category":"Weather"},{"API":"Storm Glass","Descriptio' +
        'n":"Global marine weather from multiple sources","Auth":"apiKey"' +
        ',"HTTPS":true,"Cors":"yes","Link":"https:\/\/stormglass.io\/","C' +
        'ategory":"Weather"},{"API":"Tomorrow","Description":"Weather API' +
        ' Powered by Proprietary Technology","Auth":"apiKey","HTTPS":true' +
        ',"Cors":"unknown","Link":"https:\/\/docs.tomorrow.io","Category"' +
        ':"Weather"},{"API":"US Weather","Description":"US National Weath' +
        'er Service","Auth":"","HTTPS":true,"Cors":"yes","Link":"https:\/' +
        '\/www.weather.gov\/documentation\/services-web-api","Category":"' +
        'Weather"},{"API":"Visual Crossing","Description":"Global histori' +
        'cal and weather forecast data","Auth":"apiKey","HTTPS":true,"Cor' +
        's":"yes","Link":"https:\/\/www.visualcrossing.com\/weather-api",' +
        '"Category":"Weather"},{"API":"weather-api","Description":"A REST' +
        'ful free API to check the weather","Auth":"","HTTPS":true,"Cors"' +
        ':"no","Link":"https:\/\/github.com\/robertoduessmann\/weather-ap' +
        'i","Category":"Weather"},{"API":"WeatherAPI","Description":"Weat' +
        'her API with other stuff like Astronomy and Geolocation API","Au' +
        'th":"apiKey","HTTPS":true,"Cors":"yes","Link":"https:\/\/www.wea' +
        'therapi.com\/","Category":"Weather"},{"API":"Weatherbit","Descri' +
        'ption":"Weather","Auth":"apiKey","HTTPS":true,"Cors":"unknown","' +
        'Link":"https:\/\/www.weatherbit.io\/api","Category":"Weather"},{' +
        '"API":"Yandex.Weather","Description":"Assesses weather condition' +
        ' in specific locations","Auth":"apiKey","HTTPS":true,"Cors":"no"' +
        ',"Link":"https:\/\/yandex.com\/dev\/weather\/","Category":"Weath' +
        'er"}]}')
    Left = 536
    Top = 296
  end
end
