var countdownInterval = null;
// var introducedJobSite = false;
$(function () {
    // $('#exportMask').show();
    $('#exportMask').click(function (e) {
        if (e.target === this) {
            closeExportMask();
        }
    });
    $('.btn-download-cv').click(function (event) {
        event.preventDefault();
        var cvId = $(this).data('id');
        var applyId = $(this).data('apply-id');
        var pdcvid = $(this).data('pdcvid');
        var adcvid = $(this).data('adcvid');
        var accessKey = $(this).data('access-key');

        if (applyId && accessKey) {
            $('#downloadCvLink').attr('href', DOWNLOAD_URL + '?cv_id=' + cvId + '&accessKey=' + accessKey + '&applyId=' + applyId).attr('dontcount', 1);
        } else if (pdcvid) {
            $('#downloadCvLink').attr('href', DOWNLOAD_URL + '?cv_id=' + cvId + '&accessKey=' + accessKey + '&pdcvid=' + pdcvid).attr('dontcount', 1);
        } else if (adcvid) {
            $('#downloadCvLink').attr('href', DOWNLOAD_URL + '?cv_id=' + cvId + '&accessKey=' + accessKey + '&adcvid=' + adcvid).attr('dontcount', 1);
        } else {
            $('#downloadCvLink').attr('href', DOWNLOAD_URL + '?cv_id=' + cvId).attr('dontcount', '');
        }
        if (VALID_EPL_TOKEN) {
            $('#downloadCvLink')[0].click();
        } else {
            showWaiting();
        }
    });

    $('#downloadCvLink').click(function () {
        if ($(this).attr('dontcount') == 1) return true;
        if (DOWNLOAD_LIMIT) {
            if (DOWNLOAD_LIMIT_REMAIN > 0) {
                DOWNLOAD_LIMIT_REMAIN -= 1;
                // $('#cv-download-limit-count').html(DOWNLOAD_LIMIT_REMAIN);
                if (DOWNLOAD_LIMIT_REMAIN == 0) {
                    $('#cv-download-limit').html('Bạn đã hết lượt tải<br>miễn phí');
                }
            }
        }
    });

    $('.btn-download-cover-letter').click(function (event) {
        event.preventDefault();
        var clId = $(this).data('id');
        $('#downloadCvLink').attr('href', DOWNLOAD_URL + '?cover_letter_id=' + clId);
        showWaiting();
    });

    $('.btnCloseExportMask').click(function () {
        closeExportMask();
    });
});

function closeExportMask()
{
    $('#exportMask').hide();
    $('.export-done').hide();
    $('#downloadCvLink').attr('href', '#');
    $('#popup-video-iframe').attr('src', '');
    $('body').css('overflow', 'auto');
    clearInterval(countdownInterval);
}

function showWaiting()
{
    clearInterval(countdownInterval);
    var downloadable = !DOWNLOAD_LIMIT || (DOWNLOAD_LIMIT_REMAIN > 0);
    if (DOWNLOAD_LIMIT) {
        $('#cv-download-limit-count').html(DOWNLOAD_LIMIT_REMAIN);
        $('#cv-download-limit').show();
    }
    if (downloadable) {
        $('.downloadable-hide').hide();
        $('.downloadable-show').show();
    } else {
        $('.downloadable-show').hide();
        $('.downloadable-hide').show();
    }
    $('#exportMask').show();
    $('#export-done').css('visibility', 'hidden');
    $('body').css('overflow', 'hidden');
    var countdown = DOWNLOAD_WAITING;
    $('#export-waiting-count').html(countdown);
    // INIT VIDEO
    $('#popup-video-iframe').attr('src', POPUP_VIDEO_IFRAME_SRC);
    // ----------
    if (downloadable) {
        countdownInterval = setInterval(function () {
            $('#export-waiting-count').html(--countdown);
            if (countdown == 0) {
                showDone();
            }
        }, 1000);
    }
    sendDownloadCvPopupWaitingEvent();
}
function showDone() {
    clearInterval(countdownInterval);
    $('#export-done').css('visibility', 'visible');
    $('#downloadCvLink')[0].click();
    // if (!introducedJobSite) {
    //     introducedJobSite = true;
    //     window.open('/viec-lam?utm_source=open-after-down-cv&utm_campaign=get-traffic-job-site&utm_medium=auto-open', "_blank");
    // }
    // Set flag dont count
    $('#downloadCvLink').attr('href', $('#downloadCvLink').attr('href') + '&dontcount=1').attr('dontcount', 1);
    sendDownloadCvPopupDoneEvent();
}
function sendDownloadCvPopupWaitingEvent()
{
    ga('send', 'event', 'download-cv', 'download-cv-popup-waiting', 1);
}
function sendDownloadCvPopupDoneEvent()
{
    ga('send', 'event', 'download-cv', 'download-cv-popup-done', 1);
}
