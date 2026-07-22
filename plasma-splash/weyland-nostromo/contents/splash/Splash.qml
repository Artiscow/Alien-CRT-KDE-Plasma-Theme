/*
 * WEYLAND-YUTANI CRT — Plasma splash :: Nostromo Power-up
 * Pulsing emblem over a segmented power gauge that fills SMOOTHLY on a timer
 * (KDE only gives coarse load stages, so we animate our own steady 0->100%).
 * Rolling CRT scanlines + a sweeping phosphor band on top.
 */
import QtQuick

Image {
    id: root
    property bool crt: true   // false = "no CRT line" theme variant
    property real uiScale: 1.0   // 0.8 = Small, 1.0 = Medium, 1.25 = Large
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

    property int stage           // set by ksplash; unused (gauge is self-timed)
    property real prog: 0
    NumberAnimation on prog { from: 0; to: 1; duration: 3400; easing.type: Easing.InOutQuad; running: true }

    FontLoader { id: mono; source: "share-tech-mono.woff2" }
    property string monoFamily: mono.status === FontLoader.Ready ? mono.name : "monospace"

    Column {
        anchors.centerIn: parent
        spacing: Math.round(root.height * root.uiScale * 0.045)

        Image {
            id: emblem
            source: "images/emblem_glow.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(root.height * 0.60)   // emblem stays a fixed size (not affected by uiScale)
            fillMode: Image.PreserveAspectFit
            smooth: true
            SequentialAnimation on scale {
                running: true
                loops: Animation.Infinite
                NumberAnimation { from: 0.99; to: 1.02; duration: 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.02; to: 0.99; duration: 1500; easing.type: Easing.InOutSine }
            }
        }

        Text {
            text: "NOSTROMO // MAIN BUS ENERGIZING"
            color: "#3bd16f"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: root.monoFamily
            font.pixelSize: Math.round(root.height * root.uiScale * 0.026)
            font.letterSpacing: 4
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Math.round(root.height * root.uiScale * 0.007)   // height-based (was width-based → too wide on 32:9)
            Repeater {
                model: 24
                Rectangle {
                    width: Math.round(root.height * root.uiScale * 0.046)
                    height: Math.round(root.height * root.uiScale * 0.024)
                    color: "#3bd16f"
                    opacity: index < Math.round(root.prog * 24) ? 1.0 : 0.12
                    Behavior on opacity { NumberAnimation { duration: 160 } }
                }
            }
        }

        Text {
            text: Math.round(root.prog * 100) + "%"
            color: "#7dff96"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: root.monoFamily
            font.pixelSize: Math.round(root.height * root.uiScale * 0.024)
            font.letterSpacing: 3
        }
    }

    // ---- CRT: rolling scanline grille + sweeping phosphor band ----
    // Animate a normalized 0..1 value and BIND the position to the CURRENT sizes, so it
    // never freezes on the first cycle before the splash window has its real dimensions.
    Image {
        id: band
        visible: root.crt
        x: 0; width: parent.width
        height: Math.round(parent.height * 0.20)
        source: "images/crt_band.png"
        fillMode: Image.Stretch
        opacity: 0.13
        property real t: 0
        NumberAnimation on t { from: 0; to: 1; duration: 4500; loops: Animation.Infinite; running: true }
        y: -height + t * (root.height + height)
    }
    Image {
        id: grille
        visible: root.crt
        x: 0; width: parent.width
        height: parent.height + 16
        source: "images/crt_grille.png"
        fillMode: Image.Stretch
        opacity: 0.26
        property real t: 0
        NumberAnimation on t { from: 0; to: 1; duration: 800; loops: Animation.Infinite; running: true }
        y: -t * 16
    }
}
