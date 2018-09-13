function suggestions(type, value, element) {
    $(element).focus(function() {
        switch (type) {
            case 'freetext' :
                suggestFreetext(value);
                break;
            case null : hideSuggest();
              break;
            default:
                suggestFull(type, value);
                break;
        }
    });
}

function suggestFull(type, value) {
    var message = $(".suggest-"+type).html();
    if (type === undefined || type === null) {
      hideSuggest();
      return;
    }
    if (value !== null) {
      message = value;
    }
    showSuggest(message);
}

function suggestFreetext(value) {
    if (value !== null) {
      showSuggest(value);
    }
}

function showSuggest(message) {
    $('#cv-suggestion .cv-suggestion-content').html(message);
    $('#cv-suggestion .cv-suggestion-default').hide();
}

function hideSuggest() {
    $('#cv-suggestion .cv-suggestion-content').html('');
    $('#cv-suggestion .cv-suggestion-default').show();
}
