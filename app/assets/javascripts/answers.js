$(document).on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    var answer_id = $(this).data('answerId');

    $('p#answer-buttons-' + answer_id).hide();
    $('p#edited-answer-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();

    $(document).on('click', '.cancel', function(e) {
        e.preventDefault();
        $('form#edit-answer-' + answer_id).hide();
        $('p#edited-answer-' + answer_id).show();
        $('#answer-buttons-' + answer_id).show();
    });
});
