pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.components.shared
import qs.components.theme

Item {
    id: root
    property bool showPopup: false

    IconButton {
        id: powerButton
        anchors.fill: parent
        icon: "power.svg"

        onClicked: root.showPopup = !root.showPopup
    }

    LazyLoader {
        active: root.showPopup

        PanelWindow {
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }
            color: '#4f000000'

            contentItem {
                focus: true
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape)
                        root.showPopup = false;
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.showPopup = false
            }

            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 300
                implicitHeight: 200
                color: Theme.disabledBgColor
                radius: Theme.radius
                border {
                    color: Theme.borderColor
                    width: Theme.borderWidth
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 25
                    anchors.bottomMargin: 25
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 10

                    Rectangle {
                        id: sb
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.bgColor
                        radius: Theme.radius

                        property double pressedWidth: 0

                        readonly property var process: Process {
                            command: ["systemctl", "poweroff"]
                        }

                        Timer {
                            id: sbTimer
                            interval: 5
                            repeat: true
                            onTriggered: {
                                if (sb.pressedWidth >= 1) {
                                    running = false;

                                    sb.process.startDetached();
                                    Qt.quit();

                                    return;
                                }
                                sb.pressedWidth += .01;
                            }
                        }

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10

                            AssetIcon {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.leftMargin: 15
                                icon: "power.svg"
                                color: Theme.color
                                size: 20
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: "<u>S</u>hutdown"
                                color: Theme.color
                                font.pixelSize: 16
                            }
                        }

                        Rectangle {
                            anchors {
                                top: parent.top
                                left: parent.left
                                bottom: parent.bottom
                            }
                            radius: Theme.radius
                            color: Theme.bgColorSec
                            implicitWidth: sb.width * sb.pressedWidth
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                parent.scale = .99;
                                parent.opacity = 0.9;
                            }

                            onExited: {
                                parent.scale = 1;
                                parent.opacity = 1;
                            }

                            onPressed: {
                                sbTimer.restart();
                            }

                            onReleased: {
                                sbTimer.running = false;
                                sb.pressedWidth = 0;
                            }

                            Behavior on scale {
                                NumberAnim {}
                            }
                            Behavior on opacity {
                                NumberAnim {}
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.bgColor
                        radius: Theme.radius

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10

                            AssetIcon {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.leftMargin: 15
                                icon: "restart.svg"
                                color: Theme.color
                                size: 20
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: "<u>R</u>estart"
                                color: Theme.color
                                font.pixelSize: 16
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.bgColor
                        radius: Theme.radius

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 10

                            AssetIcon {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.leftMargin: 15
                                icon: "logout.svg"
                                color: Theme.color
                                size: 20
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: "<u>L</u>ogout"
                                color: Theme.color
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }
        }
    }
}
