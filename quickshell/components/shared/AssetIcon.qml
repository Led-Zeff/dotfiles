pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property bool colorize: true
    property color color: "blue"
    property string icon: ""
    property string folder: Qt.resolvedUrl(Quickshell.shellPath("assets"))
    property double size: 20

    width: size
    height: size

    IconImage {
        id: iconImage
        anchors.fill: parent
        source: root.folder + "/" + root.icon
        implicitSize: root.height
    }

    Loader {
        active: root.colorize
        anchors.fill: iconImage
        sourceComponent: ColorOverlay {
            source: iconImage
            color: root.color
        }
    }
}
