importScripts("https://www.gstatic.com/firebasejs/7.22.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/7.22.0/firebase-messaging.js"
);

const firebaseConfig = {
  apiKey: "AIzaSyBlDmSd7-4fzuILJhUYlRQBpy3KyFS7_3E",
  authDomain: "kashfly-48eaa.firebaseapp.com",
  databaseURL: "https://kashfly-48eaa.firebaseio.com",
  projectId: "kashfly-48eaa",
  storageBucket: "kashfly-48eaa.appspot.com",
  messagingSenderId: "425270968391",
  appId: "1:425270968391:web:2bb79c0d5c936627b5b162",
  measurementId: "G-V4WDZ9FJGM"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
  const promiseChain = clients
    .matchAll({
      type: "window",
      includeUncontrolled: true,
    })
    .then(function (windowClients) {
      for (var i = 0; i < windowClients.length; i++) {
        const windowClient = windowClients[i];
        windowClient.postMessage(payload);
      }
    })
    .then(function () {
      return registration.showNotification(payload.data.title, {
        body: payload.data.body,
      });
    });
  return promiseChain;
});
self.addEventListener("notificationclick", function (event) {
  console.log("notification received: ", event);
});
