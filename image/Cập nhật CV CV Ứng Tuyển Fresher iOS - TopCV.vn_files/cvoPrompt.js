/**
 * Demo a jquery classic promt that can fit with CVOFormUtils
 * Using window prompt
 *
 * @param function callback
 *
 * @author Vu Nhat Anh <anhvnse@gmail.com>
 */

function cvoPromptClassic(callback, val) {
    // Take input from user
    if (val === undefined || val === null) {
        val = '';
    }
    var input = window.prompt('Enter rating', val);
    // Promt mus have callback that received prompted input
    callback(input);
}

/**
 * Demo a beautiful prompt that fit with CVOFormUtils
 * Using jquery and css3
 *
 * @param function callback
 *
 * @author Vu Nhat Anh <anhvnse@gmail.com>
 */

function cvoPrompt(callback, val) {
    // Take input from user
    var cvoMask = $('<div/>').addClass('cvoPromptMask');
    var htmlForm = '<form id="frmCvoPrompt"><input type="text" id="cvoPromptInput"></form>';
    cvoMask.html(htmlForm);
    if (val !== undefined && val !== null) {
        cvoMask.find('input#cvoPromptInput').val(val);
    }
    cvoMask.appendTo($('body'));
    $('#frmCvoPrompt').submit(function (e) {
        var input = $('#cvoPromptInput').val();
        // Promt callback that received prompted input
        callback(input);
        e.preventDefault();
        $('.cvoPromptMask').remove();
    });
    cvoMask.show();
}


/**
 * Demo a stars prompt that fit with CVOFormUtils
 * Using jquery and css3
 *
 * @param function callback
 *
 * @author Vu Nhat Anh <anhvnse@gmail.com>
 */

function cvoPromptStars(callback, val) {
    // Take input from user
    var cvoMask = $('<div/>').addClass('cvoPromptMask');
    var htmlForm = '<form id="frmCvoPromptStars">'+
        '<div class="cvoStarsRating">' +
        '<span value="5" class="btn_star"><i class="fa fa-star"></i></span>'+
        '<span value="4" class="btn_star"><i class="fa fa-star"></i></span>'+
        '<span value="3" class="btn_star"><i class="fa fa-star"></i></span>'+
        '<span value="2" class="btn_star"><i class="fa fa-star"></i></span>'+
        '<span value="1" class="btn_star"><i class="fa fa-star"></i></span>'+
        '</div>' +
        '</form>';
    cvoMask.html(htmlForm);
    if (val !== undefined && val !== null) {
        cvoMask.find('span[value='+val+']').addClass('rated');
    }
    cvoMask.find('.btn_star').click(function (e) {
        var input = $(this).attr('value');
        // Promt callback that received prompted input
        callback(input);
        e.preventDefault();
        $('.cvoPromptMask').remove();
    });
    cvoMask.appendTo($('body'));
    cvoMask.show();
}




