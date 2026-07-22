/*
 * WEYLAND-YUTANI CRT — Plasma splash :: Emblem Ignition
 * The emblem powers on the moment the splash appears (self-timed, not stage-gated),
 * then breathes gently. Rolling CRT scanlines + a sweeping phosphor band on top.
 */
import QtQuick

Image {
    id: root
    property bool crt: true   // false = "no CRT line" theme variant
    property real uiScale: 1.0   // 0.8 = Small, 1.0 = Medium, 1.25 = Large
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

    property int stage   // set by ksplash; unused (animation is self-timed)

    Image {
        id: emblem
        source: "images/emblem_glow.png"
        anchors.centerIn: parent
        width: Math.round(root.height * root.uiScale * 0.75)   // height-based so it doesn't sprawl on ultrawide
        fillMode: Image.PreserveAspectFit
        smooth: true
        opacity: 0
        scale: 0.94

        SequentialAnimation {
            running: true
            ParallelAnimation {
                NumberAnimation { target: emblem; property: "opacity"; from: 0; to: 1; duration: 700; easing.type: Easing.OutCubic }
                NumberAnimation { target: emblem; property: "scale"; from: 0.94; to: 1.0; duration: 900; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
            }
            SequentialAnimation {
                loops: Animation.Infinite
                NumberAnimation { target: emblem; property: "scale"; from: 1.0; to: 1.015; duration: 1600; easing.type: Easing.InOutSine }
                NumberAnimation { target: emblem; property: "scale"; from: 1.015; to: 1.0; duration: 1600; easing.type: Easing.InOutSine }
            }
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
