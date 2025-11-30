import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
  id: pluginRoot

  // --- AUTO DETECT PATH ---
  // Ini akan mengambil lokasi file QML ini berada, dan menghapus "file://"
  // Hasilnya: /home/adi/.config/DankMaterialShell/plugins/wf-recorder-menu/
  property string scriptPath: Qt.resolvedUrl(".").toString().replace("file://", "")

  // --- LOGIC STATUS WF-RECORDER ---
  property bool isRecording: false

  Timer {
    id: statusTimer
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      Proc.runCommand("check_wf_recorder", ["/usr/bin/pgrep", "-x", "wf-recorder"], (output, exitCode) => {
        pluginRoot.isRecording = (exitCode === 0);
      });
    }
  }

  // --- DAFTAR COMMAND (Sekarang dinamis mengikuti scriptPath) ---
  property var commands: [
    {
      label: "Selected Area (Slurp)",
      command: pluginRoot.scriptPath + "wf-launcher-exec.sh",
      args: [pluginRoot.scriptPath + "wf-rec-area.sh"]
    },
    {
      label: "Active Window",
      command: pluginRoot.scriptPath + "wf-launcher-exec.sh",
      args: [pluginRoot.scriptPath + "wf-rec-window.sh"]
    },
    {
      label: "Full Screen",
      command: pluginRoot.scriptPath + "wf-launcher-exec.sh",
      args: [pluginRoot.scriptPath + "wf-rec-full.sh"]
    }
  ]

  function executeCommand(command, args) {
    if (ToastService) ToastService.showInfo("Processing...");

    if (command.includes("wf-stop.sh")) {
      const stopCommand = [pluginRoot.scriptPath + "wf-launcher-exec.sh", pluginRoot.scriptPath + "wf-stop.sh"];
      Proc.runCommand("wf_stop_exec", stopCommand, (output, exitCode) => {
        if (exitCode !== 0 && ToastService) ToastService.showError("Stop failed");
      });
        return;
    }

    const fullCommand = [command].concat(args);
    Proc.runCommand("wf_start_exec", fullCommand, (output, exitCode) => {
      if (exitCode !== 0 && ToastService) ToastService.showError("Failed code: " + exitCode);
    });
  }

  // --- TAMPILAN ICONS ---
  horizontalBarPill: Component {
    DankIcon {
      name: pluginRoot.isRecording ? "fiber_manual_record" : "videocam"
      color: pluginRoot.isRecording ? "#FF5252" : Theme.surfaceText
      size: 15
    }
  }

  verticalBarPill: Component {
    DankIcon {
      name: pluginRoot.isRecording ? "fiber_manual_record" : "videocam"
      color: pluginRoot.isRecording ? "#FF5252" : Theme.surfaceText
      size: 15
    }
  }

  popoutWidth: 300
  popoutHeight: pluginRoot.isRecording ? 160 : 280

  popoutContent: Component {
    PopoutComponent {
      id: popoutRoot

      headerText: "Screen Recorder"
      detailsText: "Select action"
      showCloseButton: true

      Column {
        id: mainColumn
        width: parent.width
        spacing: Theme.spacingS

        // --- ITEM STOP ---
        StyledRect {
          width: parent.width
          height: 44
          color: stopMouseArea.containsMouse ? "#FFEBEE" : Theme.surfaceContainerHigh
          radius: Theme.cornerRadius
          border.width: 0
          visible: pluginRoot.isRecording

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacingM
            anchors.rightMargin: Theme.spacingM
            spacing: Theme.spacingS

            StyledText {
              Layout.fillWidth: true
              text: "Stop Recording"
              color: "#FF5252"
              font.pixelSize: Theme.fontSizeMedium
              font.weight: Font.Bold
              elide: Text.ElideRight
            }
            DankIcon {
              name: "stop"
              color: "#FF5252"
              size: 20
            }
          }
          MouseArea {
            id: stopMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              pluginRoot.executeCommand(pluginRoot.scriptPath + "wf-stop.sh", []);
              popoutRoot.closePopout();
            }
          }
        }

        // --- DAFTAR TOMBOL START ---
        Repeater {
          id: commandRepeater
          model: pluginRoot.commands

          Column {
            id: menuItemColumn
            width: parent.width
            spacing: 0
            visible: !pluginRoot.isRecording

            StyledRect {
              width: parent.width
              height: 44
              color: mainItemMouseArea.containsMouse ? Theme.surfaceContainerHighest : Theme.surfaceContainerHigh
              radius: Theme.cornerRadius
              border.width: 0

              RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingM
                anchors.rightMargin: Theme.spacingM
                spacing: Theme.spacingS

                StyledText {
                  Layout.fillWidth: true
                  text: modelData.label
                  color: Theme.surfaceText
                  font.pixelSize: Theme.fontSizeMedium
                  elide: Text.ElideRight
                }

                DankIcon {
                  name: "chevron_right"
                  color: Theme.surfaceVariantText
                  size: 16
                }
              }

              MouseArea {
                id: mainItemMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  pluginRoot.executeCommand(modelData.command, modelData.args);
                  popoutRoot.closePopout();
                }
              }
            }
          }
        }
      }
    }
  }
}
