'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"index.html": "01dba9816cdb431407e14c875f8297b8",
"/": "01dba9816cdb431407e14c875f8297b8",
"main.dart.js": "8728ed8d93f07aea11c58e3b74ee1102",
"icons/Icon-maskable-192.png": "3be355a0d5ee247f8d11d00ebabe7c5a",
"icons/Icon-512.png": "4d029c2692691ebf213fc8ff646c7f26",
"icons/Icon-maskable-512.png": "f790d4c3526e16dd188ea2943da3c93e",
"icons/Icon-192.png": "7e4cccf108e12a39292d5806c6450f7a",
"manifest.json": "f4438fe1ddc837a1f932cd716b935b2d",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"favicon.png": "8d33dec3a39b4c45a240f054b20abc5a",
"version.json": "7e280ce305eda1286ebfa9a84e760217",
"splash/style.css": "fd7e08a5fc9e29a741f7106de4c3c652",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"assets/packages/circle_flags/assets/svg/sl.svg": "b40874c7aad54ff1696b0c1828611780",
"assets/packages/circle_flags/assets/svg/za.svg": "06e2a985bb77f9f5fa3adc6496d4452a",
"assets/packages/circle_flags/assets/svg/sk.svg": "7365349f3806a60924ce1cd75d159a5b",
"assets/packages/circle_flags/assets/svg/cz.svg": "591673eebdcf515f5d5508add0fc009a",
"assets/packages/circle_flags/assets/svg/pt.svg": "abc9ef40c1b2ff65bc0ad80affd10788",
"assets/packages/circle_flags/assets/svg/esperanto.svg": "062880708f552983238243e96d677564",
"assets/packages/circle_flags/assets/svg/bj.svg": "2c32c62ebc5036ce3d23b75b70b4d884",
"assets/packages/circle_flags/assets/svg/pl.svg": "dab68e3036fcb93a86f919d80839319c",
"assets/packages/circle_flags/assets/svg/wf.svg": "b6852b5f47536a135e53d56e00399e81",
"assets/packages/circle_flags/assets/svg/gb-eng.svg": "d4e60073c77164265aa1496bdfe307b0",
"assets/packages/circle_flags/assets/svg/it-88.svg": "bed218a426fca87ad34fb4530a71999e",
"assets/packages/circle_flags/assets/svg/gu.svg": "10a27bf1ee22883065bb085fb20fb893",
"assets/packages/circle_flags/assets/svg/nu.svg": "f1aecd5b4f8230f9cc3d4ab698580e65",
"assets/packages/circle_flags/assets/svg/hn.svg": "94abe2f41dbab8b161a979077d336d93",
"assets/packages/circle_flags/assets/svg/uz.svg": "2c99360b398906120f6265a5a5915c36",
"assets/packages/circle_flags/assets/svg/cl.svg": "dfe5e4b9ad7f02d4196be54274b274c7",
"assets/packages/circle_flags/assets/svg/ca-bc.svg": "ff7a4c1986b43f8ff2e4b742086ca5d9",
"assets/packages/circle_flags/assets/svg/lu.svg": "8a3f8c988859932862f9047865bbde39",
"assets/packages/circle_flags/assets/svg/ly.svg": "df3155b98edf6e141f67663c2ffaf352",
"assets/packages/circle_flags/assets/svg/ec-w.svg": "d7c184918ad5a3b1fa3eb857f2660bc3",
"assets/packages/circle_flags/assets/svg/mc.svg": "5b037c6b61701ec8cef7f4ba22ee297a",
"assets/packages/circle_flags/assets/svg/tw.svg": "14f54b5d50dd9c9d673ef21ac481e1af",
"assets/packages/circle_flags/assets/svg/sm.svg": "eb21fa05f80a74793fb8d96c7b792b5a",
"assets/packages/circle_flags/assets/svg/sindh.svg": "0ab58c437668d9b93cd12fd60c50aa95",
"assets/packages/circle_flags/assets/svg/in.svg": "a667b2332b12bf937bc4df051d3d22fe",
"assets/packages/circle_flags/assets/svg/bq-bo.svg": "c82fc5a3b87c0f6a406b4162aadab3be",
"assets/packages/circle_flags/assets/svg/jm.svg": "9d4a1bc69652a0e9c4eb657be8224793",
"assets/packages/circle_flags/assets/svg/european_union.svg": "871ae2e7221011c886ebe7ea36787943",
"assets/packages/circle_flags/assets/svg/tm.svg": "b792aa429b9486d200810ee496f6dc7e",
"assets/packages/circle_flags/assets/svg/lc.svg": "82209f2ebd1e1ecba8d68194d8c4cda3",
"assets/packages/circle_flags/assets/svg/jp.svg": "be04fd894b0d6e13a16ec1bb874b74e2",
"assets/packages/circle_flags/assets/svg/dj.svg": "1ae4c0f6d4facad34075252f928a0a82",
"assets/packages/circle_flags/assets/svg/lv.svg": "9697c1c57eea9b2b50ed6761e7cbdefb",
"assets/packages/circle_flags/assets/svg/tj.svg": "6f83dc6a5c45754ec89e5ed62aea63e6",
"assets/packages/circle_flags/assets/svg/ac.svg": "23fb3ca454c770c3a3384735ec0e08e6",
"assets/packages/circle_flags/assets/svg/lr.svg": "03762e2d6b0bc5ec8323aa28ef04a9a8",
"assets/packages/circle_flags/assets/svg/pg.svg": "c7c6415305f2bca597407a9d9444ce44",
"assets/packages/circle_flags/assets/svg/es-ib.svg": "f1382a29597864bc79d0f243dc7fbf93",
"assets/packages/circle_flags/assets/svg/gw.svg": "ac71ef8446359525384399df8439c59e",
"assets/packages/circle_flags/assets/svg/it.svg": "ff40703386d1ce5dcb6f44732809e56f",
"assets/packages/circle_flags/assets/svg/it-82.svg": "dc7a07c22d1a60ff57877a78f6417ba9",
"assets/packages/circle_flags/assets/svg/ca.svg": "4d433fc3bd3b5568f93161a29400c73c",
"assets/packages/circle_flags/assets/svg/pw.svg": "9e79308401c325a3f3c76807f80130e7",
"assets/packages/circle_flags/assets/svg/ni.svg": "704a21bf8b7aaec1f3e004ff27f8166d",
"assets/packages/circle_flags/assets/svg/bs.svg": "048f207088030e3c33408b18b4d40a0b",
"assets/packages/circle_flags/assets/svg/hm.svg": "a485bb2faa02f1c8aa1b63e35d1a20b1",
"assets/packages/circle_flags/assets/svg/sz.svg": "287333f40e1b6e6705160c45a4331253",
"assets/packages/circle_flags/assets/svg/mp.svg": "e5069541bb00466ebfc37bbebfed0ee1",
"assets/packages/circle_flags/assets/svg/ht.svg": "83223775ec37213f37d3b1c5599f9edd",
"assets/packages/circle_flags/assets/svg/om.svg": "957fa2cc624a8264e6335f7fb2d94dad",
"assets/packages/circle_flags/assets/svg/ne.svg": "f1c7f30e78f7dc79467fbed3d77fd564",
"assets/packages/circle_flags/assets/svg/my.svg": "af3c3e9b290175550cb7a19b7721ccb5",
"assets/packages/circle_flags/assets/svg/by.svg": "58ae33e6909cf72dbb9fd53faac7470f",
"assets/packages/circle_flags/assets/svg/br.svg": "057f3318ec8094abfc02d746d78f167a",
"assets/packages/circle_flags/assets/svg/er.svg": "d7790c413c20478a2d03f83c5536fc6b",
"assets/packages/circle_flags/assets/svg/gb-sct.svg": "439931a1a9d8bf6306e562caebbdeb1c",
"assets/packages/circle_flags/assets/svg/um.svg": "5947945ea95bcf3707ff61470c6972e8",
"assets/packages/circle_flags/assets/svg/as.svg": "b4518f6b67ef5bf611f4c0941ea0cf57",
"assets/packages/circle_flags/assets/svg/tk.svg": "9a878bbfb0db8d0535d7975dcb5a0a13",
"assets/packages/circle_flags/assets/svg/nl.svg": "ee9b0bd34dd0925a7fb75bdb10028e55",
"assets/packages/circle_flags/assets/svg/ax.svg": "8716c282b286147ac7d899c2278c8fb2",
"assets/packages/circle_flags/assets/svg/kn.svg": "0edddebdd0296d4a86e51310d1940a3b",
"assets/packages/circle_flags/assets/svg/tt.svg": "ee80b6dceb1902699c325854e3a3b34f",
"assets/packages/circle_flags/assets/svg/ag.svg": "f6b94a14908089d1b31c735263b0d974",
"assets/packages/circle_flags/assets/svg/es-ml.svg": "c555c992a448cac8e29cc2b08d9bb22c",
"assets/packages/circle_flags/assets/svg/tl.svg": "1b22495b503f1e441453badb9f4f4845",
"assets/packages/circle_flags/assets/svg/ch.svg": "f45a7dbf12930ac8ef8e9db2123feda5",
"assets/packages/circle_flags/assets/svg/es-variant.svg": "3c3887816f694ca0c8dcc4f83adaa6b0",
"assets/packages/circle_flags/assets/svg/ua.svg": "6ef59119c38bc5e1eb860bd17fdfa84b",
"assets/packages/circle_flags/assets/svg/cd.svg": "ad03efd05727acf3f5ea5b0b59266454",
"assets/packages/circle_flags/assets/svg/ec.svg": "0775eb34f8776aa2deb27a4ee07f696c",
"assets/packages/circle_flags/assets/svg/nc.svg": "dfbc2084830be0845f4c6f687f8c6aaa",
"assets/packages/circle_flags/assets/svg/bw.svg": "9a7528b95cea43526a82c052154e60fe",
"assets/packages/circle_flags/assets/svg/mu.svg": "e7b1ed616794d3825927189f83d19328",
"assets/packages/circle_flags/assets/svg/mh.svg": "ec211b569617b17afabd8e1b93df9338",
"assets/packages/circle_flags/assets/svg/mr.svg": "c94614cf0ac44e46ee110c4f1f942f4e",
"assets/packages/circle_flags/assets/svg/km.svg": "4a12bb178db2290729910f61273aeff7",
"assets/packages/circle_flags/assets/svg/fi.svg": "475a737ec7729f15bea4b9c389a5314f",
"assets/packages/circle_flags/assets/svg/malayali.svg": "284dad1ccec1f0ceb33b15bead430060",
"assets/packages/circle_flags/assets/svg/fm.svg": "eeaa12a27ba022219aa7a10f9a033335",
"assets/packages/circle_flags/assets/svg/co.svg": "27b71dc72631d9205fe646448225fed5",
"assets/packages/circle_flags/assets/svg/hmong.svg": "a4e3b886c198f1fd78701a5118572e3e",
"assets/packages/circle_flags/assets/svg/mq.svg": "6fc074f97e5da6422e510409b0ac5be5",
"assets/packages/circle_flags/assets/svg/cg.svg": "ab34cdcef0c29d1005686c8826edf5bc",
"assets/packages/circle_flags/assets/svg/mz.svg": "f104942234e651bf0c8ebca00ff5ae29",
"assets/packages/circle_flags/assets/svg/cy.svg": "170c71c5823c032c337bc380a2119c00",
"assets/packages/circle_flags/assets/svg/south_ossetia.svg": "aa12aecc90abd6c43578b7c3e5757d52",
"assets/packages/circle_flags/assets/svg/gn.svg": "3f4a6d5a0b32d69bb017ec9d0aed3434",
"assets/packages/circle_flags/assets/svg/bb.svg": "1db266d702c39d521b38ef7578e89cee",
"assets/packages/circle_flags/assets/svg/ru.svg": "b7e32f2afc2bc24a4d45cec6fabd384d",
"assets/packages/circle_flags/assets/svg/va.svg": "318a1d440787a98ce584119691a6021d",
"assets/packages/circle_flags/assets/svg/at.svg": "33d39054f5c40c9e8c404101ccbc2aa6",
"assets/packages/circle_flags/assets/svg/al.svg": "244afce9ac99c9f215ec7d4aa16dacd5",
"assets/packages/circle_flags/assets/svg/sv.svg": "e78b64970f591854b6087c6a92ae9134",
"assets/packages/circle_flags/assets/svg/us-hi.svg": "cbbe97831822277ed5a044ff09385726",
"assets/packages/circle_flags/assets/svg/de.svg": "e5476a0d42d2c69a20fa0ec8decaed25",
"assets/packages/circle_flags/assets/svg/bq-sa.svg": "843523ab1f1343f927ba918f59a89345",
"assets/packages/circle_flags/assets/svg/hk.svg": "7667be2ebe66da6b43405536358a48dc",
"assets/packages/circle_flags/assets/svg/mm.svg": "e1e9937625af45d6d6c72e0b02084123",
"assets/packages/circle_flags/assets/svg/pm.svg": "67e1110099471ea06b5002b3f6151ae1",
"assets/packages/circle_flags/assets/svg/bi.svg": "761c83b881740e9c5109e0e5c6991828",
"assets/packages/circle_flags/assets/svg/aq.svg": "2e181d4b257c74530f2ec6b2bdd80114",
"assets/packages/circle_flags/assets/svg/sh-hl.svg": "074d05a81f68a9f34b1075f90e67f7b7",
"assets/packages/circle_flags/assets/svg/tf.svg": "09caa8d93032d1656630663180ac9e19",
"assets/packages/circle_flags/assets/svg/xk.svg": "a4f5eed93152605396ad671ef5b91a56",
"assets/packages/circle_flags/assets/svg/ms.svg": "46fb901c8a83cf3ec5b2bc0d6b80731e",
"assets/packages/circle_flags/assets/svg/mv.svg": "e96351fd6c8807774d96f08d1e84933c",
"assets/packages/circle_flags/assets/svg/tg.svg": "b40b5851491758034b1292a1b6e7d7ef",
"assets/packages/circle_flags/assets/svg/fk.svg": "f53727bd1fdb7ff8bc7679ee02f101a8",
"assets/packages/circle_flags/assets/svg/cw.svg": "c7547a00007b79ed1156fccbf3c0ec18",
"assets/packages/circle_flags/assets/svg/sh-ac.svg": "23fb3ca454c770c3a3384735ec0e08e6",
"assets/packages/circle_flags/assets/svg/ls.svg": "fa89864d6c4c887dbcce727bc039687b",
"assets/packages/circle_flags/assets/svg/lk.svg": "9e0e66b47d769e0debc739a9a887d09e",
"assets/packages/circle_flags/assets/svg/pr.svg": "29878f1db3675601456fe9779e4f35b4",
"assets/packages/circle_flags/assets/svg/vg.svg": "102c51b63e4bcd3f5bf461c3c7b77595",
"assets/packages/circle_flags/assets/svg/bg.svg": "0ef89f3e55e045c1e8e956c2a96da4ff",
"assets/packages/circle_flags/assets/svg/ug.svg": "89d0101396f0c315eba44f1bedd1d92b",
"assets/packages/circle_flags/assets/svg/st.svg": "1403f2d22c59133494fd9ebe2ddff95a",
"assets/packages/circle_flags/assets/svg/vi.svg": "c7208ad93d7db9f0fabb8989bdebe555",
"assets/packages/circle_flags/assets/svg/af.svg": "5ce6cd72be6763228940e78d13e2cac4",
"assets/packages/circle_flags/assets/svg/bo.svg": "2d373f6e99d7f6e1efa9b0d5dc76bffa",
"assets/packages/circle_flags/assets/svg/gb-ork.svg": "b62cd4cfbb8d80ba5a545f8cd4db9c1c",
"assets/packages/circle_flags/assets/svg/es-cn.svg": "0ffbff276ef119effd2ecd7a31c0912c",
"assets/packages/circle_flags/assets/svg/pf.svg": "3910f57f54c84b2a3b023c6a780379de",
"assets/packages/circle_flags/assets/svg/ci.svg": "f385ab70102fc72a5cc57c67549471a7",
"assets/packages/circle_flags/assets/svg/vc.svg": "a390bb4bdfc51827b0c2b66f3fd9e881",
"assets/packages/circle_flags/assets/svg/ga.svg": "3f4840cd3d3fb99ab3cc74a75708904c",
"assets/packages/circle_flags/assets/svg/uy.svg": "6720b2e47fdadc2c3921cd44e05689aa",
"assets/packages/circle_flags/assets/svg/no.svg": "6ad5392835cd9033852886113806ede5",
"assets/packages/circle_flags/assets/svg/dk.svg": "37a1865895f22ddb0f0e1bd2970cf2c9",
"assets/packages/circle_flags/assets/svg/gg.svg": "7d311b0411753c514db2915acb61e4cc",
"assets/packages/circle_flags/assets/svg/iq.svg": "0885ff7d2ac292fcd7cdd5dacef7f4e4",
"assets/packages/circle_flags/assets/svg/se.svg": "01887b79a05dc88a4c59f3dc8ce2bf97",
"assets/packages/circle_flags/assets/svg/bq.svg": "c82fc5a3b87c0f6a406b4162aadab3be",
"assets/packages/circle_flags/assets/svg/fr.svg": "dc3c45c4e531d31397b4b378354d476c",
"assets/packages/circle_flags/assets/svg/mw.svg": "821bfec12652e2deb9ed052774e93a50",
"assets/packages/circle_flags/assets/svg/sb.svg": "b3481d949279ba4bfabe1ab5b64ce61c",
"assets/packages/circle_flags/assets/svg/th.svg": "f213dbbef7b45a13ca72862af6e662d3",
"assets/packages/circle_flags/assets/svg/gb-wls.svg": "4ae3736ec04cd0c1042f40fd6cb41d1d",
"assets/packages/circle_flags/assets/svg/fo.svg": "275f04c86752a8eba6df22d6a87d8e95",
"assets/packages/circle_flags/assets/svg/la.svg": "c86fffbfeb449e1b591d859528de4129",
"assets/packages/circle_flags/assets/svg/kh.svg": "3a7a7d57d2692b90ec3663b258211ba0",
"assets/packages/circle_flags/assets/svg/fr-h.svg": "2c3ecb76cda9b92e3a8b2185e917538f",
"assets/packages/circle_flags/assets/svg/kurdistan.svg": "c5aa95d96b1bd6498b0c0a36122cf6f5",
"assets/packages/circle_flags/assets/svg/tc.svg": "00200ae4bb23469dc422da215bd434ba",
"assets/packages/circle_flags/assets/svg/sh-ta.svg": "54b91082703e11c2218f3b903aaea10b",
"assets/packages/circle_flags/assets/svg/cr.svg": "2c8a0b157da53116fa90ba3424e7a386",
"assets/packages/circle_flags/assets/svg/us.svg": "5947945ea95bcf3707ff61470c6972e8",
"assets/packages/circle_flags/assets/svg/eg.svg": "1fa3d248c801150a6fdeb2d6cb55602a",
"assets/packages/circle_flags/assets/svg/yt.svg": "226d5728915c117e646d8c96bf0ee908",
"assets/packages/circle_flags/assets/svg/re.svg": "d12759984e2abdbd8501864c3ece9e62",
"assets/packages/circle_flags/assets/svg/gs.svg": "828f21f95d874ebd1cd7633ee51c4919",
"assets/packages/circle_flags/assets/svg/gr.svg": "1ceb5d80d95c9eed368282b119eed8ce",
"assets/packages/circle_flags/assets/svg/et.svg": "0dc00578ef7b9517ab80907ed7be589c",
"assets/packages/circle_flags/assets/svg/bl.svg": "30d6b24e5f6fba4700ff7ad7498e44aa",
"assets/packages/circle_flags/assets/svg/fj.svg": "c784235e90e2021cfd339f6c04d7669a",
"assets/packages/circle_flags/assets/svg/es.svg": "67a365e2d1ceed95387b180a9ff495fe",
"assets/packages/circle_flags/assets/svg/im.svg": "f7e83cac25acaffcd543c34025c3d1f1",
"assets/packages/circle_flags/assets/svg/mf.svg": "1ef59252904fbb94a779924d4fc0fe33",
"assets/packages/circle_flags/assets/svg/an.svg": "0ceac729df9bb062f9f7337f1349741f",
"assets/packages/circle_flags/assets/svg/xx.svg": "30e54fd1cff28263dfa2ea82a9d5de7b",
"assets/packages/circle_flags/assets/svg/ba.svg": "f92494b7a31b30b018c0e8bcfa5690b1",
"assets/packages/circle_flags/assets/svg/es-pv.svg": "c3050ef4c37cc6498a2aa64f4328a409",
"assets/packages/circle_flags/assets/svg/sc.svg": "bc08a6b5a14fc42c3b05d519ec6f810b",
"assets/packages/circle_flags/assets/svg/lb.svg": "107c3be9d99f0b4c4ed4f9933d383928",
"assets/packages/circle_flags/assets/svg/mx.svg": "3ec0ef90ee44d55257594e5b320af639",
"assets/packages/circle_flags/assets/svg/il.svg": "1243ac49f28c1f43856bbcf2d648af53",
"assets/packages/circle_flags/assets/svg/si.svg": "5a0703e0bb6f28f989a35fe00a516c58",
"assets/packages/circle_flags/assets/svg/ck.svg": "29ad7976e8cb208c7bb552ce499c2649",
"assets/packages/circle_flags/assets/svg/np.svg": "1452f3dc94aabc6adf348d364d3c9e2a",
"assets/packages/circle_flags/assets/svg/hu.svg": "8f4c390339a02ee646bf06a7d3977502",
"assets/packages/circle_flags/assets/svg/sr.svg": "183a9e40141ef7a6c92f9bbbb8144385",
"assets/packages/circle_flags/assets/svg/sa.svg": "6a6a776e6eafd7894a15b59489d256e0",
"assets/packages/circle_flags/assets/svg/md.svg": "667635e5a977946f3c551db63d2f6688",
"assets/packages/circle_flags/assets/svg/yiddish.svg": "2954e4af78bcef134e4ce740b873bc1f",
"assets/packages/circle_flags/assets/svg/eh.svg": "bbe5c30ffe639317af1fd28b7ceae57b",
"assets/packages/circle_flags/assets/svg/to.svg": "5cba98ad640082174f6bdceeb622decf",
"assets/packages/circle_flags/assets/svg/tv.svg": "6c6bdb16922358702bfb90e7fe0d56ee",
"assets/packages/circle_flags/assets/svg/bm.svg": "65034eeae3ddbbdb27d4afa32f40a512",
"assets/packages/circle_flags/assets/svg/ro.svg": "feb88609ec1d6966b5ac0cffb888cef0",
"assets/packages/circle_flags/assets/svg/sy.svg": "366d1ac83c492cb1835ff481f6a1bc65",
"assets/packages/circle_flags/assets/svg/py.svg": "bb1899d3a8c7fb2c2ae0b8495b093fad",
"assets/packages/circle_flags/assets/svg/kannada.svg": "c5e69ac31b5823b6cb29975795c3440c",
"assets/packages/circle_flags/assets/svg/mg.svg": "8785f8d07da272f1fec074ac178ace2f",
"assets/packages/circle_flags/assets/svg/kw.svg": "f236070f2b656334445a684af35fa9be",
"assets/packages/circle_flags/assets/svg/bh.svg": "4bc0dacd5d4dc23475bb441fd603bdd4",
"assets/packages/circle_flags/assets/svg/kz.svg": "3d973b6d79281a3fb5b92f1c5a560ecd",
"assets/packages/circle_flags/assets/svg/ky.svg": "525006369cc24da51c0366cc8effaffe",
"assets/packages/circle_flags/assets/svg/bv.svg": "6ad5392835cd9033852886113806ede5",
"assets/packages/circle_flags/assets/svg/ie.svg": "7b659f5a5c6fc721750da5e95edd10d3",
"assets/packages/circle_flags/assets/svg/cx.svg": "95acc8ce21028d1403d65ee141f34e5e",
"assets/packages/circle_flags/assets/svg/kp.svg": "32070bf9c925fbd1a945013d4056987e",
"assets/packages/circle_flags/assets/svg/ss.svg": "3026df94f34e1859f7de1e25a7e15919",
"assets/packages/circle_flags/assets/svg/ge.svg": "a5234f32d942ca46473c172450dd7003",
"assets/packages/circle_flags/assets/svg/ae.svg": "dfeb0f940880884d11f30ebceef464be",
"assets/packages/circle_flags/assets/svg/ng.svg": "c0bf7d8ff246d7982d558d6de884ffab",
"assets/packages/circle_flags/assets/svg/be.svg": "63fd03cf723a8df27f5a8156dc68f681",
"assets/packages/circle_flags/assets/svg/sh.svg": "074d05a81f68a9f34b1075f90e67f7b7",
"assets/packages/circle_flags/assets/svg/vu.svg": "e2349f70ba865da34faf0e3f0502af3c",
"assets/packages/circle_flags/assets/svg/bf.svg": "0679153f1422163537878563d8a0c6a4",
"assets/packages/circle_flags/assets/svg/zw.svg": "76db6ed54a43d69822a861e69eff055d",
"assets/packages/circle_flags/assets/svg/sx.svg": "1228f6668ea3b3c79d212bdeb4b44e3c",
"assets/packages/circle_flags/assets/svg/na.svg": "d1ebb4bd2c2097be74d64f8882d6997e",
"assets/packages/circle_flags/assets/svg/ad.svg": "f07f4ebc86a1a08e7e2519bda186f4f2",
"assets/packages/circle_flags/assets/svg/pe.svg": "c96225a37b5c24767640100c52467d5d",
"assets/packages/circle_flags/assets/svg/transnistria.svg": "64456833a003f41bb72a5d2e3bc751d0",
"assets/packages/circle_flags/assets/svg/je.svg": "db9c6cf00b28c9b3f6c54b2753835364",
"assets/packages/circle_flags/assets/svg/gm.svg": "e00cacd6dcf7f6b4a1c1caea6adf78d7",
"assets/packages/circle_flags/assets/svg/somaliland.svg": "e08f14f8d6bf24800b40f0dd35b2c0f2",
"assets/packages/circle_flags/assets/svg/dz.svg": "300c399075a5a11f90917c766f6a8566",
"assets/packages/circle_flags/assets/svg/cm.svg": "5ef78df88525c24662ba4535bae29058",
"assets/packages/circle_flags/assets/svg/nato.svg": "96a364e48de93ae2dba336ff7e5e1f08",
"assets/packages/circle_flags/assets/svg/sg.svg": "ac975d1a1ef9f8a921c84454b401c9ef",
"assets/packages/circle_flags/assets/svg/au.svg": "a485bb2faa02f1c8aa1b63e35d1a20b1",
"assets/packages/circle_flags/assets/svg/northern_cyprus.svg": "26576b084fe5a5aad79ab9d7c724d00f",
"assets/packages/circle_flags/assets/svg/united_nations.svg": "fcf6200ed285e2f90a4ab63440c4239f",
"assets/packages/circle_flags/assets/svg/bt.svg": "c81d52f9807fa65b6be80c2266e91986",
"assets/packages/circle_flags/assets/svg/li.svg": "535b82bf7e54c3f803e1416c665e00e9",
"assets/packages/circle_flags/assets/svg/ir.svg": "9219b4a55203ac0d093b4af13728e384",
"assets/packages/circle_flags/assets/svg/rs.svg": "437d85037d8ba5d4e4158b085687a5d8",
"assets/packages/circle_flags/assets/svg/ke.svg": "c0bf589a9511a36bea87979ee4c1c3d1",
"assets/packages/circle_flags/assets/svg/es-ga.svg": "ec306dbdd18b02f9ba43e4475e3ca53a",
"assets/packages/circle_flags/assets/svg/ye.svg": "c8aadcdaab6af181bcfc4d0d79b2f7e2",
"assets/packages/circle_flags/assets/svg/cn.svg": "daa4b5a7e549d7f7897e5101f6dc5131",
"assets/packages/circle_flags/assets/svg/ps.svg": "67375bb499ccff93536d537071ef86f7",
"assets/packages/circle_flags/assets/svg/mt.svg": "80ed8eed583102ce3f4dd021a779069c",
"assets/packages/circle_flags/assets/svg/es-ce.svg": "d61c3d24b1956cfbac485a1dd7fbf0e9",
"assets/packages/circle_flags/assets/svg/cv.svg": "4e54347bc13d4298ba84b506b4ba8366",
"assets/packages/circle_flags/assets/svg/bd.svg": "33b0d66b6977a92a2b833435cd53d44a",
"assets/packages/circle_flags/assets/svg/nf.svg": "de87d19a53de5f067e61d1b7b442b05b",
"assets/packages/circle_flags/assets/svg/pk.svg": "8e1b819cec9ac503c212583bcfdbbb0b",
"assets/packages/circle_flags/assets/svg/jo.svg": "837db7446e42e59431d8f9a3bb7ff6b0",
"assets/packages/circle_flags/assets/svg/do.svg": "c33b8d86bff9429da9d8a3eb4f71d745",
"assets/packages/circle_flags/assets/svg/sj.svg": "6ad5392835cd9033852886113806ede5",
"assets/packages/circle_flags/assets/svg/kg.svg": "a92b7300128c8005e1109ee88f0619b8",
"assets/packages/circle_flags/assets/svg/cc.svg": "1014990dcff05b48e7792292475828c5",
"assets/packages/circle_flags/assets/svg/id.svg": "29d7dbd5af98200ee68517c4be6b94f0",
"assets/packages/circle_flags/assets/svg/gh.svg": "b21ce03150d5665b021de644291bbd5d",
"assets/packages/circle_flags/assets/svg/ee.svg": "e24b6ca0aca558b3fc1374f9f248b1e2",
"assets/packages/circle_flags/assets/svg/bn.svg": "b463ac712d6e450623473a6352f82e2d",
"assets/packages/circle_flags/assets/svg/bq-se.svg": "3f241dbd64f15e7ce955c15148dd0c8d",
"assets/packages/circle_flags/assets/svg/nr.svg": "df32b38fbd580e6a47dd2df18c8b7165",
"assets/packages/circle_flags/assets/svg/mk.svg": "8e28b928e1f35b8077b91e10f790dd0e",
"assets/packages/circle_flags/assets/svg/ph.svg": "ba804bbacdfd3c3b99fe06f8e70f160e",
"assets/packages/circle_flags/assets/svg/gf.svg": "eb540a337988046574ce8c208ea11973",
"assets/packages/circle_flags/assets/svg/ar.svg": "50bcaaec8c29006da8cabe0b097d9847",
"assets/packages/circle_flags/assets/svg/ta.svg": "54b91082703e11c2218f3b903aaea10b",
"assets/packages/circle_flags/assets/svg/ki.svg": "28e34a8854062dea9cb2784882b84631",
"assets/packages/circle_flags/assets/svg/so.svg": "ba052f96bb8187d86389a0ec479be9c7",
"assets/packages/circle_flags/assets/svg/dm.svg": "aa802be170de20298c5b62dde5e09228",
"assets/packages/circle_flags/assets/svg/tz.svg": "f56b4e238b58b0fb4098cb8bee546155",
"assets/packages/circle_flags/assets/svg/mo.svg": "a829e8877bcb790849dd4c682fbdfd39",
"assets/packages/circle_flags/assets/svg/tn.svg": "5c013018d4d863aa7928a5d94a16e287",
"assets/packages/circle_flags/assets/svg/pa.svg": "9904c98ff645a433a5865a46069e3fb0",
"assets/packages/circle_flags/assets/svg/gy.svg": "3ac8d8fb43731497a59c3be6671efde5",
"assets/packages/circle_flags/assets/svg/gd.svg": "b5e51c48e573d662975a545d020dc781",
"assets/packages/circle_flags/assets/svg/am.svg": "3367445df6aacf4268a867f54b2aa012",
"assets/packages/circle_flags/assets/svg/ai.svg": "35ccde327d1b41d04c327002e1707565",
"assets/packages/circle_flags/assets/svg/ve.svg": "6f3250ea4752641871f933f0c98cfba1",
"assets/packages/circle_flags/assets/svg/td.svg": "a5bcfd6e4600975b44cadd15dc1cd416",
"assets/packages/circle_flags/assets/svg/az.svg": "93d4994bf0c2670aea991618878b0688",
"assets/packages/circle_flags/assets/svg/ma.svg": "f90e3f47b004e4c1779db659b5522e13",
"assets/packages/circle_flags/assets/svg/mn.svg": "ab522741021a33c88f45a1d2b0d9ac50",
"assets/packages/circle_flags/assets/svg/pt-30.svg": "9496165a228a4d33be83d7fb4c48761b",
"assets/packages/circle_flags/assets/svg/ml.svg": "0fdff6d2b13f77160baccea393413240",
"assets/packages/circle_flags/assets/svg/qa.svg": "97b9b44e33ccbbe459a0e3fda97d9f18",
"assets/packages/circle_flags/assets/svg/hausa.svg": "ebde243a95129b3c8840f9dc31fea085",
"assets/packages/circle_flags/assets/svg/nz.svg": "18bed669e6c5d599a68b963c5ab65d73",
"assets/packages/circle_flags/assets/svg/gt.svg": "c9385b061ee36b46006e063311c0d6b8",
"assets/packages/circle_flags/assets/svg/gq.svg": "3a66a4a1b1012779615b403b8aca16c4",
"assets/packages/circle_flags/assets/svg/me.svg": "420389a18960efd3be2aed0147e49791",
"assets/packages/circle_flags/assets/svg/kr.svg": "4d7928d0e2aa321ec4f212ce0100cc6c",
"assets/packages/circle_flags/assets/svg/gl.svg": "3fd508ebb8ba5c86100a1d92ea969803",
"assets/packages/circle_flags/assets/svg/is.svg": "9e18eabf2cdfada2761be0d08414f937",
"assets/packages/circle_flags/assets/svg/vn.svg": "4bc2a5601a76d831d6d55ea857f8b4c6",
"assets/packages/circle_flags/assets/svg/tibet.svg": "64a0f08665e4b60534e5a09de1efc0b5",
"assets/packages/circle_flags/assets/svg/aw.svg": "d536ae24c11b08eef9efea4af5a1ec81",
"assets/packages/circle_flags/assets/svg/gb.svg": "05a4a9027bfb21945e2c36bf225f35b1",
"assets/packages/circle_flags/assets/svg/pn.svg": "420583d75f65a19574d13e9473dfde04",
"assets/packages/circle_flags/assets/svg/gp.svg": "4a13339fdb87a1ea1a22b24b7d5618a5",
"assets/packages/circle_flags/assets/svg/pt-20.svg": "1fd7f5bdc3abe1b7e79e08f7fe57c2f4",
"assets/packages/circle_flags/assets/svg/cf.svg": "2255e54e479952ea56392f831b8abfd1",
"assets/packages/circle_flags/assets/svg/ao.svg": "5b8624837922c3b279072b0b1cf3c43d",
"assets/packages/circle_flags/assets/svg/sd.svg": "3aa7c54abc6030365f7aaa3066358463",
"assets/packages/circle_flags/assets/svg/io.svg": "4701e81ac1c1a6fd68e6024d7ef1b78f",
"assets/packages/circle_flags/assets/svg/rw.svg": "408bebb0110eca4e236ce302ef3688d1",
"assets/packages/circle_flags/assets/svg/easter_island.svg": "9ea8770c9f6c82bca7e518343a2c3641",
"assets/packages/circle_flags/assets/svg/maori.svg": "01cbe97c1a996ed2b1fba56263d59d84",
"assets/packages/circle_flags/assets/svg/sn.svg": "21c497e852ad41952ec941687c43ebef",
"assets/packages/circle_flags/assets/svg/lt.svg": "793eda52fd8268ea8c2a0ba876fcbbb5",
"assets/packages/circle_flags/assets/svg/cu.svg": "ced5bf8d4a51d9162a5d3e19d9f6545e",
"assets/packages/circle_flags/assets/svg/zm.svg": "f6c0ef98ed3bbce0d3383c35217256f0",
"assets/packages/circle_flags/assets/svg/ge-ab.svg": "35714e5484036b7b0f4e8261aec155ad",
"assets/packages/circle_flags/assets/svg/gi.svg": "fb52d8c2f2f4a837c89eb26a236c7813",
"assets/packages/circle_flags/assets/svg/bz.svg": "cbbe4ee809c535c1a329174cd5ee7f76",
"assets/packages/circle_flags/assets/svg/tr.svg": "b4a158322e521d3a0ec446c0fbd07ca0",
"assets/packages/circle_flags/assets/svg/hr.svg": "3c3cb4e0bb504066e5607df14d1f3b43",
"assets/packages/circle_flags/assets/svg/ws.svg": "e03072bc05344ccd2fea95e8f8cc63cc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "0a94bab8e306520dc6ae14c2573972ad",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "9cda082bd7cc5642096b56fa8db15b45",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b00363533ebe0bfdb95f3694d7647f6d",
"assets/packages/status_alert/assets/fonts/SFNS.ttf": "9e14b4e72dec1db9a60d2636bbfe64f2",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/FontManifest.json": "340ba7db15928dafeb99710b23eb301b",
"assets/NOTICES": "06292d267f26820d59180daca7ddc283",
"assets/AssetManifest.json": "f5d80228c4cbef5c8290d5f4cffd924e",
"assets/assets/ca/lets-encrypt-r3.pem": "be77e5992c00fcd753d1b9c11d3768f2",
"assets/assets/images/logo_ankh_800_bcg.png": "e28a1236a360950068e7f82886b7276c",
"assets/assets/images/4.0x/giraffes_tile.png": "587872544a6cbe54ebdbde7864ef1995",
"assets/assets/images/4.0x/giraffes_banner.png": "5de2a968167e55f8e51e06d4c15ecc6d",
"assets/assets/images/3.0x/giraffes_tile.png": "d8f026f5afb119085126fae99987f1dc",
"assets/assets/images/3.0x/giraffes_banner.png": "6edf17d372d9f8d61badd5e3afc6f625",
"assets/assets/images/logo_400.png": "b524633bf7c73d16023ffbe0c3a658fa",
"assets/assets/images/logo_72.png": "1a440446cacbced89ecad1ee3dc7fc62",
"assets/assets/images/giraffes_tile.png": "0e9177ce6d3acb02ca3d56ed7ee9197a",
"assets/assets/images/logo_ankh_800.png": "b524633bf7c73d16023ffbe0c3a658fa",
"assets/assets/images/giraffes_banner.png": "e114f3b043f1a60b0d6147b38d0ba98a",
"assets/assets/images/2.0x/giraffes_tile.png": "342e6fafc0721e0c7f6cbf69723a94e8",
"assets/assets/images/2.0x/giraffes_banner.png": "ce8f4d512c9c56351456e737287762cf"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
