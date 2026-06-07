import QtQuick
import QtQuick.Layouts
import qs.components.theme

RowLayout {
    id: root
    property alias label: label.label
    property alias icon: label.icon
    property bool checked
    signal toggle

    Layout.fillWidth: true
    Layout.leftMargin: 0
    Layout.rightMargin: 14

    MenuLabel {
        id: label
        fontSize: 13
        iconSize: 16
        Layout.alignment: Qt.AlignVCenter
    }

    Rectangle {
        implicitWidth: 18
        implicitHeight: implicitWidth
        color: root.checked ? Theme.happyColor : Theme.disabledBgColor
        radius: implicitWidth / 2

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: 4
            implicitWidth: 12
            implicitHeight: implicitWidth
            color: Theme.inputColor
            radius: implicitWidth / 2
        }

        Behavior on color {
            ColorAnim {}
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.CursorShape.PointingHandCursor
            onClicked: root.toggle()
        }
    }
}
