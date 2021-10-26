import consumer from "./consumer"

consumer.subscriptions.create("MessageChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if(data.nopaid_count != null) {
      document.getElementById('get-count').innerHTML = data.nopaid_count
      return location.reload();
    } else if (data.change_credit = 'change-credit') {
      var container = document.getElementById('credit-no')
      var content = container.innerHTML
      container.innerHTML= content
      return location.reload();
    } else if (data.user_delete = 'user-delete') {
      var container = document.getElementById('bookings')
      var content = container.innerHTML
      container.innerHTML= content
      return location.reload();
    } else {
      document.getElementById('cancel-count').innerHTML = data.cancel_count
      return location.reload();
    }

  }
});
