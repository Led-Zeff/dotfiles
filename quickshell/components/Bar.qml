import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.theme
import qs.components.widgets

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                right: true
                left: true
            }
            color: 'transparent'
            implicitHeight: clock.implicitHeight

            margins {
                top: Spaces.marginTop
                left: Spaces.marginSides
                right: Spaces.marginSides
            }

            ClockWidget {
                id: clock
                anchors.centerIn: parent
            }

            RowLayout {
                anchors.right: parent.right
                implicitHeight: parent.height
                implicitWidth: systemWidgets.implicitWidth
                spacing: 10

                Item {
                    id: systemWidgets
                    implicitHeight: parent.height
                    implicitWidth: widgetsRow.implicitWidth

                    Rectangle {
                        id: background
                        anchors.fill: parent
                        radius: Theme.radius
                        color: Theme.bgColor
                        border {
                            color: Theme.borderColor
                            width: Theme.borderWidth
                        }
                    }

                    RowLayout {
                        id: widgetsRow
                        anchors.fill: parent
                        spacing: 0

                        AudioWidget {
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: parent.height + 4
                            Layout.leftMargin: 4
                        }

                        BluetoothWidget {
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: parent.height
                        }

                        WifiWidget {
                            Layout.preferredHeight: parent.height
                            Layout.preferredWidth: parent.height
                            Layout.rightMargin: 4
                        }
                    }
                }

                Rectangle {
                    implicitWidth: parent.height
                    implicitHeight: parent.height
                    radius: parent.height / 2
                    color: Theme.bgColor
                    border {
                        color: Theme.borderColor
                        width: Theme.borderWidth
                    }

                    PowerOffWidget {
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
