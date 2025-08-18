import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls

GridView {
    id: grid

    property var wallpapers: []
    signal wallpaperApplied(string path)
    signal previewRequested(string path)

    readonly property int columns: 4
    property int currentIndex: 0
    readonly property int rows: Math.max(1, Math.ceil(count / columns))
    property int thumbnailWidth: 220
    property int thumbnailHeight: 140

    cellWidth: grid.thumbnailWidth
    cellHeight: grid.thumbnailHeight
    clip: true
    interactive: true
    keyNavigationWraps: true
    boundsBehavior: Flickable.StopAtBounds

    cacheBuffer: cellHeight * 2
    ScrollBar.horizontal: ScrollBar {
        policy: ScrollBar.AsNeeded
        visible: false
    }
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        visible: false
    }

    model: wallpapers
    onModelChanged: currentIndex = 0

    function moveSelection(delta) {
        for (let i = 0; i < count; i++) {
            const item = itemAtIndex(i);
            if (item) {
                item.isHovered = false;
            }
        }
        currentIndex = Math.max(0, Math.min(count - 1, currentIndex + delta));
        positionViewAtIndex(currentIndex, GridView.Contain);
    }

    function activateCurrent() {
        const path = model[currentIndex];
        if (!path)
            return;
        wallpaperApplied(path);
    }

    function previewCurrent() {
        const path = model[currentIndex];
        if (!path)
            return;
        previewRequested(path);
    }

    delegate: WallpaperGridItem {
        width: grid.cellWidth
        height: grid.cellHeight
        wallpaperPath: modelData
        isSelected: index === grid.currentIndex

        onClicked: isRightClick => {
            if (isRightClick) {
                grid.previewRequested(modelData);
            } else {
                grid.wallpaperApplied(modelData);
            }
        }

        onHoverChanged: hovered => {
            if (hovered) {
                for (let i = 0; i < grid.count; i++) {
                    const item = grid.itemAtIndex(i);
                    if (item && item !== this) {
                        item.isHovered = false;
                    }
                }
                grid.currentIndex = index;
            }
        }
    }
}
