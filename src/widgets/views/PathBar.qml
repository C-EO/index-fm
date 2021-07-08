/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.maui.index 1.0 as Index

Rectangle
{
    id: control

    property int preferredWidth: visible ? (item ?  pathEntry ? Math.max(500, item.implicitWidth) : item.implicitWidth : 500) : 0

    Behavior on preferredWidth
    {
        NumberAnimation
        {
            duration: 100
        }
    }

    color:  item ? "transparent" : Qt.lighter(Kirigami.Theme.backgroundColor)
    radius: Maui.Style.radiusV

    implicitHeight: Maui.Style.rowHeight
    implicitWidth: preferredWidth
    /**
      * url : string
      */
    property url url

    /**
      * pathEntry : bool
      */
    property bool pathEntry: false

    /**
      * item : Item
      */
    readonly property alias item : _loader.item

    /**
      * pathChanged :
      */
    signal pathChanged(string path)

    /**
      * homeClicked :
      */
    signal homeClicked()

    /**
      * placeClicked :
      */
    signal placeClicked(string path)

    signal menuClicked()

    /**
      * placeRightClicked :
      */
    signal placeRightClicked(string path)

    Maui.ProgressIndicator
    {
        id: _progress
        width: parent.width
        anchors.centerIn: parent
        visible: _loader.status == Loader.Loading
    }

    Loader
    {
        id: _loader
        anchors.fill: parent
        asynchronous: true
        sourceComponent: Item
        {
            implicitWidth: _rowLayout.implicitWidth

            Maui.TextField
            {
                id: entry
                anchors.fill: parent
                visible: pathEntry
                enabled: visible
                text: control.url
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase
                implicitWidth: 500
                horizontalAlignment: Qt.AlignLeft
                onAccepted:
                {
                    pathChanged(text)
                }

                onActiveFocusChanged:
                {
                    if(!activeFocus)
                    {
                        control.pathEntry = false
                    }
                }

                background: Rectangle
                {
                    color: Qt.lighter(Kirigami.Theme.backgroundColor)
                    radius: Maui.Style.radiusV
                    border.color:  control.Kirigami.Theme.highlightColor
                }

                actions: Action
                {
                    icon.name: "go-next"
                    icon.color: control.Kirigami.Theme.textColor
                    onTriggered:
                    {
                        entry.accepted()
                    }
                }

                onVisibleChanged:
                {
                    if(visible)
                    {
                        entry.forceActiveFocus()
                        entry.selectAll()
                    }
                }

                Keys.enabled: true
                Keys.onEscapePressed: control.pathEntry = false
            }

            RowLayout
            {
                id: _rowLayout
                spacing: 2
                visible: !pathEntry
                anchors.fill: parent

                //                MouseArea
                //                {
                //                    Layout.fillHeight: true
                //                    Layout.preferredWidth: height * 1.5
                //                    onClicked: control.homeClicked()
                //                    hoverEnabled: Kirigami.Settings.isMobile

                //                    Kirigami.ShadowedRectangle
                //                    {
                //                        anchors.fill: parent
                //                        color: Qt.lighter(Kirigami.Theme.backgroundColor)
                //                        corners
                //                        {
                //                            topLeftRadius: Maui.Style.radiusV
                //                            topRightRadius: 0
                //                            bottomLeftRadius: Maui.Style.radiusV
                //                            bottomRightRadius: 0
                //                        }

                //                        Kirigami.Icon
                //                        {
                //                            anchors.centerIn: parent
                //                            source: Qt.platform.os == "android" ?  "user-home-sidebar" : "user-home"
                //                            color: parent.hovered ? control.Kirigami.Theme.highlightColor : control.Kirigami.Theme.textColor
                //                            width: Maui.Style.iconSizes.small
                //                            height: width
                //                        }
                //                    }
                //                }

                ScrollView
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    implicitWidth: contentWidth

                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                    contentHeight: availableHeight

                    background: null

                    ListView
                    {
                        id: _listView

                        Kirigami.Theme.colorSet: control.Kirigami.Theme.colorSet
                        Kirigami.Theme.inherit: false

                        orientation: ListView.Horizontal
                        clip: true
                        spacing: 2
                        currentIndex: _pathList.count - 1
                        focus: true
                        interactive: Maui.Handy.isTouch
                        highlightFollowsCurrentItem: true

                        boundsBehavior: Flickable.StopAtBounds
                        boundsMovement :Flickable.StopAtBounds

                        onContentWidthChanged: _listView.positionViewAtEnd()

                        model: Maui.BaseModel
                        {
                            id: _pathModel
                            list: Index.PathList
                            {
                                id: _pathList
                                path: control.url
                            }
                        }

                        delegate: PathBarDelegate
                        {
                            id: delegate

                            height: ListView.view.height
                            width: Math.max(Maui.Style.iconSizes.medium * 2, delegate.implicitWidth)

                            color: checked || hovered ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.15) : Qt.lighter(Kirigami.Theme.backgroundColor)

                            onClicked:
                            {
                                control.placeClicked(model.path)
                            }

                            onRightClicked:
                            {
                                control.placeRightClicked(model.path)
                            }

                            onPressAndHold:
                            {
                                control.placeRightClicked(model.path)
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: showEntryBar()
                            z: -1
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask
                        {
                            maskSource: Item
                            {
                                width: _listView.width
                                height: _listView.height

                                Kirigami.ShadowedRectangle
                                {
                                    anchors.fill: parent
                                    corners
                                    {
                                        topLeftRadius: Maui.Style.radiusV
                                        topRightRadius: 0
                                        bottomLeftRadius: Maui.Style.radiusV
                                        bottomRightRadius: 0
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea
                {
                    Layout.fillHeight: true
                    Layout.preferredWidth: control.height
                    onClicked: control.menuClicked()
                    hoverEnabled: Kirigami.Settings.isMobile

                    Kirigami.ShadowedRectangle
                    {
                        anchors.fill: parent
                       color: browserMenu.visible ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.15) : Qt.lighter(Kirigami.Theme.backgroundColor)

                        corners
                        {
                            topLeftRadius: 0
                            topRightRadius: Maui.Style.radiusV
                            bottomLeftRadius: 0
                            bottomRightRadius: Maui.Style.radiusV
                        }

                        Kirigami.Icon
                        {
                            anchors.centerIn: parent
                            source: "go-down"
                            color: browserMenu.visible ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                            width: Maui.Style.iconSizes.small
                            height: width
                        }
                    }

                }
            }
        }
    }


    /**
      *
      */
    function showEntryBar()
    {
        control.pathEntry = !control.pathEntry

    }
}
