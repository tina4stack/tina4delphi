object frmDataModule: TfrmDataModule
  Height = 662
  Width = 988
  PixelsPerInch = 120
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 220
    Top = 100
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=..\Car_Database.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 450
    Top = 250
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 320
    Top = 250
  end
  object Tina4REST1: TTina4REST
    BaseUrl = 'https://api.publicapis.org'
    Left = 480
    Top = 429
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    DataKey = 'entries'
    EndPoint = 'entries'
    MemTable = FDMemTable2
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
    OnExecuteDone = Tina4RESTRequest1ExecuteDone
    Left = 596
    Top = 430
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
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 600
    Top = 90
    Content = {
      4144425310000000E8AF0300FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C0065003100050016000000460044004D0065006D
      005400610062006C0065003100060000000000070000080032000000090000FF
      0AFF0B0400060000004100500049000500060000004100500049000C00010000
      000E000D000F00E8030000100001110001120001130001140001150001160006
      0000004100500049001700E8030000FEFF0B0400160000004400650073006300
      720069007000740069006F006E00050016000000440065007300630072006900
      7000740069006F006E000C00020000000E000D000F00E8030000100001110001
      1200011300011400011500011600160000004400650073006300720069007000
      740069006F006E001700E8030000FEFF0B040008000000410075007400680005
      000800000041007500740068000C00030000000E000D000F00E8030000100001
      11000112000113000114000115000116000800000041007500740068001700E8
      030000FEFF0B04000A0000004800540054005000530005000A00000048005400
      5400500053000C00040000000E000D000F00E803000010000111000112000113
      000114000115000116000A000000480054005400500053001700E8030000FEFF
      0B04000800000043006F007200730005000800000043006F00720073000C0005
      0000000E000D000F00E803000010000111000112000113000114000115000116
      000800000043006F00720073001700E8030000FEFF0B0400080000004C006900
      6E006B000500080000004C0069006E006B000C00060000000E000D000F00E803
      00001000011100011200011300011400011500011600080000004C0069006E00
      6B001700E8030000FEFF0B040010000000430061007400650067006F00720079
      00050010000000430061007400650067006F00720079000C00070000000E000D
      000F00E803000010000111000112000113000114000115000116001000000043
      0061007400650067006F00720079001700E8030000FEFEFF18FEFF19FEFF1AFF
      1B1C0000000000FF1D00000900000041646F7074415065740100210000005265
      736F7572636520746F2068656C702067657420706574732061646F7074656402
      00060000006170694B6579030004000000747275650400030000007965730500
      3300000068747470733A2F2F7777772E61646F7074617065742E636F6D2F7075
      626C69632F617069732F7065745F6C6973742E68746D6C060007000000416E69
      6D616C73FEFEFF1B1C0001000000FF1D00000700000041786F6C6F746C010028
      000000436F6C6C656374696F6E206F662061786F6C6F746C2070696374757265
      7320616E64206661637473020000000000030004000000747275650400020000
      006E6F05002200000068747470733A2F2F74686561786F6C6F746C6170692E6E
      65746C6966792E6170702F060007000000416E696D616C73FEFEFF1B1C000200
      0000FF1D00000900000043617420466163747301000F0000004461696C792063
      6174206661637473020000000000030004000000747275650400020000006E6F
      05002A00000068747470733A2F2F616C6578776F686C627275636B2E67697468
      75622E696F2F6361742D66616374732F060007000000416E696D616C73FEFEFF
      1B1C0003000000FF1D0000060000004361746161730100290000004361742061
      732061207365727669636520286361747320706963747572657320616E642067
      69667329020000000000030004000000747275650400020000006E6F05001300
      000068747470733A2F2F6361746161732E636F6D2F060007000000416E696D61
      6C73FEFEFF1B1C0004000000FF1D0000040000004361747301001C0000005069
      637475726573206F6620636174732066726F6D2054756D626C72020006000000
      6170694B6579030004000000747275650400020000006E6F05001B0000006874
      7470733A2F2F646F63732E7468656361746170692E636F6D2F06000700000041
      6E696D616C73FEFEFF1B1C0005000000FF1D000009000000446F672046616374
      7301001000000052616E646F6D20646F67206661637473020000000000030004
      0000007472756504000300000079657305002800000068747470733A2F2F6475
      6B656E676E2E6769746875622E696F2F446F672D66616374732D4150492F0600
      07000000416E696D616C73FEFEFF1B1C0006000000FF1D000009000000446F67
      20466163747301001400000052616E646F6D206661637473206F6620446F6773
      0200000000000300040000007472756504000300000079657305002200000068
      747470733A2F2F6B696E647566662E6769746875622E696F2F646F672D617069
      2F060007000000416E696D616C73FEFEFF1B1C0007000000FF1D000004000000
      446F67730100220000004261736564206F6E20746865205374616E666F726420
      446F677320446174617365740200000000000300040000007472756504000300
      000079657305001800000068747470733A2F2F646F672E63656F2F646F672D61
      70692F060007000000416E696D616C73FEFEFF1B1C0008000000FF1D00000500
      0000654269726401003F000000526574726965766520726563656E74206F7220
      6E6F7461626C652062697264696E67206F62736572766174696F6E7320776974
      68696E206120726567696F6E0200060000006170694B65790300040000007472
      75650400020000006E6F05003600000068747470733A2F2F646F63756D656E74
      65722E676574706F73746D616E2E636F6D2F766965772F3636343330322F5331
      454E77793539060007000000416E696D616C73FEFEFF1B1C0009000000FF1D00
      0009000000466973685761746368010036000000496E666F726D6174696F6E20
      616E642070696374757265732061626F757420696E646976696475616C206669
      7368207370656369657302000000000003000400000074727565040003000000
      79657305002400000068747470733A2F2F7777772E6669736877617463682E67
      6F762F646576656C6F70657273060007000000416E696D616C73FEFEFF1B1C00
      0A000000FF1D000008000000485454502043617401001900000043617420666F
      7220657665727920485454502053746174757302000000000003000400000074
      72756504000300000079657305001100000068747470733A2F2F687474702E63
      61742F060007000000416E696D616C73FEFEFF1B1C000B000000FF1D00000800
      00004854545020446F67010028000000446F677320666F722065766572792048
      54545020726573706F6E73652073746174757320636F64650200000000000300
      040000007472756504000300000079657305001100000068747470733A2F2F68
      7474702E646F672F060007000000416E696D616C73FEFEFF1B1C000C000000FF
      1D0000040000004955434E0100230000004955434E20526564204C697374206F
      6620546872656174656E656420537065636965730200060000006170694B6579
      03000500000066616C73650400020000006E6F050028000000687474703A2F2F
      61706976332E6975636E7265646C6973742E6F72672F6170692F76332F646F63
      73060007000000416E696D616C73FEFEFF1B1C000D000000FF1D000009000000
      4D656F7746616374730100140000004765742072616E646F6D20636174206661
      637473020000000000030004000000747275650400020000006E6F05002A0000
      0068747470733A2F2F6769746875622E636F6D2F77682D697465726162622D69
      742F6D656F776661637473060007000000416E696D616C73FEFEFF1B1C000E00
      0000FF1D0000080000004D6F766562616E6B0100260000004D6F76656D656E74
      20616E64204D6967726174696F6E2064617461206F6620616E696D616C730200
      000000000300040000007472756504000300000079657305002C000000687474
      70733A2F2F6769746875622E636F6D2F6D6F766562616E6B2F6D6F766562616E
      6B2D6170692D646F63060007000000416E696D616C73FEFEFF1B1C000F000000
      FF1D00000900000050657466696E64657201005700000050657466696E646572
      2069732064656469636174656420746F2068656C70696E672070657473206669
      6E6420686F6D65732C20616E6F74686572207265736F7572636520746F206765
      7420706574732061646F707465640200060000006170694B6579030004000000
      7472756504000300000079657305002500000068747470733A2F2F7777772E70
      657466696E6465722E636F6D2F646576656C6F706572732F060007000000416E
      696D616C73FEFEFF1B1C0010000000FF1D000009000000506C61636542656172
      010019000000506C616365686F6C646572206265617220706963747572657302
      0000000000030004000000747275650400030000007965730500160000006874
      7470733A2F2F706C616365626561722E636F6D2F060007000000416E696D616C
      73FEFEFF1B1C0011000000FF1D000008000000506C616365446F670100180000
      00506C616365686F6C64657220446F6720706963747572657302000000000003
      00040000007472756504000300000079657305001100000068747470733A2F2F
      706C6163652E646F67060007000000416E696D616C73FEFEFF1B1C0012000000
      FF1D00000B000000506C6163654B697474656E01001B000000506C616365686F
      6C646572204B697474656E207069637475726573020000000000030004000000
      7472756504000300000079657305001800000068747470733A2F2F706C616365
      6B697474656E2E636F6D2F060007000000416E696D616C73FEFEFF1B1C001300
      0000FF1D00000900000052616E646F6D446F6701001700000052616E646F6D20
      7069637475726573206F6620646F677302000000000003000400000074727565
      04000300000079657305001C00000068747470733A2F2F72616E646F6D2E646F
      672F776F6F662E6A736F6E060007000000416E696D616C73FEFEFF1B1C001400
      0000FF1D00000A00000052616E646F6D4475636B01001800000052616E646F6D
      207069637475726573206F66206475636B730200000000000300040000007472
      75650400020000006E6F05001700000068747470733A2F2F72616E646F6D2D64
      2E756B2F617069060007000000416E696D616C73FEFEFF1B1C0015000000FF1D
      00000900000052616E646F6D466F7801001800000052616E646F6D2070696374
      75726573206F6620666F78657302000000000003000400000074727565040002
      0000006E6F05001B00000068747470733A2F2F72616E646F6D666F782E63612F
      666C6F6F662F060007000000416E696D616C73FEFEFF1B1C0016000000FF1D00
      000C00000052657363756547726F75707301000800000041646F7074696F6E02
      000000000003000400000074727565040007000000756E6B6E6F776E05004A00
      000068747470733A2F2F7573657267756964652E72657363756567726F757073
      2E6F72672F646973706C61792F41504944472F4150492B446576656C6F706572
      732B47756964652B486F6D65060007000000416E696D616C73FEFEFF1B1C0017
      000000FF1D00000C00000053686962652E4F6E6C696E6501002B00000052616E
      646F6D207069637475726573206F6620536869626120496E752C206361747320
      6F72206269726473020000000000030004000000747275650400030000007965
      73050014000000687474703A2F2F73686962652E6F6E6C696E652F0600070000
      00416E696D616C73FEFEFF1B1C0018000000FF1D00000700000054686520446F
      6701005F00000041207075626C6963207365727669636520616C6C2061626F75
      7420446F67732C206672656520746F20757365207768656E206D616B696E6720
      796F75722066616E6379206E6577204170702C2057656273697465206F722053
      6572766963650200060000006170694B65790300040000007472756504000200
      00006E6F05001600000068747470733A2F2F746865646F676170692E636F6D2F
      060007000000416E696D616C73FEFEFF1B1C0019000000FF1D00000A00000078
      656E6F2D63616E746F01000F00000042697264207265636F7264696E67730200
      0000000003000400000074727565040007000000756E6B6E6F776E0500220000
      0068747470733A2F2F78656E6F2D63616E746F2E6F72672F6578706C6F72652F
      617069060007000000416E696D616C73FEFEFF1B1C001A000000FF1D00000B00
      00005A6F6F20416E696D616C73010021000000466163747320616E6420706963
      7475726573206F66207A6F6F20616E696D616C73020000000000030004000000
      7472756504000300000079657305002500000068747470733A2F2F7A6F6F2D61
      6E696D616C2D6170692E6865726F6B756170702E636F6D2F060007000000416E
      696D616C73FEFEFF1B1C001B000000FF1D000006000000416E69415049010032
      000000416E696D6520646973636F766572792C2073747265616D696E67202620
      73796E63696E67207769746820747261636B6572730200050000004F41757468
      0300040000007472756504000300000079657305001800000068747470733A2F
      2F616E696170692E636F6D2F646F63732F060005000000416E696D65FEFEFF1B
      1C001C000000FF1D000005000000416E69444201000E000000416E696D652044
      617461626173650200060000006170694B657903000500000066616C73650400
      07000000756E6B6E6F776E05002A00000068747470733A2F2F77696B692E616E
      6964622E6E65742F485454505F4150495F446566696E6974696F6E0600050000
      00416E696D65FEFEFF1B1C001D000000FF1D000007000000416E694C69737401
      001A000000416E696D6520646973636F76657279202620747261636B696E6702
      00050000004F4175746803000400000074727565040007000000756E6B6E6F77
      6E05002D00000068747470733A2F2F6769746875622E636F6D2F416E694C6973
      742F41706956322D4772617068514C2D446F6373060005000000416E696D65FE
      FEFF1B1C001E000000FF1D000009000000416E696D654368616E010018000000
      416E696D652071756F74657320286F7665722031306B2B290200000000000300
      04000000747275650400020000006E6F05002B00000068747470733A2F2F6769
      746875622E636F6D2F526F636B74696D5361696B69612F616E696D652D636861
      6E060005000000416E696D65FEFEFF1B1C001F000000FF1D00000A000000416E
      696D654661637473010017000000416E696D6520466163747320286F76657220
      3130302B29020000000000030004000000747275650400030000007965730500
      3200000068747470733A2F2F6368616E64616E2D30322E6769746875622E696F
      2F616E696D652D66616374732D726573742D6170692F060005000000416E696D
      65FEFEFF1B1C0020000000FF1D000010000000416E696D654E6577734E657477
      6F726B010013000000416E696D6520696E647573747279206E65777302000000
      0000030004000000747275650400030000007965730500350000006874747073
      3A2F2F7777772E616E696D656E6577736E6574776F726B2E636F6D2F656E6379
      636C6F70656469612F6170692E706870060005000000416E696D65FEFEFF1B1C
      0021000000FF1D000006000000436174626F7901001E0000004E656B6F20696D
      616765732C2066756E6E7920474946732026206D6F7265020000000000030004
      0000007472756504000300000079657305001700000068747470733A2F2F6361
      74626F79732E636F6D2F617069060005000000416E696D65FEFEFF1B1C002200
      0000FF1D00000E00000044616E626F6F727520416E696D650100390000005468
      6F7573616E6473206F6620616E696D6520617274697374206461746162617365
      20746F2066696E6420676F6F6420616E696D6520617274020006000000617069
      4B65790300040000007472756504000300000079657305002E00000068747470
      733A2F2F64616E626F6F72752E646F6E6D61692E75732F77696B695F70616765
      732F68656C703A617069060005000000416E696D65FEFEFF1B1C0023000000FF
      1D0000050000004A696B616E01001A000000556E6F6666696369616C204D7941
      6E696D654C697374204150490200000000000300040000007472756504000300
      000079657305001100000068747470733A2F2F6A696B616E2E6D6F6506000500
      0000416E696D65FEFEFF1B1C0024000000FF1D0000050000004B697473750100
      18000000416E696D6520646973636F7665727920706C6174666F726D02000500
      00004F417574680300040000007472756504000300000079657305001D000000
      68747470733A2F2F6B697473752E646F63732E6170696172792E696F2F060005
      000000416E696D65FEFEFF1B1C0025000000FF1D0000080000004D616E676144
      657801001C0000004D616E676120446174616261736520616E6420436F6D6D75
      6E6974790200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05002200000068747470733A2F2F6170692E6D616E67616465
      782E6F72672F646F63732E68746D6C060005000000416E696D65FEFEFF1B1C00
      26000000FF1D0000070000004D616E676170690100320000005472616E736C61
      7465206D616E67612070616765732066726F6D206F6E65206C616E6775616765
      20746F20616E6F746865720200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05003A00000068747470733A2F2F72617069
      646170692E636F6D2F7069657272652E63617263656C6C65726D65756E696572
      2F6170692F6D616E67617069332F060005000000416E696D65FEFEFF1B1C0027
      000000FF1D00000B0000004D79416E696D654C697374010026000000416E696D
      6520616E64204D616E676120446174616261736520616E6420436F6D6D756E69
      74790200050000004F4175746803000400000074727565040007000000756E6B
      6E6F776E05002B00000068747470733A2F2F6D79616E696D656C6973742E6E65
      742F636C7562732E7068703F6369643D3133373237060005000000416E696D65
      FEFEFF1B1C0028000000FF1D0000090000004E656B6F73426573740100240000
      004E656B6F20496D61676573202620416E696D6520726F6C65706C6179696E67
      2047494673020000000000030004000000747275650400030000007965730500
      1700000068747470733A2F2F646F63732E6E656B6F732E626573740600050000
      00416E696D65FEFEFF1B1C0029000000FF1D0000090000005368696B696D6F72
      69010027000000416E696D6520646973636F766572792C20747261636B696E67
      2C20666F72756D2C2072617465730200050000004F4175746803000400000074
      727565040007000000756E6B6E6F776E05001D00000068747470733A2F2F7368
      696B696D6F72692E6F6E652F6170692F646F63060005000000416E696D65FEFE
      FF1B1C002A000000FF1D00000D00000053747564696F20476869626C69010022
      0000005265736F75726365732066726F6D2053747564696F20476869626C6920
      66696C6D73020000000000030004000000747275650400030000007965730500
      1F00000068747470733A2F2F676869626C696170692E6865726F6B756170702E
      636F6D060005000000416E696D65FEFEFF1B1C002B000000FF1D000009000000
      5472616365204D6F65010042000000412075736566756C20746F6F6C20746F20
      67657420746865206578616374207363656E65206F6620616E20616E696D6520
      66726F6D20612073637265656E73686F74020000000000030004000000747275
      650400020000006E6F05002900000068747470733A2F2F736F72756C792E6769
      746875622E696F2F74726163652E6D6F652D6170692F232F060005000000416E
      696D65FEFEFF1B1C002C000000FF1D00000800000057616966752E696D010048
      0000004765742077616966752070696374757265732066726F6D20616E206172
      6368697665206F66206F766572203430303020696D6167657320616E64206D75
      6C7469706C652074616773020000000000030004000000747275650400030000
      0079657305001500000068747470733A2F2F77616966752E696D2F646F637306
      0005000000416E696D65FEFEFF1B1C002D000000FF1D00000A00000057616966
      752E70696373010027000000496D6167652073686172696E6720706C6174666F
      726D20666F7220616E696D6520696D6167657302000000000003000400000074
      7275650400020000006E6F05001700000068747470733A2F2F77616966752E70
      6963732F646F6373060005000000416E696D65FEFEFF1B1C002E000000FF1D00
      000900000041627573654950444201001800000049502F646F6D61696E2F5552
      4C2072657075746174696F6E0200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05001B00000068747470733A2F2F646F63
      732E6162757365697064622E636F6D2F06000C000000416E74692D4D616C7761
      7265FEFEFF1B1C002F000000FF1D000025000000416C69656E5661756C74204F
      70656E205468726561742045786368616E676520284F54582901001800000049
      502F646F6D61696E2F55524C2072657075746174696F6E020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001E000000
      68747470733A2F2F6F74782E616C69656E7661756C742E636F6D2F6170690600
      0C000000416E74692D4D616C77617265FEFEFF1B1C0030000000FF1D00000B00
      00004341504573616E64626F7801001E0000004D616C77617265206578656375
      74696F6E20616E6420616E616C797369730200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05003600000068747470733A
      2F2F6361706576322E72656164746865646F63732E696F2F656E2F6C61746573
      742F75736167652F6170692E68746D6C06000C000000416E74692D4D616C7761
      7265FEFEFF1B1C0031000000FF1D000014000000476F6F676C65205361666520
      42726F7773696E6701001B000000476F6F676C65204C696E6B2F446F6D61696E
      20466C616767696E670200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05002C00000068747470733A2F2F646576656C6F
      706572732E676F6F676C652E636F6D2F736166652D62726F7773696E672F0600
      0C000000416E74692D4D616C77617265FEFEFF1B1C0032000000FF1D00000B00
      00004D616C446174616261736501003600000050726F76696465206D616C7761
      726520646174617365747320616E642074687265617420696E74656C6C696765
      6E63652066656564730200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05002400000068747470733A2F2F6D616C646174
      61626173652E636F6D2F6170692D646F632E68746D6C06000C000000416E7469
      2D4D616C77617265FEFEFF1B1C0033000000FF1D0000080000004D616C536861
      726501001F0000004D616C776172652041726368697665202F2066696C652073
      6F757263696E670200060000006170694B657903000400000074727565040002
      0000006E6F05001C00000068747470733A2F2F6D616C73686172652E636F6D2F
      646F632E70687006000C000000416E74692D4D616C77617265FEFEFF1B1C0034
      000000FF1D00000D0000004D616C7761726542617A616172010021000000436F
      6C6C65637420616E64207368617265206D616C776172652073616D706C657302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001C00000068747470733A2F2F62617A6161722E61627573652E63682F
      6170692F06000C000000416E74692D4D616C77617265FEFEFF1B1C0035000000
      FF1D0000080000004D657461636572740100160000004D65746163657274204C
      696E6B20466C616767696E670200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05001500000068747470733A2F2F6D6574
      61636572742E636F6D2F06000C000000416E74692D4D616C77617265FEFEFF1B
      1C0036000000FF1D0000080000004E6F50686973687901003500000043686563
      6B206C696E6B7320746F207365652069662074686579277265206B6E6F776E20
      7068697368696E6720617474656D7074730200060000006170694B6579030004
      0000007472756504000300000079657305003700000068747470733A2F2F7261
      7069646170692E636F6D2F416D69696368752F6170692F6578657272612D7068
      697368696E672D636865636B2F06000C000000416E74692D4D616C77617265FE
      FEFF1B1C0037000000FF1D00000A000000506869736865726D616E0100180000
      0049502F646F6D61696E2F55524C2072657075746174696F6E02000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001600
      000068747470733A2F2F706869736865726D616E2E67672F06000C000000416E
      74692D4D616C77617265FEFEFF1B1C0038000000FF1D0000060000005363616E
      696901005300000053696D706C6520524553542041504920746861742063616E
      207363616E207375626D697474656420646F63756D656E74732F66696C657320
      666F72207468652070726573656E6365206F6620746872656174730200060000
      006170694B657903000400000074727565040003000000796573050018000000
      68747470733A2F2F646F63732E7363616E69692E636F6D2F06000C000000416E
      74692D4D616C77617265FEFEFF1B1C0039000000FF1D00000700000055524C68
      61757301002900000042756C6B207175657269657320616E6420446F776E6C6F
      6164204D616C776172652053616D706C65730200000000000300040000007472
      756504000300000079657305001D00000068747470733A2F2F75726C68617573
      2D6170692E61627573652E63682F06000C000000416E74692D4D616C77617265
      FEFEFF1B1C003A000000FF1D00000A00000055524C5363616E2E696F01001500
      00005363616E20616E6420416E616C7973652055524C73020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001D000000
      68747470733A2F2F75726C7363616E2E696F2F61626F75742D6170692F06000C
      000000416E74692D4D616C77617265FEFEFF1B1C003B000000FF1D00000A0000
      005669727573546F74616C01001C0000005669727573546F74616C2046696C65
      2F55524C20416E616C797369730200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05003700000068747470733A2F2F7777
      772E7669727573746F74616C2E636F6D2F656E2F646F63756D656E746174696F
      6E2F7075626C69632D6170692F06000C000000416E74692D4D616C77617265FE
      FEFF1B1C003C000000FF1D00000C000000576562206F66205472757374010018
      00000049502F646F6D61696E2F55524C2072657075746174696F6E0200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      3D00000068747470733A2F2F737570706F72742E6D79776F742E636F6D2F6863
      2F656E2D75732F73656374696F6E732F3336303030343437373733342D415049
      2D06000C000000416E74692D4D616C77617265FEFEFF1B1C003D000000FF1D00
      000A000000416DC3A974687973746501002100000047656E657261746520696D
      6167657320666F7220446973636F72642075736572730200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05001A00000068
      747470733A2F2F6170692E616D657468797374652E6D6F652F06000C00000041
      727420262044657369676EFEFEFF1B1C003E000000FF1D000018000000417274
      20496E73746974757465206F66204368696361676F0100030000004172740200
      000000000300040000007472756504000300000079657305001B000000687474
      70733A2F2F6170692E61727469632E6564752F646F63732F06000C0000004172
      7420262044657369676EFEFEFF1B1C003F000000FF1D000009000000436F6C6F
      726D696E64010016000000436F6C6F7220736368656D652067656E657261746F
      7202000000000003000500000066616C7365040007000000756E6B6E6F776E05
      001F000000687474703A2F2F636F6C6F726D696E642E696F2F6170692D616363
      6573732F06000C00000041727420262044657369676EFEFEFF1B1C0040000000
      FF1D00000C000000436F6C6F75724C6F76657273010029000000476574207661
      72696F7573207061747465726E732C2070616C657474657320616E6420696D61
      67657302000000000003000500000066616C7365040007000000756E6B6E6F77
      6E05001F000000687474703A2F2F7777772E636F6C6F75726C6F766572732E63
      6F6D2F61706906000C00000041727420262044657369676EFEFEFF1B1C004100
      0000FF1D00000D000000436F6F70657220486577697474010019000000536D69
      7468736F6E69616E2044657369676E204D757365756D0200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05002700000068
      747470733A2F2F636F6C6C656374696F6E2E636F6F7065726865776974742E6F
      72672F61706906000C00000041727420262044657369676EFEFEFF1B1C004200
      0000FF1D0000080000004472696262626C65010030000000446973636F766572
      2074686520776F726C64E280997320746F702064657369676E65727320262063
      72656174697665730200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05001E00000068747470733A2F2F646576656C6F7065
      722E6472696262626C652E636F6D06000C00000041727420262044657369676E
      FEFEFF1B1C0043000000FF1D000008000000456D6F6A69487562010023000000
      47657420656D6F6A69732062792063617465676F7269657320616E642067726F
      7570730200000000000300040000007472756504000300000079657305002600
      000068747470733A2F2F6769746875622E636F6D2F6368656174736E616B652F
      656D6F6A6968756206000C00000041727420262044657369676EFEFEFF1B1C00
      44000000FF1D0000090000004575726F7065616E610100250000004575726F70
      65616E204D757365756D20616E642047616C6C657269657320636F6E74656E74
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05002E00000068747470733A2F2F70726F2E6575726F7065616E612E65
      752F7265736F75726365732F617069732F73656172636806000C000000417274
      20262044657369676EFEFEFF1B1C0045000000FF1D0000130000004861727661
      726420417274204D757365756D73010003000000417274020006000000617069
      4B657903000500000066616C7365040007000000756E6B6E6F776E05002D0000
      0068747470733A2F2F6769746875622E636F6D2F686172766172646172746D75
      7365756D732F6170692D646F637306000C00000041727420262044657369676E
      FEFEFF1B1C0046000000FF1D00000A00000049636F6E20486F72736501002800
      000046617669636F6E7320666F7220616E7920776562736974652C2077697468
      2066616C6C6261636B7302000000000003000400000074727565040003000000
      79657305001200000068747470733A2F2F69636F6E2E686F72736506000C0000
      0041727420262044657369676EFEFEFF1B1C0047000000FF1D00000A00000049
      636F6E66696E64657201000500000049636F6E730200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E050020000000687474
      70733A2F2F646576656C6F7065722E69636F6E66696E6465722E636F6D06000C
      00000041727420262044657369676EFEFEFF1B1C0048000000FF1D0000060000
      0049636F6E733801002C00000049636F6E73202866696E642022736561726368
      2069636F6E222068797065726C696E6B20696E20706167652902000000000003
      000400000074727565040007000000756E6B6E6F776E05001700000068747470
      733A2F2F696D672E69636F6E73382E636F6D2F06000C00000041727420262044
      657369676EFEFEFF1B1C0049000000FF1D0000080000004C6F726469636F6E01
      001D00000049636F6E73207769746820707265646F6E6520416E696D6174696F
      6E73020000000000030004000000747275650400030000007965730500150000
      0068747470733A2F2F6C6F726469636F6E2E636F6D2F06000C00000041727420
      262044657369676EFEFEFF1B1C004A000000FF1D00001A0000004D6574726F70
      6F6C6974616E204D757365756D206F66204172740100110000004D6574204D75
      7365756D206F6620417274020000000000030004000000747275650400020000
      006E6F05001C00000068747470733A2F2F6D65746D757365756D2E6769746875
      622E696F2F06000C00000041727420262044657369676EFEFEFF1B1C004B0000
      00FF1D00000C0000004E6F756E2050726F6A65637401000500000049636F6E73
      0200050000004F4175746803000500000066616C7365040007000000756E6B6E
      6F776E050028000000687474703A2F2F6170692E7468656E6F756E70726F6A65
      63742E636F6D2F696E6465782E68746D6C06000C000000417274202620446573
      69676EFEFEFF1B1C004C000000FF1D0000090000005048502D4E6F6973650100
      200000004E6F697365204261636B67726F756E6420496D6167652047656E6572
      61746F7202000000000003000400000074727565040003000000796573050016
      00000068747470733A2F2F7068702D6E6F6973652E636F6D2F06000C00000041
      727420262044657369676EFEFEFF1B1C004D000000FF1D00000F000000506978
      656C20456E636F756E7465720100120000005356472049636F6E2047656E6572
      61746F72020000000000030004000000747275650400020000006E6F05001E00
      000068747470733A2F2F706978656C656E636F756E7465722E636F6D2F617069
      06000C00000041727420262044657369676EFEFEFF1B1C004E000000FF1D0000
      0B00000052696A6B736D757365756D01001000000052696A6B734D757365756D
      20446174610200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05003000000068747470733A2F2F646174612E72696A6B73
      6D757365756D2E6E6C2F6F626A6563742D6D657461646174612F6170692F0600
      0C00000041727420262044657369676EFEFEFF1B1C004F000000FF1D00000A00
      0000576F726420436C6F7564010019000000456173696C792063726561746520
      776F726420636C6F7564730200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05001900000068747470733A2F2F776F7264
      636C6F75646170692E636F6D2F06000C00000041727420262044657369676EFE
      FEFF1B1C0050000000FF1D00000700000078436F6C6F72730100190000004765
      6E6572617465202620636F6E7665727420636F6C6F7273020000000000030004
      0000007472756504000300000079657305001F00000068747470733A2F2F782D
      636F6C6F72732E6865726F6B756170702E636F6D2F06000C0000004172742026
      2044657369676EFEFEFF1B1C0051000000FF1D00000500000041757468300100
      460000004561737920746F20696D706C656D656E742C20616461707461626C65
      2061757468656E7469636174696F6E20616E6420617574686F72697A6174696F
      6E20706C6174666F726D0200060000006170694B657903000400000074727565
      04000300000079657305001100000068747470733A2F2F61757468302E636F6D
      06001E00000041757468656E7469636174696F6E202620417574686F72697A61
      74696F6EFEFEFF1B1C0052000000FF1D0000060000004765744F545001001A00
      0000496D706C656D656E74204F545020666C6F7720717569636B6C7902000600
      00006170694B6579030004000000747275650400020000006E6F050018000000
      68747470733A2F2F6F74702E6465762F656E2F646F63732F06001E0000004175
      7468656E7469636174696F6E202620417574686F72697A6174696F6EFEFEFF1B
      1C0053000000FF1D0000120000004D6963726F20557365722053657276696365
      01002200000055736572206D616E6167656D656E7420616E642061757468656E
      7469636174696F6E0200060000006170694B6579030004000000747275650400
      020000006E6F05001400000068747470733A2F2F6D336F2E636F6D2F75736572
      06001E00000041757468656E7469636174696F6E202620417574686F72697A61
      74696F6EFEFEFF1B1C0054000000FF1D0000080000004D6F6A6F417574680100
      3600000053656375726520616E64206D6F6465726E2070617373776F72646C65
      73732061757468656E7469636174696F6E20706C6174666F726D020006000000
      6170694B65790300040000007472756504000300000079657305001400000068
      747470733A2F2F6D6F6A6F617574682E636F6D06001E00000041757468656E74
      69636174696F6E202620417574686F72697A6174696F6EFEFEFF1B1C00550000
      00FF1D0000090000005341574F204C61627301006100000053696D706C696679
      206C6F67696E20616E6420696D70726F7665207573657220657870657269656E
      636520627920696E746567726174696E672070617373776F72646C6573732061
      757468656E7469636174696F6E20696E20796F75722061707002000600000061
      70694B6579030004000000747275650400030000007965730500140000006874
      7470733A2F2F7361776F6C6162732E636F6D06001E00000041757468656E7469
      636174696F6E202620417574686F72697A6174696F6EFEFEFF1B1C0056000000
      FF1D00000600000053747974636801002B0000005573657220696E6672617374
      7275637475726520666F72206D6F6465726E206170706C69636174696F6E7302
      00060000006170694B6579030004000000747275650400020000006E6F050013
      00000068747470733A2F2F7374797463682E636F6D2F06001E00000041757468
      656E7469636174696F6E202620417574686F72697A6174696F6EFEFEFF1B1C00
      57000000FF1D00000700000057617272616E740100290000004150497320666F
      7220617574686F72697A6174696F6E20616E642061636365737320636F6E7472
      6F6C0200060000006170694B6579030004000000747275650400030000007965
      7305001400000068747470733A2F2F77617272616E742E6465762F06001E0000
      0041757468656E7469636174696F6E202620417574686F72697A6174696F6EFE
      FEFF1B1C0058000000FF1D000008000000426974717565727901001F0000004F
      6E636861696E204772617068514C204150497320262044455820415049730200
      060000006170694B65790300040000007472756504000300000079657305001F
      00000068747470733A2F2F6772617068716C2E62697471756572792E696F2F69
      646506000A000000426C6F636B636861696EFEFEFF1B1C0059000000FF1D0000
      09000000436861696E6C696E6B01002B0000004275696C642068796272696420
      736D61727420636F6E747261637473207769746820436861696E6C696E6B0200
      0000000003000400000074727565040007000000756E6B6E6F776E0500260000
      0068747470733A2F2F636861696E2E6C696E6B2F646576656C6F7065722D7265
      736F757263657306000A000000426C6F636B636861696EFEFEFF1B1C005A0000
      00FF1D00000A000000436861696E706F696E7401004B000000436861696E706F
      696E74206973206120676C6F62616C206E6574776F726B20666F7220616E6368
      6F72696E67206461746120746F2074686520426974636F696E20626C6F636B63
      6861696E02000000000003000400000074727565040007000000756E6B6E6F77
      6E05001F00000068747470733A2F2F74696572696F6E2E636F6D2F636861696E
      706F696E742F06000A000000426C6F636B636861696EFEFEFF1B1C005B000000
      FF1D000008000000436F76616C656E740100290000004D756C74692D626C6F63
      6B636861696E20646174612061676772656761746F7220706C6174666F726D02
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002400000068747470733A2F2F7777772E636F76616C656E7468712E63
      6F6D2F646F63732F6170692F06000A000000426C6F636B636861696EFEFEFF1B
      1C005C000000FF1D00000900000045746865727363616E010015000000457468
      657265756D206578706C6F726572204150490200060000006170694B65790300
      040000007472756504000300000079657305001900000068747470733A2F2F65
      746865727363616E2E696F2F6170697306000A000000426C6F636B636861696E
      FEFEFF1B1C005D000000FF1D00000600000048656C69756D0100640000004865
      6C69756D206973206120676C6F62616C2C206469737472696275746564206E65
      74776F726B206F6620486F7473706F7473207468617420637265617465207075
      626C69632C206C6F6E672D72616E676520776972656C65737320636F76657261
      676502000000000003000400000074727565040007000000756E6B6E6F776E05
      003400000068747470733A2F2F646F63732E68656C69756D2E636F6D2F617069
      2F626C6F636B636861696E2F696E74726F64756374696F6E2F06000A00000042
      6C6F636B636861696EFEFEFF1B1C005E000000FF1D0000080000004E6F776E6F
      64657301004E000000426C6F636B636861696E2D61732D612D73657276696365
      20736F6C7574696F6E20746861742070726F766964657320686967682D717561
      6C69747920636F6E6E656374696F6E2076696120415049020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050014000000
      68747470733A2F2F6E6F776E6F6465732E696F2F06000A000000426C6F636B63
      6861696EFEFEFF1B1C005F000000FF1D000005000000537465656D0100320000
      00426C6F636B636861696E2D626173656420626C6F6767696E6720616E642073
      6F6369616C206D65646961207765627369746502000000000003000500000066
      616C73650400020000006E6F05001C00000068747470733A2F2F646576656C6F
      706572732E737465656D2E696F2F06000A000000426C6F636B636861696EFEFE
      FF1B1C0060000000FF1D00000900000054686520477261706801004200000049
      6E646578696E672070726F746F636F6C20666F72207175657279696E67206E65
      74776F726B73206C696B6520457468657265756D207769746820477261706851
      4C0200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05001400000068747470733A2F2F74686567726170682E636F6D0600
      0A000000426C6F636B636861696EFEFEFF1B1C0061000000FF1D000008000000
      57616C6C74696D65010022000000546F2072657472696576652057616C6C7469
      6D652773206D61726B657420696E666F02000000000003000400000074727565
      040007000000756E6B6E6F776E05001E00000068747470733A2F2F77616C6C74
      696D652E696E666F2F6170692E68746D6C06000A000000426C6F636B63686169
      6EFEFEFF1B1C0062000000FF1D00000900000057617463686461746101003D00
      000050726F766964652073696D706C6520616E642072656C6961626C65204150
      492061636365737320746F20457468657265756D20626C6F636B636861696E02
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001900000068747470733A2F2F646F63732E7761746368646174612E69
      6F06000A000000426C6F636B636861696EFEFEFF1B1C0063000000FF1D000011
      000000412042C3AD626C6961204469676974616C01003E000000446F206E6F74
      20776F7272792061626F7574206D616E6167696E6720746865206D756C746970
      6C652076657273696F6E73206F6620746865204269626C650200060000006170
      694B6579030004000000747275650400020000006E6F05002400000068747470
      733A2F2F7777772E616269626C69616469676974616C2E636F6D2E62722F656E
      060005000000426F6F6B73FEFEFF1B1C0064000000FF1D00000D000000426861
      676176616420476974610100610000004F70656E20536F757263652053687269
      6D616420426861676176616420476974612041504920696E636C7564696E6720
      32312B20617574686F7273207472616E736C6174696F6E20696E2053616E736B
      7269742F456E676C6973682F48696E64690200060000006170694B6579030004
      0000007472756504000300000079657305001F00000068747470733A2F2F646F
      63732E6268616761766164676974616170692E696E060005000000426F6F6B73
      FEFEFF1B1C0065000000FF1D00000D0000004268616761766164204769746101
      00120000004268616761766164204769746120746578740200050000004F4175
      74680300040000007472756504000300000079657305001B0000006874747073
      3A2F2F6268616761766164676974612E696F2F617069060005000000426F6F6B
      73FEFEFF1B1C0066000000FF1D00001400000042686167617661642047697461
      2074656C75677501002E00000042686167617661642047697461204150492069
      6E2074656C75677520616E64206F646961206C616E6775616765730200000000
      000300040000007472756504000300000079657305001B00000068747470733A
      2F2F676974612D6170692E76657263656C2E617070060005000000426F6F6B73
      FEFEFF1B1C0067000000FF1D0000090000004269626C652D6170690100260000
      0046726565204269626C65204150492077697468206D756C7469706C65206C61
      6E67756167657302000000000003000400000074727565040003000000796573
      05001600000068747470733A2F2F6269626C652D6170692E636F6D2F06000500
      0000426F6F6B73FEFEFF1B1C0068000000FF1D00001D00000042726974697368
      204E6174696F6E616C204269626C696F677261706879010005000000426F6F6B
      7302000000000003000500000066616C7365040007000000756E6B6E6F776E05
      0016000000687474703A2F2F626E622E646174612E626C2E756B2F0600050000
      00426F6F6B73FEFEFF1B1C0069000000FF1D00001800000043726F7373726566
      204D6574616461746120536561726368010019000000426F6F6B732026204172
      7469636C6573204D657461646174610200000000000300040000007472756504
      0007000000756E6B6E6F776E05002800000068747470733A2F2F676974687562
      2E636F6D2F43726F73735265662F726573742D6170692D646F63060005000000
      426F6F6B73FEFEFF1B1C006A000000FF1D00000700000047616E6A6F6F720100
      62000000436C6173736963205065727369616E20706F6574727920776F726B73
      20696E636C7564696E672061636365737320746F2072656C61746564206D616E
      75736372697074732C2072656369746174696F6E7320616E64206D7573696320
      747261636B730200050000004F41757468030004000000747275650400030000
      0079657305001700000068747470733A2F2F6170692E67616E6A6F6F722E6E65
      74060005000000426F6F6B73FEFEFF1B1C006B000000FF1D00000C000000476F
      6F676C6520426F6F6B73010005000000426F6F6B730200050000004F41757468
      03000400000074727565040007000000756E6B6E6F776E050024000000687474
      70733A2F2F646576656C6F706572732E676F6F676C652E636F6D2F626F6F6B73
      2F060005000000426F6F6B73FEFEFF1B1C006C000000FF1D00000A0000004775
      7262616E694E6F770100250000004661737420616E6420416363757261746520
      47757262616E69205245535466756C2041504902000000000003000400000074
      727565040007000000756E6B6E6F776E05002100000068747470733A2F2F6769
      746875622E636F6D2F47757262616E694E6F772F617069060005000000426F6F
      6B73FEFEFF1B1C006D000000FF1D000008000000477574656E64657801003E00
      00005765622D41504920666F72206665746368696E6720646174612066726F6D
      2050726F6A65637420477574656E6265726720426F6F6B73204C696272617279
      02000000000003000400000074727565040007000000756E6B6E6F776E050015
      00000068747470733A2F2F677574656E6465782E636F6D2F060005000000426F
      6F6B73FEFEFF1B1C006E000000FF1D00000C0000004F70656E204C6962726172
      79010023000000426F6F6B732C20626F6F6B20636F7665727320616E64207265
      6C61746564206461746102000000000003000400000074727565040002000000
      6E6F05002600000068747470733A2F2F6F70656E6C6962726172792E6F72672F
      646576656C6F706572732F617069060005000000426F6F6B73FEFEFF1B1C006F
      000000FF1D00001200000050656E6775696E205075626C697368696E67010023
      000000426F6F6B732C20626F6F6B20636F7665727320616E642072656C617465
      6420646174610200000000000300040000007472756504000300000079657305
      0033000000687474703A2F2F7777772E70656E6775696E72616E646F6D686F75
      73652E62697A2F77656273657276696365732F726573742F060005000000426F
      6F6B73FEFEFF1B1C0070000000FF1D000008000000506F65747279444201003F
      000000456E61626C657320796F7520746F2067657420696E7374616E74206461
      74612066726F6D206F7572207661737420706F6574727920636F6C6C65637469
      6F6E0200000000000300040000007472756504000300000079657305002E0000
      0068747470733A2F2F6769746875622E636F6D2F7468756E646572636F6D622F
      706F65747279646223726561646D65060005000000426F6F6B73FEFEFF1B1C00
      71000000FF1D000005000000517572616E0100290000005245535466756C2051
      7572616E204150492077697468206D756C7469706C65206C616E677561676573
      0200000000000300040000007472756504000300000079657305001A00000068
      747470733A2F2F717572616E2E6170692D646F63732E696F2F06000500000042
      6F6F6B73FEFEFF1B1C0072000000FF1D00000B000000517572616E20436C6F75
      6401004C00000041205245535466756C20517572616E2041504920746F207265
      74726965766520616E20417961682C2053757261682C204A757A206F72207468
      6520656E7469726520486F6C7920517572616E02000000000003000400000074
      72756504000300000079657305001900000068747470733A2F2F616C71757261
      6E2E636C6F75642F617069060005000000426F6F6B73FEFEFF1B1C0073000000
      FF1D000009000000517572616E2D617069010049000000467265652051757261
      6E20415049205365727669636520776974682039302B20646966666572656E74
      206C616E67756167657320616E64203430302B207472616E736C6174696F6E73
      0200000000000300040000007472756504000300000079657305002F00000068
      747470733A2F2F6769746875622E636F6D2F666177617A61686D6564302F7175
      72616E2D61706923726561646D65060005000000426F6F6B73FEFEFF1B1C0074
      000000FF1D0000080000005269672056656461010058000000476F647320616E
      6420706F6574732C2074686569722063617465676F726965732C20616E642074
      6865207665727365206D65746572732C207769746820746865206D616E64616C
      20616E642073756B7461206E756D626572020000000000030004000000747275
      65040007000000756E6B6E6F776E05003200000068747470733A2F2F616E696E
      64697461626173752E6769746875622E696F2F696E646963612F68746D6C2F72
      762E68746D6C060005000000426F6F6B73FEFEFF1B1C0075000000FF1D000009
      000000546865204269626C6501003C00000045766572797468696E6720796F75
      206E6565642066726F6D20746865204269626C6520696E206F6E652064697363
      6F76657261626C6520706C6163650200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001600000068747470733A2F2F64
      6F63732E6170692E6269626C65060005000000426F6F6B73FEFEFF1B1C007600
      0000FF1D00000B00000054686972756B6B7572616C01003B0000003133333020
      54686972756B6B7572616C20706F656D7320616E64206578706C616E6174696F
      6E20696E2054616D696C20616E6420456E676C69736802000000000003000400
      00007472756504000300000079657305002000000068747470733A2F2F617069
      2D74686972756B6B7572616C2E7765622E6170702F060005000000426F6F6B73
      FEFEFF1B1C0077000000FF1D00000D000000566564696320536F636965747901
      00500000004465736372697074696F6E73206F6620616C6C206E6F756E732028
      6E616D65732C20706C616365732C20616E696D616C732C207468696E67732920
      66726F6D207665646963206C6974657261747572650200000000000300040000
      0074727565040007000000756E6B6E6F776E05003200000068747470733A2F2F
      616E696E64697461626173752E6769746875622E696F2F696E646963612F6874
      6D6C2F76732E68746D6C060005000000426F6F6B73FEFEFF1B1C0078000000FF
      1D00000C00000057697A61726420576F726C6401002E00000047657420696E66
      6F726D6174696F6E2066726F6D2074686520486172727920506F747465722075
      6E69766572736502000000000003000400000074727565040003000000796573
      05003900000068747470733A2F2F77697A6172642D776F726C642D6170692E68
      65726F6B756170702E636F6D2F737761676765722F696E6465782E68746D6C06
      0005000000426F6F6B73FEFEFF1B1C0079000000FF1D00000D000000576F6C6E
      65204C656B7475727901005400000041504920666F72206F627461696E696E67
      20696E666F726D6174696F6E2061626F757420652D626F6F6B7320617661696C
      61626C65206F6E2074686520576F6C6E654C656B747572792E706C2077656273
      69746502000000000003000400000074727565040007000000756E6B6E6F776E
      05001C00000068747470733A2F2F776F6C6E656C656B747572792E706C2F6170
      692F060005000000426F6F6B73FEFEFF1B1C007A000000FF1D00000F00000041
      706163686520537570657273657401003D00000041504920746F206D616E6167
      6520796F75722042492064617368626F6172647320616E64206461746120736F
      7572636573206F6E2053757065727365740200060000006170694B6579030004
      0000007472756504000300000079657305002400000068747470733A2F2F7375
      7065727365742E6170616368652E6F72672F646F63732F617069060008000000
      427573696E657373FEFEFF1B1C007B000000FF1D00000E000000436861726974
      79205365617263680100170000004E6F6E2D70726F6669742063686172697479
      20646174610200060000006170694B657903000500000066616C736504000700
      0000756E6B6E6F776E050020000000687474703A2F2F63686172697479617069
      2E6F726768756E7465722E636F6D2F060008000000427573696E657373FEFEFF
      1B1C007C000000FF1D00000D000000436C656172626974204C6F676F01003800
      000053656172636820666F7220636F6D70616E79206C6F676F7320616E642065
      6D626564207468656D20696E20796F75722070726F6A65637473020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050022
      00000068747470733A2F2F636C6561726269742E636F6D2F646F6373236C6F67
      6F2D617069060008000000427573696E657373FEFEFF1B1C007D000000FF1D00
      000E000000446F6D61696E7364622E696E666F01001E00000052656769737465
      72656420446F6D61696E204E616D657320536561726368020000000000030004
      000000747275650400020000006E6F05001700000068747470733A2F2F646F6D
      61696E7364622E696E666F2F060008000000427573696E657373FEFEFF1B1C00
      7E000000FF1D00000A000000467265656C616E63657201002100000048697265
      20667265656C616E6365727320746F2067657420776F726B20646F6E65020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      002100000068747470733A2F2F646576656C6F706572732E667265656C616E63
      65722E636F6D060008000000427573696E657373FEFEFF1B1C007F000000FF1D
      000005000000476D61696C01002C000000466C657869626C652C205245535466
      756C2061636365737320746F207468652075736572277320696E626F78020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      002800000068747470733A2F2F646576656C6F706572732E676F6F676C652E63
      6F6D2F676D61696C2F6170692F060008000000427573696E657373FEFEFF1B1C
      0080000000FF1D000010000000476F6F676C6520416E616C7974696373010044
      000000436F6C6C6563742C20636F6E66696775726520616E6420616E616C797A
      6520796F7572206461746120746F207265616368207468652072696768742061
      756469656E63650200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05002800000068747470733A2F2F646576656C6F706572
      732E676F6F676C652E636F6D2F616E616C79746963732F060008000000427573
      696E657373FEFEFF1B1C0081000000FF1D000008000000496E73746174757301
      0059000000506F737420746F20616E6420757064617465206D61696E74656E61
      6E636520616E6420696E636964656E7473206F6E20796F757220737461747573
      2070616765207468726F75676820616E20485454502052455354204150490200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05001D00000068747470733A2F2F696E7374617475732E636F6D2F68656C70
      2F617069060008000000427573696E657373FEFEFF1B1C0082000000FF1D0000
      090000004D61696C6368696D7001003000000053656E64206D61726B6574696E
      672063616D706169676E7320616E64207472616E73616374696F6E616C206D61
      696C730200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05002000000068747470733A2F2F6D61696C6368696D702E636F
      6D2F646576656C6F7065722F060008000000427573696E657373FEFEFF1B1C00
      83000000FF1D0000070000006D61696C6A65740100590000004D61726B657469
      6E6720656D61696C2063616E2062652073656E7420616E64206D61696C207465
      6D706C61746573206D61646520696E204D4A4D4C206F722048544D4C2063616E
      2062652073656E74207573696E67204150490200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E0500180000006874747073
      3A2F2F7777772E6D61696C6A65742E636F6D2F060008000000427573696E6573
      73FEFEFF1B1C0084000000FF1D0000090000006D61726B657261706901001000
      000054726164656D61726B205365617263680200000000000300050000006661
      6C7365040007000000756E6B6E6F776E05001500000068747470733A2F2F6D61
      726B65726170692E636F6D060008000000427573696E657373FEFEFF1B1C0085
      000000FF1D0000100000004F524220496E74656C6C6967656E636501000E0000
      00436F6D70616E79206C6F6F6B75700200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05002600000068747470733A2F2F
      6170692E6F72622D696E74656C6C6967656E63652E636F6D2F646F63732F0600
      08000000427573696E657373FEFEFF1B1C0086000000FF1D0000060000005265
      6461736801002C00000041636365737320796F7572207175657269657320616E
      642064617368626F61726473206F6E205265646173680200060000006170694B
      65790300040000007472756504000300000079657305003A0000006874747073
      3A2F2F7265646173682E696F2F68656C702F757365722D67756964652F696E74
      6567726174696F6E732D616E642D6170692F617069060008000000427573696E
      657373FEFEFF1B1C0087000000FF1D00000A000000536D617274736865657401
      0051000000416C6C6F777320796F7520746F2070726F6772616D6D6174696361
      6C6C792061636365737320616E6420536D617274736865657420646174612061
      6E64206163636F756E7420696E666F726D6174696F6E0200050000004F417574
      68030004000000747275650400020000006E6F05001C00000068747470733A2F
      2F736D61727473686565742E7265646F632E6C792F060008000000427573696E
      657373FEFEFF1B1C0088000000FF1D00000600000053717561726501004D0000
      00456173792077617920746F2074616B65207061796D656E74732C206D616E61
      676520726566756E64732C20616E642068656C7020637573746F6D6572732063
      6865636B6F7574206F6E6C696E650200050000004F4175746803000400000074
      727565040007000000756E6B6E6F776E05002F00000068747470733A2F2F6465
      76656C6F7065722E73717561726575702E636F6D2F7265666572656E63652F73
      7175617265060008000000427573696E657373FEFEFF1B1C0089000000FF1D00
      000B00000053776966744B616E62616E01005C0000004B616E62616E20736F66
      74776172652C2056697375616C697A6520576F726B2C20496E63726561736520
      4F7267616E697A6174696F6E73204C6561642054696D652C205468726F756768
      70757420262050726F6475637469766974790200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E0500640000006874747073
      3A2F2F7777772E6469676974652E636F6D2F6B6E6F776C656467652D62617365
      2F73776966746B616E62616E2F61727469636C652F6170692D666F722D737769
      66742D6B616E62616E2D7765622D73657276696365732F237265737461706906
      0008000000427573696E657373FEFEFF1B1C008A000000FF1D00001200000054
      656E6465727320696E2048756E67617279010033000000476574206461746120
      666F722070726F637572656D656E747320696E2048756E6761727920696E204A
      534F4E20666F726D617402000000000003000400000074727565040007000000
      756E6B6E6F776E05001B00000068747470733A2F2F74656E646572732E677572
      752F68752F617069060008000000427573696E657373FEFEFF1B1C008B000000
      FF1D00001100000054656E6465727320696E20506F6C616E6401003200000047
      6574206461746120666F722070726F637572656D656E747320696E20506F6C61
      6E6420696E204A534F4E20666F726D6174020000000000030004000000747275
      65040007000000756E6B6E6F776E05001B00000068747470733A2F2F74656E64
      6572732E677572752F706C2F617069060008000000427573696E657373FEFEFF
      1B1C008C000000FF1D00001200000054656E6465727320696E20526F6D616E69
      61010033000000476574206461746120666F722070726F637572656D656E7473
      20696E20526F6D616E696120696E204A534F4E20666F726D6174020000000000
      03000400000074727565040007000000756E6B6E6F776E05001B000000687474
      70733A2F2F74656E646572732E677572752F726F2F6170690600080000004275
      73696E657373FEFEFF1B1C008D000000FF1D00001000000054656E6465727320
      696E20537061696E010031000000476574206461746120666F722070726F6375
      72656D656E747320696E20537061696E20696E204A534F4E20666F726D617402
      000000000003000400000074727565040007000000756E6B6E6F776E05001B00
      000068747470733A2F2F74656E646572732E677572752F65732F617069060008
      000000427573696E657373FEFEFF1B1C008E000000FF1D00001200000054656E
      6465727320696E20556B7261696E65010033000000476574206461746120666F
      722070726F637572656D656E747320696E20556B7261696E6520696E204A534F
      4E20666F726D617402000000000003000400000074727565040007000000756E
      6B6E6F776E05001B00000068747470733A2F2F74656E646572732E677572752F
      75612F617069060008000000427573696E657373FEFEFF1B1C008F000000FF1D
      000012000000546F6D626120656D61696C2066696E646572010041000000456D
      61696C2046696E64657220666F72204232422073616C657320616E6420656D61
      696C206D61726B6574696E6720616E6420656D61696C20766572696669657202
      00060000006170694B6579030004000000747275650400030000007965730500
      1400000068747470733A2F2F746F6D62612E696F2F6170690600080000004275
      73696E657373FEFEFF1B1C0090000000FF1D0000060000005472656C6C6F0100
      49000000426F617264732C206C6973747320616E6420636172647320746F2068
      656C7020796F75206F7267616E697A6520616E64207072696F726974697A6520
      796F75722070726F6A656374730200050000004F417574680300040000007472
      7565040007000000756E6B6E6F776E05001E00000068747470733A2F2F646576
      656C6F706572732E7472656C6C6F2E636F6D2F060008000000427573696E6573
      73FEFEFF1B1C0091000000FF1D0000180000004162737472616374205075626C
      696320486F6C696461797301003A00000044617461206F6E206E6174696F6E61
      6C2C20726567696F6E616C2C20616E642072656C6967696F757320686F6C6964
      61797320766961204150490200060000006170694B6579030004000000747275
      6504000300000079657305002800000068747470733A2F2F7777772E61627374
      726163746170692E636F6D2F686F6C69646179732D6170690600080000004361
      6C656E646172FEFEFF1B1C0092000000FF1D00000C00000043616C656E646172
      69666963010012000000576F726C647769646520486F6C696461797302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001900000068747470733A2F2F63616C656E646172696669632E636F6D2F0600
      0800000043616C656E646172FEFEFF1B1C0093000000FF1D0000200000004368
      65636B69646179202D204E6174696F6E616C20486F6C69646179204150490100
      7B000000496E6475737472792D6C656164696E6720486F6C6964617920415049
      2E204F76657220352C30303020686F6C696461797320616E642074686F757361
      6E6473206F66206465736372697074696F6E732E205472757374656420627920
      74686520576F726C64E2809973206C656164696E6720636F6D70616E69657302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002E00000068747470733A2F2F6170696C617965722E636F6D2F6D6172
      6B6574706C6163652F636865636B696461792D61706906000800000043616C65
      6E646172FEFEFF1B1C0094000000FF1D00000F0000004368757263682043616C
      656E64617201001C000000436174686F6C6963206C69747572676963616C2063
      616C656E64617202000000000003000500000066616C7365040007000000756E
      6B6E6F776E05001E000000687474703A2F2F63616C6170692E696E6164697574
      6F7269756D2E637A2F06000800000043616C656E646172FEFEFF1B1C00950000
      00FF1D000017000000437A656368204E616D65646179732043616C656E646172
      01002A0000004C6F6F6B757020666F722061206E616D6520616E642072657475
      726E73206E616D65646179206461746502000000000003000500000066616C73
      65040007000000756E6B6E6F776E05001A00000068747470733A2F2F73766174
      6B792E6164726573612E696E666F06000800000043616C656E646172FEFEFF1B
      1C0096000000FF1D0000170000004665737469766F205075626C696320486F6C
      696461797301004D0000004661737465737420616E64206D6F73742061647661
      6E636564207075626C696320686F6C6964617920616E64206F6273657276616E
      63652073657276696365206F6E20746865206D61726B65740200060000006170
      694B657903000400000074727565040003000000796573050043000000687474
      70733A2F2F646F63732E6765746665737469766F2E636F6D2F646F63732F7072
      6F64756374732F7075626C69632D686F6C69646179732D6170692F696E74726F
      06000800000043616C656E646172FEFEFF1B1C0097000000FF1D00000F000000
      476F6F676C652043616C656E646172010031000000446973706C61792C206372
      6561746520616E64206D6F6469667920476F6F676C652063616C656E64617220
      6576656E74730200050000004F41757468030004000000747275650400070000
      00756E6B6E6F776E05003300000068747470733A2F2F646576656C6F70657273
      2E676F6F676C652E636F6D2F676F6F676C652D617070732F63616C656E646172
      2F06000800000043616C656E646172FEFEFF1B1C0098000000FF1D00000F0000
      004865627265772043616C656E64617201004A000000436F6E76657274206265
      747765656E20477265676F7269616E20616E64204865627265772C2066657463
      68205368616262617420616E6420486F6C696461792074696D65732C20657463
      02000000000003000500000066616C7365040007000000756E6B6E6F776E0500
      2A00000068747470733A2F2F7777772E68656263616C2E636F6D2F686F6D652F
      646576656C6F7065722D6170697306000800000043616C656E646172FEFEFF1B
      1C0099000000FF1D000008000000486F6C696461797301002200000048697374
      6F726963616C206461746120726567617264696E6720686F6C69646179730200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05001700000068747470733A2F2F686F6C696461796170692E636F6D2F0600
      0800000043616C656E646172FEFEFF1B1C009A000000FF1D0000090000004C65
      6374536572766501001E00000050726F74657374616E74206C69747572676963
      616C2063616C656E64617202000000000003000500000066616C736504000700
      0000756E6B6E6F776E050018000000687474703A2F2F7777772E6C6563747365
      7276652E636F6D06000800000043616C656E646172FEFEFF1B1C009B000000FF
      1D00000A0000004E616765722E4461746501002A0000005075626C696320686F
      6C696461797320666F72206D6F7265207468616E20393020636F756E74726965
      73020000000000030004000000747275650400020000006E6F05001500000068
      747470733A2F2F646174652E6E616765722E617406000800000043616C656E64
      6172FEFEFF1B1C009C000000FF1D0000110000004E616D65646179732043616C
      656E64617201002800000050726F7669646573206E616D656461797320666F72
      206D756C7469706C6520636F756E747269657302000000000003000400000074
      72756504000300000079657305001A00000068747470733A2F2F6E616D656461
      792E6162616C696E2E6E657406000800000043616C656E646172FEFEFF1B1C00
      9D000000FF1D0000100000004E6F6E2D576F726B696E67204461797301002A00
      00004461746162617365206F66204943532066696C657320666F72206E6F6E20
      776F726B696E6720646179730200000000000300040000007472756504000700
      0000756E6B6E6F776E05001F00000068747470733A2F2F6769746875622E636F
      6D2F67616461656C2F696373646206000800000043616C656E646172FEFEFF1B
      1C009E000000FF1D0000100000004E6F6E2D576F726B696E6720446179730100
      5E00000053696D706C6520524553542041504920666F7220636865636B696E67
      20776F726B696E672C206E6F6E2D776F726B696E67206F722073686F72742064
      61797320666F72205275737369612C204349532C2055534120616E64206F7468
      6572020000000000030004000000747275650400030000007965730500130000
      0068747470733A2F2F69736461796F66662E727506000800000043616C656E64
      6172FEFEFF1B1C009F000000FF1D0000100000005275737369616E2043616C65
      6E64617201002B000000436865636B2069662061206461746520697320612052
      75737369616E20686F6C69646179206F72206E6F740200000000000300040000
      00747275650400020000006E6F05002500000068747470733A2F2F6769746875
      622E636F6D2F65676E6F2F776F726B2D63616C656E6461720600080000004361
      6C656E646172FEFEFF1B1C00A0000000FF1D000010000000554B2042616E6B20
      486F6C696461797301004100000042616E6B20686F6C696461797320696E2045
      6E676C616E6420616E642057616C65732C2053636F746C616E6420616E64204E
      6F72746865726E204972656C616E640200000000000300040000007472756504
      0007000000756E6B6E6F776E05002500000068747470733A2F2F7777772E676F
      762E756B2F62616E6B2D686F6C69646179732E6A736F6E06000800000043616C
      656E646172FEFEFF1B1C00A1000000FF1D000009000000416E6F6E46696C6573
      01002700000055706C6F616420616E6420736861726520796F75722066696C65
      7320616E6F6E796D6F75736C7902000000000003000400000074727565040007
      000000756E6B6E6F776E05001E00000068747470733A2F2F616E6F6E66696C65
      732E636F6D2F646F63732F61706906001C000000436C6F75642053746F726167
      6520262046696C652053686172696E67FEFEFF1B1C00A2000000FF1D00000800
      000042617946696C657301001B00000055706C6F616420616E64207368617265
      20796F75722066696C6573020000000000030004000000747275650400070000
      00756E6B6E6F776E05001D00000068747470733A2F2F62617966696C65732E63
      6F6D2F646F63732F61706906001C000000436C6F75642053746F726167652026
      2046696C652053686172696E67FEFEFF1B1C00A3000000FF1D00000300000042
      6F7801001800000046696C652053686172696E6720616E642053746F72616765
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05001A00000068747470733A2F2F646576656C6F7065722E626F782E636F
      6D2F06001C000000436C6F75642053746F7261676520262046696C6520536861
      72696E67FEFEFF1B1C00A4000000FF1D00000900000064646F776E6C6F616401
      001800000046696C652053686172696E6720616E642053746F72616765020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001900000068747470733A2F2F64646F776E6C6F61642E636F6D2F61706906
      001C000000436C6F75642053746F7261676520262046696C652053686172696E
      67FEFEFF1B1C00A5000000FF1D00000700000044726F70626F78010018000000
      46696C652053686172696E6720616E642053746F726167650200050000004F41
      75746803000400000074727565040007000000756E6B6E6F776E050022000000
      68747470733A2F2F7777772E64726F70626F782E636F6D2F646576656C6F7065
      727306001C000000436C6F75642053746F7261676520262046696C6520536861
      72696E67FEFEFF1B1C00A6000000FF1D00000700000046696C652E696F01003B
      00000053757065722073696D706C652066696C652073686172696E672C20636F
      6E76656E69656E742C20616E6F6E796D6F757320616E64207365637572650200
      0000000003000400000074727565040007000000756E6B6E6F776E0500130000
      0068747470733A2F2F7777772E66696C652E696F06001C000000436C6F756420
      53746F7261676520262046696C652053686172696E67FEFEFF1B1C00A7000000
      FF1D00000900000046696C65737461636B01002900000046696C65737461636B
      2046696C652055706C6F6164657220262046696C652055706C6F616420415049
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001900000068747470733A2F2F7777772E66696C65737461636B2E63
      6F6D06001C000000436C6F75642053746F7261676520262046696C6520536861
      72696E67FEFEFF1B1C00A8000000FF1D000006000000476F46696C6501002400
      0000556E6C696D697465642073697A652066696C652075706C6F61647320666F
      7220667265650200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001500000068747470733A2F2F676F66696C652E696F
      2F61706906001C000000436C6F75642053746F7261676520262046696C652053
      686172696E67FEFEFF1B1C00A9000000FF1D00000C000000476F6F676C652044
      7269766501001800000046696C652053686172696E6720616E642053746F7261
      67650200050000004F4175746803000400000074727565040007000000756E6B
      6E6F776E05002400000068747470733A2F2F646576656C6F706572732E676F6F
      676C652E636F6D2F64726976652F06001C000000436C6F75642053746F726167
      6520262046696C652053686172696E67FEFEFF1B1C00AA000000FF1D00000500
      00004779617A6F0100260000005361766520262053686172652073637265656E
      20636170747572657320696E7374616E746C790200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001A00000068747470
      733A2F2F6779617A6F2E636F6D2F6170692F646F637306001C000000436C6F75
      642053746F7261676520262046696C652053686172696E67FEFEFF1B1C00AB00
      0000FF1D000005000000496D67626201002600000053696D706C6520616E6420
      717569636B207072697661746520696D6167652073686172696E670200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1600000068747470733A2F2F6170692E696D6762622E636F6D2F06001C000000
      436C6F75642053746F7261676520262046696C652053686172696E67FEFEFF1B
      1C00AC000000FF1D0000080000004F6E65447269766501001800000046696C65
      2053686172696E6720616E642053746F726167650200050000004F4175746803
      000400000074727565040007000000756E6B6E6F776E05002800000068747470
      733A2F2F646576656C6F7065722E6D6963726F736F66742E636F6D2F6F6E6564
      7269766506001C000000436C6F75642053746F7261676520262046696C652053
      686172696E67FEFEFF1B1C00AD000000FF1D00000600000050616E7472790100
      2400000046726565204A534F4E2073746F7261676520666F7220736D616C6C20
      70726F6A65637473020000000000030004000000747275650400030000007965
      7305001800000068747470733A2F2F67657470616E7472792E636C6F75642F06
      001C000000436C6F75642053746F7261676520262046696C652053686172696E
      67FEFEFF1B1C00AE000000FF1D000008000000506173746562696E0100120000
      00506C61696E20546578742053746F726167650200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001C00000068747470
      733A2F2F706173746562696E2E636F6D2F646F635F61706906001C000000436C
      6F75642053746F7261676520262046696C652053686172696E67FEFEFF1B1C00
      AF000000FF1D00000600000050696E617461010019000000495046532050696E
      6E696E67205365727669636573204150490200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05001A00000068747470733A
      2F2F646F63732E70696E6174612E636C6F75642F06001C000000436C6F756420
      53746F7261676520262046696C652053686172696E67FEFEFF1B1C00B0000000
      FF1D0000040000005175697001002300000046696C652053686172696E672061
      6E642053746F7261676520666F722067726F7570730200060000006170694B65
      790300040000007472756504000300000079657305002D00000068747470733A
      2F2F717569702E636F6D2F6465762F6175746F6D6174696F6E2F646F63756D65
      6E746174696F6E06001C000000436C6F75642053746F7261676520262046696C
      652053686172696E67FEFEFF1B1C00B1000000FF1D00000500000053746F726A
      010027000000446563656E7472616C697A6564204F70656E2D536F7572636520
      436C6F75642053746F726167650200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001A00000068747470733A2F2F646F
      63732E73746F726A2E696F2F6463732F06001C000000436C6F75642053746F72
      61676520262046696C652053686172696E67FEFEFF1B1C00B2000000FF1D0000
      10000000546865204E756C6C20506F696E7465720100330000004E6F2D62756C
      6C736869742066696C6520686F7374696E6720616E642055524C2073686F7274
      656E696E67207365727669636502000000000003000400000074727565040007
      000000756E6B6E6F776E05000E00000068747470733A2F2F3078302E73740600
      1C000000436C6F75642053746F7261676520262046696C652053686172696E67
      FEFEFF1B1C00B3000000FF1D00000C000000576562332053746F726167650100
      3000000046696C652053686172696E6720616E642053746F7261676520666F72
      20467265652077697468203154422053706163650200060000006170694B6579
      0300040000007472756504000300000079657305001500000068747470733A2F
      2F776562332E73746F726167652F06001C000000436C6F75642053746F726167
      6520262046696C652053686172696E67FEFEFF1B1C00B4000000FF1D00001300
      0000417A757265204465764F7073204865616C746801005D0000005265736F75
      726365206865616C74682068656C707320796F7520646961676E6F736520616E
      642067657420737570706F7274207768656E20616E20417A7572652069737375
      6520696D706163747320796F7572207265736F75726365730200060000006170
      694B657903000500000066616C73650400020000006E6F050038000000687474
      70733A2F2F646F63732E6D6963726F736F66742E636F6D2F656E2D75732F7265
      73742F6170692F7265736F757263656865616C7468060016000000436F6E7469
      6E756F757320496E746567726174696F6EFEFEFF1B1C00B5000000FF1D000007
      0000004269747269736501004F0000004275696C6420746F6F6C20616E642070
      726F63657373657320696E746567726174696F6E7320746F2063726561746520
      656666696369656E7420646576656C6F706D656E7420706970656C696E657302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001C00000068747470733A2F2F6170692D646F63732E62697472697365
      2E696F2F060016000000436F6E74696E756F757320496E746567726174696F6E
      FEFEFF1B1C00B6000000FF1D0000050000004275646479010043000000546865
      206661737465737420636F6E74696E756F757320696E746567726174696F6E20
      616E6420636F6E74696E756F75732064656C697665727920706C6174666F726D
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05003500000068747470733A2F2F62756464792E776F726B732F646F6373
      2F6170692F67657474696E672D737461727465642F6F76657276696577060016
      000000436F6E74696E756F757320496E746567726174696F6EFEFEFF1B1C00B7
      000000FF1D000008000000436972636C65434901005E0000004175746F6D6174
      652074686520736F66747761726520646576656C6F706D656E742070726F6365
      7373207573696E6720636F6E74696E756F757320696E746567726174696F6E20
      616E6420636F6E74696E756F75732064656C6976657279020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05002B000000
      68747470733A2F2F636972636C6563692E636F6D2F646F63732F6170692F7631
      2D7265666572656E63652F060016000000436F6E74696E756F757320496E7465
      67726174696F6EFEFEFF1B1C00B8000000FF1D000008000000436F6465736869
      7001003A000000436F646573686970206973206120436F6E74696E756F757320
      496E746567726174696F6E20506C6174666F726D20696E2074686520636C6F75
      640200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05004700000068747470733A2F2F646F63732E636C6F756462656573
      2E636F6D2F646F63732F636C6F7564626565732D636F6465736869702F6C6174
      6573742F6170692D6F766572766965772F060016000000436F6E74696E756F75
      7320496E746567726174696F6EFEFEFF1B1C00B9000000FF1D00000900000054
      726176697320434901004500000053796E6320796F7572204769744875622070
      726F6A6563747320776974682054726176697320434920746F20746573742079
      6F757220636F646520696E206D696E757465730200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001F00000068747470
      733A2F2F646F63732E7472617669732D63692E636F6D2F6170692F0600160000
      00436F6E74696E756F757320496E746567726174696F6EFEFEFF1B1C00BA0000
      00FF1D000002000000307801004400000041504920666F72207175657279696E
      6720746F6B656E20616E6420706F6F6C207374617473206163726F7373207661
      72696F7573206C697175696469747920706F6F6C730200000000000300040000
      007472756504000300000079657305001200000068747470733A2F2F30782E6F
      72672F61706906000E00000043727970746F63757272656E6379FEFEFF1B1C00
      BB000000FF1D00000500000031696E636801002600000041504920666F722071
      75657279696E6720646563656E7472616C697A652065786368616E6765020000
      00000003000400000074727565040007000000756E6B6E6F776E050015000000
      68747470733A2F2F31696E63682E696F2F6170692F06000E0000004372797074
      6F63757272656E6379FEFEFF1B1C00BC000000FF1D000010000000416C636865
      6D7920457468657265756D010023000000457468657265756D204E6F64652D61
      732D612D536572766963652050726F76696465720200060000006170694B6579
      0300040000007472756504000300000079657305002100000068747470733A2F
      2F646F63732E616C6368656D792E636F6D2F616C6368656D792F06000E000000
      43727970746F63757272656E6379FEFEFF1B1C00BD000000FF1D000012000000
      6170696C6179657220636F696E6C617965720100280000005265616C2D74696D
      652043727970746F2043757272656E63792045786368616E6765205261746573
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001500000068747470733A2F2F636F696E6C617965722E636F6D0600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00BE000000FF1D0000
      0700000042696E616E636501003400000045786368616E676520666F72205472
      6164696E672043727970746F63757272656E6369657320626173656420696E20
      4368696E610200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05003000000068747470733A2F2F6769746875622E636F6D
      2F62696E616E63652F62696E616E63652D73706F742D6170692D646F63730600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00BF000000FF1D0000
      0900000042697463616D62696F01003100000047657420746865206C69737420
      6F6620616C6C207472616465642061737365747320696E207468652065786368
      616E676502000000000003000400000074727565040007000000756E6B6E6F77
      6E05003200000068747470733A2F2F6E6F76612E62697463616D62696F2E636F
      6D2E62722F6170692F76332F646F637323612D7075626C696306000E00000043
      727970746F63757272656E6379FEFEFF1B1C00C0000000FF1D00000E00000042
      6974636F696E417665726167650100340000004469676974616C204173736574
      205072696365204461746120666F722074686520626C6F636B636861696E2069
      6E6475737472790200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05002100000068747470733A2F2F61706976322E6269
      74636F696E617665726167652E636F6D2F06000E00000043727970746F637572
      72656E6379FEFEFF1B1C00C1000000FF1D00000D000000426974636F696E4368
      6172747301003B00000046696E616E6369616C20616E6420546563686E696361
      6C20446174612072656C6174656420746F2074686520426974636F696E204E65
      74776F726B02000000000003000400000074727565040007000000756E6B6E6F
      776E05002A00000068747470733A2F2F626974636F696E6368617274732E636F
      6D2F61626F75742F65786368616E6765732F06000E00000043727970746F6375
      7272656E6379FEFEFF1B1C00C2000000FF1D00000800000042697466696E6578
      01001F00000043727970746F63757272656E63792054726164696E6720506C61
      74666F726D0200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001E00000068747470733A2F2F646F63732E6269746669
      6E65782E636F6D2F646F637306000E00000043727970746F63757272656E6379
      FEFEFF1B1C00C3000000FF1D0000060000004269746D65780100480000005265
      616C2D54696D652043727970746F63757272656E637920646572697661746976
      65732074726164696E6720706C6174666F726D20626173656420696E20486F6E
      67204B6F6E670200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002600000068747470733A2F2F7777772E6269746D65
      782E636F6D2F6170702F6170694F7665727669657706000E0000004372797074
      6F63757272656E6379FEFEFF1B1C00C4000000FF1D0000070000004269747472
      65780100270000004E6578742047656E65726174696F6E2043727970746F2054
      726164696E6720506C6174666F726D0200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05002000000068747470733A2F2F
      626974747265782E6769746875622E696F2F6170692F763306000E0000004372
      7970746F63757272656E6379FEFEFF1B1C00C5000000FF1D000005000000426C
      6F636B01002A000000426974636F696E205061796D656E742C2057616C6C6574
      2026205472616E73616374696F6E20446174610200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001B00000068747470
      733A2F2F626C6F636B2E696F2F646F63732F626173696306000E000000437279
      70746F63757272656E6379FEFEFF1B1C00C6000000FF1D00000A000000426C6F
      636B636861696E01002A000000426974636F696E205061796D656E742C205761
      6C6C65742026205472616E73616374696F6E2044617461020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001E000000
      68747470733A2F2F7777772E626C6F636B636861696E2E636F6D2F6170690600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00C7000000FF1D0000
      12000000626C6F636B66726F73742043617264616E6F010039000000496E7465
      72616374696F6E2077697468207468652043617264616E6F206D61696E6E6574
      20616E64207365766572616C20746573746E6574730200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500160000006874
      7470733A2F2F626C6F636B66726F73742E696F2F06000E00000043727970746F
      63757272656E6379FEFEFF1B1C00C8000000FF1D00000D000000427261766520
      4E6577436F696E0100400000005265616C2D74696D6520616E6420686973746F
      7269632063727970746F20646174612066726F6D206D6F7265207468616E2032
      30302B2065786368616E6765730200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05002300000068747470733A2F2F6272
      6176656E6577636F696E2E636F6D2F646576656C6F7065727306000E00000043
      727970746F63757272656E6379FEFEFF1B1C00C9000000FF1D00000700000042
      74635475726B0100420000005265616C2D74696D652063727970746F63757272
      656E637920646174612C2067726170687320616E642041504920746861742061
      6C6C6F7773206275792673656C6C0200060000006170694B6579030004000000
      7472756504000300000079657305001900000068747470733A2F2F646F63732E
      6274637475726B2E636F6D2F06000E00000043727970746F63757272656E6379
      FEFEFF1B1C00CA000000FF1D0000050000004279626974010030000000437279
      70746F63757272656E63792064617461206665656420616E6420616C676F7269
      74686D69632074726164696E670200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05003C00000068747470733A2F2F6279
      6269742D65786368616E67652E6769746875622E696F2F646F63732F6C696E65
      61722F23742D696E74726F64756374696F6E06000E00000043727970746F6375
      7272656E6379FEFEFF1B1C00CB000000FF1D000007000000436F696E41504901
      0033000000416C6C2043757272656E63792045786368616E67657320696E7465
      677261746520756E64657220612073696E676C65206170690200060000006170
      694B6579030004000000747275650400020000006E6F05001800000068747470
      733A2F2F646F63732E636F696E6170692E696F2F06000E00000043727970746F
      63757272656E6379FEFEFF1B1C00CC000000FF1D000008000000436F696E6261
      7365010033000000426974636F696E2C20426974636F696E20436173682C204C
      697465636F696E20616E6420457468657265756D205072696365730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1F00000068747470733A2F2F646576656C6F706572732E636F696E626173652E
      636F6D06000E00000043727970746F63757272656E6379FEFEFF1B1C00CD0000
      00FF1D00000C000000436F696E626173652050726F01001F0000004372797074
      6F63757272656E63792054726164696E6720506C6174666F726D020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050022
      00000068747470733A2F2F646F63732E70726F2E636F696E626173652E636F6D
      2F2361706906000E00000043727970746F63757272656E6379FEFEFF1B1C00CE
      000000FF1D000007000000436F696E4361700100350000005265616C2074696D
      652043727970746F63757272656E637920707269636573207468726F75676820
      61205245535466756C2041504902000000000003000400000074727565040007
      000000756E6B6E6F776E05001800000068747470733A2F2F646F63732E636F69
      6E6361702E696F2F06000E00000043727970746F63757272656E6379FEFEFF1B
      1C00CF000000FF1D000007000000436F696E44435801001F0000004372797074
      6F63757272656E63792054726164696E6720506C6174666F726D020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050019
      00000068747470733A2F2F646F63732E636F696E6463782E636F6D2F06000E00
      000043727970746F63757272656E6379FEFEFF1B1C00D0000000FF1D00000800
      0000436F696E4465736B01003B000000436F696E4465736B277320426974636F
      696E20507269636520496E64657820284250492920696E206D756C7469706C65
      2063757272656E63696573020000000000030004000000747275650400070000
      00756E6B6E6F776E05002600000068747470733A2F2F6F6C642E636F696E6465
      736B2E636F6D2F636F696E6465736B2D6170692F06000E00000043727970746F
      63757272656E6379FEFEFF1B1C00D1000000FF1D000009000000436F696E4765
      636B6F01003700000043727970746F63757272656E63792050726963652C204D
      61726B65742C20616E6420446576656C6F7065722F536F6369616C2044617461
      0200000000000300040000007472756504000300000079657305001C00000068
      7474703A2F2F7777772E636F696E6765636B6F2E636F6D2F61706906000E0000
      0043727970746F63757272656E6379FEFEFF1B1C00D2000000FF1D0000070000
      00436F696E696779010037000000496E746572616374696E6720776974682043
      6F696E696779204163636F756E747320616E642045786368616E676520446972
      6563746C790200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001E00000068747470733A2F2F636F696E6967792E646F
      63732E6170696172792E696F06000E00000043727970746F63757272656E6379
      FEFEFF1B1C00D3000000FF1D000007000000436F696E6C696201001600000043
      727970746F2043757272656E6379205072696365730200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E05001A0000006874
      7470733A2F2F636F696E6C69622E696F2F617069646F637306000E0000004372
      7970746F63757272656E6379FEFEFF1B1C00D4000000FF1D000008000000436F
      696E6C6F726501002800000043727970746F63757272656E6369657320707269
      6365732C20766F6C756D6520616E64206D6F7265020000000000030004000000
      74727565040007000000756E6B6E6F776E05003000000068747470733A2F2F77
      77772E636F696E6C6F72652E636F6D2F63727970746F63757272656E63792D64
      6174612D61706906000E00000043727970746F63757272656E6379FEFEFF1B1C
      00D5000000FF1D00000D000000436F696E4D61726B6574436170010017000000
      43727970746F63757272656E6369657320507269636573020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001E000000
      68747470733A2F2F636F696E6D61726B65746361702E636F6D2F6170692F0600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00D6000000FF1D0000
      0B000000436F696E70617072696B6101002800000043727970746F6375727265
      6E63696573207072696365732C20766F6C756D6520616E64206D6F7265020000
      0000000300040000007472756504000300000079657305001B00000068747470
      733A2F2F6170692E636F696E70617072696B612E636F6D06000E000000437279
      70746F63757272656E6379FEFEFF1B1C00D7000000FF1D00000B000000436F69
      6E52616E6B696E670100180000004C6976652043727970746F63757272656E63
      7920646174610200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05003400000068747470733A2F2F646576656C6F706572
      732E636F696E72616E6B696E672E636F6D2F6170692F646F63756D656E746174
      696F6E06000E00000043727970746F63757272656E6379FEFEFF1B1C00D80000
      00FF1D00000C000000436F696E72656D69747465720100210000004372797074
      6F63757272656E63696573205061796D656E7420262050726963657302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001D00000068747470733A2F2F636F696E72656D69747465722E636F6D2F646F
      637306000E00000043727970746F63757272656E6379FEFEFF1B1C00D9000000
      FF1D000009000000436F696E537461747301000E00000043727970746F205472
      61636B657202000000000003000400000074727565040007000000756E6B6E6F
      776E05004600000068747470733A2F2F646F63756D656E7465722E676574706F
      73746D616E2E636F6D2F766965772F353733343032372F527A5A36487A72333F
      76657273696F6E3D6C617465737406000E00000043727970746F63757272656E
      6379FEFEFF1B1C00DA000000FF1D000008000000437279707441504901002000
      000043727970746F63757272656E6379205061796D656E742050726F63657373
      6F7202000000000003000400000074727565040007000000756E6B6E6F776E05
      001900000068747470733A2F2F646F63732E63727970746170692E696F2F0600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00DB000000FF1D0000
      0A0000004372797074696E67557001001300000043727970746F63757272656E
      6379206461746102000000000003000400000074727565040007000000756E6B
      6E6F776E05002F00000068747470733A2F2F7777772E6372797074696E677570
      2E636F6D2F617069646F632F23696E74726F64756374696F6E06000E00000043
      727970746F63757272656E6379FEFEFF1B1C00DC000000FF1D00000D00000043
      727970746F436F6D7061726501001B00000043727970746F63757272656E6369
      657320436F6D70617269736F6E02000000000003000400000074727565040007
      000000756E6B6E6F776E05002200000068747470733A2F2F7777772E63727970
      746F636F6D706172652E636F6D2F6170692306000E00000043727970746F6375
      7272656E6379FEFEFF1B1C00DD000000FF1D00000C00000043727970746F4D61
      726B657401002100000043727970746F63757272656E63696573205472616469
      6E6720706C6174666F726D0200060000006170694B6579030004000000747275
      6504000300000079657305002300000068747470733A2F2F6170692E65786368
      616E67652E63727970746F6D6B742E636F6D2F06000E00000043727970746F63
      757272656E6379FEFEFF1B1C00DE000000FF1D00000B00000043727970746F6E
      61746F7201001F00000043727970746F63757272656E63696573204578636861
      6E67652052617465730200000000000300040000007472756504000700000075
      6E6B6E6F776E05002000000068747470733A2F2F7777772E63727970746F6E61
      746F722E636F6D2F6170692F06000E00000043727970746F63757272656E6379
      FEFEFF1B1C00DF000000FF1D0000040000006459645801002500000044656365
      6E7472616C697A65642063727970746F63757272656E63792065786368616E67
      650200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05001B00000068747470733A2F2F646F63732E647964782E65786368
      616E67652F06000E00000043727970746F63757272656E6379FEFEFF1B1C00E0
      000000FF1D000009000000457468706C6F72657201005F000000457468657265
      756D20746F6B656E732C2062616C616E6365732C206164647265737365732C20
      686973746F7279206F66207472616E73616374696F6E732C20636F6E74726163
      74732C20616E6420637573746F6D207374727563747572657302000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05003800
      000068747470733A2F2F6769746875622E636F6D2F457665726578494F2F4574
      68706C6F7265722F77696B692F457468706C6F7265722D41504906000E000000
      43727970746F63757272656E6379FEFEFF1B1C00E1000000FF1D000004000000
      45584D4F01002500000043727970746F63757272656E63696573206578636861
      6E676520626173656420696E20554B0200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05003800000068747470733A2F2F
      646F63756D656E7465722E676574706F73746D616E2E636F6D2F766965772F31
      303238373434302F537A5958574B506906000E00000043727970746F63757272
      656E6379FEFEFF1B1C00E2000000FF1D00000300000046545801004D00000043
      6F6D706C65746520524553542C20776562736F636B65742C20616E6420465458
      204150497320746F207375697420796F757220616C676F726974686D69632074
      726164696E67206E656564730200060000006170694B65790300040000007472
      756504000300000079657305001500000068747470733A2F2F646F63732E6674
      782E636F6D2F06000E00000043727970746F63757272656E6379FEFEFF1B1C00
      E3000000FF1D00000600000047617465696F0100380000004150492070726F76
      696465732073706F742C206D617267696E20616E642066757475726573207472
      6164696E67206F7065726174696F6E730200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001800000068747470733A2F
      2F7777772E676174652E696F2F6170693206000E00000043727970746F637572
      72656E6379FEFEFF1B1C00E4000000FF1D00000600000047656D696E69010019
      00000043727970746F63757272656E636965732045786368616E676502000000
      000003000400000074727565040007000000756E6B6E6F776E05002100000068
      747470733A2F2F646F63732E67656D696E692E636F6D2F726573742D6170692F
      06000E00000043727970746F63757272656E6379FEFEFF1B1C00E5000000FF1D
      000014000000486972616B2045786368616E6765205261746573010060000000
      45786368616E6765207261746573206265747765656E20313632206375727265
      6E63792026203330302063727970746F2063757272656E637920757064617465
      20656163682035206D696E2C2061636375726174652C206E6F206C696D697473
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001900000068747470733A2F2F72617465732E686972616B2E736974
      652F06000E00000043727970746F63757272656E6379FEFEFF1B1C00E6000000
      FF1D00000500000048756F62690100280000005365796368656C6C6573206261
      7365642063727970746F63757272656E63792065786368616E67650200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      2B00000068747470733A2F2F68756F62696170692E6769746875622E696F2F64
      6F63732F73706F742F76312F656E2F06000E00000043727970746F6375727265
      6E6379FEFEFF1B1C00E7000000FF1D0000090000006963792E746F6F6C730100
      150000004772617068514C206261736564204E46542041504902000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001D00
      000068747470733A2F2F646576656C6F706572732E6963792E746F6F6C732F06
      000E00000043727970746F63757272656E6379FEFEFF1B1C00E8000000FF1D00
      0007000000496E646F64617801002F000000547261646520796F757220426974
      636F696E20616E64206F74686572206173736574732077697468207275706961
      680200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05003200000068747470733A2F2F6769746875622E636F6D2F627463
      69642F696E646F6461782D6F6666696369616C2D6170692D646F637306000E00
      000043727970746F63757272656E6379FEFEFF1B1C00E9000000FF1D00000F00
      0000494E4655524120457468657265756D01003A000000496E74657261637469
      6F6E20776974682074686520457468657265756D206D61696E6E657420616E64
      207365766572616C20746573746E6574730200060000006170694B6579030004
      0000007472756504000300000079657305002200000068747470733A2F2F696E
      667572612E696F2F70726F647563742F657468657265756D06000E0000004372
      7970746F63757272656E6379FEFEFF1B1C00EA000000FF1D0000060000004B72
      616B656E01001900000043727970746F63757272656E63696573204578636861
      6E67650200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001D00000068747470733A2F2F646F63732E6B72616B656E2E
      636F6D2F726573742F06000E00000043727970746F63757272656E6379FEFEFF
      1B1C00EB000000FF1D0000060000004B75436F696E01001F0000004372797074
      6F63757272656E63792054726164696E6720506C6174666F726D020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050018
      00000068747470733A2F2F646F63732E6B75636F696E2E636F6D2F06000E0000
      0043727970746F63757272656E6379FEFEFF1B1C00EC000000FF1D00000D0000
      004C6F63616C626974636F696E7301002500000050325020706C6174666F726D
      20746F2062757920616E642073656C6C20426974636F696E7302000000000003
      000400000074727565040007000000756E6B6E6F776E05002300000068747470
      733A2F2F6C6F63616C626974636F696E732E636F6D2F6170692D646F63732F06
      000E00000043727970746F63757272656E6379FEFEFF1B1C00ED000000FF1D00
      00070000004D656D706F6F6C010033000000426974636F696E20415049205365
      727669636520666F637573696E67206F6E20746865207472616E73616374696F
      6E20666565020000000000030004000000747275650400020000006E6F050019
      00000068747470733A2F2F6D656D706F6F6C2E73706163652F61706906000E00
      000043727970746F63757272656E6379FEFEFF1B1C00EE000000FF1D00000E00
      00004D65726361646F426974636F696E0100240000004272617A696C69616E20
      43727970746F63757272656E637920496E666F726D6174696F6E020000000000
      03000400000074727565040007000000756E6B6E6F776E05002A000000687474
      70733A2F2F7777772E6D65726361646F626974636F696E2E636F6D2E62722F61
      70692D646F632F06000E00000043727970746F63757272656E6379FEFEFF1B1C
      00EF000000FF1D0000070000004D65737361726901003500000050726F766964
      65732041504920656E64706F696E747320666F722074686F7573616E6473206F
      662063727970746F206173736574730200000000000300040000007472756504
      0007000000756E6B6E6F776E05001600000068747470733A2F2F6D6573736172
      692E696F2F61706906000E00000043727970746F63757272656E6379FEFEFF1B
      1C00F0000000FF1D0000090000004E65786368616E6765010029000000417574
      6F6D617465642063727970746F63757272656E63792065786368616E67652073
      65727669636502000000000003000500000066616C7365040003000000796573
      05002200000068747470733A2F2F6E65786368616E6765322E646F63732E6170
      696172792E696F2F06000E00000043727970746F63757272656E6379FEFEFF1B
      1C00F1000000FF1D0000060000004E6F6D69637301003D000000486973746F72
      6963616C20616E64207265616C74696D652063727970746F63757272656E6379
      2070726963657320616E64206D61726B65742064617461020006000000617069
      4B65790300040000007472756504000300000079657305001800000068747470
      733A2F2F6E6F6D6963732E636F6D2F646F63732F06000E00000043727970746F
      63757272656E6379FEFEFF1B1C00F2000000FF1D0000070000004E6F76614461
      780100430000004E6F76614441582041504920746F2061636365737320616C6C
      206D61726B657420646174612C2074726164696E67206D616E6167656D656E74
      20656E64706F696E74730200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05002B00000068747470733A2F2F646F632E6E
      6F76616461782E636F6D2F656E2D55532F23696E74726F64756374696F6E0600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00F3000000FF1D0000
      040000004F4B457801002B00000043727970746F63757272656E637920657863
      68616E676520626173656420696E205365796368656C6C657302000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001A00
      000068747470733A2F2F7777772E6F6B65782E636F6D2F646F63732F06000E00
      000043727970746F63757272656E6379FEFEFF1B1C00F4000000FF1D00000800
      0000506F6C6F6E69657801001F0000005553206261736564206469676974616C
      2061737365742065786368616E67650200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001900000068747470733A2F2F
      646F63732E706F6C6F6E6965782E636F6D06000E00000043727970746F637572
      72656E6379FEFEFF1B1C00F5000000FF1D00000F000000536F6C616E61204A53
      4F4E2052504301004100000050726F766964657320766172696F757320656E64
      706F696E747320746F20696E74657261637420776974682074686520536F6C61
      6E6120426C6F636B636861696E02000000000003000400000074727565040007
      000000756E6B6E6F776E05003600000068747470733A2F2F646F63732E736F6C
      616E612E636F6D2F646576656C6F70696E672F636C69656E74732F6A736F6E72
      70632D61706906000E00000043727970746F63757272656E6379FEFEFF1B1C00
      F6000000FF1D000012000000546563686E6963616C20416E616C797369730100
      2C00000043727970746F63757272656E63792070726963657320616E64207465
      63686E6963616C20616E616C797369730200060000006170694B657903000400
      0000747275650400020000006E6F05002200000068747470733A2F2F74656368
      6E6963616C2D616E616C797369732D6170692E636F6D06000E00000043727970
      746F63757272656E6379FEFEFF1B1C00F7000000FF1D00000400000056414C52
      01002D00000043727970746F63757272656E63792045786368616E6765206261
      73656420696E20536F757468204166726963610200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001600000068747470
      733A2F2F646F63732E76616C722E636F6D2F06000E00000043727970746F6375
      7272656E6379FEFEFF1B1C00F8000000FF1D00000E000000576F726C64436F69
      6E496E64657801001700000043727970746F63757272656E6369657320507269
      6365730200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05002900000068747470733A2F2F7777772E776F726C64636F69
      6E696E6465782E636F6D2F6170697365727669636506000E0000004372797074
      6F63757272656E6379FEFEFF1B1C00F9000000FF1D0000040000005A4D4F4B01
      0027000000457468657265756D204A534F4E205250432041504920616E642057
      6562332070726F76696465720200000000000300040000007472756504000700
      0000756E6B6E6F776E05000F00000068747470733A2F2F7A6D6F6B2E696F0600
      0E00000043727970746F63757272656E6379FEFEFF1B1C00FA000000FF1D0000
      0600000031466F72676501001A000000466F7265782063757272656E6379206D
      61726B657420646174610200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05003300000068747470733A2F2F31666F7267
      652E636F6D2F666F7265782D646174612D6170692F6170692D646F63756D656E
      746174696F6E06001100000043757272656E63792045786368616E6765FEFEFF
      1B1C00FB000000FF1D000007000000416D646F72656E01002A00000046726565
      2063757272656E6379204150492077697468206F766572203135302063757272
      656E636965730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002500000068747470733A2F2F7777772E616D646F72
      656E2E636F6D2F63757272656E63792D6170692F06001100000043757272656E
      63792045786368616E6765FEFEFF1B1C00FC000000FF1D000011000000617069
      6C617965722066697865722E696F01002600000045786368616E676520726174
      657320616E642063757272656E637920636F6E76657273696F6E020006000000
      6170694B657903000500000066616C7365040007000000756E6B6E6F776E0500
      1000000068747470733A2F2F66697865722E696F06001100000043757272656E
      63792045786368616E6765FEFEFF1B1C00FD000000FF1D00000E00000042616E
      6B206F662052757373696101002600000045786368616E676520726174657320
      616E642063757272656E637920636F6E76657273696F6E020000000000030004
      00000074727565040007000000756E6B6E6F776E05002400000068747470733A
      2F2F7777772E6362722E72752F646576656C6F706D656E742F53584D4C2F0600
      1100000043757272656E63792045786368616E6765FEFEFF1B1C00FE000000FF
      1D00000C00000043757272656E63792D61706901004600000046726565204375
      7272656E63792045786368616E67652052617465732041504920776974682031
      35302B2043757272656E636965732026204E6F2052617465204C696D69747302
      0000000000030004000000747275650400030000007965730500320000006874
      7470733A2F2F6769746875622E636F6D2F666177617A61686D6564302F637572
      72656E63792D61706923726561646D6506001100000043757272656E63792045
      786368616E6765FEFEFF1B1C00FF000000FF1D00000E00000043757272656E63
      79467265616B7301005800000050726F76696465732063757272656E7420616E
      6420686973746F726963616C2063757272656E63792065786368616E67652072
      617465732077697468206672656520706C616E20314B2072657175657374732F
      6D6F6E74680200060000006170694B6579030004000000747275650400030000
      0079657305001B00000068747470733A2F2F63757272656E6379667265616B73
      2E636F6D2F06001100000043757272656E63792045786368616E6765FEFEFF1B
      1C0000010000FF1D00000D00000043757272656E63796C617965720100260000
      0045786368616E676520726174657320616E642063757272656E637920636F6E
      76657273696F6E0200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05002700000068747470733A2F2F63757272656E6379
      6C617965722E636F6D2F646F63756D656E746174696F6E060011000000437572
      72656E63792045786368616E6765FEFEFF1B1C0001010000FF1D00000D000000
      43757272656E637953636F6F700100300000005265616C2D74696D6520616E64
      20686973746F726963616C2063757272656E6379207261746573204A534F4E20
      4150490200060000006170694B65790300040000007472756504000300000079
      657305002B00000068747470733A2F2F63757272656E637973636F6F702E636F
      6D2F6170692D646F63756D656E746174696F6E06001100000043757272656E63
      792045786368616E6765FEFEFF1B1C0002010000FF1D000013000000437A6563
      68204E6174696F6E616C2042616E6B01001E0000004120636F6C6C656374696F
      6E206F662065786368616E676520726174657302000000000003000400000074
      727565040007000000756E6B6E6F776E05005500000068747470733A2F2F7777
      772E636E622E637A2F63732F66696E616E636E695F747268792F646576697A6F
      76795F7472682F6B75727A795F646576697A6F7665686F5F747268752F64656E
      6E695F6B75727A2E786D6C06001100000043757272656E63792045786368616E
      6765FEFEFF1B1C0003010000FF1D00001000000045636F6E6F6D69612E417765
      736F6D65010042000000506F727475677565736520667265652063757272656E
      63792070726963657320616E6420636F6E76657273696F6E2077697468206E6F
      2072617465206C696D6974730200000000000300040000007472756504000700
      0000756E6B6E6F776E05002C00000068747470733A2F2F646F63732E61776573
      6F6D656170692E636F6D2E62722F6170692D64652D6D6F656461730600110000
      0043757272656E63792045786368616E6765FEFEFF1B1C0004010000FF1D0000
      1000000045786368616E6765526174652D415049010018000000467265652063
      757272656E637920636F6E76657273696F6E0200060000006170694B65790300
      040000007472756504000300000079657305002000000068747470733A2F2F77
      77772E65786368616E6765726174652D6170692E636F6D060011000000437572
      72656E63792045786368616E6765FEFEFF1B1C0005010000FF1D000011000000
      45786368616E6765726174652E686F73740100280000004672656520666F7265
      69676E2065786368616E676520262063727970746F2072617465732041504902
      000000000003000400000074727565040007000000756E6B6E6F776E05001900
      000068747470733A2F2F65786368616E6765726174652E686F73740600110000
      0043757272656E63792045786368616E6765FEFEFF1B1C0006010000FF1D0000
      1300000045786368616E676572617465736170692E696F010027000000457863
      68616E676520726174657320776974682063757272656E637920636F6E766572
      73696F6E0200060000006170694B657903000400000074727565040003000000
      79657305001B00000068747470733A2F2F65786368616E676572617465736170
      692E696F06001100000043757272656E63792045786368616E6765FEFEFF1B1C
      0007010000FF1D00000B0000004672616E6B6675727465720100330000004578
      6368616E67652072617465732C2063757272656E637920636F6E76657273696F
      6E20616E642074696D6520736572696573020000000000030004000000747275
      6504000300000079657305002000000068747470733A2F2F7777772E6672616E
      6B6675727465722E6170702F646F637306001100000043757272656E63792045
      786368616E6765FEFEFF1B1C0008010000FF1D00000C00000046726565466F72
      65784150490100390000005265616C2D74696D6520666F726569676E20657863
      68616E676520726174657320666F72206D616A6F722063757272656E63792070
      61697273020000000000030004000000747275650400020000006E6F05002100
      000068747470733A2F2F66726565666F7265786170692E636F6D2F486F6D652F
      41706906001100000043757272656E63792045786368616E6765FEFEFF1B1C00
      09010000FF1D0000170000004E6174696F6E616C2042616E6B206F6620506F6C
      616E6401003E0000004120636F6C6C656374696F6E206F662063757272656E63
      792065786368616E676520726174657320286461746120696E20584D4C20616E
      64204A534F4E2902000000000003000400000074727565040003000000796573
      050019000000687474703A2F2F6170692E6E62702E706C2F656E2E68746D6C06
      001100000043757272656E63792045786368616E6765FEFEFF1B1C000A010000
      FF1D00000D000000564154436F6D706C792E636F6D0100350000004578636861
      6E67652072617465732C2067656F6C6F636174696F6E20616E6420564154206E
      756D6265722076616C69646174696F6E02000000000003000400000074727565
      04000300000079657305002700000068747470733A2F2F7777772E766174636F
      6D706C792E636F6D2F646F63756D656E746174696F6E06001100000043757272
      656E63792045786368616E6765FEFEFF1B1C000B010000FF1D0000070000004C
      6F622E636F6D0100170000005553204164647265737320566572696669636174
      696F6E0200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001000000068747470733A2F2F6C6F622E636F6D2F06000F00
      0000446174612056616C69646174696F6EFEFEFF1B1C000C010000FF1D00000C
      000000506F73746D616E204563686F01003C0000005465737420617069207365
      7276657220746F207265636569766520616E642072657475726E2076616C7565
      2066726F6D2048545450206D6574686F64020000000000030004000000747275
      65040007000000756E6B6E6F776E05001C00000068747470733A2F2F7777772E
      706F73746D616E2D6563686F2E636F6D06000F000000446174612056616C6964
      6174696F6EFEFEFF1B1C000D010000FF1D00000A000000507572676F4D616C75
      6D01002F000000436F6E74656E742076616C696461746F7220616761696E7374
      2070726F66616E6974792026206F627363656E69747902000000000003000500
      000066616C7365040007000000756E6B6E6F776E050019000000687474703A2F
      2F7777772E707572676F6D616C756D2E636F6D06000F00000044617461205661
      6C69646174696F6EFEFEFF1B1C000E010000FF1D00000F000000555320417574
      6F636F6D706C65746501003D000000456E746572206164647265737320646174
      6120717569636B6C792077697468207265616C2D74696D652061646472657373
      2073756767657374696F6E730200060000006170694B65790300040000007472
      756504000300000079657305003900000068747470733A2F2F7777772E736D61
      7274792E636F6D2F646F63732F636C6F75642F75732D6175746F636F6D706C65
      74652D70726F2D61706906000F000000446174612056616C69646174696F6EFE
      FEFF1B1C000F010000FF1D00000A000000555320457874726163740100370000
      004578747261637420706F7374616C206164647265737365732066726F6D2061
      6E79207465787420696E636C7564696E6720656D61696C730200060000006170
      694B657903000400000074727565040003000000796573050033000000687474
      70733A2F2F7777772E736D617274792E636F6D2F70726F64756374732F617069
      732F75732D657874726163742D61706906000F000000446174612056616C6964
      6174696F6EFEFEFF1B1C0010010000FF1D000011000000555320537472656574
      204164647265737301003200000056616C696461746520616E6420617070656E
      64206461746120666F7220616E7920555320706F7374616C2061646472657373
      0200060000006170694B65790300040000007472756504000300000079657305
      002F00000068747470733A2F2F7777772E736D617274792E636F6D2F646F6373
      2F636C6F75642F75732D7374726565742D61706906000F000000446174612056
      616C69646174696F6EFEFEFF1B1C0011010000FF1D0000080000007661746C61
      796572010015000000564154206E756D6265722076616C69646174696F6E0200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05002200000068747470733A2F2F7661746C617965722E636F6D2F646F6375
      6D656E746174696F6E06000F000000446174612056616C69646174696F6EFEFE
      FF1B1C0012010000FF1D00001000000032342050756C6C205265717565737473
      01003C00000050726F6A65637420746F2070726F6D6F7465206F70656E20736F
      7572636520636F6C6C61626F726174696F6E20647572696E6720446563656D62
      65720200000000000300040000007472756504000300000079657305001E0000
      0068747470733A2F2F323470756C6C72657175657374732E636F6D2F61706906
      000B000000446576656C6F706D656E74FEFEFF1B1C0013010000FF1D00001300
      000041627374726163742053637265656E73686F7401003B00000054616B6520
      70726F6772616D6D617469632073637265656E73686F7473206F662077656220
      70616765732066726F6D20616E7920776562736974650200060000006170694B
      6579030004000000747275650400030000007965730500320000006874747073
      3A2F2F7777772E61627374726163746170692E636F6D2F776562736974652D73
      637265656E73686F742D61706906000B000000446576656C6F706D656E74FEFE
      FF1B1C0014010000FF1D00000800000041676966792E696F0100230000004573
      74696D6174657320746865206167652066726F6D2061206669727374206E616D
      6502000000000003000400000074727565040003000000796573050010000000
      68747470733A2F2F61676966792E696F06000B000000446576656C6F706D656E
      74FEFEFF1B1C0015010000FF1D00000B000000415049204772C3A17469730100
      220000004D756C7469706C657320736572766963657320616E64207075626C69
      63204150497302000000000003000400000074727565040007000000756E6B6E
      6F776E05001900000068747470733A2F2F6170696772617469732E636F6D2E62
      722F06000B000000446576656C6F706D656E74FEFEFF1B1C0016010000FF1D00
      0009000000417069634167656E7401002D000000457874726163742064657669
      63652064657461696C732066726F6D20757365722D6167656E7420737472696E
      6702000000000003000400000074727565040003000000796573050019000000
      68747470733A2F2F7777772E617069636167656E742E636F6D06000B00000044
      6576656C6F706D656E74FEFEFF1B1C0017010000FF1D00000800000041706946
      6C61736801002A0000004368726F6D652062617365642073637265656E73686F
      742041504920666F7220646576656C6F706572730200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E050015000000687474
      70733A2F2F617069666C6173682E636F6D2F06000B000000446576656C6F706D
      656E74FEFEFF1B1C0018010000FF1D0000120000006170696C61796572207573
      6572737461636B01002800000053656375726520557365722D4167656E742053
      7472696E67204C6F6F6B7570204A534F4E204150490200050000004F41757468
      03000400000074727565040007000000756E6B6E6F776E050016000000687474
      70733A2F2F75736572737461636B2E636F6D2F06000B000000446576656C6F70
      6D656E74FEFEFF1B1C0019010000FF1D000009000000415049732E6775727501
      003D00000057696B69706564696120666F722057656220415049732C204F7065
      6E4150492F5377616767657220737065637320666F72207075626C6963204150
      497302000000000003000400000074727565040007000000756E6B6E6F776E05
      001A00000068747470733A2F2F617069732E677572752F6170692D646F632F06
      000B000000446576656C6F706D656E74FEFEFF1B1C001A010000FF1D00000C00
      0000417A757265204465764F707301004500000054686520417A757265204465
      764F707320626173696320636F6D706F6E656E7473206F662061205245535420
      41504920726571756573742F726573706F6E7365207061697202000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05003600
      000068747470733A2F2F646F63732E6D6963726F736F66742E636F6D2F656E2D
      75732F726573742F6170692F617A7572652F6465766F707306000B0000004465
      76656C6F706D656E74FEFEFF1B1C001B010000FF1D0000040000004261736501
      00170000004275696C64696E6720717569636B206261636B656E647302000600
      00006170694B6579030004000000747275650400030000007965730500180000
      0068747470733A2F2F7777772E626173652D6170692E696F2F06000B00000044
      6576656C6F706D656E74FEFEFF1B1C001C010000FF1D00000900000042656563
      6570746F720100290000004275696C642061206D6F636B205265737420415049
      20656E64706F696E7420696E207365636F6E6473020000000000030004000000
      7472756504000300000079657305001600000068747470733A2F2F6265656365
      70746F722E636F6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C00
      1D010000FF1D0000090000004269746275636B657401000D0000004269746275
      636B6574204150490200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05003A00000068747470733A2F2F646576656C6F7065
      722E61746C61737369616E2E636F6D2F6269746275636B65742F6170692F322F
      7265666572656E63652F06000B000000446576656C6F706D656E74FEFEFF1B1C
      001E010000FF1D00000A000000426C616775652E78797A0100390000004C6120
      706C7573206772616E64652041504920646520426C61677565732046522F5468
      652062696767657374204652206A6F6B6573204150490200060000006170694B
      6579030004000000747275650400030000007965730500130000006874747073
      3A2F2F626C616775652E78797A2F06000B000000446576656C6F706D656E74FE
      FEFF1B1C001F010000FF1D000007000000426C697461707001003D0000005363
      686564756C652073637265656E73686F7473206F662077656220706167657320
      616E642073796E63207468656D20746F20796F757220636C6F75640200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1800000068747470733A2F2F626C69746170702E636F6D2F6170692F06000B00
      0000446576656C6F706D656E74FEFEFF1B1C0020010000FF1D00000B00000042
      6C796E6B2D436C6F7564010028000000436F6E74726F6C20496F542044657669
      6365732066726F6D20426C796E6B20496F5420436C6F75640200060000006170
      694B657903000500000066616C7365040007000000756E6B6E6F776E05002100
      000068747470733A2F2F626C796E6B6170692E646F63732E6170696172792E69
      6F2F2306000B000000446576656C6F706D656E74FEFEFF1B1C0021010000FF1D
      000005000000426F72656401002700000046696E642072616E646F6D20616374
      6976697469657320746F20666967687420626F7265646F6D0200000000000300
      0400000074727565040007000000756E6B6E6F776E0500190000006874747073
      3A2F2F7777772E626F7265646170692E636F6D2F06000B000000446576656C6F
      706D656E74FEFEFF1B1C0022010000FF1D00000C000000427261696E73686F70
      2E61690100150000004D616B652041204672656520412E4920427261696E0200
      060000006170694B657903000400000074727565040003000000796573050015
      00000068747470733A2F2F627261696E73686F702E61692F06000B0000004465
      76656C6F706D656E74FEFEFF1B1C0023010000FF1D00000800000042726F7773
      686F74010046000000456173696C79206D616B652073637265656E73686F7473
      206F662077656220706167657320696E20616E792073637265656E2073697A65
      2C20617320616E79206465766963650200060000006170694B65790300040000
      007472756504000300000079657305002600000068747470733A2F2F62726F77
      73686F742E636F6D2F6170692F646F63756D656E746174696F6E06000B000000
      446576656C6F706D656E74FEFEFF1B1C0024010000FF1D00000500000043444E
      4A530100150000004C69627261727920696E666F206F6E2043444E4A53020000
      00000003000400000074727565040007000000756E6B6E6F776E050026000000
      68747470733A2F2F6170692E63646E6A732E636F6D2F6C69627261726965732F
      6A717565727906000B000000446576656C6F706D656E74FEFEFF1B1C00250100
      00FF1D00000D0000004368616E67656C6F67732E6D6401003700000053747275
      637475726564206368616E67656C6F67206D657461646174612066726F6D206F
      70656E20736F757263652070726F6A6563747302000000000003000400000074
      727565040007000000756E6B6E6F776E05001500000068747470733A2F2F6368
      616E67656C6F67732E6D6406000B000000446576656C6F706D656E74FEFEFF1B
      1C0026010000FF1D00000700000043697072616E6401001E0000005365637572
      652072616E646F6D20737472696E672067656E657261746F7202000000000003
      0004000000747275650400020000006E6F05002800000068747470733A2F2F67
      69746875622E636F6D2F706F6C617273706574726F6C6C2F63697072616E6406
      000B000000446576656C6F706D656E74FEFEFF1B1C0027010000FF1D00001000
      0000436C6F7564666C61726520547261636501005F0000004765742049502041
      6464726573732C2054696D657374616D702C2055736572204167656E742C2043
      6F756E74727920436F64652C20494154412C20485454502056657273696F6E2C
      20544C532F53534C2056657273696F6E2026204D6F7265020000000000030004
      0000007472756504000300000079657305003300000068747470733A2F2F6769
      746875622E636F6D2F666177617A61686D6564302F636C6F7564666C6172652D
      74726163652D61706906000B000000446576656C6F706D656E74FEFEFF1B1C00
      28010000FF1D000005000000436F6465780100250000004F6E6C696E6520436F
      6D70696C657220666F7220566172696F7573204C616E67756167657302000000
      000003000400000074727565040007000000756E6B6E6F776E05002000000068
      747470733A2F2F6769746875622E636F6D2F4A6161677261762F436F64655806
      000B000000446576656C6F706D656E74FEFEFF1B1C0029010000FF1D00001100
      0000436F6E74656E7466756C20496D616765730100340000005573656420746F
      20726574726965766520616E64206170706C79207472616E73666F726D617469
      6F6E7320746F20696D616765730200060000006170694B657903000400000074
      72756504000300000079657305004100000068747470733A2F2F7777772E636F
      6E74656E7466756C2E636F6D2F646576656C6F706572732F646F63732F726566
      6572656E6365732F696D616765732D6170692F06000B000000446576656C6F70
      6D656E74FEFEFF1B1C002A010000FF1D00000A000000434F52532050726F7879
      0100450000004765742061726F756E6420746865206472656164656420434F52
      53206572726F72206279207573696E6720746869732070726F78792061732061
      206D6964646C65206D616E020000000000030004000000747275650400030000
      0079657305002800000068747470733A2F2F6769746875622E636F6D2F627572
      68616E756461792F636F72732D70726F787906000B000000446576656C6F706D
      656E74FEFEFF1B1C002B010000FF1D000008000000436F756E74415049010057
      0000004672656520616E642073696D706C6520636F756E74696E672073657276
      6963652E20596F752063616E2075736520697420746F20747261636B20706167
      65206869747320616E64207370656369666963206576656E7473020000000000
      0300040000007472756504000300000079657305001400000068747470733A2F
      2F636F756E746170692E78797A06000B000000446576656C6F706D656E74FEFE
      FF1B1C002C010000FF1D00000A00000044617461627269636B73010052000000
      5365727669636520746F206D616E61676520796F75722064617461627269636B
      73206163636F756E742C636C7573746572732C206E6F7465626F6F6B732C206A
      6F627320616E6420776F726B7370616365730200060000006170694B65790300
      040000007472756504000300000079657305003B00000068747470733A2F2F64
      6F63732E64617461627269636B732E636F6D2F6465762D746F6F6C732F617069
      2F6C61746573742F696E6465782E68746D6C06000B000000446576656C6F706D
      656E74FEFEFF1B1C002D010000FF1D0000130000004469676974616C4F636561
      6E20537461747573010023000000537461747573206F6620616C6C2044696769
      74616C4F6365616E207365727669636573020000000000030004000000747275
      65040007000000756E6B6E6F776E05002300000068747470733A2F2F73746174
      75732E6469676974616C6F6365616E2E636F6D2F61706906000B000000446576
      656C6F706D656E74FEFEFF1B1C002E010000FF1D00000A000000446F636B6572
      20487562010018000000496E746572616374207769746820446F636B65722048
      75620200060000006170694B6579030004000000747275650400030000007965
      7305002E00000068747470733A2F2F646F63732E646F636B65722E636F6D2F64
      6F636B65722D6875622F6170692F6C61746573742F06000B000000446576656C
      6F706D656E74FEFEFF1B1C002F010000FF1D00000D000000446F6D61696E4462
      20496E666F01004E000000446F6D61696E206E616D652073656172636820746F
      2066696E6420616C6C20646F6D61696E7320636F6E7461696E696E6720706172
      746963756C617220776F7264732F706872617365732F65746302000000000003
      000400000074727565040007000000756E6B6E6F776E05001B00000068747470
      733A2F2F6170692E646F6D61696E7364622E696E666F2F06000B000000446576
      656C6F706D656E74FEFEFF1B1C0030010000FF1D000019000000457874656E64
      73436C617373204A534F4E2053746F72616765010017000000412073696D706C
      65204A534F4E2073746F72652041504902000000000003000400000074727565
      04000300000079657305002A00000068747470733A2F2F657874656E6473636C
      6173732E636F6D2F6A736F6E2D73746F726167652E68746D6C06000B00000044
      6576656C6F706D656E74FEFEFF1B1C0031010000FF1D0000090000004765656B
      466C61726501005700000050726F76696465206E756D65726F75732063617061
      62696C697469657320666F7220696D706F7274616E742074657374696E672061
      6E64206D6F6E69746F72696E67206D6574686F647320666F7220776562736974
      65730200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05003000000068747470733A2F2F617069646F63732E6765656B66
      6C6172652E636F6D2F646F63732F6765656B666C6172652D61706906000B0000
      00446576656C6F706D656E74FEFEFF1B1C0032010000FF1D00000C0000004765
      6E646572697A652E696F010024000000457374696D6174657320612067656E64
      65722066726F6D2061206669727374206E616D65020000000000030004000000
      7472756504000300000079657305001400000068747470733A2F2F67656E6465
      72697A652E696F06000B000000446576656C6F706D656E74FEFEFF1B1C003301
      0000FF1D00000700000047455450696E67010037000000547269676765722061
      6E20656D61696C206E6F74696669636174696F6E207769746820612073696D70
      6C652047455420726571756573740200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001800000068747470733A2F2F77
      77772E67657470696E672E696E666F06000B000000446576656C6F706D656E74
      FEFEFF1B1C0034010000FF1D00000500000047686F7374010044000000476574
      205075626C697368656420636F6E74656E7420696E746F20796F757220576562
      736974652C20417070206F72206F7468657220656D626564646564206D656469
      610200060000006170694B657903000400000074727565040003000000796573
      05001200000068747470733A2F2F67686F73742E6F72672F06000B0000004465
      76656C6F706D656E74FEFEFF1B1C0035010000FF1D0000060000004769744875
      620100440000004D616B6520757365206F6620476974487562207265706F7369
      746F726965732C20636F646520616E64207573657220696E666F2070726F6772
      616D6D61746963616C6C790200050000004F4175746803000400000074727565
      04000300000079657305003400000068747470733A2F2F646F63732E67697468
      75622E636F6D2F656E2F667265652D70726F2D7465616D406C61746573742F72
      65737406000B000000446576656C6F706D656E74FEFEFF1B1C0036010000FF1D
      0000060000004769746C616201002C0000004175746F6D617465204769744C61
      6220696E746572616374696F6E2070726F6772616D6D61746963616C6C790200
      050000004F4175746803000400000074727565040007000000756E6B6E6F776E
      05001F00000068747470733A2F2F646F63732E6769746C61622E636F6D2F6565
      2F6170692F06000B000000446576656C6F706D656E74FEFEFF1B1C0037010000
      FF1D0000060000004769747465720100130000004368617420666F7220446576
      656C6F706572730200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05002800000068747470733A2F2F646576656C6F706572
      2E6769747465722E696D2F646F63732F77656C636F6D6506000B000000446576
      656C6F706D656E74FEFEFF1B1C0038010000FF1D000009000000476C69747465
      726C79010014000000496D6167652067656E65726174696F6E20415049020006
      0000006170694B65790300040000007472756504000300000079657305002000
      000068747470733A2F2F646576656C6F706572732E676C69747465726C792E61
      707006000B000000446576656C6F706D656E74FEFEFF1B1C0039010000FF1D00
      000B000000476F6F676C6520446F637301003400000041504920746F20726561
      642C2077726974652C20616E6420666F726D617420476F6F676C6520446F6373
      20646F63756D656E74730200050000004F417574680300040000007472756504
      0007000000756E6B6E6F776E05003500000068747470733A2F2F646576656C6F
      706572732E676F6F676C652E636F6D2F646F63732F6170692F7265666572656E
      63652F7265737406000B000000446576656C6F706D656E74FEFEFF1B1C003A01
      0000FF1D00000F000000476F6F676C6520466972656261736501005800000047
      6F6F676C652773206D6F62696C65206170706C69636174696F6E20646576656C
      6F706D656E7420706C6174666F726D20746861742068656C7073206275696C64
      2C20696D70726F76652C20616E642067726F7720617070020006000000617069
      4B65790300040000007472756504000300000079657305002000000068747470
      733A2F2F66697265626173652E676F6F676C652E636F6D2F646F637306000B00
      0000446576656C6F706D656E74FEFEFF1B1C003B010000FF1D00000C00000047
      6F6F676C6520466F6E74730100300000004D6574616461746120666F7220616C
      6C2066616D696C6965732073657276656420627920476F6F676C6520466F6E74
      730200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05003600000068747470733A2F2F646576656C6F706572732E676F6F
      676C652E636F6D2F666F6E74732F646F63732F646576656C6F7065725F617069
      06000B000000446576656C6F706D656E74FEFEFF1B1C003C010000FF1D00000B
      000000476F6F676C65204B65657001003000000041504920746F20726561642C
      2077726974652C20616E6420666F726D617420476F6F676C65204B656570206E
      6F7465730200050000004F417574680300040000007472756504000700000075
      6E6B6E6F776E05003500000068747470733A2F2F646576656C6F706572732E67
      6F6F676C652E636F6D2F6B6565702F6170692F7265666572656E63652F726573
      7406000B000000446576656C6F706D656E74FEFEFF1B1C003D010000FF1D0000
      0D000000476F6F676C652053686565747301003100000041504920746F207265
      61642C2077726974652C20616E6420666F726D617420476F6F676C6520536865
      65747320646174610200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05003700000068747470733A2F2F646576656C6F7065
      72732E676F6F676C652E636F6D2F7368656574732F6170692F7265666572656E
      63652F7265737406000B000000446576656C6F706D656E74FEFEFF1B1C003E01
      0000FF1D00000D000000476F6F676C6520536C6964657301003A000000415049
      20746F20726561642C2077726974652C20616E6420666F726D617420476F6F67
      6C6520536C696465732070726573656E746174696F6E730200050000004F4175
      746803000400000074727565040007000000756E6B6E6F776E05003700000068
      747470733A2F2F646576656C6F706572732E676F6F676C652E636F6D2F736C69
      6465732F6170692F7265666572656E63652F7265737406000B00000044657665
      6C6F706D656E74FEFEFF1B1C003F010000FF1D000006000000476F7265737401
      002B0000004F6E6C696E6520524553542041504920666F722054657374696E67
      20616E642050726F746F747970696E670200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05001500000068747470733A2F2F
      676F726573742E636F2E696E2F06000B000000446576656C6F706D656E74FEFE
      FF1B1C0040010000FF1D00000600000048617375726101003700000047726170
      68514C20616E6420524553542041504920456E67696E65207769746820627569
      6C7420696E20417574686F72697A6174696F6E0200060000006170694B657903
      00040000007472756504000300000079657305001D00000068747470733A2F2F
      6861737572612E696F2F6F70656E736F757263652F06000B000000446576656C
      6F706D656E74FEFEFF1B1C0041010000FF1D0000060000004865726F6B750100
      5C000000524553542041504920746F2070726F6772616D6D61746963616C6C79
      2063726561746520617070732C2070726F766973696F6E206164642D6F6E7320
      616E6420706572666F726D206F74686572207461736B206F6E204865726F6B75
      0200050000004F41757468030004000000747275650400030000007965730500
      3D00000068747470733A2F2F64657663656E7465722E6865726F6B752E636F6D
      2F61727469636C65732F706C6174666F726D2D6170692D7265666572656E6365
      2F06000B000000446576656C6F706D656E74FEFEFF1B1C0042010000FF1D0000
      0A000000686F73742D742E636F6D010024000000426173696320444E53207175
      6572792076696120485454502047455420726571756573740200000000000300
      04000000747275650400020000006E6F05001200000068747470733A2F2F686F
      73742D742E636F6D06000B000000446576656C6F706D656E74FEFEFF1B1C0043
      010000FF1D000007000000486F73742E696F01001F000000446F6D61696E7320
      446174612041504920666F7220446576656C6F70657273020006000000617069
      4B65790300040000007472756504000300000079657305000F00000068747470
      733A2F2F686F73742E696F06000B000000446576656C6F706D656E74FEFEFF1B
      1C0044010000FF1D00000900000048545450322E50726F01003C000000546573
      7420656E64706F696E747320666F7220636C69656E7420616E64207365727665
      7220485454502F322070726F746F636F6C20737570706F727402000000000003
      000400000074727565040007000000756E6B6E6F776E05001900000068747470
      733A2F2F68747470322E70726F2F646F632F61706906000B000000446576656C
      6F706D656E74FEFEFF1B1C0045010000FF1D0000070000004874747062696E01
      0028000000412053696D706C6520485454502052657175657374202620526573
      706F6E7365205365727669636502000000000003000400000074727565040003
      00000079657305001400000068747470733A2F2F6874747062696E2E6F72672F
      06000B000000446576656C6F706D656E74FEFEFF1B1C0046010000FF1D000012
      0000004874747062696E20436C6F7564666C61726501004A000000412053696D
      706C6520485454502052657175657374202620526573706F6E73652053657276
      696365207769746820485454502F3320537570706F727420627920436C6F7564
      666C617265020000000000030004000000747275650400030000007965730500
      1E00000068747470733A2F2F636C6F7564666C6172652D717569632E636F6D2F
      622F06000B000000446576656C6F706D656E74FEFEFF1B1C0047010000FF1D00
      000600000048756E74657201005200000041504920666F7220646F6D61696E20
      7365617263682C2070726F66657373696F6E616C20656D61696C2066696E6465
      722C20617574686F722066696E64657220616E6420656D61696C207665726966
      6965720200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001500000068747470733A2F2F68756E7465722E696F2F6170
      6906000B000000446576656C6F706D656E74FEFEFF1B1C0048010000FF1D0000
      1200000049424D205465787420746F20537065656368010016000000436F6E76
      657274207465787420746F207370656563680200060000006170694B65790300
      040000007472756504000300000079657305003E00000068747470733A2F2F63
      6C6F75642E69626D2E636F6D2F646F63732F746578742D746F2D737065656368
      2F67657474696E672D737461727465642E68746D6C06000B000000446576656C
      6F706D656E74FEFEFF1B1C0049010000FF1D00000C0000004963616E68617A65
      706F636801000E0000004765742045706F63682074696D650200000000000300
      040000007472756504000300000079657305001800000068747470733A2F2F69
      63616E68617A65706F63682E636F6D06000B000000446576656C6F706D656E74
      FEFEFF1B1C004A010000FF1D0000090000004963616E68617A697001000E0000
      0049502041646472657373204150490200000000000300040000007472756504
      000300000079657305002300000068747470733A2F2F6D616A6F722E696F2F69
      63616E68617A69702D636F6D2D6661712F06000B000000446576656C6F706D65
      6E74FEFEFF1B1C004B010000FF1D000005000000494654545401001100000049
      4654545420436F6E6E6563742041504902000000000003000400000074727565
      040007000000756E6B6E6F776E05002B00000068747470733A2F2F706C617466
      6F726D2E69667474742E636F6D2F646F63732F636F6E6E6563745F6170690600
      0B000000446576656C6F706D656E74FEFEFF1B1C004C010000FF1D00000C0000
      00496D6167652D43686172747301002A00000047656E65726174652063686172
      74732C20515220636F64657320616E6420677261706820696D61676573020000
      0000000300040000007472756504000300000079657305002700000068747470
      733A2F2F646F63756D656E746174696F6E2E696D6167652D6368617274732E63
      6F6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C004D010000FF1D
      000009000000696D706F72742E696F0100330000005265747269657665207374
      727563747572656420646174612066726F6D20612077656273697465206F7220
      52535320666565640200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001A000000687474703A2F2F6170692E646F6373
      2E696D706F72742E696F2F06000B000000446576656C6F706D656E74FEFEFF1B
      1C004E010000FF1D00000B00000069702D666173742E636F6D01001C00000049
      5020616464726573732C20636F756E74727920616E6420636974790200000000
      000300040000007472756504000300000079657305001900000068747470733A
      2F2F69702D666173742E636F6D2F646F63732F06000B000000446576656C6F70
      6D656E74FEFEFF1B1C004F010000FF1D00001B00000049503257484F49532049
      6E666F726D6174696F6E204C6F6F6B757001001800000057484F495320646F6D
      61696E206E616D65206C6F6F6B75700200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001900000068747470733A2F2F
      7777772E69703277686F69732E636F6D2F06000B000000446576656C6F706D65
      6E74FEFEFF1B1C0050010000FF1D000009000000697066696E642E696F010060
      00000047656F67726170686963206C6F636174696F6E206F6620616E20495020
      61646472657373206F7220616E7920646F6D61696E206E616D6520616C6F6E67
      207769746820736F6D65206F746865722075736566756C20696E666F726D6174
      696F6E0200060000006170694B65790300040000007472756504000300000079
      657305001100000068747470733A2F2F697066696E642E696F06000B00000044
      6576656C6F706D656E74FEFEFF1B1C0051010000FF1D00000500000049506966
      79010017000000412073696D706C652049502041646472657373204150490200
      0000000003000400000074727565040007000000756E6B6E6F776E0500160000
      0068747470733A2F2F7777772E69706966792E6F72672F06000B000000446576
      656C6F706D656E74FEFEFF1B1C0052010000FF1D0000060000004950696E666F
      01001D000000416E6F746865722073696D706C65204950204164647265737320
      41504902000000000003000400000074727565040007000000756E6B6E6F776E
      05001C00000068747470733A2F2F6970696E666F2E696F2F646576656C6F7065
      727306000B000000446576656C6F706D656E74FEFEFF1B1C0053010000FF1D00
      00080000006A7344656C69767201002F0000005061636B61676520696E666F20
      616E6420646F776E6C6F6164207374617473206F6E206A7344656C6976722043
      444E0200000000000300040000007472756504000300000079657305002D0000
      0068747470733A2F2F6769746875622E636F6D2F6A7364656C6976722F646174
      612E6A7364656C6976722E636F6D06000B000000446576656C6F706D656E74FE
      FEFF1B1C0054010000FF1D00000C0000004A534F4E2032204A534F4E50010063
      000000436F6E76657274204A534F4E20746F204A534F4E5020286F6E2D746865
      2D666C792920666F7220656173792063726F73732D646F6D61696E2064617461
      207265717565737473207573696E6720636C69656E742D73696465204A617661
      53637269707402000000000003000400000074727565040007000000756E6B6E
      6F776E05001700000068747470733A2F2F6A736F6E326A736F6E702E636F6D2F
      06000B000000446576656C6F706D656E74FEFEFF1B1C0055010000FF1D00000A
      0000004A534F4E62696E2E696F01005300000046726565204A534F4E2073746F
      7261676520736572766963652E20496465616C20666F7220736D616C6C207363
      616C652057656220617070732C20576562736974657320616E64204D6F62696C
      6520617070730200060000006170694B65790300040000007472756504000300
      000079657305001200000068747470733A2F2F6A736F6E62696E2E696F06000B
      000000446576656C6F706D656E74FEFEFF1B1C0056010000FF1D000005000000
      4B726F6B6901002A00000043726561746573206469616772616D732066726F6D
      207465787475616C206465736372697074696F6E730200000000000300040000
      007472756504000300000079657305001000000068747470733A2F2F6B726F6B
      692E696F06000B000000446576656C6F706D656E74FEFEFF1B1C0057010000FF
      1D00000B0000004C6963656E73652D41504901002A000000556E6F6666696369
      616C20524553542041504920666F722063686F6F7365616C6963656E73652E63
      6F6D020000000000030004000000747275650400020000006E6F050040000000
      68747470733A2F2F6769746875622E636F6D2F636D6363616E646C6573732F6C
      6963656E73652D6170692F626C6F622F6D61737465722F524541444D452E6D64
      06000B000000446576656C6F706D656E74FEFEFF1B1C0058010000FF1D000007
      0000004C6F67732E746F01000D00000047656E6572617465206C6F6773020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001000000068747470733A2F2F6C6F67732E746F2F06000B00000044657665
      6C6F706D656E74FEFEFF1B1C0059010000FF1D00000E0000004C756120446563
      6F6D70696C65720100190000004F6E6C696E65204C756120352E31204465636F
      6D70696C65720200000000000300040000007472756504000300000079657305
      002100000068747470733A2F2F6C75612D6465636F6D70696C65722E66657269
      622E6465762F06000B000000446576656C6F706D656E74FEFEFF1B1C005A0100
      00FF1D0000190000004D414320616464726573732076656E646F72206C6F6F6B
      757001005500000052657472696576652076656E646F722064657461696C7320
      616E64206F7468657220696E666F726D6174696F6E20726567617264696E6720
      6120676976656E204D41432061646472657373206F7220616E204F5549020006
      0000006170694B65790300040000007472756504000300000079657305001900
      000068747470733A2F2F6D6163616464726573732E696F2F61706906000B0000
      00446576656C6F706D656E74FEFEFF1B1C005B010000FF1D0000080000004D69
      63726F20444201001700000053696D706C652064617461626173652073657276
      6963650200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001200000068747470733A2F2F6D336F2E636F6D2F64620600
      0B000000446576656C6F706D656E74FEFEFF1B1C005C010000FF1D0000080000
      004D6963726F454E5601001C00000046616B6520526573742041504920666F72
      20646576656C6F70657273020000000000030004000000747275650400070000
      00756E6B6E6F776E05001500000068747470733A2F2F6D6963726F656E762E63
      6F6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C005D010000FF1D
      0000050000004D6F636B790100320000004D6F636B207573657220646566696E
      65642074657374204A534F4E20666F7220524553542041504920656E64706F69
      6E74730200000000000300040000007472756504000300000079657305001A00
      000068747470733A2F2F64657369676E65722E6D6F636B792E696F2F06000B00
      0000446576656C6F706D656E74FEFEFF1B1C005E010000FF1D0000050000004D
      5920495001001A000000476574204950206164647265737320696E666F726D61
      74696F6E02000000000003000400000074727565040007000000756E6B6E6F77
      6E05001E00000068747470733A2F2F7777772E6D7969702E636F6D2F6170692D
      646F63732F06000B000000446576656C6F706D656E74FEFEFF1B1C005F010000
      FF1D00000E0000004E6174696F6E616C697A652E696F01002800000045737469
      6D61746520746865206E6174696F6E616C697479206F66206120666972737420
      6E616D6502000000000003000400000074727565040003000000796573050016
      00000068747470733A2F2F6E6174696F6E616C697A652E696F06000B00000044
      6576656C6F706D656E74FEFEFF1B1C0060010000FF1D0000070000004E65746C
      6966790100350000004E65746C696679206973206120686F7374696E67207365
      727669636520666F72207468652070726F6772616D6D61626C65207765620200
      050000004F4175746803000400000074727565040007000000756E6B6E6F776E
      05002900000068747470733A2F2F646F63732E6E65746C6966792E636F6D2F61
      70692F6765742D737461727465642F06000B000000446576656C6F706D656E74
      FEFEFF1B1C0061010000FF1D00000B0000004E6574776F726B43616C63010047
      0000004E6574776F726B2063616C63756C61746F72732C20696E636C7564696E
      67207375626E6574732C20444E532C2062696E6172792C20616E642073656375
      7269747920746F6F6C7302000000000003000400000074727565040003000000
      79657305002000000068747470733A2F2F6E6574776F726B63616C632E636F6D
      2F6170692F646F637306000B000000446576656C6F706D656E74FEFEFF1B1C00
      62010000FF1D00000C0000006E706D2052656769737472790100470000005175
      65727920696E666F726D6174696F6E2061626F757420796F7572206661766F72
      697465204E6F64652E6A73206C69627261726965732070726F6772616D617469
      63616C6C7902000000000003000400000074727565040007000000756E6B6E6F
      776E05004000000068747470733A2F2F6769746875622E636F6D2F6E706D2F72
      656769737472792F626C6F622F6D61737465722F646F63732F52454749535452
      592D4150492E6D6406000B000000446576656C6F706D656E74FEFEFF1B1C0063
      010000FF1D0000090000004F6E655369676E616C01005300000053656C662D73
      6572766520637573746F6D657220656E676167656D656E7420736F6C7574696F
      6E20666F722050757368204E6F74696669636174696F6E732C20456D61696C2C
      20534D53202620496E2D4170700200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05003600000068747470733A2F2F646F
      63756D656E746174696F6E2E6F6E657369676E616C2E636F6D2F646F63732F6F
      6E657369676E616C2D61706906000B000000446576656C6F706D656E74FEFEFF
      1B1C0064010000FF1D00000E0000004F70656E20506167652052616E6B010059
      00000041504920666F722063616C63756C6174696E6720616E6420636F6D7061
      72696E67206D657472696373206F6620646966666572656E7420776562736974
      6573207573696E6720506167652052616E6B20616C676F726974686D02000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      002400000068747470733A2F2F7777772E646F6D636F702E636F6D2F6F70656E
      7061676572616E6B2F06000B000000446576656C6F706D656E74FEFEFF1B1C00
      65010000FF1D00000A0000004F70656E41504948756201001B00000054686520
      416C6C2D696E2D6F6E652041504920506C6174666F726D02000D000000582D4D
      6173686170652D4B657903000400000074727565040007000000756E6B6E6F77
      6E05001B00000068747470733A2F2F6875622E6F70656E6170696875622E636F
      6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C0066010000FF1D00
      000A0000004F70656E4772617068720100390000005265616C6C792073696D70
      6C652041504920746F207265747269657665204F70656E204772617068206461
      74612066726F6D20616E2055524C0200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05002800000068747470733A2F2F6F
      70656E6772617068722E636F6D2F646F63732F312E302F6F7665727669657706
      000B000000446576656C6F706D656E74FEFEFF1B1C0067010000FF1D00000400
      00006F79796901006200000041504920666F722046616B6520446174612C2069
      6D6167652F766964656F20636F6E76657273696F6E2C206F7074696D697A6174
      696F6E2C20706466206F7074696D697A6174696F6E20616E64207468756D626E
      61696C2067656E65726174696F6E020000000000030004000000747275650400
      0300000079657305001900000068747470733A2F2F6F7979692E78797A2F646F
      63732F312E3006000B000000446576656C6F706D656E74FEFEFF1B1C00680100
      00FF1D0000070000005061676543444E01003C0000005075626C696320415049
      20666F72206A6176617363726970742C2063737320616E6420666F6E74206C69
      62726172696573206F6E205061676543444E0200060000006170694B65790300
      040000007472756504000300000079657305002300000068747470733A2F2F70
      61676563646E2E636F6D2F646F63732F7075626C69632D61706906000B000000
      446576656C6F706D656E74FEFEFF1B1C0069010000FF1D000007000000506F73
      746D616E010015000000546F6F6C20666F722074657374696E67204150497302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05007E00000068747470733A2F2F7777772E706F73746D616E2E636F6D2F
      706F73746D616E2F776F726B73706163652F706F73746D616E2D7075626C6963
      2D776F726B73706163652F646F63756D656E746174696F6E2F31323935393534
      322D63383134326435312D653937632D343662362D626437372D353262623636
      37313263396106000B000000446576656C6F706D656E74FEFEFF1B1C006A0100
      00FF1D00000A00000050726F7879437261776C0100290000005363726170696E
      6720616E6420637261776C696E6720616E746963617074636861207365727669
      63650200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05001600000068747470733A2F2F70726F7879637261776C2E636F
      6D06000B000000446576656C6F706D656E74FEFEFF1B1C006B010000FF1D0000
      0C00000050726F78794B696E67646F6D010041000000526F746174696E672050
      726F78792041504920746861742070726F6475636573206120776F726B696E67
      2070726F7879206F6E2065766572792072657175657374020006000000617069
      4B65790300040000007472756504000300000079657305001800000068747470
      733A2F2F70726F78796B696E67646F6D2E636F6D06000B000000446576656C6F
      706D656E74FEFEFF1B1C006C010000FF1D00000C000000507573686572204265
      616D7301002400000050757368206E6F74696669636174696F6E7320666F7220
      416E64726F6964202620694F530200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001800000068747470733A2F2F7075
      736865722E636F6D2F6265616D7306000B000000446576656C6F706D656E74FE
      FEFF1B1C006D010000FF1D000007000000515220636F64650100300000004372
      6561746520616E206561737920746F207265616420515220636F646520616E64
      2055524C2073686F7274656E6572020000000000030004000000747275650400
      0300000079657305001A00000068747470733A2F2F7777772E71727461672E6E
      65742F6170692F06000B000000446576656C6F706D656E74FEFEFF1B1C006E01
      0000FF1D000007000000515220636F646501002B00000047656E657261746520
      616E64206465636F6465202F207265616420515220636F646520677261706869
      637302000000000003000400000074727565040007000000756E6B6E6F776E05
      0013000000687474703A2F2F676F71722E6D652F6170692F06000B0000004465
      76656C6F706D656E74FEFEFF1B1C006F010000FF1D00000D0000005172636F64
      65204D6F6E6B6579010049000000496E7465677261746520637573746F6D2061
      6E6420756E69717565206C6F6F6B696E6720515220636F64657320696E746F20
      796F75722073797374656D206F7220776F726B666C6F77020000000000030004
      00000074727565040007000000756E6B6E6F776E05003400000068747470733A
      2F2F7777772E7172636F64652D6D6F6E6B65792E636F6D2F71722D636F64652D
      6170692D776974682D6C6F676F2F06000B000000446576656C6F706D656E74FE
      FEFF1B1C0070010000FF1D00000A000000517569636B436861727401001F0000
      0047656E657261746520636861727420616E6420677261706820696D61676573
      0200000000000300040000007472756504000300000079657305001600000068
      747470733A2F2F717569636B63686172742E696F2F06000B000000446576656C
      6F706D656E74FEFEFF1B1C0071010000FF1D00000C00000052616E646F6D2053
      7475666601005300000043616E206265207573656420746F2067657420414920
      526573706F6E73652C206A6F6B65732C206D656D65732C20616E64206D756368
      206D6F7265206174206C696768746E696E672D66617374207370656564020006
      0000006170694B65790300040000007472756504000300000079657305001D00
      000068747470733A2F2F6170692D646F63732E7067616D6572782E636F6D2F06
      000B000000446576656C6F706D656E74FEFEFF1B1C0072010000FF1D00000500
      000052656A61780100260000005265766572736520414A415820736572766963
      6520746F206E6F7469667920636C69656E74730200060000006170694B657903
      0004000000747275650400020000006E6F05001100000068747470733A2F2F72
      656A61782E696F2F06000B000000446576656C6F706D656E74FEFEFF1B1C0073
      010000FF1D0000060000005265715265730100380000004120686F7374656420
      524553542D41504920726561647920746F20726573706F6E6420746F20796F75
      7220414A41582072657175657374730200000000000300040000007472756504
      0007000000756E6B6E6F776E05001300000068747470733A2F2F726571726573
      2E696E2F2006000B000000446576656C6F706D656E74FEFEFF1B1C0074010000
      FF1D000010000000525353206665656420746F204A534F4E01002E0000005265
      7475726E7320525353206665656420696E204A534F4E20666F726D6174207573
      696E6720666565642055524C0200000000000300040000007472756504000300
      000079657305002D00000068747470733A2F2F7273732D746F2D6A736F6E2D73
      65727665726C6573732D6170692E76657263656C2E61707006000B0000004465
      76656C6F706D656E74FEFEFF1B1C0075010000FF1D00000B0000005361766550
      6167652E696F0100450000004120667265652C205245535466756C2041504920
      7573656420746F2073637265656E73686F7420616E79206465736B746F702C20
      6F72206D6F62696C6520776562736974650200060000006170694B6579030004
      0000007472756504000300000079657305001700000068747470733A2F2F7777
      772E73617665706167652E696F06000B000000446576656C6F706D656E74FEFE
      FF1B1C0076010000FF1D00000B0000005363726170654E696E6A6101003C0000
      005363726170696E67204150492077697468204368726F6D652066696E676572
      7072696E7420616E64207265736964656E7469616C2070726F78696573020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001700000068747470733A2F2F7363726170656E696E6A612E6E657406000B
      000000446576656C6F706D656E74FEFEFF1B1C0077010000FF1D00000A000000
      53637261706572417069010022000000456173696C79206275696C6420736361
      6C61626C65207765622073637261706572730200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E05001A0000006874747073
      3A2F2F7777772E736372617065726170692E636F6D06000B000000446576656C
      6F706D656E74FEFEFF1B1C0078010000FF1D00000A0000007363726170657242
      6F7801001D000000556E64657465637461626C6520776562207363726170696E
      67204150490200060000006170694B6579030004000000747275650400030000
      0079657305001700000068747470733A2F2F73637261706572626F782E636F6D
      2F06000B000000446576656C6F706D656E74FEFEFF1B1C0079010000FF1D0000
      0B000000736372617065737461636B0100310000005265616C2D74696D652C20
      5363616C61626C652050726F7879202620576562205363726170696E67205245
      5354204150490200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001800000068747470733A2F2F736372617065737461
      636B2E636F6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C007A01
      0000FF1D00000B0000005363726170696E67416E7401002A000000486561646C
      657373204368726F6D65207363726170696E67207769746820612073696D706C
      65204150490200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001700000068747470733A2F2F7363726170696E67616E
      742E636F6D06000B000000446576656C6F706D656E74FEFEFF1B1C007B010000
      FF1D00000B0000005363726170696E67446F6701001A00000050726F78792041
      504920666F7220576562207363726170696E670200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001C00000068747470
      733A2F2F7777772E7363726170696E67646F672E636F6D2F06000B0000004465
      76656C6F706D656E74FEFEFF1B1C007C010000FF1D0000110000005363726565
      6E73686F744150492E6E657401002800000043726561746520706978656C2D70
      65726665637420776562736974652073637265656E73686F7473020006000000
      6170694B65790300040000007472756504000300000079657305001A00000068
      747470733A2F2F73637265656E73686F746170692E6E65742F06000B00000044
      6576656C6F706D656E74FEFEFF1B1C007D010000FF1D00000E00000053657269
      616C696620436F6C6F7201003E000000436F6C6F7220636F6E76657273696F6E
      2C20636F6D706C656D656E746172792C20677261797363616C6520616E642063
      6F6E747261737465642074657874020000000000030004000000747275650400
      020000006E6F05001B00000068747470733A2F2F636F6C6F722E73657269616C
      69662E636F6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C007E01
      0000FF1D00000900000073657270737461636B01002E0000005265616C2D5469
      6D65202620416363757261746520476F6F676C65205365617263682052657375
      6C7473204150490200060000006170694B657903000400000074727565040003
      00000079657305001600000068747470733A2F2F73657270737461636B2E636F
      6D2F06000B000000446576656C6F706D656E74FEFEFF1B1C007F010000FF1D00
      00070000005368656574737501001E0000004561737920676F6F676C65207368
      6565747320696E746567726174696F6E0200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001400000068747470733A2F
      2F736865657473752E636F6D2F06000B000000446576656C6F706D656E74FEFE
      FF1B1C0080010000FF1D00000A00000053484F5554434C4F5544010015000000
      414C4C2D43415053204153204120534552564943450200000000000300050000
      0066616C7365040007000000756E6B6E6F776E050015000000687474703A2F2F
      73686F7574636C6F75642E696F2F06000B000000446576656C6F706D656E74FE
      FEFF1B1C0081010000FF1D000005000000536F6E617201002100000050726F6A
      65637420536F6E617220444E5320456E756D65726174696F6E20415049020000
      0000000300040000007472756504000300000079657305002500000068747470
      733A2F2F6769746875622E636F6D2F4367626F616C2F536F6E61725365617263
      6806000B000000446576656C6F706D656E74FEFEFF1B1C0082010000FF1D0000
      09000000536F6E61725175626501004A000000536F6E61725175626520524553
      54204150497320746F2064657465637420627567732C20636F646520736D656C
      6C7320262073656375726974792076756C6E65726162696C6974696573020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      001D00000068747470733A2F2F736F6E6172636C6F75642E696F2F7765625F61
      706906000B000000446576656C6F706D656E74FEFEFF1B1C0083010000FF1D00
      000D000000537461636B45786368616E676501001800000051264120666F7275
      6D20666F7220646576656C6F706572730200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05001E00000068747470733A2F2F
      6170692E737461636B65786368616E67652E636F6D2F06000B00000044657665
      6C6F706D656E74FEFEFF1B1C0084010000FF1D00000A00000053746174696361
      6C6C790100190000004120667265652043444E20666F7220646576656C6F7065
      7273020000000000030004000000747275650400030000007965730500160000
      0068747470733A2F2F737461746963616C6C792E696F2F06000B000000446576
      656C6F706D656E74FEFEFF1B1C0085010000FF1D00000F000000537570706F72
      746976656B6F616C610100210000004175746F67656E657261746520696D6167
      657320776974682074656D706C6174650200060000006170694B657903000400
      00007472756504000300000079657305002700000068747470733A2F2F646576
      656C6F706572732E737570706F72746976656B6F616C612E636F6D2F06000B00
      0000446576656C6F706D656E74FEFEFF1B1C0086010000FF1D00000300000054
      796B01002300000041706920616E642073657276696365206D616E6167656D65
      6E7420706C6174666F726D0200060000006170694B6579030004000000747275
      6504000300000079657305001B00000068747470733A2F2F74796B2E696F2F6F
      70656E2D736F757263652F06000B000000446576656C6F706D656E74FEFEFF1B
      1C0087010000FF1D00000700000057616E64626F7801003F000000436F646520
      636F6D70696C657220737570706F7274696E672033352B206C616E6775616765
      73206D656E74696F6E65642061742077616E64626F782E6F7267020000000000
      03000400000074727565040007000000756E6B6E6F776E05003D000000687474
      70733A2F2F6769746875622E636F6D2F6D656C706F6E2F77616E64626F782F62
      6C6F622F6D61737465722F6B656E6E656C322F4150492E72737406000B000000
      446576656C6F706D656E74FEFEFF1B1C0088010000FF1D00000E000000576562
      5363726170696E672E4149010037000000576562205363726170696E67204150
      492077697468206275696C742D696E2070726F7869657320616E64204A532072
      656E646572696E670200060000006170694B6579030004000000747275650400
      0300000079657305001700000068747470733A2F2F7765627363726170696E67
      2E61692F06000B000000446576656C6F706D656E74FEFEFF1B1C0089010000FF
      1D0000070000005A656E526F7773010063000000576562205363726170696E67
      20415049207468617420627970617373657320616E74692D626F7420736F6C75
      74696F6E73207768696C65206F66666572696E67204A532072656E646572696E
      672C20616E6420726F746174696E672070726F78696573020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050018000000
      68747470733A2F2F7777772E7A656E726F77732E636F6D2F06000B0000004465
      76656C6F706D656E74FEFEFF1B1C008A010000FF1D0000150000004368696E65
      736520436861726163746572205765620100300000004368696E657365206368
      6172616374657220646566696E6974696F6E7320616E642070726F6E756E6369
      6174696F6E7302000000000003000500000066616C73650400020000006E6F05
      0018000000687474703A2F2F636364622E68656D696F6C612E636F6D2F06000C
      00000044696374696F6E6172696573FEFEFF1B1C008B010000FF1D0000140000
      004368696E65736520546578742050726F6A65637401003F0000004F6E6C696E
      65206F70656E2D616363657373206469676974616C206C69627261727920666F
      72207072652D6D6F6465726E204368696E657365207465787473020000000000
      03000400000074727565040007000000756E6B6E6F776E05001B000000687474
      70733A2F2F63746578742E6F72672F746F6F6C732F61706906000C0000004469
      6374696F6E6172696573FEFEFF1B1C008C010000FF1D000007000000436F6C6C
      696E7301002700000042696C696E6775616C2044696374696F6E61727920616E
      642054686573617572757320446174610200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05003C00000068747470733A2F
      2F6170692E636F6C6C696E7364696374696F6E6172792E636F6D2F6170692F76
      312F646F63756D656E746174696F6E2F68746D6C2F06000C0000004469637469
      6F6E6172696573FEFEFF1B1C008D010000FF1D00000F00000046726565204469
      6374696F6E61727901004C000000446566696E6974696F6E732C2070686F6E65
      746963732C2070726F6E6F756E63696174696F6E732C207061727473206F6620
      7370656563682C206578616D706C65732C2073796E6F6E796D73020000000000
      03000400000074727565040007000000756E6B6E6F776E05001A000000687474
      70733A2F2F64696374696F6E6172796170692E6465762F06000C000000446963
      74696F6E6172696573FEFEFF1B1C008E010000FF1D000014000000496E646F6E
      657369612044696374696F6E61727901001F000000496E646F6E657369612064
      696374696F6E617279206D616E7920776F726473020000000000030004000000
      74727565040007000000756E6B6E6F776E05002300000068747470733A2F2F6E
      65772D6B6262692D6170692E6865726F6B756170702E636F6D2F06000C000000
      44696374696F6E6172696573FEFEFF1B1C008F010000FF1D00000C0000004C69
      6E67756120526F626F7401003F000000576F726420646566696E6974696F6E73
      2C2070726F6E756E63696174696F6E732C2073796E6F6E796D732C20616E746F
      6E796D7320616E64206F74686572730200060000006170694B65790300040000
      007472756504000300000079657305001A00000068747470733A2F2F7777772E
      6C696E677561726F626F742E696F06000C00000044696374696F6E6172696573
      FEFEFF1B1C0090010000FF1D00000F0000004D65727269616D2D576562737465
      7201001D00000044696374696F6E61727920616E642054686573617572757320
      446174610200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001A00000068747470733A2F2F64696374696F6E61727961
      70692E636F6D2F06000C00000044696374696F6E6172696573FEFEFF1B1C0091
      010000FF1D0000060000004F776C426F74010038000000446566696E6974696F
      6E732077697468206578616D706C652073656E74656E636520616E642070686F
      746F20696620617661696C61626C650200060000006170694B65790300040000
      007472756504000300000079657305001400000068747470733A2F2F6F776C62
      6F742E696E666F2F06000C00000044696374696F6E6172696573FEFEFF1B1C00
      92010000FF1D0000060000004F78666F726401000F00000044696374696F6E61
      727920446174610200060000006170694B657903000400000074727565040002
      0000006E6F05002900000068747470733A2F2F646576656C6F7065722E6F7866
      6F726464696374696F6E61726965732E636F6D2F06000C00000044696374696F
      6E6172696573FEFEFF1B1C0093010000FF1D00000800000053796E6F6E796D73
      01003F00000053796E6F6E796D732C2074686573617572757320616E6420616E
      746F6E796D7320696E666F726D6174696F6E20666F7220616E7920676976656E
      20776F72640200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05002900000068747470733A2F2F7777772E73796E6F6E79
      6D732E636F6D2F73796E6F6E796D735F6170692E70687006000C000000446963
      74696F6E6172696573FEFEFF1B1C0094010000FF1D00000A00000057696B7469
      6F6E61727901001D000000436F6C6C61626F7261746976652064696374696F6E
      6172792064617461020000000000030004000000747275650400030000007965
      7305002300000068747470733A2F2F656E2E77696B74696F6E6172792E6F7267
      2F772F6170692E70687006000C00000044696374696F6E6172696573FEFEFF1B
      1C0095010000FF1D000007000000576F72646E696B01000F0000004469637469
      6F6E61727920446174610200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05001D00000068747470733A2F2F646576656C
      6F7065722E776F72646E696B2E636F6D06000C00000044696374696F6E617269
      6573FEFEFF1B1C0096010000FF1D000005000000576F72647301003400000044
      6566696E6974696F6E7320616E642073796E6F6E796D7320666F72206D6F7265
      207468616E203135302C30303020776F7264730200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001E00000068747470
      733A2F2F7777772E776F7264736170692E636F6D2F646F63732F06000C000000
      44696374696F6E6172696573FEFEFF1B1C0097010000FF1D0000080000004169
      727461626C65010017000000496E746567726174652077697468204169727461
      626C650200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001800000068747470733A2F2F6169727461626C652E636F6D
      2F617069060018000000446F63756D656E747320262050726F64756374697669
      7479FEFEFF1B1C0098010000FF1D00000B00000041706932436F6E7665727401
      001A0000004F6E6C696E652046696C6520436F6E76657273696F6E2041504902
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001C00000068747470733A2F2F7777772E61706932636F6E766572742E
      636F6D2F060018000000446F63756D656E747320262050726F64756374697669
      7479FEFEFF1B1C0099010000FF1D0000110000006170696C6179657220706466
      6C6179657201000F00000048544D4C2F55524C20746F20504446020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050014
      00000068747470733A2F2F7064666C617965722E636F6D060018000000446F63
      756D656E747320262050726F647563746976697479FEFEFF1B1C009A010000FF
      1D0000050000004173616E6101003400000050726F6772616D6D617469632061
      636365737320746F20616C6C206461746120696E20796F7572206173616E6120
      73797374656D0200060000006170694B65790300040000007472756504000300
      000079657305002100000068747470733A2F2F646576656C6F706572732E6173
      616E612E636F6D2F646F6373060018000000446F63756D656E74732026205072
      6F647563746976697479FEFEFF1B1C009B010000FF1D000007000000436C6963
      6B5570010052000000436C69636B5570206973206120726F627573742C20636C
      6F75642D62617365642070726F6A656374206D616E6167656D656E7420746F6F
      6C20666F7220626F6F7374696E672070726F6475637469766974790200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050017
      00000068747470733A2F2F636C69636B75702E636F6D2F617069060018000000
      446F63756D656E747320262050726F647563746976697479FEFEFF1B1C009C01
      0000FF1D000008000000436C6F636B696679010064000000436C6F636B696679
      277320524553542D6261736564204150492063616E206265207573656420746F
      20707573682F70756C6C206461746120746F2F66726F6D206974202620696E74
      6567726174652069742077697468206F746865722073797374656D7302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      002300000068747470733A2F2F636C6F636B6966792E6D652F646576656C6F70
      6572732D61706920060018000000446F63756D656E747320262050726F647563
      746976697479FEFEFF1B1C009D010000FF1D00000C000000436C6F7564436F6E
      766572740100620000004F6E6C696E652066696C6520636F6E76657274657220
      666F7220617564696F2C20766964656F2C20646F63756D656E742C2065626F6F
      6B2C20617263686976652C20696D6167652C2073707265616473686565742C20
      70726573656E746174696F6E0200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05001F00000068747470733A2F2F636C6F
      7564636F6E766572742E636F6D2F6170692F7632060018000000446F63756D65
      6E747320262050726F647563746976697479FEFEFF1B1C009E010000FF1D0000
      29000000436C6F75646D65727369766520446F63756D656E7420616E64204461
      746120436F6E76657273696F6E01003E00000048544D4C2F55524C20746F2050
      44462F504E472C204F666669636520646F63756D656E747320746F205044462C
      20696D61676520636F6E76657273696F6E0200060000006170694B6579030004
      0000007472756504000300000079657305002400000068747470733A2F2F636C
      6F75646D6572736976652E636F6D2F636F6E766572742D617069060018000000
      446F63756D656E747320262050726F647563746976697479FEFEFF1B1C009F01
      0000FF1D00000B000000436F64653A3A53746174730100270000004175746F6D
      617469632074696D6520747261636B696E6720666F722070726F6772616D6D65
      72730200060000006170694B6579030004000000747275650400020000006E6F
      05001E00000068747470733A2F2F636F646573746174732E6E65742F6170692D
      646F6373060018000000446F63756D656E747320262050726F64756374697669
      7479FEFEFF1B1C00A0010000FF1D00000A00000043726166744D795044460100
      5200000047656E65726174652050444620646F63756D656E74732066726F6D20
      74656D706C61746573207769746820612064726F702D616E642D64726F702065
      6469746F7220616E6420612073696D706C65204150490200060000006170694B
      6579030004000000747275650400020000006E6F05001600000068747470733A
      2F2F63726166746D797064662E636F6D060018000000446F63756D656E747320
      262050726F647563746976697479FEFEFF1B1C00A1010000FF1D000008000000
      466C6F776461736801001B0000004175746F6D61746520627573696E65737320
      776F726B666C6F77730200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05002F00000068747470733A2F2F646F63732E66
      6C6F77646173682E636F6D2F646F63732F6170692D696E74726F64756374696F
      6E060018000000446F63756D656E747320262050726F647563746976697479FE
      FEFF1B1C00A2010000FF1D00000800000048746D6C3250444601000F00000048
      544D4C2F55524C20746F205044460200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001500000068747470733A2F2F68
      746D6C327064662E6170702F060018000000446F63756D656E74732026205072
      6F647563746976697479FEFEFF1B1C00A3010000FF1D000008000000694C6F76
      6550444601005F000000436F6E766572742C206D657267652C2073706C69742C
      2065787472616374207465787420616E64206164642070616765206E756D6265
      727320666F7220504446732E204672656520666F722032353020646F63756D65
      6E74732F6D6F6E74680200060000006170694B65790300040000007472756504
      000300000079657305001F00000068747470733A2F2F646576656C6F7065722E
      696C6F76657064662E636F6D2F060018000000446F63756D656E747320262050
      726F647563746976697479FEFEFF1B1C00A4010000FF1D0000040000004A4952
      410100620000004A49524120697320612070726F707269657461727920697373
      756520747261636B696E672070726F64756374207468617420616C6C6F777320
      62756720747261636B696E6720616E64206167696C652070726F6A656374206D
      616E6167656D656E740200050000004F41757468030004000000747275650400
      07000000756E6B6E6F776E05003F00000068747470733A2F2F646576656C6F70
      65722E61746C61737369616E2E636F6D2F7365727665722F6A6972612F706C61
      74666F726D2F726573742D617069732F060018000000446F63756D656E747320
      262050726F647563746976697479FEFEFF1B1C00A5010000FF1D00000A000000
      4D61747465726D6F7374010033000000416E206F70656E20736F757263652070
      6C6174666F726D20666F7220646576656C6F70657220636F6C6C61626F726174
      696F6E0200050000004F4175746803000400000074727565040007000000756E
      6B6E6F776E05001B00000068747470733A2F2F6170692E6D61747465726D6F73
      742E636F6D2F060018000000446F63756D656E747320262050726F6475637469
      76697479FEFEFF1B1C00A6010000FF1D0000070000004D65726375727901000A
      000000576562207061727365720200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05002900000068747470733A2F2F6D65
      72637572792E706F73746C696768742E636F6D2F7765622D7061727365722F06
      0018000000446F63756D656E747320262050726F647563746976697479FEFEFF
      1B1C00A7010000FF1D0000060000004D6F6E64617901004300000050726F6772
      616D6D61746963616C6C792061636365737320616E6420757064617465206461
      746120696E736964652061206D6F6E6461792E636F6D206163636F756E740200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05002500000068747470733A2F2F6170692E646576656C6F7065722E6D6F6E
      6461792E636F6D2F646F6373060018000000446F63756D656E74732026205072
      6F647563746976697479FEFEFF1B1C00A8010000FF1D0000060000004E6F7469
      6F6E010015000000496E746567726174652077697468204E6F74696F6E020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      003200000068747470733A2F2F646576656C6F706572732E6E6F74696F6E2E63
      6F6D2F646F63732F67657474696E672D73746172746564060018000000446F63
      756D656E747320262050726F647563746976697479FEFEFF1B1C00A9010000FF
      1D00000800000050616E6461446F6301001A000000446F6347656E20616E6420
      655369676E617475726573204150490200060000006170694B65790300040000
      00747275650400020000006E6F05001F00000068747470733A2F2F646576656C
      6F706572732E70616E6461646F632E636F6D060018000000446F63756D656E74
      7320262050726F647563746976697479FEFEFF1B1C00AA010000FF1D00000600
      0000506F636B6574010013000000426F6F6B6D61726B696E6720736572766963
      650200050000004F4175746803000400000074727565040007000000756E6B6E
      6F776E05002000000068747470733A2F2F676574706F636B65742E636F6D2F64
      6576656C6F7065722F060018000000446F63756D656E747320262050726F6475
      63746976697479FEFEFF1B1C00AB010000FF1D000005000000506F64696F0100
      1D00000046696C652073686172696E6720616E642070726F6475637469766974
      790200050000004F4175746803000400000074727565040007000000756E6B6E
      6F776E05001C00000068747470733A2F2F646576656C6F706572732E706F6469
      6F2E636F6D060018000000446F63756D656E747320262050726F647563746976
      697479FEFEFF1B1C00AC010000FF1D000008000000507265785669657701002B
      000000446174612066726F6D20584D4C206F72204A534F4E20746F205044462C
      2048544D4C206F7220496D6167650200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001400000068747470733A2F2F70
      726578766965772E636F6D060018000000446F63756D656E747320262050726F
      647563746976697479FEFEFF1B1C00AD010000FF1D0000080000005265737470
      61636B01003C00000050726F76696465732073637265656E73686F742C204854
      4D4C20746F2050444620616E6420636F6E74656E742065787472616374696F6E
      20415049730200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001400000068747470733A2F2F726573747061636B2E69
      6F2F060018000000446F63756D656E747320262050726F647563746976697479
      FEFEFF1B1C00AE010000FF1D000007000000546F646F69737401000A00000054
      6F646F204C697374730200050000004F41757468030004000000747275650400
      07000000756E6B6E6F776E05001D00000068747470733A2F2F646576656C6F70
      65722E746F646F6973742E636F6D060018000000446F63756D656E7473202620
      50726F647563746976697479FEFEFF1B1C00AF010000FF1D00001B000000536D
      61727420496D61676520456E68616E63656D656E742041504901006000000050
      6572666F726D7320696D6167652075707363616C696E6720627920616464696E
      672064657461696C20746F20696D61676573207468726F756768206D756C7469
      706C652073757065722D7265736F6C7574696F6E20616C676F726974686D7302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05003600000068747470733A2F2F6170696C617965722E636F6D2F6D6172
      6B6574706C6163652F696D6167655F656E68616E63656D656E742D6170690600
      18000000446F63756D656E747320262050726F647563746976697479FEFEFF1B
      1C00B0010000FF1D000013000000566563746F7220457870726573732076322E
      3001001F0000004672656520766563746F722066696C6520636F6E7665727469
      6E6720415049020000000000030004000000747275650400020000006E6F0500
      1600000068747470733A2F2F766563746F722E65787072657373060018000000
      446F63756D656E747320262050726F647563746976697479FEFEFF1B1C00B101
      0000FF1D00000800000057616B6154696D650100340000004175746F6D617465
      642074696D6520747261636B696E67206C6561646572626F6172647320666F72
      2070726F6772616D6D6572730200000000000300040000007472756504000700
      0000756E6B6E6F776E05001F00000068747470733A2F2F77616B6174696D652E
      636F6D2F646576656C6F70657273060018000000446F63756D656E7473202620
      50726F647563746976697479FEFEFF1B1C00B2010000FF1D0000040000005A75
      626501001D00000046756C6C20737461636B2070726F6A656374206D616E6167
      656D656E740200050000004F4175746803000400000074727565040007000000
      756E6B6E6F776E05001800000068747470733A2F2F7A7562652E696F2F646F63
      732F617069060018000000446F63756D656E747320262050726F647563746976
      697479FEFEFF1B1C00B3010000FF1D000019000000416273747261637420456D
      61696C2056616C69646174696F6E01003400000056616C696461746520656D61
      696C2061646472657373657320666F722064656C697665726162696C69747920
      616E64207370616D0200060000006170694B6579030004000000747275650400
      0300000079657305003D00000068747470733A2F2F7777772E61627374726163
      746170692E636F6D2F656D61696C2D766572696669636174696F6E2D76616C69
      646174696F6E2D617069060005000000456D61696CFEFEFF1B1C00B4010000FF
      1D0000150000006170696C61796572206D61696C626F786C6179657201001800
      0000456D61696C20616464726573732076616C69646174696F6E020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050018
      00000068747470733A2F2F6D61696C626F786C617965722E636F6D0600050000
      00456D61696CFEFEFF1B1C00B5010000FF1D000015000000436C6F75646D6572
      736976652056616C696461746501004500000056616C696461746520656D6169
      6C206164647265737365732C2070686F6E65206E756D626572732C2056415420
      6E756D6265727320616E6420646F6D61696E206E616D65730200060000006170
      694B657903000400000074727565040003000000796573050025000000687474
      70733A2F2F636C6F75646D6572736976652E636F6D2F76616C69646174652D61
      7069060005000000456D61696CFEFEFF1B1C00B6010000FF1D00000600000044
      697369667901003C00000056616C696461746520616E64206465746563742064
      6973706F7361626C6520616E642074656D706F7261727920656D61696C206164
      6472657373657302000000000003000400000074727565040003000000796573
      05001700000068747470733A2F2F7777772E6469736966792E636F6D2F060005
      000000456D61696CFEFEFF1B1C00B7010000FF1D00000800000044726F704D61
      696C01003E0000004772617068514C2041504920666F72206372656174696E67
      20616E64206D616E6167696E6720657068656D6572616C20652D6D61696C2069
      6E626F78657302000000000003000400000074727565040007000000756E6B6E
      6F776E05002200000068747470733A2F2F64726F706D61696C2E6D652F617069
      2F236C6976652D64656D6F060005000000456D61696CFEFEFF1B1C00B8010000
      FF1D00000300000045564101001800000056616C696461746520656D61696C20
      6164647265737365730200000000000300040000007472756504000300000079
      657305001900000068747470733A2F2F6576612E70696E677574696C2E636F6D
      2F060005000000456D61696CFEFEFF1B1C00B9010000FF1D00000E0000004775
      657272696C6C61204D61696C010024000000446973706F7361626C652074656D
      706F7261727920456D61696C2061646472657373657302000000000003000400
      000074727565040007000000756E6B6E6F776E05003300000068747470733A2F
      2F7777772E6775657272696C6C616D61696C2E636F6D2F4775657272696C6C61
      4D61696C4150492E68746D6C060005000000456D61696CFEFEFF1B1C00BA0100
      00FF1D000008000000496D70726F764D5801002500000041504920666F722066
      72656520656D61696C20666F7277617264696E67207365727669636502000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001800000068747470733A2F2F696D70726F766D782E636F6D2F617069060005
      000000456D61696CFEFEFF1B1C00BB010000FF1D0000070000004B69636B626F
      78010016000000456D61696C20766572696669636174696F6E20415049020000
      0000000300040000007472756504000300000079657305001900000068747470
      733A2F2F6F70656E2E6B69636B626F782E636F6D2F060005000000456D61696C
      FEFEFF1B1C00BC010000FF1D0000070000006D61696C2E677701000E00000031
      30204D696E757465204D61696C02000000000003000400000074727565040003
      00000079657305001400000068747470733A2F2F646F63732E6D61696C2E6777
      060005000000456D61696CFEFEFF1B1C00BD010000FF1D0000070000006D6169
      6C2E746D01001700000054656D706F7261727920456D61696C20536572766963
      6502000000000003000400000074727565040003000000796573050014000000
      68747470733A2F2F646F63732E6D61696C2E746D060005000000456D61696CFE
      FEFF1B1C00BE010000FF1D0000100000004D61696C626F7856616C696461746F
      7201003000000056616C696461746520656D61696C206164647265737320746F
      20696D70726F76652064656C697665726162696C697479020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05002F000000
      68747470733A2F2F7777772E6D61696C626F7876616C696461746F722E636F6D
      2F6170692D656D61696C2D66726565060005000000456D61696CFEFEFF1B1C00
      BF010000FF1D00000C0000004D61696C436865636B2E61690100370000005072
      6576656E7420757365727320746F207369676E20757020776974682074656D70
      6F7261727920656D61696C206164647265737365730200000000000300040000
      0074727565040007000000756E6B6E6F776E05002700000068747470733A2F2F
      7777772E6D61696C636865636B2E61692F23646F63756D656E746174696F6E06
      0005000000456D61696CFEFEFF1B1C00C0010000FF1D0000080000004D61696C
      7472617001005B00000041207365727669636520666F72207468652073616665
      2074657374696E67206F6620656D61696C732073656E742066726F6D20746865
      20646576656C6F706D656E7420616E642073746167696E6720656E7669726F6E
      6D656E74730200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05002100000068747470733A2F2F6D61696C747261702E64
      6F63732E6170696172792E696F2F23060005000000456D61696CFEFEFF1B1C00
      C1010000FF1D00000800000053656E64677269640100630000004120636C6F75
      642D626173656420534D54502070726F7669646572207468617420616C6C6F77
      7320796F7520746F2073656E6420656D61696C7320776974686F757420686176
      696E6720746F206D61696E7461696E20656D61696C2073657276657273020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002800000068747470733A2F2F646F63732E73656E64677269642E636F6D2F
      6170692D7265666572656E63652F060005000000456D61696CFEFEFF1B1C00C2
      010000FF1D00000A00000053656E64696E626C756501005D0000004120736572
      7669636520746861742070726F766964657320736F6C7574696F6E732072656C
      6174696E6720746F206D61726B6574696E6720616E642F6F72207472616E7361
      6374696F6E616C20656D61696C20616E642F6F7220534D530200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E0500260000
      0068747470733A2F2F646576656C6F706572732E73656E64696E626C75652E63
      6F6D2F646F6373060005000000456D61696CFEFEFF1B1C00C3010000FF1D0000
      0800000056657269666965720100230000005665726966696573207468617420
      6120676976656E20656D61696C206973207265616C0200060000006170694B65
      790300040000007472756504000300000079657305002600000068747470733A
      2F2F76657269666965722E6D65657463686F7072612E636F6D2F646F6373232F
      060005000000456D61696CFEFEFF1B1C00C4010000FF1D00000E000000636875
      636B6E6F727269732E696F01002C0000004A534F4E2041504920666F72206861
      6E64206375726174656420436875636B204E6F72726973206A6F6B6573020000
      00000003000400000074727565040007000000756E6B6E6F776E05001A000000
      68747470733A2F2F6170692E636875636B6E6F727269732E696F06000D000000
      456E7465727461696E6D656E74FEFEFF1B1C00C5010000FF1D00001400000043
      6F72706F726174652042757A7A20576F72647301002100000052455354204150
      4920666F7220436F72706F726174652042757A7A20576F726473020000000000
      0300040000007472756504000300000079657305003B00000068747470733A2F
      2F6769746875622E636F6D2F73616D6565726B756D617231382F636F72706F72
      6174652D62732D67656E657261746F722D61706906000D000000456E74657274
      61696E6D656E74FEFEFF1B1C00C6010000FF1D00000700000045786375736572
      0100290000004765742072616E646F6D206578637573657320666F7220766172
      696F757320736974756174696F6E730200000000000300040000007472756504
      0007000000756E6B6E6F776E05001E00000068747470733A2F2F657863757365
      722E6865726F6B756170702E636F6D2F06000D000000456E7465727461696E6D
      656E74FEFEFF1B1C00C7010000FF1D00000800000046756E2046616374010053
      000000412073696D706C652048545450532061706920746861742063616E2072
      616E646F6D6C792073656C65637420616E642072657475726E20612066616374
      2066726F6D207468652046464120646174616261736502000000000003000400
      00007472756504000300000079657305001600000068747470733A2F2F617069
      2E61616B68696C762E6D6506000D000000456E7465727461696E6D656E74FEFE
      FF1B1C00C8010000FF1D000007000000496D67666C697001001E000000476574
      7320616E206172726179206F6620706F70756C6172206D656D65730200000000
      0003000400000074727565040007000000756E6B6E6F776E0500170000006874
      7470733A2F2F696D67666C69702E636F6D2F61706906000D000000456E746572
      7461696E6D656E74FEFEFF1B1C00C9010000FF1D00000A0000004D656D65204D
      616B6572010021000000524553542041504920666F722063726561746520796F
      7572206F776E206D656D65020000000000030004000000747275650400070000
      00756E6B6E6F776E05002000000068747470733A2F2F6D656D656D616B65722E
      6769746875622E696F2F4150492F06000D000000456E7465727461696E6D656E
      74FEFEFF1B1C00CA010000FF1D0000090000004E614D6F4D656D657301001600
      00004D656D6573206F6E204E6172656E647261204D6F64690200000000000300
      0400000074727565040007000000756E6B6E6F776E0500230000006874747073
      3A2F2F6769746875622E636F6D2F7468654959442F4E614D6F4D656D65730600
      0D000000456E7465727461696E6D656E74FEFEFF1B1C00CB010000FF1D000014
      00000052616E646F6D205573656C65737320466163747301001B000000476574
      207573656C6573732C2062757420747275652066616374730200000000000300
      0400000074727565040007000000756E6B6E6F776E05001D0000006874747073
      3A2F2F7573656C65737366616374732E6A7370682E706C2F06000D000000456E
      7465727461696E6D656E74FEFEFF1B1C00CC010000FF1D000005000000546563
      68790100360000004A534F4E20616E6420506C61696E74657874204150492066
      6F7220746563682D736176767920736F756E64696E6720706872617365730200
      0000000003000400000074727565040007000000756E6B6E6F776E05001D0000
      0068747470733A2F2F74656368792D6170692E76657263656C2E6170702F0600
      0D000000456E7465727461696E6D656E74FEFEFF1B1C00CD010000FF1D00000E
      000000596F204D6F6D6D61204A6F6B657301001B000000524553542041504920
      666F7220596F204D6F6D6D61204A6F6B65730200000000000300040000007472
      7565040007000000756E6B6E6F776E05002900000068747470733A2F2F676974
      6875622E636F6D2F6265616E626F69372F796F6D6F6D6D612D61706976320600
      0D000000456E7465727461696E6D656E74FEFEFF1B1C00CE010000FF1D000012
      000000427265657A6F4D6574657220506F6C6C656E01003D0000004461696C79
      20466F72656361737420706F6C6C656E20636F6E646974696F6E732064617461
      20666F722061207370656369666963206C6F636174696F6E0200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E05003D0000
      0068747470733A2F2F646F63732E627265657A6F6D657465722E636F6D2F6170
      692D646F63756D656E746174696F6E2F706F6C6C656E2D6170692F76322F0600
      0B000000456E7669726F6E6D656E74FEFEFF1B1C00CF010000FF1D0000100000
      00436172626F6E20496E7465726661636501005400000041504920746F206361
      6C63756C61746520636172626F6E20284330322920656D697373696F6E732065
      7374696D6174657320666F7220636F6D6D6F6E2043303220656D697474696E67
      20616374697669746965730200060000006170694B6579030004000000747275
      6504000300000079657305002100000068747470733A2F2F646F63732E636172
      626F6E696E746572666163652E636F6D2F06000B000000456E7669726F6E6D65
      6E74FEFEFF1B1C00D0010000FF1D000008000000436C696D6174697101006000
      000043616C63756C6174652074686520656E7669726F6E6D656E74616C20666F
      6F747072696E74206372656174656420627920612062726F61642072616E6765
      206F6620656D697373696F6E2D67656E65726174696E67206163746976697469
      65730200060000006170694B6579030004000000747275650400030000007965
      7305001800000068747470733A2F2F646F63732E636C696D617469712E696F06
      000B000000456E7669726F6E6D656E74FEFEFF1B1C00D1010000FF1D00000800
      0000436C6F7665726C7901004C0000004150492063616C63756C617465732074
      686520696D70616374206F6620636F6D6D6F6E20636172626F6E2D696E74656E
      73697665206163746976697469657320696E207265616C2074696D6502000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      003400000068747470733A2F2F7777772E636C6F7665726C792E636F6D2F6361
      72626F6E2D6F66667365742D646F63756D656E746174696F6E06000B00000045
      6E7669726F6E6D656E74FEFEFF1B1C00D2010000FF1D00000A000000434F3220
      4F66667365740100310000004150492063616C63756C6174657320616E642076
      616C6964617465732074686520636172626F6E20666F6F747072696E74020000
      00000003000400000074727565040007000000756E6B6E6F776E05001D000000
      68747470733A2F2F636F326F66667365742E696F2F6170692E68746D6C06000B
      000000456E7669726F6E6D656E74FEFEFF1B1C00D3010000FF1D00001A000000
      44616E6973682064617461207365727669636520456E6572676901002A000000
      4F70656E20656E6572677920646174612066726F6D20456E657267696E657420
      746F20736F636965747902000000000003000400000074727565040007000000
      756E6B6E6F776E05002100000068747470733A2F2F7777772E656E6572676964
      617461736572766963652E646B2F06000B000000456E7669726F6E6D656E74FE
      FEFF1B1C00D4010000FF1D00000F0000004772C3BC6E7374726F6D496E646578
      010033000000477265656E20506F77657220496E64657820666F72204765726D
      616E7920284772C3BC6E7374726F6D696E6465782F4753492902000000000003
      000500000066616C736504000300000079657305001B00000068747470733A2F
      2F677275656E7374726F6D696E6465782E64652F06000B000000456E7669726F
      6E6D656E74FEFEFF1B1C00D5010000FF1D000005000000495141697201001C00
      0000416972207175616C69747920616E64207765617468657220646174610200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05002C00000068747470733A2F2F7777772E69716169722E636F6D2F616972
      2D706F6C6C7574696F6E2D646174612D61706906000B000000456E7669726F6E
      6D656E74FEFEFF1B1C00D6010000FF1D00000C0000004C756368746D6565746E
      657401004600000050726564696374656420616E642061637475616C20616972
      207175616C69747920636F6D706F6E656E747320666F7220546865204E657468
      65726C616E647320285249564D29020000000000030004000000747275650400
      07000000756E6B6E6F776E05002100000068747470733A2F2F6170692D646F63
      732E6C756368746D6565746E65742E6E6C2F06000B000000456E7669726F6E6D
      656E74FEFEFF1B1C00D7010000FF1D0000110000004E6174696F6E616C204772
      69642045534F01003C0000004F70656E20646174612066726F6D204772656174
      204272697461696EE280997320456C6563747269636974792053797374656D20
      4F70657261746F7202000000000003000400000074727565040007000000756E
      6B6E6F776E05002100000068747470733A2F2F646174612E6E6174696F6E616C
      6772696465736F2E636F6D2F06000B000000456E7669726F6E6D656E74FEFEFF
      1B1C00D8010000FF1D0000060000004F70656E41510100150000004F70656E20
      616972207175616C69747920646174610200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001800000068747470733A2F
      2F646F63732E6F70656E61712E6F72672F06000B000000456E7669726F6E6D65
      6E74FEFEFF1B1C00D9010000FF1D000016000000504D322E35204F70656E2044
      61746120506F7274616C01001F0000004F70656E206C6F772D636F737420504D
      322E352073656E736F7220646174610200000000000300040000007472756504
      0007000000756E6B6E6F776E05001F00000068747470733A2F2F706D32352E6C
      6173732D6E65742E6F72672F236170697306000B000000456E7669726F6E6D65
      6E74FEFEFF1B1C00DA010000FF1D000007000000504D32352E696E0100140000
      00416972207175616C697479206F66204368696E610200060000006170694B65
      7903000500000066616C7365040007000000756E6B6E6F776E05001A00000068
      7474703A2F2F7777772E706D32352E696E2F6170695F646F6306000B00000045
      6E7669726F6E6D656E74FEFEFF1B1C00DB010000FF1D00000700000050565761
      747473010032000000456E657267792070726F64756374696F6E2070686F746F
      766F6C74616963202850562920656E657267792073797374656D730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      3100000068747470733A2F2F646576656C6F7065722E6E72656C2E676F762F64
      6F63732F736F6C61722F707677617474732F76362F06000B000000456E766972
      6F6E6D656E74FEFEFF1B1C00DC010000FF1D00000A00000053727020456E6572
      677901002C000000486F75726C7920757361676520656E65726779207265706F
      727420666F722053727020637573746F6D6572730200060000006170694B6579
      030004000000747275650400020000006E6F05004500000068747470733A2F2F
      737270656E657267792D6170692D636C69656E742D707974686F6E2E72656164
      746865646F63732E696F2F656E2F6C61746573742F6170692E68746D6C06000B
      000000456E7669726F6E6D656E74FEFEFF1B1C00DD010000FF1D000013000000
      554B20436172626F6E20496E74656E7369747901004E000000546865204F6666
      696369616C20436172626F6E20496E74656E736974792041504920666F722047
      72656174204272697461696E20646576656C6F706564206279204E6174696F6E
      616C204772696402000000000003000400000074727565040007000000756E6B
      6E6F776E05004F00000068747470733A2F2F636172626F6E2D696E74656E7369
      74792E6769746875622E696F2F6170692D646566696E6974696F6E732F236361
      72626F6E2D696E74656E736974792D6170692D76312D302D3006000B00000045
      6E7669726F6E6D656E74FEFEFF1B1C00DE010000FF1D00000E00000057656273
      69746520436172626F6E01003900000041504920746F20657374696D61746520
      74686520636172626F6E20666F6F747072696E74206F66206C6F6164696E6720
      7765622070616765730200000000000300040000007472756504000700000075
      6E6B6E6F776E05001E00000068747470733A2F2F6170692E7765627369746563
      6172626F6E2E636F6D2F06000B000000456E7669726F6E6D656E74FEFEFF1B1C
      00DF010000FF1D00000A0000004576656E74627269746501000B00000046696E
      64206576656E74730200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05002800000068747470733A2F2F7777772E6576656E
      7462726974652E636F6D2F706C6174666F726D2F6170692F0600060000004576
      656E7473FEFEFF1B1C00E0010000FF1D000008000000536561744765656B0100
      24000000536561726368206576656E74732C2076656E75657320616E64207065
      72666F726D6572730200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001E00000068747470733A2F2F706C6174666F72
      6D2E736561746765656B2E636F6D2F0600060000004576656E7473FEFEFF1B1C
      00E1010000FF1D00000C0000005469636B65746D617374657201002500000053
      6561726368206576656E74732C2061747472616374696F6E732C206F72207665
      6E7565730200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E050049000000687474703A2F2F646576656C6F7065722E7469
      636B65746D61737465722E636F6D2F70726F64756374732D616E642D646F6373
      2F617069732F67657474696E672D737461727465642F0600060000004576656E
      7473FEFEFF1B1C00E2010000FF1D000017000000416273747261637420564154
      2056616C69646174696F6E01002C00000056616C696461746520564154206E75
      6D6265727320616E642063616C63756C61746520564154207261746573020006
      0000006170694B65790300040000007472756504000300000079657305003400
      000068747470733A2F2F7777772E61627374726163746170692E636F6D2F7661
      742D76616C69646174696F6E2D72617465732D61706906000700000046696E61
      6E6365FEFEFF1B1C00E3010000FF1D000008000000416C65746865696101004C
      000000496E73696465722074726164696E6720646174612C206561726E696E67
      732063616C6C20616E616C797369732C2066696E616E6369616C207374617465
      6D656E74732C20616E64206D6F72650200060000006170694B65790300040000
      007472756504000300000079657305001800000068747470733A2F2F616C6574
      686569616170692E636F6D2F06000700000046696E616E6365FEFEFF1B1C00E4
      010000FF1D000006000000416C7061636101003F0000005265616C74696D6520
      616E6420686973746F726963616C206D61726B65742064617461206F6E20616C
      6C20555320657175697469657320616E6420455446730200060000006170694B
      6579030004000000747275650400030000007965730500540000006874747073
      3A2F2F616C706163612E6D61726B6574732F646F63732F6170692D646F63756D
      656E746174696F6E2F6170692D76322F6D61726B65742D646174612F616C7061
      63612D646174612D6170692D76322F06000700000046696E616E6365FEFEFF1B
      1C00E5010000FF1D00000D000000416C7068612056616E746167650100220000
      005265616C74696D6520616E6420686973746F726963616C2073746F636B2064
      6174610200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001C00000068747470733A2F2F7777772E616C70686176616E
      746167652E636F2F06000700000046696E616E6365FEFEFF1B1C00E6010000FF
      1D0000140000006170696C61796572206D61726B6574737461636B0100300000
      005265616C2D54696D652C20496E747261646179202620486973746F72696361
      6C204D61726B65742044617461204150490200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05001800000068747470733A
      2F2F6D61726B6574737461636B2E636F6D2F06000700000046696E616E6365FE
      FEFF1B1C00E7010000FF1D00000F00000042616E636F20646F2042726173696C
      01002E000000416C6C2042616E636F20646F2042726173696C2066696E616E63
      69616C207472616E73616374696F6E20415049730200050000004F4175746803
      00040000007472756504000300000079657305002100000068747470733A2F2F
      646576656C6F706572732E62622E636F6D2E62722F686F6D6506000700000046
      696E616E6365FEFEFF1B1C00E8010000FF1D00000D00000042616E6B20446174
      6120415049010039000000496E7374616E74204942414E20616E642053574946
      54206E756D6265722076616C69646174696F6E206163726F7373207468652067
      6C6F62650200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05002E00000068747470733A2F2F6170696C617965722E636F
      6D2F6D61726B6574706C6163652F62616E6B5F646174612D6170690600070000
      0046696E616E6365FEFEFF1B1C00E9010000FF1D00000700000042696C6C706C
      7A0100100000005061796D656E7420706C6174666F726D020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001B000000
      68747470733A2F2F7777772E62696C6C706C7A2E636F6D2F6170690600070000
      0046696E616E6365FEFEFF1B1C00EA010000FF1D00000700000042696E6C6973
      740100320000005075626C69632061636365737320746F206120646174616261
      7365206F662049494E2F42494E20696E666F726D6174696F6E02000000000003
      000400000074727565040007000000756E6B6E6F776E05001400000068747470
      733A2F2F62696E6C6973742E6E65742F06000700000046696E616E6365FEFEFF
      1B1C00EB010000FF1D00000C000000426F6C65746F2E436C6F75640100230000
      00412061706920746F2067656E657261746520626F6C65746F7320696E204272
      617A696C0200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001500000068747470733A2F2F626F6C65746F2E636C6F75
      642F06000700000046696E616E6365FEFEFF1B1C00EC010000FF1D0000040000
      004369746901002D000000416C6C204369746967726F7570206163636F756E74
      20616E642073746174656D656E74206461746120415049730200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E0500360000
      0068747470733A2F2F73616E64626F782E646576656C6F7065726875622E6369
      74692E636F6D2F6170692D636174616C6F672D6C69737406000700000046696E
      616E6365FEFEFF1B1C00ED010000FF1D00000600000045636F6E646201001900
      0000476C6F62616C206D6163726F65636F6E6F6D696320646174610200000000
      000300040000007472756504000300000079657305001B00000068747470733A
      2F2F7777772E65636F6E64622E636F6D2F6170692F06000700000046696E616E
      6365FEFEFF1B1C00EE010000FF1D00000C000000466564205472656173757279
      010024000000552E532E204465706172746D656E74206F662074686520547265
      6173757279204461746102000000000003000400000074727565040007000000
      756E6B6E6F776E05003200000068747470733A2F2F66697363616C646174612E
      74726561737572792E676F762F6170692D646F63756D656E746174696F6E2F06
      000700000046696E616E6365FEFEFF1B1C00EF010000FF1D0000060000004669
      6E61676501006300000046696E61676520697320612073746F636B2C20637572
      72656E63792C2063727970746F63757272656E63792C20696E64696365732C20
      616E642045544673207265616C2D74696D65202620686973746F726963616C20
      646174612070726F76696465720200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001400000068747470733A2F2F6669
      6E6167652E636F2E756B06000700000046696E616E6365FEFEFF1B1C00F00100
      00FF1D00001700000046696E616E6369616C204D6F64656C696E672050726570
      0100220000005265616C74696D6520616E6420686973746F726963616C207374
      6F636B20646174610200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05003500000068747470733A2F2F736974652E6669
      6E616E6369616C6D6F64656C696E67707265702E636F6D2F646576656C6F7065
      722F646F637306000700000046696E616E6365FEFEFF1B1C00F1010000FF1D00
      000700000046696E6E6875620100470000005265616C2D54696D652052455354
      66756C204150497320616E6420576562736F636B657420666F722053746F636B
      732C2043757272656E636965732C20616E642043727970746F02000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001B00
      000068747470733A2F2F66696E6E6875622E696F2F646F63732F617069060007
      00000046696E616E6365FEFEFF1B1C00F2010000FF1D00000400000046524544
      01003800000045636F6E6F6D696320646174612066726F6D2074686520466564
      6572616C20526573657276652042616E6B206F662053742E204C6F7569730200
      060000006170694B65790300040000007472756504000300000079657305002A
      00000068747470733A2F2F667265642E73746C6F7569736665642E6F72672F64
      6F63732F6170692F667265642F06000700000046696E616E6365FEFEFF1B1C00
      F3010000FF1D00001500000046726F6E74204163636F756E74696E6720415049
      7301005000000046726F6E74206163636F756E74696E67206973206D756C7469
      6C696E6775616C20616E64206D756C746963757272656E637920736F66747761
      726520666F7220736D616C6C20627573696E65737365730200050000004F4175
      7468030004000000747275650400030000007965730500440000006874747073
      3A2F2F66726F6E746163636F756E74696E672E636F6D2F666177696B692F696E
      6465782E7068703F6E3D446576656C2E53696D706C654150494D6F64756C6506
      000700000046696E616E6365FEFEFF1B1C00F4010000FF1D000008000000486F
      7473746F6B7301002000000053746F636B206D61726B6574206461746120706F
      77657265642062792053514C0200060000006170694B65790300040000007472
      756504000300000079657305002B00000068747470733A2F2F686F7473746F6B
      732E636F6D3F75746D5F736F757263653D7075626C69632D6170697306000700
      000046696E616E6365FEFEFF1B1C00F5010000FF1D0000090000004945582043
      6C6F756401002B0000005265616C74696D65202620486973746F726963616C20
      53746F636B20616E64204D61726B657420446174610200060000006170694B65
      790300040000007472756504000300000079657305001D00000068747470733A
      2F2F696578636C6F75642E696F2F646F63732F6170692F06000700000046696E
      616E6365FEFEFF1B1C00F6010000FF1D00000200000049470100210000005370
      7265616462657474696E6720616E6420434644204D61726B6574204461746102
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002200000068747470733A2F2F6C6162732E69672E636F6D2F67657474
      696E677374617274656406000700000046696E616E6365FEFEFF1B1C00F70100
      00FF1D000012000000496E6469616E204D757475616C2046756E6401002F0000
      0047657420636F6D706C65746520686973746F7279206F6620496E646961204D
      757475616C2046756E6473204461746102000000000003000400000074727565
      040007000000756E6B6E6F776E05001500000068747470733A2F2F7777772E6D
      666170692E696E2F06000700000046696E616E6365FEFEFF1B1C00F8010000FF
      1D000008000000496E7472696E696F0100280000004120776964652073656C65
      6374696F6E206F662066696E616E6369616C2064617461206665656473020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001500000068747470733A2F2F696E7472696E696F2E636F6D2F0600070000
      0046696E616E6365FEFEFF1B1C00F9010000FF1D0000060000004B6C61726E61
      0100230000004B6C61726E61207061796D656E7420616E642073686F7070696E
      6720736572766963650200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05003900000068747470733A2F2F646F63732E6B
      6C61726E612E636F6D2F6B6C61726E612D7061796D656E74732F6170692F7061
      796D656E74732D6170692F06000700000046696E616E6365FEFEFF1B1C00FA01
      0000FF1D00000B0000004D65726361646F5061676F0100560000004D65726361
      646F205061676F20415049207265666572656E6365202D20616C6C2074686520
      696E666F726D6174696F6E20796F75206E65656420746F20646576656C6F7020
      796F757220696E746567726174696F6E730200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05003600000068747470733A
      2F2F7777772E6D65726361646F7061676F2E636F6D2E62722F646576656C6F70
      6572732F65732F7265666572656E636506000700000046696E616E6365FEFEFF
      1B1C00FB010000FF1D0000040000004D6F6E6F010049000000436F6E6E656374
      2077697468207573657273E280992062616E6B206163636F756E747320616E64
      20616363657373207472616E73616374696F6E206461746120696E2041667269
      63610200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05001000000068747470733A2F2F6D6F6E6F2E636F2F0600070000
      0046696E616E6365FEFEFF1B1C00FC010000FF1D0000040000004D6F6F760100
      4C000000546865204D6F6F7620415049206D616B65732069742073696D706C65
      20666F7220706C6174666F726D7320746F2073656E642C20726563656976652C
      20616E642073746F7265206D6F6E65790200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001900000068747470733A2F
      2F646F63732E6D6F6F762E696F2F6170692F06000700000046696E616E6365FE
      FEFF1B1C00FD010000FF1D0000080000004E6F72646967656E01004E00000043
      6F6E6E65637420746F2062616E6B206163636F756E7473207573696E67206F66
      66696369616C2062616E6B204150497320616E64206765742072617720747261
      6E73616374696F6E20646174610200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05005600000068747470733A2F2F6E6F
      72646967656E2E636F6D2F656E2F6163636F756E745F696E666F726D6174696F
      6E5F646F63756D656E6174696F6E2F696E746567726174696F6E2F717569636B
      73746172745F67756964652F06000700000046696E616E6365FEFEFF1B1C00FE
      010000FF1D0000080000004F70656E4649474901003B0000004571756974792C
      20696E6465782C20667574757265732C206F7074696F6E732073796D626F6C6F
      67792066726F6D20426C6F6F6D62657267204C500200060000006170694B6579
      0300040000007472756504000300000079657305001C00000068747470733A2F
      2F7777772E6F70656E666967692E636F6D2F61706906000700000046696E616E
      6365FEFEFF1B1C00FF010000FF1D000005000000506C61696401003D00000043
      6F6E6E6563742077697468207573657227732062616E6B206163636F756E7473
      20616E6420616363657373207472616E73616374696F6E206461746102000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001200000068747470733A2F2F706C6169642E636F6D2F06000700000046696E
      616E6365FEFEFF1B1C0000020000FF1D000007000000506F6C79676F6E01001C
      000000486973746F726963616C2073746F636B206D61726B6574206461746102
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001300000068747470733A2F2F706F6C79676F6E2E696F2F0600070000
      0046696E616E6365FEFEFF1B1C0001020000FF1D000013000000506F7274666F
      6C696F204F7074696D697A6572010023000000506F7274666F6C696F20616E61
      6C7973697320616E64206F7074696D697A6174696F6E02000000000003000400
      00007472756504000300000079657305001E00000068747470733A2F2F706F72
      74666F6C696F6F7074696D697A65722E696F2F06000700000046696E616E6365
      FEFEFF1B1C0002020000FF1D00000D00000052617A6F72706179204946534301
      0031000000496E6469616E2046696E616E6369616C2053797374656D7320436F
      6465202842616E6B204272616E636820436F6465732902000000000003000400
      000074727565040007000000756E6B6E6F776E05001A00000068747470733A2F
      2F72617A6F727061792E636F6D2F646F63732F06000700000046696E616E6365
      FEFEFF1B1C0003020000FF1D0000110000005265616C2054696D652046696E61
      6E636501002B000000576562736F636B65742041504920746F20616363657373
      207265616C74696D652073746F636B20646174610200060000006170694B6579
      03000500000066616C7365040007000000756E6B6E6F776E05003B0000006874
      7470733A2F2F6769746875622E636F6D2F5265616C2D74696D652D66696E616E
      63652F66696E616E63652D776562736F636B65742D4150492F06000700000046
      696E616E6365FEFEFF1B1C0004020000FF1D00000E0000005345432045444741
      52204461746101003300000041504920746F2061636365737320616E6E75616C
      207265706F727473206F66207075626C696320555320636F6D70616E69657302
      00000000000300040000007472756504000300000079657305002F0000006874
      7470733A2F2F7777772E7365632E676F762F65646761722F7365632D6170692D
      646F63756D656E746174696F6E06000700000046696E616E6365FEFEFF1B1C00
      05020000FF1D000008000000536D6172744150490100470000004761696E2061
      636365737320746F20736574206F66203C536D6172744150493E20616E642063
      726561746520656E642D746F2D656E642062726F6B696E672073657276696365
      730200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05002200000068747470733A2F2F736D6172746170692E616E67656C
      62726F6B696E672E636F6D2F06000700000046696E616E6365FEFEFF1B1C0006
      020000FF1D00000900000053746F636B446174610100440000005265616C2D54
      696D652C20496E747261646179202620486973746F726963616C204D61726B65
      7420446174612C204E65777320616E642053656E74696D656E74204150490200
      060000006170694B657903000400000074727565040003000000796573050019
      00000068747470733A2F2F7777772E53746F636B446174612E6F726706000700
      000046696E616E6365FEFEFF1B1C0007020000FF1D0000060000005374797669
      6F01003E0000005265616C74696D6520616E6420686973746F726963616C2073
      746F636B206461746120616E642063757272656E742073746F636B2073656E74
      696D656E740200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001600000068747470733A2F2F7777772E53747976696F
      2E636F6D06000700000046696E616E6365FEFEFF1B1C0008020000FF1D00000C
      000000546178204461746120415049010036000000496E7374616E7420564154
      206E756D62657220616E64207461782076616C69646174696F6E206163726F73
      732074686520676C6F62650200060000006170694B6579030004000000747275
      65040006000000756E6B6F776E05002D00000068747470733A2F2F6170696C61
      7965722E636F6D2F6D61726B6574706C6163652F7461785F646174612D617069
      06000700000046696E616E6365FEFEFF1B1C0009020000FF1D00000700000054
      72616469657201003C0000005553206571756974792F6F7074696F6E206D6172
      6B65742064617461202864656C617965642C20696E7472616461792C20686973
      746F726963616C290200050000004F4175746803000400000074727565040003
      00000079657305001D00000068747470733A2F2F646576656C6F7065722E7472
      61646965722E636F6D06000700000046696E616E6365FEFEFF1B1C000A020000
      FF1D00000B0000005477656C7665204461746101002A00000053746F636B206D
      61726B6574206461746120287265616C2D74696D65202620686973746F726963
      616C290200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001700000068747470733A2F2F7477656C7665646174612E63
      6F6D2F06000700000046696E616E6365FEFEFF1B1C000B020000FF1D00000E00
      000057616C6C7374726565744265747301003000000057616C6C737472656574
      426574732053746F636B20436F6D6D656E74732053656E74696D656E7420416E
      616C7973697302000000000003000400000074727565040007000000756E6B6E
      6F776E05002D00000068747470733A2F2F64617368626F6172642E6E62736861
      72652E696F2F617070732F7265646469742F6170692F06000700000046696E61
      6E6365FEFEFF1B1C000C020000FF1D00000D0000005961686F6F2046696E616E
      63650100620000005265616C2074696D65206C6F77206C6174656E6379205961
      686F6F2046696E616E63652041504920666F722073746F636B206D61726B6574
      2C2063727970746F2063757272656E636965732C20616E642063757272656E63
      792065786368616E67650200060000006170694B657903000400000074727565
      04000300000079657305002000000068747470733A2F2F7777772E7961686F6F
      66696E616E63656170692E636F6D2F06000700000046696E616E6365FEFEFF1B
      1C000D020000FF1D000004000000594E4142010014000000427564676574696E
      67202620506C616E6E696E670200050000004F41757468030004000000747275
      6504000300000079657305001F00000068747470733A2F2F6170692E796F756E
      656564616275646765742E636F6D2F06000700000046696E616E6365FEFEFF1B
      1C000E020000FF1D00000A0000005A6F686F20426F6F6B730100330000004F6E
      6C696E65206163636F756E74696E6720736F6674776172652C206275696C7420
      666F7220796F757220627573696E6573730200050000004F4175746803000400
      000074727565040007000000756E6B6E6F776E05002200000068747470733A2F
      2F7777772E7A6F686F2E636F6D2F626F6F6B732F6170692F76332F0600070000
      0046696E616E6365FEFEFF1B1C000F020000FF1D00000B0000004261636F6E4D
      6F636B7570010022000000526573697A61626C65206261636F6E20706C616365
      686F6C64657220696D6167657302000000000003000400000074727565040003
      00000079657305001800000068747470733A2F2F6261636F6E6D6F636B75702E
      636F6D2F06000C000000466F6F642026204472696E6BFEFEFF1B1C0010020000
      FF1D00000500000043686F6D7001002D000000446174612061626F7574207661
      72696F75732067726F636572792070726F647563747320616E6420666F6F6473
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001A00000068747470733A2F2F63686F6D70746869732E636F6D2F61
      70692F06000C000000466F6F642026204472696E6BFEFEFF1B1C0011020000FF
      1D000006000000436F6666656501001900000052616E646F6D20706963747572
      6573206F6620636F666665650200000000000300040000007472756504000700
      0000756E6B6E6F776E05002000000068747470733A2F2F636F666665652E616C
      6578666C69706E6F74652E6465762F06000C000000466F6F642026204472696E
      6BFEFEFF1B1C0012020000FF1D0000100000004564616D616D206E7574726974
      696F6E0100120000004E7574726974696F6E20416E616C797369730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      3600000068747470733A2F2F646576656C6F7065722E6564616D616D2E636F6D
      2F6564616D616D2D646F63732D6E7574726974696F6E2D61706906000C000000
      466F6F642026204472696E6BFEFEFF1B1C0013020000FF1D00000E0000004564
      616D616D207265636970657301000D0000005265636970652053656172636802
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05003300000068747470733A2F2F646576656C6F7065722E6564616D616D
      2E636F6D2F6564616D616D2D646F63732D7265636970652D61706906000C0000
      00466F6F642026204472696E6BFEFEFF1B1C0014020000FF1D00000700000046
      6F6F6469736801001E00000052616E646F6D207069637475726573206F662066
      6F6F642064697368657302000000000003000400000074727565040003000000
      79657305002B00000068747470733A2F2F6769746875622E636F6D2F73757268
      75643030342F466F6F6469736823726561646D6506000C000000466F6F642026
      204472696E6BFEFEFF1B1C0015020000FF1D00000A0000004672756974797669
      636501001D000000446174612061626F757420616C6C206B696E6473206F6620
      667275697402000000000003000400000074727565040007000000756E6B6E6F
      776E05001A00000068747470733A2F2F7777772E667275697479766963652E63
      6F6D06000C000000466F6F642026204472696E6BFEFEFF1B1C0016020000FF1D
      0000060000004B726F67657201001000000053757065726D61726B6574204461
      74610200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05002600000068747470733A2F2F646576656C6F7065722E6B726F
      6765722E636F6D2F7265666572656E636506000C000000466F6F642026204472
      696E6BFEFEFF1B1C0017020000FF1D0000040000004C43424F01000700000041
      6C636F686F6C0200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001400000068747470733A2F2F6C63626F6170692E63
      6F6D2F06000C000000466F6F642026204472696E6BFEFEFF1B1C0018020000FF
      1D00000F0000004F70656E204272657765727920444201002F00000042726577
      65726965732C20436964657269657320616E6420437261667420426565722042
      6F74746C652053686F7073020000000000030004000000747275650400030000
      0079657305001D00000068747470733A2F2F7777772E6F70656E627265776572
      7964622E6F726706000C000000466F6F642026204472696E6BFEFEFF1B1C0019
      020000FF1D00000F0000004F70656E20466F6F64204661637473010016000000
      466F6F642050726F647563747320446174616261736502000000000003000400
      000074727565040007000000756E6B6E6F776E05002400000068747470733A2F
      2F776F726C642E6F70656E666F6F6466616374732E6F72672F6461746106000C
      000000466F6F642026204472696E6BFEFEFF1B1C001A020000FF1D0000070000
      0050756E6B41504901001400000042726577646F672042656572205265636970
      657302000000000003000400000074727565040007000000756E6B6E6F776E05
      001400000068747470733A2F2F70756E6B6170692E636F6D2F06000C00000046
      6F6F642026204472696E6BFEFEFF1B1C001B020000FF1D000009000000527573
      747962656572010012000000426565722062726577696E6720746F6F6C730200
      00000000030004000000747275650400020000006E6F05002000000068747470
      733A2F2F7275737479626565722E6865726F6B756170702E636F6D2F06000C00
      0000466F6F642026204472696E6BFEFEFF1B1C001C020000FF1D00000B000000
      53706F6F6E6163756C6172010029000000526563697065732C20466F6F642050
      726F64756374732C20616E64204D65616C20506C616E6E696E67020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050020
      00000068747470733A2F2F73706F6F6E6163756C61722E636F6D2F666F6F642D
      61706906000C000000466F6F642026204472696E6BFEFEFF1B1C001D020000FF
      1D00000D00000053797374656D626F6C61676574010027000000476F766F726E
      6D656E74206F776E6564206C69716F75722073746F726520696E205377656465
      6E0200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05002300000068747470733A2F2F6170692D706F7274616C2E737973
      74656D626F6C616765742E736506000C000000466F6F642026204472696E6BFE
      FEFF1B1C001E020000FF1D0000090000005461636F46616E637901001E000000
      436F6D6D756E6974792D64726976656E207461636F2064617461626173650200
      0000000003000500000066616C7365040007000000756E6B6E6F776E05002400
      000068747470733A2F2F6769746875622E636F6D2F65767A2F7461636F66616E
      63792D61706906000C000000466F6F642026204472696E6BFEFEFF1B1C001F02
      0000FF1D000005000000546173747901003100000041504920746F2071756572
      7920646174612061626F7574207265636970652C20706C616E2C20696E677265
      6469656E74730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002700000068747470733A2F2F72617069646170692E
      636F6D2F617069646F6A6F2F6170692F74617374792F06000C000000466F6F64
      2026204472696E6BFEFEFF1B1C0020020000FF1D000016000000546865205265
      706F7274206F6620746865205765656B010014000000466F6F64202620447269
      6E6B205265766965777302000000000003000400000074727565040007000000
      756E6B6E6F776E05003600000068747470733A2F2F6769746875622E636F6D2F
      616E64796B6C696D637A616B2F5468655265706F72744F665468655765656B2D
      41504906000C000000466F6F642026204472696E6BFEFEFF1B1C0021020000FF
      1D00000D000000546865436F636B7461696C4442010010000000436F636B7461
      696C20526563697065730200060000006170694B657903000400000074727565
      04000300000079657305002500000068747470733A2F2F7777772E746865636F
      636B7461696C64622E636F6D2F6170692E70687006000C000000466F6F642026
      204472696E6BFEFEFF1B1C0022020000FF1D0000090000005468654D65616C44
      4201000C0000004D65616C20526563697065730200060000006170694B657903
      00040000007472756504000300000079657305002100000068747470733A2F2F
      7777772E7468656D65616C64622E636F6D2F6170692E70687006000C00000046
      6F6F642026204472696E6BFEFEFF1B1C0023020000FF1D000007000000556E74
      61707064010013000000536F6369616C20626565722073686172696E67020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      001C00000068747470733A2F2F756E74617070642E636F6D2F6170692F646F63
      7306000C000000466F6F642026204472696E6BFEFEFF1B1C0024020000FF1D00
      0013000000576861742773206F6E20746865206D656E753F0100310000004E59
      504C2068756D616E2D7472616E7363726962656420686973746F726963616C20
      6D656E7520636F6C6C656374696F6E0200060000006170694B65790300050000
      0066616C7365040007000000756E6B6E6F776E050020000000687474703A2F2F
      6E79706C2E6769746875622E696F2F6D656E75732D6170692F06000C00000046
      6F6F642026204472696E6BFEFEFF1B1C0025020000FF1D00000C000000576869
      736B7948756E74657201002C00000050617374206F6E6C696E6520776869736B
      792061756374696F6E7320737461746973746963616C20646174610200000000
      0003000400000074727565040007000000756E6B6E6F776E05001D0000006874
      7470733A2F2F776869736B7968756E7465722E6E65742F6170692F06000C0000
      00466F6F642026204472696E6BFEFEFF1B1C0026020000FF1D0000070000005A
      65737466756C01001800000050617273652072656369706520696E6772656469
      656E74730200060000006170694B657903000400000074727565040003000000
      79657305001800000068747470733A2F2F7A65737466756C646174612E636F6D
      2F06000C000000466F6F642026204472696E6BFEFEFF1B1C0027020000FF1D00
      0011000000416765206F6620456D706972657320494901003100000047657420
      696E666F726D6174696F6E2061626F757420416765206F6620456D7069726573
      204949207265736F757263657302000000000003000400000074727565040002
      0000006E6F05002A00000068747470733A2F2F6167652D6F662D656D70697265
      732D322D6170692E6865726F6B756170702E636F6D06000E00000047616D6573
      202620436F6D696373FEFEFF1B1C0028020000FF1D000009000000416D696962
      6F41504901001B0000004E696E74656E646F20416D6969626F20496E666F726D
      6174696F6E020000000000030004000000747275650400030000007965730500
      1600000068747470733A2F2F616D6969626F6170692E636F6D2F06000E000000
      47616D6573202620436F6D696373FEFEFF1B1C0029020000FF1D00001D000000
      416E696D616C2043726F7373696E673A204E657720486F72697A6F6E7301003E
      00000041504920666F722063726974746572732C20666F7373696C732C206172
      742C206D757369632C206675726E697475726520616E642076696C6C61676572
      7302000000000003000400000074727565040007000000756E6B6E6F776E0500
      13000000687474703A2F2F61636E686170692E636F6D2F06000E00000047616D
      6573202620436F6D696373FEFEFF1B1C002A020000FF1D00000D000000417574
      6F636865737320564E4701001A000000526573742041706920666F7220417574
      6F636865737320564E4702000000000003000400000074727565040003000000
      79657305003100000068747470733A2F2F6769746875622E636F6D2F64696461
      64616469646139332F6175746F63686573732D766E672D61706906000E000000
      47616D6573202620436F6D696373FEFEFF1B1C002B020000FF1D000009000000
      4261727465722E564701004100000050726F766964657320696E666F726D6174
      696F6E2061626F75742047616D652C20444C432C2042756E646C65732C204769
      766561776179732C2054726164696E6702000000000003000400000074727565
      04000300000079657305002A00000068747470733A2F2F6769746875622E636F
      6D2F62617274657276672F6261727465722E76672F77696B6906000E00000047
      616D6573202620436F6D696373FEFEFF1B1C002C020000FF1D00000A00000042
      6174746C652E6E657401004A000000446961626C6F204949492C204865617274
      6873746F6E652C2053746172437261667420494920616E6420576F726C64206F
      662057617263726166742067616D65206461746120415049730200050000004F
      417574680300040000007472756504000300000079657305003F000000687474
      70733A2F2F646576656C6F702E626174746C652E6E65742F646F63756D656E74
      6174696F6E2F6775696465732F67657474696E672D7374617274656406000E00
      000047616D6573202620436F6D696373FEFEFF1B1C002D020000FF1D00000F00
      0000426F6172642047616D65204765656B01001F000000426F6172642067616D
      65732C2052504720616E6420766964656F67616D657302000000000003000400
      0000747275650400020000006E6F05003000000068747470733A2F2F626F6172
      6467616D656765656B2E636F6D2F77696B692F706167652F4247475F584D4C5F
      4150493206000E00000047616D6573202620436F6D696373FEFEFF1B1C002E02
      0000FF1D00000B000000427261776C20537461727301001C000000427261776C
      2053746172732047616D6520496E666F726D6174696F6E020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050020000000
      68747470733A2F2F646576656C6F7065722E627261776C73746172732E636F6D
      06000E00000047616D6573202620436F6D696373FEFEFF1B1C002F020000FF1D
      000007000000427567736E617801001D00000047657420696E666F726D617469
      6F6E2061626F757420427567736E617802000000000003000400000074727565
      04000300000079657305001B00000068747470733A2F2F7777772E627567736E
      61786170692E636F6D2F06000E00000047616D6573202620436F6D696373FEFE
      FF1B1C0030020000FF1D00000A0000004368656170536861726B01001E000000
      537465616D2F50432047616D652050726963657320616E64204465616C730200
      000000000300040000007472756504000300000079657305001E000000687474
      70733A2F2F7777772E6368656170736861726B2E636F6D2F61706906000E0000
      0047616D6573202620436F6D696373FEFEFF1B1C0031020000FF1D0000090000
      0043686573732E636F6D01001C00000043686573732E636F6D20726561642D6F
      6E6C792052455354204150490200000000000300040000007472756504000700
      0000756E6B6E6F776E05003200000068747470733A2F2F7777772E6368657373
      2E636F6D2F6E6577732F766965772F7075626C69736865642D646174612D6170
      6906000E00000047616D6573202620436F6D696373FEFEFF1B1C0032020000FF
      1D000015000000436875636B204E6F7272697320446174616261736501000500
      00004A6F6B657302000000000003000500000066616C7365040007000000756E
      6B6E6F776E050019000000687474703A2F2F7777772E69636E64622E636F6D2F
      6170692F06000E00000047616D6573202620436F6D696373FEFEFF1B1C003302
      0000FF1D00000E000000436C617368206F6620436C616E7301001F000000436C
      617368206F6620436C616E732047616D6520496E666F726D6174696F6E020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002200000068747470733A2F2F646576656C6F7065722E636C6173686F6663
      6C616E732E636F6D06000E00000047616D6573202620436F6D696373FEFEFF1B
      1C0034020000FF1D00000C000000436C61736820526F79616C6501001D000000
      436C61736820526F79616C652047616D6520496E666F726D6174696F6E020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002100000068747470733A2F2F646576656C6F7065722E636C617368726F79
      616C652E636F6D06000E00000047616D6573202620436F6D696373FEFEFF1B1C
      0035020000FF1D00000A000000436F6D69632056696E65010006000000436F6D
      69637302000000000003000400000074727565040007000000756E6B6E6F776E
      05003000000068747470733A2F2F636F6D696376696E652E67616D6573706F74
      2E636F6D2F6170692F646F63756D656E746174696F6E06000E00000047616D65
      73202620436F6D696373FEFEFF1B1C0036020000FF1D00000800000043726166
      6174617201002100000041504920666F72204D696E65637261667420736B696E
      7320616E64206661636573020000000000030004000000747275650400030000
      0079657305001400000068747470733A2F2F63726166617461722E636F6D0600
      0E00000047616D6573202620436F6D696373FEFEFF1B1C0037020000FF1D0000
      0E00000043726F737320556E69766572736501001800000043726F737320556E
      6976657273652043617264204461746102000000000003000400000074727565
      04000300000079657305003000000068747470733A2F2F63726F7373756E6976
      657273652E70737963687073796F2E636F6D2F617069446F63732E68746D6C06
      000E00000047616D6573202620436F6D696373FEFEFF1B1C0038020000FF1D00
      000D0000004465636B206F6620436172647301000D0000004465636B206F6620
      436172647302000000000003000500000066616C7365040007000000756E6B6E
      6F776E05001A000000687474703A2F2F6465636B6F6663617264736170692E63
      6F6D2F06000E00000047616D6573202620436F6D696373FEFEFF1B1C00390200
      00FF1D00001000000044657374696E79205468652047616D6501001300000042
      756E67696520506C6174666F726D204150490200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E05002D0000006874747073
      3A2F2F62756E6769652D6E65742E6769746875622E696F2F6D756C74692F696E
      6465782E68746D6C06000E00000047616D6573202620436F6D696373FEFEFF1B
      1C003A020000FF1D000013000000446967696D6F6E20496E666F726D6174696F
      6E01002C00000050726F766964657320696E666F726D6174696F6E2061626F75
      7420646967696D6F6E2063726561747572657302000000000003000400000074
      727565040007000000756E6B6E6F776E05001F00000068747470733A2F2F6469
      67696D6F6E2D6170692E76657263656C2E6170702F06000E00000047616D6573
      202620436F6D696373FEFEFF1B1C003B020000FF1D00000B000000446967696D
      6F6E2054434701002A00000053656172636820666F7220446967696D6F6E2063
      6172647320696E20646967696D6F6E636172642E696F02000000000003000400
      000074727565040007000000756E6B6E6F776E05003800000068747470733A2F
      2F646F63756D656E7465722E676574706F73746D616E2E636F6D2F766965772F
      31343035393934382F547A65634234664806000E00000047616D657320262043
      6F6D696373FEFEFF1B1C003C020000FF1D0000060000004469736E6579010020
      000000496E666F726D6174696F6E206F66204469736E65792063686172616374
      6572730200000000000300040000007472756504000300000079657305001500
      000068747470733A2F2F6469736E65796170692E64657606000E00000047616D
      6573202620436F6D696373FEFEFF1B1C003D020000FF1D000006000000446F74
      61203201004A00000050726F766964657320696E666F726D6174696F6E206162
      6F757420506C61796572207374617473202C204D617463682073746174732C20
      52616E6B696E677320666F7220446F746120320200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001A00000068747470
      733A2F2F646F63732E6F70656E646F74612E636F6D2F06000E00000047616D65
      73202620436F6D696373FEFEFF1B1C003E020000FF1D00001400000044756E67
      656F6E7320616E6420447261676F6E7301003D0000005265666572656E636520
      666F72203574682065646974696F6E207370656C6C732C20636C61737365732C
      206D6F6E73746572732C20616E64206D6F726502000000000003000500000066
      616C73650400020000006E6F05001D00000068747470733A2F2F7777772E646E
      6435656170692E636F2F646F63732F06000E00000047616D6573202620436F6D
      696373FEFEFF1B1C003F020000FF1D00002000000044756E67656F6E7320616E
      6420447261676F6E732028416C7465726E61746529010061000000496E636C75
      64657320616C6C206D6F6E737465727320616E64207370656C6C732066726F6D
      2074686520535244202853797374656D205265666572656E636520446F63756D
      656E74292061732077656C6C2061732061207365617263682041504902000000
      0000030004000000747275650400030000007965730500130000006874747073
      3A2F2F6F70656E35652E636F6D2F06000E00000047616D6573202620436F6D69
      6373FEFEFF1B1C0040020000FF1D00000A000000457665204F6E6C696E650100
      2300000054686972642D506172747920446576656C6F70657220446F63756D65
      6E746174696F6E0200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05001A00000068747470733A2F2F6573692E6576657465
      63682E6E65742F756906000E00000047616D6573202620436F6D696373FEFEFF
      1B1C0041020000FF1D00000D000000464658495620436F6C6C65637401002600
      000046696E616C2046616E74617379205849562064617461206F6E20636F6C6C
      65637461626C6573020000000000030004000000747275650400030000007965
      7305001900000068747470733A2F2F6666786976636F6C6C6563742E636F6D2F
      06000E00000047616D6573202620436F6D696373FEFEFF1B1C0042020000FF1D
      0000120000004649464120556C74696D617465205465616D01001C0000004649
      464120556C74696D617465205465616D206974656D7320415049020000000000
      03000400000074727565040007000000756E6B6E6F776E050038000000687474
      70733A2F2F7777772E656173706F7274732E636F6D2F666966612F756C74696D
      6174652D7465616D2F6170692F6675742F6974656D06000E00000047616D6573
      202620436F6D696373FEFEFF1B1C0043020000FF1D00001100000046696E616C
      2046616E746173792058495601001F00000046696E616C2046616E7461737920
      5849562047616D65206461746120415049020000000000030004000000747275
      6504000300000079657305001300000068747470733A2F2F7869766170692E63
      6F6D2F06000E00000047616D6573202620436F6D696373FEFEFF1B1C00440200
      00FF1D000008000000466F72746E69746501000E000000466F72746E69746520
      53746174730200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05002400000068747470733A2F2F666F72746E6974657472
      61636B65722E636F6D2F736974652D61706906000E00000047616D6573202620
      436F6D696373FEFEFF1B1C0045020000FF1D000005000000466F727A61010023
      00000053686F772072616E646F6D20696D616765206F66206361722066726F6D
      20466F727A6102000000000003000400000074727565040007000000756E6B6E
      6F776E05001900000068747470733A2F2F646F63732E666F727A612D6170692E
      746B06000E00000047616D6573202620436F6D696373FEFEFF1B1C0046020000
      FF1D00000A00000046726565546F47616D6501001B000000467265652D546F2D
      506C61792047616D657320446174616261736502000000000003000400000074
      72756504000300000079657305002200000068747470733A2F2F7777772E6672
      6565746F67616D652E636F6D2F6170692D646F6306000E00000047616D657320
      2620436F6D696373FEFEFF1B1C0047020000FF1D00000900000046756E204661
      63747301001000000052616E646F6D2046756E20466163747302000000000003
      00040000007472756504000300000079657305002800000068747470733A2F2F
      61736C692D66756E2D666163742D6170692E6865726F6B756170702E636F6D2F
      06000E00000047616D6573202620436F6D696373FEFEFF1B1C0048020000FF1D
      00000F00000046756E5472616E736C6174696F6E730100230000005472616E73
      6C617465205465787420696E746F2066756E6E79206C616E6775616765730200
      0000000003000400000074727565040003000000796573050020000000687474
      70733A2F2F6170692E66756E7472616E736C6174696F6E732E636F6D2F06000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0049020000FF1D00000A
      00000047616D6572506F77657201001600000047616D65204769766561776179
      7320547261636B65720200000000000300040000007472756504000300000079
      657305002300000068747470733A2F2F7777772E67616D6572706F7765722E63
      6F6D2F6170692D7265616406000E00000047616D6573202620436F6D696373FE
      FEFF1B1C004A020000FF1D000009000000474442726F77736572010029000000
      456173792077617920746F20757365207468652047656F6D6574727920446173
      6820536572766572730200000000000300040000007472756504000700000075
      6E6B6E6F776E05001900000068747470733A2F2F676462726F777365722E636F
      6D2F61706906000E00000047616D6573202620436F6D696373FEFEFF1B1C004B
      020000FF1D00000A0000004765656B2D4A6F6B65730100520000004665746368
      20612072616E646F6D206765656B792F70726F6772616D6D696E672072656C61
      746564206A6F6B6520666F722075736520696E20616C6C20736F727473206F66
      206170706C69636174696F6E7302000000000003000400000074727565040003
      00000079657305002E00000068747470733A2F2F6769746875622E636F6D2F73
      616D6565726B756D617231382F6765656B2D6A6F6B652D61706906000E000000
      47616D6573202620436F6D696373FEFEFF1B1C004C020000FF1D00000E000000
      47656E7368696E20496D7061637401001800000047656E7368696E20496D7061
      63742067616D6520646174610200000000000300040000007472756504000300
      000079657305001300000068747470733A2F2F67656E7368696E2E6465760600
      0E00000047616D6573202620436F6D696373FEFEFF1B1C004D020000FF1D0000
      0A0000004769616E7420426F6D6201000B000000566964656F2047616D657302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002B00000068747470733A2F2F7777772E6769616E74626F6D622E636F
      6D2F6170692F646F63756D656E746174696F6E06000E00000047616D65732026
      20436F6D696373FEFEFF1B1C004E020000FF1D00000F0000004772617068514C
      20506F6B656D6F6E01003D0000004772617068514C20706F776572656420506F
      6B656D6F6E204150492E20537570706F7274732067656E65726174696F6E7320
      31207468726F7567682038020000000000030004000000747275650400030000
      0079657305002A00000068747470733A2F2F6769746875622E636F6D2F666176
      776172652F6772617068716C2D706F6B656D6F6E06000E00000047616D657320
      2620436F6D696373FEFEFF1B1C004F020000FF1D00000C0000004775696C6420
      57617273203201001D0000004775696C64205761727320322047616D6520496E
      666F726D6174696F6E0200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05002900000068747470733A2F2F77696B692E67
      75696C6477617273322E636F6D2F77696B692F4150493A4D61696E06000E0000
      0047616D6573202620436F6D696373FEFEFF1B1C0050020000FF1D0000080000
      0047573253706964790100390000004757325370696479204150492C20497465
      6D732064617461206F6E20746865204775696C64205761727320322054726164
      65204D61726B657402000000000003000400000074727565040007000000756E
      6B6E6F776E05002C00000068747470733A2F2F6769746875622E636F6D2F7275
      62656E7361797368692F67773273706964792F77696B6906000E00000047616D
      6573202620436F6D696373FEFEFF1B1C0051020000FF1D00000400000048616C
      6F01002200000048616C6F203520616E642048616C6F2057617273203220496E
      666F726D6174696F6E0200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05001E00000068747470733A2F2F646576656C6F
      7065722E68616C6F6170692E636F6D2F06000E00000047616D6573202620436F
      6D696373FEFEFF1B1C0052020000FF1D00000B00000048656172746873746F6E
      6501001D00000048656172746873746F6E6520436172647320496E666F726D61
      74696F6E02000D000000582D4D6173686170652D4B6579030004000000747275
      65040007000000756E6B6E6F776E05001A000000687474703A2F2F6865617274
      6873746F6E656170692E636F6D2F06000E00000047616D6573202620436F6D69
      6373FEFEFF1B1C0053020000FF1D00000D00000048756D626C652042756E646C
      6501001F00000048756D626C652042756E646C6527732063757272656E742062
      756E646C65730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002E00000068747470733A2F2F72617069646170692E
      636F6D2F5A6967676F746F2F6170692F68756D626C652D62756E646C6506000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0054020000FF1D000005
      00000048756D6F7201001700000048756D6F722C204A6F6B65732C20616E6420
      4D656D65730200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001400000068747470733A2F2F68756D6F726170692E63
      6F6D06000E00000047616D6573202620436F6D696373FEFEFF1B1C0055020000
      FF1D0000070000004879706978656C0100140000004879706978656C20706C61
      7965722073746174730200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05001800000068747470733A2F2F6170692E6879
      706978656C2E6E65742F06000E00000047616D6573202620436F6D696373FEFE
      FF1B1C0056020000FF1D000011000000487972756C6520436F6D70656E646975
      6D01003C00000044617461206F6E20616C6C20696E7465726163746976652069
      74656D732066726F6D20546865204C6567656E64206F66205A656C64613A2042
      4F545702000000000003000400000074727565040007000000756E6B6E6F776E
      05003100000068747470733A2F2F6769746875622E636F6D2F6761646861676F
      642F487972756C652D436F6D70656E6469756D2D41504906000E00000047616D
      6573202620436F6D696373FEFEFF1B1C0057020000FF1D000006000000487974
      616C6501001A000000487974616C6520626C6F6720706F73747320616E64206A
      6F627302000000000003000400000074727565040007000000756E6B6E6F776E
      05001700000068747470733A2F2F687974616C652D6170692E636F6D2F06000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0058020000FF1D000008
      000000494744422E636F6D010013000000566964656F2047616D652044617461
      626173650200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001900000068747470733A2F2F6170692D646F63732E6967
      64622E636F6D06000E00000047616D6573202620436F6D696373FEFEFF1B1C00
      59020000FF1D0000070000004A6F6B6541504901002900000050726F6772616D
      6D696E672C204D697363656C6C616E656F757320616E64204461726B204A6F6B
      65730200000000000300040000007472756504000300000079657305001D0000
      0068747470733A2F2F73763434332E6E65742F6A6F6B656170692F76322F0600
      0E00000047616D6573202620436F6D696373FEFEFF1B1C005A020000FF1D0000
      090000004A6F6B6573204F6E650100430000004A6F6B65206F66207468652064
      617920616E64206C617267652063617465676F7279206F66206A6F6B65732061
      636365737369626C65207669612052455354204150490200060000006170694B
      65790300040000007472756504000300000079657305001B0000006874747073
      3A2F2F6A6F6B65732E6F6E652F6170692F6A6F6B652F06000E00000047616D65
      73202620436F6D696373FEFEFF1B1C005B020000FF1D0000080000004A736572
      7669636501001A0000004A656F7061726479205175657374696F6E2044617461
      6261736502000000000003000500000066616C7365040007000000756E6B6E6F
      776E050012000000687474703A2F2F6A736572766963652E696F06000E000000
      47616D6573202620436F6D696373FEFEFF1B1C005C020000FF1D000007000000
      4C69636865737301003E00000041636365737320746F20616C6C206461746120
      6F662075736572732C2067616D65732C2070757A7A6C657320616E6420657463
      206F6E204C6963686573730200050000004F4175746803000400000074727565
      040007000000756E6B6E6F776E05001700000068747470733A2F2F6C69636865
      73732E6F72672F61706906000E00000047616D6573202620436F6D696373FEFE
      FF1B1C005D020000FF1D0000130000004D616769632054686520476174686572
      696E670100240000004D616769632054686520476174686572696E672047616D
      6520496E666F726D6174696F6E02000000000003000500000066616C73650400
      07000000756E6B6E6F776E05001C000000687474703A2F2F6D61676963746865
      676174686572696E672E696F2F06000E00000047616D6573202620436F6D6963
      73FEFEFF1B1C005E020000FF1D00000F0000004D6172696F204B61727420546F
      757201002B00000041504920666F7220447269766572732C204B617274732C20
      476C696465727320616E6420436F75727365730200050000004F417574680300
      0400000074727565040007000000756E6B6E6F776E05002A0000006874747073
      3A2F2F6D6172696F2D6B6172742D746F75722D6170692E6865726F6B75617070
      2E636F6D2F06000E00000047616D6573202620436F6D696373FEFEFF1B1C005F
      020000FF1D0000060000004D617276656C01000D0000004D617276656C20436F
      6D6963730200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001C00000068747470733A2F2F646576656C6F7065722E6D
      617276656C2E636F6D06000E00000047616D6573202620436F6D696373FEFEFF
      1B1C0060020000FF1D0000170000004D696E6563726166742053657276657220
      53746174757301002F00000041504920746F2067657420496E666F726D617469
      6F6E2061626F75742061204D696E656372616674205365727665720200000000
      00030004000000747275650400020000006E6F05001800000068747470733A2F
      2F6170692E6D63737276737461742E757306000E00000047616D657320262043
      6F6D696373FEFEFF1B1C0061020000FF1D0000090000004D4D4F2047616D6573
      0100260000004D4D4F2047616D65732044617461626173652C204E6577732061
      6E64204769766561776179730200000000000300040000007472756504000200
      00006E6F05001B00000068747470733A2F2F7777772E6D6D6F626F6D622E636F
      6D2F61706906000E00000047616D6573202620436F6D696373FEFEFF1B1C0062
      020000FF1D0000060000006D6F642E696F01001600000043726F737320506C61
      74666F726D204D6F64204150490200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001300000068747470733A2F2F646F
      63732E6D6F642E696F06000E00000047616D6573202620436F6D696373FEFEFF
      1B1C0063020000FF1D0000060000004D6F6A616E670100160000004D6F6A616E
      67202F204D696E656372616674204150490200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05001A00000068747470733A
      2F2F77696B692E76672F4D6F6A616E675F41504906000E00000047616D657320
      2620436F6D696373FEFEFF1B1C0064020000FF1D0000140000004D6F6E737465
      722048756E74657220576F726C640100190000004D6F6E737465722048756E74
      657220576F726C64206461746102000000000003000400000074727565040003
      00000079657305001800000068747470733A2F2F646F63732E6D68772D64622E
      636F6D2F06000E00000047616D6573202620436F6D696373FEFEFF1B1C006502
      0000FF1D00000B0000004F70656E205472697669610100100000005472697669
      61205175657374696F6E73020000000000030004000000747275650400070000
      00756E6B6E6F776E05002200000068747470733A2F2F6F70656E7464622E636F
      6D2F6170695F636F6E6669672E70687006000E00000047616D6573202620436F
      6D696373FEFEFF1B1C0066020000FF1D00000A00000050616E646153636F7265
      01001A000000452D73706F7274732067616D657320616E6420726573756C7473
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05002100000068747470733A2F2F646576656C6F706572732E70616E64
      6173636F72652E636F2F06000E00000047616D6573202620436F6D696373FEFE
      FF1B1C0067020000FF1D00000D00000050617468206F66204578696C6501001E
      00000050617468206F66204578696C652047616D6520496E666F726D6174696F
      6E0200050000004F4175746803000400000074727565040007000000756E6B6E
      6F776E05002A00000068747470733A2F2F7777772E706174686F666578696C65
      2E636F6D2F646576656C6F7065722F646F637306000E00000047616D65732026
      20436F6D696373FEFEFF1B1C0068020000FF1D000008000000506C6179657244
      420100280000005175657279204D696E6563726166742C20537465616D20616E
      642058426F78204163636F756E74730200000000000300040000007472756504
      0007000000756E6B6E6F776E05001400000068747470733A2F2F706C61796572
      64622E636F2F06000E00000047616D6573202620436F6D696373FEFEFF1B1C00
      69020000FF1D000008000000506F6BC3A9617069010014000000506F6BC3A96D
      6F6E20496E666F726D6174696F6E020000000000030004000000747275650400
      07000000756E6B6E6F776E05001200000068747470733A2F2F706F6B65617069
      2E636F06000E00000047616D6573202620436F6D696373FEFEFF1B1C006A0200
      00FF1D000012000000506F6BC3A941504920284772617068514C290100220000
      0054686520556E6F6666696369616C204772617068514C20666F7220506F6B65
      4150490200000000000300040000007472756504000300000079657305002A00
      000068747470733A2F2F6769746875622E636F6D2F6D617A6970616E2F677261
      7068716C2D706F6B6561706906000E00000047616D6573202620436F6D696373
      FEFEFF1B1C006B020000FF1D00000C000000506F6BC3A96D6F6E205443470100
      18000000506F6BC3A96D6F6E2054434720496E666F726D6174696F6E02000000
      000003000400000074727565040007000000756E6B6E6F776E05001500000068
      747470733A2F2F706F6B656D6F6E7463672E696F06000E00000047616D657320
      2620436F6D696373FEFEFF1B1C006C020000FF1D00000B00000050737963686F
      6E6175747301003700000050737963686F6E6175747320576F726C6420436861
      7261637465727320496E666F726D6174696F6E20616E642050534920506F7765
      7273020000000000030004000000747275650400030000007965730500240000
      0068747470733A2F2F70737963686F6E617574732D6170692E6E65746C696679
      2E6170702F06000E00000047616D6573202620436F6D696373FEFEFF1B1C006D
      020000FF1D0000040000005055424701001800000041636365737320696E2D67
      616D65205055424720646174610200060000006170694B657903000400000074
      72756504000300000079657305001B00000068747470733A2F2F646576656C6F
      7065722E707562672E636F6D2F06000E00000047616D6573202620436F6D6963
      73FEFEFF1B1C006E020000FF1D00000A0000005075796F204E6578757301002A
      0000005075796F205075796F20696E666F726D6174696F6E2066726F6D205075
      796F204E657875732057696B6902000000000003000400000074727565040003
      00000079657305002C00000068747470733A2F2F6769746875622E636F6D2F64
      656C7461646578372F7075796F64622D6170692D64656E6F06000E0000004761
      6D6573202620436F6D696373FEFEFF1B1C006F020000FF1D00000A0000007175
      697A6170692E696F01002800000041636365737320746F20766172696F757320
      6B696E64206F66207175697A207175657374696F6E730200060000006170694B
      6579030004000000747275650400030000007965730500130000006874747073
      3A2F2F7175697A6170692E696F2F06000E00000047616D6573202620436F6D69
      6373FEFEFF1B1C0070020000FF1D000006000000526169646572010063000000
      50726F76696465732064657461696C65642063686172616374657220616E6420
      6775696C642072616E6B696E677320666F722052616964696E6720616E64204D
      79746869632B20636F6E74656E7420696E20576F726C64206F66205761726372
      61667402000000000003000400000074727565040007000000756E6B6E6F776E
      05001500000068747470733A2F2F7261696465722E696F2F61706906000E0000
      0047616D6573202620436F6D696373FEFEFF1B1C0071020000FF1D0000070000
      00524157472E696F0100310000003530302C3030302B2067616D657320666F72
      20353020706C6174666F726D7320696E636C7564696E67206D6F62696C657302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001700000068747470733A2F2F726177672E696F2F617069646F637306
      000E00000047616D6573202620436F6D696373FEFEFF1B1C0072020000FF1D00
      000E0000005269636B20616E64204D6F727479010034000000416C6C20746865
      205269636B20616E64204D6F72747920696E666F726D6174696F6E2C20696E63
      6C7564696E6720696D6167657302000000000003000400000074727565040003
      00000079657305001B00000068747470733A2F2F7269636B616E646D6F727479
      6170692E636F6D06000E00000047616D6573202620436F6D696373FEFEFF1B1C
      0073020000FF1D00000A00000052696F742047616D65730100220000004C6561
      677565206F66204C6567656E64732047616D6520496E666F726D6174696F6E02
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002000000068747470733A2F2F646576656C6F7065722E72696F746761
      6D65732E636F6D2F06000E00000047616D6573202620436F6D696373FEFEFF1B
      1C0074020000FF1D00000700000052505320313031010026000000526F636B2C
      2050617065722C2053636973736F7273207769746820313031206F626A656374
      7302000000000003000400000074727565040003000000796573050025000000
      68747470733A2F2F7270733130312E707974686F6E616E7977686572652E636F
      6D2F61706906000E00000047616D6573202620436F6D696373FEFEFF1B1C0075
      020000FF1D00000900000052756E65536361706501002300000052756E655363
      61706520616E64204F535253205250477320696E666F726D6174696F6E020000
      000000030004000000747275650400020000006E6F05003A0000006874747073
      3A2F2F72756E6573636170652E77696B692F772F4170706C69636174696F6E5F
      70726F6772616D6D696E675F696E7465726661636506000E00000047616D6573
      202620436F6D696373FEFEFF1B1C0076020000FF1D00001100000053616B7572
      612043617264436170746F7201002300000053616B7572612043617264436170
      746F7220436172647320496E666F726D6174696F6E0200000000000300040000
      0074727565040007000000756E6B6E6F776E05003100000068747470733A2F2F
      6769746875622E636F6D2F4A65737356656C2F73616B7572612D636172642D63
      6170746F722D61706906000E00000047616D6573202620436F6D696373FEFEFF
      1B1C0077020000FF1D0000080000005363727966616C6C01001D0000004D6167
      69633A2054686520476174686572696E67206461746162617365020000000000
      0300040000007472756504000300000079657305001D00000068747470733A2F
      2F7363727966616C6C2E636F6D2F646F63732F61706906000E00000047616D65
      73202620436F6D696373FEFEFF1B1C0078020000FF1D00000F00000053706163
      655472616465727341504901002E0000004120706C617961626C6520696E7465
      722D67616C61637469632073706163652074726164696E67204D4D4F41504902
      00050000004F4175746803000400000074727565040003000000796573050024
      00000068747470733A2F2F7370616365747261646572732E696F3F72656C3D70
      75622D6170697306000E00000047616D6573202620436F6D696373FEFEFF1B1C
      0079020000FF1D000005000000537465616D01001B000000537465616D205765
      622041504920646F63756D656E746174696F6E0200060000006170694B657903
      0004000000747275650400020000006E6F05001900000068747470733A2F2F73
      7465616D6170692E787061772E6D652F06000E00000047616D6573202620436F
      6D696373FEFEFF1B1C007A020000FF1D000005000000537465616D0100240000
      00496E7465726E616C20537465616D205765622041504920646F63756D656E74
      6174696F6E020000000000030004000000747275650400020000006E6F050034
      00000068747470733A2F2F6769746875622E636F6D2F5265766164696B652F49
      6E7465726E616C537465616D5765624150492F77696B6906000E00000047616D
      6573202620436F6D696373FEFEFF1B1C007B020000FF1D00000B000000537570
      65724865726F6573010047000000416C6C2053757065724865726F657320616E
      642056696C6C61696E7320646174612066726F6D20616C6C20756E6976657273
      657320756E64657220612073696E676C65204150490200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500180000006874
      7470733A2F2F73757065726865726F6170692E636F6D06000E00000047616D65
      73202620436F6D696373FEFEFF1B1C007C020000FF1D00000600000054434764
      65780100280000004D756C7469206C616E67756167657320506F6BC3A96D6F6E
      2054434720496E666F726D6174696F6E02000000000003000400000074727565
      04000300000079657305001B00000068747470733A2F2F7777772E7463676465
      782E6E65742F646F637306000E00000047616D6573202620436F6D696373FEFE
      FF1B1C007D020000FF1D000005000000546562657801002E0000005465626578
      2041504920666F7220696E666F726D6174696F6E2061626F75742067616D6520
      70757263686173657302000D000000582D4D6173686170652D4B657903000400
      0000747275650400020000006E6F05001D00000068747470733A2F2F646F6373
      2E74656265782E696F2F706C7567696E2F06000E00000047616D657320262043
      6F6D696373FEFEFF1B1C007E020000FF1D000007000000544554522E494F0100
      19000000544554522E494F205465747261204368616E6E656C20415049020000
      00000003000400000074727565040007000000756E6B6E6F776E05001A000000
      68747470733A2F2F746574722E696F2F61626F75742F6170692F06000E000000
      47616D6573202620436F6D696373FEFEFF1B1C007F020000FF1D00000C000000
      54726F6E616C642044756D7001002D0000005468652064756D62657374207468
      696E677320446F6E616C64205472756D70206861732065766572207361696402
      000000000003000400000074727565040007000000756E6B6E6F776E05001B00
      000068747470733A2F2F7777772E74726F6E616C6464756D702E696F2F06000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0080020000FF1D00000B
      000000556E6976657273616C697301002300000046696E616C2046616E746173
      7920584956206D61726B657420626F6172642064617461020000000000030004
      0000007472756504000300000079657305002700000068747470733A2F2F756E
      6976657273616C69732E6170702F646F63732F696E6465782E68746D6C06000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0081020000FF1D000017
      00000056616C6F72616E7420286E6F6E2D6F6666696369616C29010050000000
      416E20657874656E736976652041504920636F6E7461696E696E672064617461
      206F66206D6F73742056616C6F72616E7420696E2D67616D65206974656D732C
      2061737365747320616E64206D6F726502000000000003000400000074727565
      040007000000756E6B6E6F776E05001800000068747470733A2F2F76616C6F72
      616E742D6170692E636F6D06000E00000047616D6573202620436F6D696373FE
      FEFF1B1C0082020000FF1D0000160000005761726661636520286E6F6E2D6F66
      66696369616C2901003F0000004F6666696369616C204150492070726F787920
      776974682062657474657220646174612073747275637475726520616E64206D
      6F72652066656174757265730200000000000300040000007472756504000200
      00006E6F05001600000068747470733A2F2F6170692E776673746174732E6366
      06000E00000047616D6573202620436F6D696373FEFEFF1B1C0083020000FF1D
      00000D00000057617267616D696E672E6E657401001C00000057617267616D69
      6E672E6E657420696E666F20616E642073746174730200060000006170694B65
      79030004000000747275650400020000006E6F05002100000068747470733A2F
      2F646576656C6F706572732E77617267616D696E672E6E65742F06000E000000
      47616D6573202620436F6D696373FEFEFF1B1C0084020000FF1D000015000000
      5768656E206973206E657874204D43552066696C6D01001D0000005570636F6D
      696E67204D43552066696C6D20696E666F726D6174696F6E0200000000000300
      0400000074727565040007000000756E6B6E6F776E0500420000006874747073
      3A2F2F6769746875622E636F6D2F44696C6A6F7453472F4D43552D436F756E74
      646F776E2F626C6F622F646576656C6F702F646F63732F4150492E6D6406000E
      00000047616D6573202620436F6D696373FEFEFF1B1C0085020000FF1D000004
      000000786B636401001C000000526574726965766520786B636420636F6D6963
      73206173204A534F4E020000000000030004000000747275650400020000006E
      6F05001A00000068747470733A2F2F786B63642E636F6D2F6A736F6E2E68746D
      6C06000E00000047616D6573202620436F6D696373FEFEFF1B1C0086020000FF
      1D00000900000059752D47692D4F682101001900000059752D47692D4F682120
      54434720496E666F726D6174696F6E0200000000000300040000007472756504
      0007000000756E6B6E6F776E05002400000068747470733A2F2F64622E79676F
      70726F6465636B2E636F6D2F6170692D67756964652F06000E00000047616D65
      73202620436F6D696373FEFEFF1B1C0087020000FF1D00001700000041627374
      726163742049502047656F6C6F636174696F6E01002900000047656F6C6F6361
      746520776562736974652076697369746F72732066726F6D2074686569722049
      50730200060000006170694B6579030004000000747275650400030000007965
      7305002E00000068747470733A2F2F7777772E61627374726163746170692E63
      6F6D2F69702D67656F6C6F636174696F6E2D61706906000900000047656F636F
      64696E67FEFEFF1B1C0088020000FF1D000011000000416374696E6961204772
      6173732047495301004C000000416374696E696120697320616E206F70656E20
      736F7572636520524553542041504920666F722067656F67726170686963616C
      2064617461207468617420757365732047524153532047495302000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05002600
      000068747470733A2F2F616374696E69612E6D756E6469616C69732E64652F61
      70695F646F63732F06000900000047656F636F64696E67FEFEFF1B1C00890200
      00FF1D00001A00000061646D696E6973747261746976652D64697669736F6E73
      2D646201002D00000047657420616C6C2061646D696E69737472617469766520
      6469766973696F6E73206F66206120636F756E74727902000000000003000400
      00007472756504000300000079657305003D00000068747470733A2F2F676974
      6875622E636F6D2F6B616D696B617A656368617365722F61646D696E69737472
      61746976652D6469766973696F6E732D646206000900000047656F636F64696E
      67FEFEFF1B1C008A020000FF1D000014000000616472657373652E646174612E
      676F75762E667201003100000041646472657373206461746162617365206F66
      204672616E63652C2067656F636F64696E6720616E6420726576657273650200
      0000000003000400000074727565040007000000756E6B6E6F776E05001C0000
      0068747470733A2F2F616472657373652E646174612E676F75762E6672060009
      00000047656F636F64696E67FEFEFF1B1C008B020000FF1D0000090000004169
      7274656C20495001003900000049502047656F6C6F636174696F6E204150492E
      20436F6C6C656374696E6720646174612066726F6D206D756C7469706C652073
      6F757263657302000000000003000400000074727565040007000000756E6B6E
      6F776E05003300000068747470733A2F2F7379732E61697274656C2E6C762F69
      7032636F756E7472792F312E312E312E312F3F66756C6C3D7472756506000900
      000047656F636F64696E67FEFEFF1B1C008C020000FF1D000005000000417069
      6970010026000000476574206C6F636174696F6E20696E666F726D6174696F6E
      20627920495020616464726573730200060000006170694B6579030004000000
      7472756504000300000079657305001200000068747470733A2F2F6170696970
      2E6E65742F06000900000047656F636F64696E67FEFEFF1B1C008D020000FF1D
      0000100000006170696C61796572206970737461636B0100320000004C6F6361
      746520616E64206964656E7469667920776562736974652076697369746F7273
      20627920495020616464726573730200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001400000068747470733A2F2F69
      70737461636B2E636F6D2F06000900000047656F636F64696E67FEFEFF1B1C00
      8E020000FF1D0000070000004261747475746101002F000000412028636F756E
      7472792F726567696F6E2F636974792920696E2D63617363616465206C6F6361
      74696F6E204150490200060000006170694B657903000500000066616C736504
      0007000000756E6B6E6F776E05001A000000687474703A2F2F62617474757461
      2E6D6564756E65732E6E657406000900000047656F636F64696E67FEFEFF1B1C
      008F020000FF1D00000C00000042696744617461436C6F756401005D00000050
      726F7669646573206661737420616E642061636375726174652049502067656F
      6C6F636174696F6E204150497320616C6F6E6720776974682073656375726974
      7920636865636B7320616E6420636F6E666964656E6365206172656102000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      003000000068747470733A2F2F7777772E62696764617461636C6F75642E636F
      6D2F69702D67656F6C6F636174696F6E2D6170697306000900000047656F636F
      64696E67FEFEFF1B1C0090020000FF1D00000900000042696E67204D61707301
      00350000004372656174652F637573746F6D697A65206469676974616C206D61
      7073206261736564206F6E2042696E67204D6170732064617461020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E05001F
      00000068747470733A2F2F7777772E6D6963726F736F66742E636F6D2F6D6170
      732F06000900000047656F636F64696E67FEFEFF1B1C0091020000FF1D00000B
      000000626E67326C61746C6F6E67010063000000436F6E766572742042726974
      697368204F53474233362065617374696E6720616E64206E6F727468696E6720
      2842726974697368204E6174696F6E616C20477269642920746F205747533834
      206C6174697475646520616E64206C6F6E676974756465020000000000030004
      0000007472756504000300000079657305002600000068747470733A2F2F7777
      772E676574746865646174612E636F6D2F626E67326C61746C6F6E6706000900
      000047656F636F64696E67FEFEFF1B1C0092020000FF1D000009000000436172
      7465732E696F010024000000437265617465206D61707320616E64206D61726B
      65727320666F7220616E797468696E6702000000000003000400000074727565
      040007000000756E6B6E6F776E05003300000068747470733A2F2F6769746875
      622E636F6D2F4D2D4D656469612D47726F75702F4361727465732E696F2F7769
      6B692F41504906000900000047656F636F64696E67FEFEFF1B1C0093020000FF
      1D0000060000004365702E6C610100610000004272617A696C20524553546675
      6C2041504920746F2066696E6420696E666F726D6174696F6E2061626F757420
      737472656574732C207A697020636F6465732C206E65696768626F72686F6F64
      732C2063697469657320616E6420737461746573020000000000030005000000
      66616C7365040007000000756E6B6E6F776E05000E000000687474703A2F2F63
      65702E6C612F06000900000047656F636F64696E67FEFEFF1B1C0094020000FF
      1D0000070000004369747953444B0100240000004F70656E204150497320666F
      722073656C656374204575726F7065616E206369746965730200000000000300
      0400000074727565040007000000756E6B6E6F776E050026000000687474703A
      2F2F7777772E6369747973646B2E65752F6369747973646B2D746F6F6C6B6974
      2F06000900000047656F636F64696E67FEFEFF1B1C0095020000FF1D00000700
      0000436F756E74727901002800000047657420796F75722076697369746F7227
      7320636F756E7472792066726F6D207468656972204950020000000000030004
      00000074727565040003000000796573050012000000687474703A2F2F636F75
      6E7472792E69732F06000900000047656F636F64696E67FEFEFF1B1C00960200
      00FF1D000010000000436F756E74727953746174654369747901006100000057
      6F726C6420636F756E74726965732C207374617465732C20726567696F6E732C
      2070726F76696E6365732C20636974696573202620746F776E7320696E204A53
      4F4E2C2053514C2C20584D4C2C2059414D4C2C20262043535620666F726D6174
      0200060000006170694B65790300040000007472756504000300000079657305
      001C00000068747470733A2F2F636F756E7472797374617465636974792E696E
      2F06000900000047656F636F64696E67FEFEFF1B1C0097020000FF1D00000F00
      00004475636B7320556E6C696D69746564010050000000415049206578706C6F
      726572207468617420676976657320612071756572792055524C207769746820
      61204A534F4E20726573706F6E7365206F66206C6F636174696F6E7320616E64
      20636974696573020000000000030004000000747275650400020000006E6F05
      003900000068747470733A2F2F6769732E6475636B732E6F72672F6461746173
      6574732F64752D756E69766572736974792D63686170746572732F6170690600
      0900000047656F636F64696E67FEFEFF1B1C0098020000FF1D00000900000046
      72656547656F4950010046000000467265652067656F20697020696E666F726D
      6174696F6E2C206E6F20726567697374726174696F6E2072657175697265642E
      2031356B2F686F75722072617465206C696D6974020000000000030004000000
      7472756504000300000079657305001600000068747470733A2F2F6672656567
      656F69702E6170702F06000900000047656F636F64696E67FEFEFF1B1C009902
      0000FF1D00000600000047656F4170690100180000004672656E63682067656F
      67726170686963616C2064617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05002300000068747470733A2F2F6170692E676F75
      762E66722F6170692F67656F6170692E68746D6C06000900000047656F636F64
      696E67FEFEFF1B1C009A020000FF1D00000800000047656F6170696679010033
      000000466F727761726420616E6420726576657273652067656F636F64696E67
      2C2061646472657373206175746F636F6D706C6574650200060000006170694B
      65790300040000007472756504000300000079657305002B0000006874747073
      3A2F2F7777772E67656F61706966792E636F6D2F6170692F67656F636F64696E
      672D6170692F06000900000047656F636F64696E67FEFEFF1B1C009B020000FF
      1D00000900000047656F636F642E696F01002D00000041646472657373206765
      6F636F64696E67202F20726576657273652067656F636F64696E6720696E2062
      756C6B0200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001600000068747470733A2F2F7777772E67656F636F642E69
      6F2F06000900000047656F636F64696E67FEFEFF1B1C009C020000FF1D00000B
      00000047656F636F64652E78797A01004C00000050726F766964657320776F72
      6C647769646520666F72776172642F726576657273652067656F636F64696E67
      2C2062617463682067656F636F64696E6720616E642067656F70617273696E67
      02000000000003000400000074727565040007000000756E6B6E6F776E050017
      00000068747470733A2F2F67656F636F64652E78797A2F617069060009000000
      47656F636F64696E67FEFEFF1B1C009D020000FF1D00000D00000047656F636F
      646966792E636F6D01003E000000576F726C64776964652067656F636F64696E
      672C2067656F70617273696E6720616E64206175746F636F6D706C6574652066
      6F72206164647265737365730200060000006170694B65790300040000007472
      756504000300000079657305001600000068747470733A2F2F67656F636F6469
      66792E636F6D2F06000900000047656F636F64696E67FEFEFF1B1C009E020000
      FF1D00000E00000047656F646174612E676F762E677201002F0000004F70656E
      2067656F7370617469616C206461746120616E64204150492073657276696365
      20666F7220477265656365020000000000030004000000747275650400070000
      00756E6B6E6F776E05001A00000068747470733A2F2F67656F646174612E676F
      762E67722F656E2F06000900000047656F636F64696E67FEFEFF1B1C009F0200
      00FF1D00000D00000047656F44617461536F7572636501004200000047656F63
      6F64696E67206F662063697479206E616D65206279207573696E67206C617469
      7475646520616E64206C6F6E67697475646520636F6F7264696E617465730200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05002900000068747470733A2F2F7777772E67656F64617461736F75726365
      2E636F6D2F7765622D7365727669636506000900000047656F636F64696E67FE
      FEFF1B1C00A0020000FF1D00000C00000047656F444220436974696573010029
      00000047657420676C6F62616C20636974792C20726567696F6E2C20616E6420
      636F756E74727920646174610200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05002C000000687474703A2F2F67656F64
      622D6369746965732D6170692E776972656672656574686F756768742E636F6D
      2F06000900000047656F636F64696E67FEFEFF1B1C00A1020000FF1D00000A00
      000047656F6772617068514C0100260000004120436F756E7472792C20537461
      74652C20616E642043697479204772617068514C204150490200000000000300
      040000007472756504000300000079657305001E00000068747470733A2F2F67
      656F6772617068716C2E6E65746C6966792E61707006000900000047656F636F
      64696E67FEFEFF1B1C00A2020000FF1D00000500000047656F4A530100270000
      0049502067656F6C6F636174696F6E207769746820436861744F707320696E74
      6567726174696F6E020000000000030004000000747275650400030000007965
      7305001500000068747470733A2F2F7777772E67656F6A732E696F2F06000900
      000047656F636F64696E67FEFEFF1B1C00A3020000FF1D00000600000047656F
      6B656F01003B00000047656F6B656F2067656F636F64696E6720736572766963
      652D207769746820323530302066726565206170692072657175657374732064
      61696C7902000000000003000400000074727565040003000000796573050012
      00000068747470733A2F2F67656F6B656F2E636F6D06000900000047656F636F
      64696E67FEFEFF1B1C00A4020000FF1D00000800000047656F4E616D65730100
      27000000506C616365206E616D657320616E64206F746865722067656F677261
      70686963616C206461746102000000000003000500000066616C736504000700
      0000756E6B6E6F776E050030000000687474703A2F2F7777772E67656F6E616D
      65732E6F72672F6578706F72742F7765622D73657276696365732E68746D6C06
      000900000047656F636F64696E67FEFEFF1B1C00A5020000FF1D000009000000
      67656F506C7567696E01002600000049502067656F6C6F636174696F6E20616E
      642063757272656E637920636F6E76657273696F6E0200000000000300040000
      007472756504000300000079657305001900000068747470733A2F2F7777772E
      67656F706C7567696E2E636F6D06000900000047656F636F64696E67FEFEFF1B
      1C00A6020000FF1D000013000000476F6F676C6520456172746820456E67696E
      650100460000004120636C6F75642D626173656420706C6174666F726D20666F
      7220706C616E65746172792D7363616C6520656E7669726F6E6D656E74616C20
      6461746120616E616C797369730200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05002B00000068747470733A2F2F6465
      76656C6F706572732E676F6F676C652E636F6D2F65617274682D656E67696E65
      2F06000900000047656F636F64696E67FEFEFF1B1C00A7020000FF1D00000B00
      0000476F6F676C65204D6170730100370000004372656174652F637573746F6D
      697A65206469676974616C206D617073206261736564206F6E20476F6F676C65
      204D61707320646174610200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05002300000068747470733A2F2F646576656C
      6F706572732E676F6F676C652E636F6D2F6D6170732F06000900000047656F63
      6F64696E67FEFEFF1B1C00A8020000FF1D00000F000000477261706820436F75
      6E7472696573010062000000436F756E7472792D72656C617465642064617461
      206C696B652063757272656E636965732C206C616E6775616765732C20666C61
      67732C20726567696F6E732B737562726567696F6E7320616E6420626F726465
      72696E6720636F756E7472696573020000000000030004000000747275650400
      07000000756E6B6E6F776E05003100000068747470733A2F2F6769746875622E
      636F6D2F6C656E6E65727456616E53657665722F6772617068636F756E747269
      657306000900000047656F636F64696E67FEFEFF1B1C00A9020000FF1D00000A
      00000048656C6C6F53616C757401002D0000004765742068656C6C6F20747261
      6E736C6174696F6E20666F6C6C6F77696E672075736572206C616E6775616765
      02000000000003000400000074727565040007000000756E6B6E6F776E05002F
      00000068747470733A2F2F666F7572746F6E666973682E636F6D2F70726F6A65
      63742F68656C6C6F73616C75742D6170692F06000900000047656F636F64696E
      67FEFEFF1B1C00AA020000FF1D00000900000048455245204D61707301003500
      00004372656174652F637573746F6D697A65206469676974616C206D61707320
      6261736564206F6E2048455245204D6170732064617461020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001A000000
      68747470733A2F2F646576656C6F7065722E686572652E636F6D060009000000
      47656F636F64696E67FEFEFF1B1C00AB020000FF1D000013000000486972616B
      20495020746F20436F756E747279010062000000497020746F206C6F63617469
      6F6E207769746820636F756E74727920636F64652C2063757272656E63792063
      6F646520262063757272656E6379206E616D652C206661737420726573706F6E
      73652C20756E6C696D697465642072657175657374730200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05001E00000068
      747470733A2F2F69706C6F636174696F6E2E686972616B2E736974652F060009
      00000047656F636F64696E67FEFEFF1B1C00AC020000FF1D000017000000486F
      6E67204B6F6E672047656F446174612053746F72650100270000004150492066
      6F7220616363657373696E672067656F2D64617461206F6620486F6E67204B6F
      6E6702000000000003000400000074727565040007000000756E6B6E6F776E05
      001A00000068747470733A2F2F67656F646174612E676F762E686B2F67732F06
      000900000047656F636F64696E67FEFEFF1B1C00AD020000FF1D000004000000
      4942474501004C000000416767726567617465207365727669636573206F6620
      4942474520284272617A696C69616E20496E73746974757465206F662047656F
      67726170687920616E6420537461746973746963732902000000000003000400
      000074727565040007000000756E6B6E6F776E05002A00000068747470733A2F
      2F7365727669636F6461646F732E696267652E676F762E62722F6170692F646F
      63732F06000900000047656F636F64696E67FEFEFF1B1C00AE020000FF1D0000
      0C0000004950203220436F756E7472790100160000004D617020616E20495020
      746F206120636F756E7472790200000000000300040000007472756504000700
      0000756E6B6E6F776E05001700000068747470733A2F2F697032636F756E7472
      792E696E666F06000900000047656F636F64696E67FEFEFF1B1C00AF020000FF
      1D000012000000495020416464726573732044657461696C7301002000000046
      696E642067656F6C6F636174696F6E2077697468206970206164647265737302
      000000000003000400000074727565040007000000756E6B6E6F776E05001200
      000068747470733A2F2F6970696E666F2E696F2F06000900000047656F636F64
      696E67FEFEFF1B1C00B0020000FF1D00000C000000495020566967696C616E74
      65010017000000467265652049502047656F6C6F636174696F6E204150490200
      0000000003000400000074727565040007000000756E6B6E6F776E05001C0000
      0068747470733A2F2F7777772E6970766967696C616E74652E636F6D2F060009
      00000047656F636F64696E67FEFEFF1B1C00B1020000FF1D0000060000006970
      2D61706901002700000046696E64206C6F636174696F6E207769746820495020
      61646472657373206F7220646F6D61696E02000000000003000500000066616C
      7365040007000000756E6B6E6F776E05001700000068747470733A2F2F69702D
      6170692E636F6D2F646F637306000900000047656F636F64696E67FEFEFF1B1C
      00B2020000FF1D00000B0000004950324C6F636174696F6E0100390000004950
      2067656F6C6F636174696F6E20776562207365727669636520746F2067657420
      6D6F7265207468616E20353520706172616D6574657273020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050033000000
      68747470733A2F2F7777772E6970326C6F636174696F6E2E636F6D2F7765622D
      736572766963652F6970326C6F636174696F6E06000900000047656F636F6469
      6E67FEFEFF1B1C00B3020000FF1D00000800000049503250726F787901002500
      00004465746563742070726F787920616E642056504E207573696E6720495020
      616464726573730200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05003000000068747470733A2F2F7777772E6970326C
      6F636174696F6E2E636F6D2F7765622D736572766963652F69703270726F7879
      06000900000047656F636F64696E67FEFEFF1B1C00B4020000FF1D0000080000
      0069706170692E636F01002400000046696E642049502061646472657373206C
      6F636174696F6E20696E666F726D6174696F6E02000000000003000400000074
      72756504000300000079657305002200000068747470733A2F2F69706170692E
      636F2F6170692F23696E74726F64756374696F6E06000900000047656F636F64
      696E67FEFEFF1B1C00B5020000FF1D00000900000069706170692E636F6D0100
      320000005265616C2D74696D652047656F6C6F636174696F6E20262052657665
      727365204950204C6F6F6B75702052455354204150490200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05001200000068
      747470733A2F2F69706170692E636F6D2F06000900000047656F636F64696E67
      FEFEFF1B1C00B6020000FF1D000005000000495047454F010035000000556E6C
      696D697465642066726565204950204164647265737320415049207769746820
      75736566756C20696E666F726D6174696F6E0200000000000300040000007472
      7565040007000000756E6B6E6F776E05002200000068747470733A2F2F617069
      2E746563686E696B6E6577732E6E65742F697067656F2F06000900000047656F
      636F64696E67FEFEFF1B1C00B7020000FF1D00000D000000697067656F6C6F63
      6174696F6E01003700000049502047656F6C6F636174696F6E20415020776974
      68206672656520706C616E2033306B20726571756573747320706572206D6F6E
      74680200060000006170694B6579030004000000747275650400030000007965
      7305001900000068747470733A2F2F697067656F6C6F636174696F6E2E696F2F
      06000900000047656F636F64696E67FEFEFF1B1C00B8020000FF1D0000080000
      004950496E666F444201005C000000467265652047656F6C6F636174696F6E20
      746F6F6C7320616E64204150497320666F7220636F756E7472792C2072656769
      6F6E2C206369747920616E642074696D65207A6F6E65206C6F6F6B7570206279
      20495020616464726573730200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05001C00000068747470733A2F2F7777772E
      6970696E666F64622E636F6D2F61706906000900000047656F636F64696E67FE
      FEFF1B1C00B9020000FF1D0000070000006970737461636B0100320000004C6F
      6361746520616E64206964656E7469667920776562736974652076697369746F
      727320627920495020616464726573730200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001400000068747470733A2F
      2F6970737461636B2E636F6D2F06000900000047656F636F64696E67FEFEFF1B
      1C00BA020000FF1D00000A0000004B616B616F204D6170730100300000004B61
      6B616F204D6170732070726F76696465206D756C7469706C6520415049732066
      6F72204B6F7265616E206D6170730200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001A00000068747470733A2F2F61
      7069732E6D61702E6B616B616F2E636F6D06000900000047656F636F64696E67
      FEFEFF1B1C00BB020000FF1D0000190000006B657963646E204950204C6F6361
      74696F6E2046696E64657201005B000000476574207468652049502067656F6C
      6F636174696F6E2064617461207468726F756768207468652073696D706C6520
      52455354204150492E20416C6C2074686520726573706F6E7365732061726520
      4A534F4E20656E636F6465640200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05001C00000068747470733A2F2F746F6F
      6C732E6B657963646E2E636F6D2F67656F06000900000047656F636F64696E67
      FEFEFF1B1C00BC020000FF1D00000A0000004C6F636174696F6E495101003600
      000050726F766964657320666F72776172642F726576657273652067656F636F
      64696E6720616E642062617463682067656F636F64696E670200060000006170
      694B65790300040000007472756504000300000079657305001C000000687474
      70733A2F2F6C6F636174696F6E69712E6F72672F646F63732F06000900000047
      656F636F64696E67FEFEFF1B1C00BD020000FF1D00000A0000004C6F6E67646F
      204D6170010047000000496E746572616374697665206D617020776974682064
      657461696C656420706C6163657320616E6420696E666F726D6174696F6E2070
      6F7274616C20696E20546861696C616E640200060000006170694B6579030004
      0000007472756504000300000079657305001C00000068747470733A2F2F6D61
      702E6C6F6E67646F2E636F6D2F646F63732F06000900000047656F636F64696E
      67FEFEFF1B1C00BE020000FF1D0000060000004D6170626F7801002700000043
      72656174652F637573746F6D697A652062656175746966756C20646967697461
      6C206D6170730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001800000068747470733A2F2F646F63732E6D617062
      6F782E636F6D2F06000900000047656F636F64696E67FEFEFF1B1C00BF020000
      FF1D0000080000004D6170517565737401002E000000546F2061636365737320
      746F6F6C7320616E64207265736F757263657320746F206D6170207468652077
      6F726C640200060000006170694B657903000400000074727565040002000000
      6E6F05001F00000068747470733A2F2F646576656C6F7065722E6D6170717565
      73742E636F6D2F06000900000047656F636F64696E67FEFEFF1B1C00C0020000
      FF1D0000060000004D657869636F01001C0000004D657869636F205245535466
      756C207A697020636F6465732041504902000000000003000400000074727565
      040007000000756E6B6E6F776E05002500000068747470733A2F2F6769746875
      622E636F6D2F4963616C69614C6162732F7365706F6D65780600090000004765
      6F636F64696E67FEFEFF1B1C00C1020000FF1D0000090000004E6F6D696E6174
      696D01002E00000050726F766964657320776F726C647769646520666F727761
      7264202F20726576657273652067656F636F64696E6702000000000003000400
      00007472756504000300000079657305003700000068747470733A2F2F6E6F6D
      696E6174696D2E6F72672F72656C656173652D646F63732F6C61746573742F61
      70692F4F766572766965772F06000900000047656F636F64696E67FEFEFF1B1C
      00C2020000FF1D0000120000004F6E65204D61702C2053696E6761706F726501
      004200000053696E6761706F7265204C616E6420417574686F72697479205245
      53542041504920736572766963657320666F722053696E6761706F7265206164
      647265737365730200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001F00000068747470733A2F2F7777772E6F6E656D
      61702E676F762E73672F646F63732F06000900000047656F636F64696E67FEFE
      FF1B1C00C3020000FF1D0000070000004F6E576174657201002A000000446574
      65726D696E652069662061206C61742F6C6F6E206973206F6E20776174657220
      6F72206C616E6402000000000003000400000074727565040007000000756E6B
      6E6F776E05001300000068747470733A2F2F6F6E77617465722E696F2F060009
      00000047656F636F64696E67FEFEFF1B1C00C4020000FF1D00000E0000004F70
      656E20546F706F2044617461010036000000456C65766174696F6E20616E6420
      6F6365616E20646570746820666F722061206C6174697475646520616E64206C
      6F6E676974756465020000000000030004000000747275650400020000006E6F
      05001C00000068747470733A2F2F7777772E6F70656E746F706F646174612E6F
      726706000900000047656F636F64696E67FEFEFF1B1C00C5020000FF1D000008
      0000004F70656E4361676501002D000000466F727761726420616E6420726576
      657273652067656F636F64696E67207573696E67206F70656E20646174610200
      060000006170694B657903000400000074727565040003000000796573050018
      00000068747470733A2F2F6F70656E63616765646174612E636F6D0600090000
      0047656F636F64696E67FEFEFF1B1C00C6020000FF1D0000140000006F70656E
      726F757465736572766963652E6F7267010047000000446972656374696F6E73
      2C20504F49732C2069736F6368726F6E65732C2067656F636F64696E6720282B
      72657665727365292C20656C65766174696F6E2C20616E64206D6F7265020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001D00000068747470733A2F2F6F70656E726F757465736572766963652E6F
      72672F06000900000047656F636F64696E67FEFEFF1B1C00C7020000FF1D0000
      0D0000004F70656E5374726565744D617001002D0000004E617669676174696F
      6E2C2067656F6C6F636174696F6E20616E642067656F67726170686963616C20
      646174610200050000004F4175746803000500000066616C7365040007000000
      756E6B6E6F776E050026000000687474703A2F2F77696B692E6F70656E737472
      6565746D61702E6F72672F77696B692F41504906000900000047656F636F6469
      6E67FEFEFF1B1C00C8020000FF1D00000B00000050696E62616C6C204D617001
      002D000000412063726F7764736F7572636564206D6170206F66207075626C69
      632070696E62616C6C206D616368696E65730200000000000300040000007472
      756504000300000079657305002200000068747470733A2F2F70696E62616C6C
      6D61702E636F6D2F6170692F76312F646F637306000900000047656F636F6469
      6E67FEFEFF1B1C00C9020000FF1D00000D000000706F736974696F6E73746163
      6B01002A000000466F7277617264202620526576657273652042617463682047
      656F636F64696E672052455354204150490200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05001A00000068747470733A
      2F2F706F736974696F6E737461636B2E636F6D2F06000900000047656F636F64
      696E67FEFEFF1B1C00CA020000FF1D000007000000506F7374616C6901001400
      00004D657869636F205A697020436F6465732041504902000000000003000400
      00007472756504000300000079657305001700000068747470733A2F2F706F73
      74616C692E6170702F61706906000900000047656F636F64696E67FEFEFF1B1C
      00CB020000FF1D00000F000000506F7374636F6465446174612E6E6C01003E00
      000050726F766964652067656F6C6F636174696F6E2064617461206261736564
      206F6E20706F7374636F646520666F7220447574636820616464726573736573
      02000000000003000500000066616C7365040007000000756E6B6E6F776E0500
      63000000687474703A2F2F6170692E706F7374636F6465646174612E6E6C2F76
      312F706F7374636F64652F3F706F7374636F64653D3132313145502673747265
      65746E756D6265723D3630267265663D646F6D65696E6E61616D2E6E6C267479
      70653D6A736F6E06000900000047656F636F64696E67FEFEFF1B1C00CC020000
      FF1D00000C000000506F7374636F6465732E696F010028000000506F7374636F
      6465206C6F6F6B757020262047656F6C6F636174696F6E20666F722074686520
      554B020000000000030004000000747275650400030000007965730500140000
      0068747470733A2F2F706F7374636F6465732E696F06000900000047656F636F
      64696E67FEFEFF1B1C00CD020000FF1D00000E000000517565696D6164617320
      494E504501002D00000041636365737320746F206865617420666F6375732064
      617461202870726F6261626C652077696C646669726529020000000000030004
      00000074727565040007000000756E6B6E6F776E05003600000068747470733A
      2F2F717565696D616461732E6467692E696E70652E62722F717565696D616461
      732F6461646F732D61626572746F732F06000900000047656F636F64696E67FE
      FEFF1B1C00CE020000FF1D00000E0000005245535420436F756E747269657301
      003100000047657420696E666F726D6174696F6E2061626F757420636F756E74
      72696573207669612061205245535466756C2041504902000000000003000400
      00007472756504000300000079657305001900000068747470733A2F2F726573
      74636F756E74726965732E636F6D06000900000047656F636F64696E67FEFEFF
      1B1C00CF020000FF1D00000F000000526F6164476F6174204369746965730100
      1B00000043697469657320636F6E74656E7420262070686F746F732041504902
      00060000006170694B6579030004000000747275650400020000006E6F05002C
      00000068747470733A2F2F7777772E726F6164676F61742E636F6D2F62757369
      6E6573732F6369746965732D61706906000900000047656F636F64696E67FEFE
      FF1B1C00D0020000FF1D0000100000005277616E6461204C6F636174696F6E73
      0100560000005277616E64612050726F76656E6365732C204469737472696374
      732C204369746965732C204361706974616C20436974792C20536563746F722C
      2063656C6C732C2076696C6C6167657320616E64207374726565747302000000
      000003000400000074727565040007000000756E6B6E6F776E05002F00000068
      747470733A2F2F72617069646170692E636F6D2F766963746F726B6172616E67
      7761342F6170692F7277616E646106000900000047656F636F64696E67FEFEFF
      1B1C00D1020000FF1D000003000000534C460100250000004765726D616E2063
      6974792C20636F756E7472792C2072697665722C206461746162617365020000
      0000000300040000007472756504000300000079657305003F00000068747470
      733A2F2F6769746875622E636F6D2F736C66746F6F6C2F736C66746F6F6C2E67
      69746875622E696F2F626C6F622F6D61737465722F4150492E6D640600090000
      0047656F636F64696E67FEFEFF1B1C00D2020000FF1D00000900000053706F74
      53656E7365010032000000416464206C6F636174696F6E20626173656420696E
      746572616374696F6E7320746F20796F7572206D6F62696C6520617070020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001500000068747470733A2F2F73706F7473656E73652E696F2F0600090000
      0047656F636F64696E67FEFEFF1B1C00D3020000FF1D00000600000054656C69
      7A6501003600000054656C697A65206F6666657273206C6F636174696F6E2069
      6E666F726D6174696F6E2066726F6D20616E7920495020616464726573730200
      060000006170694B657903000400000074727565040003000000796573050028
      00000068747470733A2F2F72617069646170692E636F6D2F6663616D6275732F
      6170692F74656C697A652F06000900000047656F636F64696E67FEFEFF1B1C00
      D4020000FF1D000006000000546F6D546F6D0100290000004D6170732C204469
      72656374696F6E732C20506C6163657320616E64205472616666696320415049
      730200060000006170694B657903000400000074727565040003000000796573
      05001D00000068747470733A2F2F646576656C6F7065722E746F6D746F6D2E63
      6F6D2F06000900000047656F636F64696E67FEFEFF1B1C00D5020000FF1D0000
      0900000055656265726D617073010024000000446973636F76657220616E6420
      7368617265206D617073207769746820667269656E6473020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001C000000
      68747470733A2F2F75656265726D6170732E636F6D2F6170692F763206000900
      000047656F636F64696E67FEFEFF1B1C00D6020000FF1D00000A000000555320
      5A6970436F646501002B00000056616C696461746520616E6420617070656E64
      206461746120666F7220616E79205553205A6970436F64650200060000006170
      694B657903000400000074727565040003000000796573050030000000687474
      70733A2F2F7777772E736D617274792E636F6D2F646F63732F636C6F75642F75
      732D7A6970636F64652D61706906000900000047656F636F64696E67FEFEFF1B
      1C00D7020000FF1D000009000000557461682041475243010029000000557461
      68205765622041504920666F722067656F636F64696E67205574616820616464
      7265737365730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001C00000068747470733A2F2F6170692E6D61707365
      72762E757461682E676F7606000900000047656F636F64696E67FEFEFF1B1C00
      D8020000FF1D00000600000056696143657001001C0000004272617A696C2052
      45535466756C207A697020636F64657320415049020000000000030004000000
      74727565040007000000756E6B6E6F776E05001500000068747470733A2F2F76
      69616365702E636F6D2E627206000900000047656F636F64696E67FEFEFF1B1C
      00D9020000FF1D00000A0000005768617433576F72647301003C000000546872
      656520776F7264732061732072656D656D62657261626C6520616E6420756E69
      71756520636F6F7264696E6174657320776F726C647769646502000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001600
      000068747470733A2F2F7768617433776F7264732E636F6D0600090000004765
      6F636F64696E67FEFEFF1B1C00DA020000FF1D00001400000059616E6465782E
      4D6170732047656F636F64657201003D0000005573652067656F636F64696E67
      20746F2067657420616E206F626A656374277320636F6F7264696E6174657320
      66726F6D2069747320616464726573730200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05002400000068747470733A2F
      2F79616E6465782E636F6D2F6465762F6D6170732F67656F636F646572060009
      00000047656F636F64696E67FEFEFF1B1C00DB020000FF1D00000A0000005A69
      70436F646541504901002D0000005553207A697020636F64652064697374616E
      63652C2072616469757320616E64206C6F636174696F6E204150490200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1A00000068747470733A2F2F7777772E7A6970636F64656170692E636F6D0600
      0900000047656F636F64696E67FEFEFF1B1C00DC020000FF1D00000D0000005A
      6970706F706F74616D2E757301003D00000047657420696E666F726D6174696F
      6E2061626F757420706C616365207375636820617320636F756E7472792C2063
      6974792C2073746174652C2065746302000000000003000500000066616C7365
      040007000000756E6B6E6F776E050018000000687474703A2F2F7777772E7A69
      70706F706F74616D2E757306000900000047656F636F64696E67FEFEFF1B1C00
      DD020000FF1D0000090000005A69707461737469630100330000004765742074
      686520636F756E7472792C2073746174652C20616E642063697479206F662061
      6E79205553207A69702D636F6465020000000000030004000000747275650400
      07000000756E6B6E6F776E05001900000068747470733A2F2F7A697074617374
      69636170692E636F6D2F06000900000047656F636F64696E67FEFEFF1B1C00DE
      020000FF1D00001E00000042616E6B204E6567617261204D616C617973696120
      4F70656E204461746101001F0000004D616C61797369612043656E7472616C20
      42616E6B204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05002300000068747470733A2F2F6170696B696A61
      6E67706F7274616C2E626E6D2E676F762E6D792F06000A000000476F7665726E
      6D656E74FEFEFF1B1C00DF020000FF1D00000600000042434C61777301002600
      000041636365737320746F20746865206C617773206F66204272697469736820
      436F6C756D62696102000000000003000500000066616C736504000700000075
      6E6B6E6F776E05004300000068747470733A2F2F7777772E62636C6177732E67
      6F762E62632E63612F63697669782F74656D706C6174652F636F6D706C657465
      2F6170692F696E6465782E68746D6C06000A000000476F7665726E6D656E74FE
      FEFF1B1C00E0020000FF1D0000060000004272617A696C01002B000000436F6D
      6D756E6974792064726976656E2041504920666F72204272617A696C20507562
      6C69632044617461020000000000030004000000747275650400030000007965
      7305001900000068747470733A2F2F62726173696C6170692E636F6D2E62722F
      06000A000000476F7665726E6D656E74FEFEFF1B1C00E1020000FF1D00001D00
      00004272617A696C2043656E7472616C2042616E6B204F70656E204461746101
      001D0000004272617A696C2043656E7472616C2042616E6B204F70656E204461
      746102000000000003000400000074727565040007000000756E6B6E6F776E05
      002000000068747470733A2F2F6461646F7361626572746F732E6263622E676F
      762E62722F06000A000000476F7665726E6D656E74FEFEFF1B1C00E2020000FF
      1D0000110000004272617A696C2052656365697461205753010031000000436F
      6E73756C7420636F6D70616E69657320627920434E504A20666F72204272617A
      696C69616E20636F6D70616E6965730200000000000300040000007472756504
      0007000000756E6B6E6F776E05001D00000068747470733A2F2F7777772E7265
      636569746177732E636F6D2E62722F06000A000000476F7665726E6D656E74FE
      FEFF1B1C00E3020000FF1D0000270000004272617A696C69616E204368616D62
      6572206F66204465707574696573204F70656E204461746101005A0000005072
      6F7669646573206C656769736C617469766520696E666F726D6174696F6E2069
      6E204170697320584D4C20616E64204A534F4E2C2061732077656C6C20617320
      66696C657320696E20766172696F757320666F726D6174730200000000000300
      04000000747275650400020000006E6F05003300000068747470733A2F2F6461
      646F7361626572746F732E63616D6172612E6C65672E62722F73776167676572
      2F6170692E68746D6C06000A000000476F7665726E6D656E74FEFEFF1B1C00E4
      020000FF1D00000A00000043656E7375732E676F760100570000005468652055
      532043656E737573204275726561752070726F766964657320766172696F7573
      204150497320616E6420646174612073657473206F6E2064656D6F6772617068
      69637320616E6420627573696E65737365730200000000000300040000007472
      7565040007000000756E6B6E6F776E05003500000068747470733A2F2F777777
      2E63656E7375732E676F762F646174612F646576656C6F706572732F64617461
      2D736574732E68746D6C06000A000000476F7665726E6D656E74FEFEFF1B1C00
      E5020000FF1D00000C000000436974792C204265726C696E0100190000004265
      726C696E284445292043697479204F70656E2044617461020000000000030004
      00000074727565040007000000756E6B6E6F776E05001800000068747470733A
      2F2F646174656E2E6265726C696E2E64652F06000A000000476F7665726E6D65
      6E74FEFEFF1B1C00E6020000FF1D00000D000000436974792C20476461C58473
      6B01001B000000476461C584736B2028504C292043697479204F70656E204461
      746102000000000003000400000074727565040007000000756E6B6E6F776E05
      002300000068747470733A2F2F636B616E2E6D756C74696D656469616764616E
      736B2E706C2F656E06000A000000476F7665726E6D656E74FEFEFF1B1C00E702
      0000FF1D00000C000000436974792C204764796E696101001A0000004764796E
      69612028504C292043697479204F70656E204461746102000000000003000500
      000066616C7365040007000000756E6B6E6F776E05002C000000687474703A2F
      2F6F74776172746564616E652E6764796E69612E706C2F656E2F6170695F646F
      632E68746D6C06000A000000476F7665726E6D656E74FEFEFF1B1C00E8020000
      FF1D00000E000000436974792C2048656C73696E6B6901001B00000048656C73
      696E6B69284649292043697479204F70656E2044617461020000000000030004
      00000074727565040007000000756E6B6E6F776E05001500000068747470733A
      2F2F6872692E66692F656E5F67622F06000A000000476F7665726E6D656E74FE
      FEFF1B1C00E9020000FF1D00000A000000436974792C204C7669760100170000
      004C766976285541292043697479204F70656E20446174610200000000000300
      0400000074727565040007000000756E6B6E6F776E0500220000006874747073
      3A2F2F6F70656E646174612E636974792D61646D2E6C7669762E75612F06000A
      000000476F7665726E6D656E74FEFEFF1B1C00EA020000FF1D00001600000043
      6974792C204E616E746573204F70656E20446174610100190000004E616E7465
      73284652292043697479204F70656E20446174610200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E05002B000000687474
      70733A2F2F646174612E6E616E7465736D6574726F706F6C652E66722F706167
      65732F686F6D652F06000A000000476F7665726E6D656E74FEFEFF1B1C00EB02
      0000FF1D000018000000436974792C204E657720596F726B204F70656E204461
      746101001C0000004E657720596F726B20285553292043697479204F70656E20
      4461746102000000000003000400000074727565040007000000756E6B6E6F77
      6E05002200000068747470733A2F2F6F70656E646174612E636974796F666E65
      77796F726B2E75732F06000A000000476F7665726E6D656E74FEFEFF1B1C00EC
      020000FF1D000016000000436974792C20507261677565204F70656E20446174
      6101001900000050726167756528435A292043697479204F70656E2044617461
      02000000000003000500000066616C7365040007000000756E6B6E6F776E0500
      1B000000687474703A2F2F6F70656E646174612E70726168612E65752F656E06
      000A000000476F7665726E6D656E74FEFEFF1B1C00ED020000FF1D0000170000
      00436974792C20546F726F6E746F204F70656E204461746101001B000000546F
      726F6E746F20284341292043697479204F70656E204461746102000000000003
      00040000007472756504000300000079657305001800000068747470733A2F2F
      6F70656E2E746F726F6E746F2E63612F06000A000000476F7665726E6D656E74
      FEFEFF1B1C00EE020000FF1D000008000000436F64652E676F76010055000000
      546865207072696D61727920706C6174666F726D20666F72204F70656E20536F
      7572636520616E6420636F64652073686172696E6720666F722074686520552E
      532E204665646572616C20476F7665726E6D656E740200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500100000006874
      7470733A2F2F636F64652E676F7606000A000000476F7665726E6D656E74FEFE
      FF1B1C00EF020000FF1D000020000000436F6C6F7261646F20496E666F726D61
      74696F6E204D61726B6574706C616365010023000000436F6C6F7261646F2053
      7461746520476F7665726E6D656E74204F70656E204461746102000000000003
      000400000074727565040007000000756E6B6E6F776E05001A00000068747470
      733A2F2F646174612E636F6C6F7261646F2E676F762F06000A000000476F7665
      726E6D656E74FEFEFF1B1C00F0020000FF1D0000080000004461746120555341
      01000E0000005553205075626C69632044617461020000000000030004000000
      74727565040007000000756E6B6E6F776E05001D00000068747470733A2F2F64
      6174617573612E696F2F61626F75742F6170692F06000A000000476F7665726E
      6D656E74FEFEFF1B1C00F1020000FF1D000008000000446174612E676F760100
      12000000555320476F7665726E6D656E7420446174610200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05001500000068
      747470733A2F2F6170692E646174612E676F762F06000A000000476F7665726E
      6D656E74FEFEFF1B1C00F2020000FF1D000012000000446174612E7061726C69
      616D656E742E756B010062000000436F6E7461696E73206C6976652064617461
      7365747320696E636C7564696E6720696E666F726D6174696F6E2061626F7574
      207065746974696F6E732C2062696C6C732C204D5020766F7465732C20617474
      656E64616E636520616E64206D6F726502000000000003000500000066616C73
      65040007000000756E6B6E6F776E05003500000068747470733A2F2F6578706C
      6F72652E646174612E7061726C69616D656E742E756B2F3F6C6561726E6D6F72
      653D4D656D6265727306000A000000476F7665726E6D656E74FEFEFF1B1C00F3
      020000FF1D0000170000004465757473636865722042756E6465737461672044
      495001005A00000054686973204150492070726F766964657320726561642061
      636365737320746F2044495020656E7469746965732028652E672E2061637469
      7669746965732C20706572736F6E732C207072696E746564206D617465726961
      6C290200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05004800000068747470733A2F2F6469702E62756E646573746167
      2E64652F646F63756D656E74732F696E666F726D6174696F6E73626C6174745F
      7A75725F6469705F6170695F7630312E70646606000A000000476F7665726E6D
      656E74FEFEFF1B1C00F4020000FF1D00001E0000004469737472696374206F66
      20436F6C756D626961204F70656E2044617461010059000000436F6E7461696E
      7320442E432E20676F7665726E6D656E74207075626C69632064617461736574
      732C20696E636C7564696E67206372696D652C204749532C2066696E616E6369
      616C20646174612C20616E6420736F206F6E0200000000000300040000007472
      7565040007000000756E6B6E6F776E050027000000687474703A2F2F6F70656E
      646174612E64632E676F762F70616765732F7573696E672D6170697306000A00
      0000476F7665726E6D656E74FEFEFF1B1C00F5020000FF1D0000030000004550
      4101004600000057656220736572766963657320616E64206461746120736574
      732066726F6D2074686520555320456E7669726F6E6D656E74616C2050726F74
      656374696F6E204167656E637902000000000003000400000074727565040007
      000000756E6B6E6F776E05003600000068747470733A2F2F7777772E6570612E
      676F762F646576656C6F706572732F646174612D646174612D70726F64756374
      73236170697306000A000000476F7665726E6D656E74FEFEFF1B1C00F6020000
      FF1D00000A0000004642492057616E74656401002C0000004163636573732069
      6E666F726D6174696F6E206F6E20746865204642492057616E7465642070726F
      6772616D02000000000003000400000074727565040007000000756E6B6E6F77
      6E05001E00000068747470733A2F2F7777772E6662692E676F762F77616E7465
      642F61706906000A000000476F7665726E6D656E74FEFEFF1B1C00F7020000FF
      1D000003000000464543010036000000496E666F726D6174696F6E206F6E2063
      616D706169676E20646F6E6174696F6E7320696E206665646572616C20656C65
      6374696F6E730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002400000068747470733A2F2F6170692E6F70656E2E
      6665632E676F762F646576656C6F706572732F06000A000000476F7665726E6D
      656E74FEFEFF1B1C00F8020000FF1D0000100000004665646572616C20526567
      6973746572010031000000546865204461696C79204A6F75726E616C206F6620
      74686520556E697465642053746174657320476F7665726E6D656E7402000000
      000003000400000074727565040007000000756E6B6E6F776E05004800000068
      747470733A2F2F7777772E6665646572616C72656769737465722E676F762F72
      65616465722D616964732F646576656C6F7065722D7265736F75726365732F72
      6573742D61706906000A000000476F7665726E6D656E74FEFEFF1B1C00F90200
      00FF1D000015000000466F6F64205374616E6461726473204167656E63790100
      1F000000554B20666F6F642068796769656E6520726174696E67206461746120
      41504902000000000003000500000066616C7365040007000000756E6B6E6F77
      6E05002A000000687474703A2F2F726174696E67732E666F6F642E676F762E75
      6B2F6F70656E2D646174612F656E2D474206000A000000476F7665726E6D656E
      74FEFEFF1B1C00FA020000FF1D00001000000047617A6574746520446174612C
      20554B01001D000000554B206F6666696369616C207075626C6963207265636F
      7264204150490200050000004F41757468030004000000747275650400070000
      00756E6B6E6F776E05002100000068747470733A2F2F7777772E74686567617A
      657474652E636F2E756B2F6461746106000A000000476F7665726E6D656E74FE
      FEFF1B1C00FB020000FF1D00000A00000047756E20506F6C6963790100320000
      00496E7465726E6174696F6E616C206669726561726D20696E6A757279207072
      6576656E74696F6E20616E6420706F6C6963790200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001D00000068747470
      733A2F2F7777772E67756E706F6C6963792E6F72672F61706906000A00000047
      6F7665726E6D656E74FEFEFF1B1C00FC020000FF1D000004000000494E454901
      0029000000506572757669616E20537461746973746963616C20476F7665726E
      6D656E74204F70656E204461746102000000000003000500000066616C736504
      0007000000756E6B6E6F776E050024000000687474703A2F2F69696E65692E69
      6E65692E676F622E70652F6D6963726F6461746F732F06000A000000476F7665
      726E6D656E74FEFEFF1B1C00FD020000FF1D000014000000496E746572706F6C
      20526564204E6F746963657301002600000041636365737320616E6420736561
      72636820496E746572706F6C20526564204E6F74696365730200000000000300
      0400000074727565040007000000756E6B6E6F776E05001E0000006874747073
      3A2F2F696E746572706F6C2E6170692E62756E642E6465762F06000A00000047
      6F7665726E6D656E74FEFEFF1B1C00FE020000FF1D000019000000497374616E
      62756C2028C4B0424229204F70656E204461746101003D000000446174612073
      6574732066726F6D2074686520C4B07374616E62756C204D6574726F706F6C69
      74616E204D756E69636970616C6974792028C4B0424229020000000000030004
      00000074727565040007000000756E6B6E6F776E05001700000068747470733A
      2F2F646174612E6962622E676F762E747206000A000000476F7665726E6D656E
      74FEFEFF1B1C00FF020000FF1D0000190000004E6174696F6E616C205061726B
      20536572766963652C205553010026000000446174612066726F6D2074686520
      5553204E6174696F6E616C205061726B20536572766963650200060000006170
      694B657903000400000074727565040003000000796573050027000000687474
      70733A2F2F7777772E6E70732E676F762F7375626A656374732F646576656C6F
      7065722F06000A000000476F7665726E6D656E74FEFEFF1B1C0000030000FF1D
      0000140000004F70656E20476F7665726E6D656E742C20414354010026000000
      4175737472616C69616E204361706974616C205465727269746F7279204F7065
      6E204461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05001C00000068747470733A2F2F7777772E646174612E6163742E676F
      762E61752F06000A000000476F7665726E6D656E74FEFEFF1B1C0001030000FF
      1D00001A0000004F70656E20476F7665726E6D656E742C20417267656E74696E
      6101001E000000417267656E74696E6120476F7665726E6D656E74204F70656E
      204461746102000000000003000400000074727565040007000000756E6B6E6F
      776E05001500000068747470733A2F2F6461746F732E676F622E61722F06000A
      000000476F7665726E6D656E74FEFEFF1B1C0002030000FF1D00001A0000004F
      70656E20476F7665726E6D656E742C204175737472616C696101001F00000041
      75737472616C69616E20476F7665726E6D656E74204F70656E20446174610200
      0000000003000400000074727565040007000000756E6B6E6F776E0500180000
      0068747470733A2F2F7777772E646174612E676F762E61752F06000A00000047
      6F7665726E6D656E74FEFEFF1B1C0003030000FF1D0000180000004F70656E20
      476F7665726E6D656E742C204175737472696101001C00000041757374726961
      20476F7665726E6D656E74204F70656E20446174610200000000000300040000
      0074727565040007000000756E6B6E6F776E05001700000068747470733A2F2F
      7777772E646174612E67762E61742F06000A000000476F7665726E6D656E74FE
      FEFF1B1C0004030000FF1D0000180000004F70656E20476F7665726E6D656E74
      2C2042656C6769756D01001C00000042656C6769756D20476F7665726E6D656E
      74204F70656E2044617461020000000000030004000000747275650400070000
      00756E6B6E6F776E05001400000068747470733A2F2F646174612E676F762E62
      652F06000A000000476F7665726E6D656E74FEFEFF1B1C0005030000FF1D0000
      170000004F70656E20476F7665726E6D656E742C2043616E61646101001D0000
      0043616E616469616E20476F7665726E6D656E74204F70656E20446174610200
      0000000003000500000066616C7365040007000000756E6B6E6F776E05001800
      0000687474703A2F2F6F70656E2E63616E6164612E63612F656E06000A000000
      476F7665726E6D656E74FEFEFF1B1C0006030000FF1D0000190000004F70656E
      20476F7665726E6D656E742C20436F6C6F6D62696101001D000000436F6C6F6D
      62696120476F7665726E6D656E74204F70656E20446174610200000000000300
      0500000066616C7365040007000000756E6B6E6F776E05001800000068747470
      733A2F2F7777772E64616E652E676F762E636F2F06000A000000476F7665726E
      6D656E74FEFEFF1B1C0007030000FF1D0000170000004F70656E20476F766572
      6E6D656E742C2043797072757301001B00000043797072757320476F7665726E
      6D656E74204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05002000000068747470733A2F2F646174612E676F
      762E63792F3F6C616E67756167653D656E06000A000000476F7665726E6D656E
      74FEFEFF1B1C0008030000FF1D00001F0000004F70656E20476F7665726E6D65
      6E742C20437A6563682052657075626C6963010023000000437A656368205265
      7075626C696320476F7665726E6D656E74204F70656E20446174610200000000
      0003000400000074727565040007000000756E6B6E6F776E05001C0000006874
      7470733A2F2F646174612E676F762E637A2F656E676C6973682F06000A000000
      476F7665726E6D656E74FEFEFF1B1C0009030000FF1D0000180000004F70656E
      20476F7665726E6D656E742C2044656E6D61726B01001C00000044656E6D6172
      6B20476F7665726E6D656E74204F70656E204461746102000000000003000400
      000074727565040007000000756E6B6E6F776E05001800000068747470733A2F
      2F7777772E6F70656E646174612E646B2F06000A000000476F7665726E6D656E
      74FEFEFF1B1C000A030000FF1D0000180000004F70656E20476F7665726E6D65
      6E742C204573746F6E696101001C0000004573746F6E696120476F7665726E6D
      656E74204F70656E20446174610200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05003C00000068747470733A2F2F6176
      61616E646D65642E65657374692E65652F696E737472756374696F6E732F6F70
      656E646174612D646174617365742D61706906000A000000476F7665726E6D65
      6E74FEFEFF1B1C000B030000FF1D0000180000004F70656E20476F7665726E6D
      656E742C2046696E6C616E6401001C00000046696E6C616E6420476F7665726E
      6D656E74204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05001B00000068747470733A2F2F7777772E61766F
      696E646174612E66692F656E06000A000000476F7665726E6D656E74FEFEFF1B
      1C000C030000FF1D0000170000004F70656E20476F7665726E6D656E742C2046
      72616E636501001B0000004672656E636820476F7665726E6D656E74204F7065
      6E20446174610200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001900000068747470733A2F2F7777772E646174612E
      676F75762E66722F06000A000000476F7665726E6D656E74FEFEFF1B1C000D03
      0000FF1D0000180000004F70656E20476F7665726E6D656E742C204765726D61
      6E7901001C0000004765726D616E7920476F7665726E6D656E74204F70656E20
      4461746102000000000003000400000074727565040007000000756E6B6E6F77
      6E05003F00000068747470733A2F2F7777772E676F76646174612E64652F6461
      74656E2F2D2F64657461696C732F676F76646174612D6D657461646174656E6B
      6174616C6F6706000A000000476F7665726E6D656E74FEFEFF1B1C000E030000
      FF1D0000170000004F70656E20476F7665726E6D656E742C2047726565636501
      001B00000047726565636520476F7665726E6D656E74204F70656E2044617461
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05001400000068747470733A2F2F646174612E676F762E67722F06000A00
      0000476F7665726E6D656E74FEFEFF1B1C000F030000FF1D0000160000004F70
      656E20476F7665726E6D656E742C20496E64696101001B000000496E6469616E
      20476F7665726E6D656E74204F70656E20446174610200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500140000006874
      7470733A2F2F646174612E676F762E696E2F06000A000000476F7665726E6D65
      6E74FEFEFF1B1C0010030000FF1D0000180000004F70656E20476F7665726E6D
      656E742C204972656C616E6401001C0000004972656C616E6420476F7665726E
      6D656E74204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05002400000068747470733A2F2F646174612E676F
      762E69652F70616765732F646576656C6F7065727306000A000000476F766572
      6E6D656E74FEFEFF1B1C0011030000FF1D0000160000004F70656E20476F7665
      726E6D656E742C204974616C7901001A0000004974616C7920476F7665726E6D
      656E74204F70656E204461746102000000000003000400000074727565040007
      000000756E6B6E6F776E05001800000068747470733A2F2F7777772E64617469
      2E676F762E69742F06000A000000476F7665726E6D656E74FEFEFF1B1C001203
      0000FF1D0000160000004F70656E20476F7665726E6D656E742C204B6F726561
      01001A0000004B6F72656120476F7665726E6D656E74204F70656E2044617461
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001700000068747470733A2F2F7777772E646174612E676F2E6B722F
      06000A000000476F7665726E6D656E74FEFEFF1B1C0013030000FF1D00001A00
      00004F70656E20476F7665726E6D656E742C204C69746875616E696101001E00
      00004C69746875616E696120476F7665726E6D656E74204F70656E2044617461
      02000000000003000400000074727565040007000000756E6B6E6F776E050020
      00000068747470733A2F2F646174612E676F762E6C742F7075626C69632F6170
      692F3106000A000000476F7665726E6D656E74FEFEFF1B1C0014030000FF1D00
      001B0000004F70656E20476F7665726E6D656E742C204C7578656D626F757267
      0100220000004C7578656D626F75726769736820476F7665726E6D656E74204F
      70656E20446174610200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001600000068747470733A2F2F646174612E7075
      626C69632E6C7506000A000000476F7665726E6D656E74FEFEFF1B1C00150300
      00FF1D0000170000004F70656E20476F7665726E6D656E742C204D657869636F
      0100280000004D65786963616E20537461746973746963616C20476F7665726E
      6D656E74204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05001F00000068747470733A2F2F7777772E696E65
      67692E6F72672E6D782F6461746F732F06000A000000476F7665726E6D656E74
      FEFEFF1B1C0016030000FF1D0000170000004F70656E20476F7665726E6D656E
      742C204D657869636F01001B0000004D657869636F20476F7665726E6D656E74
      204F70656E204461746102000000000003000400000074727565040007000000
      756E6B6E6F776E05001500000068747470733A2F2F6461746F732E676F622E6D
      782F06000A000000476F7665726E6D656E74FEFEFF1B1C0017030000FF1D0000
      1C0000004F70656E20476F7665726E6D656E742C204E65746865726C616E6473
      0100200000004E65746865726C616E647320476F7665726E6D656E74204F7065
      6E204461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05003D00000068747470733A2F2F646174612E6F766572686569642E6E
      6C2F656E2F6F6E646572737465756E696E672F646174612D7075626C69636572
      656E2F61706906000A000000476F7665726E6D656E74FEFEFF1B1C0018030000
      FF1D0000200000004F70656E20476F7665726E6D656E742C204E657720536F75
      74682057616C65730100240000004E657720536F7574682057616C657320476F
      7665726E6D656E74204F70656E20446174610200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E0500170000006874747073
      3A2F2F6170692E6E73772E676F762E61752F06000A000000476F7665726E6D65
      6E74FEFEFF1B1C0019030000FF1D00001C0000004F70656E20476F7665726E6D
      656E742C204E6577205A65616C616E640100200000004E6577205A65616C616E
      6420476F7665726E6D656E74204F70656E204461746102000000000003000400
      000074727565040007000000756E6B6E6F776E05001900000068747470733A2F
      2F7777772E646174612E676F76742E6E7A2F06000A000000476F7665726E6D65
      6E74FEFEFF1B1C001A030000FF1D0000170000004F70656E20476F7665726E6D
      656E742C204E6F7277617901001E0000004E6F7277656769616E20476F766572
      6E6D656E74204F70656E20446174610200000000000300040000007472756504
      000300000079657305002200000068747470733A2F2F646174612E6E6F726765
      2E6E6F2F64617461736572766963657306000A000000476F7665726E6D656E74
      FEFEFF1B1C001B030000FF1D0000150000004F70656E20476F7665726E6D656E
      742C20506572750100190000005065727520476F7665726E6D656E74204F7065
      6E204461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05002100000068747470733A2F2F7777772E6461746F73616269657274
      6F732E676F622E70652F06000A000000476F7665726E6D656E74FEFEFF1B1C00
      1C030000FF1D0000170000004F70656E20476F7665726E6D656E742C20506F6C
      616E6401001B000000506F6C616E6420476F7665726E6D656E74204F70656E20
      4461746102000000000003000400000074727565040003000000796573050016
      00000068747470733A2F2F64616E652E676F762E706C2F656E06000A00000047
      6F7665726E6D656E74FEFEFF1B1C001D030000FF1D0000190000004F70656E20
      476F7665726E6D656E742C20506F72747567616C01001D000000506F72747567
      616C20476F7665726E6D656E74204F70656E2044617461020000000000030004
      0000007472756504000300000079657305001F00000068747470733A2F2F6461
      646F732E676F762E70742F656E2F646F636170692F06000A000000476F766572
      6E6D656E74FEFEFF1B1C001E030000FF1D0000260000004F70656E20476F7665
      726E6D656E742C20517565656E736C616E6420476F7665726E6D656E7401001F
      000000517565656E736C616E6420476F7665726E6D656E74204F70656E204461
      746102000000000003000400000074727565040007000000756E6B6E6F776E05
      001C00000068747470733A2F2F7777772E646174612E716C642E676F762E6175
      2F06000A000000476F7665726E6D656E74FEFEFF1B1C001F030000FF1D000018
      0000004F70656E20476F7665726E6D656E742C20526F6D616E696101001C0000
      00526F6D616E696120476F7665726E6D656E74204F70656E2044617461020000
      00000003000500000066616C7365040007000000756E6B6E6F776E0500130000
      00687474703A2F2F646174612E676F762E726F2F06000A000000476F7665726E
      6D656E74FEFEFF1B1C0020030000FF1D00001D0000004F70656E20476F766572
      6E6D656E742C2053617564692041726162696101002100000053617564692041
      726162696120476F7665726E6D656E74204F70656E2044617461020000000000
      03000400000074727565040007000000756E6B6E6F776E050013000000687474
      70733A2F2F646174612E676F762E736106000A000000476F7665726E6D656E74
      FEFEFF1B1C0021030000FF1D00001A0000004F70656E20476F7665726E6D656E
      742C2053696E6761706F726501001E00000053696E6761706F726520476F7665
      726E6D656E74204F70656E204461746102000000000003000400000074727565
      040007000000756E6B6E6F776E05001D00000068747470733A2F2F646174612E
      676F762E73672F646576656C6F70657206000A000000476F7665726E6D656E74
      FEFEFF1B1C0022030000FF1D0000190000004F70656E20476F7665726E6D656E
      742C20536C6F76616B696101001D000000536C6F76616B696120476F7665726E
      6D656E74204F70656E2044617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05001700000068747470733A2F2F646174612E676F
      762E736B2F656E2F06000A000000476F7665726E6D656E74FEFEFF1B1C002303
      0000FF1D0000190000004F70656E20476F7665726E6D656E742C20536C6F7665
      6E696101001D000000536C6F76656E696120476F7665726E6D656E74204F7065
      6E2044617461020000000000030004000000747275650400020000006E6F0500
      1700000068747470733A2F2F706F6461746B692E676F762E73692F06000A0000
      00476F7665726E6D656E74FEFEFF1B1C0024030000FF1D00002C0000004F7065
      6E20476F7665726E6D656E742C20536F757468204175737472616C69616E2047
      6F7665726E6D656E74010025000000536F757468204175737472616C69616E20
      476F7665726E6D656E74204F70656E2044617461020000000000030004000000
      74727565040007000000756E6B6E6F776E05001700000068747470733A2F2F64
      6174612E73612E676F762E61752F06000A000000476F7665726E6D656E74FEFE
      FF1B1C0025030000FF1D0000160000004F70656E20476F7665726E6D656E742C
      20537061696E01001A000000537061696E20476F7665726E6D656E74204F7065
      6E204461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05001700000068747470733A2F2F6461746F732E676F622E65732F656E
      06000A000000476F7665726E6D656E74FEFEFF1B1C0026030000FF1D00001700
      00004F70656E20476F7665726E6D656E742C2053776564656E01001B00000053
      776564656E20476F7665726E6D656E74204F70656E2044617461020000000000
      03000400000074727565040007000000756E6B6E6F776E050052000000687474
      70733A2F2F7777772E64617461706F7274616C2E73652F656E2F646174617365
      72766963652F39315F32393738392F6170692D666F722D7468652D7374617469
      73746963616C2D646174616261736506000A000000476F7665726E6D656E74FE
      FEFF1B1C0027030000FF1D00001C0000004F70656E20476F7665726E6D656E74
      2C20537769747A65726C616E64010020000000537769747A65726C616E642047
      6F7665726E6D656E74204F70656E204461746102000000000003000400000074
      727565040007000000756E6B6E6F776E05004100000068747470733A2F2F6861
      6E64626F6F6B2E6F70656E646174612E73776973732F64652F636F6E74656E74
      2F6E75747A656E2F6170692D6E75747A656E2E68746D6C06000A000000476F76
      65726E6D656E74FEFEFF1B1C0028030000FF1D0000170000004F70656E20476F
      7665726E6D656E742C2054616977616E01001B00000054616977616E20476F76
      65726E6D656E74204F70656E2044617461020000000000030004000000747275
      65040007000000756E6B6E6F776E05001400000068747470733A2F2F64617461
      2E676F762E74772F06000A000000476F7665726E6D656E74FEFEFF1B1C002903
      0000FF1D0000190000004F70656E20476F7665726E6D656E742C20546861696C
      616E6401001D000000546861696C616E6420476F7665726E6D656E74204F7065
      6E20446174610200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001300000068747470733A2F2F646174612E676F2E74
      682F06000A000000476F7665726E6D656E74FEFEFF1B1C002A030000FF1D0000
      130000004F70656E20476F7665726E6D656E742C20554B010017000000554B20
      476F7665726E6D656E74204F70656E2044617461020000000000030004000000
      74727565040007000000756E6B6E6F776E05001400000068747470733A2F2F64
      6174612E676F762E756B2F06000A000000476F7665726E6D656E74FEFEFF1B1C
      002B030000FF1D0000140000004F70656E20476F7665726E6D656E742C205553
      41010022000000556E697465642053746174657320476F7665726E6D656E7420
      4F70656E20446174610200000000000300040000007472756504000700000075
      6E6B6E6F776E05001500000068747470733A2F2F7777772E646174612E676F76
      2F06000A000000476F7665726E6D656E74FEFEFF1B1C002C030000FF1D00002A
      0000004F70656E20476F7665726E6D656E742C20566963746F72696120537461
      746520476F7665726E6D656E74010023000000566963746F7269612053746174
      6520476F7665726E6D656E74204F70656E204461746102000000000003000400
      000074727565040007000000756E6B6E6F776E05001C00000068747470733A2F
      2F7777772E646174612E7669632E676F762E61752F06000A000000476F766572
      6E6D656E74FEFEFF1B1C002D030000FF1D00001F0000004F70656E20476F7665
      726E6D656E742C2057657374204175737472616C696101001800000057657374
      204175737472616C6961204F70656E2044617461020000000000030004000000
      74727565040007000000756E6B6E6F776E05001700000068747470733A2F2F64
      6174612E77612E676F762E61752F06000A000000476F7665726E6D656E74FEFE
      FF1B1C002E030000FF1D000011000000505243204578616D205363686564756C
      6501004F000000556E6F6666696369616C205068696C697070696E652050726F
      66657373696F6E616C20526567756C6174696F6E20436F6D6D697373696F6E27
      73206578616D696E6174696F6E207363686564756C6502000000000003000400
      00007472756504000300000079657305002C00000068747470733A2F2F617069
      2E7768656E69737468656E657874626F6172646578616D2E636F6D2F646F6373
      2F06000A000000476F7665726E6D656E74FEFEFF1B1C002F030000FF1D000017
      000000526570726573656E74206279204F70656E204E6F727468010028000000
      46696E642043616E616469616E20476F7665726E6D656E742052657072657365
      6E7461746976657302000000000003000400000074727565040007000000756E
      6B6E6F776E05001F00000068747470733A2F2F726570726573656E742E6F7065
      6E6E6F7274682E63612F06000A000000476F7665726E6D656E74FEFEFF1B1C00
      30030000FF1D000012000000554B20436F6D70616E69657320486F7573650100
      2E000000554B20436F6D70616E69657320486F75736520446174612066726F6D
      2074686520554B20676F7665726E6D656E740200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05003500000068747470733A
      2F2F646576656C6F7065722E636F6D70616E792D696E666F726D6174696F6E2E
      736572766963652E676F762E756B2F06000A000000476F7665726E6D656E74FE
      FEFF1B1C0031030000FF1D000029000000555320507265736964656E7469616C
      20456C656374696F6E204461746120627920546F676154656368010063000000
      42617369632063616E646964617465206461746120616E64206C69766520656C
      6563746F72616C20766F746520636F756E747320666F7220746F702074776F20
      7061727469657320696E20555320707265736964656E7469616C20656C656374
      696F6E020000000000030004000000747275650400020000006E6F0500240000
      0068747470733A2F2F7573656C656374696F6E2E746F6761746563682E6F7267
      2F6170692F06000A000000476F7665726E6D656E74FEFEFF1B1C0032030000FF
      1D0000070000005553412E676F76010045000000417574686F72697461746976
      6520696E666F726D6174696F6E206F6E20552E532E2070726F6772616D732C20
      6576656E74732C20736572766963657320616E64206D6F726502000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001D00
      000068747470733A2F2F7777772E7573612E676F762F646576656C6F70657206
      000A000000476F7665726E6D656E74FEFEFF1B1C0033030000FF1D00000F0000
      005553417370656E64696E672E676F760100180000005553206665646572616C
      207370656E64696E672064617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05001C00000068747470733A2F2F6170692E757361
      7370656E64696E672E676F762F06000A000000476F7665726E6D656E74FEFEFF
      1B1C0034030000FF1D000007000000434D532E676F7601002E00000041636365
      737320746F2074686520646174612066726F6D2074686520434D53202D206D65
      6469636172652E676F760200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05002300000068747470733A2F2F646174612E
      636D732E676F762F70726F76696465722D646174612F0600060000004865616C
      7468FEFEFF1B1C0035030000FF1D00000B000000436F726F6E61766972757301
      0021000000485454502041504920666F72204C617465737420436F7669642D31
      39204461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05006200000068747470733A2F2F70697065647265616D2E636F6D2F40
      70726176696E2F687474702D6170692D666F722D6C61746573742D777568616E
      2D636F726F6E6176697275732D646174612D323031392D6E636F762D705F4736
      434C564D2F726561646D650600060000004865616C7468FEFEFF1B1C00360300
      00FF1D000015000000436F726F6E61766972757320696E2074686520554B0100
      44000000554B20476F7665726E6D656E7420636F726F6E617669727573206461
      74612C20696E636C7564696E672064656174687320616E642063617365732062
      7920726567696F6E02000000000003000400000074727565040007000000756E
      6B6E6F776E05003800000068747470733A2F2F636F726F6E6176697275732E64
      6174612E676F762E756B2F64657461696C732F646576656C6F706572732D6775
      6964650600060000004865616C7468FEFEFF1B1C0037030000FF1D0000160000
      00436F76696420547261636B696E672050726F6A656374010019000000436F76
      69642D313920206461746120666F722074686520555302000000000003000400
      0000747275650400020000006E6F05002C00000068747470733A2F2F636F7669
      64747261636B696E672E636F6D2F646174612F6170692F76657273696F6E2D32
      0600060000004865616C7468FEFEFF1B1C0038030000FF1D000008000000436F
      7669642D3139010027000000436F766964203139207370726561642C20696E66
      656374696F6E20616E64207265636F7665727902000000000003000400000074
      72756504000300000079657305001700000068747470733A2F2F636F76696431
      396170692E636F6D2F0600060000004865616C7468FEFEFF1B1C0039030000FF
      1D000008000000436F7669642D313901002F000000436F766964203139206361
      7365732C2064656174687320616E64207265636F766572792070657220636F75
      6E7472790200000000000300040000007472756504000300000079657305002D
      00000068747470733A2F2F6769746875622E636F6D2F4D2D4D656469612D4772
      6F75702F436F7669642D31392D4150490600060000004865616C7468FEFEFF1B
      1C003A030000FF1D000011000000436F7669642D313920446174656E68756201
      00400000004D6170732C2064617461736574732C206170706C69636174696F6E
      7320616E64206D6F726520696E2074686520636F6E74657874206F6620434F56
      49442D313902000000000003000400000074727565040007000000756E6B6E6F
      776E05002C00000068747470733A2F2F6E7067656F2D636F726F6E612D6E7067
      656F2D64652E6875622E6172636769732E636F6D0600060000004865616C7468
      FEFEFF1B1C003B030000FF1D00001C000000436F7669642D313920476F766572
      6E6D656E7420526573706F6E7365010042000000476F7665726E6D656E74206D
      6561737572657320747261636B657220746F20666967687420616761696E7374
      2074686520436F7669642D31392070616E64656D696302000000000003000400
      00007472756504000300000079657305002100000068747470733A2F2F636F76
      6964747261636B65722E6273672E6F782E61632E756B0600060000004865616C
      7468FEFEFF1B1C003C030000FF1D00000E000000436F7669642D313920496E64
      696101005C000000436F76696420313920737461746973746963732073746174
      6520616E6420646973747269637420776973652061626F75742063617365732C
      2076616363696E6174696F6E732C207265636F766572792077697468696E2049
      6E64696102000000000003000400000074727565040007000000756E6B6E6F77
      6E05001E00000068747470733A2F2F646174612E636F7669643139696E646961
      2E6F72672F0600060000004865616C7468FEFEFF1B1C003D030000FF1D000011
      000000436F7669642D3139204A4855204353534501003D0000004F70656E2D73
      6F757263652041504920666F72206578706C6F72696E6720436F766964313920
      6361736573206261736564206F6E204A48552043535345020000000000030004
      0000007472756504000300000079657305002200000068747470733A2F2F6E75
      747461706861742E636F6D2F636F76696431392D6170692F0600060000004865
      616C7468FEFEFF1B1C003E030000FF1D000012000000436F7669642D3139204C
      697665204461746101005C000000476C6F62616C20616E6420636F756E747279
      776973652064617461206F6620436F766964203139206461696C792053756D6D
      6172792C20636F6E6669726D65642063617365732C207265636F766572656420
      616E642064656174687302000000000003000400000074727565040003000000
      79657305002900000068747470733A2F2F6769746875622E636F6D2F6D617468
      64726F69642F636F7669642D31392D6170690600060000004865616C7468FEFE
      FF1B1C003F030000FF1D000014000000436F7669642D3139205068696C697070
      696E6573010046000000556E6F6666696369616C20436F7669642D3139205765
      622041504920666F72205068696C697070696E65732066726F6D206461746120
      636F6C6C656374656420627920444F4802000000000003000400000074727565
      04000300000079657305003800000068747470733A2F2F6769746875622E636F
      6D2F53696D70657266792F436F7669642D31392D4150492D5068696C69707069
      6E65732D444F480600060000004865616C7468FEFEFF1B1C0040030000FF1D00
      0017000000434F5649442D313920547261636B65722043616E61646101002700
      000044657461696C73206F6E20436F7669642D3139206361736573206163726F
      73732043616E6164610200000000000300040000007472756504000700000075
      6E6B6E6F776E05002F00000068747470733A2F2F6170692E636F766964313974
      7261636B65722E63612F646F63732F312E302F6F766572766965770600060000
      004865616C7468FEFEFF1B1C0041030000FF1D00001A000000434F5649442D31
      3920547261636B657220537269204C616E6B6101004100000050726F76696465
      7320736974756174696F6E206F662074686520434F5649442D31392070617469
      656E7473207265706F7274656420696E20537269204C616E6B61020000000000
      03000400000074727565040007000000756E6B6E6F776E050032000000687474
      70733A2F2F7777772E6870622E6865616C74682E676F762E6C6B2F656E2F6170
      692D646F63756D656E746174696F6E0600060000004865616C7468FEFEFF1B1C
      0042030000FF1D000008000000434F5649442D494401002D000000496E646F6E
      657369616E20676F7665726E6D656E7420436F76696420646174612070657220
      70726F76696E6365020000000000030004000000747275650400030000007965
      7305002F00000068747470733A2F2F646174612E636F76696431392E676F2E69
      642F7075626C69632F6170692F70726F762E6A736F6E0600060000004865616C
      7468FEFEFF1B1C0043030000FF1D00001500000044617461666C6F77204B6974
      20434F5649442D313901002C000000434F5649442D3139206C69766520737461
      7469737469637320696E746F2073697465732070657220686F75720200000000
      0003000400000074727565040007000000756E6B6E6F776E0500200000006874
      7470733A2F2F636F7669642D31392E64617461666C6F776B69742E636F6D0600
      060000004865616C7468FEFEFF1B1C0044030000FF1D000010000000466F6F64
      446174612043656E7472616C0100310000004E6174696F6E616C204E75747269
      656E7420446174616261736520666F72205374616E6461726420526566657265
      6E63650200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05001900000068747470733A2F2F6664632E6E616C2E75736461
      2E676F762F0600060000004865616C7468FEFEFF1B1C0045030000FF1D00000E
      0000004865616C7468636172652E676F7601003D000000456475636174696F6E
      616C20636F6E74656E742061626F757420746865205553204865616C74682049
      6E737572616E6365204D61726B6574706C616365020000000000030004000000
      74727565040007000000756E6B6E6F776E05002600000068747470733A2F2F77
      77772E6865616C7468636172652E676F762F646576656C6F706572732F060006
      0000004865616C7468FEFEFF1B1C0046030000FF1D00001A00000048756D616E
      6974617269616E20446174612045786368616E676501006200000048756D616E
      6974617269616E20446174612045786368616E6765202848445829206973206F
      70656E20706C6174666F726D20666F722073686172696E672064617461206163
      726F73732063726973657320616E64206F7267616E69736174696F6E73020000
      00000003000400000074727565040007000000756E6B6E6F776E050019000000
      68747470733A2F2F646174612E68756D646174612E6F72672F06000600000048
      65616C7468FEFEFF1B1C0047030000FF1D00000B000000496E6665726D656469
      636101004F0000004E4C502062617365642073796D70746F6D20636865636B65
      7220616E642070617469656E74207472696167652041504920666F7220686561
      6C746820646961676E6F7369732066726F6D2074657874020006000000617069
      4B65790300040000007472756504000300000079657305002700000068747470
      733A2F2F646576656C6F7065722E696E6665726D65646963612E636F6D2F646F
      63732F0600060000004865616C7468FEFEFF1B1C0048030000FF1D0000050000
      004C41504953010030000000534152532D436F562D322067656E6F6D69632073
      657175656E6365732066726F6D207075626C696320736F757263657302000000
      0000030004000000747275650400030000007965730500230000006874747073
      3A2F2F636F762D737065637472756D2E6574687A2E63682F7075626C69630600
      060000004865616C7468FEFEFF1B1C0049030000FF1D0000080000004C657869
      6772616D01005C0000004E4C502074686174206578747261637473206D656E74
      696F6E73206F6620636C696E6963616C20636F6E63657074732066726F6D2074
      6578742C2067697665732061636365737320746F20636C696E6963616C206F6E
      746F6C6F67790200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001900000068747470733A2F2F646F63732E6C657869
      6772616D2E696F2F0600060000004865616C7468FEFEFF1B1C004A030000FF1D
      0000060000004D616B6575700100120000004D616B65757020496E666F726D61
      74696F6E02000000000003000500000066616C7365040007000000756E6B6E6F
      776E050020000000687474703A2F2F6D616B6575702D6170692E6865726F6B75
      6170702E636F6D2F0600060000004865616C7468FEFEFF1B1C004B030000FF1D
      00000D0000004D7956616363696E6174696F6E01001D00000056616363696E61
      74696F6E206461746120666F72204D616C617973696102000000000003000400
      000074727565040007000000756E6B6E6F776E05003800000068747470733A2F
      2F646F63756D656E7465722E676574706F73746D616E2E636F6D2F766965772F
      31363630353334332F547A6D38474737750600060000004865616C7468FEFEFF
      1B1C004C030000FF1D0000050000004E5050455301005A0000004E6174696F6E
      616C20506C616E20262050726F766964657220456E756D65726174696F6E2053
      797374656D2C20696E666F206F6E206865616C7468636172652070726F766964
      657273207265676973746572656420696E205553020000000000030004000000
      74727565040007000000756E6B6E6F776E05003100000068747470733A2F2F6E
      706972656769737472792E636D732E6868732E676F762F72656769737472792F
      68656C702D6170690600060000004865616C7468FEFEFF1B1C004D030000FF1D
      00000B0000004E7574726974696F6E697801002A000000576F726C6473206C61
      7267657374207665726966696564206E7574726974696F6E2064617461626173
      650200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05002200000068747470733A2F2F646576656C6F7065722E6E757472
      6974696F6E69782E636F6D2F0600060000004865616C7468FEFEFF1B1C004E03
      0000FF1D0000160000004F70656E2044617461204E48532053636F746C616E64
      01003F0000004D65646963616C207265666572656E6365206461746120616E64
      2073746174697374696373206279205075626C6963204865616C74682053636F
      746C616E6402000000000003000400000074727565040007000000756E6B6E6F
      776E05001D00000068747470733A2F2F7777772E6F70656E646174612E6E6873
      2E73636F740600060000004865616C7468FEFEFF1B1C004F030000FF1D00000C
      0000004F70656E204469736561736501004100000041504920666F7220437572
      72656E7420636173657320616E64206D6F72652073747566662061626F757420
      434F5649442D313920616E6420496E666C75656E7A6102000000000003000400
      00007472756504000300000079657305001300000068747470733A2F2F646973
      656173652E73682F0600060000004865616C7468FEFEFF1B1C0050030000FF1D
      0000070000006F70656E46444101002E0000005075626C696320464441206461
      74612061626F75742064727567732C206465766963657320616E6420666F6F64
      730200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05001400000068747470733A2F2F6F70656E2E6664612E676F760600
      060000004865616C7468FEFEFF1B1C0051030000FF1D00000C0000004F72696F
      6E204865616C74680100600000004D65646963616C20706C6174666F726D2077
      6869636820616C6C6F77732074686520646576656C6F706D656E74206F662061
      70706C69636174696F6E7320666F7220646966666572656E74206865616C7468
      63617265207363656E6172696F730200050000004F4175746803000400000074
      727565040007000000756E6B6E6F776E05002100000068747470733A2F2F6465
      76656C6F7065722E6F72696F6E6865616C74682E696F2F060006000000486561
      6C7468FEFEFF1B1C0052030000FF1D00000A00000051756172616E74696E6501
      002F000000436F726F6E61766972757320415049207769746820667265652043
      4F5649442D3139206C6976652075706461746573020000000000030004000000
      7472756504000300000079657305002B00000068747470733A2F2F7175617261
      6E74696E652E636F756E7472792F636F726F6E6176697275732F6170692F0600
      060000004865616C7468FEFEFF1B1C0053030000FF1D00000600000041647A75
      6E610100140000004A6F6220626F6172642061676772656761746F7202000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      002500000068747470733A2F2F646576656C6F7065722E61647A756E612E636F
      6D2F6F766572766965770600040000004A6F6273FEFEFF1B1C0054030000FF1D
      0000090000004172626569746E6F7701002F00000041504920666F72204A6F62
      20626F6172642061676772656761746F7220696E204575726F7065202F205265
      6D6F746502000000000003000400000074727565040003000000796573050038
      00000068747470733A2F2F646F63756D656E7465722E676574706F73746D616E
      2E636F6D2F766965772F31383534353237382F55564A624A644B680600040000
      004A6F6273FEFEFF1B1C0055030000FF1D00000A00000041726265697473616D
      7401004000000041504920666F7220746865202241726265697473616D74222C
      2077686963682069732061206765726D616E204A6F6220626F61726420616767
      72656761746F720200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05001E00000068747470733A2F2F6A6F6273756368652E
      6170692E62756E642E6465762F0600040000004A6F6273FEFEFF1B1C00560300
      00FF1D0000090000004361726565726A65740100110000004A6F622073656172
      636820656E67696E650200060000006170694B657903000500000066616C7365
      040007000000756E6B6E6F776E05002700000068747470733A2F2F7777772E63
      61726565726A65742E636F6D2F706172746E6572732F6170692F060004000000
      4A6F6273FEFEFF1B1C0057030000FF1D00000C00000044657649546A6F627320
      554B0100110000004A6F62732077697468204772617068514C02000000000003
      00040000007472756504000300000079657305002100000068747470733A2F2F
      64657669746A6F62732E756B2F6A6F625F666565642E786D6C0600040000004A
      6F6273FEFEFF1B1C0058030000FF1D00000800000046696E64776F726B010009
      0000004A6F6220626F6172640200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05002000000068747470733A2F2F66696E
      64776F726B2E6465762F646576656C6F706572732F0600040000004A6F6273FE
      FEFF1B1C0059030000FF1D00000C0000004772617068514C204A6F6273010011
      0000004A6F62732077697468204772617068514C020000000000030004000000
      7472756504000300000079657305001E00000068747470733A2F2F6772617068
      716C2E6A6F62732F646F63732F6170692F0600040000004A6F6273FEFEFF1B1C
      005A030000FF1D00000C0000004A6F6273324361726565727301000E0000004A
      6F622061676772656761746F720200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E050028000000687474703A2F2F617069
      2E6A6F627332636172656572732E636F6D2F6170692F737065632E7064660600
      040000004A6F6273FEFEFF1B1C005B030000FF1D0000060000004A6F6F626C65
      0100110000004A6F622073656172636820656E67696E65020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001C000000
      68747470733A2F2F6A6F6F626C652E6F72672F6170692F61626F757406000400
      00004A6F6273FEFEFF1B1C005C030000FF1D0000040000004A756A7501001100
      00004A6F622073656172636820656E67696E650200060000006170694B657903
      000500000066616C7365040007000000756E6B6E6F776E050023000000687474
      703A2F2F7777772E6A756A752E636F6D2F7075626C69736865722F737065632F
      0600040000004A6F6273FEFEFF1B1C005D030000FF1D00000B0000004F70656E
      20536B696C6C730100280000004A6F62207469746C65732C20736B696C6C7320
      616E642072656C61746564206A6F627320646174610200000000000300050000
      0066616C7365040007000000756E6B6E6F776E05004900000068747470733A2F
      2F6769746875622E636F6D2F776F726B666F7263652D646174612D696E697469
      61746976652F736B696C6C732D6170692F77696B692F4150492D4F7665727669
      65770600040000004A6F6273FEFEFF1B1C005E030000FF1D0000040000005265
      65640100140000004A6F6220626F6172642061676772656761746F7202000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      002100000068747470733A2F2F7777772E726565642E636F2E756B2F64657665
      6C6F706572730600040000004A6F6273FEFEFF1B1C005F030000FF1D00000800
      0000546865204D75736501001E0000004A6F6220626F61726420616E6420636F
      6D70616E792070726F66696C65730200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05002900000068747470733A2F2F77
      77772E7468656D7573652E636F6D2F646576656C6F706572732F6170692F7632
      0600040000004A6F6273FEFEFF1B1C0060030000FF1D0000060000005570776F
      726B010029000000467265656C616E6365206A6F6220626F61726420616E6420
      6D616E6167656D656E742073797374656D0200050000004F4175746803000400
      000074727565040007000000756E6B6E6F776E05001E00000068747470733A2F
      2F646576656C6F706572732E7570776F726B2E636F6D2F0600040000004A6F62
      73FEFEFF1B1C0061030000FF1D0000070000005553414A4F4253010017000000
      555320676F7665726E6D656E74206A6F6220626F617264020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E05001E000000
      68747470733A2F2F646576656C6F7065722E7573616A6F62732E676F762F0600
      040000004A6F6273FEFEFF1B1C0062030000FF1D000008000000576861744A6F
      62730100110000004A6F622073656172636820656E67696E6502000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05002300
      000068747470733A2F2F7777772E776861746A6F62732E636F6D2F616666696C
      69617465730600040000004A6F6273FEFEFF1B1C0063030000FF1D00000C0000
      005A697052656372756974657201001A0000004A6F6220736561726368206170
      7020616E6420776562736974650200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05002700000068747470733A2F2F7777
      772E7A69707265637275697465722E636F6D2F7075626C697368657273060004
      0000004A6F6273FEFEFF1B1C0064030000FF1D00000B000000414920466F7220
      546861690100180000004672656520566172696F757320546861692041492041
      50490200060000006170694B6579030004000000747275650400030000007965
      7305002100000068747470733A2F2F6169666F72746861692E696E2E74682F69
      6E6465782E7068700600100000004D616368696E65204C6561726E696E67FEFE
      FF1B1C0065030000FF1D000008000000436C61726966616901000F000000436F
      6D707574657220566973696F6E0200050000004F417574680300040000007472
      7565040007000000756E6B6E6F776E05003000000068747470733A2F2F646F63
      732E636C6172696661692E636F6D2F6170692D67756964652F6170692D6F7665
      72766965770600100000004D616368696E65204C6561726E696E67FEFEFF1B1C
      0066030000FF1D00000C000000436C6F75646D65727369766501003700000049
      6D6167652063617074696F6E696E672C2066616365207265636F676E6974696F
      6E2C204E53465720636C617373696669636174696F6E0200060000006170694B
      6579030004000000747275650400030000007965730500410000006874747073
      3A2F2F7777772E636C6F75646D6572736976652E636F6D2F696D6167652D7265
      636F676E6974696F6E2D616E642D70726F63657373696E672D61706906001000
      00004D616368696E65204C6561726E696E67FEFEFF1B1C0067030000FF1D0000
      0800000044656570636F6465010012000000414920666F7220636F6465207265
      7669657702000000000003000400000074727565040007000000756E6B6E6F77
      6E05001700000068747470733A2F2F7777772E64656570636F64652E61690600
      100000004D616368696E65204C6561726E696E67FEFEFF1B1C0068030000FF1D
      00000A0000004469616C6F67666C6F7701001B0000004E61747572616C204C61
      6E67756167652050726F63657373696E670200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05002900000068747470733A
      2F2F636C6F75642E676F6F676C652E636F6D2F6469616C6F67666C6F772F646F
      63732F0600100000004D616368696E65204C6561726E696E67FEFEFF1B1C0069
      030000FF1D00000900000045585544452D415049010057000000557365642066
      6F7220746865207072696D617279207761797320666F722066696C746572696E
      67207468652073746F7070696E672C207374656D6D696E6720776F7264732066
      726F6D2074686520746578742064617461020000000000030004000000747275
      6504000300000079657305001C000000687474703A2F2F7574746573682E636F
      6D2F65787564652D6170692F0600100000004D616368696E65204C6561726E69
      6E67FEFEFF1B1C006A030000FF1D00000D000000486972616B20466163654150
      490100610000004661636520646574656374696F6E2C2066616365207265636F
      676E6974696F6E20776974682061676520657374696D6174696F6E2F67656E64
      657220657374696D6174696F6E2C2061636375726174652C206E6F2071756F74
      61206C696D6974730200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001B00000068747470733A2F2F66616365617069
      2E686972616B2E736974652F0600100000004D616368696E65204C6561726E69
      6E67FEFEFF1B1C006B030000FF1D000006000000496D61676761010048000000
      496D616765205265636F676E6974696F6E20536F6C7574696F6E73206C696B65
      2054616767696E672C2056697375616C205365617263682C204E534657206D6F
      6465726174696F6E0200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001300000068747470733A2F2F696D616767612E
      636F6D2F0600100000004D616368696E65204C6561726E696E67FEFEFF1B1C00
      6C030000FF1D000007000000496E666572646F010053000000436F6D70757465
      7220566973696F6E207365727669636573206C696B652046616369616C206465
      74656374696F6E2C20496D616765206C6162656C696E672C204E53465720636C
      617373696669636174696F6E0200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05002100000068747470733A2F2F726170
      69646170692E636F6D2F757365722F696E666572646F0600100000004D616368
      696E65204C6561726E696E67FEFEFF1B1C006D030000FF1D00000A0000004950
      53204F6E6C696E650100240000004661636520616E64204C6963656E73652050
      6C61746520416E6F6E796D697A6174696F6E0200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E05001D0000006874747073
      3A2F2F646F63732E6964656E746974792E70732F646F63730600100000004D61
      6368696E65204C6561726E696E67FEFEFF1B1C006E030000FF1D000007000000
      497269736E65740100510000005265616C74696D6520636F6E74656E74206D6F
      6465726174696F6E20415049207468617420626C6F636B73206F7220626C7572
      7320756E77616E74656420696D6167657320696E207265616C2D74696D650200
      060000006170694B657903000400000074727565040003000000796573050017
      00000068747470733A2F2F697269736E65742E64652F6170692F060010000000
      4D616368696E65204C6561726E696E67FEFEFF1B1C006F030000FF1D00000700
      00004B65656E20494F01000E0000004461746120416E616C7974696373020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001000000068747470733A2F2F6B65656E2E696F2F0600100000004D616368
      696E65204C6561726E696E67FEFEFF1B1C0070030000FF1D00000D0000004D61
      6368696E657475746F7273010056000000414920536F6C7574696F6E733A2056
      6964656F2F496D61676520436C617373696669636174696F6E20262054616767
      696E672C204E5346572C2049636F6E2F496D6167652F417564696F2053656172
      63682C204E4C500200060000006170694B657903000400000074727565040003
      00000079657305003300000068747470733A2F2F7777772E6D616368696E6574
      75746F72732E636F6D2F706F7274666F6C696F2F4D545F6170692E68746D6C06
      00100000004D616368696E65204C6561726E696E67FEFEFF1B1C0071030000FF
      1D00000D0000004D657373656E676572582E696F01004F000000412046524545
      2041504920666F7220646576656C6F7065727320746F206275696C6420616E64
      206D6F6E6574697A6520706572736F6E616C697A6564204D4C20626173656420
      6368617420617070730200060000006170694B65790300040000007472756504
      000300000079657305001A00000068747470733A2F2F6D657373656E67657278
      2E727466642E696F0600100000004D616368696E65204C6561726E696E67FEFE
      FF1B1C0072030000FF1D0000090000004E4C5020436C6F75640100610000004E
      4C5020415049207573696E6720737061437920616E64207472616E73666F726D
      65727320666F72204E45522C2073656E74696D656E74732C20636C6173736966
      69636174696F6E2C2073756D6D6172697A6174696F6E2C20616E64206D6F7265
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001300000068747470733A2F2F6E6C70636C6F75642E696F06001000
      00004D616368696E65204C6561726E696E67FEFEFF1B1C0073030000FF1D0000
      0D0000004F70656E566973696F6E41504901003B0000004F70656E20736F7572
      636520636F6D707574657220766973696F6E20415049206261736564206F6E20
      6F70656E20736F75726365206D6F64656C730200000000000300040000007472
      756504000300000079657305001900000068747470733A2F2F6F70656E766973
      696F6E6170692E636F6D0600100000004D616368696E65204C6561726E696E67
      FEFEFF1B1C0074030000FF1D00000B0000005065727370656374697665010056
      0000004E4C502041504920746F2072657475726E2070726F626162696C697479
      2074686174206966207465787420697320746F7869632C206F627363656E652C
      20696E73756C74696E67206F7220746872656174656E696E6702000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001A00
      000068747470733A2F2F70657273706563746976656170692E636F6D06001000
      00004D616368696E65204C6561726E696E67FEFEFF1B1C0075030000FF1D0000
      11000000526F626F666C6F7720556E6976657273650100220000005072652D74
      7261696E656420636F6D707574657220766973696F6E206D6F64656C73020006
      0000006170694B65790300040000007472756504000300000079657305001D00
      000068747470733A2F2F756E6976657273652E726F626F666C6F772E636F6D06
      00100000004D616368696E65204C6561726E696E67FEFEFF1B1C0076030000FF
      1D00000B000000536B7942696F6D657472790100320000004661636520446574
      656374696F6E2C2046616365205265636F676E6974696F6E20616E6420466163
      652047726F7570696E670200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05002600000068747470733A2F2F736B796269
      6F6D657472792E636F6D2F646F63756D656E746174696F6E2F0600100000004D
      616368696E65204C6561726E696E67FEFEFF1B1C0077030000FF1D0000090000
      0054696D6520446F6F7201001A000000412074696D652073657269657320616E
      616C79736973204150490200060000006170694B657903000400000074727565
      04000300000079657305001300000068747470733A2F2F74696D65646F6F722E
      696F0600100000004D616368696E65204C6561726E696E67FEFEFF1B1C007803
      0000FF1D000007000000556E706C756767010023000000466F72656361737469
      6E672041504920666F722074696D657365726965732064617461020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E05001E
      00000068747470733A2F2F756E706C752E67672F746573745F6170692E68746D
      6C0600100000004D616368696E65204C6561726E696E67FEFEFF1B1C00790300
      00FF1D00000C000000576F6C6672616D416C70686101004000000050726F7669
      64657320737065636966696320616E737765727320746F207175657374696F6E
      73207573696E67206461746120616E6420616C676F726974686D730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      2600000068747470733A2F2F70726F64756374732E776F6C6672616D616C7068
      612E636F6D2F6170692F0600100000004D616368696E65204C6561726E696E67
      FEFEFF1B1C007A030000FF1D000008000000376469676974616C01001B000000
      417069206F66204D757369632073746F726520376469676974616C0200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050023
      00000068747470733A2F2F646F63732E376469676974616C2E636F6D2F726566
      6572656E63650600050000004D75736963FEFEFF1B1C007B030000FF1D00000C
      0000004149204D6173746572696E670100190000004175746F6D61746564204D
      75736963204D6173746572696E670200060000006170694B6579030004000000
      7472756504000300000079657305002100000068747470733A2F2F61696D6173
      746572696E672E636F6D2F6170695F646F63732F0600050000004D75736963FE
      FEFF1B1C007C030000FF1D000009000000417564696F6D61636B010028000000
      417069206F66207468652073747265616D696E67206D75736963206875622041
      7564696F6D61636B0200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05002700000068747470733A2F2F7777772E61756469
      6F6D61636B2E636F6D2F646174612D6170692F646F63730600050000004D7573
      6963FEFEFF1B1C007D030000FF1D00000800000042616E6463616D7001001B00
      0000415049206F66204D757369632073746F72652042616E6463616D70020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      001E00000068747470733A2F2F62616E6463616D702E636F6D2F646576656C6F
      7065720600050000004D75736963FEFEFF1B1C007E030000FF1D00000B000000
      42616E6473696E746F776E01000C0000004D75736963204576656E7473020000
      00000003000400000074727565040007000000756E6B6E6F776E05003B000000
      68747470733A2F2F6170702E737761676765726875622E636F6D2F617069732F
      42616E6473696E746F776E2F5075626C69634150492F332E302E300600050000
      004D75736963FEFEFF1B1C007F030000FF1D0000060000004465657A65720100
      050000004D757369630200050000004F41757468030004000000747275650400
      07000000756E6B6E6F776E05002100000068747470733A2F2F646576656C6F70
      6572732E6465657A65722E636F6D2F6170690600050000004D75736963FEFEFF
      1B1C0080030000FF1D000007000000446973636F67730100050000004D757369
      630200050000004F4175746803000400000074727565040007000000756E6B6E
      6F776E05002300000068747470733A2F2F7777772E646973636F67732E636F6D
      2F646576656C6F706572732F0600050000004D75736963FEFEFF1B1C00810300
      00FF1D00000900000046726565736F756E6401000D0000004D75736963205361
      6D706C65730200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05001F00000068747470733A2F2F66726565736F756E642E
      6F72672F646F63732F6170692F0600050000004D75736963FEFEFF1B1C008203
      0000FF1D0000050000004761616E6101002B00000041504920746F2072657472
      6965766520736F6E6720696E666F726D6174696F6E2066726F6D204761616E61
      02000000000003000400000074727565040007000000756E6B6E6F776E05002C
      00000068747470733A2F2F6769746875622E636F6D2F6379626572626F797375
      6D616E6A61792F4761616E614150490600050000004D75736963FEFEFF1B1C00
      83030000FF1D00000600000047656E69757301002700000043726F7764736F75
      72636564206C797269637320616E64206D75736963206B6E6F776C6564676502
      00050000004F4175746803000400000074727565040007000000756E6B6E6F77
      6E05001800000068747470733A2F2F646F63732E67656E6975732E636F6D2F06
      00050000004D75736963FEFEFF1B1C0084030000FF1D00000A00000047656E72
      656E61746F720100150000004D757369632067656E72652067656E657261746F
      7202000000000003000400000074727565040007000000756E6B6E6F776E0500
      2500000068747470733A2F2F62696E6172796A617A7A2E75732F67656E72656E
      61746F722D6170692F0600050000004D75736963FEFEFF1B1C0085030000FF1D
      00000D0000006954756E657320536561726368010011000000536F6674776172
      652070726F647563747302000000000003000400000074727565040007000000
      756E6B6E6F776E05005F00000068747470733A2F2F616666696C696174652E69
      74756E65732E6170706C652E636F6D2F7265736F75726365732F646F63756D65
      6E746174696F6E2F6974756E65732D73746F72652D7765622D73657276696365
      2D7365617263682D6170692F0600050000004D75736963FEFEFF1B1C00860300
      00FF1D0000070000004A616D656E646F0100050000004D757369630200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050027
      00000068747470733A2F2F646576656C6F7065722E6A616D656E646F2E636F6D
      2F76332E302F646F63730600050000004D75736963FEFEFF1B1C0087030000FF
      1D0000080000004A696F536161766E01004D00000041504920746F2072657472
      6965766520736F6E6720696E666F726D6174696F6E2C20616C62756D206D6574
      61206461746120616E64206D616E79206D6F72652066726F6D204A696F536161
      766E02000000000003000400000074727565040007000000756E6B6E6F776E05
      002F00000068747470733A2F2F6769746875622E636F6D2F6379626572626F79
      73756D616E6A61792F4A696F536161766E4150490600050000004D75736963FE
      FEFF1B1C0088030000FF1D0000050000004B4B424F5801004B00000047657420
      6D75736963206C69627261726965732C20706C61796C697374732C2063686172
      74732C20616E6420706572666F726D206F7574206F66204B4B424F5827732070
      6C6174666F726D0200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05001B00000068747470733A2F2F646576656C6F706572
      2E6B6B626F782E636F6D0600050000004D75736963FEFEFF1B1C0089030000FF
      1D00000F0000004B536F66742E5369204C797269637301001B00000041504920
      746F20676574206C797269637320666F7220736F6E6773020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050024000000
      68747470733A2F2F646F63732E6B736F66742E73692F6170692F6C7972696373
      2D6170690600050000004D75736963FEFEFF1B1C008A030000FF1D0000060000
      004C617374466D0100050000004D757369630200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E0500170000006874747073
      3A2F2F7777772E6C6173742E666D2F6170690600050000004D75736963FEFEFF
      1B1C008B030000FF1D00000A0000004C79726963732E6F766801002B00000053
      696D706C652041504920746F20726574726965766520746865206C7972696373
      206F66206120736F6E6702000000000003000400000074727565040007000000
      756E6B6E6F776E05002000000068747470733A2F2F6C79726963736F76682E64
      6F63732E6170696172792E696F0600050000004D75736963FEFEFF1B1C008C03
      0000FF1D0000080000004D6978636C6F75640100050000004D75736963020005
      0000004F41757468030004000000747275650400030000007965730500240000
      0068747470733A2F2F7777772E6D6978636C6F75642E636F6D2F646576656C6F
      706572732F0600050000004D75736963FEFEFF1B1C008D030000FF1D00000B00
      00004D75736963427261696E7A0100050000004D757369630200000000000300
      0400000074727565040007000000756E6B6E6F776E0500410000006874747073
      3A2F2F6D75736963627261696E7A2E6F72672F646F632F446576656C6F706D65
      6E742F584D4C5F5765625F536572766963652F56657273696F6E5F3206000500
      00004D75736963FEFEFF1B1C008E030000FF1D00000A0000004D757369786D61
      7463680100050000004D757369630200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05002100000068747470733A2F2F64
      6576656C6F7065722E6D757369786D617463682E636F6D2F0600050000004D75
      736963FEFEFF1B1C008F030000FF1D0000070000004E61707374657201000500
      00004D757369630200060000006170694B657903000400000074727565040003
      00000079657305002600000068747470733A2F2F646576656C6F7065722E6E61
      70737465722E636F6D2F6170692F76322E320600050000004D75736963FEFEFF
      1B1C0090030000FF1D0000080000004F70656E7768796401004C000000446F77
      6E6C6F6164206375726174656420706C61796C69737473206F66207374726561
      6D696E6720747261636B732028596F75547562652C20536F756E64436C6F7564
      2C206574632E2E2E29020000000000030004000000747275650400020000006E
      6F05002700000068747470733A2F2F6F70656E776879642E6769746875622E69
      6F2F6F70656E776879642F4150490600050000004D75736963FEFEFF1B1C0091
      030000FF1D0000070000005068697368696E01005900000041207765622D6261
      7365642061726368697665206F66206C6567616C206C69766520617564696F20
      7265636F7264696E6773206F662074686520696D70726F7669736174696F6E61
      6C20726F636B2062616E642050686973680200060000006170694B6579030004
      000000747275650400020000006E6F05001900000068747470733A2F2F706869
      73682E696E2F6170692D646F63730600050000004D75736963FEFEFF1B1C0092
      030000FF1D00000D000000526164696F2042726F7773657201001F0000004C69
      7374206F6620696E7465726E657420726164696F2073746174696F6E73020000
      0000000300040000007472756504000300000079657305001F00000068747470
      733A2F2F6170692E726164696F2D62726F777365722E696E666F2F0600050000
      004D75736963FEFEFF1B1C0093030000FF1D000008000000536F6E676B69636B
      01000C0000004D75736963204576656E74730200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E0500230000006874747073
      3A2F2F7777772E736F6E676B69636B2E636F6D2F646576656C6F7065722F0600
      050000004D75736963FEFEFF1B1C0094030000FF1D000011000000536F6E676C
      696E6B202F204F6465736C6901003100000047657420616C6C20746865207365
      727669636573206F6E207768696368206120736F6E6720697320617661696C61
      626C650200060000006170694B65790300040000007472756504000300000079
      657305003A00000068747470733A2F2F7777772E6E6F74696F6E2E736F2F4150
      492D643065626530386135653330346135353932383430356562363832663637
      34310600050000004D75736963FEFEFF1B1C0095030000FF1D00000900000053
      6F6E67737465727201002F00000050726F7669646573206775697461722C2062
      61737320616E64206472756D73207461627320616E642063686F726473020000
      00000003000400000074727565040007000000756E6B6E6F776E050023000000
      68747470733A2F2F7777772E736F6E6773746572722E636F6D2F612F77612F61
      70692F0600050000004D75736963FEFEFF1B1C0096030000FF1D00000A000000
      536F756E64436C6F75640100600000005769746820536F756E64436C6F756420
      41504920796F752063616E206275696C64206170706C69636174696F6E732074
      6861742077696C6C2067697665206D6F726520706F77657220746F20636F6E74
      726F6C20796F757220636F6E74656E740200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05003000000068747470733A2F2F
      646576656C6F706572732E736F756E64636C6F75642E636F6D2F646F63732F61
      70692F67756964650600050000004D75736963FEFEFF1B1C0097030000FF1D00
      000700000053706F74696679010051000000566965772053706F74696679206D
      7573696320636174616C6F672C206D616E61676520757365727327206C696272
      61726965732C20676574207265636F6D6D656E646174696F6E7320616E64206D
      6F72650200050000004F4175746803000400000074727565040007000000756E
      6B6E6F776E05003900000068747470733A2F2F626574612E646576656C6F7065
      722E73706F746966792E636F6D2F646F63756D656E746174696F6E2F7765622D
      6170692F0600050000004D75736963FEFEFF1B1C0098030000FF1D0000090000
      0054617374654469766501003700000053696D696C6172206172746973742041
      50492028616C736F20776F726B7320666F72206D6F7669657320616E64205456
      2073686F7773290200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001E00000068747470733A2F2F7461737465646976
      652E636F6D2F726561642F6170690600050000004D75736963FEFEFF1B1C0099
      030000FF1D00000A000000546865417564696F44420100050000004D75736963
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05002800000068747470733A2F2F7777772E746865617564696F64622E
      636F6D2F6170695F67756964652E7068700600050000004D75736963FEFEFF1B
      1C009A030000FF1D000008000000566167616C756D6501002700000043726F77
      64736F7572636564206C797269637320616E64206D75736963206B6E6F776C65
      6467650200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05002100000068747470733A2F2F6170692E766167616C756D65
      2E636F6D2E62722F646F63732F0600050000004D75736963FEFEFF1B1C009B03
      0000FF1D0000130000006170696C61796572206D65646961737461636B010033
      000000467265652C2053696D706C6520524553542041504920666F72204C6976
      65204E657773202620426C6F672041727469636C65730200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05001700000068
      747470733A2F2F6D65646961737461636B2E636F6D2F0600040000004E657773
      FEFEFF1B1C009C030000FF1D0000100000004173736F63696174656420507265
      737301003200000053656172636820666F72206E65777320616E64206D657461
      646174612066726F6D204173736F636961746564205072657373020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050019
      00000068747470733A2F2F646576656C6F7065722E61702E6F72672F06000400
      00004E657773FEFEFF1B1C009D030000FF1D0000130000004368726F6E69636C
      696E6720416D657269636101005B00000050726F766964657320616363657373
      20746F206D696C6C696F6E73206F66207061676573206F6620686973746F7269
      63205553206E6577737061706572732066726F6D20746865204C696272617279
      206F6620436F6E677265737302000000000003000500000066616C7365040007
      000000756E6B6E6F776E05002C000000687474703A2F2F6368726F6E69636C69
      6E67616D65726963612E6C6F632E676F762F61626F75742F6170692F06000400
      00004E657773FEFEFF1B1C009E030000FF1D00000800000043757272656E7473
      01003F0000004C6174657374206E657773207075626C697368656420696E2076
      6172696F7573206E65777320736F75726365732C20626C6F677320616E642066
      6F72756D730200060000006170694B6579030004000000747275650400030000
      0079657305001D00000068747470733A2F2F63757272656E74736170692E7365
      7276696365732F0600040000004E657773FEFEFF1B1C009F030000FF1D000007
      0000004665656462696E01000A00000052535320726561646572020005000000
      4F4175746803000400000074727565040007000000756E6B6E6F776E05002600
      000068747470733A2F2F6769746875622E636F6D2F6665656462696E2F666565
      6462696E2D6170690600040000004E657773FEFEFF1B1C00A0030000FF1D0000
      05000000474E65777301002400000053656172636820666F72206E6577732066
      726F6D20766172696F757320736F75726365730200060000006170694B657903
      00040000007472756504000300000079657305001100000068747470733A2F2F
      676E6577732E696F2F0600040000004E657773FEFEFF1B1C00A1030000FF1D00
      001600000047726170687320666F7220436F726F6E61766972757301004B0000
      004561636820436F756E7472792073657061726174656C7920616E6420576F72
      6C64776964652047726170687320666F7220436F726F6E6176697275732E2044
      61696C7920757064617465730200000000000300040000007472756504000300
      000079657305002700000068747470733A2F2F636F726F6E612E646E73666F72
      66616D696C792E636F6D2F6170692E7478740600040000004E657773FEFEFF1B
      1C00A2030000FF1D00000D000000496E73686F727473204E65777301001B0000
      0050726F7669646573206E6577732066726F6D20696E73686F72747302000000
      000003000400000074727565040007000000756E6B6E6F776E05003500000068
      747470733A2F2F6769746875622E636F6D2F6379626572626F7973756D616E6A
      61792F496E73686F7274732D4E6577732D4150490600040000004E657773FEFE
      FF1B1C00A3030000FF1D0000090000004D61726B65744175780100490000004C
      6976652073746F636B206D61726B6574206E6577732077697468207461676765
      64207469636B657273202B2073656E74696D656E7420616E6420737461747320
      4A534F4E204150490200060000006170694B6579030004000000747275650400
      0300000079657305001A00000068747470733A2F2F7777772E6D61726B657461
      75782E636F6D2F0600040000004E657773FEFEFF1B1C00A4030000FF1D00000E
      0000004E657720596F726B2054696D6573010024000000546865204E65772059
      6F726B2054696D657320446576656C6F706572204E6574776F726B0200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1E00000068747470733A2F2F646576656C6F7065722E6E7974696D65732E636F
      6D2F0600040000004E657773FEFEFF1B1C00A5030000FF1D0000040000004E65
      7773010042000000486561646C696E65732063757272656E746C79207075626C
      6973686564206F6E20612072616E6765206F66206E65777320736F7572636573
      20616E6420626C6F67730200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05001400000068747470733A2F2F6E65777361
      70692E6F72672F0600040000004E657773FEFEFF1B1C00A6030000FF1D000008
      0000004E6577734461746101004D0000004E6577732064617461204150492066
      6F72206C6976652D627265616B696E67206E65777320616E6420686561646C69
      6E65732066726F6D207265707574656420206E65777320736F75726365730200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05001800000068747470733A2F2F6E657773646174612E696F2F646F637306
      00040000004E657773FEFEFF1B1C00A7030000FF1D0000050000004E65777358
      010041000000476574206F7220536561726368204C617465737420427265616B
      696E67204E6577732077697468204D4C20506F77657265642053756D6D617269
      657320F09FA4960200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05003F00000068747470733A2F2F7261706964617069
      2E636F6D2F6D61636861616F2D696E632D6D61636861616F2D696E632D646566
      61756C742F6170692F6E657773782F0600040000004E657773FEFEFF1B1C00A8
      030000FF1D0000070000004E5052204F6E6501002F000000506572736F6E616C
      697A6564206E657773206C697374656E696E6720657870657269656E63652066
      726F6D204E50520200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E050017000000687474703A2F2F6465762E6E70722E6F72
      672F6170692F0600040000004E657773FEFEFF1B1C00A9030000FF1D00001000
      00005370616365666C69676874204E65777301001D0000005370616365666C69
      6768742072656C61746564206E65777320F09F9A800200000000000300040000
      007472756504000300000079657305001E00000068747470733A2F2F73706163
      65666C696768746E6577736170692E6E65740600040000004E657773FEFEFF1B
      1C00AA030000FF1D00000C00000054686520477561726469616E01004C000000
      41636365737320616C6C2074686520636F6E74656E7420746865204775617264
      69616E20637265617465732C2063617465676F72697365642062792074616773
      20616E642073656374696F6E0200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E050025000000687474703A2F2F6F70656E
      2D706C6174666F726D2E746865677561726469616E2E636F6D2F060004000000
      4E657773FEFEFF1B1C00AB030000FF1D00000E000000546865204F6C64205265
      6164657201000A000000525353207265616465720200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E050023000000687474
      70733A2F2F6769746875622E636F6D2F7468656F6C647265616465722F617069
      0600040000004E657773FEFEFF1B1C00AC030000FF1D0000070000005468654E
      6577730100360000004167677265676174656420686561646C696E65732C2074
      6F702073746F727920616E64206C697665206E657773204A534F4E2041504902
      00060000006170694B6579030004000000747275650400030000007965730500
      1B00000068747470733A2F2F7777772E7468656E6577736170692E636F6D2F06
      00040000004E657773FEFEFF1B1C00AD030000FF1D00000500000054726F7665
      01005C000000536561726368207468726F75676820746865204E6174696F6E61
      6C204C696272617279206F66204175737472616C696120636F6C6C656374696F
      6E206F66203130303073206F6620646967697469736564206E65777370617065
      72730200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05003900000068747470733A2F2F74726F76652E6E6C612E676F76
      2E61752F61626F75742F6372656174652D736F6D657468696E672F7573696E67
      2D6170690600040000004E657773FEFEFF1B1C00AE030000FF1D000003000000
      313846010030000000556E6F6666696369616C205553204665646572616C2047
      6F7665726E6D656E742041504920446576656C6F706D656E7402000000000003
      000500000066616C7365040007000000756E6B6E6F776E050023000000687474
      703A2F2F3138662E6769746875622E696F2F4150492D416C6C2D7468652D582F
      0600090000004F70656E2044617461FEFEFF1B1C00AF030000FF1D0000080000
      004150492053657475010063000000416E20496E6469616E20476F7665726E6D
      656E7420706C6174666F726D20746861742070726F76696465732061206C6F74
      206F66204150495320666F72204B59432C20627573696E6573732C2065647563
      6174696F6E202620656D706C6F796D656E740200000000000300040000007472
      756504000300000079657305001B00000068747470733A2F2F7777772E617069
      736574752E676F762E696E2F0600090000004F70656E2044617461FEFEFF1B1C
      00B0030000FF1D00000B000000417263686976652E6F72670100140000005468
      6520496E7465726E657420417263686976650200000000000300040000007472
      75650400020000006E6F05001E00000068747470733A2F2F617263686976652E
      726561646D652E696F2F646F63730600090000004F70656E2044617461FEFEFF
      1B1C00B1030000FF1D000013000000426C61636B20486973746F727920466163
      747301004F000000436F6E74726962757465206F7220736561726368206F6E65
      206F6620746865206C61726765737420626C61636B20686973746F7279206661
      637420646174616261736573206F6E2074686520776562020006000000617069
      4B65790300040000007472756504000300000079657305002300000068747470
      733A2F2F7777772E626C61636B686973746F72796170692E696F2F646F637306
      00090000004F70656E2044617461FEFEFF1B1C00B2030000FF1D00000B000000
      426F7473417263686976650100400000004A534F4E20666F726D617474656420
      64657461696C732061626F75742054656C656772616D20426F74732061766169
      6C61626C6520696E206461746162617365020000000000030004000000747275
      65040007000000756E6B6E6F776E05002100000068747470733A2F2F626F7473
      617263686976652E636F6D2F646F63732E68746D6C0600090000004F70656E20
      44617461FEFEFF1B1C00B3030000FF1D00000C00000043616C6C6F6F6B2E696E
      666F010021000000556E69746564205374617465732068616D20726164696F20
      63616C6C7369676E730200000000000300040000007472756504000700000075
      6E6B6E6F776E05001400000068747470733A2F2F63616C6C6F6F6B2E696E666F
      0600090000004F70656E2044617461FEFEFF1B1C00B4030000FF1D0000050000
      00434152544F01001F0000004C6F636174696F6E20496E666F726D6174696F6E
      2050726564696374696F6E0200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05001200000068747470733A2F2F63617274
      6F2E636F6D2F0600090000004F70656E2044617461FEFEFF1B1C00B5030000FF
      1D000017000000436F6C6C65676553636F7265436172642E65642E676F760100
      3A00000044617461206F6E2068696768657220656475636174696F6E20696E73
      7469747574696F6E7320696E2074686520556E69746564205374617465730200
      0000000003000400000074727565040007000000756E6B6E6F776E0500250000
      0068747470733A2F2F636F6C6C65676573636F7265636172642E65642E676F76
      2F646174612F0600090000004F70656E2044617461FEFEFF1B1C00B6030000FF
      1D00000D000000456E69676D61205075626C696301002200000042726F616465
      737420636F6C6C656374696F6E206F66207075626C6963206461746102000600
      00006170694B6579030004000000747275650400030000007965730500220000
      0068747470733A2F2F646576656C6F706572732E656E69676D612E636F6D2F64
      6F63730600090000004F70656E2044617461FEFEFF1B1C00B7030000FF1D0000
      150000004672656E636820416464726573732053656172636801002800000041
      646472657373207365617263682076696120746865204672656E636820476F76
      65726E6D656E7402000000000003000400000074727565040007000000756E6B
      6E6F776E05001F00000068747470733A2F2F67656F2E6170692E676F75762E66
      722F616472657373650600090000004F70656E2044617461FEFEFF1B1C00B803
      0000FF1D00000700000047454E455349530100220000004665646572616C2053
      7461746973746963616C204F6666696365204765726D616E790200050000004F
      4175746803000400000074727565040007000000756E6B6E6F776E05003F0000
      0068747470733A2F2F7777772E64657374617469732E64652F454E2F53657276
      6963652F4F70656E446174612F6170692D776562736572766963652E68746D6C
      0600090000004F70656E2044617461FEFEFF1B1C00B9030000FF1D00000E0000
      004A6F736875612050726F6A65637401003E00000050656F706C652067726F75
      7073206F662074686520776F726C642077697468207468652066657765737420
      666F6C6C6F77657273206F66204368726973740200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001E00000068747470
      733A2F2F6170692E6A6F7368756170726F6A6563742E6E65742F060009000000
      4F70656E2044617461FEFEFF1B1C00BA030000FF1D0000060000004B6167676C
      6501004500000043726561746520616E6420696E746572616374207769746820
      44617461736574732C204E6F7465626F6F6B732C20616E6420636F6E6E656374
      2077697468204B6167676C650200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05001F00000068747470733A2F2F777777
      2E6B6167676C652E636F6D2F646F63732F6170690600090000004F70656E2044
      617461FEFEFF1B1C00BB030000FF1D00000B0000004C696E6B50726576696577
      01005A000000476574204A534F4E20666F726D61747465642073756D6D617279
      2077697468207469746C652C206465736372697074696F6E20616E6420707265
      7669657720696D61676520666F7220616E79207265717565737465642055524C
      0200060000006170694B65790300040000007472756504000300000079657305
      001B00000068747470733A2F2F7777772E6C696E6B707265766965772E6E6574
      0600090000004F70656E2044617461FEFEFF1B1C00BC030000FF1D0000150000
      004C6F7779204173696120506F77657220496E64657801005000000047657420
      6D656173757265207265736F757263657320616E6420696E666C75656E636520
      746F2072616E6B207468652072656C617469766520706F776572206F66207374
      6174657320696E20417369610200000000000300040000007472756504000700
      0000756E6B6E6F776E05002D00000068747470733A2F2F6769746875622E636F
      6D2F3078306973312F6C6F77792D696E6465782D6170692D646F637306000900
      00004F70656E2044617461FEFEFF1B1C00BD030000FF1D00000C0000004D6963
      726F6C696E6B2E696F0100280000004578747261637420737472756374757265
      6420646174612066726F6D20616E792077656273697465020000000000030004
      0000007472756504000300000079657305001400000068747470733A2F2F6D69
      63726F6C696E6B2E696F0600090000004F70656E2044617461FEFEFF1B1C00BE
      030000FF1D0000100000004E61736461712044617461204C696E6B0100110000
      0053746F636B206D61726B657420646174610200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E05001D0000006874747073
      3A2F2F646F63732E646174612E6E61736461712E636F6D2F0600090000004F70
      656E2044617461FEFEFF1B1C00BF030000FF1D00000B0000004E6F62656C2050
      72697A650100270000004F70656E20646174612061626F7574206E6F62656C20
      7072697A657320616E64206576656E7473020000000000030004000000747275
      6504000300000079657305003200000068747470733A2F2F7777772E6E6F6265
      6C7072697A652E6F72672F61626F75742F646576656C6F7065722D7A6F6E652D
      322F0600090000004F70656E2044617461FEFEFF1B1C00C0030000FF1D000015
      0000004F70656E2044617461204D696E6E6561706F6C69730100370000005370
      617469616C20284749532920616E64206E6F6E2D7370617469616C2063697479
      206461746120666F72204D696E6E6561706F6C69730200000000000300040000
      00747275650400020000006E6F05002300000068747470733A2F2F6F70656E64
      6174612E6D696E6E6561706F6C69736D6E2E676F762F0600090000004F70656E
      2044617461FEFEFF1B1C00C1030000FF1D00000A0000006F70656E4146524943
      4101002E0000004C61726765206461746173657473207265706F7369746F7279
      206F66204166726963616E206F70656E20646174610200000000000300040000
      0074727565040007000000756E6B6E6F776E05001B00000068747470733A2F2F
      6166726963616F70656E646174612E6F72672F0600090000004F70656E204461
      7461FEFEFF1B1C00C2030000FF1D00000E0000004F70656E436F72706F726174
      657301003A00000044617461206F6E20636F72706F7261746520656E74697469
      657320616E64206469726563746F727320696E206D616E7920636F756E747269
      65730200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E050039000000687474703A2F2F6170692E6F70656E636F72706F72
      617465732E636F6D2F646F63756D656E746174696F6E2F4150492D5265666572
      656E63650600090000004F70656E2044617461FEFEFF1B1C00C3030000FF1D00
      000D0000004F70656E53616E6374696F6E7301004600000044617461206F6E20
      696E7465726E6174696F6E616C2073616E6374696F6E732C206372696D652061
      6E6420706F6C69746963616C6C79206578706F73656420706572736F6E730200
      0000000003000400000074727565040003000000796573050027000000687474
      70733A2F2F7777772E6F70656E73616E6374696F6E732E6F72672F646F63732F
      6170692F0600090000004F70656E2044617461FEFEFF1B1C00C4030000FF1D00
      000B0000005065616B4D6574726963730100210000004E657773206172746963
      6C657320616E64207075626C6963206461746173657473020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050049000000
      68747470733A2F2F72617069646170692E636F6D2F7065616B6D657472696373
      2D7065616B6D6574726963732D64656661756C742F6170692F7065616B6D6574
      726963732D6E6577730600090000004F70656E2044617461FEFEFF1B1C00C503
      0000FF1D00001F00000052656372656174696F6E20496E666F726D6174696F6E
      20446174616261736501005F00000052656372656174696F6E616C2061726561
      732C206665646572616C206C616E64732C20686973746F726963207369746573
      2C206D757365756D732C20616E64206F746865722061747472616374696F6E73
      2F7265736F7572636573285553290200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001C00000068747470733A2F2F72
      6964622E72656372656174696F6E2E676F762F0600090000004F70656E204461
      7461FEFEFF1B1C00C6030000FF1D00000800000053636F6F702E697401001800
      0000436F6E74656E74204375726174696F6E2053657276696365020006000000
      6170694B657903000500000066616C7365040007000000756E6B6E6F776E0500
      17000000687474703A2F2F7777772E73636F6F702E69742F6465760600090000
      004F70656E2044617461FEFEFF1B1C00C7030000FF1D000007000000536F6372
      61746101004B00000041636365737320746F204F70656E20446174612066726F
      6D20476F7665726E6D656E74732C204E6F6E2D70726F6669747320616E64204E
      474F732061726F756E642074686520776F726C640200050000004F4175746803
      00040000007472756504000300000079657305001800000068747470733A2F2F
      6465762E736F63726174612E636F6D2F0600090000004F70656E2044617461FE
      FEFF1B1C00C8030000FF1D00000800000054656C65706F727401001400000051
      75616C697479206F66204C696665204461746102000000000003000400000074
      727565040007000000756E6B6E6F776E05002000000068747470733A2F2F6465
      76656C6F706572732E74656C65706F72742E6F72672F0600090000004F70656E
      2044617461FEFEFF1B1C00C9030000FF1D00000F000000556D65C3A5204F7065
      6E204461746101002D0000004F70656E2064617461206F662074686520636974
      7920556D65C3A520696E206E6F727468656E2053776564656E02000000000003
      00040000007472756504000300000079657305001D00000068747470733A2F2F
      6F70656E646174612E756D65612E73652F6170692F0600090000004F70656E20
      44617461FEFEFF1B1C00CA030000FF1D000011000000556E6976657273697469
      6573204C697374010027000000556E6976657273697479206E616D65732C2063
      6F756E747269657320616E6420646F6D61696E73020000000000030004000000
      74727565040007000000756E6B6E6F776E05002F00000068747470733A2F2F67
      69746875622E636F6D2F4869706F2F756E69766572736974792D646F6D61696E
      732D6C6973740600090000004F70656E2044617461FEFEFF1B1C00CB030000FF
      1D000012000000556E6976657273697479206F66204F736C6F01006200000043
      6F75727365732C206C65637475726520766964656F732C2064657461696C6564
      20696E666F726D6174696F6E20666F7220636F7572736573206574632E20666F
      722074686520556E6976657273697479206F66204F736C6F20284E6F72776179
      2902000000000003000400000074727565040007000000756E6B6E6F776E0500
      1400000068747470733A2F2F646174612E75696F2E6E6F2F0600090000004F70
      656E2044617461FEFEFF1B1C00CC030000FF1D00000C00000055504320646174
      616261736501003F0000004D6F7265207468616E20312E35206D696C6C696F6E
      20626172636F6465206E756D626572732066726F6D20616C6C2061726F756E64
      2074686520776F726C640200060000006170694B657903000400000074727565
      040007000000756E6B6E6F776E05001B00000068747470733A2F2F7570636461
      7461626173652E6F72672F6170690600090000004F70656E2044617461FEFEFF
      1B1C00CD030000FF1D000011000000557262616E204F627365727661746F7279
      010044000000546865206C61726765737420736574206F66207075626C69636C
      7920617661696C61626C65207265616C2074696D6520757262616E2064617461
      20696E2074686520554B02000000000003000500000066616C73650400020000
      006E6F05001E00000068747470733A2F2F757262616E6F627365727661746F72
      792E61632E756B0600090000004F70656E2044617461FEFEFF1B1C00CE030000
      FF1D00000800000057696B696461746101004A000000436F6C6C61626F726174
      6976656C7920656469746564206B6E6F776C656467652062617365206F706572
      61746564206279207468652057696B696D6564696120466F756E646174696F6E
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05002E00000068747470733A2F2F7777772E77696B69646174612E6F7267
      2F772F6170692E7068703F616374696F6E3D68656C700600090000004F70656E
      2044617461FEFEFF1B1C00CF030000FF1D00000900000057696B697065646961
      0100160000004D6564696177696B6920456E6379636C6F706564696102000000
      000003000400000074727565040007000000756E6B6E6F776E05002C00000068
      747470733A2F2F7777772E6D6564696177696B692E6F72672F77696B692F4150
      493A4D61696E5F706167650600090000004F70656E2044617461FEFEFF1B1C00
      D0030000FF1D00000400000059656C7001001300000046696E64204C6F63616C
      20427573696E6573730200050000004F41757468030004000000747275650400
      07000000756E6B6E6F776E05003000000068747470733A2F2F7777772E79656C
      702E636F6D2F646576656C6F706572732F646F63756D656E746174696F6E2F76
      330600090000004F70656E2044617461FEFEFF1B1C00D1030000FF1D00000700
      0000436F756E746C79010015000000436F756E746C792077656220616E616C79
      7469637302000000000003000500000066616C7365040007000000756E6B6E6F
      776E05001E00000068747470733A2F2F6170692E636F756E742E6C792F726566
      6572656E63650600140000004F70656E20536F757263652050726F6A65637473
      FEFEFF1B1C00D2030000FF1D000018000000437265617469766520436F6D6D6F
      6E7320436174616C6F6701003400000053656172636820616D6F6E67206F7065
      6E6C79206C6963656E73656420616E64207075626C696320646F6D61696E2077
      6F726B730200050000004F417574680300040000007472756504000300000079
      657305002800000068747470733A2F2F6170692E6372656174697665636F6D6D
      6F6E732E656E67696E656572696E672F0600140000004F70656E20536F757263
      652050726F6A65637473FEFEFF1B1C00D3030000FF1D00000800000044617461
      6D757365010019000000576F72642D66696E64696E6720717565727920656E67
      696E6502000000000003000400000074727565040007000000756E6B6E6F776E
      05001D00000068747470733A2F2F7777772E646174616D7573652E636F6D2F61
      70692F0600140000004F70656E20536F757263652050726F6A65637473FEFEFF
      1B1C00D4030000FF1D00000A00000044727570616C2E6F726701000A00000044
      727570616C2E6F72670200000000000300040000007472756504000700000075
      6E6B6E6F776E05002900000068747470733A2F2F7777772E64727570616C2E6F
      72672F64727570616C6F72672F646F63732F6170690600140000004F70656E20
      536F757263652050726F6A65637473FEFEFF1B1C00D5030000FF1D0000150000
      004576696C20496E73756C742047656E657261746F7201000C0000004576696C
      20496E73756C7473020000000000030004000000747275650400030000007965
      7305001A00000068747470733A2F2F6576696C696E73756C742E636F6D2F6170
      690600140000004F70656E20536F757263652050726F6A65637473FEFEFF1B1C
      00D6030000FF1D00002300000047697448756220436F6E747269627574696F6E
      2043686172742047656E657261746F7201002C00000043726561746520616E20
      696D616765206F6620796F75722047697448756220636F6E747269627574696F
      6E73020000000000030004000000747275650400030000007965730500270000
      0068747470733A2F2F6769746875622D636F6E747269627574696F6E732E7665
      7263656C2E6170700600140000004F70656E20536F757263652050726F6A6563
      7473FEFEFF1B1C00D7030000FF1D00001300000047697448756220526561644D
      652053746174730100420000004164642064796E616D6963616C6C792067656E
      657261746564207374617469737469637320746F20796F757220476974487562
      2070726F66696C6520526561644D650200000000000300040000007472756504
      000300000079657305003200000068747470733A2F2F6769746875622E636F6D
      2F616E7572616768617A72612F6769746875622D726561646D652D7374617473
      0600140000004F70656E20536F757263652050726F6A65637473FEFEFF1B1C00
      D8030000FF1D0000080000004D6574616261736501005B000000416E206F7065
      6E20736F7572636520427573696E65737320496E74656C6C6967656E63652073
      657276657220746F207368617265206461746120616E6420616E616C79746963
      7320696E7369646520796F757220636F6D70616E790200000000000300040000
      007472756504000300000079657305001900000068747470733A2F2F7777772E
      6D657461626173652E636F6D2F0600140000004F70656E20536F757263652050
      726F6A65637473FEFEFF1B1C00D9030000FF1D000007000000536869656C6473
      010040000000436F6E636973652C20636F6E73697374656E742C20616E64206C
      656769626C652062616467657320696E2053564720616E642072617374657220
      666F726D617402000000000003000400000074727565040007000000756E6B6E
      6F776E05001300000068747470733A2F2F736869656C64732E696F2F06001400
      00004F70656E20536F757263652050726F6A65637473FEFEFF1B1C00DA030000
      FF1D00000300000045504F0100210000004575726F7065616E20706174656E74
      207365617263682073797374656D206170690200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05001B00000068747470733A
      2F2F646576656C6F706572732E65706F2E6F72672F060006000000506174656E
      74FEFEFF1B1C00DB030000FF1D00000C000000506174656E7473566965772001
      005B00000041504920697320696E74656E64656420746F206578706C6F726520
      616E642076697375616C697A65207472656E64732F7061747465726E73206163
      726F73732074686520555320696E6E6F766174696F6E206C616E647363617065
      02000000000003000400000074727565040007000000756E6B6E6F776E050024
      00000068747470733A2F2F706174656E7473766965772E6F72672F617069732F
      707572706F7365060006000000506174656E74FEFEFF1B1C00DC030000FF1D00
      00040000005449504F01001F00000054616977616E20706174656E7420736561
      7263682073797374656D206170690200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05004500000068747470733A2F2F74
      69706F6E65742E7469706F2E676F762E74772F47617A657474652F4F70656E44
      6174612F4F442F4F4430352E617370783F51727944533D415049303006000600
      0000506174656E74FEFEFF1B1C00DD030000FF1D000005000000555350544F01
      001700000055534120706174656E742061706920736572766963657302000000
      000003000400000074727565040007000000756E6B6E6F776E05004300000068
      747470733A2F2F7777772E757370746F2E676F762F6C6561726E696E672D616E
      642D7265736F75726365732F6F70656E2D646174612D616E642D6D6F62696C69
      7479060006000000506174656E74FEFEFF1B1C00DE030000FF1D00000B000000
      41647669636520536C697001001C00000047656E65726174652072616E646F6D
      2061647669636520736C69707302000000000003000400000074727565040007
      000000756E6B6E6F776E05001A000000687474703A2F2F6170692E6164766963
      65736C69702E636F6D2F06000B000000506572736F6E616C697479FEFEFF1B1C
      00DF030000FF1D0000150000004269726979616E692041732041205365727669
      636501001B0000004269726979616E6920696D6167657320706C616365686F6C
      646572020000000000030004000000747275650400020000006E6F05001C0000
      0068747470733A2F2F6269726979616E692E616E6F72616D2E636F6D2F06000B
      000000506572736F6E616C697479FEFEFF1B1C00E0030000FF1D000006000000
      4465762E746F01003800000041636365737320466F72656D2061727469636C65
      732C20757365727320616E64206F74686572207265736F757263657320766961
      204150490200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05002000000068747470733A2F2F646576656C6F706572732E
      666F72656D2E636F6D2F61706906000B000000506572736F6E616C697479FEFE
      FF1B1C00E1030000FF1D00000600000044696374756D01005000000041504920
      746F206765742061636365737320746F2074686520636F6C6C656374696F6E20
      6F6620746865206D6F737420696E73706972696E672065787072657373696F6E
      73206F66206D616E6B696E640200000000000300040000007472756504000700
      0000756E6B6E6F776E05002300000068747470733A2F2F6769746875622E636F
      6D2F666973656E6B6F64762F64696374756D06000B000000506572736F6E616C
      697479FEFEFF1B1C00E2030000FF1D00000900000046617651732E636F6D0100
      44000000466176517320616C6C6F777320796F7520746F20636F6C6C6563742C
      20646973636F76657220616E6420736861726520796F7572206661766F726974
      652071756F7465730200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05001500000068747470733A2F2F66617671732E63
      6F6D2F61706906000B000000506572736F6E616C697479FEFEFF1B1C00E30300
      00FF1D000005000000464F4141530100150000004675636B204F666620417320
      41205365727669636502000000000003000500000066616C7365040007000000
      756E6B6E6F776E050015000000687474703A2F2F7777772E666F6161732E636F
      6D2F06000B000000506572736F6E616C697479FEFEFF1B1C00E4030000FF1D00
      000A000000466F7269736D61746963010014000000496E737069726174696F6E
      616C2051756F74657302000000000003000500000066616C7365040007000000
      756E6B6E6F776E05001D000000687474703A2F2F666F7269736D617469632E63
      6F6D2F656E2F6170692F06000B000000506572736F6E616C697479FEFEFF1B1C
      00E5030000FF1D00000E0000006963616E68617A6461646A6F6B650100320000
      00546865206C6172676573742073656C656374696F6E206F6620646164206A6F
      6B6573206F6E2074686520696E7465726E657402000000000003000400000074
      727565040007000000756E6B6E6F776E05001E00000068747470733A2F2F6963
      616E68617A6461646A6F6B652E636F6D2F61706906000B000000506572736F6E
      616C697479FEFEFF1B1C00E6030000FF1D00000B000000496E73706972617469
      6F6E0100250000004D6F7469766174696F6E616C20616E6420496E7370697261
      74696F6E616C2071756F74657302000000000003000400000074727565040003
      00000079657305002600000068747470733A2F2F696E737069726174696F6E2E
      676F70726F6772616D2E61692F646F63732F06000B000000506572736F6E616C
      697479FEFEFF1B1C00E7030000FF1D00000A0000006B616E79652E7265737401
      0025000000524553542041504920666F722072616E646F6D204B616E79652057
      6573742071756F74657302000000000003000400000074727565040003000000
      79657305001200000068747470733A2F2F6B616E79652E7265737406000B0000
      00506572736F6E616C697479FEFEFF1B1C00E8030000FF1D00000A0000006B69
      6D6971756F7465730100450000005465616D20726164696F20616E6420696E74
      6572766965772071756F7465732062792046696E6E697368204631206C656765
      6E64204B696D692052C3A4696B6BC3B66E656E02000000000003000400000074
      72756504000300000079657305002400000068747470733A2F2F6B696D697175
      6F7465732E6865726F6B756170702E636F6D2F646F6306000B00000050657273
      6F6E616C697479FEFEFF1B1C00E9030000FF1D0000060000004D656469756D01
      0046000000436F6D6D756E697479206F66207265616465727320616E64207772
      6974657273206F66666572696E6720756E697175652070657273706563746976
      6573206F6E2069646561730200050000004F4175746803000400000074727565
      040007000000756E6B6E6F776E05002900000068747470733A2F2F6769746875
      622E636F6D2F4D656469756D2F6D656469756D2D6170692D646F637306000B00
      0000506572736F6E616C697479FEFEFF1B1C00EA030000FF1D00001200000050
      726F6772616D6D696E672051756F74657301002F00000050726F6772616D6D69
      6E672051756F7465732041504920666F72206F70656E20736F75726365207072
      6F6A6563747302000000000003000400000074727565040007000000756E6B6E
      6F776E05003300000068747470733A2F2F6769746875622E636F6D2F736B6F6C
      616B6F64612F70726F6772616D6D696E672D71756F7465732D61706906000B00
      0000506572736F6E616C697479FEFEFF1B1C00EB030000FF1D00000F00000051
      756F7461626C652051756F74657301002E00000051756F7461626C6520697320
      6120667265652C206F70656E20736F757263652071756F746174696F6E732041
      504902000000000003000400000074727565040007000000756E6B6E6F776E05
      002600000068747470733A2F2F6769746875622E636F6D2F6C756B6550656176
      65792F71756F7461626C6506000B000000506572736F6E616C697479FEFEFF1B
      1C00EC030000FF1D00000C00000051756F74652047617264656E010029000000
      524553542041504920666F72206D6F7265207468616E20353030302066616D6F
      75732071756F7465730200000000000300040000007472756504000700000075
      6E6B6E6F776E05002E00000068747470733A2F2F707072617468616D6573686D
      6F72652E6769746875622E696F2F51756F746547617264656E2F06000B000000
      506572736F6E616C697479FEFEFF1B1C00ED030000FF1D00000A00000071756F
      7465636C656172010041000000457665722D67726F77696E67206C697374206F
      66204A616D657320436C6561722071756F7465732066726F6D2074686520332D
      322D31204E6577736C6574746572020000000000030004000000747275650400
      0300000079657305001B00000068747470733A2F2F71756F7465636C6561722E
      7765622E6170702F06000B000000506572736F6E616C697479FEFEFF1B1C00EE
      030000FF1D00001000000051756F746573206F6E2044657369676E0100140000
      00496E737069726174696F6E616C2051756F7465730200000000000300040000
      0074727565040007000000756E6B6E6F776E05001F00000068747470733A2F2F
      71756F7465736F6E64657369676E2E636F6D2F6170692F06000B000000506572
      736F6E616C697479FEFEFF1B1C00EF030000FF1D00000E00000053746F696369
      736D2051756F746501001500000051756F7465732061626F75742053746F6963
      69736D02000000000003000400000074727565040007000000756E6B6E6F776E
      05003900000068747470733A2F2F6769746875622E636F6D2F746C6368656168
      322F73746F69632D71756F74652D6C616D6264612D7075626C69632D61706906
      000B000000506572736F6E616C697479FEFEFF1B1C00F0030000FF1D00001300
      000054686579205361696420536F2051756F74657301003600000051756F7465
      732054727573746564206279206D616E7920666F7274756E65206272616E6473
      2061726F756E642074686520776F726C64020000000000030004000000747275
      65040007000000756E6B6E6F776E05001B00000068747470733A2F2F74686579
      73616964736F2E636F6D2F6170692F06000B000000506572736F6E616C697479
      FEFEFF1B1C00F1030000FF1D0000080000005472616974696679010027000000
      4173736573732C20636F6C6C65637420616E6420616E616C797A652050657273
      6F6E616C69747902000000000003000400000074727565040007000000756E6B
      6E6F776E05002200000068747470733A2F2F6170702E74726169746966792E63
      6F6D2F646576656C6F70657206000B000000506572736F6E616C697479FEFEFF
      1B1C00F2030000FF1D0000110000005564656D7928696E7374727563746F7229
      01001C00000041504920666F7220696E7374727563746F7273206F6E20556465
      6D790200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05002C00000068747470733A2F2F7777772E7564656D792E636F6D
      2F646576656C6F706572732F696E7374727563746F722F06000B000000506572
      736F6E616C697479FEFEFF1B1C00F3030000FF1D000013000000566164697665
      6C75204854545020436F6465730100200000004F6E2064656D616E6420485454
      5020436F646573207769746820696D6167657302000000000003000400000074
      7275650400020000006E6F05001C00000068747470733A2F2F7661646976656C
      752E616E6F72616D2E636F6D2F06000B000000506572736F6E616C697479FEFE
      FF1B1C00F4030000FF1D00000A0000005A656E2051756F74657301002E000000
      4C6172676520636F6C6C656374696F6E206F66205A656E2071756F7465732066
      6F7220696E737069726174696F6E020000000000030004000000747275650400
      0300000079657305001500000068747470733A2F2F7A656E71756F7465732E69
      6F2F06000B000000506572736F6E616C697479FEFEFF1B1C00F5030000FF1D00
      001900000041627374726163742050686F6E652056616C69646174696F6E0100
      1F00000056616C69646174652070686F6E65206E756D6265727320676C6F6261
      6C6C790200060000006170694B65790300040000007472756504000300000079
      657305003000000068747470733A2F2F7777772E61627374726163746170692E
      636F6D2F70686F6E652D76616C69646174696F6E2D6170690600050000005068
      6F6E65FEFEFF1B1C00F6030000FF1D0000120000006170696C61796572206E75
      6D76657269667901001700000050686F6E65206E756D6265722076616C696461
      74696F6E0200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001500000068747470733A2F2F6E756D7665726966792E63
      6F6D06000500000050686F6E65FEFEFF1B1C00F7030000FF1D00001500000043
      6C6F75646D6572736976652056616C696461746501002400000056616C696461
      746520696E7465726E6174696F6E616C2070686F6E65206E756D626572730200
      060000006170694B657903000400000074727565040003000000796573050034
      00000068747470733A2F2F636C6F75646D6572736976652E636F6D2F70686F6E
      652D6E756D6265722D76616C69646174696F6E2D41504906000500000050686F
      6E65FEFEFF1B1C00F8030000FF1D00001300000050686F6E6520537065636966
      69636174696F6E010021000000526573742041706920666F722050686F6E6520
      73706563696669636174696F6E73020000000000030004000000747275650400
      0300000079657305002B00000068747470733A2F2F6769746875622E636F6D2F
      617A686172696D6D2F70686F6E652D73706563732D6170690600050000005068
      6F6E65FEFEFF1B1C00F9030000FF1D0000090000005665726970686F6E650100
      2800000050686F6E65206E756D6265722076616C69646174696F6E2026206361
      7272696572206C6F6F6B75700200060000006170694B65790300040000007472
      756504000300000079657305001400000068747470733A2F2F7665726970686F
      6E652E696F06000500000050686F6E65FEFEFF1B1C00FA030000FF1D00001800
      00006170696C617965722073637265656E73686F746C6179657201000B000000
      55524C203220496D616765020000000000030004000000747275650400070000
      00756E6B6E6F776E05001B00000068747470733A2F2F73637265656E73686F74
      6C617965722E636F6D06000B00000050686F746F677261706879FEFEFF1B1C00
      FB030000FF1D00000E00000041504954656D706C6174652E696F010045000000
      44796E616D6963616C6C792067656E657261746520696D6167657320616E6420
      504446732066726F6D2074656D706C61746573207769746820612073696D706C
      65204150490200060000006170694B6579030004000000747275650400030000
      0079657305001600000068747470733A2F2F61706974656D706C6174652E696F
      06000B00000050686F746F677261706879FEFEFF1B1C00FC030000FF1D000005
      0000004272757A75010022000000496D6167652067656E65726174696F6E2077
      69746820717565727920737472696E670200060000006170694B657903000400
      00007472756504000300000079657305001600000068747470733A2F2F646F63
      732E6272757A752E636F6D06000B00000050686F746F677261706879FEFEFF1B
      1C00FD030000FF1D000008000000436865657461684F01001D00000050686F74
      6F206F7074696D697A6174696F6E20616E6420726573697A6502000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05002A00
      000068747470733A2F2F636865657461686F2E636F6D2F646F63732F67657474
      696E672D737461727465642F06000B00000050686F746F677261706879FEFEFF
      1B1C00FE030000FF1D0000050000004461677069010021000000496D61676520
      6D616E6970756C6174696F6E20616E642070726F63657373696E670200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1100000068747470733A2F2F64616770692E78797A06000B00000050686F746F
      677261706879FEFEFF1B1C00FF030000FF1D0000050000004475706C79010043
      00000047656E65726174652C20456469742C205363616C6520616E64204D616E
      61676520496D6167657320616E6420566964656F7320536D6172746572202620
      4661737465720200060000006170694B65790300040000007472756504000300
      000079657305002900000068747470733A2F2F6475706C792E636F2F646F6373
      2367657474696E672D737461727465642D61706906000B00000050686F746F67
      7261706879FEFEFF1B1C0000040000FF1D00000C00000044796E615069637475
      72657301003300000047656E65726174652048756E6472656473206F66205065
      72736F6E616C697A656420496D6167657320696E204D696E7574657302000600
      00006170694B65790300040000007472756504000300000079657305001E0000
      0068747470733A2F2F64796E6170696374757265732E636F6D2F646F63732F06
      000B00000050686F746F677261706879FEFEFF1B1C0001040000FF1D00000600
      0000466C69636B7201000F000000466C69636B72205365727669636573020005
      0000004F4175746803000400000074727565040007000000756E6B6E6F776E05
      002400000068747470733A2F2F7777772E666C69636B722E636F6D2F73657276
      696365732F6170692F06000B00000050686F746F677261706879FEFEFF1B1C00
      02040000FF1D00000C000000476574747920496D6167657301003A0000004275
      696C64206170706C69636174696F6E73207573696E672074686520776F726C64
      2773206D6F737420706F77657266756C20696D61676572790200050000004F41
      75746803000400000074727565040007000000756E6B6E6F776E050025000000
      687474703A2F2F646576656C6F706572732E6765747479696D616765732E636F
      6D2F656E2F06000B00000050686F746F677261706879FEFEFF1B1C0003040000
      FF1D00000600000047667963617401000C0000004A6966666965722047494673
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05002200000068747470733A2F2F646576656C6F706572732E6766796361
      742E636F6D2F6170692F06000B00000050686F746F677261706879FEFEFF1B1C
      0004040000FF1D000005000000476970687901001100000047657420616C6C20
      796F757220676966730200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05002200000068747470733A2F2F646576656C6F
      706572732E67697068792E636F6D2F646F63732F06000B00000050686F746F67
      7261706879FEFEFF1B1C0005040000FF1D00000D000000476F6F676C65205068
      6F746F73010031000000496E7465677261746520476F6F676C652050686F746F
      73207769746820796F75722061707073206F7220646576696365730200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050024
      00000068747470733A2F2F646576656C6F706572732E676F6F676C652E636F6D
      2F70686F746F7306000B00000050686F746F677261706879FEFEFF1B1C000604
      0000FF1D00000C000000496D6167652055706C6F6164010012000000496D6167
      65204F7074696D697A6174696F6E0200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05003100000068747470733A2F2F61
      70696C617965722E636F6D2F6D61726B6574706C6163652F696D6167655F7570
      6C6F61642D61706906000B00000050686F746F677261706879FEFEFF1B1C0007
      040000FF1D000005000000496D677572010006000000496D6167657302000500
      00004F4175746803000400000074727565040007000000756E6B6E6F776E0500
      1A00000068747470733A2F2F617069646F63732E696D6775722E636F6D2F0600
      0B00000050686F746F677261706879FEFEFF1B1C0008040000FF1D0000050000
      00496D7365610100110000004672656520696D61676520736561726368020000
      00000003000400000074727565040007000000756E6B6E6F776E05001C000000
      68747470733A2F2F696D7365612E6865726F6B756170702E636F6D2F06000B00
      000050686F746F677261706879FEFEFF1B1C0009040000FF1D00000C0000004C
      6F72656D2050696373756D010014000000496D616765732066726F6D20556E73
      706C61736802000000000003000400000074727565040007000000756E6B6E6F
      776E05001600000068747470733A2F2F70696373756D2E70686F746F732F0600
      0B00000050686F746F677261706879FEFEFF1B1C000A040000FF1D0000090000
      004F626A656374437574010018000000496D616765204261636B67726F756E64
      2072656D6F76616C0200060000006170694B6579030004000000747275650400
      0300000079657305001600000068747470733A2F2F6F626A6563746375742E63
      6F6D2F06000B00000050686F746F677261706879FEFEFF1B1C000B040000FF1D
      000006000000506578656C7301001C000000467265652053746F636B2050686F
      746F7320616E6420566964656F730200060000006170694B6579030004000000
      7472756504000300000079657305001B00000068747470733A2F2F7777772E70
      6578656C732E636F6D2F6170692F06000B00000050686F746F677261706879FE
      FEFF1B1C000C040000FF1D00000900000050686F746F526F6F6D01001D000000
      52656D6F7665206261636B67726F756E642066726F6D20696D61676573020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05001E00000068747470733A2F2F7777772E70686F746F726F6F6D2E636F6D2F
      6170692F06000B00000050686F746F677261706879FEFEFF1B1C000D040000FF
      1D0000070000005069786162617901000B00000050686F746F67726170687902
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002900000068747470733A2F2F706978616261792E636F6D2F736B2F73
      6572766963652F61626F75742F6170692F06000B00000050686F746F67726170
      6879FEFEFF1B1C000E040000FF1D00000A000000506C6163654B65616E750100
      50000000526573697A61626C65204B65616E752052656576657320706C616365
      686F6C64657220696D61676573207769746820677261797363616C6520616E64
      20796F756E67204B65616E75206F7074696F6E73020000000000030004000000
      74727565040007000000756E6B6E6F776E05001700000068747470733A2F2F70
      6C6163656B65616E752E636F6D2F06000B00000050686F746F677261706879FE
      FEFF1B1C000F040000FF1D000011000000526561646D6520747970696E672053
      5647010029000000437573746F6D697A61626C6520747970696E6720616E6420
      64656C6574696E67207465787420535647020000000000030004000000747275
      65040007000000756E6B6E6F776E05003100000068747470733A2F2F67697468
      75622E636F6D2F44656E766572436F646572312F726561646D652D747970696E
      672D73766706000B00000050686F746F677261706879FEFEFF1B1C0010040000
      FF1D00000900000052656D6F76652E6267010018000000496D61676520426163
      6B67726F756E642072656D6F76616C0200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001900000068747470733A2F2F
      7777772E72656D6F76652E62672F61706906000B00000050686F746F67726170
      6879FEFEFF1B1C0011040000FF1D00000A0000005265536D7573682E69740100
      1200000050686F746F206F7074696D697A6174696F6E02000000000003000500
      000066616C7365040007000000756E6B6E6F776E05001600000068747470733A
      2F2F7265736D7573682E69742F61706906000B00000050686F746F6772617068
      79FEFEFF1B1C0012040000FF1D00000C0000007368757474657273746F636B01
      001700000053746F636B2050686F746F7320616E6420566964656F7302000500
      00004F4175746803000400000074727565040007000000756E6B6E6F776E0500
      2700000068747470733A2F2F6170692D7265666572656E63652E736875747465
      7273746F636B2E636F6D2F06000B00000050686F746F677261706879FEFEFF1B
      1C0013040000FF1D00000400000053697276010043000000496D616765206D61
      6E6167656D656E7420736F6C7574696F6E73206C696B65206F7074696D697A61
      74696F6E2C206D616E6970756C6174696F6E2C20686F7374696E670200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1900000068747470733A2F2F617069646F63732E736972762E636F6D2F06000B
      00000050686F746F677261706879FEFEFF1B1C0014040000FF1D000008000000
      556E73706C61736801000B00000050686F746F6772617068790200050000004F
      4175746803000400000074727565040007000000756E6B6E6F776E05001F0000
      0068747470733A2F2F756E73706C6173682E636F6D2F646576656C6F70657273
      06000B00000050686F746F677261706879FEFEFF1B1C0015040000FF1D000009
      00000057616C6C686176656E01000A00000057616C6C70617065727302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001D00000068747470733A2F2F77616C6C686176656E2E63632F68656C702F61
      706906000B00000050686F746F677261706879FEFEFF1B1C0016040000FF1D00
      000600000057656264616D010006000000496D616765730200050000004F4175
      746803000400000074727565040007000000756E6B6E6F776E05003F00000068
      747470733A2F2F7777772E64616D737563636573732E636F6D2F68632F656E2D
      75732F61727469636C65732F3230323133343035352D524553542D4150490600
      0B00000050686F746F677261706879FEFEFF1B1C0017040000FF1D00000A0000
      00436F6465666F7263657301001D0000004765742061636365737320746F2043
      6F6465666F7263657320646174610200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05001E00000068747470733A2F2F63
      6F6465666F726365732E636F6D2F61706948656C7006000B00000050726F6772
      616D6D696E67FEFEFF1B1C0018040000FF1D00000B0000004861636B65726561
      727468010033000000466F7220636F6D70696C696E6720616E642072756E6E69
      6E6720636F646520696E207365766572616C206C616E67756167657302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      003400000068747470733A2F2F7777772E6861636B657265617274682E636F6D
      2F646F63732F77696B692F646576656C6F706572732F76342F06000B00000050
      726F6772616D6D696E67FEFEFF1B1C0019040000FF1D0000090000004A756467
      653020434501001C0000004F6E6C696E6520636F646520657865637574696F6E
      2073797374656D0200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001600000068747470733A2F2F63652E6A75646765
      302E636F6D2F06000B00000050726F6772616D6D696E67FEFEFF1B1C001A0400
      00FF1D0000080000004B4F4E5445535453010034000000466F72207570636F6D
      696E6720616E64206F6E676F696E6720636F6D706574697469766520636F6469
      6E6720636F6E7465737473020000000000030004000000747275650400070000
      00756E6B6E6F776E05001800000068747470733A2F2F6B6F6E74657374732E6E
      65742F61706906000B00000050726F6772616D6D696E67FEFEFF1B1C001B0400
      00FF1D0000080000004D696E746C696679010036000000466F722070726F6772
      616D6D61746963616C6C792067656E65726174696E6720646F63756D656E7461
      74696F6E20666F7220636F64650200060000006170694B657903000400000074
      72756504000300000079657305001900000068747470733A2F2F646F63732E6D
      696E746C6966792E636F6D06000B00000050726F6772616D6D696E67FEFEFF1B
      1C001C040000FF1D00000C0000006172637365636F6E642E696F01001F000000
      4D756C7469706C6520617374726F6E6F6D79206461746120736F757263657302
      000000000003000400000074727565040007000000756E6B6E6F776E05001900
      000068747470733A2F2F6170692E6172637365636F6E642E696F2F06000E0000
      00536369656E63652026204D617468FEFEFF1B1C001D040000FF1D0000050000
      00617258697601005C000000437572617465642072657365617263682D736861
      72696E6720706C6174666F726D3A20706879736963732C206D617468656D6174
      6963732C207175616E74697461746976652066696E616E63652C20616E642065
      636F6E6F6D69637302000000000003000400000074727565040007000000756E
      6B6E6F776E05002600000068747470733A2F2F61727869762E6F72672F68656C
      702F6170692F757365722D6D616E75616C06000E000000536369656E63652026
      204D617468FEFEFF1B1C001E040000FF1D000004000000434F524501002E0000
      004163636573732074686520776F726C642773204F70656E2041636365737320
      7265736561726368207061706572730200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001F00000068747470733A2F2F
      636F72652E61632E756B2F73657276696365732361706906000E000000536369
      656E63652026204D617468FEFEFF1B1C001F040000FF1D000004000000474249
      46010028000000476C6F62616C2042696F64697665727369747920496E666F72
      6D6174696F6E20466163696C6974790200000000000300040000007472756504
      000300000079657305002600000068747470733A2F2F7777772E676269662E6F
      72672F646576656C6F7065722F73756D6D61727906000E000000536369656E63
      652026204D617468FEFEFF1B1C0020040000FF1D000007000000694469674269
      6F010047000000416363657373206D696C6C696F6E73206F66206D757365756D
      2073706563696D656E732066726F6D206F7267616E697A6174696F6E73206172
      6F756E642074686520776F726C64020000000000030004000000747275650400
      07000000756E6B6E6F776E05003200000068747470733A2F2F6769746875622E
      636F6D2F6964696762696F2F6964696762696F2D7365617263682D6170692F77
      696B6906000E000000536369656E63652026204D617468FEFEFF1B1C00210400
      00FF1D00000E000000696E73706972656865702E6E6574010020000000486967
      6820456E65726779205068797369637320696E666F2E2073797374656D020000
      00000003000400000074727565040007000000756E6B6E6F776E05002A000000
      68747470733A2F2F6769746875622E636F6D2F696E73706972656865702F7265
      73742D6170692D646F6306000E000000536369656E63652026204D617468FEFE
      FF1B1C0022040000FF1D00000E00000069734576656E202868756D6F72290100
      19000000436865636B2069662061206E756D626572206973206576656E020000
      00000003000400000074727565040007000000756E6B6E6F776E050016000000
      68747470733A2F2F69736576656E6170692E78797A2F06000E00000053636965
      6E63652026204D617468FEFEFF1B1C0023040000FF1D0000040000004953524F
      01001D0000004953524F2053706163652043726166747320496E666F726D6174
      696F6E020000000000030004000000747275650400020000006E6F0500170000
      0068747470733A2F2F6973726F2E76657263656C2E61707006000E0000005363
      69656E63652026204D617468FEFEFF1B1C0024040000FF1D0000040000004954
      4953010027000000496E7465677261746564205461786F6E6F6D696320496E66
      6F726D6174696F6E2053797374656D0200000000000300040000007472756504
      0007000000756E6B6E6F776E05002800000068747470733A2F2F7777772E6974
      69732E676F762F77735F6465736372697074696F6E2E68746D6C06000E000000
      536369656E63652026204D617468FEFEFF1B1C0025040000FF1D000010000000
      4C61756E6368204C69627261727920320100280000005370616365666C696768
      74206C61756E6368657320616E64206576656E74732064617461626173650200
      000000000300040000007472756504000300000079657305001E000000687474
      70733A2F2F7468657370616365646576732E636F6D2F6C6C61706906000E0000
      00536369656E63652026204D617468FEFEFF1B1C0026040000FF1D0000230000
      004D6174657269616C7320506C6174666F726D20666F72204461746120536369
      656E636501002F00000043757261746564206578706572696D656E74616C2064
      61746120666F72206D6174657269616C7320736369656E636502000600000061
      70694B6579030004000000747275650400020000006E6F05000F000000687474
      70733A2F2F6D7064732E696F06000E000000536369656E63652026204D617468
      FEFEFF1B1C0027040000FF1D0000130000004D696E6F7220506C616E65742043
      656E7465720100180000004173746572616E6B2E636F6D20496E666F726D6174
      696F6E02000000000003000500000066616C7365040007000000756E6B6E6F77
      6E05001B000000687474703A2F2F7777772E6173746572616E6B2E636F6D2F6D
      706306000E000000536369656E63652026204D617468FEFEFF1B1C0028040000
      FF1D0000040000004E41534101001C0000004E41534120646174612C20696E63
      6C7564696E6720696D6167657279020000000000030004000000747275650400
      020000006E6F05001400000068747470733A2F2F6170692E6E6173612E676F76
      06000E000000536369656E63652026204D617468FEFEFF1B1C0029040000FF1D
      0000080000004E4153412041445301001D0000004E41534120417374726F7068
      797369637320446174612053797374656D0200050000004F4175746803000400
      00007472756504000300000079657305003400000068747470733A2F2F75692E
      6164736162732E686172766172642E6564752F68656C702F6170692F6170692D
      646F63732E68746D6C06000E000000536369656E63652026204D617468FEFEFF
      1B1C002A040000FF1D0000060000004E6577746F6E01002700000053796D626F
      6C696320616E642041726974686D65746963204D6174682043616C63756C6174
      6F72020000000000030004000000747275650400020000006E6F050019000000
      68747470733A2F2F6E6577746F6E2E76657263656C2E61707006000E00000053
      6369656E63652026204D617468FEFEFF1B1C002B040000FF1D0000060000004E
      6F6374756101002A0000005245535420415049207573656420746F2061636365
      7373204E6F63747561536B792066656174757265730200000000000300040000
      0074727565040007000000756E6B6E6F776E05002C00000068747470733A2F2F
      6170692E6E6F63747561736B792E636F6D2F6170692F76312F73776167676572
      646F632F06000E000000536369656E63652026204D617468FEFEFF1B1C002C04
      0000FF1D0000070000004E756D6265727301005C0000004E756D626572206F66
      20746865206461792C2072616E646F6D206E756D6265722C206E756D62657220
      666163747320616E6420616E797468696E6720656C736520796F752077616E74
      20746F20646F2077697468206E756D626572730200060000006170694B657903
      0004000000747275650400020000006E6F05001F00000068747470733A2F2F6D
      6174682E746F6F6C732F6170692F6E756D626572732F06000E00000053636965
      6E63652026204D617468FEFEFF1B1C002D040000FF1D0000070000004E756D62
      65727301001300000046616374732061626F7574206E756D6265727302000000
      000003000500000066616C73650400020000006E6F050015000000687474703A
      2F2F6E756D626572736170692E636F6D06000E000000536369656E6365202620
      4D617468FEFEFF1B1C002E040000FF1D00000B0000004F6365616E2046616374
      730100380000004661637473207065727461696E696E6720746F207468652070
      6879736963616C20736369656E6365206F66204F6365616E6F67726170687902
      000000000003000400000074727565040007000000756E6B6E6F776E05002100
      000068747470733A2F2F6F6365616E66616374732E6865726F6B756170702E63
      6F6D2F06000E000000536369656E63652026204D617468FEFEFF1B1C002F0400
      00FF1D00000B0000004F70656E204E6F74696679010025000000495353206173
      74726F6E617574732C2063757272656E74206C6F636174696F6E2C2065746302
      000000000003000500000066616C73650400020000006E6F0500270000006874
      74703A2F2F6F70656E2D6E6F746966792E6F72672F4F70656E2D4E6F74696679
      2D4150492F06000E000000536369656E63652026204D617468FEFEFF1B1C0030
      040000FF1D0000160000004F70656E20536369656E6365204672616D65776F72
      6B0100540000005265706F7369746F727920616E64206172636869766520666F
      722073747564792064657369676E732C207265736561726368206D6174657269
      616C732C20646174612C206D616E75736372697074732C206574630200000000
      0003000400000074727565040007000000756E6B6E6F776E0500180000006874
      7470733A2F2F646576656C6F7065722E6F73662E696F06000E00000053636965
      6E63652026204D617468FEFEFF1B1C0031040000FF1D00000A00000050757270
      6C65204169720100200000005265616C2054696D6520416972205175616C6974
      79204D6F6E69746F72696E670200000000000300040000007472756504000700
      0000756E6B6E6F776E05001B00000068747470733A2F2F777777322E70757270
      6C656169722E636F6D2F06000E000000536369656E63652026204D617468FEFE
      FF1B1C0032040000FF1D00000B00000052656D6F74652043616C630100550000
      004465636F6465732062617365363420656E636F64696E6720616E6420706172
      73657320697420746F2072657475726E206120736F6C7574696F6E20746F2074
      68652063616C63756C6174696F6E20696E204A534F4E02000000000003000400
      00007472756504000300000079657305002F00000068747470733A2F2F676974
      6875622E636F6D2F656C697A61626574686164656762616A752F72656D6F7465
      63616C6306000E000000536369656E63652026204D617468FEFEFF1B1C003304
      0000FF1D000005000000534841524501003D0000004120667265652C206F7065
      6E2C20646174617365742061626F757420726573656172636820616E64207363
      686F6C61726C7920616374697669746965730200000000000300040000007472
      75650400020000006E6F05001C00000068747470733A2F2F73686172652E6F73
      662E696F2F6170692F76322F06000E000000536369656E63652026204D617468
      FEFEFF1B1C0034040000FF1D00000600000053706163655801002B000000436F
      6D70616E792C2076656869636C652C206C61756E636870616420616E64206C61
      756E63682064617461020000000000030004000000747275650400020000006E
      6F05002600000068747470733A2F2F6769746875622E636F6D2F722D73706163
      65782F5370616365582D41504906000E000000536369656E63652026204D6174
      68FEFEFF1B1C0035040000FF1D00000600000053706163655801003200000047
      72617068514C2C20436F6D70616E792C2053686970732C206C61756E63687061
      6420616E64206C61756E63682064617461020000000000030004000000747275
      65040007000000756E6B6E6F776E05002000000068747470733A2F2F6170692E
      7370616365782E6C616E642F6772617068716C2F06000E000000536369656E63
      652026204D617468FEFEFF1B1C0036040000FF1D00001200000053756E726973
      6520616E642053756E73657401003B00000053756E73657420616E642073756E
      726973652074696D657320666F72206120676976656E206C6174697475646520
      616E64206C6F6E67697475646502000000000003000400000074727565040002
      0000006E6F05001E00000068747470733A2F2F73756E726973652D73756E7365
      742E6F72672F61706906000E000000536369656E63652026204D617468FEFEFF
      1B1C0037040000FF1D00000B00000054696D657320416464657201004A000000
      5769746820746869732041504920796F752063616E206164642065616368206F
      66207468652074696D657320696E74726F647563656420696E20746865206172
      7261792073656E64656402000000000003000400000074727565040002000000
      6E6F05002D00000068747470733A2F2F6769746875622E636F6D2F4672616E50
      2D636F64652F4150492D54696D65732D416464657206000E000000536369656E
      63652026204D617468FEFEFF1B1C0038040000FF1D000003000000544C450100
      15000000536174656C6C69746520696E666F726D6174696F6E02000000000003
      0004000000747275650400020000006E6F05002400000068747470733A2F2F74
      6C652E6976616E7374616E6F6A657669632E6D652F232F646F637306000E0000
      00536369656E63652026204D617468FEFEFF1B1C0039040000FF1D00001F0000
      00555347532045617274687175616B652048617A617264732050726F6772616D
      01001A00000045617274687175616B65732064617461207265616C2D74696D65
      020000000000030004000000747275650400020000006E6F05002B0000006874
      7470733A2F2F65617274687175616B652E757367732E676F762F6664736E7773
      2F6576656E742F312F06000E000000536369656E63652026204D617468FEFEFF
      1B1C003A040000FF1D0000130000005553475320576174657220536572766963
      65730100310000005761746572207175616C69747920616E64206C6576656C20
      696E666F20666F722072697665727320616E64206C616B657302000000000003
      0004000000747275650400020000006E6F05001F00000068747470733A2F2F77
      6174657273657276696365732E757367732E676F762F06000E00000053636965
      6E63652026204D617468FEFEFF1B1C003B040000FF1D00000A000000576F726C
      642042616E6B01000A000000576F726C64204461746102000000000003000400
      0000747275650400020000006E6F05003E00000068747470733A2F2F64617461
      68656C706465736B2E776F726C6462616E6B2E6F72672F6B6E6F776C65646765
      626173652F746F706963732F31323535383906000E000000536369656E636520
      26204D617468FEFEFF1B1C003C040000FF1D000005000000784D61746801001F
      00000052616E646F6D206D617468656D61746963616C2065787072657373696F
      6E730200000000000300040000007472756504000300000079657305001D0000
      0068747470733A2F2F782D6D6174682E6865726F6B756170702E636F6D2F0600
      0E000000536369656E63652026204D617468FEFEFF1B1C003D040000FF1D0000
      240000004170706C69636174696F6E20456E7669726F6E6D656E742056657269
      6669636174696F6E010063000000416E64726F6964206C69627261727920616E
      642041504920746F207665726966792074686520736166657479206F66207573
      657220646576696365732C2064657465637420726F6F74656420646576696365
      7320616E64206F74686572207269736B730200060000006170694B6579030004
      0000007472756504000300000079657305002400000068747470733A2F2F6769
      746875622E636F6D2F66696E6765727072696E746A732F616576060008000000
      5365637572697479FEFEFF1B1C003E040000FF1D00000A00000042696E617279
      4564676501003300000050726F766964652061636365737320746F2042696E61
      7279456467652034306679207363616E6E696E6720706C6174666F726D020006
      0000006170694B65790300040000007472756504000300000079657305002600
      000068747470733A2F2F646F63732E62696E617279656467652E696F2F617069
      2D76322E68746D6C0600080000005365637572697479FEFEFF1B1C003F040000
      FF1D00000900000042697457617264656E01002100000042657374206F70656E
      2D736F757263652070617373776F7264206D616E616765720200050000004F41
      75746803000400000074727565040007000000756E6B6E6F776E05001F000000
      68747470733A2F2F62697477617264656E2E636F6D2F68656C702F6170692F06
      00080000005365637572697479FEFEFF1B1C0040040000FF1D00000400000042
      6F7464010036000000426F746420697320612062726F77736572206C69627261
      727920666F72204A61766153637269707420626F7420646574656374696F6E02
      00060000006170694B6579030004000000747275650400030000007965730500
      2500000068747470733A2F2F6769746875622E636F6D2F66696E676572707269
      6E746A732F626F74640600080000005365637572697479FEFEFF1B1C00410400
      00FF1D00000800000042756763726F776401004E00000042756763726F776420
      41504920666F7220696E746572616374696E6720616E6420747261636B696E67
      20746865207265706F72746564206973737565732070726F6772616D6D617469
      63616C6C790200060000006170694B6579030004000000747275650400070000
      00756E6B6E6F776E05002E00000068747470733A2F2F646F63732E6275676372
      6F77642E636F6D2F6170692F67657474696E672D737461727465642F06000800
      00005365637572697479FEFEFF1B1C0042040000FF1D00000600000043656E73
      797301003500000053656172636820656E67696E6520666F7220496E7465726E
      657420636F6E6E656374656420686F737420616E642064657669636573020006
      0000006170694B6579030004000000747275650400020000006E6F05001C0000
      0068747470733A2F2F7365617263682E63656E7379732E696F2F617069060008
      0000005365637572697479FEFEFF1B1C0043040000FF1D000008000000436C61
      7373696679010025000000456E6372797074696E672026206465637279707469
      6E672074657874206D6573736167657302000000000003000400000074727565
      04000300000079657305002800000068747470733A2F2F636C6173736966792D
      7765622E6865726F6B756170702E636F6D2F232F617069060008000000536563
      7572697479FEFEFF1B1C0044040000FF1D000018000000436F6D706C65746520
      4372696D696E616C20436865636B7301003F00000050726F7669646573206461
      7461206F66206F6666656E646572732066726F6D20616C6C20552E532E205374
      6174657320616E642050757265746F205269636F0200060000006170694B6579
      0300040000007472756504000300000079657305002D00000068747470733A2F
      2F636F6D706C6574656372696D696E616C636865636B732E636F6D2F44657665
      6C6F706572730600080000005365637572697479FEFEFF1B1C0045040000FF1D
      00000A00000043525863617661746F7201001D0000004368726F6D6520657874
      656E73696F6E207269736B2073636F72696E670200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05001D00000068747470
      733A2F2F63727863617661746F722E696F2F617069646F637306000800000053
      65637572697479FEFEFF1B1C0046040000FF1D0000090000004465686173682E
      6C74010037000000486173682064656372797074696F6E204D44352C20534841
      312C20534841332C205348413235362C205348413338342C2053484135313202
      000000000003000400000074727565040007000000756E6B6E6F776E05002000
      000068747470733A2F2F6769746875622E636F6D2F4465686173682D6C742F61
      70690600080000005365637572697479FEFEFF1B1C0047040000FF1D00000800
      0000456D61696C526570010028000000456D61696C2061646472657373207468
      7265617420616E64207269736B2070726564696374696F6E0200000000000300
      0400000074727565040007000000756E6B6E6F776E0500190000006874747073
      3A2F2F646F63732E656D61696C7265702E696F2F060008000000536563757269
      7479FEFEFF1B1C0048040000FF1D00000600000045736361706501002D000000
      416E2041504920666F72206573636170696E6720646966666572656E74206B69
      6E64206F66207175657269657302000000000003000400000074727565040002
      0000006E6F05002A00000068747470733A2F2F6769746875622E636F6D2F706F
      6C617273706574726F6C6C2F4573636170654150490600080000005365637572
      697479FEFEFF1B1C0049040000FF1D00000B00000046696C7465724C69737473
      01002D0000004C69737473206F662066696C7465727320666F72206164626C6F
      636B65727320616E64206669726577616C6C7302000000000003000400000074
      727565040007000000756E6B6E6F776E05001700000068747470733A2F2F6669
      6C7465726C697374732E636F6D0600080000005365637572697479FEFEFF1B1C
      004A040000FF1D00001100000046696E6765727072696E744A532050726F0100
      43000000467261756420646574656374696F6E20415049206F66666572696E67
      20686967686C792061636375726174652062726F777365722066696E67657270
      72696E74696E670200060000006170694B657903000400000074727565040003
      00000079657305002200000068747470733A2F2F6465762E66696E6765727072
      696E746A732E636F6D2F646F63730600080000005365637572697479FEFEFF1B
      1C004B040000FF1D00000D00000046726175644C6162732050726F0100320000
      0053637265656E206F7264657220696E666F726D6174696F6E207573696E6720
      414920746F20646574656374206672617564730200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05003700000068747470
      733A2F2F7777772E66726175646C61627370726F2E636F6D2F646576656C6F70
      65722F6170692F73637265656E2D6F7264657206000800000053656375726974
      79FEFEFF1B1C004C040000FF1D00000800000046756C6C48756E740100390000
      0053656172636861626C652061747461636B2073757266616365206461746162
      617365206F662074686520656E7469726520696E7465726E6574020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E05002A
      00000068747470733A2F2F6170692D646F63732E66756C6C68756E742E696F2F
      23696E74726F64756374696F6E0600080000005365637572697479FEFEFF1B1C
      004D040000FF1D00000B000000476974477561726469616E0100370000005363
      616E2066696C657320666F7220736563726574732028415049204B6579732C20
      64617461626173652063726564656E7469616C73290200060000006170694B65
      79030004000000747275650400020000006E6F05001F00000068747470733A2F
      2F6170692E676974677561726469616E2E636F6D2F646F630600080000005365
      637572697479FEFEFF1B1C004E040000FF1D000009000000477265794E6F6973
      6501005400000051756572792049507320696E2074686520477265794E6F6973
      65206461746173657420616E6420726574726965766520612073756273657420
      6F66207468652066756C6C20495020636F6E7465787420646174610200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      3700000068747470733A2F2F646F63732E677265796E6F6973652E696F2F7265
      666572656E63652F6765745F76332D636F6D6D756E6974792D69700600080000
      005365637572697479FEFEFF1B1C004F040000FF1D0000090000004861636B65
      724F6E6501006600000054686520696E647573747279E2809973206669727374
      206861636B65722041504920746861742068656C707320696E63726561736520
      70726F64756374697669747920746F7761726473206372656174697665206275
      6720626F756E74792068756E74696E670200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001A00000068747470733A2F
      2F6170692E6861636B65726F6E652E636F6D2F06000800000053656375726974
      79FEFEFF1B1C0050040000FF1D0000080000004861736861626C650100430000
      004120524553542041504920746F206163636573732068696768206C6576656C
      2063727970746F677261706869632066756E6374696F6E7320616E64206D6574
      686F647302000000000003000400000074727565040003000000796573050021
      00000068747470733A2F2F6861736861626C652E73706163652F70616765732F
      6170692F0600080000005365637572697479FEFEFF1B1C0051040000FF1D0000
      0E00000048617665494265656E50776E656401003D00000050617373776F7264
      7320776869636820686176652070726576696F75736C79206265656E20657870
      6F73656420696E20646174612062726561636865730200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500210000006874
      7470733A2F2F68617665696265656E70776E65642E636F6D2F4150492F763306
      00080000005365637572697479FEFEFF1B1C0052040000FF1D00000E00000049
      6E74656C6C6967656E63652058010020000000506572666F726D204F53494E54
      2076696120496E74656C6C6967656E636520580200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05004B00000068747470
      733A2F2F6769746875622E636F6D2F496E74656C6C6967656E6365582F53444B
      2F626C6F622F6D61737465722F496E74656C6C6967656E636525323058253230
      4150492E7064660600080000005365637572697479FEFEFF1B1C0053040000FF
      1D00000B0000004C6F67696E5261646975730100230000004D616E6167656420
      557365722041757468656E7469636174696F6E20536572766963650200060000
      006170694B657903000400000074727565040003000000796573050021000000
      68747470733A2F2F7777772E6C6F67696E7261646975732E636F6D2F646F6373
      2F0600080000005365637572697479FEFEFF1B1C0054040000FF1D0000290000
      004D6963726F736F667420536563757269747920526573706F6E73652043656E
      74657220284D5352432901005400000050726F6772616D6D6174696320696E74
      6572666163657320746F20656E67616765207769746820746865204D6963726F
      736F667420536563757269747920526573706F6E73652043656E74657220284D
      5352432902000000000003000400000074727565040007000000756E6B6E6F77
      6E05002B00000068747470733A2F2F6D7372632E6D6963726F736F66742E636F
      6D2F7265706F72742F646576656C6F7065720600080000005365637572697479
      FEFEFF1B1C0055040000FF1D0000140000004D6F7A696C6C6120687474702073
      63616E6E65720100200000004D6F7A696C6C61206F627365727661746F727920
      68747470207363616E6E65720200000000000300040000007472756504000700
      0000756E6B6E6F776E05004B00000068747470733A2F2F6769746875622E636F
      6D2F6D6F7A696C6C612F687474702D6F627365727661746F72792F626C6F622F
      6D61737465722F687474706F62732F646F63732F6170692E6D64060008000000
      5365637572697479FEFEFF1B1C0056040000FF1D0000130000004D6F7A696C6C
      6120746C73207363616E6E657201001F0000004D6F7A696C6C61206F62736572
      7661746F727920746C73207363616E6E65720200000000000300040000007472
      7565040007000000756E6B6E6F776E05003800000068747470733A2F2F676974
      6875622E636F6D2F6D6F7A696C6C612F746C732D6F627365727661746F727923
      6170692D656E64706F696E74730600080000005365637572697479FEFEFF1B1C
      0057040000FF1D00001F0000004E6174696F6E616C2056756C6E65726162696C
      697479204461746162617365010024000000552E532E204E6174696F6E616C20
      56756C6E65726162696C69747920446174616261736502000000000003000400
      000074727565040007000000756E6B6E6F776E05003800000068747470733A2F
      2F6E76642E6E6973742E676F762F76756C6E2F446174612D46656564732F4A53
      4F4E2D666565642D6368616E67656C6F670600080000005365637572697479FE
      FEFF1B1C0058040000FF1D00000E00000050617373776F7264696E61746F7201
      003100000047656E65726174652072616E646F6D2070617373776F726473206F
      662076617279696E6720636F6D706C6578697469657302000000000003000400
      00007472756504000300000079657305003200000068747470733A2F2F676974
      6875622E636F6D2F666177617A73756C6C69612F70617373776F72642D67656E
      657261746F722F0600080000005365637572697479FEFEFF1B1C0059040000FF
      1D00000A000000506869736853746174730100110000005068697368696E6720
      646174616261736502000000000003000400000074727565040007000000756E
      6B6E6F776E05001800000068747470733A2F2F706869736873746174732E696E
      666F2F0600080000005365637572697479FEFEFF1B1C005A040000FF1D00000B
      000000507269766163792E636F6D01005B00000047656E6572617465206D6572
      6368616E742D737065636966696320616E64206F6E652D74696D652075736520
      6372656469742063617264206E756D626572732074686174206C696E6B206261
      636B20746F20796F75722062616E6B0200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05002200000068747470733A2F2F
      707269766163792E636F6D2F646576656C6F7065722F646F6373060008000000
      5365637572697479FEFEFF1B1C005B040000FF1D00000900000050756C736564
      69766501003E0000005363616E2C2073656172636820616E6420636F6C6C6563
      742074687265617420696E74656C6C6967656E6365206461746120696E207265
      616C2D74696D650200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001A00000068747470733A2F2F70756C7365646976
      652E636F6D2F6170692F0600080000005365637572697479FEFEFF1B1C005C04
      0000FF1D00000E0000005365637572697479547261696C73010056000000446F
      6D61696E20616E642049502072656C6174656420696E666F726D6174696F6E20
      737563682061732063757272656E7420616E6420686973746F726963616C2057
      484F495320616E6420444E53207265636F7264730200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E050027000000687474
      70733A2F2F7365637572697479747261696C732E636F6D2F636F72702F617069
      646F63730600080000005365637572697479FEFEFF1B1C005D040000FF1D0000
      0600000053686F64616E01002C00000053656172636820656E67696E6520666F
      7220496E7465726E657420636F6E6E6563746564206465766963657302000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      001C00000068747470733A2F2F646576656C6F7065722E73686F64616E2E696F
      2F0600080000005365637572697479FEFEFF1B1C005E040000FF1D0000050000
      00537079736501005C0000004163636573732064617461206F6E20616C6C2049
      6E7465726E65742061737365747320616E64206275696C6420706F7765726675
      6C2061747461636B2073757266616365206D616E6167656D656E74206170706C
      69636174696F6E730200060000006170694B6579030004000000747275650400
      07000000756E6B6E6F776E05003100000068747470733A2F2F73707973652D64
      65762E726561646D652E696F2F7265666572656E63652F717569636B2D737461
      72740600080000005365637572697479FEFEFF1B1C005F040000FF1D00000D00
      0000546872656174204A616D6D657201003A0000005269736B2073636F72696E
      6720736572766963652066726F6D20637572617465642074687265617420696E
      74656C6C6967656E636520646174610200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05002300000068747470733A2F2F
      7468726561746A616D6D65722E636F6D2F646F63732F696E6465780600080000
      005365637572697479FEFEFF1B1C0060040000FF1D000009000000554B20506F
      6C69636501000E000000554B20506F6C69636520646174610200000000000300
      0400000074727565040007000000756E6B6E6F776E05001C0000006874747073
      3A2F2F646174612E706F6C6963652E756B2F646F63732F060008000000536563
      7572697479FEFEFF1B1C0061040000FF1D000008000000566972757368656501
      001B00000056697275736865652066696C652F64617461207363616E6E696E67
      0200000000000300040000007472756504000300000079657305001900000068
      747470733A2F2F6170692E76697275736865652E636F6D2F0600080000005365
      637572697479FEFEFF1B1C0062040000FF1D00000500000056756C4442010058
      00000056756C44422041504920616C6C6F777320746F20696E69746961746520
      7175657269657320666F72206F6E65206F72206D6F7265206974656D7320616C
      6F6E672077697468207472616E73616374696F6E616C20626F74730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1A00000068747470733A2F2F76756C64622E636F6D2F3F646F632E6170690600
      080000005365637572697479FEFEFF1B1C0063040000FF1D0000080000004265
      73742042757901004A00000050726F64756374732C20427579696E67204F7074
      696F6E732C2043617465676F726965732C205265636F6D6D656E646174696F6E
      732C2053746F72657320616E6420436F6D6D657263650200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05003900000068
      747470733A2F2F62657374627579617069732E6769746875622E696F2F617069
      2D646F63756D656E746174696F6E2F236F766572766965770600080000005368
      6F7070696E67FEFEFF1B1C0064040000FF1D000008000000446967692D4B6579
      01004D000000526574726965766520707269636520616E6420696E76656E746F
      7279206F6620656C656374726F6E696320636F6D706F6E656E74732061732077
      656C6C20617320706C616365206F72646572730200050000004F417574680300
      0400000074727565040007000000756E6B6E6F776E0500320000006874747073
      3A2F2F7777772E646967696B65792E636F6D2F656E2F7265736F75726365732F
      6170692D736F6C7574696F6E7306000800000053686F7070696E67FEFEFF1B1C
      0065040000FF1D00000E00000044756D6D792050726F647563747301004B0000
      00416E2061706920746F2066657463682064756D6D7920652D636F6D6D657263
      652070726F6475637473204A534F4E2064617461207769746820706C61636568
      6F6C64657220696D616765730200060000006170694B65790300040000007472
      756504000300000079657305002800000068747470733A2F2F64756D6D797072
      6F64756374732D6170692E6865726F6B756170702E636F6D2F06000800000053
      686F7070696E67FEFEFF1B1C0066040000FF1D00000400000065426179010014
      00000053656C6C20616E6420427579206F6E20654261790200050000004F4175
      746803000400000074727565040007000000756E6B6E6F776E05001B00000068
      747470733A2F2F646576656C6F7065722E656261792E636F6D2F060008000000
      53686F7070696E67FEFEFF1B1C0067040000FF1D000004000000457473790100
      260000004D616E6167652073686F7020616E6420696E74657261637420776974
      68206C697374696E67730200050000004F417574680300040000007472756504
      0007000000756E6B6E6F776E05004800000068747470733A2F2F7777772E6574
      73792E636F6D2F646576656C6F706572732F646F63756D656E746174696F6E2F
      67657474696E675F737461727465642F6170695F626173696373060008000000
      53686F7070696E67FEFEFF1B1C0068040000FF1D000014000000466C69706B61
      7274204D61726B6574706C61636501004800000050726F64756374206C697374
      696E67206D616E6167656D656E742C204F726465722046756C66696C6D656E74
      20696E2074686520466C69706B617274204D61726B6574706C61636502000500
      00004F4175746803000400000074727565040003000000796573050030000000
      68747470733A2F2F73656C6C65722E666C69706B6172742E636F6D2F6170692D
      646F63732F464D534150492E68746D6C06000800000053686F7070696E67FEFE
      FF1B1C0069040000FF1D0000060000004C617A61646101003700000052657472
      696576652070726F6475637420726174696E677320616E642073656C6C657220
      706572666F726D616E6365206D6574726963730200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05002300000068747470
      733A2F2F6F70656E2E6C617A6164612E636F6D2F646F632F646F632E68746D06
      000800000053686F7070696E67FEFEFF1B1C006A040000FF1D00000C0000004D
      65726361646F6C6962726501002F0000004D616E6167652073616C65732C2061
      64732C2070726F64756374732C20736572766963657320616E642053686F7073
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05003400000068747470733A2F2F646576656C6F706572732E6D657263
      61646F6C696272652E636C2F65735F61722F6170692D646F63732D6573060008
      00000053686F7070696E67FEFEFF1B1C006B040000FF1D0000080000004F6374
      6F7061727401003C000000456C656374726F6E69632070617274206461746120
      666F72206D616E75666163747572696E672C2064657369676E2C20616E642073
      6F757263696E670200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05002500000068747470733A2F2F6F63746F70617274
      2E636F6D2F6170692F76342F7265666572656E636506000800000053686F7070
      696E67FEFEFF1B1C006C040000FF1D00000A0000004F4C5820506F6C616E6401
      0058000000496E746567726174652077697468206C6F63616C20736974657320
      627920706F7374696E672C206D616E6167696E67206164766572747320616E64
      20636F6D6D756E69636174696E672077697468204F4C58207573657273020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002900000068747470733A2F2F646576656C6F7065722E6F6C782E706C2F61
      70692F646F632373656374696F6E2F06000800000053686F7070696E67FEFEFF
      1B1C006D040000FF1D000005000000526170706901001E0000004D616E616765
      206F72646572732066726F6D2052617070692773206170700200050000004F41
      75746803000400000074727565040007000000756E6B6E6F776E05001D000000
      68747470733A2F2F6465762D706F7274616C2E72617070692E636F6D2F060008
      00000053686F7070696E67FEFEFF1B1C006E040000FF1D00000600000053686F
      70656501004500000053686F7065652773206F6666696369616C204150492066
      6F7220696E746567726174696F6E206F6620766172696F757320736572766963
      65732066726F6D2053686F7065650200060000006170694B6579030004000000
      74727565040007000000756E6B6E6F776E05002B00000068747470733A2F2F6F
      70656E2E73686F7065652E636F6D2F646F63756D656E74733F76657273696F6E
      3D3106000800000053686F7070696E67FEFEFF1B1C006F040000FF1D00000900
      0000546F6B6F706564696101004B000000546F6B6F70656469612773204F6666
      696369616C2041504920666F7220696E746567726174696F6E206F6620766172
      696F75732073657276696365732066726F6D20546F6B6F706564696102000500
      00004F4175746803000400000074727565040007000000756E6B6E6F776E0500
      3000000068747470733A2F2F646576656C6F7065722E746F6B6F70656469612E
      636F6D2F6F70656E6170692F67756964652F232F06000800000053686F707069
      6E67FEFEFF1B1C0070040000FF1D00000B000000576F6F436F6D6D6572636501
      0062000000576F6F436F6D6D657263652052455354204150495320746F206372
      656174652C20726561642C207570646174652C20616E642064656C6574652064
      617461206F6E20776F72647072657373207765627369746520696E204A534F4E
      20666F726D61740200060000006170694B657903000400000074727565040003
      00000079657305003800000068747470733A2F2F776F6F636F6D6D657263652E
      6769746875622E696F2F776F6F636F6D6D657263652D726573742D6170692D64
      6F63732F06000800000053686F7070696E67FEFEFF1B1C0071040000FF1D0000
      05000000346368616E01004200000053696D706C6520696D6167652D62617365
      642062756C6C6574696E20626F6172642064656469636174656420746F206120
      76617269657479206F6620746F70696373020000000000030004000000747275
      6504000300000079657305002200000068747470733A2F2F6769746875622E63
      6F6D2F346368616E2F346368616E2D415049060006000000536F6369616CFEFE
      FF1B1C0072040000FF1D0000080000004179727368617265010059000000536F
      6369616C206D65646961204150497320746F20706F73742C2067657420616E61
      6C79746963732C20616E64206D616E616765206D756C7469706C652075736572
      7320736F6369616C206D65646961206163636F756E7473020006000000617069
      4B65790300040000007472756504000300000079657305001800000068747470
      733A2F2F7777772E61797273686172652E636F6D060006000000536F6369616C
      FEFEFF1B1C0073040000FF1D000005000000617A74726F010037000000446169
      6C7920686F726F73636F706520696E666F20666F72207965737465726461792C
      20746F6461792C20616E6420746F6D6F72726F77020000000000030004000000
      74727565040007000000756E6B6E6F776E05002200000068747470733A2F2F61
      7A74726F2E73616D6565726B756D61722E776562736974652F06000600000053
      6F6369616CFEFEFF1B1C0074040000FF1D000007000000426C6F676765720100
      4E00000054686520426C6F67676572204150497320616C6C6F777320636C6965
      6E74206170706C69636174696F6E7320746F207669657720616E642075706461
      746520426C6F6767657220636F6E74656E740200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05002600000068747470733A
      2F2F646576656C6F706572732E676F6F676C652E636F6D2F626C6F676765722F
      060006000000536F6369616CFEFEFF1B1C0075040000FF1D00000B0000004369
      73636F20537061726B01001B0000005465616D20436F6C6C61626F726174696F
      6E20536F6674776172650200050000004F417574680300040000007472756504
      0007000000756E6B6E6F776E05002000000068747470733A2F2F646576656C6F
      7065722E636973636F737061726B2E636F6D060006000000536F6369616CFEFE
      FF1B1C0076040000FF1D00001A00000044616E6765726F757320446973636F72
      642044617461626173650100260000004461746162617365206F66206D616C69
      63696F757320446973636F7264206163636F756E74730200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05002E00000068
      747470733A2F2F646973636F72642E7269766572736964652E726F636B732F64
      6F63732F696E6465782E706870060006000000536F6369616CFEFEFF1B1C0077
      040000FF1D000007000000446973636F72640100420000004D616B6520626F74
      7320666F7220446973636F72642C20696E7465677261746520446973636F7264
      206F6E746F20616E2065787465726E616C20706C6174666F726D020005000000
      4F4175746803000400000074727565040007000000756E6B6E6F776E05002900
      000068747470733A2F2F646973636F72642E636F6D2F646576656C6F70657273
      2F646F63732F696E74726F060006000000536F6369616CFEFEFF1B1C00780400
      00FF1D00000600000044697371757301001C000000436F6D6D756E6963617465
      20776974682044697371757320646174610200050000004F4175746803000400
      000074727565040007000000756E6B6E6F776E05002100000068747470733A2F
      2F6469737175732E636F6D2F6170692F646F63732F617574682F060006000000
      536F6369616CFEFEFF1B1C0079040000FF1D000009000000446F67652D4D656D
      65010039000000546F70206D656D6520706F7374732066726F6D20722F646F67
      65636F696E20776869636820696E636C75646520274D656D652720666C616972
      0200000000000300040000007472756504000300000079657305001E00000068
      747470733A2F2F6170692E646F67652D6D656D652E6C6F6C2F646F6373060006
      000000536F6369616CFEFEFF1B1C007A040000FF1D0000080000004661636562
      6F6F6B01003F00000046616365626F6F6B204C6F67696E2C205368617265206F
      6E2046422C20536F6369616C20506C7567696E732C20416E616C797469637320
      616E64206D6F72650200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05002000000068747470733A2F2F646576656C6F7065
      72732E66616365626F6F6B2E636F6D2F060006000000536F6369616CFEFEFF1B
      1C007B040000FF1D00000A000000466F7572737175617265010061000000496E
      746572616374207769746820466F757273717561726520757365727320616E64
      20706C61636573202867656F6C6F636174696F6E2D626173656420636865636B
      696E732C2070686F746F732C20746970732C206576656E74732C206574632902
      00050000004F4175746803000400000074727565040007000000756E6B6E6F77
      6E05002100000068747470733A2F2F646576656C6F7065722E666F7572737175
      6172652E636F6D2F060006000000536F6369616CFEFEFF1B1C007C040000FF1D
      0000150000004675636B204F6666206173206120536572766963650100180000
      0041736B7320736F6D656F6E6520746F206675636B206F666602000000000003
      000400000074727565040007000000756E6B6E6F776E05001500000068747470
      733A2F2F7777772E666F6161732E636F6D060006000000536F6369616CFEFEFF
      1B1C007D040000FF1D00000C00000046756C6C20436F6E746163740100310000
      0047657420536F6369616C204D656469612070726F66696C657320616E642063
      6F6E7461637420496E666F726D6174696F6E0200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05001D00000068747470733A
      2F2F646F63732E66756C6C636F6E746163742E636F6D2F060006000000536F63
      69616CFEFEFF1B1C007E040000FF1D00000A0000004861636B65724E65777301
      0027000000536F6369616C206E65777320666F7220435320616E6420656E7472
      657072656E657572736869700200000000000300040000007472756504000700
      0000756E6B6E6F776E05002100000068747470733A2F2F6769746875622E636F
      6D2F4861636B65724E6577732F415049060006000000536F6369616CFEFEFF1B
      1C007F040000FF1D000008000000486173686E6F64650100280000004120626C
      6F6767696E6720706C6174666F726D206275696C7420666F7220646576656C6F
      7065727302000000000003000400000074727565040007000000756E6B6E6F77
      6E05001400000068747470733A2F2F686173686E6F64652E636F6D0600060000
      00536F6369616CFEFEFF1B1C0080040000FF1D000009000000496E7374616772
      616D01003C000000496E7374616772616D204C6F67696E2C205368617265206F
      6E20496E7374616772616D2C20536F6369616C20506C7567696E7320616E6420
      6D6F72650200050000004F417574680300040000007472756504000700000075
      6E6B6E6F776E05002400000068747470733A2F2F7777772E696E737461677261
      6D2E636F6D2F646576656C6F7065722F060006000000536F6369616CFEFEFF1B
      1C0081040000FF1D0000050000004B616B616F0100380000004B616B616F204C
      6F67696E2C205368617265206F6E204B616B616F54616C6B2C20536F6369616C
      20506C7567696E7320616E64206D6F72650200050000004F4175746803000400
      000074727565040007000000756E6B6E6F776E05001D00000068747470733A2F
      2F646576656C6F706572732E6B616B616F2E636F6D2F060006000000536F6369
      616CFEFEFF1B1C0082040000FF1D0000070000004C616E796172640100470000
      00526574726965766520796F75722070726573656E6365206F6E20446973636F
      7264207468726F75676820616E2048545450205245535420415049206F722057
      6562536F636B6574020000000000030004000000747275650400030000007965
      7305002200000068747470733A2F2F6769746875622E636F6D2F5068696E6561
      732F6C616E79617264060006000000536F6369616CFEFEFF1B1C0083040000FF
      1D0000040000004C696E650100320000004C696E65204C6F67696E2C20536861
      7265206F6E204C696E652C20536F6369616C20506C7567696E7320616E64206D
      6F72650200050000004F4175746803000400000074727565040007000000756E
      6B6E6F776E05001C00000068747470733A2F2F646576656C6F706572732E6C69
      6E652E62697A2F060006000000536F6369616CFEFEFF1B1C0084040000FF1D00
      00080000004C696E6B6564496E01003800000054686520666F756E646174696F
      6E206F6620616C6C206469676974616C20696E746567726174696F6E73207769
      7468204C696E6B6564496E0200050000004F4175746803000400000074727565
      040007000000756E6B6E6F776E05004300000068747470733A2F2F646F63732E
      6D6963726F736F66742E636F6D2F656E2D75732F6C696E6B6564696E2F3F636F
      6E746578743D6C696E6B6564696E2F636F6E74657874060006000000536F6369
      616CFEFEFF1B1C0085040000FF1D00000A0000004D65657475702E636F6D0100
      22000000446174612061626F7574204D6565747570732066726F6D204D656574
      75702E636F6D0200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05002000000068747470733A2F2F7777772E6D65657475
      702E636F6D2F6170692F6775696465060006000000536F6369616CFEFEFF1B1C
      0086040000FF1D00000F0000004D6963726F736F667420477261706801005600
      000041636365737320746865206461746120616E6420696E74656C6C6967656E
      636520696E204D6963726F736F6674203336352C2057696E646F77732031302C
      20616E6420456E7465727072697365204D6F62696C6974790200050000004F41
      75746803000400000074727565040007000000756E6B6E6F776E050033000000
      68747470733A2F2F646F63732E6D6963726F736F66742E636F6D2F656E2D7573
      2F67726170682F6170692F6F76657276696577060006000000536F6369616CFE
      FEFF1B1C0087040000FF1D0000050000004E415645520100340000004E415645
      52204C6F67696E2C205368617265206F6E204E415645522C20536F6369616C20
      506C7567696E7320616E64206D6F72650200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05002200000068747470733A2F2F
      646576656C6F706572732E6E617665722E636F6D2F6D61696E2F060006000000
      536F6369616CFEFEFF1B1C0088040000FF1D00000F0000004F70656E20436F6C
      6C656374697665010018000000476574204F70656E20436F6C6C656374697665
      206461746102000000000003000400000074727565040007000000756E6B6E6F
      776E05003300000068747470733A2F2F646F63732E6F70656E636F6C6C656374
      6976652E636F6D2F68656C702F646576656C6F706572732F6170690600060000
      00536F6369616CFEFEFF1B1C0089040000FF1D00000900000050696E74657265
      737401001C00000054686520776F726C64277320636174616C6F67206F662069
      646561730200050000004F417574680300040000007472756504000700000075
      6E6B6E6F776E05002100000068747470733A2F2F646576656C6F706572732E70
      696E7465726573742E636F6D2F060006000000536F6369616CFEFEFF1B1C008A
      040000FF1D00000C00000050726F647563742048756E7401001D000000546865
      2062657374206E65772070726F647563747320696E2074656368020005000000
      4F4175746803000400000074727565040007000000756E6B6E6F776E05002300
      000068747470733A2F2F6170692E70726F6475637468756E742E636F6D2F7632
      2F646F6373060006000000536F6369616CFEFEFF1B1C008B040000FF1D000006
      000000526564646974010018000000486F6D6570616765206F66207468652069
      6E7465726E65740200050000004F417574680300040000007472756504000700
      0000756E6B6E6F776E05001E00000068747470733A2F2F7777772E7265646469
      742E636F6D2F6465762F617069060006000000536F6369616CFEFEFF1B1C008C
      040000FF1D0000060000005265766F6C740100260000005265766F6C74206F70
      656E20736F7572636520446973636F726420616C7465726E6174697665020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002300000068747470733A2F2F646576656C6F706572732E7265766F6C742E
      636861742F6170692F060006000000536F6369616CFEFEFF1B1C008D040000FF
      1D0000060000005361696469740100180000004F70656E20536F757263652052
      656464697420436C6F6E650200050000004F4175746803000400000074727565
      040007000000756E6B6E6F776E05001E00000068747470733A2F2F7777772E73
      61696469742E6E65742F6465762F617069060006000000536F6369616CFEFEFF
      1B1C008E040000FF1D000005000000536C61636B0100160000005465616D2049
      6E7374616E74204D6573736167696E670200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05001600000068747470733A2F2F
      6170692E736C61636B2E636F6D2F060006000000536F6369616CFEFEFF1B1C00
      8F040000FF1D00000600000054616D54616D01001F000000426F742041504920
      746F20696E74657261637420776974682054616D54616D020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050018000000
      68747470733A2F2F6465762E74616D74616D2E636861742F060006000000536F
      6369616CFEFEFF1B1C0090040000FF1D00000C00000054656C656772616D2042
      6F7401003300000053696D706C696669656420485454502076657273696F6E20
      6F6620746865204D5450726F746F2041504920666F7220626F74730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      2200000068747470733A2F2F636F72652E74656C656772616D2E6F72672F626F
      74732F617069060006000000536F6369616CFEFEFF1B1C0091040000FF1D0000
      1000000054656C656772616D204D5450726F746F01001C000000526561642061
      6E642077726974652054656C656772616D20646174610200050000004F417574
      6803000400000074727565040007000000756E6B6E6F776E05002D0000006874
      7470733A2F2F636F72652E74656C656772616D2E6F72672F6170692367657474
      696E672D73746172746564060006000000536F6369616CFEFEFF1B1C00920400
      00FF1D00000900000054656C6567726170680100280000004372656174652061
      74747261637469766520626C6F677320656173696C792C20746F207368617265
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001600000068747470733A2F2F74656C656772612E70682F61706906
      0006000000536F6369616CFEFEFF1B1C0093040000FF1D00000600000054696B
      546F6B01003B00000046657463686573207573657220696E666F20616E642075
      736572277320766964656F20706F737473206F6E2054696B546F6B20706C6174
      666F726D0200050000004F417574680300040000007472756504000700000075
      6E6B6E6F776E05002F00000068747470733A2F2F646576656C6F706572732E74
      696B746F6B2E636F6D2F646F632F6C6F67696E2D6B69742D7765620600060000
      00536F6369616CFEFEFF1B1C0094040000FF1D00000D0000005472617368204E
      6F7468696E670100450000004120667265656379636C696E6720636F6D6D756E
      69747920776974682074686F7573616E6473206F662066726565206974656D73
      20706F73746564206576657279206461790200050000004F4175746803000400
      00007472756504000300000079657305002200000068747470733A2F2F747261
      73686E6F7468696E672E636F6D2F646576656C6F706572060006000000536F63
      69616CFEFEFF1B1C0095040000FF1D00000600000054756D626C7201001A0000
      005265616420616E642077726974652054756D626C7220446174610200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050025
      00000068747470733A2F2F7777772E74756D626C722E636F6D2F646F63732F65
      6E2F6170692F7632060006000000536F6369616CFEFEFF1B1C0096040000FF1D
      00000600000054776974636801001200000047616D652053747265616D696E67
      204150490200050000004F417574680300040000007472756504000700000075
      6E6B6E6F776E05001A00000068747470733A2F2F6465762E7477697463682E74
      762F646F6373060006000000536F6369616CFEFEFF1B1C0097040000FF1D0000
      070000005477697474657201001B0000005265616420616E6420777269746520
      5477697474657220646174610200050000004F41757468030004000000747275
      650400020000006E6F05002500000068747470733A2F2F646576656C6F706572
      2E747769747465722E636F6D2F656E2F646F6373060006000000536F6369616C
      FEFEFF1B1C0098040000FF1D000002000000766B010016000000526561642061
      6E6420777269746520766B20646174610200050000004F417574680300040000
      0074727565040007000000756E6B6E6F776E05001800000068747470733A2F2F
      766B2E636F6D2F6465762F7369746573060006000000536F6369616CFEFEFF1B
      1C0099040000FF1D00000C0000004150492D464F4F5442414C4C01002D000000
      47657420696E666F726D6174696F6E2061626F757420466F6F7462616C6C204C
      656167756573202620437570730200060000006170694B657903000400000074
      72756504000300000079657305002D00000068747470733A2F2F7777772E6170
      692D666F6F7462616C6C2E636F6D2F646F63756D656E746174696F6E2D763306
      001000000053706F7274732026204669746E657373FEFEFF1B1C009A040000FF
      1D0000080000004170694D656469630100440000004170694D65646963206F66
      666572732061206D65646963616C2073796D70746F6D20636865636B65722041
      5049207072696D6172696C7920666F722070617469656E747302000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001500
      000068747470733A2F2F6170696D656469632E636F6D2F06001000000053706F
      7274732026204669746E657373FEFEFF1B1C009B040000FF1D00000B00000062
      616C6C646F6E746C696501003600000042616C6C646F6E746C69652070726F76
      696465732061636365737320746F20737461747320646174612066726F6D2074
      6865204E42410200000000000300040000007472756504000300000079657305
      001A00000068747470733A2F2F7777772E62616C6C646F6E746C69652E696F06
      001000000053706F7274732026204669746E657373FEFEFF1B1C009C040000FF
      1D00001E00000043616E616469616E20466F6F7462616C6C204C656167756520
      2843464C290100560000004F6666696369616C204A534F4E204150492070726F
      766964696E67207265616C2D74696D65206C65616775652C207465616D20616E
      6420706C6179657220737461746973746963732061626F757420746865204346
      4C0200060000006170694B6579030004000000747275650400020000006E6F05
      0012000000687474703A2F2F6170692E63666C2E63612F06001000000053706F
      7274732026204669746E657373FEFEFF1B1C009D040000FF1D00000A00000043
      6974792042696B657301001B000000436974792042696B65732061726F756E64
      2074686520776F726C6402000000000003000400000074727565040007000000
      756E6B6E6F776E05001A00000068747470733A2F2F6170692E6369747962696B
      2E65732F76322F06001000000053706F7274732026204669746E657373FEFEFF
      1B1C009E040000FF1D000008000000436C6F75646265740100630000004F6666
      696369616C20436C6F7564626574204150492070726F7669646573207265616C
      2D74696D652073706F727473206F64647320616E642062657474696E67204150
      4920746F20706C61636520626574732070726F6772616D6D61746963616C6C79
      0200060000006170694B65790300040000007472756504000300000079657305
      001D00000068747470733A2F2F7777772E636C6F75646265742E636F6D2F6170
      692F06001000000053706F7274732026204669746E657373FEFEFF1B1C009F04
      0000FF1D000017000000436F6C6C656765466F6F7462616C6C446174612E636F
      6D010052000000556E6F6666696369616C2064657461696C656420416D657269
      63616E20636F6C6C65676520666F6F7462616C6C20737461746973746963732C
      207265636F7264732C20616E6420726573756C74732041504902000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001F00
      000068747470733A2F2F636F6C6C656765666F6F7462616C6C646174612E636F
      6D06001000000053706F7274732026204669746E657373FEFEFF1B1C00A00400
      00FF1D00000900000045726761737420463101003D0000004631206461746120
      66726F6D2074686520626567696E6E696E67206F662074686520776F726C6420
      6368616D70696F6E736869707320696E20313935300200000000000300040000
      0074727565040007000000756E6B6E6F776E050016000000687474703A2F2F65
      72676173742E636F6D2F6D72642F06001000000053706F727473202620466974
      6E657373FEFEFF1B1C00A1040000FF1D00000600000046697462697401001200
      000046697462697420496E666F726D6174696F6E0200050000004F4175746803
      000400000074727565040007000000756E6B6E6F776E05001700000068747470
      733A2F2F6465762E6669746269742E636F6D2F06001000000053706F72747320
      26204669746E657373FEFEFF1B1C00A2040000FF1D000008000000466F6F7462
      616C6C01004F000000412073696D706C65204F70656E20536F7572636520466F
      6F7462616C6C2041504920746F2067657420737175616473E280992073746174
      732C20626573742073636F7265727320616E64206D6F726502000D000000582D
      4D6173686170652D4B657903000400000074727565040007000000756E6B6E6F
      776E05003800000068747470733A2F2F72617069646170692E636F6D2F476975
      6C69616E6F4372657363696D62656E692F6170692F666F6F7462616C6C39382F
      06001000000053706F7274732026204669746E657373FEFEFF1B1C00A3040000
      FF1D000018000000466F6F7462616C6C2028536F636365722920566964656F73
      01005B000000456D62656420636F64657320666F7220676F616C7320616E6420
      686967686C69676874732066726F6D205072656D696572204C65616775652C20
      42756E6465736C6967612C205365726965204120616E64206D616E79206D6F72
      6502000000000003000400000074727565040003000000796573050023000000
      68747470733A2F2F7777772E73636F72656261742E636F6D2F766964656F2D61
      70692F06001000000053706F7274732026204669746E657373FEFEFF1B1C00A4
      040000FF1D000012000000466F6F7462616C6C205374616E64696E6773010058
      000000446973706C617920666F6F7462616C6C207374616E64696E677320652E
      672065706C2C206C61206C6967612C2073657269652061206574632E20546865
      2064617461206973206261736564206F6E206573706E20736974650200000000
      000300040000007472756504000300000079657305003200000068747470733A
      2F2F6769746875622E636F6D2F617A686172696D6D2F666F6F7462616C6C2D73
      74616E64696E67732D61706906001000000053706F7274732026204669746E65
      7373FEFEFF1B1C00A5040000FF1D00000D000000466F6F7462616C6C2D446174
      61010041000000466F6F7462616C6C20646174612077697468206D6174636865
      7320696E666F2C20706C61796572732C207465616D732C20616E6420636F6D70
      65746974696F6E7302000D000000582D4D6173686170652D4B65790300040000
      0074727565040007000000756E6B6E6F776E05001D00000068747470733A2F2F
      7777772E666F6F7462616C6C2D646174612E6F726706001000000053706F7274
      732026204669746E657373FEFEFF1B1C00A6040000FF1D00000D0000004A4344
      65636175782042696B650100200000004A4344656361757827732073656C662D
      736572766963652062696379636C65730200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001F00000068747470733A2F
      2F646576656C6F7065722E6A636465636175782E636F6D2F0600100000005370
      6F7274732026204669746E657373FEFEFF1B1C00A7040000FF1D000015000000
      4D4C42205265636F72647320616E642053746174730100250000004375727265
      6E7420616E6420686973746F726963616C204D4C422073746174697374696373
      02000000000003000500000066616C7365040007000000756E6B6E6F776E0500
      2A00000068747470733A2F2F61707061632E6769746875622E696F2F6D6C622D
      646174612D6170692D646F63732F06001000000053706F727473202620466974
      6E657373FEFEFF1B1C00A8040000FF1D0000080000004E424120446174610100
      3B000000416C6C204E424120537461747320444154412C2047616D65732C204C
      69766573636F72652C205374616E64696E67732C205374617469737469637302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05002C00000068747470733A2F2F72617069646170692E636F6D2F617069
      2D73706F7274732F6170692F6170692D6E62612F06001000000053706F727473
      2026204669746E657373FEFEFF1B1C00A9040000FF1D0000090000004E424120
      537461747301002500000043757272656E7420616E6420686973746F72696361
      6C204E4241205374617469737469637302000000000003000400000074727565
      040007000000756E6B6E6F776E05003800000068747470733A2F2F616E792D61
      70692E636F6D2F6E62615F636F6D2F6E62615F636F6D2F646F63732F4150495F
      4465736372697074696F6E06001000000053706F7274732026204669746E6573
      73FEFEFF1B1C00AA040000FF1D0000150000004E484C205265636F7264732061
      6E642053746174730100220000004E484C20686973746F726963616C20646174
      6120616E64207374617469737469637302000000000003000400000074727565
      040007000000756E6B6E6F776E05002000000068747470733A2F2F6769746C61
      622E636F6D2F64776F7264342F6E686C61706906001000000053706F72747320
      26204669746E657373FEFEFF1B1C00AB040000FF1D00000A0000004F6464736D
      61676E65740100280000004F64647320686973746F72792066726F6D206D756C
      7469706C6520554B20626F6F6B6D616B65727302000000000003000400000074
      72756504000300000079657305001B00000068747470733A2F2F646174612E6F
      6464736D61676E65742E636F6D06001000000053706F7274732026204669746E
      657373FEFEFF1B1C00AC040000FF1D00000A0000004F70656E4C696761444201
      002300000043726F776420736F75726365642073706F727473206C6561677565
      20726573756C7473020000000000030004000000747275650400030000007965
      7305001900000068747470733A2F2F7777772E6F70656E6C69676164622E6465
      06001000000053706F7274732026204669746E657373FEFEFF1B1C00AD040000
      FF1D0000190000005072656D696572204C6561677565205374616E64696E6773
      20010033000000416C6C2043757272656E74205072656D696572204C65616775
      65205374616E64696E677320616E642053746174697374696373020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E05003E
      00000068747470733A2F2F72617069646170692E636F6D2F68656973656E6275
      672F6170692F7072656D6965722D6C65616775652D6C6976652D73636F726573
      2F06001000000053706F7274732026204669746E657373FEFEFF1B1C00AE0400
      00FF1D00000A00000053706F727420446174610100270000004765742073706F
      72747320646174612066726F6D20616C6C206F7665722074686520776F726C64
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001800000068747470733A2F2F73706F7274646174616170692E636F
      6D06001000000053706F7274732026204669746E657373FEFEFF1B1C00AF0400
      00FF1D00001100000053706F7274204C69737420262044617461010027000000
      4C697374206F6620616E64207265736F75726365732072656C6174656420746F
      2073706F72747302000000000003000400000074727565040003000000796573
      05003000000068747470733A2F2F646576656C6F706572732E6465636174686C
      6F6E2E636F6D2F70726F64756374732F73706F72747306001000000053706F72
      74732026204669746E657373FEFEFF1B1C00B0040000FF1D00000C0000005370
      6F727420506C6163657301002B00000043726F77642D736F757263652073706F
      72747320706C616365732061726F756E642074686520776F726C640200000000
      00030004000000747275650400020000006E6F05003600000068747470733A2F
      2F646576656C6F706572732E6465636174686C6F6E2E636F6D2F70726F647563
      74732F73706F72742D706C6163657306001000000053706F7274732026204669
      746E657373FEFEFF1B1C00B1040000FF1D00000C00000053706F727420566973
      696F6E01004E0000004964656E746966792073706F72742C206272616E647320
      616E64206765617220696E20616E20696D6167652E20416C736F20646F657320
      696D6167652073706F7274732063617074696F6E696E67020006000000617069
      4B65790300040000007472756504000300000079657305003600000068747470
      733A2F2F646576656C6F706572732E6465636174686C6F6E2E636F6D2F70726F
      64756374732F73706F72742D766973696F6E06001000000053706F7274732026
      204669746E657373FEFEFF1B1C00B2040000FF1D00001200000053706F72746D
      6F6E6B7320437269636B65740100350000004C69766520637269636B65742073
      636F72652C20706C61796572207374617469737469637320616E642066616E74
      617379204150490200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05002400000068747470733A2F2F646F63732E73706F
      72746D6F6E6B732E636F6D2F637269636B65742F06001000000053706F727473
      2026204669746E657373FEFEFF1B1C00B3040000FF1D00001300000053706F72
      746D6F6E6B7320466F6F7462616C6C010062000000466F6F7462616C6C207363
      6F72652F7363686564756C652C206E657773206170692C207476206368616E6E
      656C732C2073746174732C20686973746F72792C20646973706C617920737461
      6E64696E6720652E672E2065706C2C206C61206C696761020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050025000000
      68747470733A2F2F646F63732E73706F72746D6F6E6B732E636F6D2F666F6F74
      62616C6C2F06001000000053706F7274732026204669746E657373FEFEFF1B1C
      00B4040000FF1D0000080000005371756967676C650100480000004669787475
      7265732C20726573756C747320616E642070726564696374696F6E7320666F72
      204175737472616C69616E20466F6F7462616C6C204C6561677565206D617463
      6865730200000000000300040000007472756504000300000079657305001B00
      000068747470733A2F2F6170692E7371756967676C652E636F6D2E6175060010
      00000053706F7274732026204669746E657373FEFEFF1B1C00B5040000FF1D00
      000600000053747261766101002A000000436F6E6E6563742077697468206174
      686C657465732C206163746976697469657320616E64206D6F72650200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E05001D
      00000068747470733A2F2F7374726176612E6769746875622E696F2F6170692F
      06001000000053706F7274732026204669746E657373FEFEFF1B1C00B6040000
      FF1D00000900000053757265644269747301004900000051756572792073706F
      72747320646174612C20696E636C7564696E67207465616D732C20706C617965
      72732C2067616D65732C2073636F72657320616E642073746174697374696373
      02000000000003000500000066616C73650400020000006E6F05001A00000068
      747470733A2F2F7375726564626974732E636F6D2F6170692F06001000000053
      706F7274732026204669746E657373FEFEFF1B1C00B7040000FF1D00000B0000
      0054686553706F727473444201002500000043726F77642D536F757263656420
      53706F727473204461746120616E6420417274776F726B020006000000617069
      4B65790300040000007472756504000300000079657305002300000068747470
      733A2F2F7777772E74686573706F72747364622E636F6D2F6170692E70687006
      001000000053706F7274732026204669746E657373FEFEFF1B1C00B8040000FF
      1D0000070000005472656469637401002C00000047657420616E642073657420
      616374697669746965732C206865616C7468206461746120616E64206D6F7265
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05002800000068747470733A2F2F7777772E747265646963742E636F6D2F
      626C6F672F6F617574685F646F63732F06001000000053706F72747320262046
      69746E657373FEFEFF1B1C00B9040000FF1D0000040000005767657201003700
      0000576F726B6F7574206D616E61676572206461746120617320657865726369
      7365732C206D7573636C6573206F722065717569706D656E7402000600000061
      70694B657903000400000074727565040007000000756E6B6E6F776E05001F00
      000068747470733A2F2F776765722E64652F656E2F736F6674776172652F6170
      6906001000000053706F7274732026204669746E657373FEFEFF1B1C00BA0400
      00FF1D00000B0000004261636F6E20497073756D01001F00000041204D656174
      696572204C6F72656D20497073756D2047656E657261746F7202000000000003
      000400000074727565040007000000756E6B6E6F776E05002000000068747470
      733A2F2F6261636F6E697073756D2E636F6D2F6A736F6E2D6170692F06000900
      0000546573742044617461FEFEFF1B1C00BB040000FF1D000010000000446963
      6562656172204176617461727301002100000047656E65726174652072616E64
      6F6D20706978656C2D6172742061766174617273020000000000030004000000
      747275650400020000006E6F05001D00000068747470733A2F2F617661746172
      732E64696365626561722E636F6D2F060009000000546573742044617461FEFE
      FF1B1C00BC040000FF1D000014000000456E676C6973682052616E646F6D2057
      6F72647301003000000047656E657261746520456E676C6973682052616E646F
      6D20576F72647320776974682050726F6E756E63696174696F6E020000000000
      030004000000747275650400020000006E6F05002800000068747470733A2F2F
      72616E646F6D2D776F7264732D6170692E76657263656C2E6170702F776F7264
      060009000000546573742044617461FEFEFF1B1C00BD040000FF1D0000080000
      0046616B654A534F4E0100260000005365727669636520746F2067656E657261
      7465207465737420616E642066616B6520646174610200060000006170694B65
      790300040000007472756504000300000079657305001400000068747470733A
      2F2F66616B656A736F6E2E636F6D060009000000546573742044617461FEFEFF
      1B1C00BE040000FF1D00000800000046616B6572415049010020000000415049
      7320636F6C6C656374696F6E20746F206765742066616B652064617461020000
      0000000300040000007472756504000300000079657305001600000068747470
      733A2F2F66616B65726170692E69742F656E0600090000005465737420446174
      61FEFEFF1B1C00BF040000FF1D00000C00000046616B6553746F726541504901
      004500000046616B652073746F726520726573742041504920666F7220796F75
      7220652D636F6D6D65726365206F722073686F7070696E672077656273697465
      2070726F746F7479706502000000000003000400000074727565040007000000
      756E6B6E6F776E05001900000068747470733A2F2F66616B6573746F72656170
      692E636F6D2F060009000000546573742044617461FEFEFF1B1C00C0040000FF
      1D00000C00000047656E657261646F72444E4901003C00000044617461206765
      6E657261746F72204150492E2050726F66696C65732C2076656869636C65732C
      2062616E6B7320616E642063617264732C206574630200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E05001B0000006874
      7470733A2F2F6170692E67656E657261646F72646E692E657306000900000054
      6573742044617461FEFEFF1B1C00C1040000FF1D00000E000000497473546869
      73466F725468617401001D00000047656E65726174652052616E646F6D207374
      6172747570206964656173020000000000030004000000747275650400020000
      006E6F05002200000068747470733A2F2F69747374686973666F72746861742E
      636F6D2F6170692E706870060009000000546573742044617461FEFEFF1B1C00
      C2040000FF1D00000F0000004A534F4E506C616365686F6C6465720100250000
      0046616B65206461746120666F722074657374696E6720616E642070726F746F
      747970696E6702000000000003000500000066616C7365040007000000756E6B
      6E6F776E050024000000687474703A2F2F6A736F6E706C616365686F6C646572
      2E74797069636F64652E636F6D2F060009000000546573742044617461FEFEFF
      1B1C00C3040000FF1D0000080000004C6F72697073756D01002D000000546865
      20226C6F72656D20697073756D222067656E657261746F72207468617420646F
      65736E2774207375636B02000000000003000500000066616C73650400070000
      00756E6B6E6F776E050014000000687474703A2F2F6C6F72697073756D2E6E65
      742F060009000000546573742044617461FEFEFF1B1C00C4040000FF1D000007
      0000004D61696C736163010010000000446973706F7361626C6520456D61696C
      0200060000006170694B657903000400000074727565040007000000756E6B6E
      6F776E05001C00000068747470733A2F2F6D61696C7361632E636F6D2F646F63
      732F617069060009000000546573742044617461FEFEFF1B1C00C5040000FF1D
      00000B0000004D65746170686F7273756D01003D00000047656E657261746520
      64656D6F207061726167726170687320676976696E67206E756D626572206F66
      20776F72647320616E642073656E74656E636573020000000000030005000000
      66616C7365040007000000756E6B6E6F776E050018000000687474703A2F2F6D
      65746170686F727073756D2E636F6D2F060009000000546573742044617461FE
      FEFF1B1C00C6040000FF1D0000080000004D6F636B61726F6F01003100000047
      656E65726174652066616B65206461746120746F204A534F4E2C204353562C20
      5458542C2053514C20616E6420584D4C0200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001D00000068747470733A2F
      2F7777772E6D6F636B61726F6F2E636F6D2F646F637306000900000054657374
      2044617461FEFEFF1B1C00C7040000FF1D00000B000000517569636B4D6F636B
      657201003C000000415049206D6F636B696E6720746F6F6C20746F2067656E65
      7261746520636F6E7465787475616C2C2066616B65206F722072616E646F6D20
      6461746102000000000003000400000074727565040003000000796573050017
      00000068747470733A2F2F717569636B6D6F636B65722E636F6D060009000000
      546573742044617461FEFEFF1B1C00C8040000FF1D00000B00000052616E646F
      6D204461746101001500000052616E646F6D20646174612067656E657261746F
      7202000000000003000400000074727565040007000000756E6B6E6F776E0500
      1B00000068747470733A2F2F72616E646F6D2D646174612D6170692E636F6D06
      0009000000546573742044617461FEFEFF1B1C00C9040000FF1D000009000000
      52616E646F6D6D657201001500000052616E646F6D20646174612067656E6572
      61746F720200060000006170694B657903000400000074727565040003000000
      79657305002200000068747470733A2F2F72616E646F6D6D65722E696F2F7261
      6E646F6D6D65722D617069060009000000546573742044617461FEFEFF1B1C00
      CA040000FF1D00000A00000052616E646F6D5573657201001C00000047656E65
      726174657320616E64206C697374207573657220646174610200000000000300
      0400000074727565040007000000756E6B6E6F776E0500150000006874747073
      3A2F2F72616E646F6D757365722E6D65060009000000546573742044617461FE
      FEFF1B1C00CB040000FF1D000008000000526F626F4861736801002300000047
      656E65726174652072616E646F6D20726F626F742F616C69656E206176617461
      727302000000000003000400000074727565040007000000756E6B6E6F776E05
      001500000068747470733A2F2F726F626F686173682E6F72672F060009000000
      546573742044617461FEFEFF1B1C00CC040000FF1D0000140000005370616E69
      73682072616E646F6D206E616D657301002D00000047656E6572617465207370
      616E697368206E616D65732028776974682067656E646572292072616E646F6D
      6C7902000000000003000400000074727565040007000000756E6B6E6F776E05
      002D00000068747470733A2F2F72616E646F6D2D6E616D65732D6170692E6865
      726F6B756170702E636F6D2F7075626C69630600090000005465737420446174
      61FEFEFF1B1C00CD040000FF1D0000140000005370616E6973682072616E646F
      6D20776F72647301001F00000047656E6572617465207370616E69736820776F
      7264732072616E646F6D6C790200000000000300040000007472756504000700
      0000756E6B6E6F776E05003400000068747470733A2F2F70616C61627261732D
      616C6561746F726961732D7075626C69632D6170692E6865726F6B756170702E
      636F6D060009000000546573742044617461FEFEFF1B1C00CE040000FF1D0000
      1A0000005468697320506572736F6E20446F6573206E6F742045786973740100
      3400000047656E657261746573207265616C2D6C696665206661636573206F66
      2070656F706C652077686F20646F206E6F742065786973740200000000000300
      0400000074727565040007000000756E6B6E6F776E0500220000006874747073
      3A2F2F74686973706572736F6E646F65736E6F7465786973742E636F6D060009
      000000546573742044617461FEFEFF1B1C00CF040000FF1D00000A000000546F
      6F6C636172746F6E01002000000047656E65726174652072616E646F6D207465
      7374696D6F6E69616C2064617461020000000000030004000000747275650400
      07000000756E6B6E6F776E05002600000068747470733A2F2F74657374696D6F
      6E69616C6170692E746F6F6C636172746F6E2E636F6D2F060009000000546573
      742044617461FEFEFF1B1C00D0040000FF1D00000E000000555549442047656E
      657261746F7201000E00000047656E6572617465205555494473020000000000
      030004000000747275650400020000006E6F05001E00000068747470733A2F2F
      7777772E75756964746F6F6C732E636F6D2F646F637306000900000054657374
      2044617461FEFEFF1B1C00D1040000FF1D00000F000000576861742054686520
      436F6D6D697401001F00000052616E646F6D20636F6D6D6974206D6573736167
      652067656E657261746F7202000000000003000500000066616C736504000300
      0000796573050022000000687474703A2F2F77686174746865636F6D6D69742E
      636F6D2F696E6465782E747874060009000000546573742044617461FEFEFF1B
      1C00D2040000FF1D000006000000596573204E6F01001B00000047656E657261
      746520796573206F72206E6F2072616E646F6D6C790200000000000300040000
      0074727565040007000000756E6B6E6F776E05001500000068747470733A2F2F
      7965736E6F2E7774662F617069060009000000546573742044617461FEFEFF1B
      1C00D3040000FF1D000012000000436F646520446574656374696F6E20415049
      01004E0000004465746563742C206C6162656C2C20666F726D617420616E6420
      656E726963682074686520636F646520696E20796F757220617070206F722069
      6E20796F7572206461746120706970656C696E650200050000004F4175746803
      000400000074727565040007000000756E6B6E6F776E05002400000068747470
      733A2F2F636F6465646574656374696F6E6170692E72756E74696D652E646576
      06000D0000005465787420416E616C79736973FEFEFF1B1C00D4040000FF1D00
      00160000006170696C61796572206C616E67756167656C617965720100340000
      004C616E677561676520446574656374696F6E204A534F4E2041504920737570
      706F7274696E6720313733206C616E6775616765730200050000004F41757468
      03000400000074727565040007000000756E6B6E6F776E05001A000000687474
      70733A2F2F6C616E67756167656C617965722E636F6D2F06000D000000546578
      7420416E616C79736973FEFEFF1B1C00D5040000FF1D00001400000041796C69
      656E205465787420416E616C7973697301003F0000004120636F6C6C65637469
      6F6E206F6620696E666F726D6174696F6E2072657472696576616C20616E6420
      6E61747572616C206C616E677561676520415049730200060000006170694B65
      7903000400000074727565040007000000756E6B6E6F776E0500300000006874
      7470733A2F2F646F63732E61796C69656E2E636F6D2F746578746170692F2367
      657474696E672D7374617274656406000D0000005465787420416E616C797369
      73FEFEFF1B1C00D6040000FF1D000028000000436C6F75646D65727369766520
      4E61747572616C204C616E67756167652050726F63657373696E6701002D0000
      004E61747572616C206C616E67756167652070726F63657373696E6720616E64
      207465787420616E616C797369730200060000006170694B6579030004000000
      7472756504000300000079657305002400000068747470733A2F2F7777772E63
      6C6F75646D6572736976652E636F6D2F6E6C702D61706906000D000000546578
      7420416E616C79736973FEFEFF1B1C00D7040000FF1D00000F00000044657465
      6374204C616E6775616765010015000000446574656374732074657874206C61
      6E67756167650200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001B00000068747470733A2F2F6465746563746C616E
      67756167652E636F6D2F06000D0000005465787420416E616C79736973FEFEFF
      1B1C00D8040000FF1D000003000000454C490100330000004E61747572616C20
      4C616E67756167652050726F63657373696E6720546F6F6C7320666F72205468
      6169204C616E67756167650200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05002600000068747470733A2F2F6E6C702E
      696E73696768746572612E636F2E74682F646F63732F76312E3006000D000000
      5465787420416E616C79736973FEFEFF1B1C00D9040000FF1D00001400000047
      6F6F676C6520436C6F7564204E61747572616C01005A0000004E61747572616C
      206C616E677561676520756E6465727374616E64696E6720746563686E6F6C6F
      67792C20696E636C7564696E672073656E74696D656E742C20656E7469747920
      616E642073796E74617820616E616C797369730200060000006170694B657903
      000400000074727565040007000000756E6B6E6F776E05002F00000068747470
      733A2F2F636C6F75642E676F6F676C652E636F6D2F6E61747572616C2D6C616E
      67756167652F646F63732F06000D0000005465787420416E616C79736973FEFE
      FF1B1C00DA040000FF1D000009000000486972616B204F435201006000000049
      6D61676520746F2074657874202D74657874207265636F676E6974696F6E2D20
      66726F6D20696D616765206D6F7265207468616E20313030206C616E67756167
      652C2061636375726174652C20756E6C696D6974656420726571756573747302
      00060000006170694B657903000400000074727565040007000000756E6B6E6F
      776E05001700000068747470733A2F2F6F63722E686972616B2E736974652F06
      000D0000005465787420416E616C79736973FEFEFF1B1C00DB040000FF1D0000
      11000000486972616B205472616E736C6174696F6E0100490000005472616E73
      6C617465206265747765656E203231206F66206D6F73742075736564206C616E
      6775616765732C2061636375726174652C20756E6C696D697465642072657175
      657374730200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001D00000068747470733A2F2F7472616E736C6174652E68
      6972616B2E736974652F06000D0000005465787420416E616C79736973FEFEFF
      1B1C00DC040000FF1D0000110000004C6563746F205472616E736C6174696F6E
      0100340000005472616E736C6174696F6E204150492077697468206672656520
      7469657220616E6420726561736F6E61626C6520707269636573020006000000
      6170694B65790300040000007472756504000300000079657305003F00000068
      747470733A2F2F72617069646170692E636F6D2F6C6563746F2D6C6563746F2D
      64656661756C742F6170692F6C6563746F2D7472616E736C6174696F6E2F0600
      0D0000005465787420416E616C79736973FEFEFF1B1C00DD040000FF1D00000E
      0000004C696272655472616E736C61746501002C0000005472616E736C617469
      6F6E20746F6F6C207769746820313720617661696C61626C65206C616E677561
      67657302000000000003000400000074727565040007000000756E6B6E6F776E
      05001F00000068747470733A2F2F6C696272657472616E736C6174652E636F6D
      2F646F637306000D0000005465787420416E616C79736973FEFEFF1B1C00DE04
      0000FF1D00000900000053656D616E747269610100500000005465787420416E
      616C797469637320776974682073656E74696D656E7420616E616C797369732C
      2063617465676F72697A6174696F6E2026206E616D656420656E746974792065
      787472616374696F6E0200050000004F41757468030004000000747275650400
      07000000756E6B6E6F776E05002000000068747470733A2F2F73656D616E7472
      69612E726561646D652E696F2F646F637306000D0000005465787420416E616C
      79736973FEFEFF1B1C00DF040000FF1D00001200000053656E74696D656E7420
      416E616C7973697301003F0000004D756C74696C696E6775616C2073656E7469
      6D656E7420616E616C79736973206F662074657874732066726F6D2064696666
      6572656E7420736F75726365730200060000006170694B657903000400000074
      72756504000300000079657305003900000068747470733A2F2F7777772E6D65
      616E696E67636C6F75642E636F6D2F646576656C6F7065722F73656E74696D65
      6E742D616E616C7973697306000D0000005465787420416E616C79736973FEFE
      FF1B1C00E0040000FF1D000006000000546973616E6501005A00000054657874
      20416E616C7974696373207769746820666F637573206F6E2064657465637469
      6F6E206F66206162757369766520636F6E74656E7420616E64206C617720656E
      666F7263656D656E74206170706C69636174696F6E730200050000004F417574
      680300040000007472756504000300000079657305001200000068747470733A
      2F2F746973616E652E61692F06000D0000005465787420416E616C79736973FE
      FEFF1B1C00E1040000FF1D000025000000576174736F6E204E61747572616C20
      4C616E677561676520556E6465727374616E64696E670100360000004E617475
      72616C206C616E67756167652070726F63657373696E6720666F722061647661
      6E636564207465787420616E616C797369730200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05005B00000068747470733A
      2F2F636C6F75642E69626D2E636F6D2F617069646F63732F6E61747572616C2D
      6C616E67756167652D756E6465727374616E64696E672F6E61747572616C2D6C
      616E67756167652D756E6465727374616E64696E6706000D0000005465787420
      416E616C79736973FEFEFF1B1C00E2040000FF1D000009000000416674657273
      68697001003400000041504920746F207570646174652C206D616E6167652061
      6E6420747261636B20736869706D656E7420656666696369656E746C79020006
      0000006170694B65790300040000007472756504000300000079657305003600
      000068747470733A2F2F646576656C6F706572732E6166746572736869702E63
      6F6D2F7265666572656E63652F717569636B2D73746172740600080000005472
      61636B696E67FEFEFF1B1C00E3040000FF1D000008000000436F727265696F73
      010051000000496E746567726174696F6E20746F2070726F7669646520696E66
      6F726D6174696F6E20616E64207072657061726520736869706D656E74732075
      73696E6720436F727265696F2773207365727669636573020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050021000000
      68747470733A2F2F6377732E636F727265696F732E636F6D2E62722F616A7564
      61060008000000547261636B696E67FEFEFF1B1C00E4040000FF1D0000060000
      00506978656C6101003900000041504920666F72207265636F7264696E672061
      6E6420747261636B696E6720686162697473206F72206566666F72742C20726F
      7574696E657302000D000000582D4D6173686170652D4B657903000400000074
      72756504000300000079657305000F00000068747470733A2F2F706978652E6C
      61060008000000547261636B696E67FEFEFF1B1C00E5040000FF1D00000D0000
      00506F7374616C50696E436F646501002800000041504920666F722067657474
      696E672050696E636F64652064657461696C7320696E20496E64696102000000
      000003000400000074727565040007000000756E6B6E6F776E05002700000068
      7474703A2F2F7777772E706F7374616C70696E636F64652E696E2F4170692D44
      657461696C73060008000000547261636B696E67FEFEFF1B1C00E6040000FF1D
      000007000000506F73746D6F6E010047000000416E2041504920746F20717565
      7279204272617A696C69616E205A495020636F64657320616E64206F72646572
      7320656173696C792C20717569636B6C7920616E642066726565020000000000
      03000500000066616C7365040007000000756E6B6E6F776E0500150000006874
      74703A2F2F706F73746D6F6E2E636F6D2E6272060008000000547261636B696E
      67FEFEFF1B1C00E7040000FF1D000008000000506F73744E6F72640100460000
      0050726F766964657320696E666F726D6174696F6E2061626F75742070617263
      656C7320696E207472616E73706F727420666F722053776564656E20616E6420
      44656E6D61726B0200060000006170694B657903000500000066616C73650400
      07000000756E6B6E6F776E05002200000068747470733A2F2F646576656C6F70
      65722E706F73746E6F72642E636F6D2F617069060008000000547261636B696E
      67FEFEFF1B1C00E8040000FF1D00000300000055505301002000000053686970
      6D656E7420616E64204164647265737320696E666F726D6174696F6E02000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      002300000068747470733A2F2F7777772E7570732E636F6D2F75707364657665
      6C6F7065726B6974060008000000547261636B696E67FEFEFF1B1C00E9040000
      FF1D00000A000000576543616E547261636B01005E0000004175746F6D617469
      63616C6C7920706C6163652073756269647320696E20616666696C6961746520
      6C696E6B7320746F2061747472696275746520616666696C6961746520636F6E
      76657273696F6E7320746F20636C69636B20646174610200060000006170694B
      65790300040000007472756504000300000079657305001B0000006874747073
      3A2F2F646F63732E776563616E747261636B2E636F6D06000800000054726163
      6B696E67FEFEFF1B1C00EA040000FF1D0000090000005768617450756C736501
      0039000000536D616C6C206170706C69636174696F6E2074686174206D656173
      7572657320796F7572206B6579626F6172642F6D6F7573652075736167650200
      0000000003000400000074727565040007000000756E6B6E6F776E0500280000
      0068747470733A2F2F646576656C6F7065722E7768617470756C73652E6F7267
      2F237765622D617069060008000000547261636B696E67FEFEFF1B1C00EB0400
      00FF1D00000E0000004144532D422045786368616E6765010045000000416363
      657373207265616C2D74696D6520616E6420686973746F726963616C20646174
      61206F6620616E7920616E6420616C6C20616972626F726E6520616972637261
      667402000000000003000400000074727565040007000000756E6B6E6F776E05
      002200000068747470733A2F2F7777772E6164736265786368616E67652E636F
      6D2F646174612F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C
      00EC040000FF1D00000B000000616972706F7274736170690100320000004765
      74206E616D6520616E6420776562736974652D55524C20666F7220616972706F
      727473206279204943414F20636F646502000000000003000400000074727565
      040007000000756E6B6E6F776E05002900000068747470733A2F2F616972706F
      72742D7765622E61707073706F742E636F6D2F6170692F646F63732F06000E00
      00005472616E73706F72746174696F6EFEFEFF1B1C00ED040000FF1D00000700
      0000414953204875620100500000005265616C2D74696D652064617461206F66
      20616E79206D6172696E6520616E6420696E6C616E642076657373656C206571
      75697070656420776974682041495320747261636B696E672073797374656D02
      00060000006170694B657903000500000066616C7365040007000000756E6B6E
      6F776E050019000000687474703A2F2F7777772E6169736875622E6E65742F61
      706906000E0000005472616E73706F72746174696F6EFEFEFF1B1C00EE040000
      FF1D000016000000416D616465757320666F7220446576656C6F706572730100
      1D00000054726176656C20536561726368202D204C696D697465642075736167
      650200050000004F4175746803000400000074727565040007000000756E6B6E
      6F776E05002B00000068747470733A2F2F646576656C6F706572732E616D6164
      6575732E636F6D2F73656C662D7365727669636506000E0000005472616E7370
      6F72746174696F6EFEFEFF1B1C00EF040000FF1D0000160000006170696C6179
      6572206176696174696F6E737461636B0100320000005265616C2D74696D6520
      466C6967687420537461747573202620476C6F62616C204176696174696F6E20
      44617461204150490200050000004F4175746803000400000074727565040007
      000000756E6B6E6F776E05001A00000068747470733A2F2F6176696174696F6E
      737461636B2E636F6D2F06000E0000005472616E73706F72746174696F6EFEFE
      FF1B1C00F0040000FF1D00000B0000004176696174696F6E4150490100520000
      00464141204165726F6E6175746963616C2043686172747320616E6420507562
      6C69636174696F6E732C20416972706F727420496E666F726D6174696F6E2C20
      616E6420416972706F7274205765617468657202000000000003000400000074
      7275650400020000006E6F05001C00000068747470733A2F2F646F63732E6176
      696174696F6E6170692E636F6D06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C00F1040000FF1D000005000000415A3531310100250000004163
      63657373207472616666696320646174612066726F6D207468652041444F5420
      4150490200060000006170694B65790300040000007472756504000700000075
      6E6B6E6F776E05002400000068747470733A2F2F7777772E617A3531312E636F
      6D2F646576656C6F706572732F646F6306000E0000005472616E73706F727461
      74696F6EFEFEFF1B1C00F2040000FF1D00001600000042617920417265612052
      61706964205472616E73697401002800000053746174696F6E7320616E642070
      7265646963746564206172726976616C7320666F722042415254020006000000
      6170694B657903000500000066616C7365040007000000756E6B6E6F776E0500
      13000000687474703A2F2F6170692E626172742E676F7606000E000000547261
      6E73706F72746174696F6EFEFEFF1B1C00F3040000FF1D00000A000000424320
      4665727269657301002B0000005361696C696E672074696D657320616E642063
      61706163697469657320666F7220424320466572726965730200000000000300
      040000007472756504000300000079657305001B00000068747470733A2F2F77
      77772E6263666572726965736170692E636106000E0000005472616E73706F72
      746174696F6EFEFEFF1B1C00F4040000FF1D00000B0000004249432D426F7874
      656368010039000000436F6E7461696E657220746563686E6963616C20646574
      61696C20666F722074686520676C6F62616C20636F6E7461696E657220666C65
      65740200050000004F4175746803000400000074727565040007000000756E6B
      6E6F776E05001D00000068747470733A2F2F646F63732E6269632D626F787465
      63682E6F72672F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C
      00F5040000FF1D000009000000426C61426C6143617201001800000053656172
      6368206361722073686172696E672074726970730200060000006170694B6579
      03000400000074727565040007000000756E6B6E6F776E050019000000687474
      70733A2F2F6465762E626C61626C616361722E636F6D06000E0000005472616E
      73706F72746174696F6EFEFEFF1B1C00F6040000FF1D000013000000426F7374
      6F6E204D425441205472616E73697401002800000053746174696F6E7320616E
      6420707265646963746564206172726976616C7320666F72204D425441020006
      0000006170694B657903000400000074727565040007000000756E6B6E6F776E
      05002600000068747470733A2F2F7777772E6D6274612E636F6D2F646576656C
      6F706572732F76332D61706906000E0000005472616E73706F72746174696F6E
      FEFEFF1B1C00F7040000FF1D000011000000436F6D6D756E697479205472616E
      73697401000F0000005472616E7369746C616E64204150490200000000000300
      0400000074727565040007000000756E6B6E6F776E0500580000006874747073
      3A2F2F6769746875622E636F6D2F7472616E7369746C616E642F7472616E7369
      746C616E642D6461746173746F72652F626C6F622F6D61737465722F52454144
      4D452E6D64236170692D656E64706F696E747306000E0000005472616E73706F
      72746174696F6EFEFEFF1B1C00F8040000FF1D000015000000436F6D70617265
      20466C696768742050726963657301003000000041504920666F7220636F6D70
      6172696E6720666C6967687420707269636573206163726F737320706C617466
      6F726D730200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05005700000068747470733A2F2F72617069646170692E636F
      6D2F6F627279616E2D736F6674776172652D6F627279616E2D736F6674776172
      652D64656661756C742F6170692F636F6D706172652D666C696768742D707269
      6365732F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C00F904
      0000FF1D000003000000435453010010000000435453205265616C74696D6520
      4150490200060000006170694B65790300040000007472756504000300000079
      657305001E00000068747470733A2F2F6170692E6374732D7374726173626F75
      72672E65752F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C00
      FA040000FF1D00000400000047726162010039000000547261636B2064656C69
      7665726965732C20726964652066617265732C207061796D656E747320616E64
      206C6F79616C747920706F696E74730200050000004F41757468030004000000
      74727565040007000000756E6B6E6F776E05002000000068747470733A2F2F64
      6576656C6F7065722E677261622E636F6D2F646F63732F06000E000000547261
      6E73706F72746174696F6EFEFEFF1B1C00FB040000FF1D00000B000000477261
      7068486F7070657201002D000000412D746F2D4220726F7574696E6720776974
      68207475726E2D62792D7475726E20696E737472756374696F6E730200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      1D00000068747470733A2F2F646F63732E6772617068686F707065722E636F6D
      2F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C00FC040000FF
      1D00000E0000004963656C616E64696320415049730100370000004F70656E20
      4150497320746861742064656C6976657220736572766963657320696E206F72
      20726567617264696E67204963656C616E640200000000000300040000007472
      7565040007000000756E6B6E6F776E050014000000687474703A2F2F646F6373
      2E617069732E69732F06000E0000005472616E73706F72746174696F6EFEFEFF
      1B1C00FD040000FF1D000015000000496D70616C6120486F74656C20426F6F6B
      696E6773010026000000486F74656C20636F6E74656E742C2072617465732061
      6E6420726F6F6D20626F6F6B696E67730200060000006170694B657903000400
      0000747275650400020000006E6F05002C00000068747470733A2F2F646F6373
      2E696D70616C612E74726176656C2F646F63732F626F6F6B696E672D6170692F
      06000E0000005472616E73706F72746174696F6EFEFEFF1B1C00FE040000FF1D
      000003000000497A6901001A000000417564696F20677569646520666F722074
      726176656C6C6572730200060000006170694B65790300040000007472756504
      0007000000756E6B6E6F776E05001B000000687474703A2F2F6170692D646F63
      732E697A692E74726176656C2F06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C00FF040000FF1D00002C0000004C616E64205472616E73706F72
      7420417574686F7269747920446174614D616C6C2C2053696E6761706F726501
      001F00000053696E6761706F7265207472616E73706F727420696E666F726D61
      74696F6E0200060000006170694B657903000500000066616C73650400070000
      00756E6B6E6F776E05005900000068747470733A2F2F646174616D616C6C2E6C
      74612E676F762E73672F636F6E74656E742F64616D2F646174616D616C6C2F64
      617461736574732F4C54415F446174614D616C6C5F4150495F557365725F4775
      6964652E70646606000E0000005472616E73706F72746174696F6EFEFEFF1B1C
      0000050000FF1D00000C0000004D6574726F204C6973626F6101001600000044
      656C61797320696E20737562776179206C696E65730200000000000300050000
      0066616C73650400020000006E6F05002E000000687474703A2F2F6170702E6D
      6574726F6C6973626F612E70742F7374617475732F6765744C696E6861732E70
      687006000E0000005472616E73706F72746174696F6EFEFEFF1B1C0001050000
      FF1D0000070000004E617669746961010038000000546865206F70656E204150
      4920666F72206275696C64696E6720636F6F6C20737475666620776974682074
      72616E73706F727420646174610200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001700000068747470733A2F2F646F
      632E6E6176697469612E696F2F06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C0002050000FF1D00000F0000004F70656E20436861726765204D
      617001003D000000476C6F62616C207075626C6963207265676973747279206F
      6620656C6563747269632076656869636C65206368617267696E67206C6F6361
      74696F6E730200060000006170694B6579030004000000747275650400030000
      0079657305002A00000068747470733A2F2F6F70656E6368617267656D61702E
      6F72672F736974652F646576656C6F702F61706906000E0000005472616E7370
      6F72746174696F6EFEFEFF1B1C0003050000FF1D00000F0000004F70656E536B
      79204E6574776F726B01002200000046726565207265616C2D74696D65204144
      532D42206176696174696F6E2064617461020000000000030004000000747275
      65040007000000756E6B6E6F776E05002D00000068747470733A2F2F6F70656E
      736B792D6E6574776F726B2E6F72672F617069646F632F696E6465782E68746D
      6C06000E0000005472616E73706F72746174696F6EFEFEFF1B1C0004050000FF
      1D00001C0000005261696C776179205472616E73706F727420666F7220467261
      6E636501000F000000534E4346207075626C6963204150490200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E0500280000
      0068747470733A2F2F7777772E6469676974616C2E736E63662E636F6D2F7374
      61727475702F61706906000E0000005472616E73706F72746174696F6EFEFEFF
      1B1C0005050000FF1D0000100000005245465547452052657374726F6F6D7301
      005C00000050726F766964657320736166652072657374726F6F6D2061636365
      737320666F72207472616E7367656E6465722C20696E74657273657820616E64
      2067656E646572206E6F6E636F6E666F726D696E6720696E646976696475616C
      7302000000000003000400000074727565040007000000756E6B6E6F776E0500
      3500000068747470733A2F2F7777772E72656675676572657374726F6F6D732E
      6F72672F6170692F646F63732F23212F72657374726F6F6D7306000E00000054
      72616E73706F72746174696F6EFEFEFF1B1C0006050000FF1D00001400000053
      6162726520666F7220446576656C6F7065727301001D00000054726176656C20
      536561726368202D204C696D697465642075736167650200060000006170694B
      657903000400000074727565040007000000756E6B6E6F776E05005500000068
      747470733A2F2F646576656C6F7065722E73616272652E636F6D2F6775696465
      732F74726176656C2D6167656E63792F717569636B73746172742F6765747469
      6E672D737461727465642D696E2D74726176656C06000E0000005472616E7370
      6F72746174696F6EFEFEFF1B1C0007050000FF1D000010000000536368697068
      6F6C20416972706F72740100080000005363686970686F6C0200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E05001E0000
      0068747470733A2F2F646576656C6F7065722E7363686970686F6C2E6E6C2F06
      000E0000005472616E73706F72746174696F6EFEFEFF1B1C0008050000FF1D00
      000C00000054616E6B65726B6F656E69670100210000004765726D616E207265
      616C74696D65206761732F64696573656C207072696365730200060000006170
      694B657903000400000074727565040003000000796573050030000000687474
      70733A2F2F6372656174697665636F6D6D6F6E732E74616E6B65726B6F656E69
      672E64652F737761676765722F06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C0009050000FF1D00000B0000005472616E7369744C616E640100
      130000005472616E736974204167677265676174696F6E020000000000030004
      00000074727565040007000000756E6B6E6F776E05004300000068747470733A
      2F2F7777772E7472616E7369742E6C616E642F646F63756D656E746174696F6E
      2F6461746173746F72652F6170692D656E64706F696E74732E68746D6C06000E
      0000005472616E73706F72746174696F6EFEFEFF1B1C000A050000FF1D000019
      0000005472616E73706F727420666F722041746C616E74612C20555301000500
      00004D6172746102000000000003000500000066616C7365040007000000756E
      6B6E6F776E050034000000687474703A2F2F7777772E6974736D617274612E63
      6F6D2F6170702D646576656C6F7065722D7265736F75726365732E6173707806
      000E0000005472616E73706F72746174696F6EFEFEFF1B1C000B050000FF1D00
      00230000005472616E73706F727420666F72204175636B6C616E642C204E6577
      205A65616C616E640100120000004175636B6C616E64205472616E73706F7274
      02000000000003000400000074727565040007000000756E6B6E6F776E05001E
      00000068747470733A2F2F6465762D706F7274616C2E61742E676F76742E6E7A
      2F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C000C050000FF
      1D0000150000005472616E73706F727420666F722042656C6769756D01004800
      000054686520695261696C2041504920697320612074686972642D7061727479
      2041504920666F722042656C6769616E207075626C6963207472616E73706F72
      7420627920747261696E02000000000003000400000074727565040003000000
      79657305001600000068747470733A2F2F646F63732E697261696C2E62652F06
      000E0000005472616E73706F72746174696F6EFEFEFF1B1C000D050000FF1D00
      001D0000005472616E73706F727420666F72204265726C696E2C204765726D61
      6E7901001300000054686972642D706172747920564242204150490200000000
      0003000400000074727565040007000000756E6B6E6F776E05003A0000006874
      7470733A2F2F6769746875622E636F6D2F6465726875657273742F7662622D72
      6573742F626C6F622F332F646F63732F696E6465782E6D6406000E0000005472
      616E73706F72746174696F6EFEFEFF1B1C000E050000FF1D00001E0000005472
      616E73706F727420666F7220426F7264656175782C204672616E636501003600
      0000426F726465617578204DC3A974726F706F6C65207075626C696320747261
      6E73706F727420616E64206D6F726520284672616E6365290200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E05002F0000
      0068747470733A2F2F6F70656E646174612E626F7264656175782D6D6574726F
      706F6C652E66722F6578706C6F72652F06000E0000005472616E73706F727461
      74696F6EFEFEFF1B1C000F050000FF1D00001F0000005472616E73706F727420
      666F722042756461706573742C2048756E6761727901001D0000004275646170
      657374207075626C6963207472616E73706F7274204150490200000000000300
      0400000074727565040007000000756E6B6E6F776E05001F0000006874747073
      3A2F2F626B6B66757461722E646F63732E6170696172792E696F06000E000000
      5472616E73706F72746174696F6EFEFEFF1B1C0010050000FF1D000019000000
      5472616E73706F727420666F72204368696361676F2C20555301001F00000043
      68696361676F205472616E73697420417574686F726974792028435441290200
      060000006170694B657903000500000066616C7365040007000000756E6B6E6F
      776E050029000000687474703A2F2F7777772E7472616E736974636869636167
      6F2E636F6D2F646576656C6F706572732F06000E0000005472616E73706F7274
      6174696F6EFEFEFF1B1C0011050000FF1D00001C0000005472616E73706F7274
      20666F7220437A6563682052657075626C6963010013000000437A6563682074
      72616E73706F7274204150490200000000000300040000007472756504000700
      0000756E6B6E6F776E05002F00000068747470733A2F2F7777772E6368617073
      2E637A2F656E672F70726F64756374732F69646F732D696E7465726E65740600
      0E0000005472616E73706F72746174696F6EFEFEFF1B1C0012050000FF1D0000
      180000005472616E73706F727420666F722044656E7665722C20555301000300
      000052544402000000000003000500000066616C7365040007000000756E6B6E
      6F776E050034000000687474703A2F2F7777772E7274642D64656E7665722E63
      6F6D2F677466732D646576656C6F7065722D67756964652E7368746D6C06000E
      0000005472616E73706F72746174696F6EFEFEFF1B1C0013050000FF1D000015
      0000005472616E73706F727420666F722046696E6C616E640100150000004669
      6E6E697368207472616E73706F72742041504902000000000003000400000074
      727565040007000000756E6B6E6F776E05002600000068747470733A2F2F6469
      67697472616E7369742E66692F656E2F646576656C6F706572732F2006000E00
      00005472616E73706F72746174696F6EFEFEFF1B1C0014050000FF1D00001500
      00005472616E73706F727420666F72204765726D616E79010016000000446575
      7473636865204261686E2028444229204150490200060000006170694B657903
      000500000066616C7365040007000000756E6B6E6F776E050031000000687474
      703A2F2F646174612E64657574736368656261686E2E636F6D2F646174617365
      742F6170692D66616872706C616E06000E0000005472616E73706F7274617469
      6F6EFEFEFF1B1C0015050000FF1D00001E0000005472616E73706F727420666F
      72204772656E6F626C652C204672616E63650100190000004772656E6F626C65
      207075626C6963207472616E73706F727402000000000003000500000066616C
      73650400020000006E6F05003A00000068747470733A2F2F7777772E6D6F6269
      6C697465732D6D2E66722F70616765732F6F70656E646174612F4F70656E4461
      74614170692E68746D6C06000E0000005472616E73706F72746174696F6EFEFE
      FF1B1C0016050000FF1D00001D0000005472616E73706F727420666F72204865
      7373656E2C204765726D616E79010024000000524D562041504920285075626C
      6963205472616E73706F727420696E2048657373656E29020000000000030004
      00000074727565040007000000756E6B6E6F776E05002700000068747470733A
      2F2F6F70656E646174612E726D762E64652F736974652F73746172742E68746D
      6C06000E0000005472616E73706F72746174696F6EFEFEFF1B1C0017050000FF
      1D00001A0000005472616E73706F727420666F7220486F6E6F6C756C752C2055
      53010023000000486F6E6F6C756C75205472616E73706F72746174696F6E2049
      6E666F726D6174696F6E0200060000006170694B657903000500000066616C73
      65040007000000756E6B6E6F776E050022000000687474703A2F2F6865612E74
      68656275732E6F72672F6170695F696E666F2E61737006000E0000005472616E
      73706F72746174696F6EFEFEFF1B1C0018050000FF1D00001E0000005472616E
      73706F727420666F72204C6973626F6E2C20506F72747567616C01002C000000
      446174612061626F757420627573657320726F757465732C207061726B696E67
      20616E6420747261666669630200060000006170694B65790300040000007472
      7565040007000000756E6B6E6F776E05002800000068747470733A2F2F656D65
      6C2E636974792D706C6174666F726D2E636F6D2F6F70656E646174612F06000E
      0000005472616E73706F72746174696F6EFEFEFF1B1C0019050000FF1D00001D
      0000005472616E73706F727420666F72204C6F6E646F6E2C20456E676C616E64
      01000700000054664C204150490200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05001600000068747470733A2F2F6170
      692E74666C2E676F762E756B06000E0000005472616E73706F72746174696F6E
      FEFEFF1B1C001A050000FF1D00001D0000005472616E73706F727420666F7220
      4C6F7320416E67656C65732C20555301004B000000446174612061626F757420
      706F736974696F6E73206F66204D6574726F2076656869636C657320696E2072
      65616C2074696D6520616E642074726176656C20746865697220726F75746573
      02000000000003000400000074727565040007000000756E6B6E6F776E050020
      00000068747470733A2F2F646576656C6F7065722E6D6574726F2E6E65742F61
      70692F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C001B0500
      00FF1D0000210000005472616E73706F727420666F72204D616E636865737465
      722C20456E676C616E6401001B0000005466474D207472616E73706F7274206E
      6574776F726B20646174610200060000006170694B6579030004000000747275
      650400020000006E6F05001B00000068747470733A2F2F646576656C6F706572
      2E7466676D2E636F6D2F06000E0000005472616E73706F72746174696F6EFEFE
      FF1B1C001C050000FF1D0000140000005472616E73706F727420666F72204E6F
      727761790100250000005472616E73706F7274204150497320616E6420646174
      6173657420666F72204E6F727761790200000000000300040000007472756504
      0007000000756E6B6E6F776E05001C00000068747470733A2F2F646576656C6F
      7065722E656E7475722E6F72672F06000E0000005472616E73706F7274617469
      6F6EFEFEFF1B1C001D050000FF1D00001C0000005472616E73706F727420666F
      72204F74746177612C2043616E61646101000E0000004F43205472616E73706F
      204150490200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05004300000068747470733A2F2F7777772E6F637472616E73
      706F2E636F6D2F656E2F706C616E2D796F75722D747269702F74726176656C2D
      746F6F6C732F646576656C6F7065727306000E0000005472616E73706F727461
      74696F6EFEFEFF1B1C001E050000FF1D00001B0000005472616E73706F727420
      666F722050617269732C204672616E636501001200000052415450204F70656E
      20446174612041504902000000000003000500000066616C7365040007000000
      756E6B6E6F776E050037000000687474703A2F2F646174612E726174702E6672
      2F6170692F76312F636F6E736F6C652F64617461736574732F312E302F736561
      7263682F06000E0000005472616E73706F72746174696F6EFEFEFF1B1C001F05
      0000FF1D00001E0000005472616E73706F727420666F72205068696C6164656C
      706869612C20555301000A000000534550544120415049730200000000000300
      0500000066616C7365040007000000756E6B6E6F776E05002000000068747470
      3A2F2F777777332E73657074612E6F72672F6861636B6174686F6E2F06000E00
      00005472616E73706F72746174696F6EFEFEFF1B1C0020050000FF1D00001F00
      00005472616E73706F727420666F722053616F205061756C6F2C204272617A69
      6C01000700000053505472616E730200050000004F4175746803000500000066
      616C7365040007000000756E6B6E6F776E05005F000000687474703A2F2F7777
      772E73707472616E732E636F6D2E62722F646573656E766F6C7665646F726573
      2F6170692D646F2D6F6C686F2D7669766F2D677569612D64652D726566657265
      6E6369612F646F63756D656E746163616F2D6170692F06000E0000005472616E
      73706F72746174696F6EFEFEFF1B1C0021050000FF1D0000130000005472616E
      73706F727420666F7220537061696E0100160000005075626C69632074726169
      6E73206F6620537061696E020000000000030004000000747275650400070000
      00756E6B6E6F776E05006800000068747470733A2F2F646174612E72656E6665
      2E636F6D2F6170692F312F7574696C2F736E69707065742F6170695F696E666F
      2E68746D6C3F7265736F757263655F69643D61323336386366662D313536322D
      346464652D383436362D39363335656133613537326106000E0000005472616E
      73706F72746174696F6EFEFEFF1B1C0022050000FF1D0000140000005472616E
      73706F727420666F722053776564656E0100190000005075626C696320547261
      6E73706F727420636F6E73756D65720200050000004F41757468030004000000
      74727565040007000000756E6B6E6F776E05001C00000068747470733A2F2F77
      77772E74726166696B6C61622E73652F61706906000E0000005472616E73706F
      72746174696F6EFEFEFF1B1C0023050000FF1D0000190000005472616E73706F
      727420666F7220537769747A65726C616E640100290000004F6666696369616C
      205377697373205075626C6963205472616E73706F7274204F70656E20446174
      610200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05002300000068747470733A2F2F6F70656E7472616E73706F727464
      6174612E73776973732F656E2F06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C0024050000FF1D0000190000005472616E73706F727420666F72
      20537769747A65726C616E6401001A0000005377697373207075626C69632074
      72616E73706F7274204150490200000000000300040000007472756504000700
      0000756E6B6E6F776E05001E00000068747470733A2F2F7472616E73706F7274
      2E6F70656E646174612E63682F06000E0000005472616E73706F72746174696F
      6EFEFEFF1B1C0025050000FF1D00001D0000005472616E73706F727420666F72
      20546865204E65746865726C616E647301000F0000004E532C206F6E6C792074
      7261696E730200060000006170694B657903000500000066616C736504000700
      0000756E6B6E6F776E050026000000687474703A2F2F7777772E6E732E6E6C2F
      72656973696E666F726D617469652F6E732D61706906000E0000005472616E73
      706F72746174696F6EFEFEFF1B1C0026050000FF1D00001D0000005472616E73
      706F727420666F7220546865204E65746865726C616E64730100240000004F56
      4150492C20636F756E7472792D77696465207075626C6963207472616E73706F
      727402000000000003000400000074727565040007000000756E6B6E6F776E05
      002F00000068747470733A2F2F6769746875622E636F6D2F736B79776176652F
      4B563738547572626F2D4F564150492F77696B6906000E0000005472616E7370
      6F72746174696F6EFEFEFF1B1C0027050000FF1D00001D0000005472616E7370
      6F727420666F7220546F726F6E746F2C2043616E616461010003000000545443
      02000000000003000400000074727565040007000000756E6B6E6F776E05001B
      00000068747470733A2F2F6D797474632E63612F646576656C6F706572730600
      0E0000005472616E73706F72746174696F6EFEFEFF1B1C0028050000FF1D0000
      100000005472616E73706F727420666F7220554B0100200000005472616E7370
      6F72742041504920616E64206461746173657420666F7220554B020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050022
      00000068747470733A2F2F646576656C6F7065722E7472616E73706F72746170
      692E636F6D06000E0000005472616E73706F72746174696F6EFEFEFF1B1C0029
      050000FF1D00001B0000005472616E73706F727420666F7220556E6974656420
      53746174657301000B0000004E65787442757320415049020000000000030005
      00000066616C7365040007000000756E6B6E6F776E0500360000006874747073
      3A2F2F726574726F2E756D6F69712E636F6D2F786D6C46656564446F63732F4E
      657874427573584D4C466565642E70646606000E0000005472616E73706F7274
      6174696F6EFEFEFF1B1C002A050000FF1D00001F0000005472616E73706F7274
      20666F722056616E636F757665722C2043616E6164610100090000005472616E
      734C696E6B0200050000004F4175746803000400000074727565040007000000
      756E6B6E6F776E05001F00000068747470733A2F2F646576656C6F7065722E74
      72616E736C696E6B2E63612F06000E0000005472616E73706F72746174696F6E
      FEFEFF1B1C002B050000FF1D00001C0000005472616E73706F727420666F7220
      57617368696E67746F6E2C20555301001E00000057617368696E67746F6E204D
      6574726F207472616E73706F7274204150490200050000004F41757468030004
      00000074727565040007000000756E6B6E6F776E05001C00000068747470733A
      2F2F646576656C6F7065722E776D6174612E636F6D2F06000E0000005472616E
      73706F72746174696F6EFEFEFF1B1C002C050000FF1D00000E0000007472616E
      73706F72742E7265737401003D000000436F6D6D756E697479206D61696E7461
      696E65642C20646576656C6F7065722D667269656E646C79207075626C696320
      7472616E73706F72742041504902000000000003000400000074727565040003
      00000079657305001600000068747470733A2F2F7472616E73706F72742E7265
      737406000E0000005472616E73706F72746174696F6EFEFEFF1B1C002D050000
      FF1D00000B0000005472697061647669736F72010041000000526174696E6720
      636F6E74656E7420666F72206120686F74656C2C2072657374617572616E742C
      2061747472616374696F6E206F722064657374696E6174696F6E020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E050027
      00000068747470733A2F2F646576656C6F7065722D7472697061647669736F72
      2E636F6D2F686F6D652F06000E0000005472616E73706F72746174696F6EFEFE
      FF1B1C002E050000FF1D00000400000055626572010027000000556265722072
      69646520726571756573747320616E6420707269636520657374696D6174696F
      6E0200050000004F417574680300040000007472756504000300000079657305
      002300000068747470733A2F2F646576656C6F7065722E756265722E636F6D2F
      70726F647563747306000E0000005472616E73706F72746174696F6EFEFEFF1B
      1C002F050000FF1D00001F00000056656C6962206D6574726F706F6C69732C20
      50617269732C204672616E636501001300000056656C6962204F70656E204461
      746120415049020000000000030004000000747275650400020000006E6F0500
      5000000068747470733A2F2F7777772E76656C69622D6D6574726F706F6C652E
      66722F646F6E6E6565732D6F70656E2D646174612D676266732D64752D736572
      766963652D76656C69622D6D6574726F706F6C6506000E0000005472616E7370
      6F72746174696F6EFEFEFF1B1C0030050000FF1D000003000000317074010016
      000000412073696D706C652055524C2073686F7274656E657202000000000003
      00040000007472756504000300000079657305003100000068747470733A2F2F
      6769746875622E636F6D2F3170742D636F2F6170692F626C6F622F6D61696E2F
      524541444D452E6D6406000E00000055524C2053686F7274656E657273FEFEFF
      1B1C0031050000FF1D0000050000004269746C7901002100000055524C207368
      6F7274656E657220616E64206C696E6B206D616E6167656D656E740200050000
      004F4175746803000400000074727565040007000000756E6B6E6F776E050025
      000000687474703A2F2F6465762E6269746C792E636F6D2F6765745F73746172
      7465642E68746D6C06000E00000055524C2053686F7274656E657273FEFEFF1B
      1C0032050000FF1D000008000000436C65616E55524901001500000055524C20
      73686F7274656E65722073657276696365020000000000030004000000747275
      6504000300000079657305001900000068747470733A2F2F636C65616E757269
      2E636F6D2F646F637306000E00000055524C2053686F7274656E657273FEFEFF
      1B1C0033050000FF1D00000A000000436C69636B4D657465720100320000004D
      6F6E69746F722C20636F6D7061726520616E64206F7074696D697A6520796F75
      72206D61726B6574696E67206C696E6B730200060000006170694B6579030004
      00000074727565040007000000756E6B6E6F776E05003C00000068747470733A
      2F2F737570706F72742E636C69636B6D657465722E636F6D2F68632F656E2D75
      732F63617465676F726965732F32303134373439383606000E00000055524C20
      53686F7274656E657273FEFEFF1B1C0034050000FF1D000005000000436C6963
      6F01001500000055524C2073686F7274656E6572207365727669636502000600
      00006170694B657903000400000074727565040007000000756E6B6E6F776E05
      004B00000068747470733A2F2F636C692E636F6D2F737761676765722D75692F
      696E6465782E68746D6C3F636F6E66696755726C3D2F76332F6170692D646F63
      732F737761676765722D636F6E66696706000E00000055524C2053686F727465
      6E657273FEFEFF1B1C0035050000FF1D000007000000437574742E6C79010015
      00000055524C2073686F7274656E657220736572766963650200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E0500320000
      0068747470733A2F2F637574742E6C792F6170692D646F63756D656E74617469
      6F6E2F637574746C792D6C696E6B732D61706906000E00000055524C2053686F
      7274656E657273FEFEFF1B1C0036050000FF1D00001400000044726976657420
      55524C2053686F7274656E657201002200000053686F7274656E2061206C6F6E
      672055524C20656173696C7920616E6420666173740200000000000300040000
      0074727565040007000000756E6B6E6F776E05003200000068747470733A2F2F
      77696B692E6472697665742E78797A2F656E2F75726C2D73686F7274656E6572
      2F6164642D6C696E6B7306000E00000055524C2053686F7274656E657273FEFE
      FF1B1C0037050000FF1D000012000000467265652055726C2053686F7274656E
      6572010045000000467265652055524C2053686F7274656E6572206F66666572
      73206120706F77657266756C2041504920746F20696E74657261637420776974
      68206F7468657220736974657302000000000003000400000074727565040007
      000000756E6B6E6F776E05002000000068747470733A2F2F756C7669732E6E65
      742F646576656C6F7065722E68746D6C06000E00000055524C2053686F727465
      6E657273FEFEFF1B1C0038050000FF1D0000060000004769742E696F01001400
      00004769742E696F2055524C2073686F7274656E657202000000000003000400
      000074727565040007000000756E6B6E6F776E05003B00000068747470733A2F
      2F6769746875622E626C6F672F323031312D31312D31302D6769742D696F2D67
      69746875622D75726C2D73686F7274656E65722F06000E00000055524C205368
      6F7274656E657273FEFEFF1B1C0039050000FF1D000006000000476F54696E79
      01005200000041206C696768747765696768742055524C2073686F7274656E65
      722C20666F6375736564206F6E20656173652D6F662D75736520666F72207468
      6520646576656C6F70657220616E6420656E642D757365720200000000000300
      040000007472756504000300000079657305002900000068747470733A2F2F67
      69746875622E636F6D2F726F6276616E62616B656C2F676F74696E792D617069
      06000E00000055524C2053686F7274656E657273FEFEFF1B1C003A050000FF1D
      0000040000004B75747401001900000046726565204D6F6465726E2055524C20
      53686F7274656E65720200060000006170694B65790300040000007472756504
      000300000079657305001500000068747470733A2F2F646F63732E6B7574742E
      69742F06000E00000055524C2053686F7274656E657273FEFEFF1B1C003B0500
      00FF1D0000080000004D676E65742E6D65010017000000546F7272656E742055
      524C2073686F7274656E20415049020000000000030004000000747275650400
      020000006E6F050018000000687474703A2F2F6D676E65742E6D652F6170692E
      68746D6C06000E00000055524C2053686F7274656E657273FEFEFF1B1C003C05
      0000FF1D0000030000006F776F010022000000412073696D706C65206C696E6B
      206F626675736361746F722F73686F7274656E65720200000000000300040000
      0074727565040007000000756E6B6E6F776E05001200000068747470733A2F2F
      6F776F2E76632F61706906000E00000055524C2053686F7274656E657273FEFE
      FF1B1C003D050000FF1D00000900000052656272616E646C7901002E00000043
      7573746F6D2055524C2073686F7274656E657220666F722073686172696E6720
      6272616E646564206C696E6B730200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05002800000068747470733A2F2F6465
      76656C6F706572732E72656272616E646C792E636F6D2F76312F646F63730600
      0E00000055524C2053686F7274656E657273FEFEFF1B1C003E050000FF1D0000
      0A00000053686F7274204C696E6B01002200000053686F72742055524C732073
      7570706F727420736F206D616E7920646F6D61696E7302000000000003000400
      000074727565040007000000756E6B6E6F776E05002E00000068747470733A2F
      2F6769746875622E636F6D2F46617961734E6F75736861642F53686F72742D4C
      696E6B2D41504906000E00000055524C2053686F7274656E657273FEFEFF1B1C
      003F050000FF1D00000800000053687274636F646501002300000055526C2053
      686F7274656E65722077697468206D756C7469706C6520446F6D61696E730200
      0000000003000400000074727565040003000000796573050016000000687474
      70733A2F2F73687274636F2E64652F646F637306000E00000055524C2053686F
      7274656E657273FEFEFF1B1C0040050000FF1D000007000000536872746C6E6B
      01002800000053696D706C6520616E6420656666696369656E742073686F7274
      206C696E6B206372656174696F6E0200060000006170694B6579030004000000
      7472756504000300000079657305001D00000068747470733A2F2F736872746C
      6E6B2E6465762F646576656C6F70657206000E00000055524C2053686F727465
      6E657273FEFEFF1B1C0041050000FF1D00000700000054696E7955524C010011
      00000053686F7274656E206C6F6E672055524C730200060000006170694B6579
      030004000000747275650400020000006E6F05001B00000068747470733A2F2F
      74696E7975726C2E636F6D2F6170702F64657606000E00000055524C2053686F
      7274656E657273FEFEFF1B1C0042050000FF1D00000600000055726C42616501
      002800000053696D706C6520616E6420656666696369656E742073686F727420
      6C696E6B206372656174696F6E0200060000006170694B657903000400000074
      72756504000300000079657305001D00000068747470733A2F2F75726C626165
      2E636F6D2F646576656C6F7065727306000E00000055524C2053686F7274656E
      657273FEFEFF1B1C0043050000FF1D00001D0000004272617A696C69616E2056
      656869636C657320616E642050726963657301004E00000056656869636C6573
      20696E666F726D6174696F6E2066726F6D2046756E6461C3A7C3A36F20496E73
      74697475746F206465205065737175697361732045636F6EC3B46D6963617320
      2D2046697065020000000000030004000000747275650400020000006E6F0500
      2500000068747470733A2F2F646569766964666F7274756E612E676974687562
      2E696F2F666970652F06000700000056656869636C65FEFEFF1B1C0044050000
      FF1D00000F00000048656C69706164647920736974657301005300000048656C
      69636F7074657220616E642070617373656E6765722064726F6E65206C616E64
      696E672073697465206469726563746F72792C2048656C697061646479206461
      746120616E64206D756368206D6F72650200060000006170694B657903000400
      000074727565040007000000756E6B6E6F776E05001A00000068747470733A2F
      2F68656C6970616464792E636F6D2F6170692F06000700000056656869636C65
      FEFEFF1B1C0045050000FF1D0000100000004B656C6C657920426C756520426F
      6F6B01003400000056656869636C6520696E666F2C2070726963696E672C2063
      6F6E66696775726174696F6E2C20706C7573206D756368206D6F726502000600
      00006170694B6579030004000000747275650400020000006E6F05002A000000
      687474703A2F2F646576656C6F7065722E6B62622E636F6D2F23212F64617461
      2F312D44656661756C7406000700000056656869636C65FEFEFF1B1C00460500
      00FF1D00000D0000004D657263656465732D42656E7A01005C00000054656C65
      6D617469637320646174612C2072656D6F74656C792061636365737320766568
      69636C652066756E6374696F6E732C2063617220636F6E666967757261746F72
      2C206C6F636174652073657276696365206465616C6572730200060000006170
      694B6579030004000000747275650400020000006E6F05002800000068747470
      733A2F2F646576656C6F7065722E6D657263656465732D62656E7A2E636F6D2F
      6170697306000700000056656869636C65FEFEFF1B1C0047050000FF1D000005
      0000004E485453410100350000004E485453412050726F6475637420496E666F
      726D6174696F6E20436174616C6F6720616E642056656869636C65204C697374
      696E6702000000000003000400000074727565040007000000756E6B6E6F776E
      05001F00000068747470733A2F2F767069632E6E687473612E646F742E676F76
      2F6170692F06000700000056656869636C65FEFEFF1B1C0048050000FF1D0000
      08000000536D6172746361720100600000004C6F636B20616E6420756E6C6F63
      6B2076656869636C657320616E64206765742064617461206C696B65206F646F
      6D657465722072656164696E6720616E64206C6F636174696F6E2E20576F726B
      73206F6E206D6F7374206E657720636172730200050000004F41757468030004
      0000007472756504000300000079657305001A00000068747470733A2F2F736D
      6172746361722E636F6D2F646F63732F06000700000056656869636C65FEFEFF
      1B1C0049050000FF1D000016000000416E20415049206F662049636520416E64
      204669726501001300000047616D65204F66205468726F6E6573204150490200
      0000000003000400000074727565040007000000756E6B6E6F776E05001E0000
      0068747470733A2F2F616E6170696F66696365616E64666972652E636F6D2F06
      0005000000566964656FFEFEFF1B1C004A050000FF1D00000D000000426F6227
      732042757267657273010011000000426F622773204275726765727320415049
      0200000000000300040000007472756504000300000079657305002900000068
      747470733A2F2F626F62732D627572676572732D6170692D75692E6865726F6B
      756170702E636F6D060005000000566964656FFEFEFF1B1C004B050000FF1D00
      000C000000427265616B696E6720426164010010000000427265616B696E6720
      4261642041504902000000000003000400000074727565040007000000756E6B
      6E6F776E05002800000068747470733A2F2F627265616B696E67626164617069
      2E636F6D2F646F63756D656E746174696F6E060005000000566964656FFEFEFF
      1B1C004C050000FF1D000013000000427265616B696E67204261642051756F74
      6573010018000000536F6D6520427265616B696E67204261642071756F746573
      02000000000003000400000074727565040007000000756E6B6E6F776E05002F
      00000068747470733A2F2F6769746875622E636F6D2F736865766162616D2F62
      7265616B696E672D6261642D71756F746573060005000000566964656FFEFEFF
      1B1C004D050000FF1D00000D000000436174616C6F676F706F6C697301000E00
      0000446F63746F722057686F2041504902000000000003000400000074727565
      040007000000756E6B6E6F776E05002300000068747470733A2F2F6170692E63
      6174616C6F676F706F6C69732E78797A2F646F63732F06000500000056696465
      6FFEFEFF1B1C004E050000FF1D00000E0000004361746368205468652053686F
      7701001D000000524553542041504920666F72206E6578742D657069736F6465
      2E6E657402000000000003000400000074727565040007000000756E6B6E6F77
      6E05003400000068747470733A2F2F636174636874686573686F772E6865726F
      6B756170702E636F6D2F6170692F646F63756D656E746174696F6E0600050000
      00566964656FFEFEFF1B1C004F050000FF1D000010000000437A656368205465
      6C65766973696F6E01001800000054562070726F6772616D6D65206F6620437A
      65636820545602000000000003000500000066616C7365040007000000756E6B
      6E6F776E05002B000000687474703A2F2F7777772E6365736B6174656C657669
      7A652E637A2F786D6C2F74762D70726F6772616D2F060005000000566964656F
      FEFEFF1B1C0050050000FF1D00000B0000004461696C796D6F74696F6E010019
      0000004461696C796D6F74696F6E20446576656C6F7065722041504902000500
      00004F4175746803000400000074727565040007000000756E6B6E6F776E0500
      2200000068747470733A2F2F646576656C6F7065722E6461696C796D6F74696F
      6E2E636F6D2F060005000000566964656FFEFEFF1B1C0051050000FF1D000004
      00000044756E65010050000000412073696D706C652041504920776869636820
      70726F766964657320796F75207769746820626F6F6B2C206368617261637465
      722C206D6F76696520616E642071756F746573204A534F4E2064617461020000
      0000000300040000007472756504000300000079657305002400000068747470
      733A2F2F6769746875622E636F6D2F7977616C696130312F64756E652D617069
      060005000000566964656FFEFEFF1B1C0052050000FF1D00000B00000046696E
      616C20537061636501000F00000046696E616C20537061636520415049020000
      0000000300040000007472756504000300000079657305001F00000068747470
      733A2F2F66696E616C73706163656170692E636F6D2F646F63732F0600050000
      00566964656FFEFEFF1B1C0053050000FF1D00001600000047616D65206F6620
      5468726F6E65732051756F74657301001B000000536F6D652047616D65206F66
      205468726F6E65732071756F7465730200000000000300040000007472756504
      0007000000756E6B6E6F776E05002000000068747470733A2F2F67616D656F66
      7468726F6E657371756F7465732E78797A2F060005000000566964656FFEFEFF
      1B1C0054050000FF1D000016000000486172727920506F747465722043686172
      616374657301002E000000486172727920506F74746572204368617261637465
      727320446174612077697468207769746820696D616765727902000000000003
      000400000074727565040007000000756E6B6E6F776E05001D00000068747470
      733A2F2F68702D6170692E6865726F6B756170702E636F6D2F06000500000056
      6964656FFEFEFF1B1C0055050000FF1D000008000000494D44622D4150490100
      3400000041504920666F7220726563656976696E67206D6F7669652C20736572
      69616C20616E64206361737420696E666F726D6174696F6E0200060000006170
      694B657903000400000074727565040007000000756E6B6E6F776E0500150000
      0068747470733A2F2F696D64622D6170692E636F6D2F06000500000056696465
      6FFEFEFF1B1C0056050000FF1D000006000000494D44624F5401002A00000055
      6E6F6666696369616C20494D4462204D6F766965202F2053657269657320496E
      666F726D6174696F6E0200000000000300040000007472756504000300000079
      657305002200000068747470733A2F2F6769746875622E636F6D2F5370456348
      6944652F494D44624F54060005000000566964656FFEFEFF1B1C0057050000FF
      1D00000A0000004A534F4E32566964656F01006200000043726561746520616E
      64206564697420766964656F732070726F6772616D6D61746963616C6C793A20
      77617465726D61726B732C726573697A696E672C736C69646573686F77732C76
      6F6963652D6F7665722C7465787420616E696D6174696F6E7302000600000061
      70694B6579030004000000747275650400020000006E6F050016000000687474
      70733A2F2F6A736F6E32766964656F2E636F6D060005000000566964656FFEFE
      FF1B1C0058050000FF1D00000E0000004C7563696665722051756F7465730100
      1600000052657475726E73204C7563696665722071756F746573020000000000
      03000400000074727565040007000000756E6B6E6F776E05002D000000687474
      70733A2F2F6769746875622E636F6D2F736861646F776F666630392F6C756369
      6665722D71756F746573060005000000566964656FFEFEFF1B1C0059050000FF
      1D00000D0000004D435520436F756E74646F776E0100200000004120436F756E
      74646F776E20746F20746865206E657874204D43552046696C6D020000000000
      0300040000007472756504000300000079657305002900000068747470733A2F
      2F6769746875622E636F6D2F44696C6A6F7453472F4D43552D436F756E74646F
      776E060005000000566964656FFEFEFF1B1C005A050000FF1D0000130000004D
      6F7469766174696F6E616C2051756F74657301001A00000052616E646F6D204D
      6F7469766174696F6E616C2051756F7465730200000000000300040000007472
      7565040007000000756E6B6E6F776E05002600000068747470733A2F2F6E6F64
      656A732D71756F74656170702E6865726F6B756170702E636F6D2F0600050000
      00566964656FFEFEFF1B1C005B050000FF1D00000B0000004D6F766965205175
      6F746501001E00000052616E646F6D204D6F76696520616E6420536572696573
      2051756F74657302000000000003000400000074727565040003000000796573
      05002500000068747470733A2F2F6769746875622E636F6D2F463452344E2F6D
      6F7669652D71756F74652F060005000000566964656FFEFEFF1B1C005C050000
      FF1D0000130000004F70656E204D6F7669652044617461626173650100110000
      004D6F76696520696E666F726D6174696F6E0200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E050017000000687474703A
      2F2F7777772E6F6D64626170692E636F6D2F060005000000566964656FFEFEFF
      1B1C005D050000FF1D00000F0000004F77656E2057696C736F6E20576F770100
      3800000041504920666F72206163746F72204F77656E2057696C736F6E277320
      22776F7722206578636C616D6174696F6E7320696E206D6F7669657302000000
      0000030004000000747275650400030000007965730500290000006874747073
      3A2F2F6F77656E2D77696C736F6E2D776F772D6170692E6865726F6B75617070
      2E636F6D060005000000566964656FFEFEFF1B1C005E050000FF1D0000120000
      00526F6E205377616E736F6E2051756F74657301000A00000054656C65766973
      696F6E02000000000003000400000074727565040007000000756E6B6E6F776E
      05004C00000068747470733A2F2F6769746875622E636F6D2F6A616D65737365
      616E7772696768742F726F6E2D7377616E736F6E2D71756F74657323726F6E2D
      7377616E736F6E2D71756F7465732D617069060005000000566964656FFEFEFF
      1B1C005F050000FF1D00000500000053696D6B6C0100180000004D6F7669652C
      20545620616E6420416E696D6520646174610200060000006170694B65790300
      0400000074727565040007000000756E6B6E6F776E05001C0000006874747073
      3A2F2F73696D6B6C2E646F63732E6170696172792E696F060005000000566964
      656FFEFEFF1B1C0060050000FF1D000005000000535441504901002300000049
      6E666F726D6174696F6E206F6E20616C6C207468696E67732053746172205472
      656B02000000000003000500000066616C73650400020000006E6F05000F0000
      00687474703A2F2F73746170692E636F060005000000566964656FFEFEFF1B1C
      0061050000FF1D000016000000537472616E676572205468696E67732051756F
      74657301001E00000052657475726E7320537472616E676572205468696E6773
      2071756F74657302000000000003000400000074727565040007000000756E6B
      6E6F776E05003400000068747470733A2F2F6769746875622E636F6D2F736861
      646F776F666630392F737472616E6765727468696E67732D71756F7465730600
      05000000566964656FFEFEFF1B1C0062050000FF1D0000060000005374726561
      6D010043000000437A65636820696E7465726E65742074656C65766973696F6E
      2C2066696C6D732C2073657269657320616E64206F6E6C696E6520766964656F
      7320666F72206672656502000000000003000400000074727565040002000000
      6E6F05001E00000068747470733A2F2F6170692E73747265616D2E637A2F6772
      61706869716C060005000000566964656FFEFEFF1B1C0063050000FF1D000010
      0000005374726F6D626572672051756F74657301002100000052657475726E73
      205374726F6D626572672071756F74657320616E64206D6F7265020000000000
      03000400000074727565040007000000756E6B6E6F776E05001D000000687474
      70733A2F2F7777772E7374726F6D626572672D6170692E64652F060005000000
      566964656FFEFEFF1B1C0064050000FF1D000005000000535741504901002900
      0000416C6C2074686520537461722057617273206461746120796F7527766520
      657665722077616E746564020000000000030004000000747275650400030000
      0079657305001200000068747470733A2F2F73776170692E6465762F06000500
      0000566964656FFEFEFF1B1C0065050000FF1D00000500000053574150490100
      14000000416C6C207468696E6773205374617220576172730200000000000300
      040000007472756504000300000079657305001600000068747470733A2F2F77
      77772E73776170692E74656368060005000000566964656FFEFEFF1B1C006605
      0000FF1D00000D0000005357415049204772617068514C010015000000537461
      722057617273204772617068514C204150490200000000000300040000007472
      7565040007000000756E6B6E6F776E05002100000068747470733A2F2F677261
      7068716C2E6F72672F73776170692D6772617068716C06000500000056696465
      6FFEFEFF1B1C0067050000FF1D000015000000546865204C6F7264206F662074
      68652052696E6773010019000000546865204C6F7264206F6620746865205269
      6E6773204150490200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001800000068747470733A2F2F7468652D6F6E652D
      6170692E6465762F060005000000566964656FFEFEFF1B1C0068050000FF1D00
      00130000005468652056616D70697265204469617269657301000C0000005456
      2053686F7720446174610200060000006170694B657903000400000074727565
      04000300000079657305002800000068747470733A2F2F76616D706972652D64
      6961726965732D6170692E6E65746C6966792E6170702F060005000000566964
      656FFEFEFF1B1C0069050000FF1D00000A0000005468726F6E65734170690100
      2C00000047616D65204F66205468726F6E657320436861726163746572732044
      617461207769746820696D616765727902000000000003000400000074727565
      040007000000756E6B6E6F776E05001700000068747470733A2F2F7468726F6E
      65736170692E636F6D2F060005000000566964656FFEFEFF1B1C006A050000FF
      1D000004000000544D446201001A000000436F6D6D756E6974792D6261736564
      206D6F76696520646174610200060000006170694B6579030004000000747275
      65040007000000756E6B6E6F776E05002C00000068747470733A2F2F7777772E
      7468656D6F76696564622E6F72672F646F63756D656E746174696F6E2F617069
      060005000000566964656FFEFEFF1B1C006B050000FF1D00000D000000547261
      696C6572416464696374010028000000456173696C7920656D62656420747261
      696C6572732066726F6D20547261696C65724164646963740200060000006170
      694B657903000500000066616C7365040007000000756E6B6E6F776E05002800
      000068747470733A2F2F7777772E747261696C65726164646963742E636F6D2F
      747261696C6572617069060005000000566964656FFEFEFF1B1C006C050000FF
      1D0000050000005472616B740100110000004D6F76696520616E642054562044
      6174610200060000006170694B65790300040000007472756504000300000079
      657305001D00000068747470733A2F2F7472616B742E646F63732E6170696172
      792E696F2F060005000000566964656FFEFEFF1B1C006D050000FF1D00000400
      00005456444201000F00000054656C65766973696F6E20646174610200060000
      006170694B657903000400000074727565040007000000756E6B6E6F776E0500
      2300000068747470733A2F2F746865747664622E636F6D2F6170692D696E666F
      726D6174696F6E060005000000566964656FFEFEFF1B1C006E050000FF1D0000
      0600000054564D617A6501000C00000054562053686F77204461746102000000
      000003000500000066616C7365040007000000756E6B6E6F776E050019000000
      687474703A2F2F7777772E74766D617A652E636F6D2F61706906000500000056
      6964656FFEFEFF1B1C006F050000FF1D000005000000754E6F47530100500000
      00556E6F6666696369616C204E6574666C6978204F6E6C696E6520476C6F6261
      6C205365617263682C2053656172636820616C6C206E6574666C697820726567
      696F6E7320696E206F6E6520706C6163650200060000006170694B6579030004
      0000007472756504000300000079657305002600000068747470733A2F2F7261
      7069646170692E636F6D2F756E6F67732F6170692F756E6F67736E6706000500
      0000566964656FFEFEFF1B1C0070050000FF1D00000500000056696D656F0100
      1300000056696D656F20446576656C6F706572204150490200050000004F4175
      746803000400000074727565040007000000756E6B6E6F776E05001C00000068
      747470733A2F2F646576656C6F7065722E76696D656F2E636F6D2F0600050000
      00566964656FFEFEFF1B1C0071050000FF1D00000900000057617463686D6F64
      6501004000000041504920666F722066696E64696E67206F7574207468652073
      747265616D696E6720617661696C6162696C697479206F66206D6F7669657320
      262073686F77730200060000006170694B657903000400000074727565040007
      000000756E6B6E6F776E05001A00000068747470733A2F2F6170692E77617463
      686D6F64652E636F6D2F060005000000566964656FFEFEFF1B1C0072050000FF
      1D00001B000000576562205365726965732051756F7465732047656E65726174
      6F7201002D0000004150492067656E65726174657320766172696F7573205765
      62205365726965732051756F746520496D616765730200000000000300040000
      007472756504000300000079657305003200000068747470733A2F2F67697468
      75622E636F6D2F796F67657368776172616E30312F7765622D7365726965732D
      71756F746573060005000000566964656FFEFEFF1B1C0073050000FF1D000007
      000000596F755475626501003000000041646420596F75547562652066756E63
      74696F6E616C69747920746F20796F757220736974657320616E642061707073
      0200050000004F4175746803000400000074727565040007000000756E6B6E6F
      776E05002600000068747470733A2F2F646576656C6F706572732E676F6F676C
      652E636F6D2F796F75747562652F060005000000566964656FFEFEFF1B1C0074
      050000FF1D0000070000003754696D657221010024000000576561746865722C
      20657370656369616C6C7920666F7220417374726F7765617468657202000000
      000003000500000066616C7365040007000000756E6B6E6F776E050026000000
      687474703A2F2F7777772E3774696D65722E696E666F2F646F632E7068703F6C
      616E673D656E06000700000057656174686572FEFEFF1B1C0075050000FF1D00
      000B00000041636375576561746865720100190000005765617468657220616E
      6420666F72656361737420646174610200060000006170694B65790300050000
      0066616C7365040007000000756E6B6E6F776E05002600000068747470733A2F
      2F646576656C6F7065722E61636375776561746865722E636F6D2F6170697306
      000700000057656174686572FEFEFF1B1C0076050000FF1D0000050000004165
      6D65740100240000005765617468657220616E6420666F726563617374206461
      74612066726F6D20537061696E0200060000006170694B657903000400000074
      727565040007000000756E6B6E6F776E05003200000068747470733A2F2F6F70
      656E646174612E61656D65742E65732F63656E74726F64656465736361726761
      732F696E6963696F06000700000057656174686572FEFEFF1B1C0077050000FF
      1D0000150000006170696C617965722077656174686572737461636B01002D00
      00005265616C2D54696D65202620486973746F726963616C20576F726C642057
      6561746865722044617461204150490200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001900000068747470733A2F2F
      77656174686572737461636B2E636F6D2F06000700000057656174686572FEFE
      FF1B1C0078050000FF1D00000500000041504958550100070000005765617468
      65720200060000006170694B657903000400000074727565040007000000756E
      6B6E6F776E05002600000068747470733A2F2F7777772E61706978752E636F6D
      2F646F632F726571756573742E6173707806000700000057656174686572FEFE
      FF1B1C0079050000FF1D000005000000415149434E01002B0000004169722051
      75616C69747920496E646578204461746120666F72206F766572203130303020
      6369746965730200060000006170694B65790300040000007472756504000700
      0000756E6B6E6F776E05001600000068747470733A2F2F617169636E2E6F7267
      2F6170692F06000700000057656174686572FEFEFF1B1C007A050000FF1D0000
      0F0000004176696174696F6E576561746865720100300000004E4F4141206176
      696174696F6E207765617468657220666F7265636173747320616E64206F6273
      6572766174696F6E730200000000000300040000007472756504000700000075
      6E6B6E6F776E05002A00000068747470733A2F2F7777772E6176696174696F6E
      776561746865722E676F762F6461746173657276657206000700000057656174
      686572FEFEFF1B1C007B050000FF1D00000E000000436F6C6F7266756C436C6F
      756473010007000000576561746865720200060000006170694B657903000400
      00007472756504000300000079657305003500000068747470733A2F2F6F7065
      6E2E63616979756E6170702E636F6D2F436F6C6F7266756C436C6F7564735F57
      6561746865725F41504906000700000057656174686572FEFEFF1B1C007C0500
      00FF1D0000090000004575736B616C6D65740100290000004D6574656F726F6C
      6F676963616C2064617461206F66207468652042617371756520436F756E7472
      790200060000006170694B657903000400000074727565040007000000756E6B
      6E6F776E05003E00000068747470733A2F2F6F70656E646174612E6575736B61
      64692E6575732F6170692D6575736B616C6D65742F2D2F6170692D64652D6575
      736B616C6D65742F06000700000057656174686572FEFEFF1B1C007D050000FF
      1D000006000000466F7265636101000700000057656174686572020005000000
      4F4175746803000400000074727565040007000000756E6B6E6F776E05001C00
      000068747470733A2F2F646576656C6F7065722E666F726563612E636F6D0600
      0700000057656174686572FEFEFF1B1C007E050000FF1D00000A000000484720
      5765617468657201003300000050726F7669646573207765617468657220666F
      726563617374206461746120666F722063697469657320696E204272617A696C
      0200060000006170694B65790300040000007472756504000300000079657305
      002300000068747470733A2F2F686762726173696C2E636F6D2F737461747573
      2F7765617468657206000700000057656174686572FEFEFF1B1C007F050000FF
      1D000014000000486F6E67204B6F6E67204F6265727661746F72790100450000
      0050726F76696465207765617468657220696E666F726D6174696F6E2C206561
      7274687175616B6520696E666F726D6174696F6E2C20616E6420636C696D6174
      65206461746102000000000003000400000074727565040007000000756E6B6E
      6F776E05003500000068747470733A2F2F7777772E686B6F2E676F762E686B2F
      656E2F61626F7574686B6F2F6F70656E646174615F696E74726F2E68746D0600
      0700000057656174686572FEFEFF1B1C0080050000FF1D00000B0000004D6574
      6157656174686572010007000000576561746865720200000000000300040000
      00747275650400020000006E6F05002000000068747470733A2F2F7777772E6D
      657461776561746865722E636F6D2F6170692F06000700000057656174686572
      FEFEFF1B1C0081050000FF1D0000170000004D6574656F726F6C6F6769736B20
      496E737469747574740100180000005765617468657220616E6420636C696D61
      7465206461746102000A000000557365722D4167656E74030004000000747275
      65040007000000756E6B6E6F776E05002B00000068747470733A2F2F6170692E
      6D65742E6E6F2F776561746865726170692F646F63756D656E746174696F6E06
      000700000057656174686572FEFEFF1B1C0082050000FF1D00000D0000004D69
      63726F205765617468657201002D0000005265616C2074696D65207765617468
      657220666F7265636173747320616E6420686973746F72696320646174610200
      060000006170694B657903000400000074727565040007000000756E6B6E6F77
      6E05001B00000068747470733A2F2F6D336F2E636F6D2F776561746865722F61
      706906000700000057656174686572FEFEFF1B1C0083050000FF1D0000090000
      004F445765617468657201001B0000005765617468657220616E642077656174
      6865722077656263616D7302000000000003000500000066616C736504000700
      0000756E6B6E6F776E05002C000000687474703A2F2F6170692E6F6365616E64
      7269766572732E636F6D2F7374617469632F646F63732E68746D6C0600070000
      0057656174686572FEFEFF1B1C0084050000FF1D0000070000004F696B6F6C61
      6201005400000037302B207965617273206F6620676C6F62616C2C20686F7572
      6C7920686973746F726963616C20616E6420666F726563617374207765617468
      657220646174612066726F6D204E4F414120616E642045434D57460200060000
      006170694B657903000400000074727565040003000000796573050018000000
      68747470733A2F2F646F63732E6F696B6F6C61622E636F6D0600070000005765
      6174686572FEFEFF1B1C0085050000FF1D00000A0000004F70656E2D4D657465
      6F010032000000476C6F62616C207765617468657220666F7265636173742041
      504920666F72206E6F6E2D636F6D6D65726369616C2075736502000000000003
      00040000007472756504000300000079657305001700000068747470733A2F2F
      6F70656E2D6D6574656F2E636F6D2F06000700000057656174686572FEFEFF1B
      1C0086050000FF1D00000C0000006F70656E53656E73654D6170010035000000
      446174612066726F6D20506572736F6E616C2057656174686572205374617469
      6F6E732063616C6C65642073656E7365426F7865730200000000000300040000
      007472756504000300000079657305001D00000068747470733A2F2F6170692E
      6F70656E73656E73656D61702E6F72672F06000700000057656174686572FEFE
      FF1B1C0087050000FF1D0000060000004F70656E555601001B0000005265616C
      2D74696D6520555620496E64657820466F726563617374020006000000617069
      4B657903000400000074727565040007000000756E6B6E6F776E050015000000
      68747470733A2F2F7777772E6F70656E75762E696F0600070000005765617468
      6572FEFEFF1B1C0088050000FF1D00000E0000004F70656E576561746865724D
      6170010007000000576561746865720200060000006170694B65790300040000
      0074727565040007000000756E6B6E6F776E05001E00000068747470733A2F2F
      6F70656E776561746865726D61702E6F72672F61706906000700000057656174
      686572FEFEFF1B1C0089050000FF1D000008000000515765617468657201001B
      0000004C6F636174696F6E2D6261736564207765617468657220646174610200
      060000006170694B65790300040000007472756504000300000079657305001C
      00000068747470733A2F2F6465762E71776561746865722E636F6D2F656E2F06
      000700000057656174686572FEFEFF1B1C008A050000FF1D00000A0000005261
      696E5669657765720100400000005261646172206461746120636F6C6C656374
      65642066726F6D20646966666572656E74207765627369746573206163726F73
      732074686520496E7465726E6574020000000000030004000000747275650400
      07000000756E6B6E6F776E05002300000068747470733A2F2F7777772E726169
      6E7669657765722E636F6D2F6170692E68746D6C060007000000576561746865
      72FEFEFF1B1C008B050000FF1D00000B00000053746F726D20476C6173730100
      2B000000476C6F62616C206D6172696E6520776561746865722066726F6D206D
      756C7469706C6520736F75726365730200060000006170694B65790300040000
      007472756504000300000079657305001600000068747470733A2F2F73746F72
      6D676C6173732E696F2F06000700000057656174686572FEFEFF1B1C008C0500
      00FF1D000008000000546F6D6F72726F7701002D000000576561746865722041
      504920506F77657265642062792050726F707269657461727920546563686E6F
      6C6F67790200060000006170694B657903000400000074727565040007000000
      756E6B6E6F776E05001800000068747470733A2F2F646F63732E746F6D6F7272
      6F772E696F06000700000057656174686572FEFEFF1B1C008D050000FF1D0000
      0A0000005553205765617468657201001B0000005553204E6174696F6E616C20
      5765617468657220536572766963650200000000000300040000007472756504
      000300000079657305003600000068747470733A2F2F7777772E776561746865
      722E676F762F646F63756D656E746174696F6E2F73657276696365732D776562
      2D61706906000700000057656174686572FEFEFF1B1C008E050000FF1D00000F
      00000056697375616C2043726F7373696E6701002B000000476C6F62616C2068
      6973746F726963616C20616E64207765617468657220666F7265636173742064
      6174610200060000006170694B65790300040000007472756504000300000079
      657305002A00000068747470733A2F2F7777772E76697375616C63726F737369
      6E672E636F6D2F776561746865722D61706906000700000057656174686572FE
      FEFF1B1C008F050000FF1D00000B000000776561746865722D61706901002700
      000041205245535466756C20667265652041504920746F20636865636B207468
      652077656174686572020000000000030004000000747275650400020000006E
      6F05002F00000068747470733A2F2F6769746875622E636F6D2F726F62657274
      6F64756573736D616E6E2F776561746865722D61706906000700000057656174
      686572FEFEFF1B1C0090050000FF1D00000A0000005765617468657241504901
      003F00000057656174686572204150492077697468206F746865722073747566
      66206C696B6520417374726F6E6F6D7920616E642047656F6C6F636174696F6E
      204150490200060000006170694B657903000400000074727565040003000000
      79657305001B00000068747470733A2F2F7777772E776561746865726170692E
      636F6D2F06000700000057656174686572FEFEFF1B1C0091050000FF1D00000A
      0000005765617468657262697401000700000057656174686572020006000000
      6170694B657903000400000074727565040007000000756E6B6E6F776E05001D
      00000068747470733A2F2F7777772E776561746865726269742E696F2F617069
      06000700000057656174686572FEFEFF1B1C0092050000FF1D00000E00000059
      616E6465782E5765617468657201003000000041737365737365732077656174
      68657220636F6E646974696F6E20696E207370656369666963206C6F63617469
      6F6E730200060000006170694B6579030004000000747275650400020000006E
      6F05001F00000068747470733A2F2F79616E6465782E636F6D2F6465762F7765
      61746865722F06000700000057656174686572FEFEFEFEFEFF1EFEFF1F200093
      050000FF21FEFEFE0E004D0061006E0061006700650072001E00550070006400
      6100740065007300520065006700690073007400720079001200540061006200
      6C0065004C006900730074000A005400610062006C00650008004E0061006D00
      6500140053006F0075007200630065004E0061006D0065000A00540061006200
      49004400240045006E0066006F0072006300650043006F006E00730074007200
      610069006E00740073001E004D0069006E0069006D0075006D00430061007000
      61006300690074007900180043006800650063006B004E006F0074004E007500
      6C006C00140043006F006C0075006D006E004C006900730074000C0043006F00
      6C0075006D006E00100053006F00750072006300650049004400180064007400
      41006E007300690053007400720069006E006700100044006100740061005400
      7900700065000800530069007A00650014005300650061007200630068006100
      62006C006500120041006C006C006F0077004E0075006C006C00080042006100
      7300650014004F0041006C006C006F0077004E0075006C006C0012004F004900
      6E0055007000640061007400650010004F0049006E0057006800650072006500
      1A004F0072006900670069006E0043006F006C004E0061006D00650014005300
      6F007500720063006500530069007A0065001C0043006F006E00730074007200
      610069006E0074004C00690073007400100056006900650077004C0069007300
      74000E0052006F0077004C00690073007400060052006F0077000A0052006F00
      77004900440010004F0072006900670069006E0061006C001800520065006C00
      6100740069006F006E004C006900730074001C00550070006400610074006500
      73004A006F00750072006E0061006C001200530061007600650050006F006900
      6E0074000E004300680061006E00670065007300}
  end
  object Tina4WebServer1: TTina4WebServer
    Connection = FDConnection1
    HTTPServer = IdHTTPServer1
    Active = False
    Left = 180
    Top = 430
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    Left = 160
    Top = 190
  end
  object FDMemTable2: TFDMemTable
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
        DataType = ftBoolean
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
    Left = 591
    Top = 250
  end
  object Tina4Route1: TTina4Route
    EndPoint = '/api/cars'
    CRUD = False
    Left = 320
    Top = 432
  end
end
