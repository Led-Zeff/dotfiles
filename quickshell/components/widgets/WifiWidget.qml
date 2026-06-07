pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import qs.components.shared
import qs.components.theme

Item {
    id: root
    implicitWidth: wifiButton.width
    implicitHeight: wifiButton.height

    readonly property WifiDevice wifiDevice: {
        for (const device of Networking.devices.values) {
            if (device.type === DeviceType.Wifi) {
                return device;
            }
        }
        return null;
    }

    readonly property WifiNetwork currentNetwork: {
        for (const network of wifiDevice?.networks.values) {
            if (network.connected) {
                return network;
            }
        }
        return null;
    }

    function iconForNetwork(network: WifiNetwork): string {
        if (!network) {
            return "wifi.sgv";
        }

        return "wifi_" + (Math.ceil(root.currentNetwork.signalStrength * 5)) + ".svg";
    }

    IconButton {
        id: wifiButton
        icon: root.iconForNetwork(root.currentNetwork)
        enabled: Networking.wifiEnabled

        onClicked: wifiPopup.visible = true
    }

    PopupWindow {
        id: wifiPopup
        grabFocus: true
        visible: false

        implicitWidth: 250
        implicitHeight: column.implicitHeight
        color: "transparent"

        Behavior on implicitHeight {
            NumberAnim {}
        }

        anchor {
            item: wifiButton
            rect.y: wifiButton.height + 4
        }

        onVisibleChanged: {
            if (root.wifiDevice) {
                root.wifiDevice.scannerEnabled = visible;
            }
        }

        // ----- background -----------------------------------------
        Rectangle {
            color: Theme.bgColor
            border {
                color: Theme.borderColor
                width: Theme.borderWidth
            }
            radius: Theme.radius
            anchors.fill: parent
        }

        // ----- Main popup  ----------------------------------------
        ColumnLayout {
            id: column
            spacing: 8
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                color: "transparent"
                implicitHeight: 2
            }

            // ----- Main popup  ------------------------------------
            MenuItemSwitcher {
                label: "Wifi"
                on: Networking.wifiEnabled
                onToggle: Networking.wifiEnabled = !Networking.wifiEnabled
            }

            // ----- Networks ----------------------------------------
            ColumnLayout {
                spacing: 2
                visible: Networking.wifiEnabled

                MenuLabel {
                    label: "Devices"
                }

                Repeater {
                    model: root.wifiDevice.networks

                    delegate: MenuItemCheckbox {
                        id: wifiDeviceItem

                        required property var modelData
                        readonly property WifiNetwork network: modelData

                        icon: root.iconForNetwork(network)
                        label: network.name
                        checked: network.connected
                    }
                }
            }

            Rectangle {
                color: "transparent"
                implicitHeight: 2
            }
        }
    }
}
