import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: panelWindow
    
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(panelWindow.screen)
    property bool monitorIsFocused: (Hyprland.focusedMonitor?.id == monitor?.id)
    property var filteredWallpapers: Wallpapers.wallpapers
    
    property bool previewMode: false
    property string previewWallpaper: ""
    property var previewMetadata: ({})

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:wallpaper-overview"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    color: "transparent"

    // implicitHeight: panelWindow.previewMode ? 750 : Math.max(layout.implicitHeight, 500)
    // implicitWidth: panelWindow.previewMode ? 1000 : Math.max(layout.implicitWidth, 920)

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    margins {
        top: Appearance.sizes.barHeight + Appearance.sizes.hyprlandGapsOut
    }
    // get wallpaper metadata
    function getWallpaperMetadata(path) {
        let filename = path.split('/').pop();
        let extension = filename.split('.').pop().toUpperCase();

        return {
            filename: filename,
            format: extension
        };
    }

    // HyprlandFocusGrab {
    //     id: grab
    //     windows: [panelWindow]
    //     property bool canBeActive: panelWindow.monitorIsFocused
    //     active: false
    //     onCleared: () => {
    //         if (!active)
    //             GlobalStates.wallpaperSelectorOpen = false;
    //     }
    // }
    //
    // Timer {
    //     id: delayedGrabTimer
    //     interval: Config.options.hacks.arbitraryRaceConditionDelay
    //     repeat: false
    //     onTriggered: {
    //         if (!grab.canBeActive)
    //             return;
    //         grab.active = GlobalStates.wallpaperSelectorOpen;
    //     }
    // }

    WallpaperDebugOverlay {
        id: debugOverlay
        previewMode: panelWindow.previewMode
        implicitWindowWidth: panelWindow.implicitWidth
        implicitWindowHeight: panelWindow.implicitHeight
        layoutImplicitWidth: layout.implicitWidth
        layoutImplicitHeight: layout.implicitHeight
        filteredWallpapersCount: panelWindow.filteredWallpapers.length
        gridCurrentIndex: wallpaperGrid.currentIndex
    }

    ColumnLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        WallpaperSearchField {
            id: searchField
            Layout.preferredWidth: panelWindow.previewMode ? layout.implicitWidth : wallpaperGrid.implicitWidth
            previewMode: panelWindow.previewMode

            onFilterChanged: text => {
                let newModel = [];
                if (text.length > 0) {
                    for (let i = 0; i < Wallpapers.wallpapers.length; ++i) {
                        let wallpaperPath = Wallpapers.wallpapers[i];
                        if (wallpaperPath.toLowerCase().includes(text.toLowerCase())) {
                            newModel.push(wallpaperPath);
                        }
                    }
                    panelWindow.filteredWallpapers = newModel;
                } else {
                    panelWindow.filteredWallpapers = Wallpapers.wallpapers;
                }
            }

            onNavigationRequested: direction => {
                wallpaperGrid.forceActiveFocus();
                if (direction === "down")
                    wallpaperGrid.moveSelection(wallpaperGrid.columns);
                else if (direction === "left")
                    wallpaperGrid.moveSelection(-1);
                else if (direction === "right")
                    wallpaperGrid.moveSelection(1);
            }

            onActivateRequested: {
                wallpaperGrid.activateCurrent();
            }

            onCloseRequested: {
                GlobalStates.wallpaperSelectorOpen = false;
            }
        }

        WallpaperGridContainer {
            id: wallpaperGrid
            filteredWallpapers: panelWindow.filteredWallpapers
            previewMode: panelWindow.previewMode
            searchField: searchField

            onWallpaperApplied: path => {
                GlobalStates.wallpaperSelectorOpen = false;
                searchField.clearFilter();
                Wallpapers.apply(path);
            }

            onPreviewRequested: path => {
                panelWindow.previewWallpaper = path;
                panelWindow.previewMetadata = panelWindow.getWallpaperMetadata(path);
                panelWindow.previewMode = true;
            }

            onCloseRequested: {
                GlobalStates.wallpaperSelectorOpen = false;
            }
        }

        WallpaperPreview {
            id: wallpaperPreview
            visible: panelWindow.previewMode
            wallpaperPath: panelWindow.previewWallpaper
            wallpaperMetadata: panelWindow.previewMetadata
            monitor: panelWindow.monitor

            // I like big preview
            // Layout.fillWidth: true
            Layout.preferredWidth: 1000
            Layout.preferredHeight: 900
            Layout.maximumWidth: panelWindow.monitor ? Math.min(panelWindow.monitor.width * 0.7, 1200) : 800
            Layout.minimumHeight: 600
            Layout.maximumHeight: panelWindow.monitor ? Math.min(panelWindow.monitor.height * 0.9, 1200) : 700

            onClosed: {
                panelWindow.previewMode = false;
                wallpaperGrid.forceActiveFocus();
            }

            onWallpaperApplied: path => {
                GlobalStates.wallpaperSelectorOpen = false;
                searchField.clearFilter();
                Wallpapers.apply(path);
            }
        }
    }

    // Connections {
    //     target: GlobalStates
    //     function onWallpaperOverviewOpenChanged() {
    //         if (GlobalStates.wallpaperSelectorOpen && monitorIsFocused) {
    //             panelWindow.previewMode = false;
    //             delayedGrabTimer.start();
    //         }
    //     }
    // }
}
