import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: debugOverlay

    // Properties exposed from parent
    property bool previewMode: false
    property real implicitWindowWidth: 0
    property real implicitWindowHeight: 0
    property real layoutImplicitWidth: 0
    property real layoutImplicitHeight: 0
    property int filteredWallpapersCount: 0
    property int gridCurrentIndex: 0
    property bool debugVisible: true

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 10
    width: debugColumn.implicitWidth + 20
    height: debugColumn.implicitHeight + 20
    color: Appearance.colors.colLayer0
    border.color: Appearance.colors.colLayer0Border
    border.width: 1
    radius: Appearance.rounding.small
    opacity: 0.9
    visible: debugVisible
    z: 1000

    ColumnLayout {
        id: debugColumn
        anchors.centerIn: parent
        spacing: 4

        Label {
            text: "DEBUG INFO"
            font.family: Appearance.font.family.main
            font.pixelSize: Appearance.font.pixelSize.small
            font.bold: true
            color: Appearance.colors.colSecondary
            Layout.alignment: Qt.AlignHCenter
        }

        DebugInfoRow {
            label: "Preview Mode"
            value: debugOverlay.previewMode
        }

        // DebugInfoRow {
        //     label: "Window Size"
        //     value: `${Math.round(debugOverlay.implicitWindowWidth)}×${Math.round(debugOverlay.implicitWindowHeight)}`
        // }

        DebugInfoRow {
            label: "Layout Size"
            value: `${Math.round(debugOverlay.layoutImplicitWidth)}×${Math.round(debugOverlay.layoutImplicitHeight)}`
        }

        DebugInfoRow {
            label: "Filtered Count"
            value: debugOverlay.filteredWallpapersCount
        }

        DebugInfoRow {
            label: "Grid Index"
            value: debugOverlay.gridCurrentIndex
            visible: !debugOverlay.previewMode
        }
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            debugOverlay.debugVisible = !debugOverlay.debugVisible;
        }
    }

    // Toggle debug visibility with Ctrl+D
    // Why this not working 
    // does i have to move this to panelWindow
    Keys.onPressed: event => {
        if (event.key === Qt.Key_D && (event.modifiers & Qt.ControlModifier)) {
            debugOverlay.debugVisible = !debugOverlay.debugVisible;
            event.accepted = true;
        }
    }
}
