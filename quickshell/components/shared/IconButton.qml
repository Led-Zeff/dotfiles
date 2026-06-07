import QtQuick
import qs.components.theme

Rectangle {
    id: root

    property int iconSize: 15
    property string icon
    property string iconColor: Theme.color
    property bool enabled: true
    signal clicked()

    width: iconSize + 14
    height: iconSize + 12
    radius: Theme.radius
    color: enabled
            ? (mouseArea.containsMouse ? Theme.activeBgColor : Theme.bgColor)
            : Theme.disabledBgColor
    border {
        color: root.enabled ? Theme.borderColor : Theme.disabledBorderColor
        width: Theme.borderWidth
    }

    AssetIcon {
        icon: root.icon
        color: root.enabled ? root.iconColor : Theme.disabled
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
        }
    }

    Behavior on color {
        ColorAnim {}
    }

}
