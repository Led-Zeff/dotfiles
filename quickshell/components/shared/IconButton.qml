import QtQuick
import qs.components.theme

Item {
    id: root

    property double iconSize: 18
    property alias icon: icon.icon
    property string iconColor: Theme.color
    property bool enabled: true
    signal clicked

    layer.enabled: true

    AssetIcon {
        id: icon
        size: root.iconSize
        color: root.enabled ? root.iconColor : Theme.disabled
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked();
        }
    }
}
