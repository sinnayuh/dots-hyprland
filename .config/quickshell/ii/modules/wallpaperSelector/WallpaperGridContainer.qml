import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: container

    property var filteredWallpapers: []
    property bool previewMode: false
    property var searchField
    property alias currentIndex: grid.currentIndex
    property alias columns: grid.columns

    signal wallpaperApplied(string path)
    signal previewRequested(string path)
    signal closeRequested

    color: Appearance.colors.colLayer0
    border.width: 1
    border.color: Appearance.colors.colLayer0Border
    radius: Appearance.rounding.screenRounding
    visible: !previewMode

    property int calculatedRows: Math.ceil(grid.count / grid.columns)

    implicitWidth: {
        if (filteredWallpapers.length === 0) {
            return 300;
        } else if (filteredWallpapers.length < grid.columns) {
            return filteredWallpapers.length * grid.cellWidth + 16;
        } else {
            return grid.columns * grid.cellWidth + 16;
        }
    }

    implicitHeight: {
        if (filteredWallpapers.length === 0) {
            return 100;
        } else {
            return Math.min(calculatedRows, 3) * grid.cellHeight + 16;
        }
    }

    Behavior on implicitWidth {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }

    Behavior on implicitHeight {
        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    }

    function moveSelection(delta) {
        grid.moveSelection(delta);
    }

    function activateCurrent() {
        grid.activateCurrent();
    }

    function previewCurrent() {
        grid.previewCurrent();
    }

    Keys.onPressed: event => {
        if (previewMode)
            return;

        if (event.key === Qt.Key_Escape) {
            closeRequested();
            event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
            grid.moveSelection(-1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
            grid.moveSelection(1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Up) {
            if (grid.currentIndex < grid.columns) {
                searchField.forceActiveFocus();
            } else {
                grid.moveSelection(-grid.columns);
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Down) {
            grid.moveSelection(grid.columns);
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            grid.activateCurrent();
            event.accepted = true;
        } else if (event.key === Qt.Key_Space) {
            grid.previewCurrent();
            event.accepted = true;
        } else if (event.key === Qt.Key_Backspace) {
            if (searchField.text.length > 0) {
                searchField.text = searchField.text.substring(0, searchField.text.length - 1);
            }
            searchField.forceActiveFocus();
            event.accepted = true;
        } else {
            searchField.forceActiveFocus();
            if (event.text.length > 0) {
                searchField.text += event.text;
                searchField.cursorPosition = searchField.text.length;
            }
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        WallpaperGrid {
            id: grid
            visible: filteredWallpapers.length > 0
            wallpapers: filteredWallpapers

            Layout.preferredWidth: columns * cellWidth
            Layout.fillHeight: true

            onWallpaperApplied: path => {
                container.wallpaperApplied(path);
            }

            onPreviewRequested: path => {
                container.previewRequested(path);
            }
        }

        WallpaperEmptyState {
            visible: filteredWallpapers.length === 0
            Layout.alignment: Qt.AlignCenter
        }
    }
}
