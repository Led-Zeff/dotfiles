import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.components.theme
import qs.components.shared

Scope {
    id: root
    property bool showOverlay: false
    property double volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? true

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.showOverlay = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.showOverlay = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.showOverlay = false
    }

    LazyLoader {
        active: root.showOverlay

        PanelWindow {
            anchors.right: true
            exclusiveZone: 0

            implicitWidth: 30
            implicitHeight: 400
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                color: Theme.bgColor
                topLeftRadius: Theme.radius
                bottomLeftRadius: Theme.radius

                ColumnLayout {
                    spacing: 5
                    anchors {
                        fill: parent
                        topMargin: 10
                        bottomMargin: 15
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: parent.width
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            color: Theme.color
                            text: root.muted ? 0 : Math.ceil(root.volume * 100)
                            font.pixelSize: 13
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 7
                        radius: 3.5
                        color: Theme.disabledBgColor

                        Rectangle {
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                            }

                            implicitHeight: parent.height * (root.muted ? 0 : root.volume)
                            radius: parent.radius
                            color: Theme.inputColor

                            Behavior on implicitHeight {
                                NumberAnim {}
                            }
                        }
                    }

                    Rectangle {}

                    AssetIcon {
                        Layout.alignment: Qt.AlignCenter

                        icon: root.muted || root.volume === 0 ? "volume_off.svg" : "volume_up.svg"
                        color: root.muted || root.volume === 0 ? Theme.inputColorMuted : Theme.inputColor
                        size: 18
                    }
                }
            }
        }
    }
}
