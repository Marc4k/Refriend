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
                title: 'New event!',
                body: request.EventName
            }
        };

        admin.messaging().sendToTopic(topic, payload)
});



    
exports.sendChatNotification = functions.firestore
    .document('chats/{eventID}/message/{messageID}').onWrite((change, context) => {

        var request = change.after.data()
        functions.logger.log(request.GroupID);


        var topic = request.GroupID;
        const payload = {
            notification: {
                title: request.Name,
                body: request.Message
            }
        };

        admin.messaging().sendToTopic(topic, payload)
});