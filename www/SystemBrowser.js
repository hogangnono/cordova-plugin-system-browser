var exec = require('cordova/exec');

module.exports = {
    /**
     * URL을 기기 기본 외부 브라우저(Safari 앱, Chrome 앱 등)로 연다.
     * iOS / Android 모두 지원.
     * @param {string} url http/https URL
     */
    openExternal: function (url, success, error) {
        exec(success || null, error || null, 'SystemBrowser', 'openExternal', [url]);
    },

    /**
     * URL을 앱 내 SFSafariViewController pageSheet로 띄운다.
     * iOS 전용. Android에서 호출하면 error 콜백이 호출된다.
     * @param {string} url http/https URL
     */
    openSheet: function (url, success, error) {
        exec(success || null, error || null, 'SystemBrowser', 'openSheet', [url]);
    }
};
