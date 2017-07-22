$(document).on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    var question_id = $(this).data('questionId');
    var question_title = $('.question-title').val();

    $('.question-buttons').hide();
    $('.question-body').hide();
    $('form#edit-question-' + question_id).show();

    $(document).on('click', '.cancel', function(e) {
        e.preventDefault();
        $('form#edit-question-' + question_id).hide();
        $('.question-body').show();
        $('.question-buttons').show();
    });
});
