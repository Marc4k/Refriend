const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

//Now we're going to create a function that listens to when a 'Notifications' node changes and send a notificcation
//to all devices subscribed to a topic



exports.sendGroupNotification = functions.firestore
    .document('groups_events/{groupID}/event_chat/{eventID}').onWrite((change, context) => {


        var request = change.after.data()
        functions.logger.log(request.GroupID);


        var topic = request.GroupID;
        const payload = {
            notification: {
                title: 'New event:'+ request.EventName,
                body: request.Description
            }
        };

        admin.messaging().sendToTopic(topic, payload)
        .then((response) => {
            console.log("Successfully sent message: ", response);
            return true;
        })
        .catch((error) => {
            console.log("Error sending message: ", error);
            return false;
        })

    });



    
exports.sendChatNotification = functions.firestore
    .document('chats/{eventID}/message/{messageID}').onWrite((change, context) => {

//        chats/${widget.chatID}/message
        var request = change.after.data()
        functions.logger.log(request.GroupID);


        var topic = request.GroupID;
        const payload = {
            notification: {
                title: "New Message:",
                body: request.Message
            }
        };

        admin.messaging().sendToTopic(topic, payload)
        .then((response) => {
            console.log("Successfully sent message: ", response);
            return true;
        })
        .catch((error) => {
            console.log("Error sending message: ", error);
            return false;
        })

    });