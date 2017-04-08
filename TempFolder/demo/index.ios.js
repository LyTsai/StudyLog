import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, View, Image } from 'react-native';

class HelloWorld extends Component {
    render() {
        let pic = {uri: 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'};
        
        return (
                <View style={styles.container}>
                <Text style={styles.welcome}>
                HelloWorld!!
                </Text>
                <Image source={pic} style={{width: 190, height: 100}}/>
                <Text style = {[styles.welcome, styles.blue]}>
                red, then blue
                </Text>
                </View>
                );
    }
}


const styles = StyleSheet.create({
                                 container: {
                                 flex: 1,
                                 justifyContent: 'center',
                                 alignItems: 'center'
                                 },
                                 welcome: {
                                 fontSize: 12,
                                 color: 'red',
                                 fontWeight: '900',
                                 textAlign: 'center'
                                 },
                                 blue: {
                                 color: 'blue',
                                 fontWeight: 'bold',
                                 fontSize: 34
                                 }
                                 });

AppRegistry.registerComponent('demo', () => HelloWorld);

