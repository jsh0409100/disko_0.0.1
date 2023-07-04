/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.sendNotifications = functions.region("asia-northeast3").https.onCall(async (data, context) => {
  const {ownerToken, postTitle} = data;

  const payload = {
    notification: {
      title: postTitle,
        body: "this is test body",
      },
      data: {
        title: postTitle,
        body: "this is test data body",
        postId: "none",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        id: "1",
        status: "done",
        sound: "default",
        route: '/chat-screen'
      },
  };
  try {
    const response = await admin.messaging().sendToDevice(
      ownerToken, payload,
        {
        // Required for background/quit data-only messages on iOS
          contentAvailable: true,
          // Required for background/quit data-only messages on Android
          priority: "high",
        },
    );
    console.log('Successfully sent message:', response);
    return response;
  } catch (error) {
    console.log("Error sending message:", error);
    throw new functions.https.HttpsError("internal", "Error sending message");
  }
});
