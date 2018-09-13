function loadCvLayout(cvId, template, lang, change_lang, checkRecovery, recovery)
{
    var url = LOAD_TEMPLATE_URL;
    // var data = {
    //     _token: getToken(),
    //     template_name: template,
    //     lang: lang,
    // };

    var data = CVOFormController.getTemporaryFormData();
    data._token = getToken();
    data.template_name = template;
    data.lang = lang;
    data.change_lang = 0;
    if (recovery) {
        data.recovery = 1;
    }
    if (checkRecovery) {
        data.checkRecovery = 1;
    }

    // edit
    if (cvId != '') {
        data.cv_id = cvId;
        url = LOAD_TEMPLATE_EDIT_URL;
    }
    if (change_lang) {
        data.change_lang = 1;
    }
    $.ajax({
        url : url,
        data : data,
        type : 'post',
        dataType : 'json',
        beforeSend: function() {
            showLoading();
        },
        success : function (response) {
            if (response.status == 'success') {
                builder = response.builder;
                loadColor(builder);
                loadFont(builder);
                loadFontSize(builder);
                loadSpacing(builder);
                $('#cv-layout').html(response.view).show(0, function () {
                    initCVBuilder();
                });
                if (response.url != undefined) {
                    history.replaceState(null, null, response.url);
                }
            }
            hideLoading();
        },
        error : function (error) {
            hideLoading();
            alert('Lỗi');
        }
    });
}

var totalJobs = 0;
var suggestJobsDone = 0;
$('#link-close-modal-change-lang').click(function(event) {
    event.preventDefault();
    $('#modal-change-lang').modal('hide');
});

function changeLang(lang) {
    hideTemplateContainer();
    hideLayoutEditor();
    $('#cvo-toolbar span.flag').removeClass('active');
    builder.lang = lang;
    change_lang = 1;
    $('#cvo-toolbar span.flag.' + lang).addClass('active');
    $('#link-close-modal-change-lang').trigger('click');
    loadCvLayout(builder.cv_id, builder.template, builder.lang, change_lang);
}
$(document).ready(function () {

    // $('#modal-upgrade').modal();

    // prevent leave page
    var isClickUrl = false;
    $('a').click(function (event) {
        isClickUrl = true;
    });

    $(window).bind('beforeunload', function (e) {
        if (isClickUrl) {
            return undefined;
        }
        return "Bạn đang sửa CV, bạn chắc chắn muốn rời khỏi trang này?";
    });


    // flag
    $('#cvo-toolbar span.flag').click(function() {
        var lang = $(this).data('lang');
        if (builder.lang != lang) {
            $('#link-change-lang').attr('href', "javascript:changeLang('"+lang+"')");
            $('#modal-change-lang').modal('show');
        };
    });

    $('#template-container .template').click(function() {

        if ($(this).hasClass('active') && builder.template == $(this).data('name')) {
            hideTemplateContainer();
            return;
        }

        if ($(this).data('upgrade')) {
            // isClickUrl = true;
            $('#modal-upgrade').modal();
            return;
        }

        $('#template-container .template').removeClass('active');
        $(this).addClass('active');
        hideTemplateContainer();
        builder.template = $(this).data('name');
        loadCvLayout(builder.cv_id, builder.template, builder.lang);
    });

    // color
    $(document).on('click', '#cvo-toolbar span.color', function() {
        hideTemplateContainer();
        hideLayoutEditor();
        $('#cvo-toolbar span.color').removeClass('active');
        $(this).addClass('active');
        var color = $(this).data('color');
        $('#cv-scheme-css').attr('href', builder.color_path+"/"+color+".css");
        $('#cvColorScheme').val(color);
    });

    // font size
    $(document).on('click', '#cvo-toolbar span.fontsize', function() {
        $('#cvo-toolbar span.fontsize').removeClass('active');
        $(this).addClass('active');
        var size = $(this).data('size');
        $('#cv-font-size-css').attr('href', builder.fontsize_path+"/font_"+size+".css");
        $('#cvFontSize').val(size);
    });

    // spacing
    $(document).on('click', '#cvo-toolbar span.line-height', function() {
        $('#cvo-toolbar span.line-height').removeClass('active');
        $(this).addClass('active');
        var spacing = $(this).data('spacing');
        $('#cv-spacing-css').attr('href', builder.spacing_path+"/spacing_"+spacing+".css");
        $('#cvSpacing').val(spacing);
    });

    // layout editor
    $('#btn-edit-layout').click(function() {
        if ($(this).hasClass('active')) {
            hideLayoutEditor()
        } else {
            hideTemplateContainer();
            showLayoutEditor();
        }
    });

    // template
    $('#btn-change-template').click(function () {
        if ($(this).hasClass('active')) {
            hideTemplateContainer();
        } else {
            showTemplateContainer();
            hideLayoutEditor();
        }
    });

    var cvSuggestionInner = $('#cv-suggestion-inner');
    $(document).scroll(function (event) {
        if ($(document).scrollTop() < 80) {
            $('#cvo-toolbar').removeClass('fixed');
            cvSuggestionInner.removeClass('fixed');
        } else {
            $('#cvo-toolbar').addClass('fixed');
            cvSuggestionInner.addClass('fixed');

            if ($(document).scrollTop() + 60 > $('footer').offset().top - cvSuggestionInner.height()) {
                var marginTOp = $(document).scrollTop() + 70 - ($('footer').offset().top - cvSuggestionInner.height());
                marginTOp += 25;
                cvSuggestionInner.css({
                    'margin-top': '-' + marginTOp + 'px',
                })
            } else {
                cvSuggestionInner.css({
                    'margin-top': '0px',
                })
            }
        }
    });

    $('#btn-edit-cv').click(function (e) {
        e.preventDefault();
        $('#cv-message').hide();
        $('#save-done').hide();
    });

    $('#btn-template-cancel').click(function (e) {
        hideTemplateContainer();
    });
});

function showLayoutEditor()
{
    LayoutEditorControler.init(); // Reload LayoutEditor
    $('#btn-edit-layout').addClass('active');
    $('#layout-editor-container').show();
    $(document).scrollTop(0);
}

function hideLayoutEditor()
{
    $('#btn-edit-layout').removeClass('active');
    $('#layout-editor-container').hide();
    LayoutEditorControler.init();
}

function showTemplateContainer()
{
    $('#btn-change-template').addClass('active');
    $('#template-container').show();
    $(document).scrollTop(0);
}

function hideTemplateContainer()
{
    $('#btn-change-template').removeClass('active');
    $('#template-container').hide();
}

function initCVBuilder()
{
    CVOFormUtils.promptRating(cvoPromptStars);

    /* Set alert handler */
    CVOFormUtils.alertHandler(function(v, t) {
        if (t === undefined) t = 'info';

        switch (t) {
            case 'error':
                alertError(v);
                break;
            case 'warning':
                alertWarning(v);
                break;
            default:
                alertInfo(v);
                break;
        }

    });

    function alertInfo(messages) {
        // $('.suggest-default').hide();
        // $('#cv-message .content').html('<p>'+message+'<p>');
        // $('#cv-message').removeClass('error').removeClass('warning').addClass('info').slideDown(100);
    }

    function alertError(messages) {
        txt = '<ul>';
        $.each(messages, function (index, value) {
            txt += '<li>'+value+'</li>';
        });
        txt += '</ul>';

        $('.suggest-default').hide();
        $('#cv-message .content').html('<p>Kiểm tra lại các lỗi trong CV:</p> <b>' + txt + '</b><p style="margin:5px 0 0 0">Và bấm lại nút lưu CV</p>');
        $('#cv-message').removeClass('info').removeClass('warning').addClass('error').slideDown(100);
    }

    function alertWarning(messages) {
        // $('.suggest-default').hide();
        // $('#cv-message .content').html('<p>'+message+'<p>');
        // $('#cv-message').removeClass('error').removeClass('info').addClass('warning').slideDown(100);
    }

     /* Sugetsion handers */
    CVOFormUtils.suggestions(suggestions);

    // Suggestion controls
    CVOFormUtils.bindSuggestControlHandler(function (suggestType)  {
        switch (suggestType) {
            default:
                $('.suggestion-popup').popup('show');
                break;
        }
    });

     /* Validation alert handler */
    CVOFormUtils.bindValidationMessagesHander(cvoValidationErrorsDialog);

    // CVODocumentController.init();
    CVOFormController.init(cvoMeta, cvoMaster, cvoDefaultLayout, initialLayout, function () {
        // Callback when CV Builder initialized
        LayoutEditorControler.init(true);
        // Load handlers to show/hide layout-editor
        CVOFormUtils.bindShowLayoutEditorHandler(showLayoutEditor);
        CVOFormUtils.bindHideLayoutEditorHandler(hideLayoutEditor);
        // Load editor handler
        CVOFormUtils.bindEditorOnHandler(editorOn);
        CVOFormUtils.bindEditorOffHandler(editorOff);
        // Init hack cv title
        initHackCvTitle();
    });

    if ($('[cvo-form-field][type=text]').length > 0) {
        // $('[cvo-form-field][type=text]').get(0).focus();
        $(window).scrollTop(0);
    }
}

function suggestions(type, value, element)
{
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

function suggestFull(type, value)
{
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

function suggestFreetext(value)
{
    if (value !== null) {
      showSuggest(value);
    }
}

function showSuggest(message)
{
    $('#cv-suggestion-content').html(message);
    $('#cv-suggestion-default').hide();
}

function hideSuggest()
{
    $('#cv-suggestion-content').html('');
    $('#cv-suggestion-default').show();
}

function suggestJobsTopCV()
{
    var limit = 15;
    var noResult = "Hiện tại chưa có công việc nào phù hợp với bạn!<br> Bạn có thể gửi email tới hotro@topcv.vn để nhận được hỗ trợ tốt hơn.";
    $.ajax({
        url: TOPCV_SUGGEST_JOB_API,
        dataType: 'json',
        beforeSend: function() {
            // $(".jobs-container .topcv-loader").show();
            $(".topcv-jobs").html("");
        },
        success : function (response) {
            if (response.status == 'success') {
                $(".jobs-container .topcv-loader").hide();
                data = response.data;
                if (data.total > 0) {
                    // var star = "<div class='star'><i class='fa fa-bookmark'></i></div>";
                    // $(star).appendTo(".suggest-jobs .topcv-content");
                    $.each( data.jobs, function( i, job ) {
                        sendImpressionEvent('topcv', job.title);
                        var local = "";
                        for (var id in job.cities) {
                            local += job.cities[id] + " ";
                        }
                        var strType = job.strType;
                        var logo_url = job.company.logo_url;
                        var logo = "<div class='company-logo'><img src='"+logo_url+"'></div>";
                        var title = "<div class='title'><a onclick='sendClickEvent(\"topcv\", \"" + job.title + "\")' target='_blank' href='"+job.url+"'>" + job.title + "</a></div>";
                        var detail = "<div class='info'><span><i class='fa fa-map-marker'></i> " + local + "</span><span><i class='fa fa-briefcase'></i> "+strType+"</span></div>";
                        $("<div class='col'>"+logo+"<div class='job'>"+title+detail+"</div></div></div>").appendTo(".topcv-jobs");
                    });
                    $(".topcv-jobs").show();
                } else {
                }
                // alertNoJobs(data.total);
            } else {
                // $(".jobs-container .topcv-loader").show().html(noResult);
            }
        },
        error : function (error) {
            // $(".jobs-container .topcv-loader").show().html(noResult);
        }
    });
}

// function suggestJobsTVN()
// {
//     var limit = 15;
//     var noResult = "<span>Hiện tại chưa có công việc nào phù hợp với bạn!<br> Xem danh sách việc làm mới nhất <a href='"+TIM_VIEC_LAM+"'>tại đây</a></span>";
//     $.ajax({
//         url: SUGGEST_JOB_TVN_API,
//         dataType: 'json',
//         beforeSend: function() {
//             $(".topcv-loader").show();
//             $(".tvn-jobs").html("");
//         },
//         success : function (response) {
//             if (response.status == 'success') {
//                 data = response.data;
//                 if (data.total > 0) {
//                     $(".topcv-loader").hide();
//                     $.each( data.jobs, function( i, job ) {
//                         // sendImpressionEvent('tnv', job.title);
//                         var title = "<div class='title'><a onclick='sendClickEvent(\"tnv\", \"" + job.title + "\")' target='_blank' href='"+job.url+"'>" + job.quantity + " " + job.title + "</a></div>";
//                         var detail = "<div class='info'><span><i class='fa fa-money'></i> " + job.salary + "</span><span><i class='fa fa-map-marker'></i> " + job.cities + "</span></div>";
//                         var description = job.description;
//                         var logo_img = job.company_logo;
//                         var logo = "<div class='company-logo'><img src='"+WHITE_LOGO_150+"'></div>";
//                         if (logo_img != '') logo = "<div class='company-logo'><img src='"+logo_img+"'></div>";
//                         $("<div class='col' title='"+description+"'>"+logo+"<div class='job'>"+title+detail+"</div></div>").appendTo(".tvn-jobs");
//                     });
//                     $(".tvn-jobs").show();
//                 } else {
//                     $(".jobs-container .topcv-loader").hide();
//                 }
//                 // alertNoJobs(data.total);
//             } else {
//                 $(".jobs-container .topcv-loader").show().html(noResult);
//             }
//         },
//         error : function (error) {
//             $(".jobs-container .topcv-loader").show().html(noResult);
//         }
//     });
// }

// function suggestJobsVlance()
// {
//     var limit = 15;
//     var noResult = "Hiện tại chưa có công việc nào phù hợp với bạn!<br> Bạn có thể gửi email tới hotro@topcv.vn để nhận được hỗ trợ tốt hơn.";
//     $.ajax({
//         url: SUGGEST_JOB_VLANCE_API,
//         dataType: 'json',
//         beforeSend: function() {
//             $(".jobs-container .vlance-loader").show();
//             $(".vlance-jobs").html("");
//         },
//         success : function (response) {
//             if (response.status == 'success') {
//                 data = response.data;
//                 if (data.total > 0) {
//                     $(".jobs-container .vlance-loader").hide();
//                     $.each( data.jobs, function( i, job ) {
//                         sendImpressionEvent('vlance', job.title);
//                         var title = "<div class='title'><a onclick='sendClickEvent(\"vlance\", \"" + job.title + "\")' target='_blank' href='"+job.url+"'>" + job.title + "</a></div>";
//                         var detail = "<div class='info'><span><i class='fa fa-money'></i> " + job.strBudget + "</span><span><i class='fa fa-clock-o'></i> còn " + job.deadline_remaining + " ngày nữa</span></div>";
//                         var logo = "<div class='company-logo'><img src='"+WHITE_LOGO_150+"'></div>";
//                         $("<div class='col'>"+logo+"<div class='job'>"+title+detail+"</div></div>").appendTo(".vlance-jobs");
//                     });
//                     $(".vlance-jobs").show();
//                 } else {
//                     $(".jobs-container .vlance-loader").hide();
//                 }
//                 // alertNoJobs(data.total);
//             } else {
//                 $(".jobs-container .vlance-loader").html(noResult);
//             }
//         },
//         error : function (error) {
//             $(".jobs-container .vlance-loader").html(noResult);
//         }
//     });
// }

// function suggestJobsTopdev()
// {
//     var limit = 5;
//     var noResult = "Hiện tại chưa có công việc nào phù hợp với bạn!<br> Bạn có thể gửi email tới hotro@topcv.vn để nhận được hỗ trợ tốt hơn.";
//     $.ajax({
//         url: SUGGEST_JOB_TOPDEV_API,
//         dataType: 'json',
//         beforeSend: function() {
//             $(".suggest-jobs .loading-job").show();
//             $(".suggest-jobs .content").html("");
//         },
//         success : function (response) {
//             if (response.status == 'success') {
//                 data = response.data;
//                 if (data.total > 0) {
//                     $(".suggest-jobs .loading-job").hide();
//                     $.each( data.jobs, function( i, job ) {
//                         sendImpressionEvent('topdev', job.title);
//                         var title = "<div class='title-job'><a onclick='sendClickEvent(\"topdev\", \"" + job.title + "\")' target='_blank' href='"+job.url+"'>" + job.title + "</a></div>";
//                         var detail = "<div class='info-job'><span><i class='fa fa-map-marker'></i> " + job.cities + "</span></div>";
//                         $("<div class='detail'>"+title+detail+"</div>").appendTo(".suggest-jobs .content");
//                     });
//                     $(".suggest-jobs .content").show();
//                 } else {
//                     $(".suggest-jobs .loading-job").hide();
//                     // $(".result-title").html("Chức năng đang được thử nghiệm với giới hạn người dùng.").show();
//                     // $(".survey-suggest-job").show();
//                 }
//                 alertNoJobs(data.total);
//             } else {
//                 $(".suggest-jobs .loading-job").html(noResult);
//             }
//         },
//         error : function (error) {
//             $(".suggest-jobs .loading-job").html(noResult);
//         }
//     });
// }

var viecNgayJobContainer = $('.viecngay-jobs');
function destroyViecNgayPinto() {
    if (viecNgayJobContainer.hasClass('pinto-loaded')) {
        viecNgayJobContainer.pinto('destroy').removeClass('pinto-loaded');
    }
}
function initViecNgayPinto() {
    viecNgayJobContainer.pinto({
        itemWidth: 256,
        gapX: 30,
        gapY: 30,
    }).addClass('pinto-loaded');
}
function suggestJobsViecNgay()
{
    $.ajax({
        url: VIECNGAY_SUGGEST_JOB_API,
        dataType: 'json',
        beforeSend: function() {
            $('.viecngay-loader').show();
            destroyViecNgayPinto();
            $('.viecngay-jobs').html("");
        },
        success : function (response) {
            if (response.status == 'success') {
                $('.viecngay-loader').hide();
                $('.viecngay-jobs').height(0).html(response.html);
                viecNgayJobContainer.imagesLoaded(function () {
                    initViecNgayPinto();
                });
            }
        },
        error : function (error) {
        }
    });
}

function countSuggestJob() {
    $.ajax({
        url: SUGGEST_JOB_COUNT_URL,
        type: 'GET',
        dataType: 'json',
    })
    .done(function(response) {
        if (response.status == 'success') {
            if (parseInt(response.total) > 0) {
                $('#count-suggest-job').html(response.total);
                $('#has-suggest-job').show();
            } else {
                $('#has-no-suggest-job').show();
            }
        }
    })
    .fail(function() {
        console.log("error");
    })
    .always(function() {
        console.log("complete");
    });

}

function showPrivacySetting()
{
    if ($.cookie("show-setting-privacy-cv") != 1) {
        $('#save-done .privacy').click(function() {
            $(this).fadeOut(5000);
        });
        $('#save-done .privacy').show();
        $.cookie("show-setting-privacy-cv", 1, { expires : 180 });
    }
}

var btnSaveCv = $('#btn-save-cv');
function ajaxSaveForm() {
    var ajaxSaveOptions = {
        beforeSend: function() {
            CVOFormController.setSaving(true);
            btnSaveCv.find('.title').text('Đang lưu');
        },
        success: function (response) {
            if (response.status == 'success') {
                builder.cv_id = response.cv_id;
                $('#save-done').show();
                $('#save-done .cv-online').val(response.online_url);
                $('#btn-view-cv').attr('href', response.origin_url);
                $('#save-done .btn-download-cv').data('id', builder.cv_id);
                $('#cvo-toolbar-lang').remove();
                $('#cvoForm').find('input[name=cv_id]').val(builder.cv_id);
                $('#cvoForm').attr('action', URL_EDIT);
                history.pushState(null, null, response.edit_url);
                suggestJobsTopCV();
                // suggestJobsTopdev();
                // suggestJobsVlance();
                // suggestJobsTVN();
                suggestJobsViecNgay();
                countSuggestJob();
            } else {
                alert(response.error);
            }
            btnSaveCv.find('.title').text('Lưu CV');
            CVOFormController.setSaving(false);
        },
        error: function (error) {
            CVOFormController.setSaving(false);
            alert('Lưu CV thất bại!');
        }
    }
    CVOFormController.ajaxSaveForm(ajaxSaveOptions);
}

function saveCv()
{
    $(document).scrollTop(0);
    ajaxSaveForm();
    // showPrivacySetting();
}

function updateCvTitleAndSave()
{
    var cvTitle = $('#inp-cv-title').val().trim();
    if (!cvTitle.length) {
        $('#error-cv-title-empty').show();
        return false;
    } else {
        $('#error-cv-title-empty').hide();
    }
    $('#cv-title').html(cvTitle).trigger('input');
    $('#modal-update-cv-title').modal('hide');
    saveCv();
}

function showUpdateTitlePopup()
{
    $('#inp-cv-title').val('');
    $('#modal-update-cv-title').modal('show');
    $('#inp-cv-title').focus();
}

// Init event CV Builder
$(document).ready(function () {
    btnSaveCv.click(function (e) {
        e.preventDefault();
        var cvTitle = $('#cv-title').html();
        if (!cvTitle.length || cvTitle == 'Untitled CV') {
            showUpdateTitlePopup();
        } else {
            saveCv();
        }
    });
    $('#inp-cv-title').keypress(function (e) {
      if (e.which == 13) {
            updateCvTitleAndSave();
            return false;
      }
    });
    $('.ads-close').click(function() {
        $('.ads-viet-cv').hide();
        $('#cv-suggestion-container').css({'height' : '600px'});
    })
});
