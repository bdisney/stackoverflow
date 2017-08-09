$(document).ready(function() {
    $('.container').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        var question_id = $(this).data('questionId');

        $('.question-buttons').hide();
        $('.question-body').hide();
        $('form#edit-question-' + question_id).show();

        $('.container').on('click', '.cancel', function (e) {
            e.preventDefault();
            $('form#edit-question-' + question_id).hide();
            $('.question-body').show();
            $('.question-buttons').show();
        });
        return false;
    });
});
