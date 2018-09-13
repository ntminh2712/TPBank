Lang = {
    /**
     * The current locale
     * @default en
     * @type {String}
     */
    locale : 'en',

    /**
     * The fallback locale
     * when current locale transation not found
     * @default en
     * @type {String}
     */
    // fallback : 'en',

    languages : {},

    /**
     * Set current locale
     * @param {String} locale
     */
    setLocale : function (locale) {
        this.locale = locale;
    },

    getLocale: function () {
        return this.locale;
    },

    /**
     * Set fallback locale
     * @param {String} fallback
     */
    // setFallback : function (fallback) {
    //     this.fallback = fallback;
    // },

    /**
     * Load translations for a locale
     * @param  {HashMap} lang
     * @param  {String} locale
     * @return {Object} this.language
     */
    loadTranslations : function (lang, locale) {
        if (locale === undefined) {
            locale = this.locale;
        }
        if (this.languages[locale] === undefined) {
            this.languages[locale] = {};
        }
        // console.log(lang);
        for (var key in lang) {
            this.languages[locale][key] = lang[key];
        }
        return this.languages;
    },

    /**
     * Load translations fallback
     * @param  {HashMap} lang
     * @return {Object} this.language
     */
    // loadFallbackTranslations : function (lang) {
    //     return this.loadTranslations(lang, this.fallback);
    // },

    /**
     * Get the translation of a key
     * @param  {String} key
     * @param  {HashMap} parameters
     * @param  {String} locale
     * @return {String} translation or key if no translation found
     */
    get : function(key, parameters, locale) {
        if (key === undefined || key.length === 0) {
            return '';
        }
        if (locale === undefined) {
            locale = this.locale;
        }
        if (parameters === undefined) {
            parameters = {};
        }
        // console.log(parameters);
        var languagePack = this.languages[locale];
        // console.log(this.languages);
        // if (languagePack === undefined) {
        //     languagePack = this.languages[this.fallback];
        // }
        var translation = languagePack[key];
        if (translation === undefined) {
            translation = key;
        }
        for (var k in parameters) {
            var v = parameters[k];
            translation = translation.replace(':' + k, v);
        }
        return translation;
    },
};


/**
 * Get the translation of a key
 * Fallback to Lang.get() method
 * @param  {String} key
 * @param  {HashMap} parameters
 * @param  {String} locale
 * @return {String} translation or key if no translation found
 */
function __(key, parameters, locale)
{
    return Lang.get(key, parameters, locale);
}



