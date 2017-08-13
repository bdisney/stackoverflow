App.cable.subscriptions.create("AnswersChannel", {
    connected: function () {
        var question_id = $(".question").data("id");
        if (question_id) {
            this.perform('follow_answers', {id: question_id});
        }
        else {
            this.perform('unfollow');
        }
    },

    received: function (data) {
        var current_user_id = gon.current_user_id,
            answer_user_id = JSON.parse(data["answer_user_id"]);
        if (current_user_id !== answer_user_id) {
            $('.answers-list').append(JST["templates/answers/answer"]({
                data: data
            }));
        }
    }
});
