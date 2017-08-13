App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
        var question_id = $(".question").data("id");
        if (question_id) {
            this.perform('follow_comments', {
                id: question_id
            });
        } else {
            this.perform('unfollow');
        }
    },
    received: function(data) {
        var current_user_id = gon.current_user_id,
            comment_user_id = data.comment.user_id;
        if (current_user_id !== comment_user_id) {
            var $comments_list = '#comments-' + data['commentable_type'] + '-' + data['commentable_id'];

            $($comments_list).append(JST["templates/comments/comment"]({
                comment: data.comment,
                user_email: data.comment_user_email
            }));
        }
    }
});
