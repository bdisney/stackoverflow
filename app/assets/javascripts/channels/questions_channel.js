App.cable.subscriptions.create('QuestionsChannel', {
    connected: function () {
        this.perform('follow') ;
    },
    received: function(data) {
        $('.questions-list').prepend(data);
    }
})
