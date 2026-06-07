import QtQuick
import QtQuick.Layouts
import qs.components.theme

RowLayout {
    id: root
    property string label
    property bool on
    signal toggle

    Layout.fillWidth: true
    Layout.rightMargin: Theme.menuHMargins

    MenuLabel {
        label: root.label
    }

    Rectangle {
        implicitWidth: 42
        implicitHeight: 24
        color: root.on ? Theme.happyColor : Theme.disabledBgColor
        radius: 12

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: root.on ? 15 : 2
            color: Theme.inputColor
            width: 26
            height: 20
            radius: 11

            Behavior on x {
                NumberAnim {}
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.toggle()
            cursorShape: Qt.CursorShape.PointingHandCursor
        }

        Behavior on color {
            ColorAnim {}
        }
    }
}
