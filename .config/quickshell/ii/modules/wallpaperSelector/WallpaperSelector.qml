import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    // TODO: adding imp var here

    WallpaperSelectorWindow {
        id: wallpaperWindow
        visible: GlobalStates.wallpaperSelectorOpen
    }

    GlobalShortcut {
        name: "wallpaperSelectorToggle"
        description: "Toggle wallpaper overview"
        onPressed: {
            GlobalStates.wallpaperSelectorOpen = !GlobalStates.wallpaperSelectorOpen;
        }
    }
}
