function cvoValidationErrorsDialog(messages) {
    CVOFormUtils.alert(messages, 'error');

    // if (messages.length > 1) {
    //     var html = '';
    //     for (var i = 0;  i < messages.length; i++) {
    //         html += '<li>- ' + messages[i] + '</li>';
    //     }
    //     CVOFormUtils.alert('<ul>' + html + '</ul>', 'error');
    // } else if (messages.length == 1){
    //     CVOFormUtils.alert(messages[0], 'error');
    // }
}
