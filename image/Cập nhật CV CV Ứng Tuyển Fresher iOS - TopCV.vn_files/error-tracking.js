window.onerror = function(msg, file, line, col, error) {
    StackTrace.fromError(error).then(function (stackframes) {
        var stringifiedStack = stackframes.map(function(sf) {
            return sf.toString();
        }).join('\n');
        pushTrackingError(msg, stringifiedStack);
    });
};

function pushTrackingError(msg, traceString)
{
    ga('send', 'event', 'Javascript Eror', msg, traceString);
}
