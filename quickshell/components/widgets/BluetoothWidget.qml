import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import qs.components.shared
import qs.components.theme
import qs.components.system

Item {
    IconButton {
        id: bluetoothButton
        anchors.fill: parent
        icon: "bluetooth"
        enabled: BluetoothConfig.enabled

        onClicked: bluetoothPopup.visible = true
    }

    PopupWindow {
        id: bluetoothPopup
        grabFocus: true
        visible: false

        onVisibleChanged: {
            BluetoothConfig.adapter.discovering = visible;
        }

        implicitWidth: 250
        implicitHeight: column.implicitHeight
        color: "transparent"

        Behavior on implicitHeight {
            NumberAnim {}
        }

        anchor {
            item: bluetoothButton
            rect.y: bluetoothButton.height + 4
        }

        // ----- background ----------------------------------
        Rectangle {
            color: Theme.bgColor
            border {
                color: Theme.borderColor
                width: Theme.borderWidth
            }
            radius: Theme.radius
            anchors.fill: parent
        }

        ColumnLayout {
            id: column
            spacing: 8
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                color: 'transparent'
                implicitHeight: 2
            }

            // ----------------------- Switcher -----------------------
            MenuItemSwitcher {
                label: "Bluetooth"
                on: BluetoothConfig.enabled
                onToggle: BluetoothConfig.toggleEnabled()
            }

            // ------------------- No adapter found -------------------
            Loader {
                Layout.fillWidth: true
                visible: !BluetoothConfig.available
                sourceComponent: Item {
                    height: 36
                    Text {
                        anchors.centerIn: parent
                        text: "No Bluetooth adapter found"
                        color: Theme.colorSec
                        font.pixelSize: 12
                    }
                }
            }

            // -------------------- Paired devices --------------------
            ColumnLayout {
                spacing: 5
                visible: BluetoothConfig.enabled

                MenuLabel {
                    label: "Devices"
                }

                Repeater {
                    model: BluetoothConfig.adapter.devices

                    delegate: MenuItemCheckbox {
                        id: deviceMenu
                        required property var modelData
                        readonly property BluetoothDevice device: modelData

                        icon: (device.icon || 'unknown-device') + '.svg'
                        label: device.name || device.deviceName || device.address
                        checked: device.connected
                        onToggle: {
                            if (!device.paired) {
                                device.pair();
                                device.trusted = true;
                            }

                            if (device.connected) {
                                device.disconnect();
                            } else {
                                device.connect();
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: 'transparent'
                implicitHeight: 2
            }
        }
    }
}
