// Пока не используем

import consumer from "channels/consumer"

//consumer.subscriptions.create("NodeChannel", {
  //connected() {
    //// Called when the subscription is ready for use on the server
  //},

  //disconnected() {
    //// Called when the subscription has been terminated by the server
  //},

  //received(data) {
    //// Called when there's incoming data on the websocket for this channel
  //}
//});

document.
  querySelectorAll('[data-node-channel]').
  forEach( (el) => {
    const nodeId = el.dataset['nodeChannel'];
    consumer.subscriptions.create({ "channel": "NodeChannel", "id": nodeId }, {
      connected() {
        console.log('Connected to NodeChannel');
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log('Received node update', data);

        //var element = document.querySelector(`[data-setup-project='${nodeId}']`);
        //if (element && data.group_setup_page) {
          //element.innerHTML = data.group_setup_page;
          //document.querySelectorAll('[data-checkbox-value="true"]').forEach((element) => { element.classList.add('animate__animated', 'animate__bounceIn'); });
        //}
      }
    });
  });
