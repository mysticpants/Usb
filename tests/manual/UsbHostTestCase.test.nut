// MIT License
// 
// Copyright 2017 Electric Imp
// 
// SPDX-License-Identifier: MIT
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// NOTE: These tests require manual actions as connection and disconnection
// is tested. Instructions will be displayed as the tests run.
// ---------------------------------------------------------------------

// Setup
// ---------------------------------------------------------------------

// Test Hardware
//  - Imp005 Breakout Board
//  either
//  - FT232RL FTDI USB to TTL Serial Adapter Module
//      - USB wired to USB
//      - TX & RX wired to UART1
//  or
//  - Brother QL-720NW label printer


// Tests
// ---------------------------------------------------------------------

class UsbHostTestCase extends ImpTestCase {
    // UART on imp005
    dataString = "";
    usbHost = null;
    loadPin = null;

    function setUp() {

        usbHost = USB.Host(hardware.usb);
        usbHost.registerDriver(FT232RLFtdiUsbDriver, FT232RLFtdiUsbDriver.getIdentifiers());
        usbHost.registerDriver(QL720NWUartUsbDriver, QL720NWUartUsbDriver.getIdentifiers());

        return "Hi from #{__FILE__}!";
    }

    // Test that a registered driver is returned when corresponding device is
    // connected
    function test1_UsbConnection() {
        this.info("Connect any registered usb device to imp");
        return Promise(function(resolve, reject) {

            // Listen for connection event
            usbHost.on("connected", function(device) {

                // A registered driver was found
                if (device != null) {
                    resolve("Device Connected");
                } else {
                    reject("No drivers found");
                }
            }.bindenv(this));
        }.bindenv(this))
    }

    // Test that a registered driver is returned when corresponding device is
    // connected
    function test2_GetDriver() {
        return Promise(function(resolve, reject) {
            local driver = usbHost.getDriver();
            assertTrue(driver != null);
            resolve("Correct driver was received");
        }.bindenv(this))
    }

    // Tests whether a disconnection event is correctly emitted
    function test3_UsbDisconnection() {
        this.info("Disconnect the usb device from imp");
        return Promise(function(resolve, reject) {
            // Listen for disconnection event
            usbHost.on("disconnected", function(device) {
                // An recognized device was disconnected
                if (device != null) {
                    resolve("Device Disconnected");
                }
            }.bindenv(this));
        }.bindenv(this))
    }

    // Tests that an event handler can be unsubscribed from an event
    function test4_On() {

        usbHost = USB.Host(hardware.usb);

        return Promise(function(resolve, reject) {

            // Assert there are no event listeners registered
            assertEqual(0, usbHost._customEventHandlers.len())

            // Register two event handlers
            usbHost.on("connected", function() {

            });
            usbHost.on("disconnected", function() {

            });

            // assert there are 2 currently registered event handlers
            assertTrue(usbHost._customEventHandlers.len() == 2);

            resolve()

        }.bindenv(this))
    }

    // Tests that an event handler can be unsubscribed from an event
    function test5_Off() {

        usbHost = USB.Host(hardware.usb);

        return Promise(function(resolve, reject) {

            // Assert there are no event listeners registered
            assertEqual(0, usbHost._customEventHandlers.len())

            // Register two event handlers
            usbHost.on("connected", function() {

            });
            usbHost.on("disconnected", function() {

            });

            // assert there are 2 currently registered event handlers
            assertTrue(usbHost._customEventHandlers.len() == 2);

            // unregister both registered event handlers
            usbHost.off("connected");
            usbHost.off("disconnected");

            // Assert there are no event listeners registered
            assertEqual(0, usbHost._customEventHandlers.len())
            resolve()

        }.bindenv(this))
    }

    function test6_UsbAutoConf() {

        local host = USB.Host(hardware.usb, false);
        local host2 = USB.Host(hardware.usb, true);
        // Assert _autoConfiguredPins is false
        assertTrue(!host._autoConfiguredPins);
        // Assert _autoConfiguredPins is true
        assertTrue(host2._autoConfiguredPins);
        return;
    }

    function tearDown() {
        return "Test finished";
    }
}
