pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.components.theme
import qs.components.shared

Scope {
    id: root
    property bool showOverlay: false
    readonly property double volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? true

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

            implicitWidth: 35
            implicitHeight: 400
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                anchors.rightMargin: 5
                color: Theme.bgColor
                radius: Theme.radius

                ColumnLayout {
                    spacing: 5
                    anchors {
                        fill: parent
                        topMargin: 12
                        bottomMargin: 12
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

                            implicitHeight: (parent.height - 15) * (root.muted ? 0 : root.volume) + 15
                            radius: parent.radius
                            color: Theme.inputColor

                            Behavior on implicitHeight {
                                NumberAnim {}
                            }

                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                implicitWidth: 24
                                implicitHeight: volumeValue.implicitHeight
                                radius: Theme.radius
                                color: Theme.inputColorAccent

                                Text {
                                    id: volumeValue
                                    anchors.centerIn: parent
                                    color: Theme.color
                                    text: root.muted ? 0 : Math.ceil(root.volume * 100)
                                    font.pixelSize: 13
                                }
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
