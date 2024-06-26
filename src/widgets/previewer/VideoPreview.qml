import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtMultimedia

import org.mauikit.controls as Maui

Maui.Page
{
    id: control
    property alias player : player
    headBar.visible: false

    Video
    {
        id: player
        anchors.fill: parent
        source: currentUrl
        autoPlay: appSettings.autoPlayPreviews
        loops: 3
        property string codec : player.metaData.videoCodec

        onCodecChanged:
        {
            infoModel.append({key:"Title", value: player.metaData.title})
            infoModel.append({key:"Camera", value: player.metaData.cameraModel})
            infoModel.append({key:"Zoom Ratio", value: player.metaData.digitalZoomRatio})
            infoModel.append({key:"Author", value: player.metaData.author})
            infoModel.append({key:"Audio Codec", value: player.metaData.audioCodec})
            infoModel.append({key:"Video Codec", value: player.metaData.videoCodec})
            infoModel.append({key:"Copyright", value: player.metaData.copyright})
            infoModel.append({key:"Duration", value: player.metaData.duration})
            infoModel.append({key:"Framerate", value: player.metaData.videoFrameRate})
            infoModel.append({key:"Year", value: player.metaData.year})
            infoModel.append({key:"Aspect Ratio", value: player.metaData.pixelAspectRatio})
            infoModel.append({key:"Resolution", value: player.metaData.resolution})
        }

        ToolButton
        {
            visible: player.playbackState == MediaPlayer.StoppedState
            anchors.centerIn: parent
            icon.color: "transparent"
            flat: true
            icon.width: Maui.Style.iconSizes.huge
            icon.name: iteminfo.icon
        }

        focus: true
        Keys.onSpacePressed: player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play()
        Keys.onLeftPressed: player.seek(player.position - 5000)
        Keys.onRightPressed: player.seek(player.position + 5000)

        RowLayout
        {
            anchors.fill: parent

            MouseArea
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onDoubleClicked: player.seek(player.position - 5000)
            }

            MouseArea
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
            }

            MouseArea
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onDoubleClicked: player.seek(player.position + 5000)
            }
        }
    }

    footBar.visible: true
    footBar.background: null

    footBar.leftContent: ToolButton
    {
        icon.name: player.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
        onClicked:
        {
            if(player.playbackState === MediaPlayer.PlayingState)
                player.pause()
            else
                player.play()
        }
    }
    footBar.middleContent : Slider
    {
        id: _slider
        Layout.fillWidth: true
        orientation: Qt.Horizontal
        from: 0
        to: 1000
        value: (1000 * player.position) / player.duration

        onMoved: player.seek((_slider.value / 1000) * player.duration)
    }
}
