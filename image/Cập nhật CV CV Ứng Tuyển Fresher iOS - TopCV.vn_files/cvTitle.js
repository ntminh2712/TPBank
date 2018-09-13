var cvTitleConf = {
    "selector": "#cv-title",
    "name": "cvoData[global][cv_title]",
    "suggestions": {
        "cv_title": null
    },
    "type": "text",
    "default": "",
    "placeholder": "common.cvtitle",
    "validates": [
        {
            "rule": "inline",
            "value": true
        },
        {
            "rule": "textonly",
            "value": true
        },
        {
            "rule": "notEmpty",
            "value": true,
        },
        {
            "rule": "maxlength",
            "value": 64
        }
    ]
};
function initHackCvTitle(isCoverLetter) {
    var conf = cvTitleConf;
    if (isCoverLetter) {
        conf.placeholder = 'common.coverlettertitle';
        conf.suggestions = {
            "cover_letter_title": null
        };
    }
     var titleElement = $('#cv-title');
    // blockkey & fieldkey
    $(titleElement).attr('blockkey', 'common');
    $(titleElement).attr('fieldkey', 'cvtitle');
    titleElement.cvoEditable(conf)
    .on('input', function () {
        var cvTitle = $('#cv-title').text();
        $('.hack-cv-title').val(cvTitle);
    }).focus(function () {
        $(this).selectAll();
    });
    if (conf.suggestions !== undefined) {
        var suggestions = conf.suggestions;
        for (var key in suggestions) {
            CVOFormUtils.suggestionsHandler(key, suggestions[key], titleElement);
        }
    } else {
        CVOFormUtils.suggestionsHandler(null, null, titleElement);
    }
    // End suggestion
    $('<input/>').
    addClass('hack-cv-title').
    attr('name', 'cvoData[global][cv_title]').hide().val($('#cv-title').text()).appendTo($('#cvoForm'));
};