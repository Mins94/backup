/****************************************************************************
 *
 * Customized widget.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl.MultiVehicleManager   1.0
import MAVLink                              1.0

import "qrc:/toolbar/"
import "qrc:/qml/"

Item {

    id: _root
    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl

    readonly property string noGPS:         qsTr("NO GPS")
    readonly property real   indicatorValueWidth:   ScreenTools.defaultFontPixelWidth * 7

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property string _altitude:              _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _distanceStr:           isNaN(_distance) ? "0" : _distance.toFixed(0) + ' ' + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property real   _distance:              _activeVehicle ? _activeVehicle.distanceToHome.rawValue : 0
    property string _messageTitle:          ""
    property string _messageText:           ""
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75

    property real   _heading:               _activeVehicle   ? _activeVehicle.heading.rawValue : 0
    property string _headingStr:            _activeVehicle ? (isNaN(_activeVehicle.heading.value) ? "0.0" : _activeVehicle.heading.value.toFixed(1)) + ' ' + _activeVehicle.heading.units : "0.0"
    property real   _gpsnumber:               _activeVehicle   ? _activeVehicle.gps.count : 0
    property string _gpsnumberStr:            _activeVehicle ? (isNaN(_activeVehicle.gps.count) ? "0" : _activeVehicle.gps.count) : "0"



    //Vehicle.cc 참고
    property real _vehicleAltitude_rel:     _activeVehicle ? _activeVehicle.altitudeRelative.rawValue : 0
    property real _vehicleAltitude_AMSL:    _activeVehicle ? _activeVehicle.altitudeAMSL.rawValue : 0
    property string _altitude_relStr:       _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _altitude_AMSLStr:      _activeVehicle ? (isNaN(_activeVehicle.altitudeAMSL.value) ? "0.0" : _activeVehicle.altitudeAMSL.value.toFixed(1)) + ' ' + _activeVehicle.altitudeAMSL.units : "0.0"

    property real _airspeed:                _activeVehicle ? _activeVehicle.airSpeed.rawValue : 0
    property real _flightTime:              _activeVehicle ? _activeVehicle.flightTimeFact.rawValue : 0
    property real _groundSpeed:             _activeVehicle ? _activeVehicle.groundSpeed.rawValue : 0
    property string _groundSpeedStr:        _activeVehicle ? (isNaN(_activeVehicle.groundSpeed.value) ? "0.0" : _activeVehicle.groundSpeed.value.toFixed(1)) + ' ' + _activeVehicle.groundSpeed.units : "0.0"
    property real _flightdistance:          _activeVehicle ? _activeVehicle.flightDistance.rawValue : 0
    property real _climbrate:               _activeVehicle ? _activeVehicle.climbRate.rawValue : 0

    property string _airspeedStr:             _activeVehicle ? (isNaN(_activeVehicle.airSpeed.value) ? "0.0" : _activeVehicle.airSpeed.value.toFixed(1)) + ' ' + _activeVehicle.airSpeed.units : "0.0"
    property string _flightTimeStr:           _activeVehicle ? (isNaN(_activeVehicle.flightTimeFact.value) ? "0.0" : _activeVehicle.flightTimeFact.value.toFixed(1)) + ' ' + _activeVehicle.flightTimeFact.units : "0.0"
    property string _flightdistanceStr:       _activeVehicle ? (isNaN(_activeVehicle.flightDistance.value) ? "0.0" : _activeVehicle.flightDistance.value.toFixed(1)) + ' ' + _activeVehicle.flightDistance.units : "0.0"
    property string _climbrateStr:            _activeVehicle ? (isNaN(_activeVehicle.climbRate.value) ? "0.0" : _activeVehicle.climbRate.value.toFixed(1)) + ' ' + _activeVehicle.climbRate.units : "0.0"

//    property real _groundSpeed:         vehicle ? vehicle.groundSpeed.rawValue : 0
    property real _rollAngle:   _activeVehicle ? vehicle.roll.rawValue  : 0
    property real _pitchAngle:  _activeVehicle ? vehicle.pitch.rawValue : 0

//    property real batteryPercentage: _activeVehicle ? _activeVehicle.batteryPercentage.rawValue : 0
//    property string _batteryPercentage:        _activeVehicle ? (isNaN(_activeVehicle.groundSpeed.value) ? "0.0" : _activeVehicle.groundSpeed.value.toFixed(1)) + ' ' + _activeVehicle.groundSpeed.units : "0.0"

//    property var battery: _activeVehicle ? _activeVehicle.batteries :0
//    property var battery: Object

//    property real batteryPercentage: _activeVehicle ? _activeVehicle.batteryPercentage.rawValue : 0
    property var batteryPercentage: _activeVehicle ? _activeVehicle.batteries[0].percentRemaining.value : 0
    property string _batteryPercentage: _activeVehicle ? (_activeVehicle.batteryPercentage.rawValue.toFixed(1)) + '%' : "0%"
    property var _batteryPercentageTest : _activeVehicle ? _activeVehicle.batteries.percentRemaining.Value :0
    property string _batteryPercentageTestStr : _activeVehicle ? (isNaN(_activeVehicle.batteries.percentRemaining.Value) ? "0.0" : _activeVehicle.batteries.percentRemaining.Value.toFixed(1)) + ' ' + '%' : "0.0"

/*
    function getBatteryPercentageText() {
        if (!isNaN(battery.percentRemaining.rawValue)) {
            if (battery.percentRemaining.rawValue > 98.9) {
                return qsTr("100%")
            } else {
                return battery.percentRemaining.valueString + battery.percentRemaining.units
            }
        } else if (!isNaN(battery.voltage.rawValue)) {
            return battery.voltage.valueString + battery.voltage.units
        } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
            return battery.chargeState.enumStringValue
        }
        return ""
    }
*/

    function getBatteryPercentageText() {
        if (_activeVehicle && _activeVehicle.batteries.length > 0) {
            var battery = _activeVehicle.batteries[0];
            if (!isNaN(battery.percentRemaining.rawValue)) {
                if (battery.percentRemaining.rawValue > 98.9) {
                    return qsTr("100%");
                } else {
                    return battery.percentRemaining.valueString + battery.percentRemaining.units;
                }
            } else if (!isNaN(battery.voltage.rawValue)) {
                return battery.voltage.valueString + battery.voltage.units;
            } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                return battery.chargeState.enumStringValue;
            }
        }
        return "";
    }

    Rectangle {
        id:                     flightDataGrid
//        anchors.bottomMargin:   _toolsMargin
        anchors.rightMargin:    _toolsMargin
//        anchors.bottom:        parent.bottom
        anchors.left:          parent.left
        anchors.fill:   gridforinformation

//        width: 335
//        height: 480
        // 5등분
//        width : globals.mainwindowwidth/5 + 5
        //6등분
        width : globals.mainwindowwidth/6
//        height : 485
//        height : width*12/5 + gridforinformation.spacing
        height : width*6/5 + gridforinformation.spacing*4 + _toolsMargin
        color: "#104754"
        opacity: 0.85
//        border.color: "#70FFE7"
//        border.width: 10

        Grid{
        id:gridforinformation
//        anchors.centerIn: parent
        anchors.top: parent
        anchors.horizontalCenter: parent.horizontalCenter

        columns: 2
        rows: 5
        spacing: 5

        property real gridinfowidth: flightDataGrid.width/2 - spacing/2 - _toolsMargin
        property int titlefontsize: 9
//        property int infofontsize: 18
        //폰트사이즈 2만큼 감소
        property int infofontsize: 16
        // if flightDataGrid.height is 480 and 4 rows
//        property int boxheight: 115
        // if flightDataGrid.height is 480 and 5 rows
//        property int boxheight: 92
        // if flightDataGrid.height is width*2/3 and 5 rows
//        property int boxheight: flightDataGrid.height/5
//        property int boxheight: flightDataGrid.height/10
        property int boxheight: (flightDataGrid.width*12/5)/10
        property string boxcolor: "#072532"
        property string inboxtextcolor : "#FFFFFF"

    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "AMSL Altitude: " + "[m]"
            text: "해발고도: " + "[m]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor


        }
        Text {
            text:   _altitude_AMSLStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }}

    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "Relative Altitude: " + "[m]"
            text: "상대고도: " + "[m]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
            text:   _altitude_relStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }

    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "Ground Speed: " + "[m/s]"
            text: "지상속도: " + "[m/s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
            text:   _groundSpeedStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }

    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "Air Speed: " + "[m/s]"
            text: "대기속도: " + "[m/s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
            text:   _airspeedStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }

    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "Distance to Home:" + "[m]"
            text: "출발지 거리: " + "[m]"

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
            text:   _distanceStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }
    /*
    Rectangle{
        width:180
        height:180
        color: "grey"
        Text {
//            text: "Flight Time"  + "[s]"
            text: "Heading: " + "[s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 16 // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
        }
        Text {
            text:   _HeadingStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 30 // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
        }
    }*/

/*
    Rectangle{
        width:180
        height:180
        color: "grey"
        Text {
//            text: "Flight Time"  + "[s]"
            text: "비행시간: " + "[s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 16 // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
        }
        Text {
            text:   _flightTimeStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 30 // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
        }
    }*/
    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
            text: "배터리량1: " + "[%]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
/*
        BatteryIndicator {
            id: batteryIndicator
            anchors.centerIn: parent
            width: 160
            height: 80
            //            property var batteryPercentage: QGroundControl.multiVehicleManager.activeVehicle.batteryPercentage
            property real batteryPercentage: getBatteryPercentageText()
            property string _batteryPercentageStr: _activeVehicle ? (isNaN(batteryPercentage) ? "0.0" : batteryPercentage)  + ' '+ '%' : "0.0%"

            visible: false
        }

        Text {
//            text:   batteryIndicator.batteryPercentage
            text:    batteryIndicator._batteryPercentageStr
            color: "black"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 30 // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
        }*/

        CustomBatteryIndicator {
            id: batteryIndicator1
            anchors.centerIn: parent
            width: 160
            height: 80
            batteryfontsize : gridforinformation.infofontsize
//            property real batteryPercentage: _activeVehicle ? _activeVehicle.batteries.percentRemaining.value : 0
//            property val batteryPercentage: batteryIndicator1._activeVehicle.batteries. getBatteryPercentageText() : 0
//            visible: false
        }

/*
        Text {
//            text: batteryIndicator.batteryPercentage.toFixed(1) + ' %'
//            property var activebattery: _activeVehicle.batteries
//            text: batteryIndicator1.getBatteryPercentageText(activebattery)
            text: _batteryPercentageTestStr
            color: "black"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 30 // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
        }
*/
    }



    Rectangle{
        width:gridforinformation.gridinfowidth
        height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
            text: "비행거리: " + "[m]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
            text:   _flightdistanceStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }
        Rectangle{
            width:gridforinformation.gridinfowidth
            height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
/*
            //            text: "Flight Time" // + "[s]"
            text: "상승률: " + "[m/s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor
*/
            text: "배터리량2: " + "[%]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor
        }

/*        Component {
            id: batteryValuesAvailableComponent

            QtObject {
                property bool functionAvailable:        battery.function.rawValue !== MAVLink.MAV_BATTERY_FUNCTION_UNKNOWN
                property bool temperatureAvailable:     !isNaN(battery.temperature.rawValue)
                property bool currentAvailable:         !isNaN(battery.current.rawValue)
                property bool mahConsumedAvailable:     !isNaN(battery.mahConsumed.rawValue)
                property bool timeRemainingAvailable:   !isNaN(battery.timeRemaining.rawValue)
                property bool chargeStateAvailable:     battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED
            }
        }

        property var bat_model1: _activeVehicle ? _activeVehicle.batteries.get(1) : 0

        Text {
            text:   bat_model1.percentRemaining.valueString
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
*/

    //        CustomBatteryIndicator_second_bat {
            CustomBatteryIndicator {
                id: batteryIndicator2
                anchors.centerIn: parent
                width: 160
                height: 80
                batteryfontsize : gridforinformation.infofontsize
            }


    }
        Rectangle{
            width:gridforinformation.gridinfowidth
            height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
/*//            text: "Flight Time" // + "[s]"
            text: "Heading: " + "[deg]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor
*/
            text: "상승률: " + "[m/s]"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor


        }
        Text {
            /*
//            text:   _climbrateStr
            text:   _headingStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor
*/
            text:   _climbrateStr
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }
        Rectangle{
            width:gridforinformation.gridinfowidth
            height:gridforinformation.boxheight
        color: gridforinformation.boxcolor
        Text {
//            text: "Flight Time" // + "[s]"
            text: "GPS 개수"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.titlefontsize // Adjust the font size here
            font.bold: true // Set the text to bold
//            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.topMargin: _toolsMargin
            color: gridforinformation.inboxtextcolor

        }
        Text {
//            text:   _climbrateStr
//            text:   _gpsnumberStr
            text:   _activeVehicle.gps.count.valueString
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: gridforinformation.infofontsize // Adjust the font size here
            font.bold: true // Set the text to bold
            font.italic: true // Set the text to italic
            font.family: "Arial" // Set the font family
            anchors.centerIn: parent
            color: gridforinformation.inboxtextcolor

        }
    }
       }
    }


}
