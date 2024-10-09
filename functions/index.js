const {pubsub} = require("firebase-functions/v2");
const admin = require("firebase-admin");
admin.initializeApp();

// إرسال إشعار تذكير بالدواء كل 5 ساعات
exports.sendMedicationReminder = pubsub
    .schedule("every 5 hours")
    .onRun(async (context) => {
      const message = {
        notification: {
          title: "تذكير بأخذ الدواء",
          body: "لا تنسَ أخذ الدواء الآن للحفاظ على صحتك.",
        },
        topic: "patients",
      };

      await admin.messaging().send(message);
      console.log("Notification sent");
    });

// إرسال نصائح صحية كل 3 ساعات
exports.sendHealthTips = pubsub
    .schedule("every 3 hours")
    .onRun(async (context) => {
      const tips = [
        "شرب كمية كافية من الماء.",
        "تناول طعام صحي.",
        "الحفاظ على مستوى نشاط بدني معتدل.",
      ];

      const randomTip = tips[Math.floor(Math.random() * tips.length)];

      const message = {
        notification: {
          title: "نصيحة صحية",
          body: randomTip,
        },
        topic: "patients",
      };

      await admin.messaging().send(message);
      console.log("Health tip notification sent");
    });
