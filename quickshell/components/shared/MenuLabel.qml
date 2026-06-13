pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.components.theme

RowLayout {
    id: root
    spacing: 6

    property alias label: label.text
    property alias fontSize: label.font.pixelSize
    property string icon
    property double iconSize: 20

    Layout.leftMargin: Theme.menuHMargins
    Layout.rightMargin: Theme.menuHMargins

    Loader {
        visible: !!root.icon
        sourceComponent: AssetIcon {
            id: icon
            icon: root.icon
            color: Theme.color
            size: root.iconSize
        }
    }

    Text {
        id: label
        text: root.label
        color: Theme.color
        font.pixelSize: 14
        Layout.fillWidth: true
        wrapMode: Text.Wrap
    }
}
