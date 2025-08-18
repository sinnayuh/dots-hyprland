import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: previewOverlay

    property string wallpaperPath: ""
    property var wallpaperMetadata: ({})
    property var monitor: null

    signal closed
    signal wallpaperApplied(string path)

    color: Appearance.colors.colLayer0
    border.width: 1
    border.color: Appearance.colors.colLayer0Border
    radius: Appearance.rounding.screenRounding

    opacity: visible ? 1 : 0

    Behavior on implicitWidth {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }

    Behavior on implicitHeight {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                closed();
                event.accepted = true;
            } else if (mouse.button === Qt.LeftButton) {
                wallpaperApplied(wallpaperPath);
                event.accepted = true;
            }
        }
    }
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Space) {
            closed();
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            wallpaperApplied(wallpaperPath);
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.minimumHeight: 40
            Layout.maximumHeight: 60
            spacing: 16

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Label {
                    text: wallpaperMetadata.filename || "Unknown"
                    font.family: Appearance.font.family.main
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.bold: true
                    color: Appearance.colors.colPrimary
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideMiddle
                }
            }

            // Format badge
            // can make look better
            // Rectangle {
            //     Layout.preferredWidth: formatLabel.implicitWidth + 16
            //     Layout.preferredHeight: 32
            //     color: Appearance.colors.colSecondary
            //     radius: 16
            //
            //     Label {
            //         id: formatLabel
            //         anchors.centerIn: parent
            //         text: wallpaperMetadata.format || "?"
            //         font.family: Appearance.font.family.main
            //         font.pixelSize: Appearance.font.pixelSize.normal
            //         color: Appearance.colors.colLayer0
            //         font.bold: true
            //     }
            // }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 300
            Layout.preferredHeight: 800
            color: Appearance.colors.colLayer2
            radius: Appearance.rounding.windowRounding

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                color: "black"
                radius: Appearance.rounding.windowRounding - 2

                Image {
                    id: previewImage
                    anchors.fill: parent
                    source: wallpaperPath ? `file://${wallpaperPath}` : ""
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true

                    // Loading indicator
                    Rectangle {
                        anchors.centerIn: parent
                        width: 64
                        height: 64
                        radius: 32
                        color: Appearance.colors.colLayer3
                        visible: parent.status === Image.Loading

                        opacity: 0.3
                        SequentialAnimation on opacity {
                            running: parent.visible
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 1.0
                                duration: 1000
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                to: 0.3
                                duration: 1000
                                easing.type: Easing.InOutSine
                            }
                        }
                    }

                    // Error state
                    Rectangle {
                        anchors.centerIn: parent
                        width: 200
                        height: 100
                        color: Appearance.colors.colLayer1
                        radius: Appearance.rounding.small
                        visible: parent.status === Image.Error

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8

                            // Adding Icon rather than u8
                            Text {
                                text: "❌"
                                font.pixelSize: 32
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Label {
                                text: "Failed to load image"
                                font.family: Appearance.font.family.main
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colSubtext
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }

                // Image dimensions overlay
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 12
                    width: imageSizeLabel.implicitWidth + 16
                    height: imageSizeLabel.implicitHeight + 8
                    color: Appearance.colors.colLayer0
                    opacity: 0.9
                    radius: 4
                    visible: previewImage.status === Image.Ready

                    Label {
                        id: imageSizeLabel
                        anchors.centerIn: parent
                        text: `${previewImage.sourceSize.width} × ${previewImage.sourceSize.height}`
                        font.family: Appearance.font.family.main
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: Appearance.colors.colPrimary
                    }
                }
            }
        }

        // Bottom info section
        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 50
            Layout.maximumHeight: 100
            color: Appearance.colors.colLayer1
            radius: Appearance.rounding.windowRounding

            RowLayout {
                anchors.fill: parent
                spacing: 5

                // TODO: Adding extra infomations like size, and tags

                // Keyboard hints
                // TODO: make it look good
                Rectangle {
                    Layout.preferredWidth: keyboardHintsRow.implicitWidth + 16
                    Layout.preferredHeight: keyboardHintsRow.implicitHeight + 12
                    color: Appearance.colors.colLayer0
                    radius: Appearance.rounding.small
                    opacity: 0.7

                    RowLayout {
                        id: keyboardHintsRow
                        anchors.centerIn: parent
                        spacing: 12

                        Label {
                            text: "Enter/leftclick: Apply  Esc/Space/rightClick: Back"
                            font.family: Appearance.font.family.main
                            font.pixelSize: Appearance.font.pixelSize.large
                            color: Appearance.colors.colSubtext
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (visible) {
            forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus();
        }
    }
}
