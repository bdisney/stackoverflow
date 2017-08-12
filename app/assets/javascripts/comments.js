$(document).ready(function() {
    $('.container').on('click', '.add-comment', function () {
        var $trigger = $(this),
            $comment_form = $trigger.next('form#new_comment');

        $trigger.hide();
        $comment_form.show();

        $comment_form.on('click', '.cancel-comment', function (e) {
            e.preventDefault();
            $comment_form.hide();
            $trigger.show();
        });
        return false;
    });
});

$(document).on('ajax:success', 'form.new_comment', function(e, data) {
    var $comment_form = $(this),
        $form_container = $comment_form.closest('.comment-form'),
        $comments_list = $form_container.closest('.item-comments').find('.comments-list');

    $comments_list.append(JST["templates/comments/comment"]({
        comment: data,
        user_email: data.user.email
    }));
    $comment_form.find('#comment_body').val('');
    $form_container.find('.add-comment').show();
    $comment_form.hide();
}).on('ajax:error', 'form.new_comment', function() {
    $('#toast-container').remove();
});

$(document).on('ajax:success', '.comment-delete', function() {
    $(this).closest('.comment').remove();
});
