import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
  pluginId: "wf-recorder-menu"

  StyledText {
    width: parent.width
    text: "WF Recorder Settings"
    font.pixelSize: Theme.fontSizeLarge
    font.weight: Font.Bold
    color: Theme.surfaceText
  }

  StyledText {
    width: parent.width
    text: "This plugin launches wf-recorder using external shell scripts."
    font.pixelSize: Theme.fontSizeSmall
    color: Theme.surfaceVariantText
    wrapMode: Text.WordWrap
  }


}
