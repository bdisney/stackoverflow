$(document).on('ajax:success', '.vote-links', function (e, data) {
    var $vote_container = $(this).closest('.vote');
    var $vote_links = $vote_container.find('a');
    var $rating = $vote_container.find('.rating');

    $vote_links.removeClass('voted');
    $rating.text(data.rating);
    if (data.vote) {
        $(this).addClass('voted');
    };
}).on('ajax:error', function (e, xhr) {
    toastr.error(xhr.responseJSON);
});
