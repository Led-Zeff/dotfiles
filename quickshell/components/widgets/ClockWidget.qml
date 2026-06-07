import QtQuick
import qs.components.theme
import qs.components.system

Rectangle {
    implicitHeight: clockText.implicitHeight + Spaces.marginV * 2
    implicitWidth: clockText.implicitWidth + Spaces.marginH * 2
    color: Theme.bgColor
    border {
        color: Theme.borderColor
        width: Theme.borderWidth
    }
    radius: Theme.radius

    Text {
        id: clockText
        text: Time.time
        color: Theme.color
        anchors.centerIn: parent
    }
}
