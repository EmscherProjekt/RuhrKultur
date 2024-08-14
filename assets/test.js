'use strict';
(function() {
    if ('now'in Date == !1) {
        Date.now = function() {
            return new Date().getTime()
        }
    }
    if ('from'in Array == !1) {
        var toArray = function(collection) {
            return Array.prototype.slice.call(collection)
        }
    } else {
        var toArray = Array.from
    }
    if ('includes'in Array.prototype == !1) {
        Object.defineProperty(Array.prototype, 'includes', {
            configurable: !0,
            enumerable: !1,
            value: function Array_includes(needle, offset) {
                offset = parseInt(offset);
                if (isNaN(offset)) {
                    offset = 0
                } else {
                    offset = Math.min(Math.max(0, (offset >= 0) ? offset : this.length + offset), this.length - 1)
                }
                var haystack = Array.prototype.slice.call(this, offset);
                return haystack.reduce(function(found, currentValue) {
                    return found || currentValue === needle
                }, !1)
            }
        })
    }
    if ('includes'in String.prototype == !1) {
        Object.defineProperty(String.prototype, 'includes', {
            configurable: !0,
            enumerable: !1,
            value: function String_includes(needle, offset) {
                offset = parseInt(offset);
                if (isNaN(offset)) {
                    offset = 0
                } else {
                    offset = Math.min(Math.max(0, (offset >= 0) ? offset : this.length + offset), this.length - 1)
                }
                return this.indexOf(needle, offset) !== -1
            }
        })
    }
    if ('values'in Object == !1) {
        Object.defineProperty(Object, 'values', {
            configurable: !0,
            enumerable: !1,
            writable: !0,
            value: function(object) {
                return Object.keys(object).map(function(property) {
                    return object[property]
                })
            },
        })
    }
    if (!('addEventListener'in window) && 'attachEvent'in window) {
        EventTarget.prototype.addEventListener = function(event, fn, opt) {
            if (typeof opt == 'object' && opt.once) {
                var obj = this;
                var origFn = fn;
                fn = function() {
                    var result;
                    try {
                        result = origFn.apply(this, arguments)
                    } catch (e) {
                        obj.detachEvent('on' + event, fn);
                        throw e
                    }
                    obj.detachEvent('on' + event, fn);
                    return result
                }
            }
            this.attachEvent('on' + event, fn)
        }
        EventTarget.prototype.removeEventListener = function(event, fn, opt) {
            this.detachEvent('on' + event, fn)
        }
    }
    if (typeof window.CustomEvent != 'function') {
        window.CustomEvent = function(event, params) {
            params = params || {
                bubbles: !1,
                cancelable: !1,
                detail: null
            };
            var evt = document.createEvent('CustomEvent');
            evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
            return evt
        }
        ;
        window.CustomEvent.prototype = window.Event.prototype
    }
    if ('padStart'in String.prototype == !1) {
        String.prototype.padStart = function padStart(len, padding) {
            len = len | 0;
            padding = (padString === undefined) ? padding + "" : " ";
            if (this.length > len) {
                return this
            } else {
                len = len - this.length;
                if (len > len.length) {
                    padding += padding.repeat(len / padding.length)
                }
                return padding.slice(0, len) + this
            }
        }
    }
    var hl = [];
    for (var i = 0; i < 256; i++) {
        hl[i] = ((i >> 4) & 15).toString(16) + (i & 15).toString(16)
    }
    var Utils = {
        toggleClass: function(element, className, forceState) {
            if (!element || !element.classList) {
                console.error('[CCM19] Cannot toggle class %s on %s', className, element === null ? element : typeof element);
                return !1
            }
            var newState = typeof forceState == 'boolean' ? forceState : element.classList.contains(className) == !1;
            newState ? element.classList.add(className) : element.classList.remove(className);
            return newState
        },
        partial: function(values) {
            return values.reduce(function(newState, value) {
                if (newState === !0) {
                    newState = !!value || 'partial'
                } else {
                    newState = !!value ? 'partial' : newState
                }
                return newState
            }, values.length ? !!values[0] : !1)
        },
        uniqueValues: function(array) {
            return array.filter(function(value, index) {
                return array.indexOf(value) == index
            })
        },
        enableButtons: function(element) {
            toArray(element.getElementsByTagName('BUTTON')).forEach(function(button) {
                button.disabled = !1
            })
        },
        disableButtons: function(element) {
            toArray(element.getElementsByTagName('BUTTON')).forEach(function(button) {
                button.disabled = !0
            })
        },
        extractDomain: function(url) {
            var match = url.match(/^(?:https?:)?\/\/([^\/]+)/);
            return match ? match[1] : ''
        },
        triggerCustomEvent: function(node, name, detail) {
            var evt;
            try {
                evt = new CustomEvent(name,{
                    detail: detail
                })
            } catch (_) {
                evt = document.createEvent('CustomEvent');
                evt.initCustomEvent(name, !0, !1, detail)
            }
            node.dispatchEvent(evt)
        },
        triggerGTMEvent: function(name, data) {
            data = data || {};
            data.event = name;
            window.dataLayer = window.dataLayer || [];
            window.dataLayer.push(data)
        },
        hasGTMLayer: function(type) {
            var layers = window.dataLayer || [];
            for (var i = 0; i < layers.length; ++i) {
                var layer = layers[i];
                if (layer[0] === type || layer[type] !== undefined) {
                    return !0
                }
            }
            return !1
        },
        sendGTag: function() {
            if (typeof window.gtag == 'function') {
                window.gtag.apply(null, arguments)
            } else {
                window.dataLayer = window.dataLayer || [];
                window.dataLayer.push(arguments)
            }
        },
        isBlockableScript: function(script) {
            return this.isJavaScript(script) || script.type.toLowerCase() == 'text/x-ccm-loader' && !script.dataset.ccmLoaderGroup || script.type.toLowerCase() == 'text/x-magento-init'
        },
        isJavaScript: function(script) {
            return (!script.type || /(application|text)\/(x-)?(java|ecma|j|live)script(1.[0-5])?/.test(script.type.toLowerCase()) || script.type.toLowerCase() == 'module')
        },
        isIE: function() {
            return 'userAgent'in navigator && /\b(Trident|MSIE)\b/.test(navigator.userAgent)
        },
        getContainingModal: function getContainingModal(node) {
            if (!node || !('classList'in node)) {
                return null
            } else if (node.classList.contains('ccm-modal')) {
                return node
            }
            return getContainingModal(node.parentNode)
        },
        focusableElements: function(root) {
            if (!root) {
                root = document.body
            }
            return toArray(root.querySelectorAll('button, a[href], map area[href], input:not(:disabled), select, textarea, [tabindex]:not([tabindex="-1"])')).filter(function(el) {
                return el.offsetHeight !== 0 && el.offsetWidth !== 0
            })
        },
        isManipulatedClick: function(event) {
            if (event instanceof MouseEvent == !1 || event.type != 'click') {
                return !1
            }
            if ('isTrusted'in event && event.isTrusted == !1) {
                return !0
            }
            return !1
        },
        hash: function(str) {
            var c, i, l = str.length, t0 = 0, v0 = 0x2325, t1 = 0, v1 = 0x8422, t2 = 0, v2 = 0x9ce4, t3 = 0, v3 = 0xcbf2;
            for (i = 0; i < l; i++) {
                c = str.charCodeAt(i);
                if (c < 128) {
                    v0 ^= c
                } else if (c < 2048) {
                    v0 ^= (c >> 6) | 192;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= (c & 63) | 128
                } else if (((c & 64512) == 55296) && (i + 1) < l && ((str.charCodeAt(i + 1) & 64512) == 56320)) {
                    c = 65536 + ((c & 1023) << 10) + (str.charCodeAt(++i) & 1023);
                    v0 ^= (c >> 18) | 240;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= ((c >> 12) & 63) | 128;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= ((c >> 6) & 63) | 128;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= (c & 63) | 128
                } else {
                    v0 ^= (c >> 12) | 224;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= ((c >> 6) & 63) | 128;
                    t0 = v0 * 435;
                    t1 = v1 * 435;
                    t2 = v2 * 435;
                    t3 = v3 * 435;
                    t2 += v0 << 8;
                    t3 += v1 << 8;
                    t1 += t0 >>> 16;
                    v0 = t0 & 65535;
                    t2 += t1 >>> 16;
                    v1 = t1 & 65535;
                    v3 = (t3 + (t2 >>> 16)) & 65535;
                    v2 = t2 & 65535;
                    v0 ^= (c & 63) | 128
                }
                t0 = v0 * 435;
                t1 = v1 * 435;
                t2 = v2 * 435;
                t3 = v3 * 435;
                t2 += v0 << 8;
                t3 += v1 << 8;
                t1 += t0 >>> 16;
                v0 = t0 & 65535;
                t2 += t1 >>> 16;
                v1 = t1 & 65535;
                v3 = (t3 + (t2 >>> 16)) & 65535;
                v2 = t2 & 65535
            }
            return hl[v3 >> 8] + hl[v3 & 255] + hl[v2 >> 8] + hl[v2 & 255] + hl[v1 >> 8] + hl[v1 & 255] + hl[v0 >> 8] + hl[v0 & 255]
        },
        getUrl: function(element, forceCopy) {
            var url = null;
            if (!forceCopy && typeof element == 'object' && 'hostname'in element && 'hash'in element) {
                url = element
            } else {
                url = document.createElement('a');
                if (typeof element == 'string' || element instanceof String) {
                    url.href = element
                } else if ('href'in element) {
                    url.href = element.href
                } else if ('action'in element) {
                    url.href = element.action
                }
            }
            return url
        },
        setUrl: function(element, url) {
            if (element !== url) {
                if ('href'in url) {
                    url = url.href
                }
                if ('href'in element) {
                    element.href = url
                } else if ('action'in element) {
                    element.action = url
                }
            }
            return url
        },
        fnmatch: function(pattern, string) {
            pattern = pattern.replace(/[.+^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*').replace(/\\\\\.\*/g, '\*').replace(/\?/g, '.').replace(/\\\\\.\*/g, '\?');
            return (new RegExp("^" + pattern + "$","")).test(string)
        },
        isTopLevel: function() {
            try {
                var top = window.top;
                return (window === top || window.self === top)
            } catch (e) {
                return !1
            }
        },
        wrapProperty: function(object, name, getter, setter) {
            var descriptor = null;
            var prototype = object;
            for (var i = 0; (i < 10) && prototype; ++i) {
                descriptor = Object.getOwnPropertyDescriptor(prototype, name);
                if (descriptor !== undefined) {
                    break
                }
                prototype = Object.getPrototypeOf(prototype)
            }
            if (!descriptor) {
                return !1
            }
            if (getter) {
                var origGetter = descriptor.get;
                descriptor.get = function() {
                    return getter.call(this, origGetter)
                }
            }
            if (setter) {
                var origSetter = descriptor.set;
                descriptor.set = function(value) {
                    return setter.call(this, value, origSetter)
                }
            }
            Object.defineProperty(object, name, descriptor);
            return !0
        },
    };
    function CookieConsentManagement(urlConsent) {
        this.urlConsent = urlConsent;
        this.init()
    }
    CookieConsentManagement.prototype = {
        constructor: CookieConsentManagement,
        versionId: "f572eb7ee323069153f9eefe5ebee1a8c94c5aec",
        versionName: "2022.03.25",
        domainId: "79da03d",
        initialized: !1,
        shouldReport: !1,
        container: null,
        controlPanel: null,
        urlConsent: null,
        widget: null,
        widgetUrl: null,
        widgetUrls: {
            "de_DE": "https:\/\/click-learn.consent-bist.de\/public\/widget?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e&lang=de_DE&v=1713180154"
        },
        detailsUrls: {
            "de_DE": "https:\/\/click-learn.consent-bist.de\/public\/widget\/details?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e&lang=de_DE&v=1713180154"
        },
        locale: "de_DE",
        statisticsUrl: "https:\/\/click-learn.consent-bist.de\/public\/statistics\/consent?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e",
        pageCheckUrl: "https:\/\/click-learn.consent-bist.de\/public\/page_check\/report?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2",
        cronUrl: "https:\/\/click-learn.consent-bist.de\/public\/cron?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2",
        origin: "https:\/\/click-learn.consent-bist.de",
        cssFiles: ["https:\/\/click-learn.consent-bist.de\/public\/app.css?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e&v=1691742518"],
        jsFiles: [],
        isActive: !0,
        deleteAllCookiesConfig: !1,
        deleteAllCookiesReload: !1,
        runMandatoryEmbeddingsWithoutConsent: !0,
        cookies: {
            consent: 'ccm_consent',
        },
        cookieLifetime: 30,
        cookieUseSecure: !0,
        consentStorageMethod: "cookie",
        consentShareDomains: [],
        consentCrossDomain: !1,
        consentValidateUrl: "https:\/\/click-learn.consent-bist.de\/public\/statistics\/consent\/validate?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2",
        cookieDeclarationUrl: "https:\/\/click-learn.consent-bist.de\/public\/cookie-declaration?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e",
        storageNamespace: "\/",
        ucid: Utils.hash(String(Date.now()) + String(Math.random()).substring(1)),
        settingsIconEnabled: !1,
        settingsIconTarget: "purpose",
        repository: {
            "4af8c3d": {
                "id": "4af8c3d",
                "name": "Sonstige",
                "code": "",
                "iframeBlockingStrings": [],
                "hideIframesUntilConsent": !1,
                "scriptLoaderGroup": "",
                "excludeUrls": [],
                "excludeUrlsMode": "blacklist",
                "purpose": "15c61c3",
                "mandatory": !1,
                "assets": [{
                    "id": "e0496bf",
                    "name": "ss-pid",
                    "type": "cookie",
                    "glob": !1,
                    "lifetime": "20 y",
                    "hours": 175200
                }, {
                    "id": "8085b76",
                    "name": "ss-id",
                    "type": "cookie",
                    "glob": !1,
                    "lifetime": "Session",
                    "hours": null
                }],
                "tcf": null
            },
            "5beec12": {
                "id": "5beec12",
                "name": "Cookie Consent Manager CCM19",
                "code": "",
                "iframeBlockingStrings": [],
                "hideIframesUntilConsent": !1,
                "scriptLoaderGroup": "",
                "excludeUrls": [],
                "excludeUrlsMode": "blacklist",
                "purpose": "41ba25c",
                "mandatory": !0,
                "assets": [{
                    "id": "b28e369",
                    "name": "ccm_consent",
                    "type": "cookie",
                    "glob": !1,
                    "lifetime": "1 Jahr",
                    "hours": 8760
                }],
                "tcf": null
            }
        },
        consentState: {
            googleAdTechProviders: {},
            tcfPurposes: {},
            tcfSpecialFeatures: {},
            tcfVendors: {},
        },
        tcfData: {
            "enabled": !1,
            "purposes": {
                "1": {},
                "2": {},
                "3": {},
                "4": {},
                "5": {},
                "6": {},
                "7": {},
                "8": {},
                "9": {},
                "10": {}
            },
            "specialFeatures": [],
            "vendor": [],
            "gvlVersion": 2,
            "vlVersion": 224,
            "tcfVersion": 2,
            "googleACMode": !1,
            "googleATPs": [],
            "disclosureUrlTemplate": "https:\/\/click-learn.consent-bist.de\/public\/tcf-disclosure\/:VENDOR?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2"
        },
        behavior: {
            "respectDoNotTrack": !0,
            "noConsentRequired": !1
        },
        embeddingsEmbedded: [],
        loadingModal: !1,
        forceOpenWidget: !1,
        consentShareChannels: [],
        domWatcher: null,
        iframes: [],
        iframeConsentDomains: [],
        iframeConsentSwitchMap: {},
        blockableScripts: [],
        scriptLoaderQueue: [],
        scriptLoaderRunning: !1,
        foundScriptCookies: {},
        inEval: !1,
        focusStack: [],
        blockIframes: !1,
        rememberIframeConsent: !1,
        appendConsentSwitchToIframes: !1,
        iframeBlockMode: "whitelist",
        blockNewScripts: !1,
        blockSameDomainScripts: !1,
        blockInlineScripts: !1,
        activatePermaScan: !0,
        blockEmbeddingScriptMarkers: {
            "4af8c3d": []
        },
        deniedScripts: [],
        allowedScripts: [],
        allowedScriptMarkers: [],
        deniedScriptMarkers: [],
        iframeMarkers: [],
        country: "DE",
        exemptUrls: ["https:\/\/schueler.click-learn.info\/Content\/Impressum", "https:\/\/schueler.click-learn.info\/Content\/Datenschutz"],
        scripTracker: "",
        appendCrossDomainConsent: function(element) {
            var currentDomain = this.getBaseDomain(window.location.hostname);
            var origUrl = Utils.getUrl(element, !0);
            var url = this.withCrossDomainConsent(Utils.getUrl(element, !0));
            if (url.hash !== origUrl.hash) {
                Utils.setUrl(element, url);
                window.setTimeout(function() {
                    Utils.setUrl(element, origUrl)
                }, 100)
            }
        },
        withCrossDomainConsent: function(url) {
            var currentDomain = this.getBaseDomain(window.location.hostname);
            var origUrl = url;
            url = Utils.getUrl(url, !1);
            if (!url || !this.consentGiven()) {
                return origUrl
            }
            var targetDomain = this.getBaseDomain(url.hostname);
            if (!targetDomain || targetDomain === currentDomain) {
                return origUrl
            }
            if (/(^#?|&)CCM19consent=/.test(url.hash)) {
                return origUrl
            }
            if (url.hash) {
                url.hash += '&' + this.buildCrossDomainConsent()
            } else {
                url.hash = '#' + this.buildCrossDomainConsent()
            }
            return (typeof origUrl === 'string') ? url.href : url
        },
        buildCrossDomainConsent: function() {
            var data = (Date.now() / 1000 / 60 | 0).toString(16) + '|' + this.getUniqueCookieId() + '|' + (this.embeddingsEmbedded.join('|'));
            return 'CCM19consent=' + data
        },
        getBaseDomain: function(hostname) {
            var hostname = hostname.replace(/\.+$/, '');
            for (var i = 0; i < this.consentShareDomains.length; ++i) {
                var domain = this.consentShareDomains[i];
                if (hostname == domain || (hostname).indexOf('.' + domain, hostname.length - domain.length - 1) != -1) {
                    return domain
                }
            }
            return null
        },
        checkIsExternal: function(urlString) {
            if (!urlString) {
                return !1
            }
            var dblSlashIdx = urlString.search('//');
            if (dblSlashIdx < 0 || dblSlashIdx > 16) {
                return !1
            }
            var url = Utils.getUrl(urlString);
            if (url.protocol === 'data:') {
                return !1
            }
            if (url.hostname === location.hostname) {
                return !1
            }
            if (this.getBaseDomain(url.hostname)) {
                return !1
            }
            var mainDomain = location.hostname;
            mainDomain = mainDomain.replace(/\.$/, '');
            mainDomain = mainDomain.replace(/^.*\.([^.]+\.[^.]+)$/, '$1');
            var domainRegExp = new RegExp('\\b' + mainDomain.replace(/([.\\])/g, '\\$1') + '$');
            if (url.hostname.search(domainRegExp) !== -1) {
                return !1
            }
            if (Utils.fnmatch("https:\/\/click-learn.consent-bist.de\/public\/app.js*", urlString)) {
                return !1
            }
            return !0
        },
        getCookies: function() {
            return document.cookie.split(';').filter(function(chunk) {
                return chunk.trim().length > 0
            }).map(function(cookie) {
                var parts = cookie.trim().split('=');
                return {
                    name: parts[0],
                    value: parts[1],
                }
            })
        },
        getCookie: function(name, storageMethod) {
            var self = this;
            var result = null;
            var method = (storageMethod !== undefined) ? storageMethod : this.consentStorageMethod;
            if ('sessionStorage'in window && 'getItem'in window.sessionStorage) {
                result = window.sessionStorage.getItem(name);
                if (result !== null) {
                    try {
                        return JSON.parse(result)
                    } catch (error) {
                        if (method == 'sessionStorage') {
                            return {}
                        }
                    }
                }
            }
            if (method == 'localStorage' && 'localStorage'in window && 'getItem'in window.localStorage) {
                result = window.localStorage.getItem(name);
                if (result !== null) {
                    try {
                        return JSON.parse(result)
                    } catch (error) {
                        return {}
                    }
                }
            }
            if (method == 'cookie' || !('localStorage'in window) || !('sessionStorage'in window)) {
                return this.getCookies().reduce(function(value, cookie) {
                    try {
                        return cookie.name === name ? self.decodeCookieValue(cookie.value) : value
                    } catch (error) {
                        return {}
                    }
                }, null)
            }
            return {}
        },
        setCookie: function(name, value, options) {
            if (name === undefined || value === undefined) {
                throw new Error('Undefined name or value not allowed for cookies.')
            }
            options = typeof options === 'object' ? options : {};
            var method = ('method'in options) ? options.method : this.consentStorageMethod;
            if (method == 'sessionStorage' && 'sessionStorage'in window && 'setItem'in window.sessionStorage) {
                window.sessionStorage.setItem(name, JSON.stringify(value))
            } else if (method == 'localStorage' && 'localStorage'in window && 'setItem'in window.localStorage) {
                window.localStorage.setItem(name, JSON.stringify(value))
            } else {
                var chunks = [name + '=' + this.encodeCookieValue(value), ];
                var domain = this.getBaseDomain(location.hostname);
                if (domain) {
                    chunks.push('domain=' + domain)
                }
                if (options.path) {
                    chunks.push('path=' + options.path)
                }
                if (options.expires) {
                    chunks.push('expires=' + options.expires)
                }
                if (options.sameSite) {
                    chunks.push('SameSite=' + options.sameSite)
                } else {
                    chunks.push('SameSite=Lax')
                }
                if (options.secure) {
                    chunks.push('Secure')
                }
                document.cookie = chunks.join(';')
            }
        },
        encodeCookieValue: function(value) {
            return encodeURIComponent(btoa(JSON.stringify(value)))
        },
        decodeCookieValue: function(value) {
            return JSON.parse(atob(decodeURIComponent(value)))
        },
        isBotBrowser: function() {
            return /(bot\b|BOT\b|Bot\b|BingPreview| \(\+http)|[a-z]-Google\b/.test(navigator.userAgent)
        },
        isDoNotTrackEnabledInBrowser: function() {
            return window.doNotTrack && window.doNotTrack == 1 || navigator.doNotTrack && [1, '1', 'yes'].includes(navigator.doNotTrack) || navigator.msDoNotTrack && navigator.msDoNotTrack == 1 || typeof window.external === 'object' && 'msTrackingProtectionEnabled'in window.external && window.external.msTrackingProtectionEnabled() || !1
        },
        ajax: function(url, options) {
            options = typeof options === 'object' ? options : {};
            var body = options.body;
            var async = typeof options.async === 'boolean' ? options.async : !0;
            var method = options.method || 'GET';
            var xhr = new XMLHttpRequest();
            var self = this;
            xhr.onreadystatechange = function() {
                if (this.readyState == 4) {
                    (this.status >= 200 && this.status <= 205) ? typeof options.success === 'function' && options.success.call(self, this.responseText, this.status, xhr) : typeof options.failure === 'function' && options.failure.call(self, this.status, xhr);
                    typeof options.done === 'function' && options.done.call(self)
                }
            }
            ;
            xhr.open(method, url, async);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            if (['POST', 'PUT', 'PATCH'].includes(method)) {
                var contentType = options.contentType || 'application/x-www-form-urlencoded';
                if (contentType === 'application/json') {
                    body = JSON.stringify(body)
                }
                xhr.setRequestHeader('Content-Type', contentType)
            }
            if ('headers'in options) {
                for (var key in options.headers) {
                    xhr.setRequestHeader(key, options.headers[key] + '')
                }
            }
            xhr.send(body)
        },
        injectCss: function() {
            this.cssFiles.forEach(function(url) {
                var link = document.createElement('LINK');
                link.setAttribute('href', url);
                link.setAttribute('rel', 'stylesheet');
                link.setAttribute('type', 'text/css');
                document.head.appendChild(link)
            })
        },
        injectJs: function() {
            this.jsFiles.forEach(function(url) {
                var script = document.createElement('SCRIPT');
                script.setAttribute('src', url);
                script.setAttribute('data-ccm-injected', 'true');
                document.head.appendChild(script)
            })
        },
        initPlatformDependentComponents: function() {
            var dummy = document.createElement('DIV');
            dummy.style.boxSizing = 'border-box';
            dummy.style.display = 'block';
            dummy.style.position = 'fixed';
            dummy.style.top = '-9999px';
            dummy.style.left = '-9999px';
            dummy.style.width = '320px';
            dummy.style.height = '240px';
            dummy.style.visibility = 'hidden';
            dummy.style.overflowX = 'scroll';
            dummy.style.overflowY = 'scroll';
            document.body.appendChild(dummy);
            var scrollbarWidth = dummy.offsetWidth - dummy.clientWidth;
            var scrollbarHeight = dummy.offsetHeight - dummy.clientHeight;
            document.body.removeChild(dummy);
            document.documentElement.style.setProperty('--ccm--scrollbar-width', scrollbarWidth + 'px');
            document.documentElement.style.setProperty('--ccm--scrollbar-height', scrollbarHeight + 'px')
        },
        executeScriptQueue: function(scriptNodes, component) {
            var self = this;
            var interrupt = !1;
            scriptNodes.forEach(function(script, index) {
                if (interrupt) {
                    return
                }
                var original = script.ccmOriginalNode || script;
                var src = (script.type == 'text/x-ccm-loader' && script.dataset.ccmLoaderSrc) || script.src;
                if (script.type == 'text/x-ccm-loader') {
                    script.removeAttribute('type');
                    if (src) {
                        script.removeAttribute('data-ccm-loader-src');
                        script.setAttribute('src', src)
                    }
                }
                if (script.hasAttribute('src')) {
                    var clone = document.createElement('SCRIPT');
                    clone.setAttribute('data-ccm-injected', 'true');
                    toArray(script.attributes).forEach(function(attr) {
                        clone.setAttribute(attr.name, attr.value)
                    });
                    clone.async = script.async;
                    if (!script.async) {
                        var resumeScriptQueue = function() {
                            self.executeScriptQueue(scriptNodes.slice(index + 1), component)
                        };
                        clone.addEventListener('error', resumeScriptQueue);
                        clone.addEventListener('load', resumeScriptQueue);
                        interrupt = !0
                    }
                    for (var root = original.parentElement; root && root !== document.documentElement; root = root.parentElement)
                        ;
                    if (root) {
                        original.parentElement.insertBefore(clone, original);
                        original.parentElement.removeChild(original)
                    } else if (document.body) {
                        document.body.appendChild(clone)
                    } else {
                        document.head.appendChild(clone)
                    }
                } else {
                    try {
                        self.inEval = !0;
                        if (Utils.isJavaScript(script)) {
                            eval.call(window, script.textContent)
                        }
                        self.inEval = !1
                    } catch (error) {
                        self.inEval = !1;
                        console.error('[CCM19] Script execution: (' + error.name + ') ' + error.message)
                    }
                }
            });
            if (!interrupt && component == 'ScriptLoader') {
                this.scriptLoaderRunning = !1;
                this.executeScriptLoaderQueue()
            }
        },
        executeScriptLoaderQueue: function() {
            if (this.scriptLoaderRunning || this.scriptLoaderQueue.length == 0) {
                return
            }
            this.scriptLoaderRunning = !0;
            var scriptQueue = this.scriptLoaderQueue;
            this.scriptLoaderQueue = [];
            this.executeScriptQueue(scriptQueue, 'ScriptLoader')
        },
        isEmbeddingActiveForCurrentLocation: function(embedding) {
            return embedding.excludeUrls.reduce(function(block, url) {
                var isWildcard = url.charAt(url.length - 1) == '*';
                url = isWildcard ? url.substr(0, url.length - 1) : url;
                return block || location.href.indexOf(url) == 0 && (isWildcard || location.href.length == url.length)
            }, !1) == (embedding.excludeUrlsMode == "whitelist")
        },
        embedEmbedding: function(embedding) {
            var self = this;
            if (this.embeddingsEmbedded.includes(embedding.id)) {
                return
            }
            this.embeddingsEmbedded.push(embedding.id);
            if (this.isEmbeddingActiveForCurrentLocation(embedding) == !1) {
                return
            }
            var container = document.createElement('DIV');
            container.innerHTML = embedding.code;
            var scriptQueue = [];
            while (container.children.length > 0) {
                var child = container.removeChild(container.firstElementChild);
                if (child.tagName === 'SCRIPT') {
                    scriptQueue.push(child)
                } else {
                    document.body.appendChild(child)
                }
            }
            Utils.triggerCustomEvent(window, 'ccm19EmbeddingAccepted', {
                name: embedding.name,
                code: embedding.code,
                purpose: embedding.purpose,
                mandatory: embedding.mandatory,
            });
            Utils.triggerGTMEvent('CCM19.embeddingAccepted', {
                id: embedding.id,
                name: embedding.name,
            });
            this.blockableScripts.forEach(function(node) {
                if (!node.ccmEmbeddings || !node.ccmEmbeddings.includes(embedding.id)) {
                    return
                }
                var shouldActivate = node.ccmEmbeddings.reduce(function(result, embeddingId) {
                    return result && self.embeddingsEmbedded.includes(embeddingId)
                }, !0);
                if (shouldActivate) {
                    scriptQueue.push(node)
                }
            });
            var selectedEmbeddingIds = this.getEmbeddingsWithConsent().map(function(embedding) {
                return embedding.id
            });
            this.iframes.forEach(function(iframe) {
                var blockedByEmbeddings = iframe.ccm19BlockedByEmbeddings || [];
                if (blockedByEmbeddings.length > 0) {
                    var restoreIframe = blockedByEmbeddings.reduce(function(restore, embeddingId) {
                        return restore && selectedEmbeddingIds.includes(embeddingId)
                    }, !0);
                    if (restoreIframe) {
                        self.restoreIframe(iframe)
                    }
                }
            });
            scriptQueue = scriptQueue.filter(function(script) {
                return !script.async && !script.defer
            }).concat(scriptQueue.filter(function(script) {
                return !script.async && script.defer
            })).concat(scriptQueue.filter(function(script) {
                return script.async
            }));
            this.executeScriptQueue(scriptQueue)
        },
        jumpTo: function(id, event) {
            event = event || window.event;
            event.preventDefault();
            var currentId = window.location.hash.replace(/^#/, '');
            window.location.hash = id;
            if (currentId != id) {
                history.back && history.back()
            }
            window.requestAnimationFrame(function() {
                var el = document.getElementById(id);
                el && el.scrollIntoView && el.scrollIntoView()
            })
        },
        onFocusIn: function(event) {
            var openModals = document.querySelectorAll('.ccm-root > .ccm-modal.ccm-show');
            var container = openModals[openModals.length - 1];
            if (!container) {
                return
            }
            if (this._ignoreFocused && this._ignoreFocused === event.target) {
                return
            }
            var fromContainer = Utils.getContainingModal(event.relatedTarget);
            var nextContainer = Utils.getContainingModal(event.target);
            if (nextContainer !== container) {
                var focusable = Utils.focusableElements(container);
                var innerContainer = container.querySelector('.ccm-modal-inner');
                var firstFocusable = focusable[0];
                var lastFocusable = focusable[focusable.length - 1];
                var topFocusHelper = document.getElementById('ccm-focus-helper--top');
                var bottomFocusHelper = document.getElementById('ccm-focus-helper--bottom');
                if (lastFocusable == event.relatedTarget || event.target === topFocusHelper) {
                    firstFocusable.focus();
                    if (innerContainer) {
                        innerContainer.focus()
                    }
                    event.preventDefault()
                } else if (firstFocusable == event.relatedTarget || event.relatedTarget === innerContainer || event.target === bottomFocusHelper) {
                    lastFocusable.focus();
                    event.preventDefault()
                } else if (fromContainer === container) {
                    event.relatedTarget.focus();
                    event.preventDefault()
                } else {
                    firstFocusable.focus();
                    event.preventDefault()
                }
            }
        },
        onTabKeyDown: function(event) {
            if (event.keyCode !== 9) {
                return
            }
            var openModals = document.querySelectorAll('.ccm-root > .ccm-modal.ccm-show');
            var container = openModals[openModals.length - 1];
            if (!container) {
                return
            }
            var innerContainer = container.querySelector('.ccm-modal-inner');
            var focusable = Utils.focusableElements(container);
            if (event.shiftKey && (event.target == focusable[0] || event.target == innerContainer)) {
                var newTarget = document.getElementById('ccm-focus-helper--top');
                this._ignoreFocused = newTarget;
                newTarget.focus({
                    preventScroll: !0
                });
                this._ignoreFocused = null
            } else if (!event.shiftKey && event.target == focusable[focusable.length - 1]) {
                var newTarget = document.getElementById('ccm-focus-helper--bottom');
                this._ignoreFocused = newTarget;
                newTarget.focus({
                    preventScroll: !0
                });
                this._ignoreFocused = null
            }
        },
        onSettingsIconClicked: function(event) {
            event = event || window.event;
            event.preventDefault();
            this.logOpenData();
            this.hideSettingsIcon();
            switch (this.settingsIconTarget) {
            case 'main':
                this.openWidget();
                break;
            case 'purpose':
            default:
                this.openControlPanel();
                break
            }
        },
        showSettingsIcon: function() {
            if (this.settingsIconEnabled == !1 || this.isActive == !1) {
                return
            }
            toArray(this.container.querySelectorAll('.ccm-settings-summoner')).forEach(function(element) {
                element.classList.remove('ccm-hide');
                element.classList.add('ccm-show')
            })
        },
        hideSettingsIcon: function() {
            if (this.settingsIconEnabled == !1) {
                return
            }
            toArray(this.container.querySelectorAll('.ccm-settings-summoner')).forEach(function(element) {
                element.classList.remove('ccm-show');
                element.classList.add('ccm-hide')
            })
        },
        updateBlocking: function() {
            var activeModals = this.getActiveModals();
            var isBlocking = activeModals.reduce(function(isBlocking, modal) {
                return isBlocking || modal.classList.contains('ccm--is-blocking')
            }, !1);
            Utils.toggleClass(document.documentElement, 'ccm-blocked', isBlocking);
            Utils.toggleClass(document.body, 'ccm-blocked', isBlocking);
            activeModals.length > 0 ? this.hideSettingsIcon() : this.showSettingsIcon()
        },
        isModalActive: function() {
            return toArray(this.container.getElementsByClassName('ccm-modal')).reduce(function(active, modal) {
                return active || modal.classList.contains('ccm-show')
            }, !1)
        },
        getActiveModals: function() {
            return toArray(this.container.getElementsByClassName('ccm-modal')).filter(function(modal) {
                return modal.classList.contains('ccm-show')
            }, !1)
        },
        showModal: function(target, updateBlocking) {
            if (target == null || target.classList.contains('ccm-modal') == !1) {
                return
            }
            this.focusStack.push(window.event ? window.event.currentTarget : window.activeElement);
            toArray(target.querySelectorAll('div.ccm--h1')).forEach(function(el) {
                el.setAttribute('role', 'heading');
                el.setAttribute('aria-level', '1')
            });
            toArray(target.querySelectorAll('div.ccm--h2')).forEach(function(el) {
                el.setAttribute('role', 'heading');
                el.setAttribute('aria-level', '2')
            });
            toArray(target.querySelectorAll('div.ccm--h3')).forEach(function(el) {
                el.setAttribute('role', 'heading');
                el.setAttribute('aria-level', '3')
            });
            updateBlocking = typeof updateBlocking == 'boolean' ? updateBlocking : !0;
            if (target.classList.contains('ccm-details')) {
                var ucidShort = this.getUniqueCookieId().substr(0, 16);
                toArray(target.getElementsByClassName('ccm-user-info--ucid--value')).forEach(function(element) {
                    element.textContent = ucidShort
                })
            }
            if (this.isModalActive() == !1) {
                Utils.triggerCustomEvent(window, 'ccm19WidgetOpened')
            }
            target.classList.add('ccm-show');
            target.setAttribute('aria-hidden', 'false');
            target.style.display = '';
            Utils.enableButtons(target);
            if (updateBlocking) {
                this.updateBlocking()
            }
            if (document.body.classList.contains('ccm-blocked')) {
                this.captureFocus()
            }
            var hashMatch = location.hash.match(/^#[a-z0-9-]+$/)
            var primaryElement = ((hashMatch ? target.querySelector(hashMatch) : null) || target.querySelector('[role="document"][tabindex]') || target.getElementsByClassName('ccm--button-primary')[0] || target.getElementsByClassName('ccm-modal--close')[0]);
            if (primaryElement) {
                if (primaryElement.tabIndex == -1) {
                    var focusableChild = Utils.focusableElements(primaryElement)[0];
                    if (focusableChild) {
                        primaryElement = focusableChild
                    }
                }
                primaryElement.focus()
            } else {
                target.focus()
            }
        },
        loadModal: function(id, show, jumpTo) {
            show = typeof show == 'boolean' ? show : !0;
            var target = document.getElementById(id);
            if (target) {
                if (show) {
                    this.showModal(target);
                    if (jumpTo) {
                        window.requestAnimationFrame(function() {
                            var el = document.getElementById(jumpTo);
                            el && el.scrollIntoView && el.scrollIntoView()
                        })
                    }
                }
                return
            }
            var url = {
                'ccm-details': this.detailsUrls[this.locale],
            }[id];
            if (!url) {
                return
            }
            if (this.loadingModal) {
                return
            }
            this.loadingModal = !0;
            document.documentElement.classList.add('ccm--is-loading');
            this.ajax(url, {
                method: 'GET',
                success: function(response) {
                    var temp = document.createElement('DIV');
                    temp.innerHTML = response;
                    while (temp.children.length > 0) {
                        this.container.appendChild(temp.removeChild(temp.firstElementChild))
                    }
                    this.registerControls();
                    this.presetConsentState();
                    var target = document.getElementById(id);
                    if (target && show) {
                        this.showModal(target);
                        if (jumpTo) {
                            window.requestAnimationFrame(function() {
                                var el = document.getElementById(jumpTo);
                                el && el.scrollIntoView && el.scrollIntoView()
                            })
                        }
                    }
                },
                failure: function(code) {
                    console.warn('[CCM19] Error while loading modal "' + id + '". (' + code + ')')
                },
                done: function() {
                    this.loadingModal = !1;
                    document.documentElement.classList.remove('ccm--is-loading')
                },
            })
        },
        hideModal: function(target, updateBlocking) {
            if (target == null || target.classList.contains('ccm-modal') == !1) {
                return
            }
            updateBlocking = typeof updateBlocking == 'boolean' ? updateBlocking : !0;
            var wasOpen = target.classList.contains('ccm-show');
            target.classList.remove('ccm-show');
            target.setAttribute('aria-hidden', 'true');
            target.style.display = 'none';
            Utils.disableButtons(target);
            if (wasOpen && this.isModalActive() == !1) {
                Utils.triggerCustomEvent(window, 'ccm19WidgetClosed')
            }
            toArray(target.querySelectorAll('div.ccm--h1,div.ccm--h21,div.ccm--h3')).forEach(function(el) {
                el.removeAttribute('role');
                el.removeAttribute('aria-level')
            });
            if (updateBlocking) {
                this.updateBlocking()
            }
            if (!document.body.classList.contains('ccm-blocked')) {
                this.endCaptureFocus()
            }
            try {
                if (this.focusStack.length) {
                    this.focusStack.pop().focus()
                }
            } catch (e) {}
        },
        closeAllModals: function() {
            var self = this;
            toArray(this.container.getElementsByClassName('ccm-modal')).forEach(function(modal) {
                self.hideModal.call(self, modal, !1)
            });
            this.updateBlocking()
        },
        openControlPanel: function() {
            this.showModal(this.controlPanel)
        },
        closeControlPanel: function() {
            this.hideModal(this.controlPanel)
        },
        openWidget: function() {
            if (this.isActive) {
                this.showModal(this.widget)
            }
        },
        closeWidget: function() {
            this.hideModal(this.widget)
        },
        onModalCloseButtonClicked: function(event) {
            event = event || window.event;
            var target = event.target;
            while (target !== null && target.classList.contains('ccm-modal') == !1) {
                target = target.parentElement
            }
            this.hideModal(target)
        },
        switchLocale: function(locale) {
            if (locale in this.widgetUrls) {
                this.locale = locale;
                this.widgetUrl = this.widgetUrls[locale];
                if (this.widget) {
                    this.widget.classList.add('ccm-widget--loading')
                }
                this.forceOpenWidget = this.isModalActive();
                this.build();
                this.insertCookieDeclaration()
            } else {
                console.error('[CCM19] Could not switch to unknown locale "' + locale + '"')
            }
        },
        dismissTemporarily: function() {
            if (!this.consentGiven()) {
                var embeddingIds = [];
                var tcf = {};
                this.saveSettingsInternal(this.getUniqueCookieId(), !0, embeddingIds, tcf, 'temporary')
            }
            this.closeAllModals()
        },
        getEmbeddingsWithConsent: function(hasConsent) {
            hasConsent = typeof hasConsent == 'boolean' ? hasConsent : !0;
            return this.repository.filter(function(embedding) {
                return embedding.consent == hasConsent
            })
        },
        getPurposeCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-purpose]')).filter(function(item) {
                return !item.dataset.embedding
            })
        },
        getEmbeddingCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-embedding]'))
        },
        selectAllPurposes: function() {
            this.setAllPurposes(!0)
        },
        selectPurpose: function(purposeId, newState) {
            newState = newState == 'partial' ? newState : (typeof newState == 'boolean' ? newState : !0);
            var purposes = this.getPurposeCheckboxes();
            purposes.forEach(function(purpose) {
                if (purpose.dataset.purpose == purposeId) {
                    purpose.checked = !!newState;
                    purpose.indeterminate = newState == 'partial'
                }
            });
            if (typeof newState == 'boolean') {
                this.getEmbeddingCheckboxes().forEach(function(embedding) {
                    if (embedding.dataset.purpose == purposeId) {
                        embedding.checked = newState;
                        embedding.indeterminate = !1
                    }
                })
            }
        },
        selectEmbedding: function(embedding) {
            this.getEmbeddingCheckboxes().forEach(function(checkbox) {
                if (checkbox.dataset.embedding == embedding.id) {
                    checkbox.checked = embedding.consent
                }
            });
            var newPurposeState = this.repository.reduce(function(newState, currentEmbedding) {
                if (currentEmbedding.purpose == embedding.purpose) {
                    if (newState === !0) {
                        newState = currentEmbedding.consent || 'partial'
                    } else {
                        newState = currentEmbedding.consent ? 'partial' : newState
                    }
                }
                return newState
            }, embedding.consent);
            this.selectPurpose(embedding.purpose, newPurposeState)
        },
        selectedPurposes: function() {
            var purposes = this.getPurposeCheckboxes();
            var selectedPurposes = purposes.filter(function(purpose) {
                return purpose.checked || purpose.dataset.purposeMandatory == 'true'
            }).map(function(purpose) {
                return purpose.dataset.purpose
            });
            return selectedPurposes.filter(function(purposeId, index, array) {
                if (!array || typeof array != 'object' || 'indexOf'in array == !1) {
                    array = selectedPurposes
                }
                return array.indexOf(purposeId) == index
            })
        },
        selectedEmbeddings: function() {
            var self = this;
            var embeddings = [];
            this.getEmbeddingCheckboxes().forEach(function(checkbox) {
                var embeddingId = checkbox.dataset.embedding;
                var isSelected = checkbox.checked || checkbox.dataset.purposeMandatory == 'true';
                var embedding = self.repository[embeddingId];
                if (!self.repository[embeddingId]) {} else if (isSelected && embeddings.includes(embedding) == !1) {
                    embeddings.push(embedding)
                }
            });
            return embeddings
        },
        getTcfPurposesCategoryCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group="tcf-p"]'))
        },
        getTcfPurposesCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group-parent="tcf-p"]'))
        },
        selectAllTcfPurposes: function() {
            for (var id in this.consentState.tcfPurposes) {
                this.consentState.tcfPurposes[id] = !0
            }
            this.getTcfPurposesCheckboxes().concat(this.getTcfPurposesCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !0;
                checkbox.indeterminate = !1
            })
        },
        resetAllTcfPurposes: function() {
            for (var id in this.consentState.tcfPurposes) {
                this.consentState.tcfPurposes[id] = !1
            }
            this.getTcfPurposesCheckboxes().concat(this.getTcfPurposesCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !1;
                checkbox.indeterminate = !1
            })
        },
        selectedTcfPurposes: function() {
            var self = this;
            return Object.keys(this.consentState.tcfPurposes).filter(function(id) {
                return self.consentState.tcfPurposes[id]
            }).map(function(id) {
                return parseInt(id)
            }).sort(function(a, b) {
                return a - b
            })
        },
        presetTcfPurposes: function() {
            var tcf = this.getTcfConsentInfo();
            this.resetAllTcfPurposes();
            var self = this;
            tcf.p.forEach(function(purposeId) {
                self.consentState.tcfPurposes[purposeId] = !0
            });
            var checkboxes = this.getTcfPurposesCheckboxes();
            checkboxes.forEach(function(checkbox) {
                var purposeId = parseInt(checkbox.value);
                checkbox.checked = tcf.p.includes(purposeId)
            });
            var newGroupState = Utils.partial(Object.values(this.consentState.tcfPurposes));
            this.getTcfPurposesCategoryCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !!newGroupState;
                checkbox.indeterminate = newGroupState == 'partial'
            })
        },
        getTcfSpecialFeatureCategoryCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group="tcf-sf"]'))
        },
        getTcfSpecialFeatureCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group-parent="tcf-sf"]'))
        },
        selectAllTcfSpecialFeatures: function() {
            for (var id in this.consentState.tcfSpecialFeatures) {
                this.consentState.tcfSpecialFeatures[id] = !0
            }
            this.getTcfSpecialFeatureCheckboxes().concat(this.getTcfSpecialFeatureCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !0;
                checkbox.indeterminate = !1
            })
        },
        resetAllTcfSpecialFeatures: function() {
            for (var id in this.consentState.tcfSpecialFeatures) {
                this.consentState.tcfSpecialFeatures[id] = !1
            }
            this.getTcfSpecialFeatureCheckboxes().concat(this.getTcfSpecialFeatureCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !1;
                checkbox.indeterminate = !1
            })
        },
        selectedTcfSpecialFeatures: function() {
            var self = this;
            return Object.keys(this.consentState.tcfSpecialFeatures).filter(function(id) {
                return self.consentState.tcfSpecialFeatures[id]
            }).map(function(id) {
                return parseInt(id)
            }).sort(function(a, b) {
                return a - b
            })
        },
        presetTcfSpecialFeatures: function() {
            var tcf = this.getTcfConsentInfo();
            this.resetAllTcfSpecialFeatures();
            var self = this;
            tcf.sf.forEach(function(featureId) {
                self.consentState.tcfSpecialFeatures[featureId] = !0
            });
            var checkboxes = this.getTcfSpecialFeatureCheckboxes();
            checkboxes.forEach(function(checkbox) {
                var featureId = parseInt(checkbox.value);
                checkbox.checked = tcf.sf.includes(featureId)
            });
            var newGroupState = Utils.partial(Object.values(this.consentState.tcfSpecialFeatures));
            this.getTcfSpecialFeatureCategoryCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !!newGroupState;
                checkbox.indeterminate = newGroupState == 'partial'
            })
        },
        getTcfVendorCategoryCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group="tcf-gvl"]'))
        },
        getTcfVendorCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group-parent="tcf-gvl"][data-switch-group^="tcf-gvl"]'))
        },
        selectAllTcfVendors: function() {
            for (var id in this.consentState.tcfVendors) {
                this.consentState.tcfVendors[id] = !0
            }
            this.getTcfVendorCheckboxes().concat(this.getTcfVendorCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !0;
                checkbox.indeterminate = !1
            })
        },
        resetAllTcfVendors: function() {
            for (var id in this.consentState.tcfVendors) {
                this.consentState.tcfVendors[id] = !1
            }
            this.getTcfVendorCheckboxes().concat(this.getTcfVendorCategoryCheckboxes()).forEach(function(checkbox) {
                checkbox.checked = !1;
                checkbox.indeterminate = !1
            })
        },
        selectedTcfVendors: function() {
            var self = this;
            return Object.keys(this.consentState.tcfVendors).filter(function(id) {
                return self.consentState.tcfVendors[id]
            }).map(function(id) {
                return parseInt(id)
            }).sort(function(a, b) {
                return a - b
            })
        },
        presetTcfVendors: function() {
            var tcf = this.getTcfConsentInfo();
            this.resetAllTcfVendors();
            var self = this;
            tcf.v.forEach(function(vendorId) {
                self.consentState.tcfVendors[vendorId] = !0
            });
            var checkboxes = this.getTcfVendorCheckboxes();
            checkboxes.forEach(function(checkbox) {
                var vendorId = parseInt(checkbox.value);
                checkbox.checked = tcf.v.includes(vendorId)
            });
            var newGroupState = Utils.partial(Object.values(this.consentState.tcfVendors).concat(Object.values(this.consentState.googleAdTechProviders)));
            this.getTcfVendorCategoryCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !!newGroupState;
                checkbox.indeterminate = newGroupState == 'partial'
            })
        },
        getGoogleProviderCheckboxes: function() {
            return toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group-parent="tcf-gvl"][data-switch-group^="gad"]'))
        },
        selectAllGoogleProviders: function() {
            for (var id in this.consentState.googleAdTechProviders) {
                this.consentState.googleAdTechProviders[id] = !0
            }
            this.getGoogleProviderCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !0;
                checkbox.indeterminate = !1
            })
        },
        resetAllGoogleProviders: function() {
            for (var id in this.consentState.googleAdTechProviders) {
                this.consentState.googleAdTechProviders[id] = !1
            }
            this.getGoogleProviderCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !1;
                checkbox.indeterminate = !1
            })
        },
        selectedGoogleProviders: function() {
            var self = this;
            return Object.keys(this.consentState.googleAdTechProviders).filter(function(id) {
                return self.consentState.googleAdTechProviders[id]
            }).map(function(id) {
                return parseInt(id)
            }).sort(function(a, b) {
                return a - b
            })
        },
        presetGoogleProviders: function() {
            var tcf = this.getTcfConsentInfo();
            var gad = ('gad'in tcf && tcf.gad) ? tcf.gad : [];
            this.resetAllGoogleProviders();
            var self = this;
            gad.forEach(function(providerId) {
                self.consentState.googleAdTechProviders[providerId] = !0
            });
            var checkboxes = this.getGoogleProviderCheckboxes();
            checkboxes.forEach(function(checkbox) {
                var providerId = parseInt(checkbox.value);
                checkbox.checked = gad.includes(providerId)
            });
            var newGroupState = Utils.partial(Object.values(this.consentState.tcfVendors).concat(Object.values(this.consentState.googleAdTechProviders)));
            this.getTcfVendorCategoryCheckboxes().forEach(function(checkbox) {
                checkbox.checked = !!newGroupState;
                checkbox.indeterminate = newGroupState == 'partial'
            })
        },
        loadScripts: function(limitToTechnicallyNecessary) {
            limitToTechnicallyNecessary = typeof limitToTechnicallyNecessary == 'boolean' ? limitToTechnicallyNecessary : !1;
            if (limitToTechnicallyNecessary && this.runMandatoryEmbeddingsWithoutConsent == !1) {
                return
            }
            var self = this;
            var selectedEmbeddings = this.getEmbeddingsWithConsent();
            selectedEmbeddings.forEach(function(embedding) {
                if (limitToTechnicallyNecessary == !1 || embedding.mandatory) {
                    self.embedEmbedding(embedding)
                }
            });
            if (limitToTechnicallyNecessary) {
                return
            }
            var eventData = {
                initialConsent: !this.consentGiven(),
            };
            var googleConsentMode = {};
            var googleConsentModeUsed = !1;
            for (var embeddingId in this.repository) {
                var embedding = this.repository[embeddingId];
                var selected = eventData['ccm19_' + embedding.name] = selectedEmbeddings.reduce(function(isSelected, selectedEmbedding) {
                    return isSelected || embedding.id == selectedEmbedding.id
                }, !1);
                if (embedding.gcm) {
                    googleConsentModeUsed = !0;
                    if (selected) {
                        for (var i = 0; i < embedding.gcm.length; ++i) {
                            googleConsentMode[embedding.gcm[i]] = 'granted'
                        }
                    } else {
                        for (var i = 0; i < embedding.gcm.length; ++i) {
                            if (googleConsentMode[embedding.gcm[i]] === undefined) {
                                googleConsentMode[embedding.gcm[i]] = 'denied'
                            }
                        }
                    }
                }
            }
            if (googleConsentModeUsed) {
                Utils.sendGTag('consent', 'update', googleConsentMode)
            }
            Utils.triggerGTMEvent('CCM19.consentStateChanged', eventData);
            this.cleanUpClientStorage(!0);
            this.showSettingsIcon()
        },
        getUniqueCookieId: function() {
            var storage = this.getConsentStorage();
            return storage.ucid || this.ucid
        },
        getConsentLanguage: function() {
            var storage = this.getConsentStorage();
            return storage.lang || ''
        },
        expandIdRanges: function(ranges) {
            var result = [];
            var l = ranges.length;
            for (var i = 1; i < l; i += 2) {
                var start = ranges[i - 1];
                var end = ranges[i];
                for (var j = start; j <= end; ++j) {
                    result.push(j)
                }
            }
            return result
        },
        makeIdRanges: function(ids) {
            if (ids.length == 0) {
                return []
            }
            var result = [];
            var l = ids.length;
            var currentStart = ids[0];
            var current = ids[0];
            for (var i = 1; i <= l; ++i) {
                var id = ids[i];
                if (id == current + 1) {
                    current = id
                } else {
                    result.push(currentStart);
                    result.push(current);
                    currentStart = current = id
                }
            }
            result.push(currentStart);
            result.push(current);
            return result
        },
        getTcfConsentInfo: function() {
            var storage = this.getConsentStorage();
            var tcf = storage.tcf || {};
            tcf.p = Array.isArray(tcf.p) ? tcf.p : [];
            tcf.sf = Array.isArray(tcf.sf) ? tcf.sf : [];
            if (Array.isArray(tcf.vr)) {
                tcf.v = this.expandIdRanges(tcf.vr)
            } else {
                tcf.v = Array.isArray(tcf.v) ? tcf.v : []
            }
            tcf.gad = Array.isArray(tcf.gad) ? tcf.gad : [];
            tcf.created = 'created'in storage ? storage.created : null;
            tcf.updated = 'updated'in storage ? storage.updated : null;
            return tcf
        },
        logOpenData: function() {
            this.ajax(this.statisticsUrl, {
                method: 'POST',
                contentType: 'application/json',
                body: {
                    ucid: this.getUniqueCookieId(),
                    lang: document.getElementById('ccm-widget').lang,
                    clientUserAgent: navigator.userAgent,
                    clientOs: navigator.platform,
                    clientLang: navigator.language,
                    actualUrl: window.location.href,
                    actualRef: document.referrer,
                    actualOpened: 1
                }
            })
        },
        logConsentSettings: function() {
            var storage = this.getConsentStorage();
            var tcf = this.getTcfConsentInfo();
            tcf.created = tcf.created ? Math.round(tcf.created / 10) : null;
            tcf.updated = tcf.updated ? Math.round(tcf.updated / 10) : null;
            this.ajax(this.statisticsUrl, {
                method: 'POST',
                contentType: 'application/json',
                body: {
                    ucid: this.getUniqueCookieId(),
                    consent: storage.consent,
                    clickedButton: this.clickedButton,
                    purposes: this.selectedPurposes(),
                    embeddings: this.getEmbeddingsWithConsent().map(function(embedding) {
                        return embedding.id
                    }),
                    iframeConsentDomains: storage.iframeConsentDomains,
                    tcf: tcf,
                    lang: document.getElementById('ccm-widget').lang,
                    clientUserAgent: navigator.userAgent,
                    clientOs: navigator.platform,
                    clientLang: navigator.language,
                    clientWidth: window.innerWidth,
                    clientHeight: window.innerHeight,
                    actualUrl: window.location.href,
                    actualRef: document.referrer,
                    actualOpened: 0
                },
                done: function() {
                    var message = {
                        realm: 'CCM19',
                        type: 'ConsentSharing',
                        action: 'consent',
                        ucid: this.getUniqueCookieId(),
                        consent: this.consentGiven(),
                        embeddings: this.getAllowedEmbeddingIds(),
                        domain: this.domainId,
                    };
                    this.consentShareChannels.forEach(function(item) {
                        try {
                            var origin = (item.origin !== undefined) ? item.origin : null;
                            item.channel.postMessage(message, origin)
                        } catch (e) {}
                    }
                    .bind(this))
                },
            })
        },
        getConsentStorage: function() {
            var storage = this.getCookie(this.cookies.consent) || {};
            var hasNamespace = Object.keys(storage).reduce(function(carry, property) {
                return carry || String(property).indexOf('/') == 0
            }, !1);
            if (storage[this.storageNamespace]) {
                storage = storage[this.storageNamespace]
            } else if (hasNamespace) {
                storage = {}
            }
            return typeof storage == 'object' ? storage : {}
        },
        saveSettings: function(logSettings) {
            logSettings = typeof logSettings == 'boolean' ? logSettings : !0;
            var embeddingIds = this.getEmbeddingsWithConsent().map(function(embedding) {
                return embedding.id
            });
            var tcf = {
                p: this.selectedTcfPurposes(),
                sf: this.selectedTcfSpecialFeatures(),
                v: this.selectedTcfVendors(),
                gad: this.selectedGoogleProviders(),
            };
            this.saveSettingsInternal(this.getUniqueCookieId(), !0, embeddingIds, tcf);
            if (logSettings) {
                this.logConsentSettings()
            }
            this.closeAllModals()
        },
        saveSettingsInternal: function(ucid, consent, embeddingIds, tcf, mode) {
            var storage = this.getConsentStorage();
            var options = {
                path: '/',
            };
            tcf = typeof tcf == 'object' && 'sf'in tcf ? tcf : {
                p: [],
                sf: [],
                v: [],
            };
            var vr = this.makeIdRanges(tcf.v);
            if (vr.length < tcf.v.length) {
                tcf.vr = vr;
                delete tcf.v
            } else if ('vr'in tcf) {
                delete tcf.vr
            }
            if (this.cookieLifetime > 0) {
                options.expires = new Date(Date.now() + (this.cookieLifetime * 86400000)).toUTCString()
            }
            options.secure = (this.cookieUseSecure && location.protocol == 'https:');
            var timestamp = Math.round((new Date()).getTime() / 100);
            if (mode == 'temporary') {
                options.method = 'sessionStorage'
            }
            storage.gen = 2;
            storage.ucid = ucid;
            storage.consent = consent;
            storage.embeddings = embeddingIds;
            storage.created = ('created'in storage) ? storage.created : timestamp;
            storage.updated = timestamp;
            storage.iframeConsentDomains = this.iframeConsentDomains;
            storage.tcf = tcf;
            storage.lang = document.getElementById('ccm-widget').lang;
            var fullStorage = this.getCookie(this.cookies.consent) || {};
            fullStorage[this.storageNamespace] = storage;
            this.setCookie(this.cookies.consent, fullStorage, options);
            this.setPurposesAndEmbeddings(embeddingIds);
            this.loadScripts()
        },
        grantAllPrivileges: function() {
            this.selectAllPurposes();
            this.selectAllTcfPurposes();
            this.selectAllTcfSpecialFeatures();
            this.selectAllGoogleProviders();
            this.selectAllTcfVendors()
        },
        revokeAllPrivileges: function() {
            this.setAllPurposes(!1);
            this.resetAllTcfPurposes();
            this.resetAllTcfSpecialFeatures();
            this.resetAllGoogleProviders();
            this.resetAllTcfVendors()
        },
        onConsentButtonClicked: function(event) {
            event = event || window.event;
            var button = event.target;
            var trusted = ('isTrusted'in event) ? event.isTrusted : !0;
            if (!trusted) {
                console.warn('[CCM19] Manipulated click on consent button detected and ignored.');
                return
            }
            if (button.dataset.fullConsent == 'true') {
                this.grantAllPrivileges()
            }
            this.clickedButton = "acceptAll";
            this.saveSettings()
        },
        onDeclineButtonClicked: function(event) {
            event = event || window.event;
            var button = event.target;
            this.clickedButton = "decline";
            this.revokeAllPrivileges();
            this.saveSettings()
        },
        onActionButtonClicked: function(event) {
            event = event || window.event;
            var button = event.currentTarget || event.target;
            var actions = {
                'enableEverything': this.grantAllPrivileges,
                'disableEverything': this.revokeAllPrivileges,
            };
            var action = button.dataset.ccmAction;
            typeof actions[action] == 'function' && actions[action].call(this)
        },
        onTreeNodeToggleClicked: function(event) {
            event = event || window.event;
            var button = event.currentTarget || event.target;
            var treeNode = button.parentElement;
            while (treeNode && treeNode.classList.contains('ccm--tree-node') == !1) {
                treeNode = treeNode.parentElement
            }
            if (!treeNode) {
                return
            }
            var isOpen = Utils.toggleClass(treeNode, 'ccm--tree-node--open');
            toArray(treeNode.querySelectorAll('.ccm--collapsable')).forEach(function(element) {
                element.setAttribute('aria-hidden', isOpen ? 'false' : 'true')
            })
        },
        onSwitchStateChanged: function(event) {
            var checkbox = event.target;
            var switches = toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group]'));
            var descendants = toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group-parent]'));
            var switchGroup = switches.filter(function(item) {
                return item.dataset.switchGroup == checkbox.dataset.switchGroup
            });
            var switchGroupParents = switches.filter(function(item) {
                var parentName = checkbox.dataset.switchGroupParent;
                return parentName && item.dataset.switchGroup == parentName
            });
            var switchGroupSiblings = switches.filter(function(item) {
                var parentName = checkbox.dataset.switchGroupParent;
                return parentName && item.dataset.switchGroupParent == parentName
            });
            var switchGroupChildren = switches.filter(function(item) {
                var parentName = checkbox.dataset.switchGroup;
                return item.dataset.switchGroupParent == parentName
            });
            var newState = checkbox.checked;
            var updateConsentState = function(checkbox) {
                var category = checkbox.dataset.consentStateCategory;
                if (this.consentState[category] && checkbox.value in this.consentState[category]) {
                    this.consentState[category][checkbox.value] = checkbox.checked
                }
            }
            .bind(this);
            var updateConsentStateForGroups = function(checkbox) {
                var self = this;
                checkbox.dataset.consentStateCategoryGroups.split(',').forEach(function(category) {
                    if (self.consentState[category]) {
                        for (var id in self.consentState[category]) {
                            self.consentState[category][id] = checkbox.checked
                        }
                    }
                })
            }
            .bind(this);
            switchGroup.forEach(function(checkbox) {
                checkbox.checked = newState;
                checkbox.indeterminate = !1;
                if (checkbox.dataset.consentStateCategory) {
                    updateConsentState(checkbox)
                }
                if (checkbox.dataset.consentStateCategoryGroups) {
                    updateConsentStateForGroups(checkbox)
                }
            });
            if (switchGroupParents.length > 0) {
                var newParentState = switchGroupSiblings.reduce(function(newState, checkbox) {
                    if (newState === !0) {
                        newState = checkbox.checked || 'partial'
                    } else {
                        newState = checkbox.checked ? 'partial' : newState
                    }
                    return newState
                }, newState);
                switchGroupParents.forEach(function(checkbox) {
                    checkbox.checked = !!newParentState;
                    checkbox.indeterminate = newParentState == 'partial'
                })
            }
            switchGroupChildren.forEach(function(checkbox) {
                checkbox.checked = newState;
                checkbox.indeterminate = !1
            })
        },
        onPurposeToggled: function(event) {
            var checkbox = event.target;
            var purposeId = checkbox.dataset.purpose;
            var newState = checkbox.checked;
            var self = this;
            this.repository.forEach(function(embedding) {
                if (embedding.purpose == purposeId) {
                    embedding.consent = newState || embedding.mandatory;
                    self.selectEmbedding(embedding)
                }
            })
        },
        onEmbeddingToggled: function(event) {
            var checkbox = event.target;
            var embedding = this.repository[checkbox.dataset.embedding];
            if (embedding) {
                embedding.consent = checkbox.checked || embedding.mandatory;
                this.selectEmbedding(embedding)
            }
        },
        onTcfDescriptionExpandClicked: function(event) {
            var span = (event.currentTarget || event.target);
            var li = span.parentNode;
            var targetSpec = li.getAttribute('data-ccm-tcf').split(':');
            li.classList.toggle('ccm-expanded');
            if (li.classList.contains('ccm-expanded')) {
                var container = document.createElement('div');
                container.className = 'ccm-tcf-description';
                var dataContainer = document.getElementById('ccm-tcf-descriptions');
                var descriptionData = JSON.parse(dataContainer.innerHTML)[targetSpec[0]][targetSpec[1]];
                container.innerText = descriptionData.desc + '\n\n' + descriptionData.legal;
                span.setAttribute('aria-expanded', 'true');
                li.appendChild(container)
            } else {
                span.setAttribute('aria-expanded', 'false');
                li.removeChild(li.getElementsByClassName('ccm-tcf-description')[0])
            }
        },
        onTcfExtendedDisclosureExpandClicked: function(event) {
            var title = (event.currentTarget || event.target);
            var parent = title.parentNode;
            var vendorId = parseInt(parent.getAttribute('data-ccm-tcf'));
            parent.classList.toggle('ccm-expanded');
            if (parent.classList.contains('ccm-expanded')) {
                var url = this.tcfData.disclosureUrlTemplate.replace(':VENDOR', vendorId);
                this.ajax(url, {
                    method: 'GET',
                    success: function(data) {
                        var container = document.createElement('div');
                        container.className = 'ccm-tcf-description';
                        container.innerHTML = data;
                        title.setAttribute('aria-expanded', 'true');
                        parent.appendChild(container)
                    },
                    failure: function() {
                        parent.classList.remove('ccm-expanded')
                    }
                })
            } else {
                title.setAttribute('aria-expanded', 'false');
                parent.removeChild(parent.getElementsByClassName('ccm-tcf-description')[0])
            }
        },
        presetConsentState: function() {
            this.presetPurposesAndEmbeddings();
            this.presetTcfPurposes();
            this.presetTcfSpecialFeatures();
            this.presetTcfVendors();
            this.presetGoogleProviders()
        },
        presetPurposesAndEmbeddings: function() {
            var storage = this.getConsentStorage();
            var allowedEmbeddings = storage.embeddings || [];
            this.setPurposesAndEmbeddings(allowedEmbeddings)
        },
        setPurposesAndEmbeddings: function(allowedEmbeddings) {
            var self = this;
            this.repository.forEach(function(embedding) {
                embedding.consent = allowedEmbeddings.includes(embedding.id) || embedding.mandatory;
                if (self.container) {
                    self.selectEmbedding(embedding)
                }
            })
        },
        setAllPurposes: function(newState) {
            newState = typeof newState == 'boolean' ? newState : !1;
            var allowedEmbeddings = newState ? this.repository.map(function(embedding) {
                return embedding.id
            }) : [];
            this.setPurposesAndEmbeddings(allowedEmbeddings)
        },
        captureFocus: function() {
            if (this._focusCaptured) {
                return
            }
            var self = this;
            this._focusCaptured = !0;
            var focusHelperTop = document.createElement('div');
            focusHelperTop.style.position = 'fixed';
            focusHelperTop.style.left = '0';
            focusHelperTop.style.right = '0';
            focusHelperTop.style.height = '0';
            focusHelperTop.style.maxHeight = '0';
            focusHelperTop.background = 'transparent';
            focusHelperTop.border = '0 none transparent';
            var focusHelperBottom = focusHelperTop.cloneNode();
            focusHelperTop.tabIndex = 1;
            focusHelperTop.style.top = '0';
            focusHelperTop.id = 'ccm-focus-helper--top';
            document.body.insertBefore(focusHelperTop, document.body.firstChild);
            focusHelperBottom.tabIndex = 0;
            focusHelperBottom.style.bottom = '0';
            focusHelperBottom.id = 'ccm-focus-helper--bottom';
            document.body.appendChild(focusHelperBottom);
            document.body.addEventListener('focusin', self.onFocusIn);
            document.body.addEventListener('keydown', self.onTabKeyDown)
        },
        endCaptureFocus: function() {
            if (!this._focusCaptured) {
                return
            }
            var self = this;
            this._focusCaptured = !1;
            var topHelper = document.getElementById('ccm-focus-helper--top');
            var bottomHelper = document.getElementById('ccm-focus-helper--bottom');
            if (topHelper) {
                topHelper.parentNode.removeChild(topHelper)
            }
            if (bottomHelper) {
                bottomHelper.parentNode.removeChild(bottomHelper)
            }
            document.body.removeEventListener('focusin', self.onFocusIn);
            document.body.removeEventListener('keydown', self.onTabKeyDown)
        },
        consentGiven: function() {
            var storage = this.getConsentStorage();
            return (storage.consent && storage.gen == 2) || !1
        },
        registerControls: function() {
            var self = this;
            var initializedControls = [];
            toArray(this.container.querySelectorAll('.ccm-settings-summoner > .ccm-settings-summoner--link')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.onSettingsIconClicked.bind(self))
            });
            toArray(this.container.querySelectorAll('[data-jump-to]')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.jumpTo.bind(self, element.dataset.jumpTo))
            });
            toArray(this.container.querySelectorAll('[data-ccm-modal]')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.loadModal.bind(self, element.dataset.ccmModal, !0, element.dataset.jumpTo))
            });
            var actionButtonClickedHandler = this.onActionButtonClicked.bind(this);
            toArray(this.container.querySelectorAll('button[data-ccm-action], .button[data-ccm-action]')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', actionButtonClickedHandler)
            });
            var treeNodeToggleClickedHandler = this.onTreeNodeToggleClicked.bind(this);
            toArray(this.container.querySelectorAll('.ccm--tree-node .ccm--tree-node-toggle')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.onTreeNodeToggleClicked)
            });
            toArray(this.container.getElementsByClassName('ccm-modal--close')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.onModalCloseButtonClicked.bind(self))
            });
            toArray(this.container.getElementsByClassName('ccm--save-settings')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.onConsentButtonClicked.bind(self))
            });
            toArray(this.container.getElementsByClassName('ccm--decline-cookies')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.onDeclineButtonClicked.bind(self))
            });
            toArray(this.container.getElementsByClassName('ccm-widget--language-select')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('change', function() {
                    self.switchLocale(this.value)
                })
            });
            toArray(this.container.getElementsByClassName('ccm-dismiss-button')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', self.dismissTemporarily.bind(self))
            });
            toArray(this.container.querySelectorAll('input[type="checkbox"][data-switch-group]')).forEach(function(checkbox) {
                if (checkbox.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(checkbox);
                checkbox.addEventListener('change', self.onSwitchStateChanged.bind(self))
            });
            var tcfDescriptionExpandClicked = self.onTcfDescriptionExpandClicked.bind(self);
            var tcfExtendedDisclosureExpandClicked = self.onTcfExtendedDisclosureExpandClicked.bind(self);
            var tcfDescriptionExpandKeyPress = function(event) {
                if (event.key == 'Enter' || event.key == 'Spacebar' || event.key == ' ' || event.key == 'NumpadEnter') {
                    event.preventDefault();
                    this.click();
                    event.stopPropagation()
                }
            };
            toArray(this.container.querySelectorAll('li[data-ccm-tcf] > span')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', tcfDescriptionExpandClicked);
                element.addEventListener('keypress', tcfDescriptionExpandKeyPress);
                element.setAttribute('aria-expanded', 'false')
            });
            toArray(this.container.querySelectorAll('div[data-ccm-tcf] > strong')).forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('click', tcfExtendedDisclosureExpandClicked);
                element.addEventListener('keypress', tcfDescriptionExpandKeyPress);
                element.setAttribute('aria-expanded', 'false')
            });
            this.getPurposeCheckboxes().forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('change', self.onPurposeToggled.bind(self))
            });
            this.getEmbeddingCheckboxes().forEach(function(element) {
                if (element.classList.contains('ccm--ctrl-init')) {
                    return
                }
                initializedControls.push(element);
                element.addEventListener('change', self.onEmbeddingToggled.bind(self))
            });
            initializedControls.forEach(function(element) {
                element.classList.add('ccm--ctrl-init')
            })
        },
        validateUseRemoteConsent: function(ucid, consent, embeddingIds, domainId, source, callback) {
            var validated = !1;
            this.ajax(this.consentValidateUrl, {
                contentType: 'text/plain',
                body: ucid + '|' + embeddingIds.join('|'),
                method: 'POST',
                success: function(_, code) {
                    if (code == 204) {
                        validated = !0;
                        this.ucid = ucid;
                        this.saveSettingsInternal(ucid, consent, embeddingIds)
                    } else {}
                },
                done: function() {
                    if (callback) {
                        callback(validated)
                    }
                }
            })
        },
        urlIsExempt: function(url) {
            var hashlessUrl = url.replace(/#.*$/, '');
            return this.exemptUrls.reduce(function(isMatch, item) {
                if (item.indexOf('//') === 0) {
                    item = location.protocol + item
                } else if (item.indexOf('/') === 0) {
                    item = location.protocol + '//' + location.host + item
                }
                if (item.includes('#')) {
                    return isMatch || url == item
                } else {
                    return isMatch || hashlessUrl == item || url.indexOf(item + '#') === 0
                }
            }, !1)
        },
        build: function() {
            if (!this.widgetUrl) {
                this.widgetUrl = this.widgetUrls[this.locale]
            }
            var detailsUrl = this.detailsUrls[this.locale];
            if (detailsUrl) {
                var link = document.getElementById('ccm-prefetch--detail-dialog');
                if (link) {
                    link.parentNode.removeChild(link)
                } else {
                    link = document.createElement('LINK')
                }
                link.rel = 'prefetch';
                link.as = 'fetch';
                link.crossOrigin = !0;
                link.href = detailsUrl;
                link.id = 'ccm-prefetch--detail-dialog';
                document.head.appendChild(link)
            }
            var headers = {};
            function finishWidgetBuild() {
                var limitToTechnicallyNecessary = !1;
                if (this.forceOpenWidget) {
                    this.forceOpenWidget = !1;
                    this.openWidget();
                    limitToTechnicallyNecessary = !0
                } else if (this.isBotBrowser() || (this.urlIsExempt(location.href) && !this.consentGiven())) {
                    this.revokeAllPrivileges();
                    this.settingsIconTarget = 'main'
                } else if (this.behavior.noConsentRequired) {
                    var dnt = (this.behavior.respectDoNotTrack && this.isDoNotTrackEnabledInBrowser());
                    this.setAllPurposes(!dnt);
                    if (dnt) {
                        this.resetAllTcfPurposes();
                        this.resetAllTcfSpecialFeatures();
                        this.resetAllGoogleProviders();
                        this.resetAllTcfVendors()
                    }
                } else if (this.consentGiven() == !1) {
                    this.logOpenData();
                    this.openWidget();
                    limitToTechnicallyNecessary = !0
                }
                if (document.body) {
                    this.loadScripts(limitToTechnicallyNecessary)
                } else {
                    window.addEventListener('DOMContentLoaded', this.loadScripts.bind(this, limitToTechnicallyNecessary))
                }
                if (!Utils.isTopLevel()) {
                    var messaged = [], context;
                    ['parent', 'top', 'opener'].forEach(function(key) {
                        try {
                            context = window[key];
                            if (context !== null && !messaged.includes(context)) {
                                context.postMessage({
                                    realm: 'CCM19',
                                    type: 'ConsentSharing',
                                    action: 'requestConsent'
                                }, '*');
                                messaged.push(context)
                            }
                        } catch (e) {}
                    })
                }
                Utils.triggerCustomEvent(window, 'ccm19WidgetLoaded')
            }
            this.ajax(this.widgetUrl, {
                method: 'GET',
                headers: headers,
                success: function(response) {
                    this.container.innerHTML = response;
                    this.controlPanel = this.container.querySelector('#ccm-control-panel');
                    this.widget = this.container.querySelector('#ccm-widget');
                    this.closeAllModals();
                    this.registerControls();
                    this.presetConsentState();
                    var currentMinute = (Date.now() / 1000 / 60 | 0);
                    if (this.consentCrossDomain && this.urlConsent && !this.consentGiven() && Math.abs(parseInt(this.urlConsent[2], 16) - currentMinute) < 2) {
                        this.validateUseRemoteConsent(this.urlConsent[3], !0, this.urlConsent[4].split('|'), null, 'URL', finishWidgetBuild.bind(this))
                    } else {
                        finishWidgetBuild.call(this)
                    }
                },
                failure: function() {
                    this.closeAllModals();
                    this.container.innerHTML = '<div class="ccm-widget">Error while loading resource, please try again later.</div>'
                },
            })
        },
        restoreIframe: function(iframe) {
            var consentSwitch = (this.iframeConsentSwitchMap[iframe.ccm19IframeConsentSwitchId] || {}).checkbox || null;
            if (consentSwitch) {
                consentSwitch.checked = !0
            }
            var sibling = iframe.ccm19IframePlaceholder || iframe;
            if (sibling.parentElement === null) {
                return
            }
            if (iframe.ccm19OriginalIframe) {
                iframe.ccm19OriginalIframe.ccm19ConsentGranted = !0;
                iframe.ccm19OriginalIframe.src = iframe.dataset.ccmSrc;
                iframe.ccm19OriginalIframe.dataset.ccmSrc = '';
                sibling.parentElement.insertBefore(iframe.ccm19OriginalIframe, sibling);
                sibling.parentElement.removeChild(sibling);
                return
            }
            if (iframe.dataset.ccmSrc !== '') {
                iframe.ccm19ConsentGranted = !0;
                iframe.src = iframe.dataset.ccmSrc;
                iframe.dataset.ccmSrc = '';
                var inlineCss = iframe.dataset.initialHeightInline == 'true';
                iframe.style.height = inlineCss ? iframe.dataset.initialHeight : iframe.dataset.initialHeight + 'px';
                iframe.style.maxHeight = '';
                iframe.dataset.initialHeightInline = '';
                iframe.dataset.initialHeight = '';
                if (inlineCss == !1) {
                    window.requestAnimationFrame(function() {
                        iframe.style.height = ''
                    })
                }
            }
        },
        blockIframe: function(iframe) {
            this.processIframeForBlocking(iframe, !0)
        },
        findExistingIframeClone: function(iframe) {
            return this.iframes.reduce(function(clone, item) {
                return item.ccm19OriginalIframe === iframe ? item : clone
            }, null)
        },
        appendConsentSwitchToIframe: function(iframe, initialState) {
            initialState = typeof initialState == 'boolean' ? initialState : !1;
            var clone = this.findExistingIframeClone(iframe);
            var consentSwitchContainer = this.iframeConsentSwitchMap[clone.ccm19IframeConsentSwitchId] ? this.iframeConsentSwitchMap[clone.ccm19IframeConsentSwitchId].container : null;
            if (!consentSwitchContainer) {
                var switchId = 'ccm--consent-switch-' + Utils.hash(String(Date.now()) + String(Math.random() || Math.random()).slice(1));
                clone.ccm19IframeConsentSwitchId = switchId;
                consentSwitchContainer = document.createElement('DIV');
                consentSwitchContainer.classList.add('ccm--consent-switch');
                var consentSwitchCheckbox = document.createElement('INPUT');
                consentSwitchCheckbox.id = switchId;
                consentSwitchCheckbox.type = 'checkbox';
                consentSwitchCheckbox.addEventListener('change', this.onIframeConsentSwitchStateChanged.bind(this));
                var consentSwitchLabel = document.createElement('LABEL');
                consentSwitchLabel.setAttribute('for', switchId);
                consentSwitchLabel.textContent = "Externe Inhalte anzeigen";
                consentSwitchContainer.appendChild(consentSwitchCheckbox);
                consentSwitchContainer.appendChild(consentSwitchLabel);
                var embedding = this.repository[clone.ccm19BlockedByEmbeddings[0]];
                if (embedding) {
                    consentSwitchLabel.textContent = "Inhalt f\u00fcr \":embedding\" zulassen".replace(':embedding', embedding.name);
                    var consentSwitchEmbeddingLink = document.createElement('A');
                    consentSwitchEmbeddingLink.href = 'javascript:';
                    consentSwitchEmbeddingLink.textContent = '(' + "Details zum Anbieter" + ')';
                    consentSwitchEmbeddingLink.addEventListener('click', this.loadModal.bind(this, 'ccm-details', !0, 'ccm-cookie-details-' + embedding.id));
                    consentSwitchContainer.appendChild(consentSwitchEmbeddingLink)
                }
                this.iframeConsentSwitchMap[switchId] = {
                    original: iframe,
                    clone: clone,
                    checkbox: consentSwitchCheckbox,
                    container: consentSwitchContainer,
                }
            }
            this.iframeConsentSwitchMap[clone.ccm19IframeConsentSwitchId].checkbox.checked = initialState;
            var switchSibling = initialState ? iframe : (clone.ccm19IframePlaceholder || clone);
            if (consentSwitchContainer.previousElementSibling !== switchSibling) {
                switchSibling.nextElementSibling ? switchSibling.parentElement.insertBefore(consentSwitchContainer, switchSibling) : switchSibling.parentElement.appendChild(consentSwitchContainer)
            }
        },
        onIframeConsentSwitchStateChanged: function(event) {
            var checkbox = event.currentTarget || event.target;
            var self = this;
            var clone = this.iframeConsentSwitchMap[checkbox.id].clone;
            var original = this.iframeConsentSwitchMap[checkbox.id].original;
            var embedding = this.repository[clone.ccm19BlockedByEmbeddings[0]];
            if (embedding) {
                embedding.consent = checkbox.checked || embedding.mandatory;
                this.selectEmbedding(embedding);
                this.saveSettings();
                this.iframes.forEach(function(clone) {
                    if (clone.ccm19BlockedByEmbeddings[0] == embedding.id) {
                        if (checkbox.checked) {
                            self.restoreIframe(clone)
                        } else {
                            self.blockIframe(clone.ccm19OriginalIframe)
                        }
                    }
                })
            } else {
                if (checkbox.checked) {
                    this.restoreIframe(clone)
                } else {
                    this.blockIframe(original)
                }
                var iframeDomain = original.dataset.ccmDomain;
                this.iframeConsentDomains = this.iframeConsentDomains.filter(function(domain) {
                    return domain !== iframeDomain
                });
                if (checkbox.checked) {
                    this.iframeConsentDomains.push(iframeDomain)
                }
            }
        },
        onPostMessage: function(event) {
            if (typeof event.data !== 'object' || event.data.realm !== 'CCM19') {
                return
            }
            event.stopImmediatePropagation();
            switch (event.data.type) {
            case 'ContentBlocker':
                return this.onMessageFromContentBlocker(event)
            case 'ConsentSharing':
                return this.onMessageFromConsentSharing(event)
            default:
                break
            }
        },
        onMessageFromContentBlocker: function(event) {
            var self = this;
            if (event.origin != this.origin) {
                return
            }
            var iframe = this.iframes.reduce(function(iframe, currentItem) {
                if (event.source === currentItem.contentWindow) {
                    return currentItem
                }
                return iframe
            }, null);
            if (iframe == null) {
                return
            }
            var action = typeof event.data.action == 'string' ? event.data.action : '';
            switch (action) {
            case 'updateHeight':
                if (typeof event.data.innerHeight == 'number') {
                    if (iframe.ccm19ConsentGranted) {
                        return
                    }
                    if (event.data.initialUpdate) {
                        iframe.dataset.initialHeightInline = iframe.style.height ? 'true' : 'false';
                        iframe.dataset.initialHeight = iframe.style.height || iframe.clientHeight;
                        iframe.dataset.initialClientHeight = iframe.clientHeight
                    }
                    iframe.style.height = Math.max(event.data.innerHeight, iframe.dataset.initialClientHeight) + 'px';
                    iframe.style.maxHeight = '100%'
                }
                break;
            case 'resourceDomain':
                var domain = iframe.dataset.ccmDomain;
                iframe.contentWindow.postMessage({
                    realm: 'CCM19',
                    type: 'ContentBlocker',
                    action: action,
                    domain: domain,
                }, this.origin);
                Utils.triggerCustomEvent(iframe.ccm19OriginalIframe, 'load');
                break;
            case 'thirdPartyContentConsentGranted':
                var domain = iframe.dataset.ccmDomain;
                this.restoreIframe(iframe);
                this.iframes.forEach(function(iframe) {
                    if (iframe.dataset.ccmDomain == domain) {
                        self.restoreIframe(iframe)
                    }
                });
                if (this.iframeConsentDomains.includes(domain) == !1) {
                    this.iframeConsentDomains.push(domain);
                    this.saveSettings()
                }
                break;
            default:
                break
            }
        },
        onMessageFromConsentSharing: function(event) {
            var originDomain = this.getBaseDomain(event.origin.replace(/^[^:\/]*:\/\//, '').replace(/:[0-9]+$/, ''));
            if (event.origin !== window.origin && originDomain === null) {
                return
            }
            var self = this;
            var data = event.data;
            switch (data.action) {
            case 'requestConsent':
                event.source.postMessage({
                    realm: 'CCM19',
                    type: 'ConsentSharing',
                    action: 'consent',
                    ucid: this.getUniqueCookieId(),
                    consent: this.consentGiven(),
                    embeddings: this.getAllowedEmbeddingIds(),
                    domain: this.domainId,
                }, event.origin);
                this.consentShareChannels.push({
                    channel: event.source,
                    origin: event.origin
                });
                break;
            case 'consent':
                if (data.consent) {
                    this.validateUseRemoteConsent(data.ucid, data.consent, data.embeddings, null, event.origin, function(success) {
                        if (success || self.consentGiven()) {
                            self.closeAllModals()
                        }
                    })
                } else {
                    self.closeAllModals()
                }
                break;
            default:
                break
            }
        },
        getAllowedEmbeddingIds: function() {
            return this.getConsentStorage().embeddings || []
        },
        getAllowedAndMandatoryEmbeddingIds: function() {
            if (this.consentGiven() == !1 && this.runMandatoryEmbeddingsWithoutConsent == !1) {
                return []
            }
            var allowedEmbeddingIds = this.getAllowedEmbeddingIds();
            for (var embeddingId in this.repository) {
                var embedding = this.repository[embeddingId];
                if (allowedEmbeddingIds.includes(embedding.id) == !1 && embedding.mandatory) {
                    allowedEmbeddingIds.push(embedding.id)
                }
            }
            return allowedEmbeddingIds
        },
        shouldBlockScriptAccordingToBlacklist: function(node) {
            if (Utils.isBlockableScript(node) == !1 && node.type.toLowerCase() != 'text/x-ccm-loader' || node.hasAttribute('data-ccm-injected')) {
                return !1
            }
            var text = String(node.outerHTML);
            return this.deniedScriptMarkers.reduce(function(isMatch, item) {
                return isMatch || text.includes(item)
            }, !1)
        },
        shouldBlockScript: function(node) {
            if (this.shouldBlockScriptAccordingToBlacklist(node)) {
                return !0
            }
            if (this.inEval || !Utils.isBlockableScript(node) || node.hasAttribute('data-ccm-injected')) {
                return !1
            }
            var src = (node.type == 'text/x-ccm-loader' && node.dataset.ccmLoaderSrc) || node.src;
            if (src) {
                return (this.blockSameDomainScripts || this.checkIsExternal(src))
            } else {
                var text = String(node.outerHTML);
                var exception = this.allowedScriptMarkers.reduce(function(result, item) {
                    return (result || text.includes(item))
                }, !1);
                return (!exception && this.blockInlineScripts)
            }
        },
        embeddingsBlockingScript: function(node, embeddingIds) {
            var self = this;
            if (node.type == 'text/x-ccm-loader') {
                var loaderGroup = node.dataset.ccmLoaderGroup;
                if (loaderGroup) {
                    var associatedEmbeddingIds = this.repository.filter(function(embedding) {
                        return embedding.scriptLoaderGroup == loaderGroup
                    }).filter(function(embedding) {
                        return self.isEmbeddingActiveForCurrentLocation(embedding)
                    }).map(function(embedding) {
                        return embedding.id
                    });
                    if (associatedEmbeddingIds.length == 0) {
                        throw new Error('ScriptLoaderGroupNotAssociatedWithAnyEmbeddingException')
                    }
                    return associatedEmbeddingIds.filter(function(id) {
                        return !embeddingIds.includes(id)
                    })
                }
            }
            if (!this.blockEmbeddingScriptMarkers) {
                return []
            }
            if (this.inEval || !Utils.isBlockableScript(node) || node.hasAttribute('data-ccm-injected')) {
                return []
            }
            var text = String(node.outerHTML);
            var embeddingIdsBlockingScript = [];
            for (var embeddingId in this.blockEmbeddingScriptMarkers) {
                var embedding = this.repository[embeddingId];
                if (!embedding || this.isEmbeddingActiveForCurrentLocation(embedding) == !1) {
                    continue
                }
                if (!embeddingIds.includes(embeddingId)) {
                    var isBlocking = this.blockEmbeddingScriptMarkers[embeddingId].reduce(function(isBlocking, marker) {
                        return isBlocking || text.includes(marker)
                    }, !1);
                    if (isBlocking) {
                        embeddingIdsBlockingScript.push(embeddingId)
                    }
                }
            }
            return embeddingIdsBlockingScript
        },
        processScriptForBlocking: function(node) {
            var self = this;
            var blocked = !1;
            var embeddingIds = self.getAllowedAndMandatoryEmbeddingIds();
            var blockedByEmbeddings = [];
            var handledByEmbeddings = [];
            var allowScriptLoader = !0;
            try {
                blockedByEmbeddings = self.embeddingsBlockingScript(node, embeddingIds);
                handledByEmbeddings = self.embeddingsBlockingScript(node, [])
            } catch (e) {
                allowScriptLoader = !1
            }
            var shouldBlock = self.shouldBlockScript(node);
            if ((blockedByEmbeddings.length || shouldBlock) && !node.hasAttribute('data-ccm-injected')) {
                var contentToHash;
                var src = (node.type == 'text/x-ccm-loader' && node.dataset.ccmLoaderSrc) || node.src;
                if (src) {
                    contentToHash = String(src).trim().replace(/#.*$/i, "").replace(/\?.*/i, "?").replace(/\/(intl\/|releases\/|viewthroughconversion\/|www-widgetapi-)[^\/]+\//, '/$1…/')
                } else {
                    contentToHash = String(node.innerHTML).trim().substring(1, 1024).replace(/\s+/ig, ' ')
                }
                if (node.id) {
                    contentToHash += '#' + node.id.trim()
                }
                if (node.className) {
                    contentToHash += '.' + node.className.trim()
                }
                if (node.async) {
                    contentToHash += ':async'
                }
                if (node.defer) {
                    contentToHash += ':defer'
                }
                if (node.type == 'text/x-ccm-loader') {
                    contentToHash += ':loader'
                }
                var hash = Utils.hash(contentToHash);
                var blacklisted = this.shouldBlockScriptAccordingToBlacklist(node);
                var scriptIsAllowed = self.allowedScripts.includes(hash);
                var scriptIsDenied = self.deniedScripts.includes(hash);
                if (blockedByEmbeddings.length || !scriptIsAllowed || blacklisted) {
                    var clone = node.cloneNode(!0);
                    clone.async = node.async;
                    clone.ccm_id = hash;
                    self.blockableScripts.push(clone);
                    if (self.blockNewScripts || scriptIsDenied || (self.isActive && blockedByEmbeddings.length) || blacklisted) {
                        node.setAttribute('data-ccm-id', hash);
                        node.setAttribute('data-ccm-type', node.type);
                        node.type = 'text/x-blocked-script';
                        blocked = !0;
                        if (blockedByEmbeddings.length && !(shouldBlock && this.blockNewScripts && !scriptIsAllowed || blacklisted)) {
                            blockedByEmbeddings.forEach(function(embeddingId) {
                                var embedding = self.repository[embeddingId]
                            });
                            clone.ccmEmbeddings = blockedByEmbeddings;
                            clone.ccmOriginalNode = node
                        } else if (handledByEmbeddings.length && blacklisted) {}
                    }
                }
            }
            if (node.type == 'text/x-ccm-loader' && allowScriptLoader && !blocked) {
                this.scriptLoaderQueue.push(node);
                this.executeScriptLoaderQueue()
            }
        },
        processIframeForBlocking: function(node, overrideConsent) {
            overrideConsent = typeof overrideConsent == 'boolean' ? overrideConsent : !1;
            if (this.blockIframes == !1 || !node.getAttribute('src') || !node.parentElement || node.ccm19ConsentGranted && !overrideConsent) {
                return
            }
            var self = this;
            var blockIframe = this.iframeBlockMode == 'whitelist';
            var contentBlockedUrl = "https:\/\/click-learn.consent-bist.de\/public\/x-content-blocked.html?apiKey=e71f7057cbc3e312c1a4c4807887dd9d27d7fcfeca543b32&domain=79da03d&gen=2&theme=c0f3b1e&lang=de_DE&v=1713180154";
            var alreadyBlocked = !!node.dataset.ccmSrc && node.src.toLowerCase().indexOf(contentBlockedUrl.toLowerCase().split('?', 1)[0]) == 0;
            var tamperedWith = alreadyBlocked && node.src.toLowerCase().indexOf(contentBlockedUrl.toLowerCase()) != 0;
            if (alreadyBlocked && this.iframes.includes(node) == !1) {
                alreadyBlocked = !1;
                node.src = node.dataset.ccmSrc
            } else if (tamperedWith && this.iframes.includes(node)) {
                var newSrc = contentBlockedUrl + '&url=' + escape(node.dataset.ccmSrc.replace(/[#].*$/, ''));
                if ((node.ccm19BlockedByEmbeddings || []).length > 0) {
                    newSrc += '&embedding=' + escape(node.ccm19BlockedByEmbeddings[0])
                }
                node.src = newSrc
            }
            if (alreadyBlocked) {
                return
            }
            var nodeHtml = String(node.outerHTML);
            var blockedByEmbeddings = [];
            var hideIframesUntilConsent = !1;
            for (var embeddingId in this.repository) {
                var embedding = this.repository[embeddingId];
                if (this.isEmbeddingActiveForCurrentLocation(embedding) == !1) {
                    continue
                }
                var isBlocking = embedding.iframeBlockingStrings.reduce(function(isMatch, needle) {
                    return isMatch || nodeHtml.includes(needle)
                }, !1);
                if (isBlocking) {
                    blockedByEmbeddings.push(embeddingId);
                    hideIframesUntilConsent = hideIframesUntilConsent || embedding.hideIframesUntilConsent
                }
            }
            if (blockedByEmbeddings.length > 0) {
                var allowedEmbeddingIds = this.getAllowedAndMandatoryEmbeddingIds();
                blockIframe = blockedByEmbeddings.reduce(function(isBlocking, embeddingId) {
                    return isBlocking || allowedEmbeddingIds.includes(embeddingId) == !1
                }, !1)
            } else if (this.iframeMarkers.length > 0) {
                var text = String(node.outerHTML);
                var isMatch = this.iframeMarkers.reduce(function(isMatch, item) {
                    return isMatch || text.includes(item)
                }, !1);
                blockIframe = this.iframeBlockMode == 'whitelist' ? !isMatch : isMatch
            }
            if (node.src.substring(0, 5) == 'data:') {
                blockIframe = !1
            } else if (node.src.substring(0, 6) == 'about:') {
                blockIframe = !1
            } else if (this.rememberIframeConsent && this.iframeConsentDomains.includes(Utils.extractDomain(node.src))) {
                blockIframe = !1
            }
            if (overrideConsent) {
                blockIframe = !0
            }
            delete node.ccm19ConsentGranted;
            node.dataset.ccmSrc = node.src;
            node.dataset.ccmDomain = Utils.extractDomain(node.dataset.ccmSrc);
            var newSrc = contentBlockedUrl + '&url=' + escape(node.dataset.ccmSrc.replace(/[#].*$/, ''));
            if (blockedByEmbeddings.length > 0) {
                newSrc += '&embedding=' + escape(blockedByEmbeddings[0])
            }
            var existingClone = this.findExistingIframeClone(node);
            var substitute = null;
            if (existingClone) {
                substitute = existingClone.ccm19IframePlaceholder || existingClone
            } else {
                var tmpClone = node.cloneNode();
                tmpClone.src = newSrc;
                var clone = tmpClone.cloneNode();
                clone.ccm19BlockedByEmbeddings = blockedByEmbeddings;
                clone.ccm19OriginalIframe = node;
                if (hideIframesUntilConsent) {
                    var placeholder = document.createElement('SPAN');
                    placeholder.classList.add('ccm--iframe-placeholder');
                    substitute = clone.ccm19IframePlaceholder = placeholder
                } else {
                    substitute = clone
                }
                this.iframes = this.iframes.filter(function(iframe) {
                    return iframe !== node
                });
                this.iframes.push(clone);
                existingClone = clone
            }
            if (blockIframe) {
                node.src = newSrc;
                this.blockIframes = !1;
                node.parentElement.insertBefore(substitute, node);
                node.parentElement.removeChild(node);
                this.blockIframes = !0
            } else {
                delete node.dataset.ccmSrc;
                node.dataset.ccm19ConsentGranted = !0
            }
            if (this.appendConsentSwitchToIframes) {
                this.appendConsentSwitchToIframe(node, !blockIframe)
            }
        },
        performBlockingActionsOnNode: function(node) {
            if (node instanceof HTMLIFrameElement) {
                this.processIframeForBlocking(node)
            } else if (node instanceof HTMLScriptElement) {
                this.processScriptForBlocking(node)
            } else {
                var children = 'children'in node ? node.children : node.childNodes;
                for (var i = 0; i < children.length; i++) {
                    this.performBlockingActionsOnNode(children[i])
                }
            }
        },
        observeDocument: function() {
            if (this.domWatcher) {
                return
            }
            function onBeforeScriptExecute(event) {
                var node = event.target;
                if (node.type == 'text/x-blocked-script') {
                    node.setAttribute('data-ccm-type', node.type);
                    event.preventDefault()
                }
            }
            if (this.blockNewScripts || this.deniedScripts || this.blockEmbeddingScriptMarkers) {
                window.addEventListener('beforescriptexecute', onBeforeScriptExecute, !0)
            }
            var self = this;
            function callback(mutations, observer) {
                mutations.forEach(function(mutation) {
                    if (mutation.type == 'attributes') {
                        if (mutation.target instanceof HTMLIFrameElement) {
                            if (mutation.attributeName == 'src') {
                                self.processIframeForBlocking(mutation.target)
                            }
                        }
                    }
                    toArray(mutation.addedNodes).forEach(function(node) {
                        self.performBlockingActionsOnNode(node)
                    });
                    toArray(mutation.removedNodes).forEach(function(node) {
                        if (self.container && node === self.container) {
                            window.setTimeout(function() {
                                if (node.parentElement !== document.body) {
                                    document.body.appendChild(node)
                                }
                            }, 1000)
                        }
                    })
                })
            }
            ;var options = {
                attributes: !0,
                childList: !0,
                subtree: !0,
                characterData: !0
            };
            this.domWatcher = new MutationObserver(callback);
            this.domWatcher.observe(document, options);
            window.addEventListener('message', this.onPostMessage.bind(this));
            if (this.consentCrossDomain) {
                document.addEventListener('click', (function(event) {
                    if ('href'in event.target) {
                        this.appendCrossDomainConsent(event.target)
                    }
                }
                ).bind(this), !0);
                document.addEventListener('submit', (function(event) {
                    if ('action'in event.target) {
                        this.appendCrossDomainConsent(event.target)
                    }
                }
                ).bind(this), !0)
            }
        },
        update: function() {
            return;
            window.requestAnimationFrame(this.update.bind(this))
        },
        init: function() {
            if (this.initialized) {
                return
            }
            this.onFocusIn = this.onFocusIn.bind(this);
            this.onTabKeyDown = this.onTabKeyDown.bind(this);
            var rand = Math.random();
            this.shouldReport = (rand <= 0.333);
            if (this.activatePermaScan === !1) {
                this.shouldReport = 0
            }
            if (this.shouldReport) {
                this.wrapCookieSetter()
            }
            var self = this;
            ['filter', 'forEach', 'map', 'reduce', ].forEach(function(methodName) {
                Object.defineProperty(self.repository, methodName, {
                    configurable: !1,
                    enumerable: !1,
                    writable: !1,
                    value: function() {
                        var array = Object.values(self.repository);
                        if (methodName in array && typeof array[methodName] == 'function') {
                            return array[methodName].apply(array, arguments)
                        }
                    },
                })
            });
            this.container = document.createElement('DIV');
            this.container.classList.add('ccm-root');
            Utils.toggleClass(this.container, 'ccm--tcf-enabled', !1);
            Utils.toggleClass(this.container, 'ccm--is-ie', Utils.isIE());
            this.presetConsentState();
            if (this.isActive == !1) {
                console.info('[CCM19] Frontend widget is disabled.');
                this.initialized = !0;
                return
            }
            var storage = this.getConsentStorage();
            this.iframeConsentDomains = typeof storage.iframeConsentDomains == 'object' && storage.iframeConsentDomains instanceof Array ? storage.iframeConsentDomains : [];
            this.observeDocument();
            this.wrapElementInsertion();
            if (!Utils.hasGTMLayer('consent')) {
                for (var embeddingId in this.repository) {
                    if (this.repository[embeddingId].gcm) {
                        Utils.sendGTag("consent", "default", {
                            ad_storage: "denied",
                            analytics_storage: "denied",
                            functionality_storage: "denied",
                            personalization_storage: "denied",
                            security_storage: "denied",
                            wait_for_update: 1000,
                        });
                        break
                    }
                }
            }
            this.injectCss();
            this.injectJs();
            var consentLastModified = Math.round((storage.updated || 0) / 10);
            var consentReset = 1634635269;
            var consentLifetime = 0;
            if (this.consentGiven()) {
                if ((consentLifetime > 0 && (Date.now() / 1000) - consentLastModified) > (consentLifetime * 86400)) {
                    this.forceOpenWidget = !0
                } else if (consentLastModified < consentReset && consentReset <= (Date.now() / 1000)) {
                    this.forceOpenWidget = !0
                }
            }
            function build() {
                if (document.body && typeof document.body == 'object' && 'appendChild'in document.body) {
                    self.initPlatformDependentComponents();
                    self.build();
                    self.update();
                    document.body.appendChild(self.container)
                } else {
                    window.requestAnimationFrame(build)
                }
            }
            build();
            this.initialized = !0
        },
        pageCheckReport: function() {
            var report = {};
            report.c = this.getCookies().map(function(cookie) {
                return cookie.name
            });
            var scripts = document.getElementsByTagName('script');
            report.s = [];
            for (var i = 0; i < scripts.length; ++i) {
                var script = scripts[i];
                if (this.checkIsExternal(script.src) && !script.hasAttribute('data-ccm-injected')) {
                    report.s.push(script.src)
                }
            }
            var objects = document.getElementsByTagName('object');
            report.o = [];
            for (var i = 0; i < objects.length; ++i) {
                var object = objects[i];
                if (this.checkIsExternal(object.data)) {
                    report.o.push(object.data)
                }
            }
            objects = document.getElementsByTagName('embed');
            for (var i = 0; i < objects.length; ++i) {
                object = objects[i];
                if (this.checkIsExternal(object.src)) {
                    report.o.push(object.src)
                }
            }
            objects = document.getElementsByTagName('iframe');
            for (var i = 0; i < objects.length; ++i) {
                object = objects[i];
                if (this.checkIsExternal(object.src)) {
                    report.o.push(object.src)
                }
            }
            try {
                report.ls = [];
                var storage = window.localStorage;
                for (var i = 0; i < storage.length; ++i) {
                    report.ls.push(storage.key(i))
                }
            } catch (e) {}
            try {
                report.ss = [];
                var storage = window.sessionStorage;
                for (var i = 0; i < storage.length; ++i) {
                    report.ss.push(storage.key(i))
                }
            } catch (e) {}
            try {
                report.as = {};
                if (this.scripTracker) {
                    console.log("Script Tracking active");
                    var foundScriptCookies = this.foundScriptCookies;
                    this.blockableScripts.forEach(function(node) {
                        if (node.type == 'text/x-ccm-loader' && node.dataset.ccmLoaderGroup) {
                            return
                        }
                        var id = node.ccm_id;
                        report.as[id] = {
                            s: btoa(node.outerHTML.trim().replace(/\s+\n/g, '\n').replace(/\n\n+/g, '\n\n').substring(0, 500)),
                            c: ((node.src in foundScriptCookies) ? Object.keys(foundScriptCookies[node.src]) : [])
                        }
                    })
                }
            } catch (e) {}
            report.url = location.href.replace(/[?#].*$/, '');
            this.ajax(this.pageCheckUrl, {
                contentType: 'application/json',
                body: report,
                method: 'POST'
            })
        },
        triggerCron: function() {
            this.ajax(this.cronUrl, {
                method: 'POST',
            })
        },
        cleanUpClientStorage: function(byUserSelection) {
            byUserSelection = typeof byUserSelection == 'boolean' ? byUserSelection : !1;
            var self = this;
            var knownlist = {
                cookies: {},
                localStorage: {},
                sessionStorage: {},
            };
            var whitelist = {
                cookies: {},
                localStorage: {},
                sessionStorage: {},
            };
            var cookies = this.getCookies().map(function(cookie) {
                return cookie.name
            });
            var lsProperties = Object.getOwnPropertyNames(window.localStorage);
            var ssProperties = Object.getOwnPropertyNames(window.sessionStorage);
            var resourceRemoved = !1;
            function evaluateEmbedding(embedding, list) {
                embedding.assets.forEach(function(asset) {
                    var collection = [];
                    var storageType = null;
                    switch (asset.type) {
                    case "cookie":
                        collection = cookies;
                        storageType = 'cookies';
                        break;
                    case "localStorage":
                        collection = lsProperties;
                        storageType = 'localStorage';
                        break;
                    case "sessionStorage":
                        collection = ssProperties;
                        storageType = 'sessionStorage';
                        break;
                    default:
                        break
                    }
                    if (!storageType) {
                        return
                    }
                    if (asset.glob) {
                        collection.forEach(function(name) {
                            if (Utils.fnmatch(asset.name, name)) {
                                list[storageType][name] = asset.name
                            }
                        })
                    } else {
                        list[storageType][asset.name] = asset.name
                    }
                })
            }
            for (var embeddingId in this.repository) {
                evaluateEmbedding(this.repository[embeddingId], knownlist)
            }
            if (byUserSelection) {
                this.getEmbeddingsWithConsent().forEach(function(embedding) {
                    evaluateEmbedding(embedding, whitelist)
                })
            } else {
                whitelist = knownlist
            }
            whitelist.cookies.ccm_login_session = 'ccm_login_session';
            whitelist.cookies.ccm_consent = 'ccm_consent';
            whitelist.localStorage.ccm_consent = 'ccm_consent';
            whitelist.sessionStorage.ccm_consent = 'ccm_consent';
            var domains = [window.location.hostname];
            var secondLevelDomainMatch = window.location.hostname.match(/\.([^.]+\.[^.]+)$/);
            if (secondLevelDomainMatch) {
                domains.push(secondLevelDomainMatch[1])
            }
            cookies.forEach(function(cookieName) {
                var isAllowedCookie = !!whitelist.cookies[cookieName];
                var isUnknownCookie = !knownlist.cookies[cookieName];
                if (isAllowedCookie || (isUnknownCookie && self.deleteAllCookiesConfig == !1)) {
                    return !1
                }
                domains.forEach(function(domain) {
                    document.cookie = cookieName + "=" + ";domain=" + domain + ";path=/" + ";expires=Thu, 01 Jan 1970 00:00:00 UTC"
                });
                document.cookie = cookieName + '=;path=/;expires=Thu, 01 Jan 1970 00:00:00 UTC';
                resourceRemoved = !0
            });
            lsProperties.forEach(function(property) {
                var isAllowed = !!whitelist.localStorage[property];
                var isUnknown = !knownlist.localStorage[property];
                if (isAllowed || (isUnknown && self.deleteAllCookiesConfig == !1)) {
                    return !1
                }
                window.localStorage.removeItem(property);
                resourceRemoved = !0
            });
            ssProperties.forEach(function(property) {
                var isAllowed = !!whitelist.sessionStorage[property];
                var isUnknown = !knownlist.sessionStorage[property];
                if (isAllowed || (isUnknown && self.deleteAllCookiesConfig == !1)) {
                    return !1
                }
                window.sessionStorage.removeItem(property);
                resourceRemoved = !0
            });
            if (this.deleteAllCookiesReload) {
                if (resourceRemoved) {
                    window.location.reload(!0)
                }
            }
        },
        wrapElementInsertion: function() {
            var self = this;
            var origAppendChild = Node.prototype.appendChild;
            var origInsertBefore = Node.prototype.insertBefore;
            Node.prototype.appendChild = function appendChild(aChild) {
                self.performBlockingActionsOnNode(aChild);
                return origAppendChild.call(this, aChild)
            }
            ;
            Node.prototype.insertBefore = function insertBefore(newNode, referenceNode) {
                self.performBlockingActionsOnNode(newNode);
                return origInsertBefore.call(this, newNode, referenceNode)
            }
        },
        wrapCookieSetter: function() {
            var self = this;
            if (!('getOwnPropertyDescriptor'in Object)) {
                return
            }
            if (!('stack'in Error.prototype)) {
                return
            }
            Utils.wrapProperty(HTMLDocument.prototype, 'cookie', null, function(value, origSetter) {
                try {
                    var key = value.split('=', 1)[0];
                    var stack = ((new Error()).stack.trim().split('\n'));
                    stack.shift();
                    if (stack.length > 1 && /\/(js|jquery)\.cookie[._]/.test(stack[0])) {
                        stack.shift()
                    }
                    if (stack.length > 0) {
                        var m = stack[0].match(/\b((?:https?|data):.*):[0-9]+:[0-9]+\b/);
                        if (m) {
                            if (!(m[1]in self.foundScriptCookies)) {
                                self.foundScriptCookies[m[1]] = {}
                            }
                            self.foundScriptCookies[m[1]][key] = key
                        }
                    }
                } catch (e) {
                    console.error('[CCM19] Error while tracing cookie in script: %s', e)
                }
                return origSetter.call(this, value)
            })
        },
        insertCookieDeclaration: function() {
            var self = this;
            var containers = toArray(document.getElementsByClassName('ccm-cookie-declaration'));
            if (!containers.length) {
                return
            }
            var containersByLang = containers.reduce(function(result, container) {
                var requestedLanguage = container.getAttribute('data-lang');
                requestedLanguage = (requestedLanguage) ? requestedLanguage.replace('-', '_') : self.locale;
                if (!(requestedLanguage in result)) {
                    result[requestedLanguage] = [container]
                } else {
                    result[requestedLanguage].push(container)
                }
                return result
            }, Object.create(null));
            var baseUrl = this.cookieDeclarationUrl + '&lang=';
            Object.keys(containersByLang).forEach(function(lang) {
                var containers = containersByLang[lang];
                var url = baseUrl + encodeURIComponent(lang);
                self.ajax(url, {
                    method: 'GET',
                    success: function(response, text, xhr) {
                        var language = xhr.getResponseHeader('Content-Language');
                        containers.forEach(function(container) {
                            container.setAttribute('lang', language);
                            container.classList.add('ccm-cookie-declaration--loaded');
                            container.innerHTML = response;
                            var linkContainer = container.getElementsByClassName('ccm-cookie-declaration--change-consent')[0];
                            linkContainer.getElementsByTagName('a')[0].addEventListener("click", self.onSettingsIconClicked.bind(self))
                        })
                    },
                    failure: function() {
                        containers.forEach(function(container) {
                            container.classList.add('ccm-cookie-declaration--error')
                        });
                        console.error("[CCM19] Cooke declaration table for locale '%s' could not be loaded", lang)
                    },
                })
            })
        },
    };
    if (window.CCM === undefined) {
        (function() {
            var urlConsentRE = /(^#?|&)CCM19consent=([0-9a-f]+)\|([0-9a-f]+)\|([0-9a-f|]*)/;
            var urlConsent = urlConsentRE.exec(window.location.hash);
            if (urlConsent) {
                var url = Utils.getUrl(window.location, !0);
                url.hash = url.hash.replace(urlConsentRE, '');
                if (url.hash == '' && 'replaceState'in history) {
                    history.replaceState(history.state, '', window.location.pathname + window.location.search)
                } else {
                    window.location.replace(url.href)
                }
            }
            var ccm = new CookieConsentManagement(urlConsent);
            ccm.cleanUpClientStorage();
            window.addEventListener('ccm19WidgetLoaded', function() {
                ccm.cleanUpClientStorage(!0)
            });
            window.ccm = ccm;
            window.CCM = Object.create(null, {
                version: {
                    get: function() {
                        return ccm.versionName
                    },
                    enumerable: !0,
                },
                consent: {
                    get: function() {
                        return ccm.consentGiven()
                    },
                    enumerable: !0,
                },
                ucid: {
                    get: function() {
                        return this.consent ? ccm.getUniqueCookieId() : null
                    },
                    enumerable: !0,
                },
                acceptedCookies: {
                    get: function() {
                        var cookieNames = [];
                        ccm.getAllowedEmbeddingIds().forEach(function(embeddingId) {
                            var embedding = ccm.repository[embeddingId];
                            if (!embedding) {
                                return
                            }
                            embedding.assets.forEach(function(asset) {
                                if (cookieNames.includes(asset.name)) {
                                    return
                                } else if (asset.type != 'cookie') {
                                    return
                                }
                                cookieNames.push(asset.name)
                            })
                        });
                        return this.consent ? cookieNames : []
                    },
                    enumerable: !0,
                },
                acceptedEmbeddings: {
                    get: function() {
                        var embeddings = [];
                        ccm.getAllowedEmbeddingIds().forEach(function(embeddingId) {
                            var embedding = ccm.repository[embeddingId];
                            if (!embedding) {
                                return
                            }
                            embeddings.push(Object.create({}, {
                                id: {
                                    value: embedding.id,
                                    writable: !0,
                                    enumerable: !0
                                },
                                name: {
                                    value: embedding.name,
                                    writable: !0,
                                    enumerable: !0
                                },
                                _tcf: {
                                    value: embedding.tcf,
                                    writable: !0,
                                    enumerable: !1
                                },
                            }))
                        });
                        return this.consent ? embeddings : []
                    },
                    enumerable: !0,
                },
                consentLanguage: {
                    get: function() {
                        return ccm.getConsentLanguage()
                    },
                },
                primaryCountry: {
                    get: function() {
                        return ccm.country
                    },
                },
                crossDomainConsentString: {
                    get: function() {
                        return ccm.consentGiven() ? ccm.buildCrossDomainConsent() : ''
                    },
                    enumerable: !0,
                },
                consentRequired: {
                    get: function() {
                        return !ccm.behavior.noConsentRequired
                    },
                    enumerable: !0,
                },
                openWidget: {
                    value: function() {
                        ccm.openWidget()
                    },
                    enumerable: !0,
                },
                closeWidget: {
                    value: function() {
                        ccm.closeWidget()
                    },
                    enumerable: !0,
                },
                openControlPanel: {
                    value: function() {
                        ccm.openControlPanel()
                    },
                    enumerable: !0,
                },
                closeControlPanel: {
                    value: function() {
                        ccm.closeControlPanel()
                    },
                    enumerable: !0,
                },
                navigate: {
                    value: function(url, replace, navigateTop) {
                        url = ccm.withCrossDomainConsent(url);
                        var location = (navigateTop) ? window.top.location : window.location;
                        if (replace) {
                            location.replace(url)
                        } else {
                            location.assign(url)
                        }
                    },
                    enumerable: !0,
                },
                availableLocales: {
                    value: function availableLocales() {
                        return Object.keys(ccm.widgetUrls)
                    },
                    enumerable: !0,
                },
                switchLocale: {
                    value: function switchLocale(language) {
                        ccm.switchLocale(language)
                    },
                    enumerable: !0,
                },
                _tcfInfo: {
                    get: function() {
                        return {
                            'consent': ccm.getTcfConsentInfo(),
                            'repository': ccm.tcfData,
                        }
                    },
                },
                toString: {
                    value: function() {
                        return '[namespace CCM]'
                    }
                },
            });
            var rand = Math.random();
            if (rand <= 0.012542570704387) {
                ccm.triggerCron()
            }
            if (ccm.shouldReport) {
                window.addEventListener('load', function() {
                    window.setTimeout(ccm.pageCheckReport.bind(ccm), 501)
                })
            }
            window.addEventListener('DOMContentLoaded', function() {
                function doCCM(evt) {
                    if (Utils.isManipulatedClick(evt)) {
                        evt.preventDefault();
                        return !1
                    }
                    try {
                        var method = this.href.replace(/^.*#CCM\./, '');
                        window.CCM[method].call(window.CCM);
                        evt.preventDefault();
                        return !1
                    } catch (e) {
                        return
                    }
                }
                toArray(document.body.querySelectorAll('a[href^="#CCM."]')).forEach(function(element) {
                    element.addEventListener('click', doCCM)
                })
            });
            window.addEventListener('DOMContentLoaded', ccm.insertCookieDeclaration.bind(ccm))
        }
        )()
    }
}
)()
