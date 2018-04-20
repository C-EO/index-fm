import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Window 2.0

import "widgets"
import "widgets/views"
import "widgets/sidebar"

import "widgets_templates"

import "Index.js" as INX

Kirigami.ApplicationWindow
{
    id: root
    visible: true
    width: Screen.width * (isMobile ? 1 : 0.4)
    height: Screen.height * (isMobile ? 1 : 0.4)
    title: qsTr("Index")

    property int sidebarWidth: Kirigami.Units.gridUnit * 17

    pageStack.defaultColumnWidth: sidebarWidth
    pageStack.initialPage: [placesSidebar, browser]
    pageStack.interactive: isMobile
    pageStack.separatorVisible: pageStack.wideMode

    readonly property bool isMobile : Kirigami.Settings.isMobile
    readonly property bool isAndroid : inx.isAndroid()

    property string backgroundColor: Kirigami.Theme.backgroundColor
    property string textColor: Kirigami.Theme.textColor
    property string highlightColor: Kirigami.Theme.highlightColor
    property string highlightedTextColor: Kirigami.Theme.highlightedTextColor
    property string buttonBackgroundColor: Kirigami.Theme.buttonBackgroundColor
    property string viewBackgroundColor: Kirigami.Theme.viewBackgroundColor
    property string altColor: Kirigami.Theme.complementaryBackgroundColor




    /***************************************************/
    /******************** UI UNITS ********************/
    /*************************************************/

    property int iconSize : iconSizes.medium

    readonly property int rowHeight: (defaultFontSize*2) + space.big

    readonly property real factor : Kirigami.Units.gridUnit * (isMobile ? 0.2 : 0.2)

    readonly property int contentMargins: space.medium
    readonly property int defaultFontSize: Kirigami.Theme.defaultFont.pointSize
    readonly property var fontSizes: ({
                                          tiny: defaultFontSize * 0.4,

                                          small: (isMobile ? defaultFontSize * 0.4 :
                                                             defaultFontSize * 0.6),

                                          medium: (isMobile ? defaultFontSize * 0.6 :
                                                              defaultFontSize * 0.8),

                                          default: (isMobile ? defaultFontSize * 0.8 :
                                                               defaultFontSize),

                                          big: (isMobile ? defaultFontSize :
                                                           defaultFontSize * 1.2),

                                          large: (isMobile ? defaultFontSize * 1.2 :
                                                             defaultFontSize * 1.4)
                                      })

    readonly property var space : ({
                                       tiny: Kirigami.Units.smallSpacing,
                                       small: Kirigami.Units.smallSpacing*2,
                                       medium: Kirigami.Units.largeSpacing,
                                       big: Kirigami.Units.largeSpacing*2,
                                       large: Kirigami.Units.largeSpacing*3,
                                       huge: Kirigami.Units.largeSpacing*4,
                                       enormus: Kirigami.Units.largeSpacing*5
                                   })

    readonly property var iconSizes : ({
                                           tiny : Kirigami.Units.iconSizes.small*0.5,

                                           small :  (isMobile ? Kirigami.Units.iconSizes.small*0.5:
                                                                Kirigami.Units.iconSizes.small),

                                           medium : (isMobile ? (isAndroid ? 22 : Kirigami.Units.iconSizes.small) :
                                                                Kirigami.Units.iconSizes.smallMedium),

                                           big:  (isMobile ? Kirigami.Units.iconSizes.smallMedium :
                                                             Kirigami.Units.iconSizes.medium),

                                           large: (isMobile ? Kirigami.Units.iconSizes.medium :
                                                              Kirigami.Units.iconSizes.large),

                                           huge: (isMobile ? Kirigami.Units.iconSizes.large :
                                                             Kirigami.Units.iconSizes.huge),

                                           enormous: (isMobile ? Kirigami.Units.iconSizes.huge :
                                                                 Kirigami.Units.iconSizes.enormous)

                                       })

    /***************************************************/
    /**************************************************/
    /*************************************************/

    overlay.modal: Rectangle {
        color: isMobile ? darkColor : "transparent"
        opacity: 0.5
        height: root.height
    }

    overlay.modeless: Rectangle {
        color: "transparent"
    }


    header: IndexToolbar
    {
        id: mainHeader
    }

    PlacesSidebar
    {
        id: placesSidebar
        anchors.fill: parent

        onPlaceClicked: browser.openFolder(path)

    }

    Browser
    {
        id: browser
        anchors.fill: parent

        Component.onCompleted:
        {
            browser.openFolder(inx.homePath())
        }
    }

    ItemMenu
    {
        id: itemMenu

        onBookmarkClicked: INX.bookmarkFolder(path)
        onCopyClicked:
        {
            if(multiple)
            {
                browser.copy(browser.selectedPaths)
                browser.selectionBar.animate("#6fff80")
            }else browser.copy([path])

        }
        onCutClicked:
        {
            if(multiple)
            {
                browser.cut(browser.selectedPaths)
                browser.selectionBar.animate("#fff44f")
            }else browser.cut([path])
        }
    }
}
