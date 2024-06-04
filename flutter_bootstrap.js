(()=>{var I=()=>navigator.vendor==="Google Inc."||navigator.agent==="Edg/",T=()=>typeof ImageDecoder>"u"?!1:I(),E=()=>typeof Intl.v8BreakIterator<"u"&&typeof Intl.Segmenter<"u",S=()=>{let o=[0,97,115,109,1,0,0,0,1,5,1,95,1,120,0];return WebAssembly.validate(new Uint8Array(o))},p={hasImageCodecs:T(),hasChromiumBreakIterators:E(),supportsWasmGC:S(),crossOriginIsolated:window.crossOriginIsolated};var w=U(L());function L(){let o=document.querySelector("base");return o&&o.getAttribute("href")||""}function U(o){return o===""||o.endsWith("/")?o:`${o}/`}var f=class{constructor(){this._scriptLoaded=!1}setTrustedTypesPolicy(e){this._ttPolicy=e}async loadEntrypoint(e){let{entrypointUrl:n=`${w}main.dart.js`,onEntrypointLoaded:r,nonce:t}=e||{};return this._loadJSEntrypoint(n,r,t)}async load(e,n,r,t,i){if(i??=s=>{s.initializeEngine(r).then(a=>a.runApp())},e.compileTarget==="dart2wasm")return this._loadWasmEntrypoint(e,n,i);{let s=e.mainJsPath??"main.dart.js",a=`${w}${s}`;return this._loadJSEntrypoint(a,i,t)}}didCreateEngineInitializer(e){typeof this._didCreateEngineInitializerResolve=="function"&&(this._didCreateEngineInitializerResolve(e),this._didCreateEngineInitializerResolve=null,delete _flutter.loader.didCreateEngineInitializer),typeof this._onEntrypointLoaded=="function"&&this._onEntrypointLoaded(e)}_loadJSEntrypoint(e,n,r){let t=typeof n=="function";if(!this._scriptLoaded){this._scriptLoaded=!0;let i=this._createScriptTag(e,r);if(t)console.debug("Injecting <script> tag. Using callback."),this._onEntrypointLoaded=n,document.head.append(i);else return new Promise((s,a)=>{console.debug("Injecting <script> tag. Using Promises. Use the callback approach instead!"),this._didCreateEngineInitializerResolve=s,i.addEventListener("error",a),document.head.append(i)})}}async _loadWasmEntrypoint(e,n,r){if(!this._scriptLoaded){this._scriptLoaded=!0,this._onEntrypointLoaded=r;let{mainWasmPath:t,jsSupportRuntimePath:i}=e,s=`${w}${t}`,a=`${w}${i}`;this._ttPolicy!=null&&(a=this._ttPolicy.createScriptURL(a));let d=WebAssembly.compileStreaming(fetch(s)),c=await import(a),u;e.renderer==="skwasm"?u=(async()=>{let m=await n.skwasm;return window._flutter_skwasmInstance=m,{skwasm:m.wasmExports,skwasmWrapper:m,ffi:{memory:m.wasmMemory}}})():u={};let l=await c.instantiate(d,u);await c.invoke(l)}}_createScriptTag(e,n){let r=document.createElement("script");r.type="application/javascript",n&&(r.nonce=n);let t=e;return this._ttPolicy!=null&&(t=this._ttPolicy.createScriptURL(e)),r.src=t,r}};async function b(o,e,n){if(e<0)return o;let r,t=new Promise((i,s)=>{r=setTimeout(()=>{s(new Error(`${n} took more than ${e}ms to resolve. Moving on.`,{cause:b}))},e)});return Promise.race([o,t]).finally(()=>{clearTimeout(r)})}var h=class{setTrustedTypesPolicy(e){this._ttPolicy=e}loadServiceWorker(e){if(!e)return console.debug("Null serviceWorker configuration. Skipping."),Promise.resolve();if(!("serviceWorker"in navigator)){let a="Service Worker API unavailable.";return window.isSecureContext||(a+=`
The current context is NOT secure.`,a+=`
Read more: https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts`),Promise.reject(new Error(a))}let{serviceWorkerVersion:n,serviceWorkerUrl:r=`${w}flutter_service_worker.js?v=${n}`,timeoutMillis:t=4e3}=e,i=r;this._ttPolicy!=null&&(i=this._ttPolicy.createScriptURL(i));let s=navigator.serviceWorker.register(i).then(a=>this._getNewServiceWorker(a,n)).then(this._waitForServiceWorkerActivation);return b(s,t,"prepareServiceWorker")}async _getNewServiceWorker(e,n){if(!e.active&&(e.installing||e.waiting))return console.debug("Installing/Activating first service worker."),e.installing||e.waiting;if(e.active.scriptURL.endsWith(n))return console.debug("Loading from existing service worker."),e.active;{let r=await e.update();return console.debug("Updating service worker."),r.installing||r.waiting||r.active}}async _waitForServiceWorkerActivation(e){if(!e||e.state==="activated")if(e){console.debug("Service worker already active.");return}else throw new Error("Cannot activate a null service worker!");return new Promise((n,r)=>{e.addEventListener("statechange",()=>{e.state==="activated"&&(console.debug("Activated new service worker."),n())})})}};var v=class{constructor(e,n="flutter-js"){let r=e||[/\.js$/,/\.mjs$/];window.trustedTypes&&(this.policy=trustedTypes.createPolicy(n,{createScriptURL:function(t){if(t.startsWith("blob:"))return t;let i=new URL(t,window.location),s=i.pathname.split("/").pop();if(r.some(d=>d.test(s)))return i.toString();console.error("URL rejected by TrustedTypes policy",n,":",t,"(download prevented)")}}))}};var y=o=>{let e=WebAssembly.compileStreaming(fetch(o));return(n,r)=>((async()=>{let t=await e,i=await WebAssembly.instantiate(t,n);r(i,t)})(),{})};var C=(o,e,n,r)=>window.flutterCanvasKit?Promise.resolve(window.flutterCanvasKit):(window.flutterCanvasKitLoaded=new Promise((t,i)=>{let s=n.hasChromiumBreakIterators&&n.hasImageCodecs;if(!s&&e.canvasKitVariant=="chromium")throw"Chromium CanvasKit variant specifically requested, but unsupported in this browser";let a=s&&e.canvasKitVariant!=="full",d=e.canvasKitBaseUrl??`https://www.gstatic.com/flutter-canvaskit/${r}/`;a&&(d=`${d}chromium/`);let c=`${d}canvaskit.js`;o.flutterTT.policy&&(c=o.flutterTT.policy.createScriptURL(c));let u=y(`${d}canvaskit.wasm`),l=document.createElement("script");l.src=c,e.nonce&&(l.nonce=e.nonce),l.addEventListener("load",async()=>{try{let m=await CanvasKitInit({instantiateWasm:u});window.flutterCanvasKit=m,t(m)}catch(m){i(m)}}),l.addEventListener("error",i),document.head.appendChild(l)}),window.flutterCanvasKitLoaded);var _=(o,e,n,r)=>new Promise((t,i)=>{let s=e.canvasKitBaseUrl??`https://www.gstatic.com/flutter-canvaskit/${r}/`,a=`${s}skwasm.js`;o.flutterTT.policy&&(a=o.flutterTT.policy.createScriptURL(a));let d=y(`${s}skwasm.wasm`),c=document.createElement("script");c.src=a,e.nonce&&(c.nonce=e.nonce),c.addEventListener("load",async()=>{try{let u=await skwasm({instantiateWasm:d,locateFile:(l,m)=>{let k=m+l;return k.endsWith(".worker.js")?URL.createObjectURL(new Blob([`importScripts('${k}');`],{type:"application/javascript"})):k}});t(u)}catch(u){i(u)}}),c.addEventListener("error",i),document.head.appendChild(c)});var g=class{async loadEntrypoint(e){let{serviceWorker:n,...r}=e||{},t=new v,i=new h;i.setTrustedTypesPolicy(t.policy),await i.loadServiceWorker(n).catch(a=>{console.warn("Exception while loading service worker:",a)});let s=new f;return s.setTrustedTypesPolicy(t.policy),this.didCreateEngineInitializer=s.didCreateEngineInitializer.bind(s),s.loadEntrypoint(r)}async load({serviceWorkerSettings:e,onEntrypointLoaded:n,nonce:r,config:t}={}){t??={};let i=_flutter.buildConfig;if(!i)throw"FlutterLoader.load requires _flutter.buildConfig to be set";let s=l=>{switch(l){case"skwasm":return p.crossOriginIsolated&&p.hasChromiumBreakIterators&&p.hasImageCodecs&&p.supportsWasmGC;default:return!0}},a=l=>l.compileTarget==="dart2wasm"&&!p.supportsWasmGC||t.renderer&&t.renderer!=l.renderer?!1:s(l.renderer),d=i.builds.find(a);if(!d)throw"FlutterLoader could not find a build compatible with configuration and environment.";let c={};c.flutterTT=new v,e&&(c.serviceWorkerLoader=new h,c.serviceWorkerLoader.setTrustedTypesPolicy(c.flutterTT.policy),await c.serviceWorkerLoader.loadServiceWorker(e).catch(l=>{console.warn("Exception while loading service worker:",l)})),d.renderer==="canvaskit"?c.canvasKit=C(c,t,p,i.engineRevision):d.renderer==="skwasm"&&(c.skwasm=_(c,t,p,i.engineRevision));let u=new f;return u.setTrustedTypesPolicy(c.flutterTT.policy),this.didCreateEngineInitializer=u.didCreateEngineInitializer.bind(u),u.load(d,c,t,r,n)}};window._flutter||(window._flutter={});window._flutter.loader||(window._flutter.loader=new g);})();
//# sourceMappingURL=flutter.js.map

if (!window._flutter) {
  window._flutter = {};
}
_flutter.buildConfig = {"engineRevision":"b4bfd459865a8d636f26aca0d330ae297c006c3c","builds":[{"compileTarget":"dart2js","renderer":"auto","mainJsPath":"main.dart.js"}]};


_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: "813084561"
  }
});
