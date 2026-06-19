pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.components.shared
import qs.components.theme

RowLayout {
    id: root

    readonly property double volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? true
    readonly property int defaultSinkId: Pipewire.defaultAudioSink?.id ?? -1

    // ----- widget button ---------------------------------
    IconButton {
        id: audioButton
        Layout.fillHeight: true
        Layout.preferredWidth: parent.height
        icon: root.muted ? "volume_off.svg" : "volume_up.svg"
        iconColor: root.muted ? Theme.colorSec : Theme.color

        onClicked: {
            audioPopup.visible = !audioPopup.visible;
        }
    }

    // ----- volume indicator ------------------------------
    Rectangle {
        Layout.topMargin: 6
        Layout.bottomMargin: 6
        Layout.fillHeight: true
        Layout.margins: -7
        implicitWidth: 3
        radius: Theme.radius
        color: Theme.inputColorMuted

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            implicitHeight: (parent.height) * (root.muted ? 0 : root.volume)
            radius: parent.radius
            color: Theme.color

            Behavior on implicitHeight {
                NumberAnim {}
            }
        }
    }

    // ----- Popup window ----------------------------------
    PopupWindow {
        id: audioPopup
        grabFocus: true
        visible: false

        implicitWidth: 300
        implicitHeight: column.height
        color: "transparent"

        Behavior on implicitHeight {
            NumberAnim {}
        }

        anchor {
            item: audioButton
            rect.y: audioButton.height + 4
        }

        // ----- Background ----------------------------------
        Rectangle {
            color: Theme.bgColor
            border {
                color: Theme.borderColor
                width: Theme.borderWidth
            }
            radius: Theme.radius
            anchors.fill: parent
        }

        // ----- Popup content ----------------------------------
        ColumnLayout {
            id: column
            spacing: 8
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Item {
                implicitHeight: 2
            }

            // ----- Munte/unmute ----------------------------------
            MenuItemSwitcher {
                label: "Audio"
                on: !root.muted
                onToggle: {
                    if (Pipewire.defaultAudioSink) {
                        Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                    }
                }
            }

            // ----- Devices ----------------------------------
            ColumnLayout {
                spacing: 5

                MenuLabel {
                    label: "Devices"
                }

                Repeater {
                    model: Pipewire.nodes.values.filter(node => node.isSink)

                    delegate: MenuItemCheckbox {
                        required property var modelData
                        readonly property PwNode node: modelData

                        icon: "audio-card.svg"
                        label: node.description
                        checked: node.id === root.defaultSinkId

                        onToggle: {
                            Pipewire.preferredDefaultAudioSink = node;
                        }
                    }
                }
            }

            Item {
                implicitHeight: 2
            }
        }
    }
}
