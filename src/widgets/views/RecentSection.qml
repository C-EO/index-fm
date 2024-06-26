// Copyright 2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2020 Slike Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

import org.maui.index as Index

import "home"

SectionGroup
{
    id: _recentGrid
    readonly property alias list : _recentModelList

    browser.itemSize: 220
    browser.itemHeight: 70
    browser.implicitHeight: 140

    template.template.content:  Button
    {
        icon.name: "list-add"
        text: i18n("More")
        onClicked: openTab(_recentGrid.list.url)
    }

    baseModel.list: Index.RecentFiles
    {
        id: _recentModelList
    }
}


