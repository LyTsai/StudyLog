import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';

class HelloWorld extends Component {
    render() {
        return (
                <View style={styles.container}>
                <Text style={styles.welcome}>
                HelloWorld !!
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
                                 fontSize: 25,
                                 textAlign: 'center'
                                 }
                                 });

AppRegistry.registerComponent('demo', () => HelloWorld);
