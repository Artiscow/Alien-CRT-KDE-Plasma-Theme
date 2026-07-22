/*
 * WEYLAND-YUTANI CRT — Plasma splash :: System Online
 * Clean (no CRT scanlines). The emblem and ONLINE both animate in at the very start,
 * then hold.
 */
import QtQuick

Image {
    id: root
    property real uiScale: 1.0   // 0.8 = Small, 1.0 = Medium, 1.25 = Large
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

    property int stage   // set by ksplash; unused (animation is self-timed)

    FontLoader { id: mono; source: "share-tech-mono.woff2" }
    property string monoFamily: mono.status === FontLoader.Ready ? mono.name : "monospace"

    Column {
        anchors.centerIn: parent
        spacing: Math.round(root.height * root.uiScale * 0.04)

        Image {
            id: emblem
            source: "images/emblem_glow.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(root.height * root.uiScale * 0.60)   // follows the S/M/L size setting
            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: 0
            scale: 0.94
            // powers on at the start, then breathes gently
            SequentialAnimation {
                running: true
                ParallelAnimation {
                    NumberAnimation { target: emblem; property: "opacity"; from: 0; to: 1; duration: 650; easing.type: Easing.OutCubic }
                    NumberAnimation { target: emblem; property: "scale"; from: 0.94; to: 1.0; duration: 850; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
                }
                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation { target: emblem; property: "scale"; from: 1.0; to: 1.012; duration: 1600; easing.type: Easing.InOutSine }
                    NumberAnimation { target: emblem; property: "scale"; from: 1.012; to: 1.0; duration: 1600; easing.type: Easing.InOutSine }
                }
            }
        }

        Text {
            id: online
            text: "O N L I N E"
            color: "#7dff96"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: root.monoFamily
            font.pixelSize: Math.round(root.height * root.uiScale * 0.034)
            font.letterSpacing: 8
            opacity: 0
            // fades in at the start, together with the emblem
            NumberAnimation on opacity { from: 0; to: 1; duration: 700; easing.type: Easing.InOutQuad; running: true }
        }
    }
}
