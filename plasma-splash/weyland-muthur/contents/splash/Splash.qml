/*
 * WEYLAND-YUTANI CRT — Plasma splash :: MU-TH-UR Console
 * The ship's computer runs its startup self-test: each subsystem's label snaps in, the
 * dots crawl across as it's probed, then OK lands — ending on ALL SYSTEMS NOMINAL /
 * STARTUP COMPLETE with the cursor waiting. Self-timed. CRT scanlines + sweep on top.
 */
import QtQuick

Image {
    id: root
    property bool crt: true      // false = "no CRT line" theme variant
    property real uiScale: 1.0   // splash size: 0.8 = Small, 1.0 = Medium, 1.25 = Large
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

    property int stage           // set by ksplash; unused (sequence is self-timed)

    property var lines: [
        { pre: "> ", label: "MU-TH-UR 6000  //  COLD START", d: 0,  t: "" },
        { pre: "  ", label: "REACTOR CORE",       d: 12, t: "OK" },
        { pre: "  ", label: "LIFE SUPPORT",       d: 12, t: "OK" },
        { pre: "  ", label: "ARTIFICIAL GRAVITY", d: 6,  t: "OK" },
        { pre: "  ", label: "NAVIGATION",         d: 14, t: "OK" },
        { pre: "  ", label: "ATMOS PROCESSING",   d: 8,  t: "OK" },
        { pre: "  ", label: "COMMS ARRAY",        d: 13, t: "OK" },
        { pre: "  ", label: "CARGO SEALS",        d: 13, t: "OK" },
        { pre: "  ", label: "CREW: 7  //  CRYO-STASIS", d: 0, t: "" },
        { pre: "> ", label: "ALL SYSTEMS NOMINAL", d: 0, t: "" },
        { pre: "> ", label: "STARTUP COMPLETE",    d: 0, t: "" }
    ]

    property bool started: false
    property int  li: 0
    property int  dotsShown: 0
    property bool okShown: false
    property bool allDone: false

    FontLoader { id: mono; source: "share-tech-mono.woff2" }
    property string monoFamily: mono.status === FontLoader.Ready ? mono.name : "monospace"

    function dotsStr(n) { var s = ""; for (var i = 0; i < n; i++) s += "."; return s; }
    function fullLine(i) {
        var L = lines[i];
        return L.pre + L.label + (L.d > 0 ? " " + dotsStr(L.d) + " " + L.t : "");
    }
    function partialLine(i) {
        var L = lines[i];
        if (L.d === 0) return L.pre + L.label;
        return L.pre + L.label + " " + dotsStr(dotsShown) + (okShown ? " " + L.t : "");
    }

    Timer {
        id: seq
        interval: 28; repeat: true; running: true
        property int wait: 6
        onTriggered: {
            if (wait > 0) { wait--; return; }
            if (!root.started) { root.started = true; wait = 5; return; }
            if (root.li >= root.lines.length) { root.allDone = true; seq.running = false; return; }
            var L = root.lines[root.li];
            if (L.d > 0) {
                if (root.dotsShown < L.d) { root.dotsShown++; return; }
                if (!root.okShown) { root.okShown = true; wait = 5; return; }
            } else {
                wait = 6;
            }
            root.li++; root.dotsShown = 0; root.okShown = false;
            if (root.li < root.lines.length) wait = Math.max(wait, 3);
        }
    }

    Column {
        id: log
        x: Math.round(root.width * 0.16)
        y: Math.round(root.height * 0.24)
        spacing: Math.round(root.height * root.uiScale * 0.013)
        Repeater {
            model: root.lines
            Text {
                visible: root.started && index <= root.li
                text: index < root.li ? root.fullLine(index) : root.partialLine(index)
                // completion lines (ALL SYSTEMS NOMINAL / STARTUP COMPLETE) glow brighter
                color: index >= root.lines.length - 2 ? "#7dff96" : "#3bd16f"
                font.family: root.monoFamily
                font.pixelSize: Math.round(root.height * 0.019 * root.uiScale)   // base size; uiScale = S/M/L
            }
        }
        Rectangle {   // blinking cursor, follows the last revealed line (keeps blinking when done)
            visible: root.started
            width: Math.round(root.height * root.uiScale * 0.015)
            height: Math.round(root.height * root.uiScale * 0.030)
            color: "#7dff96"
            SequentialAnimation on opacity {
                running: true; loops: Animation.Infinite
                NumberAnimation { to: 1; duration: 60 }
                PauseAnimation { duration: 380 }
                NumberAnimation { to: 0; duration: 60 }
                PauseAnimation { duration: 380 }
            }
        }
    }

    // ---- CRT: rolling scanline grille + sweeping phosphor band ----
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
