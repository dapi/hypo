import consumer from "channels/consumer"

document.
  querySelectorAll('[data-session-channel]').
  forEach( (el) => {
    const sessionId = el.dataset['sessionChannel'];
    consumer.subscriptions.create({ "channel": "SessionsChannel", "id": sessionId }, {
      connected() {
        console.log('Connected');
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log('Received', data);

        //var element = document.querySelector(`[data-setup-project='${sessionId}']`);
        //if (element && data.group_setup_page) {
          //element.innerHTML = data.group_setup_page;
          //document.querySelectorAll('[data-checkbox-value="true"]').forEach((element) => { element.classList.add('animate__animated', 'animate__bounceIn'); });
        //}
      }
    });
  });
