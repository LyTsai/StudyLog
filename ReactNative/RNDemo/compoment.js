import React from 'react';
import { Text，  } from 'react-native';

const Cat = (props) => {
  return (
    <Text>Hello, I am {props.name} !</Text>
  );
}
const Cafe = () => {
  return (
    <Cat name="Maru" />
  )
}

export default Cat;


