/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.sendPostNotification = functions.region("asia-northeast3").https.onCall(async (data, context) => {
  const {ownerToken, postTitle, notificationBody, postId, senderDisplayName} = data;

  const payload = {
    notification: {
      title: `${senderDisplayName}님이 ${postTitle}글의 댓글을 남겼습니다`,
      body: notificationBody,
      },
      data: {
        title: postTitle,
        body: notificationBody,
        postId: postId,
        type: 'post',
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        id: "1",
        status: "done",
        sound: "default",
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

exports.sendChatNotification = functions.region("asia-northeast3").https.onCall(async (data, context) => {
  const {ownerToken, senderId, notificationBody, senderDisplayName} = data;

  const payload = {
    notification: {
      title: `${senderDisplayName}님이 메세지를 보냈습니다`,
      body: notificationBody,
      },
      data: {
        title: "채팅 알림",
        body: notificationBody,
        senderId: senderId,
        type: 'chat',
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        id: "1",
        status: "done",
        sound: "default",
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
