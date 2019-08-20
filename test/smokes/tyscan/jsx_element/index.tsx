import React from 'react';

interface France {
  readonly language: string
}

export default class App extends React.Component<France> {
  const console = "hello"

  render() {
    return (
      <div id={console}>Hello world.</div>
    );
  }
}
