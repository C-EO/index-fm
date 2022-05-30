import QtQuick 2.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.2 as Maui

import QtGraphicalEffects 1.0

Maui.ListBrowserDelegate
{
    id: control

//    template.headerSizeHint: iconSizeHint + Maui.Style.space.small

    label1.font.pointSize: Maui.Style.fontSizes.big
    label1.font.weight: Font.Bold
    label1.font.bold: true

    background: Rectangle
    {
        radius: Maui.Style.radiusV
        color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))

        Rectangle
        {
            id: _iconRec
            opacity: 0.3
            anchors.fill: parent
            color: Maui.Theme.backgroundColor
            clip: true

            FastBlur
            {
                id: fastBlur
                height: parent.height * 2
                width: parent.width * 2
                anchors.centerIn: parent
                source: control.template.iconItem
                radius: 64
                transparentBorder: true
                cached: true
            }

            Rectangle
            {
                anchors.fill: parent
                opacity: 0.5
                color: Qt.tint(control.Maui.Theme.textColor, Qt.rgba(control.Maui.Theme.backgroundColor.r, control.Maui.Theme.backgroundColor.g, control.Maui.Theme.backgroundColor.b, 0.9))
            }
        }

        OpacityMask
        {
            source: mask
            maskSource: _iconRec
        }

        LinearGradient
        {
            id: mask
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.2; color: "transparent"}
                GradientStop { position: 0.5; color: control.background.color}
            }

            start: Qt.point(0, 0)
            end: Qt.point(_iconRec.width, _iconRec.height)
        }
    }

    layer.enabled: true
    layer.effect: OpacityMask
    {
        maskSource: Item
        {
            width: control.width
            height: control.height

            Rectangle
            {
                anchors.fill: parent
                radius: Maui.Style.radiusV
            }
        }
    }

}
