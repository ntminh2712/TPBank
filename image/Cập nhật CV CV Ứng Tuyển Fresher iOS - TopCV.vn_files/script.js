$(document).ready(function () {
    // Handle drop file outsize drop area
    $(document).on('dragenter', function (e) {
        e.stopPropagation();
        e.preventDefault();
    });

    $(document).on('dragover', function (e) {
      e.stopPropagation();
      e.preventDefault();
    });

    $(document).on('drop', function (e) {
        e.stopPropagation();
        e.preventDefault();
    });
});

function cropperImageEditor(element)
{
    editImgLock = 0;
    $('.imageEditor').hide();
    $('.image-controls').hide();
    $('.loadingShow').hide();
    $('.imageEditor > img').hide().cropper('destroy');
    $('#imgChanged').val(0);
    $('.editorChooseImage').show();
    var currentImage = $(element).attr('value');
    if (currentImage && currentImage !== 'no_avatar.jpg') {
        initCropImageEditorWithImage(element);
    } else {
        initCropImageEditorNoImage(element);
    }
    $('#saveEditedAvatar').off('noavatar'); // Unbind old event if binded before
    $('#saveEditedAvatar').on('noavatar', function () {
        $(element).attr('src', '/upload/images/avatars/no_avatar.jpg');
        $(element).attr('value', '');
    });
    $('#saveEditedAvatar').ajaxForm({
        beforeSend: function () {
            showLoadingImageEditor('Đang lưu thay đổi ...');
        },
        success: function (response) {
            hideLoadingImageEditor();
            if (response.status == 'success') {
                $(element).attr('src', response.data.image_url);
                $(element).attr('value', response.data.name);
                closeImageEditor();
            } else {
                alert(response.error);
            }
        },
        error: function(error) {
            hideLoadingImageEditor();
            alert('Lỗi!');
            console.log(error) ;
        }
    })
}

function initCropImageEditorNoImage(element)
{
    $('.img-edit-preview img').attr('src', '/upload/images/avatars/no_avatar.jpg');
    $('.edit-image-btns').hide();
    $('#imageEditorWraper').show();
}

function initCropImageEditorWithImage(element)
{
    $('.img-edit-preview img').attr('src', $(element).attr('src'));
    $('.edit-image-btns').show();
    $('#imageEditorWraper').show();
}

function uploadAvatar()
{
    if (editImgLock !== 0) return;

    // Init uploadForm
    var uploadForm = $('#cvoFormUploadImage').clone();
    uploadForm.attr('id', getUniqid());

    uploadForm.ajaxForm({
        contentType: 'json',
        cache: false,
        beforeSend: function () {
            showLoadingImageEditor('Đang tải ảnh lên ...');
        },
        success: function (response) {
            hideLoadingImageEditor();
            if (response.status == 'success') {
                $('#saveEditedAvatar input[name=key]').val(response.data.key);
                initCropper(response.data.image_url);
            } else {
                alert(response.error, 'error');
            }
        },
        error: function(error) {
            hideLoadingImageEditor();
            alert('Lỗi!');
        }
    });

    uploadForm.find('[name=cvoFormImageFile]').change(function() {
        if ($(this).val()) {
            uploadForm.submit();
        }
    }).trigger('click');
}

function dropUploadAvatar(files, cvId, url)
{
    if (editImgLock !== 0) {
        return;
    }
    if (files.length > 1) {
        alert('Bạn chỉ được upload tối đa 1 file 1 lần!');
    }
    var formData = new FormData();
    formData.append('cvoFormImageFile', files[0]);
    formData.append('cvKey', cvId);
    formData.append('_token', getToken());
    $.ajax({
        url: url,
        type: 'POST',
        cache: false,
        processData: false,
        contentType:false,
        data: formData,
        beforeSend: function () {
            showLoadingImageEditor('Đang tải ảnh lên ...');
        },
        success: function (response) {
            hideLoadingImageEditor();
            if (response.status == 'success') {
                $('#saveEditedAvatar input[name=key]').val(response.data.key);
                initCropper(response.data.image_url);
            } else {
                alert(response.error, 'error');
            }
        },
        error: function(error) {
            hideLoadingImageEditor();
            alert('Lỗi!');
        }
    });
}
function showLoadingImageEditor(message) {
    editImgLock = 1;
    $('.loadingMessage').text(message);
    $('.loadingShow').show();
}
function hideLoadingImageEditor() {
    $('.loadingShow').hide();
    editImgLock = 0;
}
function initCropper(image)
{
    if ('undefined' == typeof cropRatio) {
        cropRatio = 1;
    }

    $('.imageEditor > img').hide().cropper('destroy').attr('src', image).cropper({
        aspectRatio: cropRatio,
        preview: '.img-edit-preview'
    }).show();

    $('.editorChooseImage').hide();
    $('.imageEditor').show();
    $('.edit-image-btns').show();
    $('#inpNoImage').val(0);
    $('#imgChanged').val(1);
    $('.image-controls').show();
}
function setNoImage()
{
    $('.imageEditor').hide();
    $('.editorChooseImage').show();
    $('.imageEditor > img').hide().cropper('destroy');
    $('.img-edit-preview img').attr('src', '/upload/images/avatars/no_avatar.jpg');
    $('#inpNoImage').val(1);
    $('#imgChanged').val(1);
    $('.image-controls').hide()
}
function saveAvatar()
{
    if ($('#imgChanged').val() == 0) {
        closeImageEditor();
        return;
    }
    if ($('#inpNoImage').val() == 1) {
        $('#saveEditedAvatar').trigger('noavatar');
        closeImageEditor();
        return;
    }
    var data = $('.imageEditor > img').cropper('getData');
    $('#inpCropX').val(data.x);
    $('#inpCropY').val(data.y);
    $('#inpCropW').val(data.width);
    $('#inpCropH').val(data.height);
    $('#inpRotate').val(data.rotate);
    $('#saveEditedAvatar').submit();
}
function closeImageEditor()
{
    $('#imageEditorWraper').hide();
}
function initImageControls()
{
    $('.btn-zoom-in-image').click(function () {
        $('.imageEditor > img').cropper('zoom', 0.1);
    });
    $('.btn-zoom-out-image').click(function () {
        $('.imageEditor > img').cropper('zoom', -0.1);
    });
    $('.btn-rotate-left').click(function () {
        $('.imageEditor > img').cropper('rotate', -90);
    });
    $('.btn-rotate-right').click(function () {
        $('.imageEditor > img').cropper('rotate', 90);
    });
}