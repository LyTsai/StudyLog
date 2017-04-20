import React, { Component } from 'react';
import { AppRegistry, Image } from 'react-native';

class Hello extends Component {
    render() {
        let pic = {
        url: '/Users/imac/Documents/ANBook_iOS_Version_666/ABook/ABook_Images/BrainAge/BAQ_A.png'
        };
        return (
                <Image source = {pic} style = {{width: 130, height: 130}}/>
                
        );
    }
}
AppRegistry.registerComponent('demo', () => Hello);

