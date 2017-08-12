App.cable.subscriptions.create('QuestionsChannel', {
    connected: function () {
        if ($('.questions-list').length) {
            this.perform('follow');
        } else {
            this.perform('unfollow');
        }
    },
    received: function(data) {
        $('.questions-list').prepend(data);
    }
})
